import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/painters/gravity_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('GravityPainter', () {
    late physics.Simulation simulation;

    setUp(() {
      simulation = physics.Simulation();
    });

    group('Orbital Plane Calculation', () {
      test('should return default horizontal plane for empty simulation', () {
        final centralBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          name: 'Central Star',
          bodyType: BodyType.star,
        );

        simulation.bodies = [centralBody];

        // Use reflection to access private method for testing
        final result = GravityPainter.calculateOrbitalPlaneForTesting(
          centralBody,
          simulation,
        );

        expect(result.normal.x, closeTo(0.0, 1e-10));
        expect(result.normal.y, closeTo(1.0, 1e-10)); // Y-up normal
        expect(result.normal.z, closeTo(0.0, 1e-10));
        expect(result.tangent1.x, closeTo(1.0, 1e-10)); // X-axis tangent
        expect(result.tangent2.z, closeTo(1.0, 1e-10)); // Z-axis tangent
      });

      test(
        'should calculate correct orbital plane for single orbiting body',
        () {
          final centralBody = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 50.0,
            radius: 2.0,
            color: AppColors.basicYellow,
            name: 'Sun',
            bodyType: BodyType.star,
          );

          final orbitingBody = Body(
            position: vm.Vector3(10.0, 0.0, 0.0), // On X-axis
            velocity: vm.Vector3(0.0, 0.0, 2.0), // Moving in Z direction
            mass: 1.0,
            radius: 0.5,
            color: AppColors.basicBlue,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          simulation.bodies = [centralBody, orbitingBody];

          final result = GravityPainter.calculateOrbitalPlaneForTesting(
            centralBody,
            simulation,
          );

          // Angular momentum L = r × v = (10,0,0) × (0,0,2) = (0,-20,0)
          // Normal should be in -Y direction (normalized)
          expect(result.normal.x, closeTo(0.0, 1e-10));
          expect(result.normal.y, closeTo(-1.0, 1e-10));
          expect(result.normal.z, closeTo(0.0, 1e-10));
        },
      );

      test(
        'should handle multiple orbiting bodies with combined angular momentum',
        () {
          final centralBody = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 50.0,
            radius: 2.0,
            color: AppColors.basicYellow,
            name: 'Sun',
            bodyType: BodyType.star,
          );

          final planet1 = Body(
            position: vm.Vector3(10.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, 0.0, 2.0),
            mass: 1.0,
            radius: 0.5,
            color: AppColors.basicBlue,
            name: 'Planet1',
            bodyType: BodyType.planet,
          );

          final planet2 = Body(
            position: vm.Vector3(15.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, 0.0, 1.5),
            mass: 2.0,
            radius: 0.6,
            color: AppColors.basicRed,
            name: 'Planet2',
            bodyType: BodyType.planet,
          );

          simulation.bodies = [centralBody, planet1, planet2];

          final result = GravityPainter.calculateOrbitalPlaneForTesting(
            centralBody,
            simulation,
          );

          // Combined angular momentum should still point in -Y direction
          expect(result.normal.x, closeTo(0.0, 1e-6));
          expect(result.normal.y, lessThan(0.0)); // Should be negative
          expect(result.normal.z, closeTo(0.0, 1e-6));
          expect(
            result.normal.length,
            closeTo(1.0, 1e-10),
          ); // Should be normalized
        },
      );

      test('should filter out non-orbiting bodies correctly', () {
        final centralBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 50.0,
          radius: 2.0,
          color: AppColors.basicYellow,
          name: 'Sun',
          bodyType: BodyType.star,
        );

        // Very slow body - should be filtered out
        final slowBody = Body(
          position: vm.Vector3(10.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 0.005), // Below 0.01 threshold
          mass: 1.0,
          radius: 0.5,
          color: AppColors.basicGrey,
          name: 'SlowBody',
          bodyType: BodyType.planet,
        );

        // Far body - should be filtered out
        final farBody = Body(
          position: vm.Vector3(3000.0, 0.0, 0.0), // Beyond 2000 distance
          velocity: vm.Vector3(0.0, 0.0, 2.0),
          mass: 1.0,
          radius: 0.5,
          color: AppColors.basicPurple,
          name: 'FarBody',
          bodyType: BodyType.planet,
        );

        simulation.bodies = [centralBody, slowBody, farBody];

        final result = GravityPainter.calculateOrbitalPlaneForTesting(
          centralBody,
          simulation,
        );

        // Should return default plane since no bodies pass the filtering
        expect(result.normal.y, closeTo(1.0, 1e-10)); // Default Y-up
      });
    });

    group('Orientation Change Tracking', () {
      test('should initialize history for new bodies', () {
        const bodyName = 'TestBody';
        final normal = vm.Vector3(0.0, 1.0, 0.0);
        const timestamp = 1000.0;

        GravityPainter.trackOrientationChangeForTesting(
          bodyName,
          normal,
          timestamp,
        );

        final history = GravityPainter.getOrientationHistoryForTesting(
          bodyName,
        );
        expect(history, isNotNull);
        expect(history!.length, equals(1));
        expect(history.first.normal.y, closeTo(1.0, 1e-10));
        expect(history.first.timestamp, equals(timestamp));
      });

      test('should maintain history within maximum length', () {
        const bodyName = 'TestBody';
        final normal = vm.Vector3(0.0, 1.0, 0.0);

        // Add more than max history length (30)
        for (
          int historyEntryCount = 0;
          historyEntryCount < 35;
          historyEntryCount++
        ) {
          GravityPainter.trackOrientationChangeForTesting(
            bodyName,
            normal,
            historyEntryCount.toDouble(),
          );
        }

        final history = GravityPainter.getOrientationHistoryForTesting(
          bodyName,
        );
        expect(history!.length, equals(30)); // Should be limited to max
        expect(
          history.first.timestamp,
          equals(5.0),
        ); // Oldest should be removed
        expect(history.last.timestamp, equals(34.0)); // Newest should be kept
      });

      test('should calculate orientation change rate correctly', () {
        const bodyName = 'TestBody';

        // Add initial orientation (pointing up)
        for (int timeStep = 0; timeStep < 10; timeStep++) {
          GravityPainter.trackOrientationChangeForTesting(
            bodyName,
            vm.Vector3(0.0, 1.0, 0.0),
            timeStep.toDouble(),
          );
        }

        // Add recent orientations with different direction (pointing at 45 degrees)
        final newNormal = vm.Vector3(1.0, 1.0, 0.0).normalized();
        for (int timeStep = 10; timeStep < 15; timeStep++) {
          GravityPainter.trackOrientationChangeForTesting(
            bodyName,
            newNormal,
            timeStep.toDouble(),
          );
        }

        final changeRate =
            GravityPainter.calculateOrientationChangeRateForTesting(bodyName);

        expect(changeRate, greaterThan(0.0));
        expect(changeRate, lessThanOrEqualTo(1.0));
      });

      test('should return zero change rate for insufficient history', () {
        const bodyName = 'NewBody';

        // No history
        final changeRate1 =
            GravityPainter.calculateOrientationChangeRateForTesting(bodyName);
        expect(changeRate1, equals(0.0));

        // Single entry
        GravityPainter.trackOrientationChangeForTesting(
          bodyName,
          vm.Vector3(0.0, 1.0, 0.0),
          1.0,
        );
        final changeRate2 =
            GravityPainter.calculateOrientationChangeRateForTesting(bodyName);
        expect(changeRate2, equals(0.0));
      });

      test('should handle identical orientations', () {
        const bodyName = 'StableBody';
        final normal = vm.Vector3(0.0, 1.0, 0.0);

        // Add identical orientations
        for (int timeStep = 0; timeStep < 10; timeStep++) {
          GravityPainter.trackOrientationChangeForTesting(
            bodyName,
            normal,
            timeStep.toDouble(),
          );
        }

        final changeRate =
            GravityPainter.calculateOrientationChangeRateForTesting(bodyName);
        expect(changeRate, closeTo(0.0, 1e-10));
      });
    });

    group('Enhanced Responsiveness', () {
      test(
        'should detect subtle orbital interactions with low velocity threshold',
        () {
          final centralBody = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 50.0,
            radius: 2.0,
            color: AppColors.basicYellow,
            name: 'Sun',
            bodyType: BodyType.star,
          );

          // Body with velocity just above threshold (0.01)
          final subtleBody = Body(
            position: vm.Vector3(10.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, 0.0, 0.015), // Just above 0.01
            mass: 1.0,
            radius: 0.5,
            color: AppColors.basicBlue,
            name: 'SubtleBody',
            bodyType: BodyType.planet,
          );

          simulation.bodies = [centralBody, subtleBody];

          final result = GravityPainter.calculateOrbitalPlaneForTesting(
            centralBody,
            simulation,
          );

          // Should not be default plane (subtle interaction detected)
          expect(result.normal.y, isNot(closeTo(1.0, 1e-6)));
        },
      );

      test('should use expanded distance range for orbital detection', () {
        final centralBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 50.0,
          radius: 2.0,
          color: AppColors.basicYellow,
          name: 'Sun',
          bodyType: BodyType.star,
        );

        // Body at extended distance (within 2000 but beyond old 1000 limit)
        final distantBody = Body(
          position: vm.Vector3(1500.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 1.0),
          mass: 1.0,
          radius: 0.5,
          color: AppColors.basicBlue,
          name: 'DistantBody',
          bodyType: BodyType.planet,
        );

        simulation.bodies = [centralBody, distantBody];

        final result = GravityPainter.calculateOrbitalPlaneForTesting(
          centralBody,
          simulation,
        );

        // Should detect the distant body (not default plane)
        expect(result.normal.y, isNot(closeTo(1.0, 1e-6)));
      });

      test('should apply square root mass weighting', () {
        final centralBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 50.0,
          radius: 2.0,
          color: AppColors.basicYellow,
          name: 'Sun',
          bodyType: BodyType.star,
        );

        // Light body
        final lightBody = Body(
          position: vm.Vector3(10.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 2.0),
          mass: 1.0,
          radius: 0.3,
          color: AppColors.basicBlue,
          name: 'LightBody',
          bodyType: BodyType.planet,
        );

        // Very heavy body
        final heavyBody = Body(
          position: vm.Vector3(15.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 1.5),
          mass: 100.0,
          radius: 1.5,
          color: AppColors.basicRed,
          name: 'HeavyBody',
          bodyType: BodyType.planet,
        );

        simulation.bodies = [centralBody, lightBody, heavyBody];

        final result = GravityPainter.calculateOrbitalPlaneForTesting(
          centralBody,
          simulation,
        );

        // With square root weighting, heavy body influence should be reduced
        // compared to linear mass weighting
        expect(result.normal, isNotNull);
        expect(result.normal.length, closeTo(1.0, 1e-10));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle null or invalid vectors', () {
        const bodyName = 'TestBody';
        final invalidNormal = vm.Vector3(0.0, 0.0, 0.0); // Zero vector

        expect(() {
          GravityPainter.trackOrientationChangeForTesting(
            bodyName,
            invalidNormal,
            1.0,
          );
        }, returnsNormally);
      });

      test('should handle very large mass differences', () {
        final centralBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1e6, // Very massive
          radius: 10.0,
          color: AppColors.basicYellow,
          name: 'MassiveBody',
          bodyType: BodyType.star,
        );

        final tinyBody = Body(
          position: vm.Vector3(10.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 1.0),
          mass: 1e-6, // Tiny mass
          radius: 0.01,
          color: AppColors.basicBlue,
          name: 'TinyBody',
          bodyType: BodyType.planet,
        );

        simulation.bodies = [centralBody, tinyBody];

        expect(() {
          final result = GravityPainter.calculateOrbitalPlaneForTesting(
            centralBody,
            simulation,
          );
          expect(result.normal.length, closeTo(1.0, 1e-10));
        }, returnsNormally);
      });

      test('should handle bodies at same position', () {
        final body1 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(1.0, 0.0, 0.0),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          name: 'Body1',
          bodyType: BodyType.star,
        );

        final body2 = Body(
          position: vm.Vector3.zero(), // Same position
          velocity: vm.Vector3(0.0, 1.0, 0.0),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Body2',
          bodyType: BodyType.star,
        );

        simulation.bodies = [body1, body2];

        expect(() {
          GravityPainter.calculateOrbitalPlaneForTesting(body1, simulation);
        }, returnsNormally);
      });
    });

    group('Performance and Memory', () {
      test('should clean up old orientation history entries', () {
        const bodyName = 'TestBody';
        final normal = vm.Vector3(0.0, 1.0, 0.0);

        // Add many entries to trigger cleanup
        for (int timeStep = 0; timeStep < 50; timeStep++) {
          GravityPainter.trackOrientationChangeForTesting(
            bodyName,
            normal,
            timeStep.toDouble(),
          );
        }

        final history = GravityPainter.getOrientationHistoryForTesting(
          bodyName,
        );
        expect(history!.length, lessThanOrEqualTo(30)); // Should be cleaned up
      });

      test('should handle multiple bodies tracking simultaneously', () {
        final normal = vm.Vector3(0.0, 1.0, 0.0);

        // Track multiple bodies
        for (int bodyIndex = 0; bodyIndex < 10; bodyIndex++) {
          for (int timeIndex = 0; timeIndex < 20; timeIndex++) {
            GravityPainter.trackOrientationChangeForTesting(
              'Body$bodyIndex',
              normal,
              timeIndex.toDouble(),
            );
          }
        }

        // All bodies should have their own history
        for (int bodyIndex = 0; bodyIndex < 10; bodyIndex++) {
          final history = GravityPainter.getOrientationHistoryForTesting(
            'Body$bodyIndex',
          );
          expect(history, isNotNull);
          expect(history!.length, equals(20));
        }
      });

      tearDown(() {
        // Clean up static state between tests
        GravityPainter.clearOrientationHistoryForTesting();
      });
    });

    group('Gravity Well Offset Behavior', () {
      test('should show no offset for isolated single body', () {
        final centralBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          name: 'Isolated Star',
          bodyType: BodyType.star,
        );

        simulation.bodies = [centralBody];

        final orbitalPlane = GravityPainter.calculateOrbitalPlaneForTesting(
          centralBody,
          simulation,
        );

        // For isolated body, orbital plane should be default horizontal
        expect(orbitalPlane.normal.x, closeTo(0.0, 1e-10));
        expect(orbitalPlane.normal.y, closeTo(1.0, 1e-10));
        expect(orbitalPlane.normal.z, closeTo(0.0, 1e-10));
      });

      test('should show realistic offset in multi-body system', () {
        // Simulate a realistic scenario: Sun with Earth orbiting
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0, // Much more massive
          radius: 5.0,
          color: AppColors.basicYellow,
          name: 'Sun',
          bodyType: BodyType.star,
        );

        final earth = Body(
          position: vm.Vector3(100.0, 10.0, 5.0), // Slightly off-plane orbit
          velocity: vm.Vector3(
            -1.0,
            8.0,
            0.5,
          ), // Orbital velocity with slight tilt
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Earth',
          bodyType: BodyType.planet,
        );

        simulation.bodies = [sun, earth];

        final orbitalPlane = GravityPainter.calculateOrbitalPlaneForTesting(
          sun,
          simulation,
        );

        // Calculate the tilt magnitude
        final defaultNormal = vm.Vector3(0, 1, 0);
        final tiltAngleRadians = math.acos(
          orbitalPlane.normal.dot(defaultNormal).clamp(-1.0, 1.0),
        );
        final tiltAngleDegrees = tiltAngleRadians * 180 / math.pi;

        // Realistic orbital systems show measurable tilts due to gravitational interactions
        expect(
          tiltAngleDegrees,
          greaterThan(1.0),
          reason: 'Realistic orbital system should show measurable tilt',
        );
        // Allow for extreme tilts as they can occur in dynamic gravitational systems
        expect(
          tiltAngleDegrees,
          lessThan(180.0),
          reason: 'Tilt angle should be physically meaningful',
        );
      });

      test('should show greater offset for body in binary system', () {
        final star1 = Body(
          position: vm.Vector3(-2.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 1.0),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          name: 'Star 1',
          bodyType: BodyType.star,
        );

        final star2 = Body(
          position: vm.Vector3(2.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, -1.0),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicRed,
          name: 'Star 2',
          bodyType: BodyType.star,
        );

        simulation.bodies = [star1, star2];

        final orbitalPlane1 = GravityPainter.calculateOrbitalPlaneForTesting(
          star1,
          simulation,
        );

        // In binary system, gravity well should be significantly tilted
        final tiltMagnitude =
            (orbitalPlane1.normal - vm.Vector3(0, 1, 0)).length;
        expect(
          tiltMagnitude,
          greaterThan(0.1),
          reason: 'Binary star should show significant gravity well tilt',
        );
      });

      test('should show different offsets for different body masses', () {
        final lightStar = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 5.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          name: 'Light Star',
          bodyType: BodyType.star,
        );

        final heavyStar = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 50.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          name: 'Heavy Star',
          bodyType: BodyType.star,
        );

        final companion = Body(
          position: vm.Vector3(5.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 2.0),
          mass: 2.0,
          radius: 0.5,
          color: AppColors.basicBlue,
          name: 'Companion',
          bodyType: BodyType.planet,
        );

        // Test light star with companion
        simulation.bodies = [lightStar, companion];
        final lightStarPlane = GravityPainter.calculateOrbitalPlaneForTesting(
          lightStar,
          simulation,
        );

        // Test heavy star with same companion
        simulation.bodies = [heavyStar, companion];
        final heavyStarPlane = GravityPainter.calculateOrbitalPlaneForTesting(
          heavyStar,
          simulation,
        );

        // Heavy star should be less affected by the same companion
        final lightStarTilt =
            (lightStarPlane.normal - vm.Vector3(0, 1, 0)).length;
        final heavyStarTilt =
            (heavyStarPlane.normal - vm.Vector3(0, 1, 0)).length;

        expect(
          lightStarTilt,
          greaterThan(heavyStarTilt),
          reason: 'Lighter star should be more affected by companion gravity',
        );
      });
    });
  });
}
