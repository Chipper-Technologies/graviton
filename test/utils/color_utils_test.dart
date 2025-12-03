import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/color_utils.dart';
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
            color: AppColors.uiWhite, // Default color that should be overridden
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
            color: AppColors.uiWhite,
          );

          final result = ColorUtils.getBodyColor(body);
          expect(result, equals(AppColors.uiBlack));
        }
      });

      test('should return body default color for unknown bodies', () {
        const defaultColor = AppColors.uiRed;
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
          AppColors.uiWhite,
          AppColors.uiYellow,
          AppColors.uiWhite,
          AppColors.testLightGray,
        ];

        for (final color in lightColors) {
          final result = ColorUtils.getContrastingTextColor(color);
          expect(
            result,
            equals(AppColors.uiBlack),
            reason: 'Failed for color: $color',
          );
        }
      });

      test('should return white for dark backgrounds', () {
        const darkColors = [
          AppColors.uiBlack,
          AppColors.basicBlue,
          AppColors.uiBlack,
          AppColors.testDarkGray,
        ];

        for (final color in darkColors) {
          final result = ColorUtils.getContrastingTextColor(color);
          expect(
            result,
            equals(AppColors.uiWhite),
            reason: 'Failed for color: $color',
          );
        }
      });
    });

    group('withOpacity', () {
      test('should create color with specified opacity', () {
        const baseColor = AppColors.uiRed;
        const opacity = 0.5;

        final result = ColorUtils.withOpacity(baseColor, opacity);

        expect(result.r, equals(baseColor.r));
        expect(result.g, equals(baseColor.g));
        expect(result.b, equals(baseColor.b));
        expect(result.a, closeTo(opacity, 0.001));
      });

      test('should clamp opacity values', () {
        const baseColor = AppColors.primaryColor;

        // Test values outside valid range
        final resultNegative = ColorUtils.withOpacity(baseColor, -0.5);
        final resultOver = ColorUtils.withOpacity(baseColor, 1.5);

        expect(resultNegative.a, equals(0.0));
        expect(resultOver.a, equals(1.0));
      });
    });

    group('blendColors', () {
      test('should blend colors correctly', () {
        const color1 = AppColors.uiRed;
        const color2 = AppColors.basicBlue;

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
        const color1 = AppColors.testPureRed;
        const color2 = AppColors.testPureBlue;

        final resultNegative = ColorUtils.blendColors(color1, color2, -0.5);
        final resultOver = ColorUtils.blendColors(color1, color2, 1.5);

        expect(resultNegative, equals(color1));
        expect(resultOver, equals(color2));
      });
    });

    group('darken', () {
      test('should darken colors correctly', () {
        const baseColor = AppColors.testMediumGray;
        const factor = 0.5;

        final result = ColorUtils.darken(baseColor, factor);

        // Should be darker than original
        expect(result.r, lessThan(baseColor.r));
        expect(result.g, lessThan(baseColor.g));
        expect(result.b, lessThan(baseColor.b));
        expect(result.a, equals(baseColor.a)); // Alpha should remain same
      });

      test('should handle extreme darken values', () {
        const baseColor = AppColors.uiWhite;

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
        const baseColor = AppColors.testMediumGray;
        const factor = 0.5;

        final result = ColorUtils.lighten(baseColor, factor);

        // Should be lighter than original
        expect(result.r, greaterThan(baseColor.r));
        expect(result.g, greaterThan(baseColor.g));
        expect(result.b, greaterThan(baseColor.b));
        expect(result.a, equals(baseColor.a)); // Alpha should remain same
      });

      test('should handle extreme lighten values', () {
        const baseColor = AppColors.uiBlack;

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

    group('parseHexColor', () {
      test('should parse hex colors with # prefix correctly', () {
        final testCases = {
          '#FF0000': const Color(0xFFFF0000), // Red
          '#00FF00': const Color(0xFF00FF00), // Green
          '#0000FF': const Color(0xFF0000FF), // Blue
          '#FFFFFF': const Color(0xFFFFFFFF), // White
          '#000000': const Color(0xFF000000), // Black
          '#4FC3F7': const Color(
            0xFF4FC3F7,
          ), // Cyan (matches AppColors.hexPulsarCyan)
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.parseHexColor(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Failed to parse ${entry.key} correctly',
          );
        }
      });

      test('should parse hex colors without # prefix correctly', () {
        final testCases = {
          'FF0000': const Color(0xFFFF0000), // Red
          '00FF00': const Color(0xFF00FF00), // Green
          '0000FF': const Color(0xFF0000FF), // Blue
          'FFFFFF': const Color(0xFFFFFFFF), // White
          '000000': const Color(0xFF000000), // Black
          '4FC3F7': const Color(0xFF4FC3F7), // Cyan
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.parseHexColor(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Failed to parse ${entry.key} without # prefix',
          );
        }
      });

      test('should handle 8-digit hex colors with alpha channel', () {
        final testCases = {
          '#80FF0000': const Color(0x80FF0000), // Semi-transparent red
          '#FFFF0000': const Color(0xFFFF0000), // Opaque red
          '#0000FF00': const Color(0x0000FF00), // Transparent green
          '#CC4FC3F7': const Color(0xCC4FC3F7), // Semi-transparent cyan
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.parseHexColor(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Failed to parse 8-digit hex ${entry.key}',
          );
        }
      });

      test('should handle lowercase hex input', () {
        final testCases = {
          '#ff0000': const Color(0xFFFF0000), // Red
          'abc123': const Color(0xFFABC123), // Mixed case conversion
          '#4fc3f7': const Color(0xFF4FC3F7), // Lowercase cyan
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.parseHexColor(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Failed to parse lowercase hex ${entry.key}',
          );
        }
      });

      test('should throw ArgumentError for invalid hex formats', () {
        final invalidCases = [
          'invalid',
          '#GG0000', // Invalid hex character
          '12345', // Wrong length
          '#12345', // Wrong length
          '1234567', // Wrong length
          '#1234567', // Wrong length
          '', // Empty string
          '#', // Only prefix
        ];

        for (final invalidHex in invalidCases) {
          expect(
            () => ColorUtils.parseHexColor(invalidHex),
            throwsA(isA<ArgumentError>()),
            reason: 'Should throw ArgumentError for invalid input: $invalidHex',
          );
        }
      });

      test('should handle edge case hex values', () {
        final testCases = {
          '#000000': const Color(0xFF000000), // Minimum RGB
          '#FFFFFF': const Color(0xFFFFFFFF), // Maximum RGB
          '#808080': const Color(0xFF808080), // Middle gray
          '#FF000000': const Color(0xFF000000), // Fully opaque black
          '#00000000': const Color(0x00000000), // Fully transparent
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.parseHexColor(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Failed to parse edge case ${entry.key}',
          );
        }
      });
    });

    group('colorToHex', () {
      test('should convert colors to correct hex format with alpha', () {
        final testCases = {
          const Color(0xFFFF0000): '#FFFF0000', // Opaque red
          const Color(0xFF00FF00): '#FF00FF00', // Opaque green
          const Color(0xFF0000FF): '#FF0000FF', // Opaque blue
          const Color(0xFFFFFFFF): '#FFFFFFFF', // Opaque white
          const Color(0xFF000000): '#FF000000', // Opaque black
          const Color(0x80FF0000): '#80FF0000', // Semi-transparent red
          const Color(0x00000000): '#00000000', // Fully transparent
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.colorToHex(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Failed to convert ${entry.key} to hex correctly',
          );
        }
      });

      test('should produce output compatible with parseHexColor', () {
        final originalColors = [
          const Color(0xFFFF0000), // Red
          const Color(0xFF4FC3F7), // Cyan
          const Color(0x80808080), // Semi-transparent gray
          const Color(0xFFABC123), // Custom color
        ];

        for (final original in originalColors) {
          final hexString = ColorUtils.colorToHex(original);
          final parsed = ColorUtils.parseHexColor(hexString);
          expect(
            parsed,
            equals(original),
            reason: 'Round-trip conversion failed for $original',
          );
        }
      });
    });

    group('colorToHexRGB', () {
      test('should convert colors to RGB hex format without alpha', () {
        final testCases = {
          const Color(0xFFFF0000): '#FF0000', // Red (ignore alpha)
          const Color(0x80FF0000):
              '#FF0000', // Semi-transparent red -> solid red
          const Color(0xFF00FF00): '#00FF00', // Green
          const Color(0xFF0000FF): '#0000FF', // Blue
          const Color(0xFFFFFFFF): '#FFFFFF', // White
          const Color(0xFF000000): '#000000', // Black
          const Color(0x004FC3F7): '#4FC3F7', // Transparent cyan -> solid cyan
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.colorToHexRGB(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Failed to convert ${entry.key} to RGB hex correctly',
          );
        }
      });

      test('should ignore alpha channel completely', () {
        final sameColorDifferentAlpha = [
          const Color(0x00FF0000), // Transparent red
          const Color(0x80FF0000), // Semi-transparent red
          const Color(0xFFFF0000), // Opaque red
        ];

        final expectedHex = '#FF0000';
        for (final color in sameColorDifferentAlpha) {
          final result = ColorUtils.colorToHexRGB(color);
          expect(
            result,
            equals(expectedHex),
            reason: 'RGB conversion should ignore alpha for $color',
          );
        }
      });

      test(
        'should produce 6-character hex output compatible with scenario data',
        () {
          // Test colors that match predefined scenario hex constants
          final scenarioColors = {
            const Color(0xFF4FC3F7): '#4FC3F7', // Pulsar cyan
            const Color(0xFFE91E63): '#E91E63', // Neutron star pink
            const Color(0xFFFFD700): '#FFD700', // Sun gold
            const Color(0xFFFFA500): '#FFA500', // Jupiter orange
          };

          for (final entry in scenarioColors.entries) {
            final result = ColorUtils.colorToHexRGB(entry.key);
            expect(
              result,
              equals(entry.value),
              reason: 'Scenario color conversion failed for ${entry.key}',
            );
          }
        },
      );
    });

    group('scenario color utilities integration', () {
      test('should convert AppColors to hex strings for scenario bodies', () {
        // Test that ColorUtils.colorToHexRGB works with scenario body colors
        final scenarioColors = {
          AppColors.pulsarCyan: '#4FC3F7', // Pulsar cyan
          AppColors.habitabilityHighRadiation: '#E91E63', // Neutron star pink
          AppColors.celestialGold: '#FFD700', // Sun gold
          AppColors.temperatureHot: '#FFA500', // Jupiter orange
          AppColors.asteroidRockyBrown: '#8B7355', // Asteroid brown
          AppColors.asteroidSienna: '#A0522D', // Asteroid sienna
        };

        for (final entry in scenarioColors.entries) {
          final hexString = ColorUtils.colorToHexRGB(entry.key);
          expect(
            hexString,
            equals(entry.value),
            reason: 'Failed to convert ${entry.key} to hex string',
          );
        }
      });

      test('should handle real scenario body color parsing', () {
        // Test the actual use case: parsing body colors from scenario data
        const testBodyColors = [
          '4FC3F7', // Pulsar cyan (without #)
          '#E91E63', // Neutron star pink (with #)
          'FFD700', // Sun gold
          '#FFA500', // Jupiter orange
        ];

        for (final colorHex in testBodyColors) {
          expect(
            () => ColorUtils.parseHexColor(colorHex),
            returnsNormally,
            reason: 'Should parse scenario body color $colorHex without errors',
          );

          final parsed = ColorUtils.parseHexColor(colorHex);
          expect(
            (parsed.a * 255.0).round() & 0xff,
            greaterThan(0),
            reason: 'Parsed color should be visible (non-zero alpha)',
          );
        }
      });
    });

    group('withAlpha', () {
      test('should create color with specified alpha', () {
        const baseColor = Color(0xFFFFFFFF); // White
        const alpha = 0.5;

        final result = ColorUtils.withAlpha(baseColor, alpha);

        expect(result.a, equals(alpha));
        expect(result.r, equals(baseColor.r));
        expect(result.g, equals(baseColor.g));
        expect(result.b, equals(baseColor.b));
      });

      test('should handle alpha values at boundaries', () {
        const baseColor = Color(0xFF123456);

        // Test alpha = 0 (fully transparent)
        final transparent = ColorUtils.withAlpha(baseColor, 0.0);
        expect(transparent.a, equals(0.0));

        // Test alpha = 1 (fully opaque)
        final opaque = ColorUtils.withAlpha(baseColor, 1.0);
        expect(opaque.a, equals(1.0));
      });

      test('should clamp alpha values outside valid range', () {
        const baseColor = Color(0xFF123456);

        // Test alpha > 1.0 gets clamped to 1.0
        final tooHigh = ColorUtils.withAlpha(baseColor, 1.5);
        expect(tooHigh.a, equals(1.0));

        // Test alpha < 0.0 gets clamped to 0.0
        final tooLow = ColorUtils.withAlpha(baseColor, -0.5);
        expect(tooLow.a, equals(0.0));
      });

      test('should preserve RGB values with different alpha', () {
        const red = Color(0xFFFF0000);
        const alpha = 0.75;

        final result = ColorUtils.withAlpha(red, alpha);

        expect(result.r, equals(red.r));
        expect(result.g, equals(red.g));
        expect(result.b, equals(red.b));
        expect(result.a, equals(alpha));
      });
    });

    group('createGlowGradient', () {
      test('should create gradient with proper color stops', () {
        const centerColor = Color(0xFF00FF00); // Green
        const edgeColor = Color(0xFF0000FF); // Blue

        final gradient = ColorUtils.createGlowGradient(centerColor, edgeColor);

        expect(gradient, isA<RadialGradient>());
        expect(gradient.colors, hasLength(5));
        expect(gradient.stops, hasLength(5));

        // First color should be the center color
        expect(gradient.colors[0], equals(centerColor));

        // Last color should be transparent
        expect(gradient.colors[4], equals(AppColors.transparentColor));

        // Stops should be in ascending order
        expect(gradient.stops![0], equals(0.0));
        expect(gradient.stops![1], equals(0.3));
        expect(gradient.stops![2], equals(0.6));
        expect(gradient.stops![3], equals(0.8));
        expect(gradient.stops![4], equals(1.0));
      });

      test('should create gradient with alpha variation', () {
        const centerColor = Color(0xFFFF0000); // Red
        const edgeColor = Color(0xFF00FF00); // Green

        final gradient = ColorUtils.createGlowGradient(centerColor, edgeColor);

        // Alpha should decrease through the gradient using AppTypography constants
        expect(gradient.colors[0].a, equals(1.0)); // Center - full alpha
        expect(
          gradient.colors[1].a,
          equals(AppTypography.opacityMedium),
        ); // First fade (0.5)
        expect(
          gradient.colors[2].a,
          equals(AppTypography.opacityVeryFaint),
        ); // Second fade (0.2)
        expect(
          gradient.colors[3].a,
          equals(AppTypography.opacityTransparent),
        ); // Edge fade (0.0)
        expect(gradient.colors[4].a, equals(0.0)); // Transparent
      });
    });

    group('getHabitabilityColor', () {
      test('should return correct colors for all habitability statuses', () {
        final testCases = {
          HabitabilityStatus.habitable: AppColors.habitabilityHabitable,
          HabitabilityStatus.tooHot: AppColors.habitabilityTooHot,
          HabitabilityStatus.tooCold: AppColors.habitabilityTooCold,
          HabitabilityStatus.gasGiant: AppColors.habitabilityGasGiant,
          HabitabilityStatus.tooSmall: AppColors.habitabilityTooSmall,
          HabitabilityStatus.noAtmosphere: AppColors.habitabilityNoAtmosphere,
          HabitabilityStatus.toxicAtmosphere:
              AppColors.habitabilityToxicAtmosphere,
          HabitabilityStatus.highRadiation: AppColors.habitabilityHighRadiation,
          HabitabilityStatus.tidallyLocked: AppColors.habitabilityTidallyLocked,
          HabitabilityStatus.extremeGravity:
              AppColors.habitabilityExtremeGravity,
          HabitabilityStatus.unknown: AppColors.habitabilityUnknown,
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.getHabitabilityColor(entry.key);
          final expected = Color(entry.value.toARGB32());

          expect(
            result,
            equals(expected),
            reason: 'Color mismatch for ${entry.key}',
          );
        }
      });

      test('should support all habitability status types', () {
        // Ensure all 11 habitability status types are supported
        final allStatuses = HabitabilityStatus.values;
        expect(
          allStatuses.length,
          equals(11),
          reason: 'All habitability statuses should be covered',
        );

        for (final status in allStatuses) {
          final result = ColorUtils.getHabitabilityColor(status);
          expect(
            result,
            isA<Color>(),
            reason: 'Should return valid color for $status',
          );
        }
      });
    });

    group('getTemperatureColor', () {
      test('should return correct colors for temperature ranges', () {
        // Test red dwarf / cool objects (< 3500K)
        expect(
          ColorUtils.getTemperatureColor(3000),
          equals(AppColors.uiRed),
          reason: 'Cool objects should be red',
        );

        // Test orange / K-type stars (3500-5000K)
        expect(
          ColorUtils.getTemperatureColor(4000),
          equals(AppColors.uiOrangeAccent),
          reason: 'K-type stars should be orange',
        );

        // Test yellow / G-type stars (5000-6000K)
        expect(
          ColorUtils.getTemperatureColor(5500),
          equals(AppColors.offScreenSun),
          reason: 'G-type stars should be yellow',
        );

        // Test white / F-type stars (6000-7500K)
        expect(
          ColorUtils.getTemperatureColor(6500),
          equals(AppColors.uiWhite),
          reason: 'F-type stars should be white',
        );

        // Test blue-white / A-type stars (7500-10000K)
        expect(
          ColorUtils.getTemperatureColor(8000),
          equals(AppColors.basicBlue),
          reason: 'A-type stars should be blue-white',
        );

        // Test blue / B and O-type stars (> 10000K)
        expect(
          ColorUtils.getTemperatureColor(15000),
          equals(AppColors.uiCyanAccent),
          reason: 'Hot stars should be blue-cyan',
        );
      });

      test('should handle boundary temperature values', () {
        // Test exact boundary values
        expect(
          ColorUtils.getTemperatureColor(3500),
          equals(AppColors.uiOrangeAccent),
          reason: '3500K should be orange (boundary)',
        );

        expect(
          ColorUtils.getTemperatureColor(5000),
          equals(AppColors.offScreenSun),
          reason: '5000K should be yellow (boundary)',
        );

        expect(
          ColorUtils.getTemperatureColor(10000),
          equals(AppColors.uiCyanAccent),
          reason: '10000K should be cyan (boundary)',
        );
      });

      test('should handle extreme temperature values', () {
        // Test very low temperatures
        expect(
          ColorUtils.getTemperatureColor(100),
          equals(AppColors.uiRed),
          reason: 'Very low temperatures should be red',
        );

        // Test very high temperatures
        expect(
          ColorUtils.getTemperatureColor(50000),
          equals(AppColors.uiCyanAccent),
          reason: 'Very high temperatures should be cyan',
        );
      });
    });

    group('getPlanetColor', () {
      test('should return correct colors for solar system planets', () {
        final testCases = {
          'sun': AppColors.offScreenSun,
          'sol': AppColors.offScreenSun,
          'mercury': AppColors.offScreenMercury,
          'venus': AppColors.offScreenVenus,
          'earth': AppColors.offScreenEarth,
          'terra': AppColors.offScreenEarth,
          'mars': AppColors.offScreenMars,
          'jupiter': AppColors.offScreenJupiter,
          'saturn': AppColors.offScreenSaturn,
          'uranus': AppColors.offScreenUranus,
          'neptune': AppColors.offScreenNeptune,
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.getPlanetColor(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Color mismatch for ${entry.key}',
          );
        }
      });

      test('should return correct colors for special celestial objects', () {
        final testCases = {
          'moon': AppColors.uiTextGrey,
          'luna': AppColors.uiTextGrey,
          'pulsar': AppColors.uiCyanAccent,
          'neutron star': AppColors.uiCyanAccent,
          'black hole': AppColors.offScreenBlackHole,
        };

        for (final entry in testCases.entries) {
          final result = ColorUtils.getPlanetColor(entry.key);
          expect(
            result,
            equals(entry.value),
            reason: 'Color mismatch for ${entry.key}',
          );
        }
      });

      test('should handle case insensitive input', () {
        // Test mixed case
        expect(
          ColorUtils.getPlanetColor('EARTH'),
          equals(AppColors.offScreenEarth),
          reason: 'Should handle uppercase',
        );

        expect(
          ColorUtils.getPlanetColor('Mars'),
          equals(AppColors.offScreenMars),
          reason: 'Should handle mixed case',
        );

        expect(
          ColorUtils.getPlanetColor(' jupiter '),
          equals(AppColors.offScreenJupiter),
          reason: 'Should handle extra whitespace',
        );
      });

      test('should return correct colors for object types', () {
        // Test asteroid variants
        expect(
          ColorUtils.getPlanetColor('asteroid belt'),
          equals(AppColors.offScreenMercury),
          reason: 'Asteroids should use Mercury brown/gray',
        );

        expect(
          ColorUtils.getPlanetColor('small asteroid'),
          equals(AppColors.offScreenMercury),
          reason: 'Asteroid objects should use Mercury color',
        );

        // Test comet variants
        expect(
          ColorUtils.getPlanetColor('halley comet'),
          equals(AppColors.accretionWhite),
          reason: 'Comets should use icy white color',
        );

        // Test dwarf planets
        expect(
          ColorUtils.getPlanetColor('dwarf planet'),
          equals(AppColors.uiTextGrey),
          reason: 'Dwarf planets should use gray color',
        );
      });

      test('should return default color for unknown objects', () {
        final unknownObjects = [
          'unknown_planet',
          '',
          'random_name',
          'new_discovery',
          'exoplanet',
        ];

        for (final name in unknownObjects) {
          final result = ColorUtils.getPlanetColor(name);
          expect(
            result,
            equals(AppColors.primaryColor),
            reason: 'Unknown objects should use primary color',
          );
        }
      });
    });
  });
}
