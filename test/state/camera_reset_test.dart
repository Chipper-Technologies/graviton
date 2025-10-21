import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CameraState resetView Tests', () {
    late CameraState camera;

    setUp(() {
      camera = CameraState();
    });

    test('should reset all camera parameters to default values', () {
      // Modify camera state from defaults
      camera.rotate(1.0, 0.5); // Change yaw and pitch
      camera.rotateRoll(math.pi / 2); // Add roll rotation
      camera.zoom(0.5); // Change zoom (distance)
      camera.pan(vm.Vector3(10.0, 10.0, 10.0)); // Change target
      camera.selectBody(1); // Select a body

      // Verify camera state has changed
      expect(camera.yaw, isNot(equals(0.6)));
      expect(camera.pitch, isNot(equals(0.3)));
      expect(camera.roll, isNot(equals(0.0)));
      expect(camera.distance, isNot(equals(300.0)));

      // Reset view
      camera.resetView();

      // Verify all parameters are reset to defaults
      expect(camera.yaw, equals(0.6));
      expect(camera.pitch, equals(0.3));
      expect(camera.roll, equals(0.0)); // Roll should be reset to 0
      expect(
        camera.distance,
        equals(300.0),
      ); // Distance should be reset to default
      expect(camera.selectedBody, isNull);
      expect(camera.followMode, isFalse);
    });

    test('should reset roll specifically when called', () {
      // Add some roll rotation
      camera.rotateRoll(math.pi); // 180 degrees
      expect(camera.roll, closeTo(math.pi, 0.001));

      // Reset view
      camera.resetView();

      // Roll should be back to 0
      expect(camera.roll, equals(0.0));
    });

    test('should reset zoom to default distance', () {
      // Zoom in significantly
      camera.zoom(-0.8); // Zoom in a lot
      expect(camera.distance, lessThan(300.0));

      // Reset view
      camera.resetView();

      // Distance should be back to default
      expect(camera.distance, equals(300.0));
    });
  });
}
