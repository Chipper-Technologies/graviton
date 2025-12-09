import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/shared/painters/asteroid_belt_painter.dart';
import 'package:graviton/services/simulation/asteroid_belt_system.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('AsteroidBeltPainter Tests', () {
    late Canvas canvas;
    late PictureRecorder recorder;
    late AsteroidBeltSystem asteroidBelt;

    setUp(() {
      recorder = PictureRecorder();
      canvas = Canvas(recorder);
      asteroidBelt = AsteroidBeltSystem();
    });

    tearDown(() {
      recorder.endRecording();
    });

    test('should draw asteroid belt when enabled', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      // Generate a simple belt for testing
      asteroidBelt.generateBelt(
        innerRadius: 2.0,
        outerRadius: 5.0,
        particleCount: 100,
        centralMass: 1.0,
      );

      // This should not throw
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          true, // showAsteroidBelt
        );
      }, returnsNormally);
    });

    test('should not draw asteroid belt when disabled', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      asteroidBelt.generateBelt(
        innerRadius: 2.0,
        outerRadius: 5.0,
        particleCount: 100,
        centralMass: 1.0,
      );

      // This should not throw and should handle disabled state
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          false, // showAsteroidBelt disabled
        );
      }, returnsNormally);
    });

    test('should handle empty asteroid belt', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      // Empty belt (no generateBelt call)
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle different canvas sizes', () {
      final vp = vm.Matrix4.identity();
      asteroidBelt.generateBelt(
        innerRadius: 2.0,
        outerRadius: 5.0,
        particleCount: 50,
        centralMass: 1.0,
      );

      final sizes = [
        const Size(100, 100),
        const Size(800, 600),
        const Size(1920, 1080),
        const Size(1, 1),
      ];

      for (final size in sizes) {
        expect(() {
          AsteroidBeltPainter.drawAsteroidBelt(
            canvas,
            size,
            vp,
            asteroidBelt,
            true,
          );
        }, returnsNormally);
      }
    });

    test('should handle different view-projection matrices', () {
      const size = Size(800, 600);
      asteroidBelt.generateBelt(
        innerRadius: 2.0,
        outerRadius: 5.0,
        particleCount: 50,
        centralMass: 1.0,
      );

      // Identity matrix
      final identity = vm.Matrix4.identity();
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          identity,
          asteroidBelt,
          true,
        );
      }, returnsNormally);

      // Scaled matrix
      final scaled = vm.Matrix4.identity()
        ..scaleByVector3(vm.Vector3(2.0, 2.0, 2.0));
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          scaled,
          asteroidBelt,
          true,
        );
      }, returnsNormally);

      // Translated matrix
      final translated = vm.Matrix4.identity()
        ..translateByVector3(vm.Vector3(100.0, 100.0, 0.0));
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          translated,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle small asteroid belt', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      asteroidBelt.generateBelt(
        innerRadius: 1.0,
        outerRadius: 2.0,
        particleCount: 10,
        centralMass: 1.0,
      );

      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle large asteroid belt', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      asteroidBelt.generateBelt(
        innerRadius: 10.0,
        outerRadius: 50.0,
        particleCount: 1000,
        centralMass: 10.0,
      );

      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle very distant asteroid belts', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      // Create belt at extreme distance (like Kuiper belt)
      asteroidBelt.generateBelt(
        innerRadius: 1000.0,
        outerRadius: 2000.0,
        particleCount: 500,
        centralMass: 1.0,
      );

      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle zero-sized canvas', () {
      const size = Size(0, 0);
      final vp = vm.Matrix4.identity();

      asteroidBelt.generateBelt(
        innerRadius: 2.0,
        outerRadius: 5.0,
        particleCount: 50,
        centralMass: 1.0,
      );

      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle extreme view projection matrices', () {
      const size = Size(800, 600);
      asteroidBelt.generateBelt(
        innerRadius: 2.0,
        outerRadius: 5.0,
        particleCount: 50,
        centralMass: 1.0,
      );

      // Very large scale
      final largeScale = vm.Matrix4.identity()
        ..scaleByVector3(vm.Vector3(1000.0, 1000.0, 1000.0));
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          largeScale,
          asteroidBelt,
          true,
        );
      }, returnsNormally);

      // Very small scale
      final smallScale = vm.Matrix4.identity()
        ..scaleByVector3(vm.Vector3(0.001, 0.001, 0.001));
      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          smallScale,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle performance with many particles', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      // Test performance limits (above 1500 particle rendering limit)
      asteroidBelt.generateBelt(
        innerRadius: 2.0,
        outerRadius: 8.0,
        particleCount: 2000, // Above rendering limit to test cutoff
        centralMass: 1.0,
      );

      expect(() {
        AsteroidBeltPainter.drawAsteroidBelt(
          canvas,
          size,
          vp,
          asteroidBelt,
          true,
        );
      }, returnsNormally);
    });

    test('should handle different central mass values', () {
      const size = Size(800, 600);
      final vp = vm.Matrix4.identity();

      final massValues = [0.1, 1.0, 10.0, 100.0];

      for (final mass in massValues) {
        final testBelt = AsteroidBeltSystem();
        testBelt.generateBelt(
          innerRadius: 2.0,
          outerRadius: 5.0,
          particleCount: 100,
          centralMass: mass,
        );

        expect(() {
          AsteroidBeltPainter.drawAsteroidBelt(
            canvas,
            size,
            vp,
            testBelt,
            true,
          );
        }, returnsNormally);
      }
    });
  });
}
