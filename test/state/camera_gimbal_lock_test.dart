import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/state/camera_state.dart';

void main() {
  group('Camera Gimbal Lock Prevention Tests', () {
    late CameraState camera;

    setUp(() {
      camera = CameraState();
    });

    tearDown(() {
      camera.dispose();
    });

    group('Pitch Clamping', () {
      test('pitch should be clamped to maximum value', () {
        // Try to pitch beyond the maximum
        camera.rotate(0.0, 10.0);

        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));
        expect(camera.pitch, lessThan(1.571)); // Less than π/2 (90 degrees)
      });

      test('pitch should be clamped to minimum value', () {
        // Try to pitch beyond the minimum
        camera.rotate(0.0, -10.0);

        expect(camera.pitch, equals(SimulationConstants.cameraPitchMin));
        expect(camera.pitch, greaterThan(-1.571)); // Greater than -π/2
      });

      test('pitch should accumulate correctly within bounds', () {
        final initialPitch = camera.pitch;

        camera.rotate(0.0, 0.5);
        expect(camera.pitch, equals(initialPitch + 0.5));

        camera.rotate(0.0, 0.3);
        expect(camera.pitch, equals(initialPitch + 0.8));
      });

      test('pitch should clamp when approaching limit incrementally', () {
        camera.resetView();

        // Rotate in small increments past the limit
        for (int i = 0; i < 20; i++) {
          camera.rotate(0.0, 0.2);
        }

        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));
      });

      test(
        'pitch should clamp when approaching negative limit incrementally',
        () {
          camera.resetView();

          // Rotate in small increments past the negative limit
          for (int i = 0; i < 20; i++) {
            camera.rotate(0.0, -0.2);
          }

          expect(camera.pitch, equals(SimulationConstants.cameraPitchMin));
        },
      );

      test('pitch clamping should work with invert pitch enabled', () {
        // Test positive delta with invert
        camera.toggleInvertPitch();
        camera.rotate(0.0, 10.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMin));
      });

      test(
        'pitch clamping should work with invert pitch for negative delta',
        () {
          // Test negative delta with invert
          camera.toggleInvertPitch();
          camera.rotate(0.0, -10.0);
          expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));
        },
      );
    });

    group('Yaw Behavior', () {
      test('yaw should not be clamped', () {
        // Yaw should be able to rotate continuously
        camera.rotate(10.0, 0.0);

        expect(camera.yaw, closeTo(10.6, 0.01)); // Initial 0.6 + 10.0
      });

      test('yaw should accumulate without limits', () {
        final initialYaw = camera.yaw;

        // Rotate multiple full circles
        for (int i = 0; i < 10; i++) {
          camera.rotate(6.28, 0.0); // ~2π per iteration
        }

        expect(camera.yaw, closeTo(initialYaw + 62.8, 0.1));
      });

      test('yaw should work at maximum pitch', () {
        // Set pitch to maximum
        camera.rotate(0.0, 10.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));

        final initialYaw = camera.yaw;
        camera.rotate(1.0, 0.0);

        expect(camera.yaw, equals(initialYaw + 1.0));
      });
    });

    group('setCameraParameters Pitch Clamping', () {
      test('should clamp pitch when set directly via setCameraParameters', () {
        camera.setCameraParameters(pitch: 5.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));

        camera.setCameraParameters(pitch: -5.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMin));
      });

      test('should allow valid pitch values via setCameraParameters', () {
        camera.setCameraParameters(pitch: 0.5);
        expect(camera.pitch, equals(0.5));

        camera.setCameraParameters(pitch: -0.5);
        expect(camera.pitch, equals(-0.5));
      });

      test('should clamp pitch at exact boundary values', () {
        camera.setCameraParameters(
          pitch: SimulationConstants.cameraPitchMax + 0.1,
        );
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));

        camera.setCameraParameters(
          pitch: SimulationConstants.cameraPitchMin - 0.1,
        );
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMin));
      });
    });

    group('Gimbal Lock Scenarios', () {
      test('should prevent gimbal lock when looking straight up', () {
        // Rotate to look straight up
        camera.rotate(0.0, 10.0);

        // Pitch should be clamped below 90 degrees
        expect(camera.pitch, lessThan(1.571));
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));
      });

      test('should prevent gimbal lock when looking straight down', () {
        // Rotate to look straight down
        camera.rotate(0.0, -10.0);

        // Pitch should be clamped above -90 degrees
        expect(camera.pitch, greaterThan(-1.571));
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMin));
      });

      test('should maintain stable yaw at extreme pitch angles', () {
        // Set to near-maximum pitch
        camera.rotate(0.0, 10.0);
        final yawAtMaxPitch = camera.yaw;

        // Yaw should still be modifiable
        camera.rotate(1.0, 0.0);
        expect(camera.yaw, equals(yawAtMaxPitch + 1.0));

        camera.rotate(-0.5, 0.0);
        expect(camera.yaw, equals(yawAtMaxPitch + 0.5));
      });

      test('should handle rapid pitch oscillations', () {
        for (int i = 0; i < 10; i++) {
          camera.rotate(0.0, 2.0);
          camera.rotate(0.0, -2.0);
        }

        // Should remain stable and within bounds
        expect(
          camera.pitch,
          greaterThanOrEqualTo(SimulationConstants.cameraPitchMin),
        );
        expect(
          camera.pitch,
          lessThanOrEqualTo(SimulationConstants.cameraPitchMax),
        );
      });
    });

    group('Rotation Combination', () {
      test('should handle simultaneous yaw and pitch changes', () {
        final initialYaw = camera.yaw;
        final initialPitch = camera.pitch;

        camera.rotate(1.0, 0.5);

        expect(camera.yaw, equals(initialYaw + 1.0));
        expect(camera.pitch, equals(initialPitch + 0.5));
      });

      test('should clamp pitch while allowing yaw in combined rotation', () {
        camera.rotate(2.0, 10.0); // Large values

        expect(camera.yaw, equals(0.6 + 2.0)); // Yaw changes normally
        expect(
          camera.pitch,
          equals(SimulationConstants.cameraPitchMax),
        ); // Pitch clamped
      });

      test('should maintain correct state after multiple rotations', () {
        camera.rotate(1.0, 0.5);
        camera.rotate(-0.5, 0.2);
        camera.rotate(0.3, -0.3);

        expect(camera.yaw, equals(0.6 + 1.0 - 0.5 + 0.3));
        expect(camera.pitch, equals(0.3 + 0.5 + 0.2 - 0.3));
      });
    });

    group('Follow Mode Interaction', () {
      test('pitch clamping should work in follow mode', () {
        camera.toggleFollowMode([/* empty list for test */]);
        camera.rotate(0.0, 10.0);

        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));
      });
    });

    group('Reset Behavior', () {
      test('reset should restore pitch within valid bounds', () {
        camera.rotate(0.0, 10.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));

        camera.resetView();

        expect(camera.pitch, equals(0.3)); // Default pitch
        expect(camera.pitch, greaterThan(SimulationConstants.cameraPitchMin));
        expect(camera.pitch, lessThan(SimulationConstants.cameraPitchMax));
      });
    });

    group('Edge Cases', () {
      test('should handle zero delta rotations', () {
        final initialYaw = camera.yaw;
        final initialPitch = camera.pitch;

        camera.rotate(0.0, 0.0);

        expect(camera.yaw, equals(initialYaw));
        expect(camera.pitch, equals(initialPitch));
      });

      test('should handle very small delta values', () {
        final initialPitch = camera.pitch;

        camera.rotate(0.0, 0.0001);

        expect(camera.pitch, equals(initialPitch + 0.0001));
      });

      test('should handle alternating extreme pitch attempts', () {
        camera.rotate(0.0, 10.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));

        camera.rotate(0.0, -20.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMin));

        camera.rotate(0.0, 20.0);
        expect(camera.pitch, equals(SimulationConstants.cameraPitchMax));
      });
    });

    group('Constants Validation', () {
      test('pitch limits should be symmetric', () {
        expect(
          SimulationConstants.cameraPitchMax.abs(),
          equals(SimulationConstants.cameraPitchMin.abs()),
        );
      });

      test('pitch limits should prevent gimbal lock', () {
        // Limits should be less than π/2 (90 degrees)
        expect(SimulationConstants.cameraPitchMax, lessThan(1.571));
        expect(SimulationConstants.cameraPitchMin, greaterThan(-1.571));
      });

      test('default pitch should be within valid bounds', () {
        final defaultCamera = CameraState();

        expect(
          defaultCamera.pitch,
          greaterThanOrEqualTo(SimulationConstants.cameraPitchMin),
        );
        expect(
          defaultCamera.pitch,
          lessThanOrEqualTo(SimulationConstants.cameraPitchMax),
        );

        defaultCamera.dispose();
      });
    });
  });
}
