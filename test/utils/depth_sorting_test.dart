import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/utils/painter_utils.dart';

void main() {
  group('Depth Sorting Tests', () {
    late vm.Matrix4 viewProjectionMatrix;

    setUp(() {
      // Create a simple perspective projection matrix
      // Camera at (0, 0, 10) looking toward negative z (origin at 0,0,0)
      final view = vm.Matrix4.identity();
      view.translateByVector3(vm.Vector3(0.0, 0.0, -10.0)); // Move camera back

      final projection = vm.makePerspectiveMatrix(
        vm.radians(45.0), // 45-degree field of view
        1.0, // aspect ratio
        0.1, // near plane
        1000.0, // far plane
      );

      viewProjectionMatrix = projection * view;
    });

    test('clipZ should return correct depth values', () {
      // Object closer to camera (at z = 5)
      final closeObject = vm.Vector3(0, 0, 5);
      final closeZ = PainterUtils.clipZ(viewProjectionMatrix, closeObject);

      // Object farther from camera (at z = -5)
      final farObject = vm.Vector3(0, 0, -5);
      final farZ = PainterUtils.clipZ(viewProjectionMatrix, farObject);

      // In clip space, closer objects should have smaller z values
      expect(closeZ, lessThan(farZ));
      expect(closeZ, isNot(equals(double.infinity)));
      expect(farZ, isNot(equals(double.infinity)));
    });

    test('clipZ should handle objects behind camera', () {
      // Object behind camera (at z = 15, camera is at z = 10)
      final behindCamera = vm.Vector3(0, 0, 15);
      final behindZ = PainterUtils.clipZ(viewProjectionMatrix, behindCamera);

      expect(behindZ, equals(double.infinity));
    });

    test('depth sorting should order back-to-front correctly', () {
      final positions = [
        vm.Vector3(0, 0, 5), // Close object
        vm.Vector3(0, 0, -5), // Far object
        vm.Vector3(0, 0, 0), // Middle object
      ];

      final indices = List.generate(positions.length, (i) => i);

      // Sort using the same logic as GravitonPainter
      indices.sort((a, b) {
        final za = PainterUtils.clipZ(viewProjectionMatrix, positions[a]);
        final zb = PainterUtils.clipZ(viewProjectionMatrix, positions[b]);

        // Handle infinity cases (objects behind camera)
        if (za == double.infinity && zb == double.infinity) return 0;
        if (za == double.infinity) return 1;
        if (zb == double.infinity) return -1;

        // Sort back-to-front (larger z first)
        return zb.compareTo(za);
      });

      // Should be ordered: far, middle, close (back-to-front for painting)
      expect(indices[0], equals(1)); // Far object (z = -5)
      expect(indices[1], equals(2)); // Middle object (z = 0)
      expect(indices[2], equals(0)); // Close object (z = 5)
    });

    test('depth sorting should handle objects behind camera', () {
      final positions = [
        vm.Vector3(0, 0, 5), // Close object (index 0)
        vm.Vector3(0, 0, 15), // Behind camera (index 1)
        vm.Vector3(0, 0, -5), // Far object (index 2)
      ];

      final indices = List.generate(positions.length, (i) => i);

      indices.sort((a, b) {
        final za = PainterUtils.clipZ(viewProjectionMatrix, positions[a]);
        final zb = PainterUtils.clipZ(viewProjectionMatrix, positions[b]);

        if (za == double.infinity && zb == double.infinity) return 0;
        if (za == double.infinity) return 1;
        if (zb == double.infinity) return -1;

        return zb.compareTo(za);
      });

      // Objects behind camera are rendered last (they have infinity z)
      // Order should be: far(2), close(0), behind_camera(1)
      expect(indices[2], equals(1)); // Behind camera object should be last
    });
  });
}
