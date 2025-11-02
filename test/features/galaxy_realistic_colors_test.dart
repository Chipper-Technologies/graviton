import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/services/stellar_color_service.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('Galaxy Formation Realistic Colors Tests', () {
    late physics.Simulation simulation;

    setUp(() {
      simulation = physics.Simulation();
      simulation.resetWithScenario(ScenarioType.galaxyFormation);
    });

    test('should use realistic colors for galaxy stars when enabled', () {
      // Enable realistic colors
      simulation.setUseRealisticColors(true);

      // Collect star data for analysis
      final starData = <Map<String, dynamic>>[];
      final blackHole = simulation.bodies[0];

      for (int i = 1; i < simulation.bodies.length; i++) {
        final body = simulation.bodies[i];
        if (body.bodyType == BodyType.star) {
          final distance = (body.position - blackHole.position).length;
          final realisticColor = StellarColorService.getRealisticBodyColor(
            body,
          );

          starData.add({
            'body': body,
            'distance': distance,
            'temperature': body.temperature,
            'realisticColor': realisticColor,
          });

          // Verify star has realistic color applied
          expect(
            body.color,
            equals(realisticColor),
            reason: 'Star $i should have realistic color when enabled',
          );

          // Verify that the star has meaningful stellar temperature
          expect(
            body.temperature,
            greaterThan(1000.0),
            reason: 'Star should have meaningful stellar temperature',
          );
        }
      }

      // Sort by distance from black hole
      starData.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
      );

      // If we have multiple stars, verify temperature-color relationship
      if (starData.length >= 2) {
        final closestStar = starData.first;
        final farthestStar = starData.last;

        // Closer stars should generally be hotter
        if (closestStar['distance'] < 100.0) {
          expect(
            closestStar['temperature'],
            greaterThan(farthestStar['temperature']),
            reason: 'Stars closer to black hole should be hotter',
          );
        }
      }

      // Step the simulation several times
      for (int step = 0; step < 5; step++) {
        simulation.stepRK4(1.0 / 60.0);
      }

      // Verify stars still have realistic colors after simulation steps
      for (final starInfo in starData) {
        final body = starInfo['body'];
        final expectedColor = starInfo['realisticColor'];
        expect(
          body.color,
          equals(expectedColor),
          reason: 'Star color should remain realistic after simulation steps',
        );

        // Should NOT be distance-based colors
        expect(body.color, isNot(equals(AppColors.uiGreen)));
        expect(body.color, isNot(equals(AppColors.uiYellow)));
        expect(body.color, isNot(equals(AppColors.uiOrange)));
        expect(body.color, isNot(equals(AppColors.uiRed)));
      }
    });

    test(
      'should use distance-based colors for galaxy stars when realistic colors disabled',
      () {
        // Disable realistic colors (default)
        simulation.setUseRealisticColors(false);

        // Step the simulation several times to trigger dynamic color updates
        for (int step = 0; step < 10; step++) {
          simulation.stepRK4(1.0 / 60.0);
        }

        // Verify at least some stars have distance-based colors
        bool hasDistanceBasedColors = false;
        for (int i = 1; i < simulation.bodies.length; i++) {
          final body = simulation.bodies[i];
          if (body.bodyType == BodyType.star) {
            // Check if color matches one of the distance-based colors
            if (body.color == AppColors.uiGreen ||
                body.color == AppColors.uiYellow ||
                body.color == AppColors.uiOrange ||
                body.color == AppColors.uiRed ||
                _isColorBlendOf(body.color, [
                  AppColors.uiGreen,
                  AppColors.uiYellow,
                  AppColors.uiOrange,
                  AppColors.uiRed,
                ])) {
              hasDistanceBasedColors = true;
              break;
            }
          }
        }

        expect(
          hasDistanceBasedColors,
          isTrue,
          reason:
              'Galaxy formation should use distance-based colors when realistic colors disabled',
        );
      },
    );

    test(
      'should apply realistic colors to trails in galaxy formation when enabled',
      () {
        // This test verifies the trail painter logic indirectly by checking
        // that the body colors are realistic (which trails will use)
        simulation.setUseRealisticColors(true);

        // Check that stars have realistic colors (which trails will inherit)
        for (int i = 1; i < simulation.bodies.length; i++) {
          final body = simulation.bodies[i];
          if (body.bodyType == BodyType.star) {
            final expectedRealisticColor =
                StellarColorService.getRealisticBodyColor(body);
            expect(
              body.color,
              equals(expectedRealisticColor),
              reason: 'Star colors should be realistic for trail inheritance',
            );

            // Verify temperature-based realistic colors
            expect(
              body.temperature,
              greaterThan(1000.0),
              reason:
                  'Star should have stellar temperature for realistic color calculation',
            );
          }
        }
      },
    );
  });
}

/// Helper function to check if a color is a blend of any of the provided colors
bool _isColorBlendOf(Color testColor, List<Color> baseColors) {
  for (final baseColor in baseColors) {
    // Check if the color is similar to a base color (allowing for brightness adjustments)
    final testHsv = HSVColor.fromColor(testColor);
    final baseHsv = HSVColor.fromColor(baseColor);

    // Allow some tolerance in hue and saturation, more tolerance in value (brightness)
    final hueDiff = (testHsv.hue - baseHsv.hue).abs();
    final satDiff = (testHsv.saturation - baseHsv.saturation).abs();
    final valDiff = (testHsv.value - baseHsv.value).abs();

    if (hueDiff < 10.0 && satDiff < 0.2 && valDiff < 0.4) {
      return true;
    }
  }
  return false;
}
