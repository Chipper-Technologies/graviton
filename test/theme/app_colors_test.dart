import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    group('Color Constants Validation', () {
      test('should have valid space colors', () {
        // Test that space colors are properly defined
        expect(AppColors.spaceDeepBlueBlack, const Color(0xFF0a0a1a));
        expect(AppColors.spacePurple, const Color(0xFF2a1a3f));
        expect(AppColors.spaceDeepPurple, const Color(0xFF3d1a5c));
        expect(AppColors.spacePureBlack, const Color(0xFF000000));

        // Verify colors are not null
        expect(AppColors.spaceVibrantPurple, isNotNull);
        expect(AppColors.spaceMysticPurple, isNotNull);
        expect(AppColors.spaceRoyalPurple, isNotNull);
      });

      test('should have valid galaxy colors', () {
        expect(AppColors.galaxySlateBlue, const Color(0xFF6A5ACD));
        expect(AppColors.galaxyDarkSlateBlue, const Color(0xFF483D8B));
        expect(AppColors.galaxyRoyalBlue, const Color(0xFF4169E1));
        expect(AppColors.galaxyPureBlue, const Color(0xFF0000FF));
        expect(AppColors.galaxyIndigo, const Color(0xFF4B0082));
      });

      test('should have valid stellar colors', () {
        // Test stellar classification colors
        expect(AppColors.stellarOType, const Color(0xFF9BB0FF));
        expect(AppColors.stellarBType, const Color(0xFFAABFFF));
        expect(AppColors.stellarAType, const Color(0xFFCAD7FF));
        expect(AppColors.stellarFType, const Color(0xFFF8F7FF));
        expect(AppColors.stellarGType, const Color(0xFFFFE4B5));
        expect(AppColors.stellarKType, const Color(0xFFFFD2A1));
        expect(AppColors.stellarMType, const Color(0xFFFFAD51));
      });

      test('should have valid planet colors', () {
        expect(AppColors.planetMercury, const Color(0xFF8C7853));
        expect(AppColors.planetVenus, const Color(0xFFFFC649));
        expect(AppColors.planetEarth, const Color(0xFF6B93D6));
        expect(AppColors.planetMars, const Color(0xFFCD5C5C));
        expect(AppColors.planetJupiter, const Color(0xFFD8CA9D));
        expect(AppColors.planetSaturn, const Color(0xFFFFE4B5));
        expect(AppColors.planetUranus, const Color(0xFF4CC9F0));
        expect(AppColors.planetNeptune, const Color(0xFF4169E1));
      });

      test('should have valid habitability colors', () {
        expect(AppColors.habitabilityHabitable, const Color(0xFF4CAF50));
        expect(AppColors.habitabilityTooHot, const Color(0xFFF44336));
        expect(AppColors.habitabilityTooCold, const Color(0xFF2196F3));
        expect(AppColors.habitabilityUnknown, const Color(0xFF9E9E9E));
        expect(AppColors.habitabilityDangerZone, const Color(0xFFFF5722));
      });

      test('should have valid temperature colors', () {
        expect(AppColors.temperatureFrozen, const Color(0xFF1E90FF));
        expect(AppColors.temperatureCold, const Color(0xFF87CEEB));
        expect(AppColors.temperatureCool, const Color(0xFF90EE90));
        expect(AppColors.temperatureWarm, const Color(0xFFFFFF00));
        expect(AppColors.temperatureHot, const Color(0xFFFFA500));
        expect(AppColors.temperatureVeryHot, const Color(0xFFFF4500));
        expect(AppColors.temperatureScorching, const Color(0xFF8B0000));
      });

      test('should have valid UI colors', () {
        expect(AppColors.uiWhite, const Color(0xFFFFFFFF));
        expect(AppColors.uiWhite70, const Color(0xB3FFFFFF));
        expect(AppColors.uiDividerGrey, const Color(0xFF424242));
        expect(AppColors.uiBorderGrey, const Color(0xFF616161));
        expect(AppColors.uiTextGrey, const Color(0xFF9E9E9E));
        expect(AppColors.uiStatusOrange, const Color(0xFFFF9800));
      });
    });

    group('withAlpha Method', () {
      test('should create color with specified alpha', () {
        const baseColor = Color(0xFFFFFFFF); // White
        const alpha = 0.5;

        final result = AppColors.withAlpha(baseColor, alpha);

        expect(result.alpha, equals((255 * alpha).round()));
        expect(result.red, equals(baseColor.red));
        expect(result.green, equals(baseColor.green));
        expect(result.blue, equals(baseColor.blue));
      });

      test('should handle alpha values at boundaries', () {
        const baseColor = Color(0xFF123456);

        // Test alpha = 0 (fully transparent)
        final transparent = AppColors.withAlpha(baseColor, 0.0);
        expect(transparent.alpha, equals(0));

        // Test alpha = 1 (fully opaque)
        final opaque = AppColors.withAlpha(baseColor, 1.0);
        expect(opaque.alpha, equals(255));
      });

      test('should preserve RGB values with different alpha', () {
        const red = Color(0xFFFF0000);
        const alpha = 0.75;

        final result = AppColors.withAlpha(red, alpha);

        expect(result.red, equals(255));
        expect(result.green, equals(0));
        expect(result.blue, equals(0));
        expect(result.alpha, equals((255 * alpha).round()));
      });
    });

    group('createGlowGradient Method', () {
      test('should create gradient with specified alpha stops', () {
        const baseColor = Color(0xFF00FF00); // Green
        const alphaStops = [1.0, 0.7, 0.4, 0.1];

        final gradient = AppColors.createGlowGradient(baseColor, alphaStops);

        expect(gradient, hasLength(alphaStops.length));

        for (int i = 0; i < gradient.length; i++) {
          expect(gradient[i].red, equals(baseColor.red));
          expect(gradient[i].green, equals(baseColor.green));
          expect(gradient[i].blue, equals(baseColor.blue));
          expect(gradient[i].alpha, equals((255 * alphaStops[i]).round()));
        }
      });

      test('should handle empty alpha stops', () {
        const baseColor = Color(0xFF0000FF); // Blue
        const alphaStops = <double>[];

        final gradient = AppColors.createGlowGradient(baseColor, alphaStops);

        expect(gradient, isEmpty);
      });

      test('should handle single alpha stop', () {
        const baseColor = Color(0xFFFFFF00); // Yellow
        const alphaStops = [0.5];

        final gradient = AppColors.createGlowGradient(baseColor, alphaStops);

        expect(gradient, hasLength(1));
        expect(
          gradient[0].alpha,
          equals(128),
        ); // 255 * 0.5 = 127.5, rounds to 128
      });
    });

    group('getHabitabilityColor Method', () {
      test('should return correct colors for known habitability statuses', () {
        expect(
          AppColors.getHabitabilityColor('habitable'),
          equals(AppColors.habitabilityHabitable),
        );
        expect(
          AppColors.getHabitabilityColor('too_hot'),
          equals(AppColors.habitabilityTooHot),
        );
        expect(
          AppColors.getHabitabilityColor('too_cold'),
          equals(AppColors.habitabilityTooCold),
        );
      });

      test('should handle case-insensitive input', () {
        expect(
          AppColors.getHabitabilityColor('HABITABLE'),
          equals(AppColors.habitabilityHabitable),
        );
        expect(
          AppColors.getHabitabilityColor('Too_Hot'),
          equals(AppColors.habitabilityTooHot),
        );
        expect(
          AppColors.getHabitabilityColor('TOO_COLD'),
          equals(AppColors.habitabilityTooCold),
        );
      });

      test('should return unknown color for unrecognized status', () {
        expect(
          AppColors.getHabitabilityColor('invalid'),
          equals(AppColors.habitabilityUnknown),
        );
        expect(
          AppColors.getHabitabilityColor(''),
          equals(AppColors.habitabilityUnknown),
        );
        expect(
          AppColors.getHabitabilityColor('random_text'),
          equals(AppColors.habitabilityUnknown),
        );
      });
    });

    group('getTemperatureColor Method', () {
      test('should return correct colors for temperature ranges in Kelvin', () {
        const kelvinOffset =
            SimulationConstants.kelvinToCelsiusOffset; // 273.15

        // Test frozen range (< -50°C)
        expect(
          AppColors.getTemperatureColor(kelvinOffset - 100), // -100°C
          equals(AppColors.temperatureFrozen),
        );

        // Test cold range (-50°C to 0°C)
        expect(
          AppColors.getTemperatureColor(kelvinOffset - 25), // -25°C
          equals(AppColors.temperatureCold),
        );

        // Test cool range (0°C to 25°C)
        expect(
          AppColors.getTemperatureColor(kelvinOffset + 10), // 10°C
          equals(AppColors.temperatureCool),
        );

        // Test warm range (25°C to 50°C)
        expect(
          AppColors.getTemperatureColor(kelvinOffset + 30), // 30°C
          equals(AppColors.temperatureWarm),
        );

        // Test hot range (50°C to 100°C)
        expect(
          AppColors.getTemperatureColor(kelvinOffset + 75), // 75°C
          equals(AppColors.temperatureHot),
        );

        // Test very hot range (100°C to 200°C)
        expect(
          AppColors.getTemperatureColor(kelvinOffset + 150), // 150°C
          equals(AppColors.temperatureVeryHot),
        );

        // Test scorching range (> 200°C)
        expect(
          AppColors.getTemperatureColor(kelvinOffset + 300), // 300°C
          equals(AppColors.temperatureScorching),
        );
      });

      test('should handle boundary temperatures correctly', () {
        const kelvinOffset = SimulationConstants.kelvinToCelsiusOffset;

        // Test exact boundaries
        expect(
          AppColors.getTemperatureColor(kelvinOffset - 50), // exactly -50°C
          equals(AppColors.temperatureCold),
        );
        expect(
          AppColors.getTemperatureColor(kelvinOffset), // exactly 0°C
          equals(AppColors.temperatureCool),
        );
        expect(
          AppColors.getTemperatureColor(kelvinOffset + 25), // exactly 25°C
          equals(AppColors.temperatureWarm),
        );
        expect(
          AppColors.getTemperatureColor(kelvinOffset + 50), // exactly 50°C
          equals(AppColors.temperatureHot),
        );
      });

      test('should handle extreme temperatures', () {
        // Very low temperature (absolute zero area)
        expect(
          AppColors.getTemperatureColor(50), // Well below freezing
          equals(AppColors.temperatureFrozen),
        );

        // Very high temperature (stellar core temperatures)
        expect(
          AppColors.getTemperatureColor(10000), // 9726°C
          equals(AppColors.temperatureScorching),
        );
      });
    });

    group('getPlanetColor Method', () {
      test('should return correct colors for known planets', () {
        // Test with exact capitalized names that match enum values
        expect(
          AppColors.getPlanetColor('Mercury'),
          equals(AppColors.planetMercury),
        );
        expect(
          AppColors.getPlanetColor('Venus'),
          equals(AppColors.planetVenus),
        );
        expect(
          AppColors.getPlanetColor('Earth'),
          equals(AppColors.planetEarth),
        );
        expect(AppColors.getPlanetColor('Mars'), equals(AppColors.planetMars));
        expect(
          AppColors.getPlanetColor('Jupiter'),
          equals(AppColors.planetJupiter),
        );
        expect(
          AppColors.getPlanetColor('Saturn'),
          equals(AppColors.planetSaturn),
        );
        expect(
          AppColors.getPlanetColor('Uranus'),
          equals(AppColors.planetUranus),
        );
        expect(
          AppColors.getPlanetColor('Neptune'),
          equals(AppColors.planetNeptune),
        );
      });

      test('should return default color for case-sensitive mismatches', () {
        // The fromString method is case-sensitive, so lowercase should return default
        expect(
          AppColors.getPlanetColor('earth'),
          equals(AppColors.celestialBlue),
        );
        expect(
          AppColors.getPlanetColor('jupiter'),
          equals(AppColors.celestialBlue),
        );
        expect(
          AppColors.getPlanetColor('MARS'),
          equals(AppColors.celestialBlue),
        );
      });

      test('should return default color for unknown planets', () {
        expect(
          AppColors.getPlanetColor('Pluto'),
          equals(AppColors.celestialBlue),
        );
        expect(
          AppColors.getPlanetColor('unknown'),
          equals(AppColors.celestialBlue),
        );
        expect(AppColors.getPlanetColor(''), equals(AppColors.celestialBlue));
        expect(
          AppColors.getPlanetColor('asteroid'),
          equals(AppColors.celestialBlue),
        );
      });

      test('should handle exact planet name matching from enum', () {
        // Test that the method works correctly with CelestialBodyName.fromString behavior
        expect(
          AppColors.getPlanetColor('Earth'),
          equals(AppColors.planetEarth),
        );
        // Note: The actual behavior depends on CelestialBodyName.fromString implementation
        // which requires exact case-sensitive matches
      });
    });

    group('Color Constant Integrity', () {
      test('should have consistent color value types', () {
        // Verify all color constants are properly typed
        expect(AppColors.spaceDeepBlueBlack, isA<Color>());
        expect(AppColors.planetEarth, isA<Color>());
        expect(AppColors.habitabilityHabitable, isA<Color>());
        expect(AppColors.temperatureWarm, isA<Color>());
        expect(AppColors.uiWhite, isA<Color>());
      });

      test('should have non-null color values', () {
        // Test a sampling of colors to ensure they're not null
        expect(AppColors.spacePureBlack, isNotNull);
        expect(AppColors.galaxyRoyalBlue, isNotNull);
        expect(AppColors.stellarGType, isNotNull);
        expect(AppColors.planetMars, isNotNull);
        expect(AppColors.habitabilityTooCold, isNotNull);
        expect(AppColors.temperatureHot, isNotNull);
        expect(AppColors.uiBorderGrey, isNotNull);
      });

      test('should have distinct planet colors', () {
        // Ensure planet colors are visually distinct
        final planetColors = [
          AppColors.planetMercury,
          AppColors.planetVenus,
          AppColors.planetEarth,
          AppColors.planetMars,
          AppColors.planetJupiter,
          AppColors.planetSaturn,
          AppColors.planetUranus,
          AppColors.planetNeptune,
        ];

        // Check that all planet colors are unique
        final uniqueColors = planetColors.toSet();
        expect(uniqueColors.length, equals(planetColors.length));
      });

      test('should have distinct habitability colors', () {
        final habitabilityColors = [
          AppColors.habitabilityHabitable,
          AppColors.habitabilityTooHot,
          AppColors.habitabilityTooCold,
          AppColors.habitabilityUnknown,
          AppColors.habitabilityDangerZone,
        ];

        final uniqueColors = habitabilityColors.toSet();
        expect(uniqueColors.length, equals(habitabilityColors.length));
      });
    });

    group('Alpha Constants Validation', () {
      test('should have valid alpha constant values', () {
        // Test actual alpha constants that exist in the class
        expect(AppColors.alphaVeryFaint, equals(0.003));
        expect(AppColors.alphaAlmostInvisible, equals(0.004));
        expect(AppColors.alphaLow, equals(0.05));
        expect(AppColors.alphaLowMedium, equals(0.08));
        expect(AppColors.alphaMedium, equals(0.10));
        expect(AppColors.alphaMediumHigh, equals(0.12));
        expect(AppColors.alphaHalf, equals(0.5));
        expect(AppColors.alphaHigh, equals(0.7));
        expect(AppColors.alphaNearlyOpaque, equals(0.9));
        expect(AppColors.alphaFullyOpaque, equals(1.0));
      });

      test('should have alpha values in correct range', () {
        // All alpha values should be between 0.0 and 1.0
        expect(AppColors.alphaVeryFaint, greaterThanOrEqualTo(0.0));
        expect(AppColors.alphaVeryFaint, lessThanOrEqualTo(1.0));

        expect(AppColors.alphaFullyOpaque, greaterThanOrEqualTo(0.0));
        expect(AppColors.alphaFullyOpaque, lessThanOrEqualTo(1.0));

        expect(AppColors.alphaMedium, greaterThanOrEqualTo(0.0));
        expect(AppColors.alphaMedium, lessThanOrEqualTo(1.0));

        expect(AppColors.alphaHalf, greaterThanOrEqualTo(0.0));
        expect(AppColors.alphaHalf, lessThanOrEqualTo(1.0));
      });

      test('should have ordered alpha progression', () {
        // Test that alpha values increase logically
        expect(AppColors.alphaVeryFaint, lessThan(AppColors.alphaLow));
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
