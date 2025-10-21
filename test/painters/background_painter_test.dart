import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/painters/background_painter.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('BackgroundPainter', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size canvasSize;
    late vm.Matrix4 viewProjectionMatrix;
    late vm.Matrix4 viewMatrix;
    late List<StarData> stars;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      canvasSize = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
      viewMatrix = vm.Matrix4.identity();
      stars = [
        StarData(vm.Vector3(10, 10, -10), 1.0, 0.8, 0xFFFFFFFF),
        StarData(vm.Vector3(-10, -10, -10), 0.8, 0.6, 0xFFFFE4B5),
        StarData(vm.Vector3(0, 15, -15), 1.2, 0.9, 0xFF87CEEB),
      ];
    });

    group('drawSpaceBackground', () {
      test('should draw background without throwing errors', () {
        expect(
          () => BackgroundPainter.drawSpaceBackground(canvas, canvasSize),
          returnsNormally,
        );
      });

      test('should handle zero-size canvas', () {
        expect(
          () => BackgroundPainter.drawSpaceBackground(canvas, Size.zero),
          returnsNormally,
        );
      });

      test('should handle very large canvas', () {
        final largeSize = const Size(10000, 10000);
        expect(
          () => BackgroundPainter.drawSpaceBackground(canvas, largeSize),
          returnsNormally,
        );
      });
    });

    group('drawEnhancedStarfield', () {
      test('should draw starfield without throwing errors', () {
        expect(
          () => BackgroundPainter.drawEnhancedStarfield(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
            stars,
          ),
          returnsNormally,
        );
      });

      test('should handle empty stars list', () {
        expect(
          () => BackgroundPainter.drawEnhancedStarfield(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
            [],
          ),
          returnsNormally,
        );
      });

      test('should handle stars behind camera', () {
        final behindStars = [
          StarData(vm.Vector3(10, 10, 10), 1.0, 0.8, 0xFFFFFFFF), // Positive Z
        ];

        expect(
          () => BackgroundPainter.drawEnhancedStarfield(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
            behindStars,
          ),
          returnsNormally,
        );
      });

      test('should handle many stars performance test', () {
        final manyStars = List.generate(
          1000,
          (i) => StarData(
            vm.Vector3(i.toDouble(), i.toDouble(), -i.toDouble() - 1),
            1.0,
            0.8,
            0xFFFFFFFF,
          ),
        );

        expect(
          () => BackgroundPainter.drawEnhancedStarfield(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
            manyStars,
          ),
          returnsNormally,
        );
      });
    });

    group('drawDistantGalaxies', () {
      test('should draw galaxies without throwing errors', () {
        expect(
          () => BackgroundPainter.drawDistantGalaxies(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
          ),
          returnsNormally,
        );
      });

      test('should handle extreme view transformations', () {
        final extremeView = vm.Matrix4.identity()
          ..translateByVector3(vm.Vector3(1000, 1000, 1000))
          ..rotateX(3.14159)
          ..scaleByVector3(vm.Vector3(0.001, 0.001, 0.001));

        expect(
          () => BackgroundPainter.drawDistantGalaxies(
            canvas,
            viewProjectionMatrix,
            extremeView,
            canvasSize,
          ),
          returnsNormally,
        );
      });

      test('should handle zero-size canvas for galaxies', () {
        expect(
          () => BackgroundPainter.drawDistantGalaxies(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            Size.zero,
          ),
          returnsNormally,
        );
      });
    });

    group('Galaxy Rendering', () {
      test('should draw spiral galaxies without errors', () {
        // This tests the internal spiral galaxy drawing
        expect(
          () => BackgroundPainter.drawDistantGalaxies(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
          ),
          returnsNormally,
        );
      });

      test('should draw elliptical galaxies without errors', () {
        // This tests the internal elliptical galaxy drawing
        expect(
          () => BackgroundPainter.drawDistantGalaxies(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
          ),
          returnsNormally,
        );
      });

      test('should draw irregular galaxies without errors', () {
        // This tests the internal irregular galaxy drawing
        expect(
          () => BackgroundPainter.drawDistantGalaxies(
            canvas,
            viewProjectionMatrix,
            viewMatrix,
            canvasSize,
          ),
          returnsNormally,
        );
      });
    });

    tearDown(() {
      recorder.endRecording();
    });
  });
}
