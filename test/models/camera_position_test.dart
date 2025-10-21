import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/camera_position.dart';

void main() {
  group('CameraPosition Tests', () {
    test('Should create CameraPosition with required distance', () {
      const cameraPosition = CameraPosition(distance: 100.0);

      expect(cameraPosition.distance, equals(100.0));
      expect(cameraPosition.yaw, equals(0.0));
      expect(cameraPosition.pitch, equals(0.0));
      expect(cameraPosition.roll, equals(0.0));
      expect(cameraPosition.targetX, equals(0.0));
      expect(cameraPosition.targetY, equals(0.0));
      expect(cameraPosition.targetZ, equals(0.0));
    });

    test('Should create CameraPosition with all parameters', () {
      const cameraPosition = CameraPosition(
        distance: 250.0,
        yaw: 0.5,
        pitch: -0.3,
        roll: 0.1,
        targetX: 10.0,
        targetY: -5.0,
        targetZ: 15.0,
      );

      expect(cameraPosition.distance, equals(250.0));
      expect(cameraPosition.yaw, equals(0.5));
      expect(cameraPosition.pitch, equals(-0.3));
      expect(cameraPosition.roll, equals(0.1));
      expect(cameraPosition.targetX, equals(10.0));
      expect(cameraPosition.targetY, equals(-5.0));
      expect(cameraPosition.targetZ, equals(15.0));
    });

    test('Should have proper default values', () {
      const cameraPosition = CameraPosition(
        distance: 300.0,
        yaw: 1.0, // Override one default
      );

      expect(cameraPosition.distance, equals(300.0));
      expect(cameraPosition.yaw, equals(1.0));
      // Check other defaults still apply
      expect(cameraPosition.pitch, equals(0.0));
      expect(cameraPosition.roll, equals(0.0));
      expect(cameraPosition.targetX, equals(0.0));
      expect(cameraPosition.targetY, equals(0.0));
      expect(cameraPosition.targetZ, equals(0.0));
    });

    test('Should handle negative values properly', () {
      const cameraPosition = CameraPosition(
        distance: 100.0,
        yaw: -0.5,
        pitch: -1.2,
        roll: -0.8,
        targetX: -100.0,
        targetY: -200.0,
        targetZ: -50.0,
      );

      expect(cameraPosition.distance, equals(100.0));
      expect(cameraPosition.yaw, equals(-0.5));
      expect(cameraPosition.pitch, equals(-1.2));
      expect(cameraPosition.roll, equals(-0.8));
      expect(cameraPosition.targetX, equals(-100.0));
      expect(cameraPosition.targetY, equals(-200.0));
      expect(cameraPosition.targetZ, equals(-50.0));
    });

    test('Should handle extreme values', () {
      const cameraPosition = CameraPosition(
        distance: double.maxFinite,
        yaw: double.infinity,
        pitch: double.negativeInfinity,
        targetX: 999999.99,
      );

      expect(cameraPosition.distance, equals(double.maxFinite));
      expect(cameraPosition.yaw, equals(double.infinity));
      expect(cameraPosition.pitch, equals(double.negativeInfinity));
      expect(cameraPosition.targetX, equals(999999.99));
    });
  });
}
