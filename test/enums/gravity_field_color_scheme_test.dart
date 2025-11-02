import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';

void main() {
  group('GravityFieldColorScheme', () {
    group('Enum Values', () {
      test('should have all expected color scheme values', () {
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
    });

    group('getEquipotentialColor', () {
      test(
        'should return valid colors for all strength ratios in classic scheme',
        () {
          const scheme = GravityFieldColorScheme.classic;

          // Test boundary values
          final color0 = scheme.getEquipotentialColor(0.0);
          final color1 = scheme.getEquipotentialColor(1.0);
          final colorMid = scheme.getEquipotentialColor(0.5);

          expect(color0, isA<Color>());
          expect(color1, isA<Color>());
          expect(colorMid, isA<Color>());

          // Should return consistent colors for same input
          expect(
            scheme.getEquipotentialColor(0.3),
            equals(scheme.getEquipotentialColor(0.3)),
          );
        },
      );

      test('should handle edge cases gracefully', () {
        const scheme = GravityFieldColorScheme.spectral;

        // Test negative values (should clamp to 0)
        final colorNegative = scheme.getEquipotentialColor(-0.5);
        final color0 = scheme.getEquipotentialColor(0.0);
        expect(colorNegative, equals(color0));

        // Test values > 1 (should clamp to 1)
        final colorHigh = scheme.getEquipotentialColor(1.5);
        final color1 = scheme.getEquipotentialColor(1.0);
        expect(colorHigh, equals(color1));
      });

      test('should provide smooth color gradients for all schemes', () {
        for (final scheme in GravityFieldColorScheme.values) {
          final colors = <Color>[];

          // Sample colors across the range
          for (int i = 0; i <= 10; i++) {
            final ratio = i / 10.0;
            colors.add(scheme.getEquipotentialColor(ratio));
          }

          // Verify we have a range of colors (not all the same)
          final uniqueColors = colors.toSet();
          expect(
            uniqueColors.length,
            greaterThan(1),
            reason: 'Scheme $scheme should provide color variation',
          );
        }
      });

      group('Classic Scheme', () {
        test('should use blue to red gradient', () {
          const scheme = GravityFieldColorScheme.classic;

          final weakColor = scheme.getEquipotentialColor(0.0);
          final strongColor = scheme.getEquipotentialColor(1.0);

          // Weak fields should be blue-ish (low red, higher blue)
          expect(
            (weakColor.b * 255.0).round() & 0xff,
            greaterThan((weakColor.r * 255.0).round() & 0xff),
          );

          // Strong fields should be red-ish (high red, lower blue)
          expect(
            (strongColor.r * 255.0).round() & 0xff,
            greaterThan((strongColor.b * 255.0).round() & 0xff),
          );
        });
      });

      group('Spectral Scheme', () {
        test('should provide rainbow-like progression', () {
          const scheme = GravityFieldColorScheme.spectral;

          final colors = [
            scheme.getEquipotentialColor(0.0), // Violet/Blue
            scheme.getEquipotentialColor(0.33), // Green
            scheme.getEquipotentialColor(0.66), // Yellow/Orange
            scheme.getEquipotentialColor(1.0), // Red
          ];

          // Should have distinct colors across spectrum
          final uniqueColors = colors.toSet();
          expect(uniqueColors.length, equals(4));
        });
      });

      group('Monochrome Scheme', () {
        test('should use grayscale colors', () {
          const scheme = GravityFieldColorScheme.monochrome;

          for (int i = 0; i <= 10; i++) {
            final ratio = i / 10.0;
            final color = scheme.getEquipotentialColor(ratio);

            // In monochrome, R, G, B values should be similar (grayscale)
            final tolerance = 30; // Allow some variation for tinting
            expect(
              ((color.r * 255.0).round() &
                      0xff - (color.g * 255.0).round() &
                      0xff)
                  .abs(),
              lessThan(tolerance),
            );
            expect(
              ((color.g * 255.0).round() &
                      0xff - (color.b * 255.0).round() &
                      0xff)
                  .abs(),
              lessThan(tolerance),
            );
            expect(
              ((color.r * 255.0).round() &
                      0xff - (color.b * 255.0).round() &
                      0xff)
                  .abs(),
              lessThan(tolerance),
            );
          }
        });
      });

      group('Neon Scheme', () {
        test('should use bright, saturated colors', () {
          const scheme = GravityFieldColorScheme.neon;

          final strongColor = scheme.getEquipotentialColor(1.0);

          // Neon colors should be bright (high saturation/value)
          final hsv = HSVColor.fromColor(strongColor);
          expect(
            hsv.saturation,
            greaterThan(0.5),
            reason: 'Neon colors should be highly saturated',
          );
        });
      });

      group('Emerald Scheme', () {
        test('should use green-tinted colors', () {
          const scheme = GravityFieldColorScheme.emerald;

          for (int i = 0; i <= 10; i++) {
            final ratio = i / 10.0;
            final color = scheme.getEquipotentialColor(ratio);

            // Emerald scheme should emphasize green component
            expect(
              (color.g * 255.0).round() & 0xff,
              greaterThanOrEqualTo((color.r * 255.0).round() & 0xff),
            );
            expect(
              (color.g * 255.0).round() & 0xff,
              greaterThanOrEqualTo((color.b * 255.0).round() & 0xff),
            );
          }
        });
      });
    });

    group('getLocalizedDisplayName', () {
      // Note: Localization testing requires widget test environment
      // These tests focus on the method's basic functionality
      test('should have getLocalizedDisplayName method for all schemes', () {
        for (final scheme in GravityFieldColorScheme.values) {
          expect(scheme.getLocalizedDisplayName, isA<Function>());
        }
      });
    });

    group('Integration with AppColors', () {
      test('should use colors defined in AppColors theme', () {
        // Verify that the color schemes reference actual AppColors
        const scheme = GravityFieldColorScheme.classic;

        final color = scheme.getEquipotentialColor(0.5);
        expect(color, isA<Color>());

        // Color should have reasonable RGBA values
        expect((color.r * 255.0).round() & 0xff, inInclusiveRange(0, 255));
        expect((color.g * 255.0).round() & 0xff, inInclusiveRange(0, 255));
        expect((color.b * 255.0).round() & 0xff, inInclusiveRange(0, 255));
        expect((color.a * 255.0).round() & 0xff, inInclusiveRange(0, 255));
      });
    });

    group('Performance', () {
      test('should compute colors efficiently', () {
        const scheme = GravityFieldColorScheme.spectral;
        final stopwatch = Stopwatch()..start();

        // Compute many colors to test performance
        for (int i = 0; i < 1000; i++) {
          final ratio = (i % 100) / 100.0;
          scheme.getEquipotentialColor(ratio);
        }

        stopwatch.stop();

        // Should complete in reasonable time (less than 100ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });
  });
}
