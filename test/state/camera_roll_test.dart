import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/camera_state.dart';

void main() {
  group('CameraState Roll Tests', () {
    late CameraState camera;

    setUp(() {
      camera = CameraState();
    });

    test('should start with zero roll', () {
      expect(camera.roll, equals(0.0));
    });

    test('should update roll correctly', () {
      final deltaRoll = math.pi / 4; // 45 degrees
      camera.rotateRoll(deltaRoll);

      expect(camera.roll, closeTo(deltaRoll, 0.001));
    });

    test('should accumulate roll values', () {
      final delta1 = math.pi / 6; // 30 degrees
      final delta2 = math.pi / 3; // 60 degrees

      camera.rotateRoll(delta1);
      camera.rotateRoll(delta2);

      expect(camera.roll, closeTo(delta1 + delta2, 0.001));
    });

    test('should normalize roll to 0-2π range', () {
      final largeRoll = 3 * math.pi; // 540 degrees
      camera.rotateRoll(largeRoll);

      // Should be normalized to π (180 degrees)
      expect(camera.roll, closeTo(math.pi, 0.001));
    });

    test('should handle negative roll values', () {
      final negativeRoll = -math.pi / 2; // -90 degrees
      camera.rotateRoll(negativeRoll);

      // Should be normalized to 3π/2 (270 degrees)
      expect(camera.roll, closeTo(3 * math.pi / 2, 0.001));
    });
  });
}
