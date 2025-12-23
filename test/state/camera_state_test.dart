import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/firebase/camera_snapshot.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CameraState Tests', () {
    late CameraState cameraState;

    setUp(() {
      cameraState = CameraState();
    });

    tearDown(() {
      cameraState.dispose();
    });

    test('CameraState should initialize with default values', () {
      expect(cameraState.distance, equals(300.0)); // Updated to current default
      expect(cameraState.yaw, equals(0.6));
      expect(cameraState.pitch, equals(0.3));
      expect(cameraState.autoRotate, isFalse);
      expect(cameraState.autoRotateSpeed, equals(0.2));
      expect(cameraState.selectedBody, isNull);
    });

    test('Zoom should update distance within bounds', () {
      const initialDistance = 300.0; // Updated to current default

      cameraState.zoom(0.1); // 10% increase
      expect(cameraState.distance, equals(initialDistance * 1.1));

      cameraState.zoom(-0.05); // 5% decrease
      expect(cameraState.distance, closeTo(initialDistance * 1.1 * 0.95, 0.01));
    });

    test('Zoom should respect minimum distance', () {
      cameraState.zoom(-10.0); // Try to zoom way in
      expect(
        cameraState.distance,
        greaterThanOrEqualTo(5.0),
      ); // Updated to current minimum
    });

    test('Zoom should respect maximum distance', () {
      cameraState.zoom(10.0); // Try to zoom way out
      expect(
        cameraState.distance,
        lessThanOrEqualTo(2000.0),
      ); // Updated to current maximum
    });

    test('Rotate should update yaw and pitch', () {
      const initialYaw = 0.6;
      const initialPitch = 0.3;

      cameraState.rotate(0.5, 0.3);
      expect(cameraState.yaw, closeTo(initialYaw + 0.5, 1e-10));
      expect(cameraState.pitch, closeTo(initialPitch + 0.3, 1e-10));

      cameraState.rotate(0.2, -0.1);
      expect(cameraState.yaw, closeTo(initialYaw + 0.7, 1e-10));
      expect(cameraState.pitch, closeTo(initialPitch + 0.2, 1e-10));
    });

    test('Pitch should accumulate rotation values and be clamped', () {
      final initialPitch = cameraState.pitch;
      cameraState.rotate(0.0, 10.0); // Large pitch rotation
      // Should be clamped to maxPitch (1.5)
      expect(cameraState.pitch, equals(1.5));

      cameraState.rotate(0.0, -20.0); // Large negative pitch rotation
      // Should be clamped to minPitch (-1.5)
      expect(cameraState.pitch, equals(-1.5));

      // Reset and test normal accumulation
      cameraState.resetView();
      cameraState.rotate(0.0, 0.5);
      expect(cameraState.pitch, closeTo(initialPitch + 0.5, 1e-10));
    });

    test('ToggleAutoRotate should change autoRotate state', () {
      expect(cameraState.autoRotate, isFalse);
      cameraState.toggleAutoRotate();
      expect(cameraState.autoRotate, isTrue);
      cameraState.toggleAutoRotate();
      expect(cameraState.autoRotate, isFalse);
    });

    test('SetAutoRotateSpeed should update speed within bounds', () {
      cameraState.setAutoRotateSpeed(1.0);
      expect(cameraState.autoRotateSpeed, equals(1.0));

      cameraState.setAutoRotateSpeed(0.1);
      expect(cameraState.autoRotateSpeed, equals(0.1));
    });

    test('SetAutoRotateSpeed should clamp to valid range', () {
      cameraState.setAutoRotateSpeed(-1.0);
      expect(cameraState.autoRotateSpeed, equals(0.1));

      cameraState.setAutoRotateSpeed(10.0);
      expect(cameraState.autoRotateSpeed, equals(3.0));
    });

    test('SelectBody should update selectedBody', () {
      cameraState.selectBody(5);
      expect(cameraState.selectedBody, equals(5));

      cameraState.selectBody(null);
      expect(cameraState.selectedBody, isNull);
    });

    test('ResetView should restore default values', () {
      // Change values
      cameraState.zoom(0.5); // Increase distance
      cameraState.rotate(1.0, 0.5);
      cameraState.toggleAutoRotate();
      cameraState.selectBody(3);

      // Reset
      cameraState.resetView();

      expect(cameraState.distance, equals(300.0)); // Updated to current default
      expect(cameraState.yaw, equals(0.6));
      expect(cameraState.pitch, equals(0.3));
      expect(cameraState.autoRotate, isFalse);
      expect(cameraState.selectedBody, isNull);
    });

    test('UpdateAutoRotation should rotate when enabled', () {
      cameraState.toggleAutoRotate(); // Enable auto rotation
      final initialYaw = cameraState.yaw;

      cameraState.updateAutoRotation(1.0); // 1 second

      expect(cameraState.yaw, isNot(equals(initialYaw)));
    });

    test('UpdateAutoRotation should not rotate when disabled', () {
      // Auto rotation is disabled by default
      final initialYaw = cameraState.yaw;

      cameraState.updateAutoRotation(1.0);

      expect(cameraState.yaw, equals(initialYaw));
    });

    test('UpdateAutoRotation should handle zero deltaTime', () {
      cameraState.toggleAutoRotate();
      final initialYaw = cameraState.yaw;

      cameraState.updateAutoRotation(0.0);

      expect(cameraState.yaw, equals(initialYaw));
    });

    test('State changes should notify listeners', () {
      bool wasNotified = false;
      cameraState.addListener(() {
        wasNotified = true;
      });

      cameraState.zoom(5.0);
      expect(wasNotified, isTrue);

      wasNotified = false;
      cameraState.rotate(0.1, 0.1);
      expect(wasNotified, isTrue);

      wasNotified = false;
      cameraState.toggleAutoRotate();
      expect(wasNotified, isTrue);

      wasNotified = false;
      cameraState.selectBody(1);
      expect(wasNotified, isTrue);

      wasNotified = false;
      cameraState.resetView();
      expect(wasNotified, isTrue);
    });

    test('Pitch clamping prevents gimbal lock', () {
      // Test that pitch is clamped to prevent camera flipping
      cameraState.rotate(0.0, 5.0); // Try to pitch way up
      expect(cameraState.pitch, equals(1.5)); // Clamped to max
      expect(cameraState.pitch, lessThan(1.571)); // < 90 degrees (π/2)

      cameraState.resetView();
      cameraState.rotate(0.0, -5.0); // Try to pitch way down
      expect(cameraState.pitch, equals(-1.5)); // Clamped to min
      expect(cameraState.pitch, greaterThan(-1.571)); // > -90 degrees
    });

    test('setCameraParameters clamps pitch values', () {
      // Test that direct parameter setting also clamps pitch
      cameraState.setCameraParameters(pitch: 3.0);
      expect(cameraState.pitch, equals(1.5)); // Clamped to max

      cameraState.setCameraParameters(pitch: -3.0);
      expect(cameraState.pitch, equals(-1.5)); // Clamped to min

      cameraState.setCameraParameters(pitch: 0.5);
      expect(cameraState.pitch, equals(0.5)); // Within bounds
    });

    test('Multiple operations should work correctly', () {
      cameraState.zoom(0.1); // 10% increase
      cameraState.rotate(0.5, 0.3);
      cameraState.toggleAutoRotate();
      cameraState.selectBody(2);

      expect(
        cameraState.distance,
        equals(300.0 * 1.1),
      ); // Updated to current default
      expect(cameraState.yaw, equals(0.6 + 0.5));
      expect(cameraState.pitch, equals(0.3 + 0.3));
      expect(cameraState.autoRotate, isTrue);
      expect(cameraState.selectedBody, equals(2));
    });

    group('applySnapshot', () {
      test('should apply all camera properties from snapshot', () {
        final snapshot = CameraSnapshot(
          yaw: 1.2,
          pitch: 0.5,
          roll: 0.1,
          distance: 600.0,
          target: vm.Vector3(10.0, 20.0, 30.0),
          followMode: true,
          followedBodyIndex: 2,
          selectedBody: 1,
          autoRotate: true,
          fieldOfView: 75.0,
        );

        cameraState.applySnapshot(snapshot);

        expect(cameraState.yaw, equals(1.2));
        expect(cameraState.pitch, equals(0.5));
        expect(cameraState.roll, equals(0.1));
        expect(cameraState.distance, equals(600.0));
        expect(cameraState.target.x, equals(10.0));
        expect(cameraState.target.y, equals(20.0));
        expect(cameraState.target.z, equals(30.0));
        expect(cameraState.followMode, isTrue);
        expect(cameraState.followedBodyIndex, equals(2));
        expect(cameraState.selectedBody, equals(1));
        expect(cameraState.autoRotate, isTrue);
        expect(cameraState.fieldOfView, equals(75.0));
      });

      test('should clamp pitch values within bounds', () {
        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 3.0, // Exceeds max
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        cameraState.applySnapshot(snapshot);

        expect(cameraState.pitch, equals(1.5)); // Clamped to max
      });

      test('should clamp distance values within bounds', () {
        final snapshotMin = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 1.0, // Below min
          target: vm.Vector3.zero(),
          followMode: false,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        cameraState.applySnapshot(snapshotMin);
        expect(cameraState.distance, equals(5.0)); // Clamped to min

        final snapshotMax = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 5000.0, // Above max
          target: vm.Vector3.zero(),
          followMode: false,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        cameraState.applySnapshot(snapshotMax);
        expect(cameraState.distance, equals(2000.0)); // Clamped to max
      });

      test('should clamp field of view within bounds', () {
        final snapshotMin = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          autoRotate: false,
          fieldOfView: 10.0, // Below min
        );

        cameraState.applySnapshot(snapshotMin);
        expect(cameraState.fieldOfView, equals(30.0)); // Clamped to min

        final snapshotMax = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          autoRotate: false,
          fieldOfView: 150.0, // Above max
        );

        cameraState.applySnapshot(snapshotMax);
        expect(cameraState.fieldOfView, equals(120.0)); // Clamped to max
      });

      test('should notify listeners', () {
        var notified = false;
        cameraState.addListener(() {
          notified = true;
        });

        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        cameraState.applySnapshot(snapshot);

        expect(notified, isTrue);
      });

      test('should handle null optional fields', () {
        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          followedBodyIndex: null,
          selectedBody: null,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        cameraState.applySnapshot(snapshot);

        expect(cameraState.followedBodyIndex, isNull);
        expect(cameraState.selectedBody, isNull);
      });
    });
  });
}
