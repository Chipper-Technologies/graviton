import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/painters/celestial_body_painter.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('CelestialBodyPainter', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Offset center;
    late double radius;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      center = const Offset(100, 100);
      radius = 50.0;
    });

    group('drawBody', () {
      test('should draw normal body without errors', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, radius, body),
          returnsNormally,
        );
      });

      test('should draw black hole with special rendering', () {
        final blackHole = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 10.0,
          color: AppColors.uiBlack,
          name: 'Black Hole',
        );

        expect(
          () =>
              CelestialBodyPainter.drawBody(canvas, center, radius, blackHole),
          returnsNormally,
        );
      });

      test('should draw Sun with special rendering', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, radius, sun),
          returnsNormally,
        );
      });

      test('should draw all planets with special rendering', () {
        final planets = [
          'Mercury',
          'Venus',
          'Earth',
          'Mars',
          'Jupiter',
          'Saturn',
          'Uranus',
          'Neptune',
        ];

        for (final planetName in planets) {
          final planet = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 10.0,
            radius: 5.0,
            color: AppColors.basicBlue,
            name: planetName,
          );

          expect(
            () => CelestialBodyPainter.drawBody(canvas, center, radius, planet),
            returnsNormally,
            reason: 'Failed to draw $planetName',
          );
        }
      });
    });

    group('Individual Celestial Bodies', () {
      test('should draw black hole with accretion disk', () {
        expect(
          () => CelestialBodyPainter.drawBlackHole(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Sun with corona', () {
        final testBody = Body(
          name: 'Sun',
          mass: 1.989e30,
          radius: 6.96e8,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: Colors.yellow,
        );
        expect(
          () => CelestialBodyPainter.drawSun(canvas, center, radius, testBody),
          returnsNormally,
        );
      });

      test('should draw Mercury with craters', () {
        expect(
          () => CelestialBodyPainter.drawMercury(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Venus with atmosphere', () {
        expect(
          () => CelestialBodyPainter.drawVenus(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Earth with continents and atmosphere', () {
        expect(
          () => CelestialBodyPainter.drawEarth(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Mars with polar ice caps', () {
        expect(
          () => CelestialBodyPainter.drawMars(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Jupiter with Great Red Spot and bands', () {
        expect(
          () => CelestialBodyPainter.drawJupiter(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Saturn with rings', () {
        final saturn = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.basicYellow,
          name: 'Saturn',
        );
        expect(
          () => CelestialBodyPainter.drawSaturn(canvas, center, radius, saturn),
          returnsNormally,
        );
      });

      test('should draw Uranus with tilted rings', () {
        final uranus = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.basicCyan,
          name: 'Uranus',
        );
        expect(
          () => CelestialBodyPainter.drawUranus(canvas, center, radius, uranus),
          returnsNormally,
        );
      });

      test('should draw Neptune with Great Dark Spot', () {
        expect(
          () => CelestialBodyPainter.drawNeptune(canvas, center, radius),
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle zero radius', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, 0.0, body),
          returnsNormally,
        );
      });

      test('should handle very large radius', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, 1000.0, body),
          returnsNormally,
        );
      });

      test('should handle negative center coordinates', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            const Offset(-100, -100),
            radius,
            body,
          ),
          returnsNormally,
        );
      });

      test('should handle transparent colors', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue.withValues(
            alpha: AppTypography.opacityTransparent,
          ),
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, radius, body),
          returnsNormally,
        );
      });
    });

    tearDown(() {
      recorder.endRecording();
    });
  });
}
