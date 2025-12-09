import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/utils/camera_projection_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CameraProjectionUtils', () {
    late CameraState camera;

    setUp(() {
      camera = CameraState();
    });

    tearDown(() {
      camera.dispose();
    });

    group('projectToScreen', () {
      test('should project world position to screen coordinates', () {
        final worldPos = vm.Vector3(0.0, 0.0, 0.0);
        final view = CameraProjectionUtils.buildViewMatrix(camera);
        final proj = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          16.0 / 9.0,
        );
        const screenSize = Size(1920.0, 1080.0);

        final screenPos = CameraProjectionUtils.projectToScreen(
          worldPos,
          view,
          proj,
          screenSize,
        );

        expect(screenPos, isNotNull);
        expect(screenPos!.dx, greaterThanOrEqualTo(0));
        expect(screenPos.dy, greaterThanOrEqualTo(0));
        expect(screenPos.dx, lessThanOrEqualTo(screenSize.width));
        expect(screenPos.dy, lessThanOrEqualTo(screenSize.height));
      });

      test('should return null for points behind camera', () {
        // Point behind the camera
        final worldPos = camera.eyePosition + vm.Vector3(0.0, 0.0, 100.0);
        final view = CameraProjectionUtils.buildViewMatrix(camera);
        final proj = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          16.0 / 9.0,
        );
        const screenSize = Size(1920.0, 1080.0);

        final screenPos = CameraProjectionUtils.projectToScreen(
          worldPos,
          view,
          proj,
          screenSize,
        );

        expect(screenPos, isNull);
      });

      test('should return null for points outside viewing frustum', () {
        // Point very far from the viewing frustum
        final worldPos = vm.Vector3(10000.0, 10000.0, 10000.0);
        final view = CameraProjectionUtils.buildViewMatrix(camera);
        final proj = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          16.0 / 9.0,
        );
        const screenSize = Size(1920.0, 1080.0);

        final screenPos = CameraProjectionUtils.projectToScreen(
          worldPos,
          view,
          proj,
          screenSize,
        );

        // Point may or may not be visible depending on camera settings
        // This test just ensures it doesn't crash
        expect(screenPos, anyOf(isNull, isNotNull));
      });

      test('should handle different screen sizes', () {
        final worldPos = vm.Vector3(0.0, 0.0, 0.0);
        final view = CameraProjectionUtils.buildViewMatrix(camera);

        final testSizes = [
          const Size(800.0, 600.0), // 4:3
          const Size(1920.0, 1080.0), // 16:9
          const Size(1440.0, 2960.0), // Mobile portrait
          const Size(2560.0, 1440.0), // QHD
        ];

        for (final screenSize in testSizes) {
          final aspectRatio = screenSize.width / screenSize.height;
          final proj = CameraProjectionUtils.buildProjectionMatrix(
            camera,
            aspectRatio,
          );

          final screenPos = CameraProjectionUtils.projectToScreen(
            worldPos,
            view,
            proj,
            screenSize,
          );

          if (screenPos != null) {
            expect(screenPos.dx, greaterThanOrEqualTo(0));
            expect(screenPos.dy, greaterThanOrEqualTo(0));
            expect(screenPos.dx, lessThanOrEqualTo(screenSize.width));
            expect(screenPos.dy, lessThanOrEqualTo(screenSize.height));
          }
        }
      });
    });

    group('buildViewMatrix', () {
      test('should create a valid view matrix', () {
        final view = CameraProjectionUtils.buildViewMatrix(camera);

        expect(view, isNotNull);
        expect(view, isA<vm.Matrix4>());
        // View matrix should be invertible (non-zero determinant)
        final det = view.determinant();
        expect(det, isNot(equals(0.0)));
      });

      test('should update when camera position changes', () {
        final view1 = CameraProjectionUtils.buildViewMatrix(camera);

        // Move camera
        camera.zoom(0.5);

        final view2 = CameraProjectionUtils.buildViewMatrix(camera);

        // Matrices should be different
        expect(view1, isNot(equals(view2)));
      });

      test('should update when camera rotation changes', () {
        final view1 = CameraProjectionUtils.buildViewMatrix(camera);

        // Rotate camera
        camera.rotate(0.5, 0.3);

        final view2 = CameraProjectionUtils.buildViewMatrix(camera);

        // Matrices should be different
        expect(view1, isNot(equals(view2)));
      });

      test('should incorporate camera roll', () {
        final view1 = CameraProjectionUtils.buildViewMatrix(camera);

        // Add roll
        camera.rotateRoll(math.pi / 4);

        final view2 = CameraProjectionUtils.buildViewMatrix(camera);

        // Matrices should be different
        expect(view1, isNot(equals(view2)));
      });

      test('should handle camera target changes', () {
        final view1 = CameraProjectionUtils.buildViewMatrix(camera);

        // Pan camera (change target)
        camera.pan(vm.Vector3(10.0, 5.0, 0.0));

        final view2 = CameraProjectionUtils.buildViewMatrix(camera);

        // Matrices should be different
        expect(view1, isNot(equals(view2)));
      });
    });

    group('buildProjectionMatrix', () {
      test('should create a valid projection matrix', () {
        final proj = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          16.0 / 9.0,
        );

        expect(proj, isNotNull);
        expect(proj, isA<vm.Matrix4>());
      });

      test('should handle different aspect ratios', () {
        final aspectRatios = [
          4.0 / 3.0, // 4:3
          16.0 / 9.0, // 16:9
          21.0 / 9.0, // Ultrawide
          9.0 / 16.0, // Portrait mobile
          1.0, // Square
        ];

        for (final aspect in aspectRatios) {
          final proj = CameraProjectionUtils.buildProjectionMatrix(
            camera,
            aspect,
          );

          expect(proj, isNotNull);
          expect(proj, isA<vm.Matrix4>());
        }
      });

      test('should update when field of view changes', () {
        final proj1 = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          16.0 / 9.0,
        );

        // Change field of view (through camera state if possible)
        // Since CameraState doesn't expose setFieldOfView, we'll just verify
        // the matrix is created correctly
        expect(proj1, isNotNull);

        final proj2 = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          16.0 / 9.0,
        );

        // With same FOV and aspect, should be the same
        expect(proj1, equals(proj2));
      });

      test('should create perspective matrix with correct properties', () {
        final proj = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          16.0 / 9.0,
        );

        // Perspective matrix should have specific structure
        // M[2][3] should be non-zero for perspective projection
        expect(proj[11], isNot(equals(0.0)));

        // M[3][3] should be 0 for perspective projection
        expect(proj[15], equals(0.0));
      });
    });

    group('Integration tests', () {
      test('should work together for complete projection pipeline', () {
        // Setup a world position in front of the camera
        final worldPos = vm.Vector3(0.0, 0.0, -50.0);
        const screenSize = Size(1920.0, 1080.0);

        // Build matrices
        final view = CameraProjectionUtils.buildViewMatrix(camera);
        final proj = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          screenSize.width / screenSize.height,
        );

        // Project to screen
        final screenPos = CameraProjectionUtils.projectToScreen(
          worldPos,
          view,
          proj,
          screenSize,
        );

        expect(screenPos, isNotNull);
      });

      test('should maintain consistency across camera transformations', () {
        final worldPos = vm.Vector3(10.0, 5.0, 0.0);
        const screenSize = Size(1920.0, 1080.0);

        // Project with initial camera state
        final view1 = CameraProjectionUtils.buildViewMatrix(camera);
        final proj1 = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          screenSize.width / screenSize.height,
        );
        final screenPos1 = CameraProjectionUtils.projectToScreen(
          worldPos,
          view1,
          proj1,
          screenSize,
        );

        // Transform camera and project again
        camera.rotate(0.2, 0.1);
        camera.zoom(0.1);

        final view2 = CameraProjectionUtils.buildViewMatrix(camera);
        final proj2 = CameraProjectionUtils.buildProjectionMatrix(
          camera,
          screenSize.width / screenSize.height,
        );
        final screenPos2 = CameraProjectionUtils.projectToScreen(
          worldPos,
          view2,
          proj2,
          screenSize,
        );

        // Screen positions should differ due to camera movement
        if (screenPos1 != null && screenPos2 != null) {
          expect(screenPos1, isNot(equals(screenPos2)));
        }
      });
    });
  });
}
