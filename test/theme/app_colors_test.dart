import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    group('Color Constants Validation', () {
      test('should have valid primary color family', () {
        expect(AppColors.primaryColor, isA<Color>());
        expect(AppColors.backgroundBlack, isA<Color>());
        expect(AppColors.backgroundDeepBlue, isA<Color>());

        // Ensure colors are not null and have proper alpha
        expect(AppColors.primaryColor.a, equals(1.0));
        expect(AppColors.backgroundBlack.a, equals(1.0));
      });

      test('should have valid space color family', () {
        // Test space-themed colors
        expect(AppColors.spaceDeepBlueBlack, const Color(0xFF0a0a1a));
        expect(AppColors.spacePurple, const Color(0xFF2a1a3f));
        expect(AppColors.spaceDeepPurple, const Color(0xFF3d1a5c));
        expect(AppColors.spacePureBlack, const Color(0xFF000000));
      });

      test('should have valid habitability colors', () {
        // Test habitability status colors exist and are valid
        expect(AppColors.habitabilityHabitable, isA<Color>());
        expect(AppColors.habitabilityTooHot, isA<Color>());
        expect(AppColors.habitabilityTooCold, isA<Color>());
        expect(AppColors.habitabilityGasGiant, isA<Color>());
        expect(AppColors.habitabilityTooSmall, isA<Color>());
        expect(AppColors.habitabilityNoAtmosphere, isA<Color>());
        expect(AppColors.habitabilityToxicAtmosphere, isA<Color>());
        expect(AppColors.habitabilityHighRadiation, isA<Color>());
        expect(AppColors.habitabilityTidallyLocked, isA<Color>());
        expect(AppColors.habitabilityExtremeGravity, isA<Color>());
        expect(AppColors.habitabilityUnknown, isA<Color>());

        // All should be fully opaque
        expect(AppColors.habitabilityHabitable.a, equals(1.0));
        expect(AppColors.habitabilityTooHot.a, equals(1.0));
        expect(AppColors.habitabilityTooCold.a, equals(1.0));
      });

      test('should have valid temperature colors', () {
        // Test temperature gradient colors
        expect(AppColors.temperatureFrozen, isA<Color>());
        expect(AppColors.temperatureCold, isA<Color>());
        expect(AppColors.temperatureCool, isA<Color>());
        expect(AppColors.temperatureWarm, isA<Color>());
        expect(AppColors.temperatureHot, isA<Color>());
        expect(AppColors.temperatureVeryHot, isA<Color>());
        expect(AppColors.temperatureScorching, isA<Color>());
      });

      test('should have valid UI colors', () {
        // Test UI-specific colors exist and are valid
        expect(AppColors.uiBlack, const Color(0xFF000000));
        expect(AppColors.uiWhite, const Color(0xFFFFFFFF));
        expect(AppColors.uiRed, isA<Color>());
        expect(AppColors.uiGreen, isA<Color>());
        expect(AppColors.basicBlue, isA<Color>());
        expect(AppColors.uiCyanAccent, isA<Color>());
        expect(AppColors.uiOrangeAccent, isA<Color>());
        expect(AppColors.uiTextGrey, isA<Color>());
        expect(AppColors.uiStatusOrange, isA<Color>());

        // All should be fully opaque
        expect(AppColors.uiBlack.a, equals(1.0));
        expect(AppColors.uiWhite.a, equals(1.0));
        expect(AppColors.uiRed.a, equals(1.0));
      });
    });

    group('Color Constant Integrity', () {
      test('should have consistent color value types', () {
        // Verify all color constants are properly typed
        expect(AppColors.spaceDeepBlueBlack, isA<Color>());
        expect(AppColors.planetEarth, isA<Color>());
        expect(AppColors.habitabilityHabitable, isA<Color>());
        expect(AppColors.temperatureWarm, isA<Color>());
        expect(AppColors.uiBlack, isA<Color>());
        expect(AppColors.uiWhite, isA<Color>());
      });

      test('should have non-null color values', () {
        // Test a sample of colors to ensure they are not null
        expect(AppColors.primaryColor, isNotNull);
        expect(AppColors.backgroundBlack, isNotNull);
        expect(AppColors.backgroundDeepBlue, isNotNull);
        expect(AppColors.uiBlack, isNotNull);
        expect(AppColors.uiWhite, isNotNull);
      });

      test('should have valid alpha values for UI colors', () {
        // Most UI colors should be fully opaque
        expect(AppColors.uiBlack.a, equals(1.0));
        expect(AppColors.uiWhite.a, equals(1.0));
        expect(AppColors.primaryColor.a, equals(1.0));
        expect(AppColors.backgroundBlack.a, equals(1.0));
      });

      test('should have distinguishable habitability colors', () {
        // Habitability colors should be visually distinct
        final habitable = AppColors.habitabilityHabitable;
        final tooHot = AppColors.habitabilityTooHot;
        final tooCold = AppColors.habitabilityTooCold;
        final unknown = AppColors.habitabilityUnknown;

        // Colors should not be identical
        expect(habitable, isNot(equals(tooHot)));
        expect(habitable, isNot(equals(tooCold)));
        expect(habitable, isNot(equals(unknown)));
        expect(tooHot, isNot(equals(tooCold)));
      });

      test('should have distinguishable temperature colors', () {
        // Temperature colors should create a visible gradient
        final frozen = AppColors.temperatureFrozen;
        final cold = AppColors.temperatureCold;
        final warm = AppColors.temperatureWarm;
        final hot = AppColors.temperatureHot;

        // Colors should not be identical
        expect(frozen, isNot(equals(cold)));
        expect(cold, isNot(equals(warm)));
        expect(warm, isNot(equals(hot)));
      });
    });

    group('Asteroid and Pulsar Color Constants', () {
      test('should have valid asteroid color constants', () {
        // Test asteroid color constants
        expect(AppColors.asteroidRockyBrown, isA<Color>());
        expect(AppColors.asteroidSienna, isA<Color>());
        expect(AppColors.asteroidBrownish, isA<Color>());

        // Test expected hex values
        expect(AppColors.asteroidRockyBrown, const Color(0xFF8B7355));
        expect(AppColors.asteroidSienna, const Color(0xFFA0522D));

        // All should be fully opaque
        expect(AppColors.asteroidRockyBrown.a, equals(1.0));
        expect(AppColors.asteroidSienna.a, equals(1.0));
      });

      test('should have valid pulsar color constant', () {
        // Test pulsar color constant
        expect(AppColors.pulsarCyan, isA<Color>());
        expect(AppColors.pulsarCyan, const Color(0xFF4FC3F7));
        expect(AppColors.pulsarCyan.a, equals(1.0));
      });

      test('should have distinguishable asteroid colors', () {
        // Asteroid colors should be visually distinct
        expect(
          AppColors.asteroidRockyBrown,
          isNot(equals(AppColors.asteroidSienna)),
        );
        expect(
          AppColors.asteroidRockyBrown,
          isNot(equals(AppColors.asteroidBrownish)),
        );
        expect(
          AppColors.asteroidSienna,
          isNot(equals(AppColors.asteroidBrownish)),
        );
      });
    });

    group('Alpha Constants Validation', () {
      test('should have proper alpha value ranges', () {
        // Alpha values should be between 0.0 and 1.0
        expect(AppColors.alphaLow, greaterThanOrEqualTo(0.0));
        expect(AppColors.alphaLow, lessThanOrEqualTo(1.0));

        expect(AppColors.alphaMedium, greaterThanOrEqualTo(0.0));
        expect(AppColors.alphaMedium, lessThanOrEqualTo(1.0));

        expect(AppColors.alphaHigh, greaterThanOrEqualTo(0.0));
        expect(AppColors.alphaHigh, lessThanOrEqualTo(1.0));
      });

      test('should have logical alpha progression', () {
        // Alpha values should increase in logical order
        expect(AppColors.alphaLow, lessThan(AppColors.alphaMedium));
        expect(AppColors.alphaMedium, lessThan(AppColors.alphaHalf));
        expect(AppColors.alphaHalf, lessThan(AppColors.alphaHigh));
        expect(AppColors.alphaHigh, lessThan(AppColors.alphaNearlyOpaque));
        expect(
          AppColors.alphaNearlyOpaque,
          lessThan(AppColors.alphaFullyOpaque),
        );
      });
    });
  });
}
