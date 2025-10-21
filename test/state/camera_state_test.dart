import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/camera_state.dart';

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
      expect(cameraState.distance, greaterThanOrEqualTo(5.0)); // Updated to current minimum
    });

    test('Zoom should respect maximum distance', () {
      cameraState.zoom(10.0); // Try to zoom way out
      expect(cameraState.distance, lessThanOrEqualTo(2000.0)); // Updated to current maximum
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

    test('Pitch should accumulate rotation values', () {
      final initialPitch = cameraState.pitch;
      cameraState.rotate(0.0, 10.0); // Large pitch rotation
      expect(cameraState.pitch, closeTo(initialPitch + 10.0, 1e-10));

      cameraState.rotate(0.0, -5.0); // Negative pitch rotation
      expect(cameraState.pitch, closeTo(initialPitch + 5.0, 1e-10));
      expect(cameraState.pitch, greaterThanOrEqualTo(-1.5));
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
      expect(cameraState.autoRotateSpeed, equals(2.0));
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

    test('Multiple operations should work correctly', () {
      cameraState.zoom(0.1); // 10% increase
      cameraState.rotate(0.5, 0.3);
      cameraState.toggleAutoRotate();
      cameraState.selectBody(2);

      expect(cameraState.distance, equals(300.0 * 1.1)); // Updated to current default
      expect(cameraState.yaw, equals(0.6 + 0.5));
      expect(cameraState.pitch, equals(0.3 + 0.3));
      expect(cameraState.autoRotate, isTrue);
      expect(cameraState.selectedBody, equals(2));
    });
  });
}
