import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Simulation Service Tests', () {
    late physics.Simulation simulation;

    setUp(() {
      simulation = physics.Simulation();
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
  });
}
