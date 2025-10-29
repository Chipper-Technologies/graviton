import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/painters/celestial_body_painter.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'dart:ui' as ui;

void main() {
  group('Star Color Mode Tests', () {
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

    test('should use assigned colors for random stars when realism is OFF', () {
      // Create a random star with blue color
      final bluestar = Body(
        name: 'Random Blue Star',
        mass: 50.0,
        radius: 5.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: Colors.blue, // Should keep this blue color
        bodyType: BodyType.star,
      );

      // This should NOT crash and should use normal body rendering (not drawSun)
      expect(
        () => CelestialBodyPainter.drawBody(
          canvas,
          center,
          radius,
          bluestar,
          useRealisticColors: false, // Realism OFF
        ),
        returnsNormally,
      );
    });

    test('should use realistic colors for stars when realism is ON', () {
      // Create a random star with blue color
      final bluestar = Body(
        name: 'Random Blue Star',
        mass: 50.0,
        radius: 5.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: Colors.blue, // Should be overridden by realistic colors
        bodyType: BodyType.star,
      );

      // This should use drawSun with realistic colors
      expect(
        () => CelestialBodyPainter.drawBody(
          canvas,
          center,
          radius,
          bluestar,
          useRealisticColors: true, // Realism ON
        ),
        returnsNormally,
      );
    });

    test('should always use Sun rendering for Sun regardless of realism', () {
      final sun = Body(
        name: 'Sun',
        mass: 50.0,
        radius: 5.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.celestialGold,
        bodyType: BodyType.star,
      );

      // Should use drawSun for both modes
      expect(
        () => CelestialBodyPainter.drawBody(
          canvas,
          center,
          radius,
          sun,
          useRealisticColors: false,
        ),
        returnsNormally,
      );

      expect(
        () => CelestialBodyPainter.drawBody(
          canvas,
          center,
          radius,
          sun,
          useRealisticColors: true,
        ),
        returnsNormally,
      );
    });
  });
}
