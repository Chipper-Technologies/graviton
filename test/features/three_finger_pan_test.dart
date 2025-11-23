import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Three-Finger Pan Tests', () {
    late CameraState camera;

    setUp(() {
      camera = CameraState();
    });

    tearDown(() {
      camera.dispose();
    });

    group('Pan Functionality', () {
      test('pan should move camera target', () {
        final initialTarget = camera.target.clone();
        final panDelta = vm.Vector3(10.0, 5.0, 0.0);

        camera.pan(panDelta);

        expect(camera.target.x, equals(initialTarget.x + 10.0));
        expect(camera.target.y, equals(initialTarget.y + 5.0));
        expect(camera.target.z, equals(initialTarget.z + 0.0));
      });

      test('pan should accumulate multiple movements', () {
        final initialTarget = camera.target.clone();

        camera.pan(vm.Vector3(5.0, 0.0, 0.0));
        camera.pan(vm.Vector3(0.0, 10.0, 0.0));
        camera.pan(vm.Vector3(0.0, 0.0, -3.0));

        expect(camera.target.x, equals(initialTarget.x + 5.0));
        expect(camera.target.y, equals(initialTarget.y + 10.0));
        expect(camera.target.z, equals(initialTarget.z - 3.0));
      });

      test('pan should notify listeners', () {
        bool wasNotified = false;
        camera.addListener(() {
          wasNotified = true;
        });

        camera.pan(vm.Vector3(1.0, 0.0, 0.0));

        expect(wasNotified, isTrue);
      });

      test('pan should work with negative deltas', () {
        final initialTarget = camera.target.clone();
        final panDelta = vm.Vector3(-15.0, -20.0, -5.0);

        camera.pan(panDelta);

        expect(camera.target.x, equals(initialTarget.x - 15.0));
        expect(camera.target.y, equals(initialTarget.y - 20.0));
        expect(camera.target.z, equals(initialTarget.z - 5.0));
      });

      test('pan should work with zero delta', () {
        final initialTarget = camera.target.clone();

        camera.pan(vm.Vector3.zero());

        expect(camera.target.x, equals(initialTarget.x));
        expect(camera.target.y, equals(initialTarget.y));
        expect(camera.target.z, equals(initialTarget.z));
      });
    });

    group('Pan Sensitivity Scaling', () {
      test('pan sensitivity should scale with camera distance', () {
        // Test at default distance (300.0)
        final sensitivity1 =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;
        expect(sensitivity1, equals(0.6));

        // Test at closer distance
        camera.zoom(-0.5); // Zoom in significantly
        final sensitivity2 =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;
        expect(sensitivity2, lessThan(sensitivity1));

        // Test at farther distance
        camera.resetView();
        camera.zoom(2.0); // Zoom out significantly
        final sensitivity3 =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;
        expect(sensitivity3, greaterThan(sensitivity1));
      });
    });

    group('View-Relative Pan Direction', () {
      test(
        'right vector should be perpendicular to view direction at yaw 0',
        () {
          camera.setCameraParameters(yaw: 0.0);
          final cy = math.cos(camera.yaw);
          final sy = math.sin(camera.yaw);
          final rightVector = vm.Vector3(-cy, 0, sy);

          expect(rightVector.x, closeTo(-1.0, 0.001));
          expect(rightVector.y, equals(0.0));
          expect(rightVector.z, closeTo(0.0, 0.001));
        },
      );

      test(
        'right vector should be perpendicular to view direction at yaw 90deg',
        () {
          camera.setCameraParameters(yaw: math.pi / 2);
          final cy = math.cos(camera.yaw);
          final sy = math.sin(camera.yaw);
          final rightVector = vm.Vector3(-cy, 0, sy);

          expect(rightVector.x, closeTo(0.0, 0.001));
          expect(rightVector.y, equals(0.0));
          expect(rightVector.z, closeTo(1.0, 0.001));
        },
      );

      test('up vector should always point upward in world space', () {
        final upVector = vm.Vector3(0, 1, 0);

        expect(upVector.x, equals(0.0));
        expect(upVector.y, equals(1.0));
        expect(upVector.z, equals(0.0));
      });
    });

    group('Pan with Camera Rotation', () {
      test('horizontal pan should move relative to camera yaw', () {
        // Set camera to face specific direction
        camera.setCameraParameters(yaw: math.pi / 4); // 45 degrees
        final initialTarget = camera.target.clone();

        // Simulate screen delta (positive dx = drag right)
        const screenDelta = 100.0; // pixels
        final panSensitivity =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;

        final cy = math.cos(camera.yaw);
        final sy = math.sin(camera.yaw);
        final rightVector = vm.Vector3(-cy, 0, sy);

        final worldDelta = rightVector * (screenDelta * panSensitivity);
        camera.pan(worldDelta);

        // Target should have moved in the camera's right direction
        expect(camera.target, isNot(equals(initialTarget)));
      });

      test('vertical pan should always move in world Y direction', () {
        final initialTarget = camera.target.clone();

        // Simulate screen delta (positive dy = drag down)
        const screenDelta = 100.0; // pixels
        final panSensitivity =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;

        final upVector = vm.Vector3(0, 1, 0);
        final worldDelta = upVector * (screenDelta * panSensitivity);
        camera.pan(worldDelta);

        // Target should have moved only in Y direction
        expect(camera.target.x, equals(initialTarget.x));
        expect(camera.target.y, greaterThan(initialTarget.y));
        expect(camera.target.z, equals(initialTarget.z));
      });
    });

    group('Pan Interaction with Other Camera Features', () {
      test('pan should work after zooming', () {
        camera.zoom(0.5); // Zoom out
        final targetAfterZoom = camera.target.clone();

        camera.pan(vm.Vector3(10.0, 0.0, 0.0));

        expect(camera.target.x, equals(targetAfterZoom.x + 10.0));
      });

      test('pan should work after rotating', () {
        camera.rotate(1.0, 0.5); // Rotate camera
        final targetAfterRotate = camera.target.clone();

        camera.pan(vm.Vector3(0.0, 10.0, 0.0));

        expect(camera.target.y, equals(targetAfterRotate.y + 10.0));
      });

      test('pan should work after rolling', () {
        camera.rotateRoll(math.pi / 4); // Roll camera
        final targetAfterRoll = camera.target.clone();

        camera.pan(vm.Vector3(5.0, 5.0, 5.0));

        expect(camera.target.x, equals(targetAfterRoll.x + 5.0));
        expect(camera.target.y, equals(targetAfterRoll.y + 5.0));
        expect(camera.target.z, equals(targetAfterRoll.z + 5.0));
      });

      test('pan target should not affect camera distance', () {
        final initialDistance = camera.distance;

        camera.pan(vm.Vector3(100.0, 100.0, 100.0));

        expect(camera.distance, equals(initialDistance));
      });

      test('pan target should not affect camera angles', () {
        final initialYaw = camera.yaw;
        final initialPitch = camera.pitch;
        final initialRoll = camera.roll;

        camera.pan(vm.Vector3(50.0, 50.0, 50.0));

        expect(camera.yaw, equals(initialYaw));
        expect(camera.pitch, equals(initialPitch));
        expect(camera.roll, equals(initialRoll));
      });
    });

    group('Pan Edge Cases', () {
      test('pan should work with very small deltas', () {
        final initialTarget = camera.target.clone();
        final smallDelta = vm.Vector3(0.001, 0.001, 0.001);

        camera.pan(smallDelta);

        expect(camera.target.x, equals(initialTarget.x + 0.001));
        expect(camera.target.y, equals(initialTarget.y + 0.001));
        expect(camera.target.z, equals(initialTarget.z + 0.001));
      });

      test('pan should work with very large deltas', () {
        final initialTarget = camera.target.clone();
        final largeDelta = vm.Vector3(10000.0, 10000.0, 10000.0);

        camera.pan(largeDelta);

        expect(camera.target.x, equals(initialTarget.x + 10000.0));
        expect(camera.target.y, equals(initialTarget.y + 10000.0));
        expect(camera.target.z, equals(initialTarget.z + 10000.0));
      });

      test('pan should maintain precision with repeated operations', () {
        final expectedTarget = camera.target + vm.Vector3(10.0, 10.0, 10.0);

        // Pan in small increments
        for (int i = 0; i < 100; i++) {
          camera.pan(vm.Vector3(0.1, 0.1, 0.1));
        }

        expect(camera.target.x, closeTo(expectedTarget.x, 0.001));
        expect(camera.target.y, closeTo(expectedTarget.y, 0.001));
        expect(camera.target.z, closeTo(expectedTarget.z, 0.001));
      });
    });

    group('Pan Reset Behavior', () {
      test('resetView should reset pan target to origin', () {
        camera.pan(vm.Vector3(100.0, 50.0, 25.0));
        expect(camera.target, isNot(equals(vm.Vector3.zero())));

        camera.resetView();

        expect(camera.target.x, equals(0.0));
        expect(camera.target.y, equals(0.0));
        expect(camera.target.z, equals(0.0));
      });

      test('setTarget should override previous pan', () {
        camera.pan(vm.Vector3(50.0, 50.0, 50.0));

        final newTarget = vm.Vector3(100.0, 200.0, 300.0);
        camera.setTarget(newTarget);

        expect(camera.target.x, equals(100.0));
        expect(camera.target.y, equals(200.0));
        expect(camera.target.z, equals(300.0));
      });
    });

    group('Combined Gesture Simulation', () {
      test('three-finger horizontal pan simulation - drag right', () {
        final initialTarget = camera.target.clone();
        camera.setCameraParameters(yaw: 0.0); // Facing forward

        // Simulate 100px drag to the right
        const screenDeltaDx = 100.0;
        final panSensitivity =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;

        final cy = math.cos(camera.yaw);
        final sy = math.sin(camera.yaw);
        final rightVector = vm.Vector3(-cy, 0, sy);

        final worldDelta = rightVector * (screenDeltaDx * panSensitivity);
        camera.pan(worldDelta);

        // Should move in negative X direction (right in camera space)
        expect(camera.target.x, lessThan(initialTarget.x));
      });

      test('three-finger vertical pan simulation - drag up', () {
        final initialTarget = camera.target.clone();

        // Simulate 100px drag up
        const screenDeltaDy = 100.0;
        final panSensitivity =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;

        final upVector = vm.Vector3(0, 1, 0);
        final worldDelta = upVector * (screenDeltaDy * panSensitivity);
        camera.pan(worldDelta);

        // Should move in positive Y direction (up)
        expect(camera.target.y, greaterThan(initialTarget.y));
      });

      test('three-finger diagonal pan simulation', () {
        final initialTarget = camera.target.clone();
        camera.setCameraParameters(yaw: 0.0);

        // Simulate diagonal drag (right and up)
        const screenDeltaDx = 100.0;
        const screenDeltaDy = 100.0;
        final panSensitivity =
            camera.distance * SimulationConstants.cameraPanSensitivityFactor;

        final cy = math.cos(camera.yaw);
        final sy = math.sin(camera.yaw);
        final rightVector = vm.Vector3(-cy, 0, sy);
        final upVector = vm.Vector3(0, 1, 0);

        final worldDelta =
            rightVector * (screenDeltaDx * panSensitivity) +
            upVector * (screenDeltaDy * panSensitivity);
        camera.pan(worldDelta);

        // Should move in both X and Y
        expect(camera.target.x, isNot(equals(initialTarget.x)));
        expect(camera.target.y, greaterThan(initialTarget.y));
      });
    });
  });
}
