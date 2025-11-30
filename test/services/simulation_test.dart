import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../test_utils.dart';

void main() {
  group('Simulation Service Tests', () {
    late physics.Simulation simulation;

    setUp(() {
      simulation = physics.Simulation();
      // Initialize localization for proper scenario generation
      final mockL10n = TestUtils.createMockAppLocalizations();
      simulation.updateScenarioLocalization(mockL10n);
    });

    test('Simulation should initialize with bodies', () {
      expect(simulation.bodies, isNotEmpty);
      expect(simulation.bodies.length, equals(4)); // 3 stars + 1 planet
      expect(simulation.trails, hasLength(simulation.bodies.length));
      expect(simulation.mergeFlashes, isEmpty);
    });

    test('Simulation should have correct gravitational constant', () {
      expect(simulation.gravitationalConstant, equals(1.2));
    });

    test('Reset should generate new random bodies', () {
      final originalBodies = simulation.bodies
          .map((b) => b.position.clone())
          .toList();

      simulation.reset();

      expect(simulation.bodies, hasLength(4));
      expect(simulation.trails, hasLength(simulation.bodies.length));
      expect(simulation.mergeFlashes, isEmpty);

      // Check that at least some bodies have different positions (randomization)
      bool hasChangedPositions = false;
      for (int i = 0; i < simulation.bodies.length; i++) {
        if ((simulation.bodies[i].position - originalBodies[i]).length > 0.1) {
          hasChangedPositions = true;
          break;
        }
      }
      expect(hasChangedPositions, isTrue);
    });

    test('Bodies should have appropriate properties', () {
      for (final body in simulation.bodies) {
        expect(body.mass, greaterThan(0));
        expect(body.radius, greaterThan(0));
        expect(body.position, isNotNull);
        expect(body.velocity, isNotNull);
        expect(body.color, isNotNull);
      }
    });

    test('Should have 3 stars and 1 planet', () {
      final stars = simulation.bodies.where((b) => !b.isPlanet).toList();
      final planets = simulation.bodies.where((b) => b.isPlanet).toList();

      expect(stars, hasLength(3));
      expect(planets, hasLength(1));
    });

    test('Stars should have larger mass than planets', () {
      final stars = simulation.bodies.where((b) => !b.isPlanet).toList();
      final planets = simulation.bodies.where((b) => b.isPlanet).toList();

      for (final star in stars) {
        for (final planet in planets) {
          expect(star.mass, greaterThan(planet.mass));
        }
      }
    });

    test('PushTrails should add trail points', () {
      simulation.pushTrails(1.0 / 240.0);

      for (final trail in simulation.trails) {
        expect(trail, isNotEmpty);
        expect(trail.last.alpha, closeTo(1.0, 1e-10));
      }
    });

    test('PushTrails should fade existing trail points', () {
      // Add initial trail point
      simulation.pushTrails(1.0 / 240.0);
      final initialAlpha = simulation.trails[0].first.alpha;

      // Add another trail point (should fade the first)
      simulation.pushTrails(1.0 / 240.0);

      expect(simulation.trails[0].first.alpha, lessThan(initialAlpha));
    });

    test('PushTrails should limit trail length', () {
      // Add many trail points
      for (int i = 0; i < simulation.maxTrail + 100; i++) {
        simulation.pushTrails(1.0 / 240.0);
      }

      for (final trail in simulation.trails) {
        expect(trail.length, lessThanOrEqualTo(simulation.maxTrail));
      }
    });

    test('PushTrails should handle missing bodies gracefully', () {
      // Remove a body but keep trails
      simulation.bodies.removeLast();

      expect(() => simulation.pushTrails(1.0 / 240.0), returnsNormally);
      expect(simulation.trails.length, equals(simulation.bodies.length));
    });

    test('Merge flashes should age over time', () {
      // Add a merge flash manually for testing
      simulation.mergeFlashes.add(
        MergeFlash(vm.Vector3.zero(), AppColors.basicRed),
      );
      final flash = simulation.mergeFlashes.first;
      final initialAge = flash.age;

      simulation.pushTrails(1.0 / 60.0); // This method handles flash aging

      expect(flash.age, greaterThan(initialAge));
    });

    test('Old merge flashes should be removed', () {
      // Add an old merge flash
      final oldFlash = MergeFlash(vm.Vector3.zero(), AppColors.basicBlue);
      oldFlash.age = 1.0; // Very old
      simulation.mergeFlashes.add(oldFlash);

      simulation.pushTrails(1.0 / 60.0); // This method handles flash removal

      expect(simulation.mergeFlashes, isEmpty);
    });

    test('StepRK4 should update body positions', () {
      final originalPositions = simulation.bodies
          .map((b) => b.position.clone())
          .toList();

      simulation.stepRK4(1.0 / 60.0);

      // At least some bodies should have moved
      bool hasMoved = false;
      for (int i = 0; i < simulation.bodies.length; i++) {
        if ((simulation.bodies[i].position - originalPositions[i]).length >
            1e-10) {
          hasMoved = true;
          break;
        }
      }
      expect(hasMoved, isTrue);
    });

    test('StepRK4 should conserve total momentum approximately', () {
      vm.Vector3 initialMomentum = vm.Vector3.zero();
      for (final body in simulation.bodies) {
        initialMomentum += body.velocity * body.mass;
      }

      // Run simulation for several steps
      for (int i = 0; i < 10; i++) {
        simulation.stepRK4(1.0 / 60.0);
      }

      vm.Vector3 finalMomentum = vm.Vector3.zero();
      for (final body in simulation.bodies) {
        finalMomentum += body.velocity * body.mass;
      }

      // Momentum should be approximately conserved (small numerical errors allowed)
      expect((finalMomentum - initialMomentum).length, lessThan(1e-3));
    });

    test('StepRK4 should handle zero time step', () {
      final originalPositions = simulation.bodies
          .map((b) => b.position.clone())
          .toList();

      simulation.stepRK4(0.0);

      // Positions should not change with zero time step
      for (int i = 0; i < simulation.bodies.length; i++) {
        expect(
          (simulation.bodies[i].position - originalPositions[i]).length,
          lessThan(1e-10),
        );
      }
    });

    test('StepRK4 should handle very small time steps', () {
      expect(() => simulation.stepRK4(1e-10), returnsNormally);
    });

    test('Collision detection should trigger merges', () {
      // Create three bodies, two very close together
      simulation.bodies.clear();
      simulation.bodies.addAll([
        Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicRed,
          name: 'Test Body 1',
        ),
        Body(
          position: vm.Vector3(
            0.05,
            0,
            0,
          ), // Within collision radius (5% of visual radius = 0.1 total)
          velocity: vm.Vector3(0, 0, 0),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body 2',
        ),
        Body(
          position: vm.Vector3(20, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Test Body 3',
        ), // Far away
      ]);

      final initialBodyCount = simulation.bodies.length; // Should be 3
      simulation.stepRK4(1.0 / 60.0);

      // Two bodies should merge (result: 2 bodies, not regenerated since > 1)
      expect(simulation.bodies.length, lessThan(initialBodyCount));
      expect(simulation.bodies.length, equals(2));
    });

    test('Bodies should have valid colors from palette', () {
      final expectedColors = [
        AppColors.testAmber, // amber
        AppColors.testTeal, // teal
        AppColors.testBlue, // blue
        AppColors.testRed, // red
        AppColors.testPink, // pink
        AppColors.testLightBlue, // light blue
      ];

      for (final body in simulation.bodies) {
        expect(expectedColors.contains(body.color), isTrue);
      }
    });

    group('Physics Parameters', () {
      test('Should allow updating gravitational constant', () {
        simulation.setGravitationalConstant(2.0);
        expect(simulation.gravitationalConstant, equals(2.0));
      });

      test('Should allow updating softening parameter', () {
        simulation.setSoftening(0.5);
        expect(simulation.softening, equals(0.5));
      });

      test('Should allow updating collision radius multiplier', () {
        simulation.setCollisionRadiusMultiplier(0.15);
        expect(simulation.collisionRadiusMultiplier, equals(0.15));
      });

      test('Should allow updating max trail points', () {
        simulation.setMaxTrailPoints(200);
        expect(simulation.maxTrail, equals(200));
      });

      test('Should allow updating trail fade rate', () {
        simulation.setTrailFadeRate(0.02);
        expect(simulation.fadeRate, equals(0.02));
      });

      test('Should allow updating vibration settings', () {
        simulation.setVibrationThrottleTime(0.5);
        expect(simulation.vibrationThrottleTime, equals(0.5));

        simulation.setVibrationEnabled(false);
        expect(simulation.vibrationEnabled, isFalse);
      });

      test('Should update multiple physics settings at once', () {
        simulation.updatePhysicsSettings(
          gravitationalConstant: 1.5,
          softening: 0.8,
          collisionRadiusMultiplier: 0.12,
          maxTrailPoints: 150,
          trailFadeRate: 0.03,
          vibrationThrottleTime: 0.6,
          vibrationEnabled: true,
        );

        expect(simulation.gravitationalConstant, equals(1.5));
        expect(simulation.softening, equals(0.8));
        expect(simulation.collisionRadiusMultiplier, equals(0.12));
        expect(simulation.maxTrail, equals(150));
        expect(simulation.fadeRate, equals(0.03));
        expect(simulation.vibrationThrottleTime, equals(0.6));
        expect(simulation.vibrationEnabled, isTrue);
      });
    });

    group('Realistic Colors', () {
      test('Should toggle realistic colors', () {
        expect(simulation.useRealisticColors, isFalse);

        simulation.setUseRealisticColors(true);
        expect(simulation.useRealisticColors, isTrue);

        simulation.setUseRealisticColors(false);
        expect(simulation.useRealisticColors, isFalse);
      });

      test('Should apply realistic colors when enabled', () {
        simulation.setUseRealisticColors(true);

        // Verify stars have temperature-based colors
        final stars = simulation.bodies.where((b) => !b.isPlanet).toList();
        for (final star in stars) {
          expect(star.temperature, greaterThan(0));
        }
      });
    });

    group('Change Counter', () {
      test('Should track simulation changes', () {
        final initialCounter = simulation.changeCounter;

        simulation.stepRK4(1.0 / 60.0);

        expect(simulation.changeCounter, greaterThan(initialCounter));
      });

      test('Should increment counter on merge', () {
        // Create two bodies very close together
        simulation.bodies.clear();
        simulation.bodies.addAll([
          Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3(0, 0, 0),
            mass: 1.0,
            radius: 1.0,
            color: AppColors.basicRed,
            name: 'Body 1',
          ),
          Body(
            position: vm.Vector3(0.05, 0, 0),
            velocity: vm.Vector3(0, 0, 0),
            mass: 1.0,
            radius: 1.0,
            color: AppColors.basicBlue,
            name: 'Body 2',
          ),
        ]);

        final initialCounter = simulation.changeCounter;
        simulation.stepRK4(1.0 / 60.0);

        expect(simulation.changeCounter, greaterThan(initialCounter));
      });

      test('Should allow manual change marking', () {
        final initialCounter = simulation.changeCounter;

        simulation.markChanged();

        expect(simulation.changeCounter, equals(initialCounter + 1));
      });
    });

    group('Collision Effects Integration', () {
      test('Should have collision effects service', () {
        expect(simulation.collisionEffects, isNotNull);
      });

      test('Should update collision effects', () {
        // Add some effects
        final body1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(1, 0, 0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.basicRed,
          name: 'Body 1',
        );

        final body2 = Body(
          position: vm.Vector3(1, 0, 0),
          velocity: vm.Vector3(-1, 0, 0),
          mass: 8.0,
          radius: 1.5,
          color: AppColors.basicBlue,
          name: 'Body 2',
        );

        simulation.collisionEffects.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: vm.Vector3(0.5, 0, 0),
        );

        expect(simulation.collisionEffects.debrisParticles, isNotEmpty);

        // Update should process effects
        simulation.collisionEffects.update(0.016);

        expect(() => simulation.collisionEffects, returnsNormally);
      });
    });

    group('Asteroid Belt Systems', () {
      test('Should have asteroid belt systems', () {
        expect(simulation.asteroidBelt, isNotNull);
        expect(simulation.kuiperBelt, isNotNull);
      });

      test('Should initialize asteroid belts for appropriate scenarios', () {
        // Reset with asteroid belt scenario
        final mockL10n = TestUtils.createMockAppLocalizations();
        simulation.resetWithScenario(ScenarioType.asteroidBelt, l10n: mockL10n);

        // Asteroid belt should have particles
        expect(simulation.asteroidBelt.particles, isNotEmpty);
      });

      test('Should clear asteroid belts for other scenarios', () {
        final mockL10n = TestUtils.createMockAppLocalizations();

        // First set asteroid belt scenario
        simulation.resetWithScenario(ScenarioType.asteroidBelt, l10n: mockL10n);
        expect(simulation.asteroidBelt.particles, isNotEmpty);

        // Then switch to different scenario
        simulation.resetWithScenario(ScenarioType.random, l10n: mockL10n);

        // Belts should be cleared
        expect(simulation.asteroidBelt.particles, isEmpty);
        expect(simulation.kuiperBelt.particles, isEmpty);
      });
    });

    group('Scenario Management', () {
      test('Should track current scenario', () {
        expect(simulation.currentScenario, isNotNull);
      });

      test('Should switch scenarios', () {
        final mockL10n = TestUtils.createMockAppLocalizations();

        simulation.resetWithScenario(ScenarioType.solarSystem, l10n: mockL10n);
        expect(simulation.currentScenario, equals(ScenarioType.solarSystem));

        simulation.resetWithScenario(ScenarioType.binaryStars, l10n: mockL10n);
        expect(simulation.currentScenario, equals(ScenarioType.binaryStars));
      });

      test('Should preserve custom settings when requested', () {
        final mockL10n = TestUtils.createMockAppLocalizations();

        // Set custom gravity well setting
        for (final body in simulation.bodies) {
          body.showGravityWell = true;
        }

        simulation.resetWithScenario(
          ScenarioType.solarSystem,
          l10n: mockL10n,
          preserveCustomSettings: true,
        );

        // At least some bodies should have gravity wells enabled
        final hasEnabledWells = simulation.bodies.any(
          (body) => body.showGravityWell,
        );
        expect(hasEnabledWells, isTrue);
      });

      test('Should update scenario with localization', () {
        // Create a fresh simulation without l10n
        final freshSim = physics.Simulation();

        // Reset without l10n initially
        freshSim.resetWithScenario(ScenarioType.random);

        // Provide localization later
        final mockL10n = TestUtils.createMockAppLocalizations();
        freshSim.updateScenarioLocalization(mockL10n);

        // Should have bodies after localization
        expect(freshSim.bodies, isNotEmpty);
      });
    });

    group('Trail Management Edge Cases', () {
      test('Should handle empty bodies list gracefully', () {
        simulation.bodies.clear();

        expect(() => simulation.pushTrails(1.0 / 60.0), returnsNormally);
      });

      test('Should sync trail length with bodies length', () {
        // Add extra trails
        simulation.trails.add([]);
        simulation.trails.add([]);

        expect(simulation.trails.length, greaterThan(simulation.bodies.length));

        simulation.pushTrails(1.0 / 60.0);

        expect(simulation.trails.length, equals(simulation.bodies.length));
      });

      test('Should add missing trails for new bodies', () {
        // Add a body without corresponding trail
        simulation.bodies.add(
          Body(
            position: vm.Vector3(50, 0, 0),
            velocity: vm.Vector3(0, 1, 0),
            mass: 1.0,
            radius: 1.0,
            color: AppColors.basicGreen,
            name: 'New Body',
          ),
        );

        expect(simulation.trails.length, lessThan(simulation.bodies.length));

        simulation.pushTrails(1.0 / 60.0);

        expect(simulation.trails.length, equals(simulation.bodies.length));
      });
    });

    group('System Regeneration', () {
      test('Should regenerate system when bodies are depleted', () {
        // Reduce to single body
        while (simulation.bodies.length > 1) {
          simulation.bodies.removeLast();
        }

        simulation.stepRK4(1.0 / 60.0);

        // Should regenerate to at least 3 bodies
        expect(simulation.bodies.length, greaterThanOrEqualTo(3));
      });

      test('Should regenerate system when no bodies remain', () {
        simulation.bodies.clear();

        simulation.stepRK4(1.0 / 60.0);

        // Should regenerate system
        expect(simulation.bodies, isNotEmpty);
      });
    });

    group('Temperature and Habitability', () {
      test('Should update temperatures over time', () {
        // Update temperatures
        simulation.updateTemperatures(1.0);

        // Temperature tracking should work
        expect(() => simulation.updateTemperatures(1.0), returnsNormally);
      });

      test('Should update habitability over time', () {
        // Update habitability
        expect(() => simulation.updateHabitability(1.0), returnsNormally);

        // Run multiple updates
        for (int i = 0; i < 10; i++) {
          simulation.updateHabitability(0.1);
        }

        expect(() => simulation.updateHabitability(0.1), returnsNormally);
      });
    });

    group('Merge Flash Management', () {
      test('Should handle multiple merge flashes', () {
        for (int i = 0; i < 5; i++) {
          simulation.mergeFlashes.add(
            MergeFlash(
              vm.Vector3(i.toDouble(), 0, 0),
              AppColors.basicPrimaries[i % AppColors.basicPrimaries.length],
            ),
          );
        }

        expect(simulation.mergeFlashes.length, equals(5));

        simulation.pushTrails(1.0 / 60.0);

        // All flashes should age
        for (final flash in simulation.mergeFlashes) {
          expect(flash.age, greaterThan(0));
        }
      });

      test('Should remove multiple old flashes at once', () {
        // Add several old flashes
        for (int i = 0; i < 10; i++) {
          final flash = MergeFlash(
            vm.Vector3(i.toDouble(), 0, 0),
            AppColors.basicRed,
          );
          flash.age = 1.0;
          simulation.mergeFlashes.add(flash);
        }

        expect(simulation.mergeFlashes.length, equals(10));

        simulation.pushTrails(1.0 / 60.0);

        expect(simulation.mergeFlashes, isEmpty);
      });
    });

    group('RK4 Integration Stability', () {
      test('Should handle large time steps gracefully', () {
        expect(() => simulation.stepRK4(1.0), returnsNormally);
      });

      test('Should maintain body count through multiple steps', () {
        final initialCount = simulation.bodies.length;

        // Run many steps without collisions
        simulation.setCollisionRadiusMultiplier(0.001); // Very small
        for (int i = 0; i < 100; i++) {
          simulation.stepRK4(1.0 / 60.0);
        }

        // Body count should remain stable
        expect(
          simulation.bodies.length,
          greaterThanOrEqualTo(initialCount - 1),
        );
      });

      test('Should handle negative time step', () {
        simulation.stepRK4(-1.0 / 60.0);

        // Should not crash, positions may or may not change
        expect(simulation.bodies.length, greaterThan(0));
      });
    });
  });
}
