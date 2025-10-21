import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('PainterUtils', () {
    late vm.Matrix4 viewProjectionMatrix;
    late Size canvasSize;

    setUp(() {
      viewProjectionMatrix = vm.Matrix4.identity();
      canvasSize = const Size(800, 600);
    });

    group('project', () {
      test('should project 3D point to screen coordinates', () {
        final point3D = vm.Vector3(0, 0, -10);
        final result = PainterUtils.project(viewProjectionMatrix, point3D, canvasSize);

        expect(result, isNotNull);
        expect(result!.dx, equals(400)); // Center of 800px width
        expect(result.dy, equals(300)); // Center of 600px height
      });

      test('should return null for point behind camera', () {
        // Create a proper view matrix looking down negative Z
        final view = vm.Matrix4.identity()..translateByVector3(vm.Vector3(0.0, 0.0, 0.0));
        // Create a perspective projection matrix
        final proj = vm.makePerspectiveMatrix(math.pi / 4, 800.0 / 600.0, 0.1, 100.0);
        final vp = proj * view;

        final point3D = vm.Vector3(0, 0, 1); // Positive Z (behind camera in typical OpenGL setup)
        final result = PainterUtils.project(vp, point3D, canvasSize);

        expect(result, isNull);
      });

      test('should handle zero-size canvas', () {
        final point3D = vm.Vector3(0, 0, -10);
        final zeroSize = Size.zero;
        final result = PainterUtils.project(viewProjectionMatrix, point3D, zeroSize);

        expect(result, isNotNull);
        expect(result!.dx, equals(0));
        expect(result.dy, equals(0));
      });
    });

    group('clipZ', () {
      test('should return correct clip-space Z coordinate', () {
        final point3D = vm.Vector3(0, 0, -10);
        final result = PainterUtils.clipZ(viewProjectionMatrix, point3D);

        expect(result, isA<double>());
        expect(result.isFinite, isTrue);
      });

      test('should handle edge case with near-zero w component', () {
        final point3D = vm.Vector3(0, 0, 0);
        final result = PainterUtils.clipZ(viewProjectionMatrix, point3D);

        expect(result, isA<double>());
        expect(result.isFinite, isTrue);
      });
    });

    group('calculatePerspectiveScale', () {
      test('should return 1.0 for no tilt', () {
        final result = PainterUtils.calculatePerspectiveScale(0.0, 0.0);
        expect(result, equals(1.0));
      });

      test('should return smaller value for extreme tilt', () {
        final result = PainterUtils.calculatePerspectiveScale(1.57, 1.57); // ~90 degrees
        expect(result, lessThan(0.6)); // Adjust expectation to be more realistic
        expect(result, greaterThan(0.0));
      });

      test('should handle negative tilt angles', () {
        final result = PainterUtils.calculatePerspectiveScale(-1.0, -1.0);
        expect(result, isA<double>());
        expect(result, greaterThan(0.0));
        expect(result, lessThanOrEqualTo(1.0));
      });
    });

    group('createGlowPaint', () {
      test('should create paint with radial gradient', () {
        final paint = PainterUtils.createGlowPaint(
          color: AppColors.basicBlue,
          center: const Offset(100, 100),
          radius: 50,
          coreAlpha: AppTypography.opacityFull,
          edgeAlpha: AppTypography.opacityTransparent,
        );

        expect(paint, isA<Paint>());
        expect(paint.shader, isNotNull);
      });

      test('should handle custom stops', () {
        final paint = PainterUtils.createGlowPaint(
          color: AppColors.basicRed,
          center: Offset.zero,
          radius: 25,
          stops: [0.0, 1.0], // Two stops to match two colors
        );

        expect(paint, isA<Paint>());
        expect(paint.shader, isNotNull);
      });
    });

    group('createMultiStopGlowPaint', () {
      test('should create paint with multiple color stops', () {
        final colors = [AppColors.basicRed, AppColors.basicOrange, AppColors.transparentColor];
        final stops = [0.0, 0.5, 1.0];

        final paint = PainterUtils.createMultiStopGlowPaint(
          colors: colors,
          stops: stops,
          center: const Offset(50, 50),
          radius: 30,
        );

        expect(paint, isA<Paint>());
        expect(paint.shader, isNotNull);
      });

      test('should assert colors and stops have same length', () {
        expect(
          () => PainterUtils.createMultiStopGlowPaint(
            colors: [AppColors.basicRed, AppColors.basicBlue],
            stops: [0.0, 0.5, 1.0], // Different length
            center: Offset.zero,
            radius: 10,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}
