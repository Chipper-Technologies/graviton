import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/color_utils.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('ColorUtils Tests', () {
    group('getBodyColor', () {
      test('should return correct colors for solar system bodies', () {
        final testCases = {
          'Sun': AppColors.offScreenSun,
          'Mercury': AppColors.offScreenMercury,
          'Venus': AppColors.offScreenVenus,
          'Earth': AppColors.offScreenEarth,
          'Mars': AppColors.offScreenMars,
          'Jupiter': AppColors.offScreenJupiter,
          'Saturn': AppColors.offScreenSaturn,
          'Uranus': AppColors.offScreenUranus,
          'Neptune': AppColors.offScreenNeptune,
        };

        for (final entry in testCases.entries) {
          final body = Body(
            name: entry.key,
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 1.0,
            color: Colors.white, // Default color that should be overridden
          );

          final result = ColorUtils.getBodyColor(body);
          expect(
            result,
            equals(entry.value),
            reason: 'Color mismatch for ${entry.key}',
          );
        }
      });

      test('should return black for black holes', () {
        final testCases = ['Black Hole', 'Supermassive Black Hole'];

        for (final name in testCases) {
          final body = Body(
            name: name,
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 1.0,
            color: Colors.white,
          );

          final result = ColorUtils.getBodyColor(body);
          expect(result, equals(AppColors.uiBlack));
        }
      });

      test('should return body default color for unknown bodies', () {
        const defaultColor = Colors.red;
        final body = Body(
          name: 'Unknown Planet',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: defaultColor,
        );

        final result = ColorUtils.getBodyColor(body);
        expect(result, equals(defaultColor));
      });
    });

    group('getContrastingTextColor', () {
      test('should return black for light backgrounds', () {
        const lightColors = [
          Colors.white,
          Colors.yellow,
          Color(0xFFFFFFFF),
          Color(0xFFF0F0F0),
        ];

        for (final color in lightColors) {
          final result = ColorUtils.getContrastingTextColor(color);
          expect(
            result,
            equals(Colors.black),
            reason: 'Failed for color: $color',
          );
        }
      });

      test('should return white for dark backgrounds', () {
        const darkColors = [
          Colors.black,
          Colors.blue,
          Color(0xFF000000),
          Color(0xFF333333),
        ];

        for (final color in darkColors) {
          final result = ColorUtils.getContrastingTextColor(color);
          expect(
            result,
            equals(Colors.white),
            reason: 'Failed for color: $color',
          );
        }
      });
    });

    group('withOpacity', () {
      test('should create color with specified opacity', () {
        const baseColor = Colors.red;
        const opacity = 0.5;

        final result = ColorUtils.withOpacity(baseColor, opacity);

        expect(result.r, equals(baseColor.r));
        expect(result.g, equals(baseColor.g));
        expect(result.b, equals(baseColor.b));
        expect(result.a, closeTo(opacity, 0.001));
      });

      test('should clamp opacity values', () {
        const baseColor = Colors.blue;

        // Test values outside valid range
        final resultNegative = ColorUtils.withOpacity(baseColor, -0.5);
        final resultOver = ColorUtils.withOpacity(baseColor, 1.5);

        expect(resultNegative.a, equals(0.0));
        expect(resultOver.a, equals(1.0));
      });
    });

    group('blendColors', () {
      test('should blend colors correctly', () {
        const color1 = Color(0xFFFF0000); // Red
        const color2 = Color(0xFF0000FF); // Blue

        // At ratio 0, should return color1
        final result0 = ColorUtils.blendColors(color1, color2, 0.0);
        expect(result0, equals(color1));

        // At ratio 1, should return color2
        final result1 = ColorUtils.blendColors(color1, color2, 1.0);
        expect(result1, equals(color2));

        // At ratio 0.5, should be a blend
        final result05 = ColorUtils.blendColors(color1, color2, 0.5);
        expect(result05.r, lessThan(color1.r));
        expect(result05.b, greaterThan(color1.b));
      });

      test('should clamp ratio values', () {
        const color1 = Color(0xFFFF0000); // Red
        const color2 = Color(0xFF0000FF); // Blue

        final resultNegative = ColorUtils.blendColors(color1, color2, -0.5);
        final resultOver = ColorUtils.blendColors(color1, color2, 1.5);

        expect(resultNegative, equals(color1));
        expect(resultOver, equals(color2));
      });
    });

    group('darken', () {
      test('should darken colors correctly', () {
        const baseColor = Color(0xFF808080); // Medium gray
        const factor = 0.5;

        final result = ColorUtils.darken(baseColor, factor);

        // Should be darker than original
        expect(result.r, lessThan(baseColor.r));
        expect(result.g, lessThan(baseColor.g));
        expect(result.b, lessThan(baseColor.b));
        expect(result.a, equals(baseColor.a)); // Alpha should remain same
      });

      test('should handle extreme darken values', () {
        const baseColor = Colors.white;

        // Complete darkening should result in black
        final resultBlack = ColorUtils.darken(baseColor, 1.0);
        expect(resultBlack.r, equals(0.0));
        expect(resultBlack.g, equals(0.0));
        expect(resultBlack.b, equals(0.0));

        // No darkening should return original
        final resultOriginal = ColorUtils.darken(baseColor, 0.0);
        expect(resultOriginal.r, equals(baseColor.r));
        expect(resultOriginal.g, equals(baseColor.g));
        expect(resultOriginal.b, equals(baseColor.b));
      });
    });

    group('lighten', () {
      test('should lighten colors correctly', () {
        const baseColor = Color(0xFF808080); // Medium gray
        const factor = 0.5;

        final result = ColorUtils.lighten(baseColor, factor);

        // Should be lighter than original
        expect(result.r, greaterThan(baseColor.r));
        expect(result.g, greaterThan(baseColor.g));
        expect(result.b, greaterThan(baseColor.b));
        expect(result.a, equals(baseColor.a)); // Alpha should remain same
      });

      test('should handle extreme lighten values', () {
        const baseColor = Colors.black;

        // Complete lightening should result in white
        final resultWhite = ColorUtils.lighten(baseColor, 1.0);
        expect(resultWhite.r, closeTo(1.0, 0.01));
        expect(resultWhite.g, closeTo(1.0, 0.01));
        expect(resultWhite.b, closeTo(1.0, 0.01));

        // No lightening should return original
        final resultOriginal = ColorUtils.lighten(baseColor, 0.0);
        expect(resultOriginal.r, equals(baseColor.r));
        expect(resultOriginal.g, equals(baseColor.g));
        expect(resultOriginal.b, equals(baseColor.b));
      });
    });

    group('getIconColor', () {
      test('should return colors from predefined palette', () {
        final expectedColors = [
          AppColors.primaryColor,
          AppColors.uiCyanAccent,
          AppColors.uiOrangeAccent,
          AppColors.uiRed,
          AppColors.basicBlue,
          AppColors.uiGreen,
        ];

        for (int i = 0; i < expectedColors.length; i++) {
          final result = ColorUtils.getIconColor(i);
          expect(result, equals(expectedColors[i]));
        }
      });

      test('should cycle through colors for large indices', () {
        // Test cycling - index 6 should be same as index 0
        final result6 = ColorUtils.getIconColor(6);
        final result0 = ColorUtils.getIconColor(0);
        expect(result6, equals(result0));

        // Test larger cycling
        final result12 = ColorUtils.getIconColor(12);
        expect(result12, equals(result0));

        // Test index 7 should be same as index 1
        final result7 = ColorUtils.getIconColor(7);
        final result1 = ColorUtils.getIconColor(1);
        expect(result7, equals(result1));
      });

      test('should handle negative indices', () {
        // While negative indices might not be expected in normal usage,
        // the modulo operation should still work
        final resultNegative = ColorUtils.getIconColor(-1);
        expect(resultNegative, isA<Color>());
      });
    });
  });
}
