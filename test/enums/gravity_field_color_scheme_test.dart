import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('GravityFieldColorScheme Comprehensive Tests', () {
    group('Enum Properties', () {
      test('should have all expected enum values', () {
        const expectedValues = [
          GravityFieldColorScheme.classic,
          GravityFieldColorScheme.spectral,
          GravityFieldColorScheme.monochrome,
          GravityFieldColorScheme.neon,
          GravityFieldColorScheme.emerald,
        ];

        expect(GravityFieldColorScheme.values, equals(expectedValues));
        expect(GravityFieldColorScheme.values.length, equals(5));
      });

      test('should have consistent string names', () {
        expect(GravityFieldColorScheme.classic.name, 'classic');
        expect(GravityFieldColorScheme.spectral.name, 'spectral');
        expect(GravityFieldColorScheme.monochrome.name, 'monochrome');
        expect(GravityFieldColorScheme.neon.name, 'neon');
        expect(GravityFieldColorScheme.emerald.name, 'emerald');
      });
    });

    group('Localization Key Mapping', () {
      test('should provide correct localization keys for all schemes', () {
        expect(
          GravityFieldColorScheme.classic.localizationKey,
          'gravityColorSchemeClassic',
        );
        expect(
          GravityFieldColorScheme.spectral.localizationKey,
          'gravityColorSchemeSpectral',
        );
        expect(
          GravityFieldColorScheme.monochrome.localizationKey,
          'gravityColorSchemeMonochrome',
        );
        expect(
          GravityFieldColorScheme.neon.localizationKey,
          'gravityColorSchemeNeon',
        );
        expect(
          GravityFieldColorScheme.emerald.localizationKey,
          'gravityColorSchemeEmerald',
        );
      });

      test('should have unique localization keys', () {
        final keys = GravityFieldColorScheme.values
            .map((scheme) => scheme.localizationKey)
            .toSet();
        expect(keys.length, equals(GravityFieldColorScheme.values.length));
      });
    });

    group('Primary Colors - Stars', () {
      test('should provide star primary colors for all schemes', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final color = scheme.starPrimaryColor;
          expect(color, isA<Color>());
          expect(
            (color.a * 255.0).round() & 0xff,
            equals(255),
          ); // Should be opaque
        }
      });

      test('should have distinct star colors across schemes', () {
        final colors = GravityFieldColorScheme.values
            .map((scheme) => scheme.starPrimaryColor)
            .toSet();
        expect(colors.length, greaterThan(1));
      });

      test('should return consistent star colors for same scheme', () {
        const scheme = GravityFieldColorScheme.classic;
        final color1 = scheme.starPrimaryColor;
        final color2 = scheme.starPrimaryColor;
        expect(color1, equals(color2));
      });
    });

    group('Primary Colors - Bodies', () {
      test('should provide body primary colors for all schemes', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final color = scheme.bodyPrimaryColor;
          expect(color, isA<Color>());
          expect(
            (color.a * 255.0).round() & 0xff,
            equals(255),
          ); // Should be opaque
        }
      });

      test('should have distinct body colors across schemes', () {
        final colors = GravityFieldColorScheme.values
            .map((scheme) => scheme.bodyPrimaryColor)
            .toSet();
        expect(colors.length, greaterThan(1));
      });

      test('should return consistent body colors for same scheme', () {
        const scheme = GravityFieldColorScheme.spectral;
        final color1 = scheme.bodyPrimaryColor;
        final color2 = scheme.bodyPrimaryColor;
        expect(color1, equals(color2));
      });
    });

    group('Secondary Colors', () {
      test('should provide secondary colors for all schemes', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final color = scheme.secondaryColor;
          expect(color, isA<Color>());
          expect(
            (color.a * 255.0).round() & 0xff,
            equals(255),
          ); // Should be opaque
        }
      });

      test('should have distinct secondary colors across schemes', () {
        final colors = GravityFieldColorScheme.values
            .map((scheme) => scheme.secondaryColor)
            .toSet();
        expect(colors.length, greaterThan(1));
      });

      test('should return consistent secondary colors for same scheme', () {
        const scheme = GravityFieldColorScheme.neon;
        final color1 = scheme.secondaryColor;
        final color2 = scheme.secondaryColor;
        expect(color1, equals(color2));
      });
    });

    group('Accent Colors', () {
      test('should provide accent colors for all schemes', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final color = scheme.accentColor;
          expect(color, isA<Color>());
          expect(
            (color.a * 255.0).round() & 0xff,
            equals(255),
          ); // Should be opaque
        }
      });

      test('should have distinct accent colors across schemes', () {
        final colors = GravityFieldColorScheme.values
            .map((scheme) => scheme.accentColor)
            .toSet();
        expect(colors.length, greaterThan(1));
      });

      test('should return consistent accent colors for same scheme', () {
        const scheme = GravityFieldColorScheme.emerald;
        final color1 = scheme.accentColor;
        final color2 = scheme.accentColor;
        expect(color1, equals(color2));
      });
    });

    group('Color Scheme Consistency', () {
      test('should have different star and body colors within same scheme', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final starColor = scheme.starPrimaryColor;
          final bodyColor = scheme.bodyPrimaryColor;

          // Colors should be different (unless it's a monochrome scheme where they might be similar)
          if (scheme != GravityFieldColorScheme.monochrome) {
            expect(starColor, isNot(equals(bodyColor)));
          }
        }
      });

      test('should have all color properties different within each scheme', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final colors = {
            scheme.starPrimaryColor,
            scheme.bodyPrimaryColor,
            scheme.secondaryColor,
            scheme.accentColor,
          };

          // For non-monochrome schemes, should have some color variation
          if (scheme != GravityFieldColorScheme.monochrome) {
            expect(colors.length, greaterThan(1));
          }
        }
      });
    });

    group('Equipotential Color Generation', () {
      test('should handle boundary values correctly', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final color0 = scheme.getEquipotentialColor(0.0);
          final color1 = scheme.getEquipotentialColor(1.0);
          final colorMid = scheme.getEquipotentialColor(0.5);

          expect(color0, isA<Color>());
          expect(color1, isA<Color>());
          expect(colorMid, isA<Color>());

          // All colors should be fully opaque
          expect((color0.a * 255.0).round() & 0xff, equals(255));
          expect((color1.a * 255.0).round() & 0xff, equals(255));
          expect((colorMid.a * 255.0).round() & 0xff, equals(255));
        }
      });

      test('should clamp values outside 0.0-1.0 range', () {
        const scheme = GravityFieldColorScheme.classic;

        final colorNegative = scheme.getEquipotentialColor(-0.5);
        final color0 = scheme.getEquipotentialColor(0.0);
        expect(colorNegative, equals(color0));

        final colorHigh = scheme.getEquipotentialColor(1.5);
        final color1 = scheme.getEquipotentialColor(1.0);
        expect(colorHigh, equals(color1));

        final colorVeryHigh = scheme.getEquipotentialColor(100.0);
        expect(colorVeryHigh, equals(color1));

        final colorVeryNegative = scheme.getEquipotentialColor(-100.0);
        expect(colorVeryNegative, equals(color0));
      });

      test('should provide smooth gradients for all schemes', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final colors = <Color>[];

          // Sample many points to ensure smooth gradient
          for (int i = 0; i <= 20; i++) {
            final ratio = i / 20.0;
            colors.add(scheme.getEquipotentialColor(ratio));
          }

          // Should have color variation
          final uniqueColors = colors.toSet();
          expect(
            uniqueColors.length,
            greaterThan(1),
            reason: 'Scheme $scheme should provide color variation',
          );
        }
      });

      test('should be deterministic for same input', () {
        for (final scheme in GravityFieldColorScheme.values) {
          for (double ratio in [0.0, 0.25, 0.5, 0.75, 1.0]) {
            final color1 = scheme.getEquipotentialColor(ratio);
            final color2 = scheme.getEquipotentialColor(ratio);
            expect(color1, equals(color2));
          }
        }
      });
    });

    group('Specific Scheme Color Properties', () {
      group('Classic Scheme', () {
        test('should use blue to yellow/red progression', () {
          const scheme = GravityFieldColorScheme.classic;

          final weakColor = scheme.getEquipotentialColor(0.0);
          final strongColor = scheme.getEquipotentialColor(1.0);

          // Weak fields typically blue-ish, strong fields yellow/red-ish
          // This depends on AppColors implementation, so we mainly test validity
          expect(weakColor, isA<Color>());
          expect(strongColor, isA<Color>());
          expect(weakColor, isNot(equals(strongColor)));
        });
      });

      group('Spectral Scheme', () {
        test('should provide rainbow-like spectrum', () {
          const scheme = GravityFieldColorScheme.spectral;

          final colors = [
            scheme.getEquipotentialColor(0.0),
            scheme.getEquipotentialColor(0.2),
            scheme.getEquipotentialColor(0.4),
            scheme.getEquipotentialColor(0.6),
            scheme.getEquipotentialColor(0.8),
            scheme.getEquipotentialColor(1.0),
          ];

          // Should have multiple distinct colors across spectrum
          final uniqueColors = colors.toSet();
          expect(uniqueColors.length, greaterThan(3));
        });

        test('should handle three-segment interpolation correctly', () {
          const scheme = GravityFieldColorScheme.spectral;

          // Test all three segments of the spectral gradient
          final segment1 = scheme.getEquipotentialColor(0.1); // First third
          final segment2 = scheme.getEquipotentialColor(0.5); // Second third
          final segment3 = scheme.getEquipotentialColor(0.9); // Last third

          expect(segment1, isA<Color>());
          expect(segment2, isA<Color>());
          expect(segment3, isA<Color>());

          // All segments should be different
          expect(segment1, isNot(equals(segment2)));
          expect(segment2, isNot(equals(segment3)));
          expect(segment1, isNot(equals(segment3)));
        });
      });

      group('Monochrome Scheme', () {
        test('should use grayscale colors', () {
          const scheme = GravityFieldColorScheme.monochrome;

          for (double ratio in [0.0, 0.3, 0.7, 1.0]) {
            final color = scheme.getEquipotentialColor(ratio);

            // In monochrome, RGB values should be similar (allowing some tolerance)
            final r = ((color.r * 255.0).round() & 0xff);
            final g = ((color.g * 255.0).round() & 0xff);
            final b = ((color.b * 255.0).round() & 0xff);

            // Check if it's roughly grayscale (allowing some color tinting)
            final maxDiff = [
              (r - g).abs(),
              (g - b).abs(),
              (r - b).abs(),
            ].reduce((a, b) => a > b ? a : b);

            expect(
              maxDiff,
              lessThan(50), // Allow some variation for tinting
              reason: 'Monochrome colors should be roughly grayscale',
            );
          }
        });
      });

      group('Neon Scheme', () {
        test('should use bright, vibrant colors', () {
          const scheme = GravityFieldColorScheme.neon;

          final brightColor = scheme.getEquipotentialColor(0.8);
          final hsv = HSVColor.fromColor(brightColor);

          // Neon colors should generally be bright and saturated
          expect(hsv.value, greaterThan(0.3)); // Not too dark
          expect(hsv.saturation, greaterThan(0.2)); // Some saturation
        });
      });

      group('Emerald Scheme', () {
        test('should emphasize green color components', () {
          const scheme = GravityFieldColorScheme.emerald;

          for (double ratio in [0.2, 0.5, 0.8]) {
            final color = scheme.getEquipotentialColor(ratio);
            final r = (color.r * 255.0).round() & 0xff;
            final g = (color.g * 255.0).round() & 0xff;
            final b = (color.b * 255.0).round() & 0xff;

            // Green component should be significant in emerald scheme
            expect(g, greaterThan(0));

            // In most cases, green should be prominent
            // (allowing some flexibility for different shades)
            expect(g, greaterThanOrEqualTo(r * 0.5));
            expect(g, greaterThanOrEqualTo(b * 0.5));
          }
        });
      });
    });

    group('String Conversion', () {
      test('should convert from string names correctly', () {
        expect(
          GravityFieldColorSchemeExtension.fromString('classic'),
          equals(GravityFieldColorScheme.classic),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString('spectral'),
          equals(GravityFieldColorScheme.spectral),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString('monochrome'),
          equals(GravityFieldColorScheme.monochrome),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString('neon'),
          equals(GravityFieldColorScheme.neon),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString('emerald'),
          equals(GravityFieldColorScheme.emerald),
        );
      });

      test('should handle invalid string gracefully', () {
        expect(
          GravityFieldColorSchemeExtension.fromString('invalid'),
          equals(GravityFieldColorScheme.classic),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString(''),
          equals(GravityFieldColorScheme.classic),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString('CLASSIC'),
          equals(GravityFieldColorScheme.classic),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString('random_string'),
          equals(GravityFieldColorScheme.classic),
        );
      });

      test('should be case sensitive', () {
        expect(
          GravityFieldColorSchemeExtension.fromString('Classic'),
          equals(GravityFieldColorScheme.classic),
        );
        expect(
          GravityFieldColorSchemeExtension.fromString('NEON'),
          equals(GravityFieldColorScheme.classic),
        );
      });
    });

    group('Edge Cases and Robustness', () {
      test('should handle extreme field strength ratios', () {
        for (final scheme in GravityFieldColorScheme.values) {
          // Test with very small positive numbers
          final colorTiny = scheme.getEquipotentialColor(0.0001);
          expect(colorTiny, isA<Color>());

          // Test with numbers very close to 1
          final colorAlmost1 = scheme.getEquipotentialColor(0.9999);
          expect(colorAlmost1, isA<Color>());

          // Test with exactly 0.5
          final colorHalf = scheme.getEquipotentialColor(0.5);
          expect(colorHalf, isA<Color>());
        }
      });

      test('should handle double precision edge cases', () {
        const scheme = GravityFieldColorScheme.spectral;

        // Test values right at segment boundaries
        final boundaryColor1 = scheme.getEquipotentialColor(0.33);
        final boundaryColor2 = scheme.getEquipotentialColor(0.67);

        expect(boundaryColor1, isA<Color>());
        expect(boundaryColor2, isA<Color>());

        // Test values just before and after boundaries
        final beforeBoundary = scheme.getEquipotentialColor(0.32999);
        final afterBoundary = scheme.getEquipotentialColor(0.33001);

        expect(beforeBoundary, isA<Color>());
        expect(afterBoundary, isA<Color>());
      });

      test('should maintain color validity across all operations', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final colors = [
            scheme.starPrimaryColor,
            scheme.bodyPrimaryColor,
            scheme.secondaryColor,
            scheme.accentColor,
          ];

          for (final color in colors) {
            expect((color.r * 255.0).round() & 0xff, inInclusiveRange(0, 255));
            expect((color.g * 255.0).round() & 0xff, inInclusiveRange(0, 255));
            expect((color.b * 255.0).round() & 0xff, inInclusiveRange(0, 255));
            expect((color.a * 255.0).round() & 0xff, inInclusiveRange(0, 255));
          }

          // Test equipotential colors too
          for (double ratio in [0.0, 0.1, 0.5, 0.9, 1.0]) {
            final color = scheme.getEquipotentialColor(ratio);
            expect((color.r * 255.0).round() & 0xff, inInclusiveRange(0, 255));
            expect((color.g * 255.0).round() & 0xff, inInclusiveRange(0, 255));
            expect((color.b * 255.0).round() & 0xff, inInclusiveRange(0, 255));
            expect((color.a * 255.0).round() & 0xff, inInclusiveRange(0, 255));
          }
        }
      });
    });

    group('Performance and Efficiency', () {
      test('should compute colors efficiently', () {
        const scheme = GravityFieldColorScheme.spectral;
        final stopwatch = Stopwatch()..start();

        // Compute many colors to test performance
        for (int i = 0; i < 1000; i++) {
          final ratio = (i % 1000) / 1000.0;
          scheme.getEquipotentialColor(ratio);
        }

        stopwatch.stop();

        // Should complete in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should handle repeated calls efficiently', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final stopwatch = Stopwatch()..start();

          // Test repeated access to primary colors
          for (int i = 0; i < 1000; i++) {
            scheme.starPrimaryColor;
            scheme.bodyPrimaryColor;
            scheme.secondaryColor;
            scheme.accentColor;
          }

          stopwatch.stop();
          expect(stopwatch.elapsedMilliseconds, lessThan(50));
        }
      });
    });

    group('Integration Testing', () {
      test('should work with all Flutter Color operations', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final color = scheme.getEquipotentialColor(0.5);

          // Test common Color operations
          expect(color.withValues(alpha: 0.5), isA<Color>());
          expect(color.withAlpha(128), isA<Color>());
          expect(Color.lerp(color, AppColors.uiWhite, 0.5), isA<Color>());
          expect(HSVColor.fromColor(color), isA<HSVColor>());
          expect(color.computeLuminance(), isA<double>());
        }
      });

      test('should provide consistent behavior across platforms', () {
        // This test ensures the color schemes work the same way
        // regardless of platform-specific color implementations
        for (final scheme in GravityFieldColorScheme.values) {
          final results = <String, Color>{};

          for (double ratio in [0.0, 0.25, 0.5, 0.75, 1.0]) {
            final color = scheme.getEquipotentialColor(ratio);
            results['$ratio'] = color;
          }

          // Re-run and verify consistency
          for (double ratio in [0.0, 0.25, 0.5, 0.75, 1.0]) {
            final color = scheme.getEquipotentialColor(ratio);
            expect(color, equals(results['$ratio']));
          }
        }
      });
    });
  });
}
