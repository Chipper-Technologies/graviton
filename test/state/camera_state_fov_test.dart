import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/camera_state.dart';

void main() {
  group('CameraState FOV and Visual Aids Tests', () {
    late CameraState cameraState;

    setUp(() {
      cameraState = CameraState();
    });

    group('Field of View', () {
      test('default FOV should be 60 degrees', () {
        expect(cameraState.fieldOfView, equals(60.0));
      });

      test('setFieldOfView should clamp values between 30 and 120 degrees', () {
        // Test minimum boundary
        cameraState.setFieldOfView(10.0);
        expect(cameraState.fieldOfView, equals(30.0));

        // Test maximum boundary
        cameraState.setFieldOfView(150.0);
        expect(cameraState.fieldOfView, equals(120.0));

        // Test valid value
        cameraState.setFieldOfView(75.0);
        expect(cameraState.fieldOfView, equals(75.0));
      });

      test('setFieldOfView should trigger notifyListeners', () {
        var notified = false;
        cameraState.addListener(() {
          notified = true;
        });

        cameraState.setFieldOfView(90.0);
        expect(notified, isTrue);
      });
    });

    group('Visual Aids', () {
      test('crosshairs should be disabled by default', () {
        expect(cameraState.showCrosshairs, isFalse);
      });

      test('toggleCrosshairs should toggle state and notify listeners', () {
        var notificationCount = 0;
        cameraState.addListener(() {
          notificationCount++;
        });

        expect(cameraState.showCrosshairs, isFalse);

        cameraState.toggleCrosshairs();
        expect(cameraState.showCrosshairs, isTrue);
        expect(notificationCount, equals(1));

        cameraState.toggleCrosshairs();
        expect(cameraState.showCrosshairs, isFalse);
        expect(notificationCount, equals(2));
      });
    });

    group('Dynamic FOV Calculations', () {
      test('FOV values are correctly stored and retrieved', () {
        // Test that different FOV values are stored correctly
        final testValues = [30.0, 45.0, 60.0, 90.0, 120.0];

        for (final fov in testValues) {
          cameraState.setFieldOfView(fov);
          expect(cameraState.fieldOfView, equals(fov));
        }
      });
    });
  });
}
