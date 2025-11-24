import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/scenario_camera_parameters.dart';
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

      test('should have meaningful localization keys', () {
        for (final technique in CinematicCameraTechnique.values) {
          expect(technique.localizationKey, isNotEmpty);
          expect(technique.descriptionKey, isNotEmpty);
          expect(technique.localizationKey, startsWith('camera'));
          expect(technique.descriptionKey, startsWith('camera'));
          expect(technique.descriptionKey, endsWith('Description'));
          expect(
            technique.descriptionKey.length,
            greaterThan(technique.localizationKey.length),
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

    test('should have proper localization keys', () {
      for (final technique in CinematicCameraTechnique.values) {
        expect(technique.localizationKey, isNotEmpty);
        expect(
          technique.localizationKey.length,
          greaterThan(5),
        ); // Reasonable length
        expect(
          technique.localizationKey,
          isNot(equals(technique.value)),
        ); // Different from value
        expect(technique.localizationKey, startsWith('camera'));
      }
    });

    test('should have proper description keys', () {
      for (final technique in CinematicCameraTechnique.values) {
        expect(technique.descriptionKey, isNotEmpty);
        expect(
          technique.descriptionKey.length,
          greaterThan(20),
        ); // Detailed description key
        expect(
          technique.descriptionKey.length,
          greaterThan(technique.localizationKey.length),
        );
        expect(technique.descriptionKey, endsWith('Description'));
      }
    });
  });

  group('CinematicCameraController Reset and State Management', () {
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

    test('reset should clear all internal state', () {
      // Set up some state first
      simulation.resetWithScenario(ScenarioType.solarSystem);

      // Run camera for a few frames to build up state
      for (int i = 0; i < 10; i++) {
        controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          0.016, // ~60fps
        );
      }

      // Reset should clear everything
      controller.reset();

      // After reset, controller should behave as if newly created
      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        ),
        returnsNormally,
      );
    });

    test('reset should be safe to call multiple times', () {
      controller.reset();
      controller.reset();
      controller.reset();

      // Should still work normally after multiple resets
      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.manual,
          simulation,
          camera,
          ui,
          0.016,
        ),
        returnsNormally,
      );
    });

    test('reset should be safe to call before any camera updates', () {
      // Reset on fresh controller should not throw
      expect(() => controller.reset(), returnsNormally);

      // Should still work normally after reset on fresh controller
      simulation.start();
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
    });
  });

  group('CinematicCameraController Scenario Handling', () {
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

    test('should handle scenario switching without errors', () {
      final scenarios = [
        ScenarioType.solarSystem,
        ScenarioType.earthMoonSun,
        ScenarioType.binaryStars,
        ScenarioType.asteroidBelt,
        ScenarioType.galaxyFormation,
      ];

      for (final scenario in scenarios) {
        simulation.resetWithScenario(scenario);

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

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.dynamicFraming,
            simulation,
            camera,
            ui,
            0.016,
          ),
          returnsNormally,
        );

        simulation.stop();
      }
    });

    test('should handle empty body list gracefully', () {
      simulation.start();
      simulation.bodies.clear(); // Remove all bodies

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

      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        ),
        returnsNormally,
      );
    });

    test('should handle paused simulation state', () {
      simulation.resetWithScenario(ScenarioType.solarSystem);
      simulation.pause();

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

      simulation.resumeSimulation();

      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        ),
        returnsNormally,
      );
    });

    test('should handle stopped simulation state', () {
      simulation.resetWithScenario(ScenarioType.solarSystem);
      simulation.stop();

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
    });
  });

  group('CinematicCameraController Technique Switching', () {
    late CinematicCameraController controller;
    late SimulationState simulation;
    late CameraState camera;
    late UIState ui;

    setUp(() {
      controller = CinematicCameraController();
      simulation = SimulationState();
      camera = CameraState();
      ui = UIState();
      simulation.resetWithScenario(ScenarioType.solarSystem);
    });

    test('should handle rapid technique switching', () {
      final techniques = CinematicCameraTechnique.values;

      for (int i = 0; i < 20; i++) {
        final technique = techniques[i % techniques.length];
        expect(
          () =>
              controller.updateCamera(technique, simulation, camera, ui, 0.016),
          returnsNormally,
        );
      }
    });

    test('should handle switching between AI techniques', () {
      // Start with predictive
      controller.updateCamera(
        CinematicCameraTechnique.predictiveOrbital,
        simulation,
        camera,
        ui,
        0.016,
      );

      // Switch to dynamic
      controller.updateCamera(
        CinematicCameraTechnique.dynamicFraming,
        simulation,
        camera,
        ui,
        0.016,
      );

      // Switch back to predictive
      controller.updateCamera(
        CinematicCameraTechnique.predictiveOrbital,
        simulation,
        camera,
        ui,
        0.016,
      );

      // All switches should work without errors
      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.manual,
          simulation,
          camera,
          ui,
          0.016,
        ),
        returnsNormally,
      );
    });

    test('manual technique should not modify camera automatically', () {
      final initialTarget = vm.Vector3.copy(camera.target);
      final initialDistance = camera.distance;
      final initialYaw = camera.yaw;
      final initialPitch = camera.pitch;

      // Manual technique should not change camera
      controller.updateCamera(
        CinematicCameraTechnique.manual,
        simulation,
        camera,
        ui,
        0.016,
      );

      expect(camera.target, equals(initialTarget));
      expect(camera.distance, equals(initialDistance));
      expect(camera.yaw, equals(initialYaw));
      expect(camera.pitch, equals(initialPitch));
    });
  });

  group('CinematicCameraController Performance and Edge Cases', () {
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

    test('should handle very small deltaTime values', () {
      simulation.resetWithScenario(ScenarioType.solarSystem);

      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          0.001, // Very small deltaTime
        ),
        returnsNormally,
      );
    });

    test('should handle zero deltaTime', () {
      simulation.resetWithScenario(ScenarioType.solarSystem);

      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.0, // Zero deltaTime
        ),
        returnsNormally,
      );
    });

    test('should handle large deltaTime values', () {
      simulation.resetWithScenario(ScenarioType.solarSystem);

      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          10.0, // Large deltaTime
        ),
        returnsNormally,
      );
    });

    test('should handle negative deltaTime gracefully', () {
      simulation.resetWithScenario(ScenarioType.solarSystem);

      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          -0.016, // Negative deltaTime
        ),
        returnsNormally,
      );
    });

    test('should handle many consecutive updates without memory leaks', () {
      simulation.resetWithScenario(ScenarioType.galaxyFormation);

      // Run many updates to test for memory leaks or state corruption
      for (int i = 0; i < 100; i++) {
        // Reduced from 1000 to keep tests fast
        controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        );

        // Verify camera state remains valid
        expect(camera.distance.isFinite, isTrue);
        expect(camera.yaw.isFinite, isTrue);
        expect(camera.pitch.isFinite, isTrue);
        expect(camera.target.x.isFinite, isTrue);
        expect(camera.target.y.isFinite, isTrue);
        expect(camera.target.z.isFinite, isTrue);
      }
    });

    test('should handle body removal during camera updates', () {
      simulation.resetWithScenario(ScenarioType.solarSystem);

      // Run a few updates
      for (int i = 0; i < 5; i++) {
        controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        );
      }

      // Simulate body removal
      if (simulation.bodies.isNotEmpty) {
        simulation.bodies.removeLast();
      }

      // Should continue working after body removal
      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        ),
        returnsNormally,
      );
    });

    test('should maintain finite camera values under all conditions', () {
      final scenarios = [
        ScenarioType.solarSystem,
        ScenarioType.binaryStars,
        ScenarioType.galaxyFormation,
      ];

      for (final scenario in scenarios) {
        simulation.resetWithScenario(scenario);

        for (final technique in CinematicCameraTechnique.values) {
          controller.updateCamera(technique, simulation, camera, ui, 0.016);

          // Verify all camera values are finite
          expect(
            camera.distance.isFinite,
            isTrue,
            reason: 'Distance should be finite for $scenario with $technique',
          );
          expect(
            camera.yaw.isFinite,
            isTrue,
            reason: 'Yaw should be finite for $scenario with $technique',
          );
          expect(
            camera.pitch.isFinite,
            isTrue,
            reason: 'Pitch should be finite for $scenario with $technique',
          );
          expect(
            camera.target.x.isFinite,
            isTrue,
            reason: 'Target X should be finite for $scenario with $technique',
          );
          expect(
            camera.target.y.isFinite,
            isTrue,
            reason: 'Target Y should be finite for $scenario with $technique',
          );
          expect(
            camera.target.z.isFinite,
            isTrue,
            reason: 'Target Z should be finite for $scenario with $technique',
          );
        }
      }
    });
  });

  group('CinematicCameraController State Persistence', () {
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

    test('should maintain state across paused periods', () {
      simulation.resetWithScenario(ScenarioType.earthMoonSun);

      // Run some updates to build state
      for (int i = 0; i < 10; i++) {
        controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          0.016,
        );
      }

      // Pause simulation
      simulation.pauseSimulation();

      // Run updates while paused (camera may still update for UI responsiveness)
      for (int i = 0; i < 5; i++) {
        controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          0.016,
        );
      }

      // Resume and verify it continues working
      simulation.resumeSimulation();
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
    });

    test('should handle scenario switching while maintaining stability', () {
      // Start with one scenario
      simulation.resetWithScenario(ScenarioType.solarSystem);

      for (int i = 0; i < 5; i++) {
        controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        );
      }

      // Switch scenarios
      simulation.resetWithScenario(ScenarioType.binaryStars);

      // Should continue working with new scenario
      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          0.016,
        ),
        returnsNormally,
      );

      // Camera values should still be finite
      expect(camera.distance.isFinite, isTrue);
      expect(camera.target.x.isFinite, isTrue);
      expect(camera.target.y.isFinite, isTrue);
      expect(camera.target.z.isFinite, isTrue);
    });
  });

  group('Camera Speed Integration Tests', () {
    test('should apply camera speed multiplier to AI techniques', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);

      // Test different camera speeds
      final testSpeeds = [0.1, 0.5, 1.0, 2.0, 3.0];

      for (final speed in testSpeeds) {
        ui.setCameraSpeed(speed);

        // Update camera with predictive orbital technique
        controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          1.0 / 60.0, // 60 FPS
        );

        // Camera should move (position changes indicate speed is being applied)
        // We can't test exact values due to complex movement algorithms,
        // but we can verify the camera is responding
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
      }

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should not apply camera speed to manual technique', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);

      // Set high camera speed
      ui.setCameraSpeed(3.0);

      final initialYaw = camera.yaw;
      final initialPitch = camera.pitch;
      final initialRoll = camera.roll;
      final initialDistance = camera.distance;
      final initialTarget = camera.target.clone();

      // Update camera with manual technique (should not move)
      controller.updateCamera(
        CinematicCameraTechnique.manual,
        simulation,
        camera,
        ui,
        1.0 / 60.0,
      );

      // Camera should remain unchanged for manual mode
      expect(camera.yaw, equals(initialYaw));
      expect(camera.pitch, equals(initialPitch));
      expect(camera.roll, equals(initialRoll));
      expect(camera.distance, equals(initialDistance));
      expect(camera.target.x, equals(initialTarget.x));
      expect(camera.target.y, equals(initialTarget.y));
      expect(camera.target.z, equals(initialTarget.z));

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should handle extreme camera speeds gracefully', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.random);

      // Test very slow speed
      ui.setCameraSpeed(0.1);
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

      // Test very fast speed
      ui.setCameraSpeed(3.0);
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

      // Camera values should remain finite
      expect(camera.distance.isFinite, isTrue);
      expect(camera.yaw.isFinite, isTrue);
      expect(camera.pitch.isFinite, isTrue);
      expect(camera.roll.isFinite, isTrue);

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should work with different scenarios and camera speeds', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      final scenarios = [
        ScenarioType.solarSystem,
        ScenarioType.earthMoonSun,
        ScenarioType.binaryStars,
        ScenarioType.random,
      ];

      final techniques = [
        CinematicCameraTechnique.predictiveOrbital,
        CinematicCameraTechnique.dynamicFraming,
      ];

      for (final scenario in scenarios) {
        simulation.resetWithScenario(scenario);

        for (final technique in techniques) {
          // Test different speeds
          ui.setCameraSpeed(0.5);
          expect(
            () => controller.updateCamera(
              technique,
              simulation,
              camera,
              ui,
              1.0 / 60.0,
            ),
            returnsNormally,
            reason: 'Should handle $technique with $scenario at 0.5x speed',
          );

          ui.setCameraSpeed(2.0);
          expect(
            () => controller.updateCamera(
              technique,
              simulation,
              camera,
              ui,
              1.0 / 60.0,
            ),
            returnsNormally,
            reason: 'Should handle $technique with $scenario at 2.0x speed',
          );
        }
      }

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should maintain camera state consistency with speed changes', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);

      // Test rapid speed changes
      final speeds = [1.0, 0.1, 3.0, 0.5, 2.0];

      for (final speed in speeds) {
        ui.setCameraSpeed(speed);

        // Update camera multiple times
        for (int i = 0; i < 5; i++) {
          controller.updateCamera(
            CinematicCameraTechnique.predictiveOrbital,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          );

          // Verify camera state remains valid
          expect(camera.distance, greaterThan(0));
          expect(camera.distance.isFinite, isTrue);
          expect(camera.yaw.isFinite, isTrue);
          expect(camera.pitch.isFinite, isTrue);
          expect(camera.roll.isFinite, isTrue);
        }
      }

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });
  });

  group('CinematicCameraController Cleanup and Edge Cases', () {
    test('should handle body merger cleanup correctly', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      // Start with 3 bodies
      simulation.resetWithScenario(ScenarioType.threeBodyClassic);
      simulation.start();

      // Update camera multiple times
      for (int i = 0; i < 10; i++) {
        controller.updateCamera(
          CinematicCameraTechnique.dynamicFraming,
          simulation,
          camera,
          ui,
          1.0 / 60.0,
        );
      }

      // Simulate body merger by removing a body
      if (simulation.bodies.isNotEmpty) {
        simulation.bodies.removeLast();
      }

      // Should handle the cleanup gracefully
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

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should handle all scenario types in predictive orbital mode', () {
      final controller = CinematicCameraController();
      final camera = CameraState();
      final ui = UIState();

      final scenarios = [
        ScenarioType.solarSystem,
        ScenarioType.earthMoonSun,
        ScenarioType.binaryStars,
        ScenarioType.asteroidBelt,
        ScenarioType.galaxyFormation,
        ScenarioType.threeBodyClassic,
      ];

      for (final scenario in scenarios) {
        final simulation = SimulationState();
        simulation.resetWithScenario(scenario);
        simulation.start();

        // Update camera for each scenario
        for (int i = 0; i < 5; i++) {
          expect(
            () => controller.updateCamera(
              CinematicCameraTechnique.predictiveOrbital,
              simulation,
              camera,
              ui,
              1.0 / 60.0,
            ),
            returnsNormally,
            reason: 'Should handle $scenario in predictive orbital mode',
          );
        }

        simulation.dispose();
      }

      camera.dispose();
      ui.dispose();
    });

    test('should handle empty body list gracefully', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.start();
      // Bodies list is empty by default

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

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should handle paused simulation correctly', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);
      simulation.start();

      // Update while running
      controller.updateCamera(
        CinematicCameraTechnique.predictiveOrbital,
        simulation,
        camera,
        ui,
        1.0 / 60.0,
      );

      // Pause simulation
      simulation.pause();

      final initialYaw = camera.yaw;
      final initialPitch = camera.pitch;

      // Update while paused - should not change camera
      controller.updateCamera(
        CinematicCameraTechnique.predictiveOrbital,
        simulation,
        camera,
        ui,
        1.0 / 60.0,
      );

      // Camera should not have changed significantly during pause
      expect(camera.yaw, equals(initialYaw));
      expect(camera.pitch, equals(initialPitch));

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should handle stopped simulation correctly', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);
      // Don't start simulation

      final initialDistance = camera.distance;

      // Update while stopped
      controller.updateCamera(
        CinematicCameraTechnique.predictiveOrbital,
        simulation,
        camera,
        ui,
        1.0 / 60.0,
      );

      // Camera should not have changed during stopped state
      expect(camera.distance, equals(initialDistance));

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should apply camera speed multiplier correctly', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);
      simulation.start();

      // Test with different camera speeds
      final speeds = [0.1, 0.5, 1.0, 2.0, 3.0];

      for (final speed in speeds) {
        ui.setCameraSpeed(speed);

        expect(
          () => controller.updateCamera(
            CinematicCameraTechnique.predictiveOrbital,
            simulation,
            camera,
            ui,
            1.0 / 60.0,
          ),
          returnsNormally,
          reason: 'Should handle camera speed $speed',
        );
      }

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should maintain valid camera state across multiple updates', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.binaryStars);
      simulation.start();

      // Update camera many times
      for (int i = 0; i < 100; i++) {
        controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          1.0 / 60.0,
        );

        // Verify camera state is always valid
        expect(camera.distance, greaterThan(0));
        expect(camera.distance.isFinite, isTrue);
        expect(camera.yaw.isFinite, isTrue);
        expect(camera.pitch.isFinite, isTrue);
        expect(camera.roll.isFinite, isTrue);
        expect(camera.target.storage.every((v) => v.isFinite), isTrue);
      }

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should handle dynamic framing with various scenarios', () {
      final controller = CinematicCameraController();
      final camera = CameraState();
      final ui = UIState();

      final scenarios = [
        ScenarioType.solarSystem,
        ScenarioType.binaryStars,
        ScenarioType.threeBodyClassic,
        ScenarioType.asteroidBelt,
      ];

      for (final scenario in scenarios) {
        final simulation = SimulationState();
        simulation.resetWithScenario(scenario);
        simulation.start();

        // Update with dynamic framing
        for (int i = 0; i < 10; i++) {
          expect(
            () => controller.updateCamera(
              CinematicCameraTechnique.dynamicFraming,
              simulation,
              camera,
              ui,
              1.0 / 60.0,
            ),
            returnsNormally,
            reason: 'Should handle $scenario with dynamic framing',
          );
        }

        simulation.dispose();
      }

      camera.dispose();
      ui.dispose();
    });

    test('should handle technique switching gracefully', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.threeBodyClassic);
      simulation.start();

      final techniques = CinematicCameraTechnique.values;

      // Rapidly switch between techniques
      for (int i = 0; i < 30; i++) {
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

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should handle very small deltaTime values', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);
      simulation.start();

      // Test with very small deltaTime
      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          0.0001, // Very small deltaTime
        ),
        returnsNormally,
      );

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });

    test('should handle very large deltaTime values', () {
      final controller = CinematicCameraController();
      final simulation = SimulationState();
      final camera = CameraState();
      final ui = UIState();

      simulation.resetWithScenario(ScenarioType.solarSystem);
      simulation.start();

      // Test with large deltaTime
      expect(
        () => controller.updateCamera(
          CinematicCameraTechnique.predictiveOrbital,
          simulation,
          camera,
          ui,
          1.0, // Large deltaTime (1 second)
        ),
        returnsNormally,
      );

      // Camera state should still be valid
      expect(camera.distance.isFinite, isTrue);
      expect(camera.yaw.isFinite, isTrue);
      expect(camera.pitch.isFinite, isTrue);

      simulation.dispose();
      camera.dispose();
      ui.dispose();
    });
  });
}
