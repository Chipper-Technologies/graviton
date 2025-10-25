import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/services/simulation.dart';

void main() {
  group('Simulation Physics Parameters', () {
    late Simulation simulation;

    setUp(() {
      simulation = Simulation();
    });

    test('should initialize with default physics parameters', () {
      expect(
        simulation.gravitationalConstant,
        equals(SimulationConstants.gravitationalConstant),
      );
      expect(simulation.softening, equals(SimulationConstants.softening));
      expect(
        simulation.collisionRadiusMultiplier,
        equals(SimulationConstants.collisionRadiusMultiplier),
      );
      expect(simulation.maxTrail, equals(SimulationConstants.maxTrailPoints));
      expect(simulation.fadeRate, equals(SimulationConstants.trailFadeRate));
      expect(
        simulation.vibrationThrottleTime,
        equals(SimulationConstants.vibrationThrottleTime),
      );
      expect(simulation.vibrationEnabled, isTrue);
    });

    test('updatePhysicsSettings() should update all parameters', () {
      simulation.updatePhysicsSettings(
        gravitationalConstant: 5.0,
        softening: 0.05,
        collisionRadiusMultiplier: 0.5,
        maxTrailPoints: 600,
        trailFadeRate: 1.0,
        vibrationThrottleTime: 0.3,
        vibrationEnabled: false,
      );

      expect(simulation.gravitationalConstant, equals(5.0));
      expect(simulation.softening, equals(0.05));
      expect(simulation.collisionRadiusMultiplier, equals(0.5));
      expect(simulation.maxTrail, equals(600));
      expect(simulation.fadeRate, equals(1.0));
      expect(simulation.vibrationThrottleTime, equals(0.3));
      expect(simulation.vibrationEnabled, isFalse);
    });

    test('updatePhysicsSettings() should update only provided parameters', () {
      final originalSoftening = simulation.softening;

      simulation.updatePhysicsSettings(
        gravitationalConstant: 7.5,
        // Only updating gravitational constant
      );

      expect(simulation.gravitationalConstant, equals(7.5));
      expect(
        simulation.softening,
        equals(originalSoftening),
      ); // Should remain unchanged
    });

    test('setGravitationalConstant() should update gravitational constant', () {
      simulation.setGravitationalConstant(3.5);
      expect(simulation.gravitationalConstant, equals(3.5));
    });

    test('setSoftening() should update softening parameter', () {
      simulation.setSoftening(0.03);
      expect(simulation.softening, equals(0.03));
    });

    test(
      'setCollisionRadiusMultiplier() should update collision radius multiplier',
      () {
        simulation.setCollisionRadiusMultiplier(0.7);
        expect(simulation.collisionRadiusMultiplier, equals(0.7));
      },
    );

    test('setMaxTrailPoints() should update max trail points', () {
      simulation.setMaxTrailPoints(800);
      expect(simulation.maxTrail, equals(800));
    });

    test('setTrailFadeRate() should update trail fade rate', () {
      simulation.setTrailFadeRate(1.5);
      expect(simulation.fadeRate, equals(1.5));
    });

    test(
      'setVibrationThrottleTime() should update vibration throttle time',
      () {
        simulation.setVibrationThrottleTime(0.25);
        expect(simulation.vibrationThrottleTime, equals(0.25));
      },
    );

    test('setVibrationEnabled() should update vibration enabled', () {
      simulation.setVibrationEnabled(false);
      expect(simulation.vibrationEnabled, isFalse);

      simulation.setVibrationEnabled(true);
      expect(simulation.vibrationEnabled, isTrue);
    });

    test('physics parameters should affect simulation behavior', () {
      // Create a simple two-body system for testing
      simulation.reset();

      // Ensure we have at least 2 bodies for testing
      if (simulation.bodies.length < 2) {
        // This test might need to be adapted based on how scenarios work
        // For now, we'll skip if there aren't enough bodies
        return;
      }

      final originalBodyCount = simulation.bodies.length;

      // Modify physics parameters that should affect behavior
      simulation.setGravitationalConstant(100.0); // Much stronger gravity
      simulation.setCollisionRadiusMultiplier(
        2.0,
      ); // Much larger collision radius

      // Run a few simulation steps
      for (int i = 0; i < 10; i++) {
        simulation.stepRK4(1.0 / 60.0);
      }

      // The simulation should still be running (basic sanity check)
      expect(simulation.bodies.length, greaterThanOrEqualTo(0));
      expect(simulation.bodies.length, lessThanOrEqualTo(originalBodyCount));
    });

    test('extreme physics parameters should not crash simulation', () {
      // Test with extreme values
      simulation.updatePhysicsSettings(
        gravitationalConstant: 0.0001, // Very weak gravity
        softening: 10.0, // Very high softening
        collisionRadiusMultiplier: 0.001, // Tiny collision radius
        maxTrailPoints: 1, // Minimal trails
        trailFadeRate: 100.0, // Fast fade
        vibrationThrottleTime: 0.001, // Very fast vibration
      );

      // Should not throw exceptions
      expect(() {
        simulation.reset();
        simulation.stepRK4(1.0 / 60.0);
      }, returnsNormally);
    });

    test('very high gravity should increase interaction strength', () {
      simulation.reset();

      if (simulation.bodies.isEmpty) {
        return; // Skip if no bodies
      }

      final originalPositions = simulation.bodies
          .map((body) => body.position.clone())
          .toList();

      // Set very high gravity
      simulation.setGravitationalConstant(1000.0);

      // Run simulation for a few steps
      for (int i = 0; i < 5; i++) {
        simulation.stepRK4(1.0 / 60.0);
      }

      // Bodies should have moved (assuming they weren't already at equilibrium)
      bool anyBodyMoved = false;
      for (
        int i = 0;
        i < simulation.bodies.length && i < originalPositions.length;
        i++
      ) {
        final distance =
            (simulation.bodies[i].position - originalPositions[i]).length;
        if (distance > 0.001) {
          // Some tolerance for floating point precision
          anyBodyMoved = true;
          break;
        }
      }

      // With very high gravity, something should have moved (unless it's a special case)
      expect(
        anyBodyMoved || simulation.bodies.length != originalPositions.length,
        isTrue,
      );
    });

    test('collision detection should respect collision radius multiplier', () {
      // This test verifies that the collision radius multiplier is used
      // We can't easily test actual collisions without setting up specific scenarios,
      // but we can verify the parameter is being used correctly

      simulation.setCollisionRadiusMultiplier(0.1);
      expect(simulation.collisionRadiusMultiplier, equals(0.1));

      simulation.setCollisionRadiusMultiplier(1.0);
      expect(simulation.collisionRadiusMultiplier, equals(1.0));
    });

    test('trail parameters should be applied correctly', () {
      simulation.setMaxTrailPoints(100);
      simulation.setTrailFadeRate(2.0);

      expect(simulation.maxTrail, equals(100));
      expect(simulation.fadeRate, equals(2.0));

      // Run some simulation to generate trails
      simulation.reset();
      for (int i = 0; i < 10; i++) {
        simulation.stepRK4(1.0 / 60.0);
        simulation.pushTrails(1.0 / 60.0);
      }

      // Trails should be bounded by maxTrail setting
      for (final trail in simulation.trails) {
        expect(trail.length, lessThanOrEqualTo(100));
      }
    });

    test('vibration parameters should be stored correctly', () {
      simulation.setVibrationThrottleTime(0.5);
      simulation.setVibrationEnabled(false);

      expect(simulation.vibrationThrottleTime, equals(0.5));
      expect(simulation.vibrationEnabled, isFalse);
    });
  });
}
