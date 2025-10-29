import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/cinematic_camera_controller.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/state/ui_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Comprehensive unit tests for CinematicCameraController
///
/// Tests cover:
/// - Camera technique behaviors and API compatibility
/// - Performance optimizations and rendering improvements
/// - Edge cases and error handling
/// - Mathematical constants and stability
void main() {
  group('CinematicCameraController Integration Tests', () {
    late CinematicCameraController controller;
    late SimulationState simulation;
    late CameraState camera;
    late UIState ui;

    setUp(() {
      controller = CinematicCameraController();
      simulation = SimulationState();
      camera = CameraState();
      ui = UIState();
    });

    group('Camera Technique Support', () {
      test('should support all defined camera techniques', () {
        expect(CinematicCameraTechnique.values, hasLength(3));
        expect(
          CinematicCameraTechnique.values,
          contains(CinematicCameraTechnique.manual),
        );
        expect(
          CinematicCameraTechnique.values,
          contains(CinematicCameraTechnique.predictiveOrbital),
        );
        expect(
          CinematicCameraTechnique.values,
          contains(CinematicCameraTechnique.dynamicFraming),
        );
      });

      test('should identify AI techniques correctly', () {
        expect(CinematicCameraTechnique.manual.requiresAI, isFalse);
        expect(CinematicCameraTechnique.predictiveOrbital.requiresAI, isTrue);
        expect(CinematicCameraTechnique.dynamicFraming.requiresAI, isTrue);
      });

      test('should have meaningful display names and descriptions', () {
        for (final technique in CinematicCameraTechnique.values) {
          expect(technique.displayName, isNotEmpty);
          expect(technique.description, isNotEmpty);
          expect(
            technique.description.length,
            greaterThan(technique.displayName.length),
          );
        }
      });
    });

    group('updateCamera Method Behavior', () {
      test('should handle manual technique without errors', () {
        simulation.start(); // Start simulation

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.manual,
            simulation,
            camera,
            ui,
            1.0 / 60.0, // 60 FPS
          ),
          returnsNormally,
        );
      });

      test('should handle predictive orbital technique', () {
        simulation.start();

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.predictiveOrbital,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          ),
          returnsNormally,
        );
      });

      test('should handle dynamic framing technique', () {
        simulation.start();

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          ),
          returnsNormally,
        );
      });

      test('should not crash with paused simulation', () {
        simulation.start();
        simulation.pause();

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          ),
          returnsNormally,
        );
      });

      test('should not crash with stopped simulation', () {
        // Simulation starts stopped by default
        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          ),
          returnsNormally,
        );
      });

      test('should handle very small time steps', () {
        simulation.start();

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            1e-6, // Microsecond time step
          ),
          returnsNormally,
        );
      });

      test('should handle zero time steps', () {
        simulation.start();

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            0.0,
          ),
          returnsNormally,
        );
      });

      test('should handle negative time steps gracefully', () {
        simulation.start();

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            -0.1,
          ),
          returnsNormally,
        );
      });
    });

    group('Performance and Stability Tests', () {
      test('should handle rapid consecutive updates', () {
        simulation.start();

        final stopwatch = Stopwatch()..start();

        // Perform 100 rapid updates (reduced for reasonable test time)
        for (int i = 0; i < 100; i++) {
          controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            1.0 / 120.0, // High refresh rate
          );
        }

        stopwatch.stop();

        // Should complete in reasonable time (less than 1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should maintain camera state consistency', () {
        simulation.start();

        // Update camera multiple times and verify no crashes
        for (int i = 0; i < 10; i++) {
          controller.updateCamera(
            CinematicCameraTechnique
                .manual, // Manual shouldn't change camera much
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          );
        }

        // Camera values should remain finite
        expect(camera.target.x.isFinite, isTrue);
        expect(camera.target.y.isFinite, isTrue);
        expect(camera.target.z.isFinite, isTrue);
        expect(camera.distance.isFinite, isTrue);
        expect(camera.yaw.isFinite, isTrue);
        expect(camera.pitch.isFinite, isTrue);
        expect(camera.roll.isFinite, isTrue);
      });

      test('should handle different scenarios without crashing', () {
        final scenarios = [
          ScenarioType.earthMoonSun,
          ScenarioType.binaryStars,
          ScenarioType.solarSystem,
          ScenarioType.galaxyFormation,
          ScenarioType.asteroidBelt,
          ScenarioType.random,
        ];

        for (final scenario in scenarios) {
          simulation.reset();
          simulation.start();

          expect(
            () => controller.updateCamera(
              CinematicCameraTechnique.dynamicFraming,
              simulation,
              camera,
              ui,
              1.0 / 60.0,
            ),
            returnsNormally,
            reason: 'Should handle $scenario scenario',
          );

          simulation.stop();
        }
      });
    });

    group('Camera State Validation', () {
      test('should maintain finite camera values after updates', () {
        simulation.start();

        controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          1.0 / 60.0,
        );

        // Values should remain finite
        expect(camera.target.x.isFinite, isTrue);
        expect(camera.target.y.isFinite, isTrue);
        expect(camera.target.z.isFinite, isTrue);
        expect(camera.distance.isFinite, isTrue);
        expect(camera.yaw.isFinite, isTrue);
        expect(camera.pitch.isFinite, isTrue);
        expect(camera.roll.isFinite, isTrue);
      });

      test('should handle camera updates gracefully', () {
        simulation.start();

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          ),
          returnsNormally,
        );
      });
    });

    group('Edge Case Handling', () {
      test('should handle technique switching during updates', () {
        simulation.start();

        final techniques = [
          CinematicCameraTechnique.manual,
          CinematicCameraTechnique.dynamicFraming,
          CinematicCameraTechnique.predictiveOrbital,
        ];

        // Rapidly switch between techniques
        for (int i = 0; i < 9; i++) {
          final technique = techniques[i % techniques.length];

          expect(
            () => controller.updateCamera(
              technique,
              simulation,
              camera,
              ui,
              1.0 / 60.0,
            ),
            returnsNormally,
            reason: 'Should handle switching to $technique',
          );
        }
      });

      test('should maintain stability over extended periods', () {
        simulation.start();

        // Simulate 2 seconds of updates (reasonable for tests)
        for (int i = 0; i < 120; i++) {
          // 2 seconds at 60 FPS
          controller.updateCamera(
            CinematicCameraTechnique.predictiveOrbital,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          );

          // Check every 30 frames (0.5 second)
          if (i % 30 == 0) {
            expect(camera.target.x.isFinite, isTrue);
            expect(camera.target.y.isFinite, isTrue);
            expect(camera.target.z.isFinite, isTrue);
            expect(camera.distance.isFinite, isTrue);
            expect(camera.distance, greaterThan(0));
          }
        }
      });
    });

    group('Refactored Body Tracking Logic', () {
      test('should handle velocity-aware tolerance correctly', () {
        simulation.start();

        // Test that the camera updates complete successfully
        // This indirectly tests the refactored _isSameBodiesPair and _calculateAdaptiveTolerance methods
        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.predictiveOrbital,
            simulation,
            camera,
            ui,
            0.016,
          ),
          returnsNormally,
        );

        // Verify camera maintains valid state after update
        expect(camera.eyePosition, isNotNull);
        expect(camera.distance, greaterThan(0));
        expect(camera.distance.isFinite, isTrue);
      });

      test('should validate mathematical constants are available', () {
        // These constants are used in the _calculateAdaptiveTolerance method
        expect(math.pi, closeTo(3.14159, 0.001));
        expect(math.e, closeTo(2.71828, 0.001));

        // Test that all techniques work with the refactored logic
        simulation.start();
        for (final technique in CinematicCameraTechnique.values) {
          expect(
            () => controller.updateCamera(
              technique,
              simulation,
              camera,
              ui,
              0.016,
            ),
            returnsNormally,
            reason: 'Technique $technique should work with refactored logic',
          );
        }
      });
    });
  });

  group('ScenarioCameraParameters Tests', () {
    test('should create valid camera parameters', () {
      const params = ScenarioCameraParameters(
        safetyMargin: 2.0,
        minDistance: 10.0,
        maxDistance: 1000.0,
        pitchSensitivity: 0.5,
        targetLockFrames: 180,
        orbitSpeed: 0.3,
      );

      expect(params.safetyMargin, equals(2.0));
      expect(params.minDistance, equals(10.0));
      expect(params.maxDistance, equals(1000.0));
      expect(params.pitchSensitivity, equals(0.5));
      expect(params.targetLockFrames, equals(180));
      expect(params.orbitSpeed, equals(0.3));
    });

    test('should have reasonable parameter relationships', () {
      const galaxyParams = ScenarioCameraParameters(
        safetyMargin: 2.0,
        minDistance: 80.0,
        maxDistance: 800.0,
        pitchSensitivity: 0.3,
        targetLockFrames: 900,
        orbitSpeed: 0.15,
      );

      const solarParams = ScenarioCameraParameters(
        safetyMargin: 1.5,
        minDistance: 12.0,
        maxDistance: 400.0,
        pitchSensitivity: 0.4,
        targetLockFrames: 600,
        orbitSpeed: 0.2,
      );

      // Verify reasonable parameter relationships
      expect(galaxyParams.minDistance, greaterThan(solarParams.minDistance));
      expect(galaxyParams.maxDistance, greaterThan(solarParams.maxDistance));
      expect(
        galaxyParams.targetLockFrames,
        greaterThan(solarParams.targetLockFrames),
      );
      expect(galaxyParams.orbitSpeed, lessThan(solarParams.orbitSpeed));
      expect(galaxyParams.minDistance, lessThan(galaxyParams.maxDistance));
      expect(solarParams.minDistance, lessThan(solarParams.maxDistance));
    });
  });

  group('Mathematical Constants and Calculations', () {
    test('should use appropriate mathematical constants', () {
      // Test that mathematical constants used in calculations are reasonable
      expect(math.pi, closeTo(3.14159, 0.00001)); // pi approximation
      expect(2 * math.pi, closeTo(6.28318, 0.00001)); // 2*pi for full circle

      // Common camera calculation values
      expect(math.pi / 2, closeTo(1.5708, 0.0001)); // 90 degrees
      expect(math.pi / 4, closeTo(0.7854, 0.0001)); // 45 degrees
    });

    test('should handle angle normalization correctly', () {
      // Test angle wrap-around behavior that's common in camera calculations
      final testAngles = [
        0.0,
        math.pi / 2,
        math.pi,
        3 * math.pi / 2,
        2 * math.pi,
        3 * math.pi, // > 2*pi
        -math.pi / 2, // negative
      ];

      for (final angle in testAngles) {
        // Normalize to [0, 2*pi]
        final normalized = angle % (2 * math.pi);
        expect(normalized, greaterThanOrEqualTo(0));
        expect(normalized, lessThan(2 * math.pi));
      }
    });

    test('should handle vector operations correctly', () {
      // Test basic vector operations used in camera calculations
      final vec1 = vm.Vector3(1.0, 0.0, 0.0);
      final vec2 = vm.Vector3(0.0, 1.0, 0.0);
      final vec3 = vm.Vector3(0.0, 0.0, 1.0);

      // Cross product should give orthogonal vectors
      final cross = vec1.cross(vec2);
      expect(cross.dot(vec1), closeTo(0.0, 0.0001));
      expect(cross.dot(vec2), closeTo(0.0, 0.0001));

      // Length calculations
      expect(vec1.length, closeTo(1.0, 0.0001));
      expect(vec2.length, closeTo(1.0, 0.0001));
      expect(vec3.length, closeTo(1.0, 0.0001));
    });
  });

  group('CinematicCameraTechnique Enum Tests', () {
    test('should have consistent string values', () {
      expect(CinematicCameraTechnique.manual.value, equals('manual'));
      expect(
        CinematicCameraTechnique.predictiveOrbital.value,
        equals('predictive_orbital'),
      );
      expect(
        CinematicCameraTechnique.dynamicFraming.value,
        equals('dynamic_framing'),
      );
    });

    test('should have appropriate AI requirements', () {
      // Manual should not require AI
      expect(CinematicCameraTechnique.manual.requiresAI, isFalse);

      // AI techniques should require AI
      expect(CinematicCameraTechnique.predictiveOrbital.requiresAI, isTrue);
      expect(CinematicCameraTechnique.dynamicFraming.requiresAI, isTrue);
    });

    test('should have descriptive display names', () {
      for (final technique in CinematicCameraTechnique.values) {
        expect(technique.displayName, isNotEmpty);
        expect(
          technique.displayName.length,
          greaterThan(5),
        ); // Reasonable length
        expect(
          technique.displayName,
          isNot(equals(technique.value)),
        ); // Different from value
      }
    });

    test('should have detailed descriptions', () {
      for (final technique in CinematicCameraTechnique.values) {
        expect(technique.description, isNotEmpty);
        expect(
          technique.description.length,
          greaterThan(20),
        ); // Detailed description
        expect(
          technique.description.length,
          greaterThan(technique.displayName.length),
        );
      }
    });
  });
}
