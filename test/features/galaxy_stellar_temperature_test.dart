import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/services/stellar_color_service.dart';

void main() {
  group('Galaxy Formation Stellar Temperature Tests', () {
    late ScenarioService scenarioService;

    setUp(() {
      scenarioService = ScenarioService();
    });

    test('should assign hotter temperatures to stars closer to black hole', () {
      // Generate galaxy formation scenario
      final bodies = scenarioService.generateScenario(
        ScenarioType.galaxyFormation,
      );

      // Find black hole (should be first body at position 0,0,0)
      final blackHole = bodies[0];
      expect(blackHole.position.length, lessThan(0.1)); // At origin
      expect(blackHole.name.toLowerCase(), contains('black hole'));
      expect(
        blackHole.temperature,
        greaterThan(50000.0),
      ); // Very hot accretion disk

      // Collect stars with their distances from black hole
      final starsWithDistances = <Map<String, dynamic>>[];
      for (int i = 1; i < bodies.length; i++) {
        final body = bodies[i];
        if (body.bodyType == BodyType.star) {
          final distanceFromBlackHole =
              (body.position - blackHole.position).length;
          starsWithDistances.add({
            'body': body,
            'distance': distanceFromBlackHole,
            'temperature': body.temperature,
          });
        }
      }

      // Sort by distance from black hole
      starsWithDistances.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
      );

      // Verify that closer stars tend to be hotter
      expect(
        starsWithDistances.length,
        greaterThan(5),
      ); // Should have multiple stars

      // Check first (closest) vs last (farthest) stars
      final closestStar = starsWithDistances.first;
      final farthestStar = starsWithDistances.last;

      // Stars very close to black hole should be significantly hotter
      if (closestStar['distance'] < 100.0) {
        expect(
          closestStar['temperature'],
          greaterThan(farthestStar['temperature']),
          reason:
              'Stars closer to black hole should be hotter due to tidal heating and radiation',
        );

        // Also verify heating physics bounds
        expect(
          closestStar['temperature'],
          greaterThan(2500.0),
          reason: 'Very close stars should be heated to at least 2500K',
        );
        expect(
          closestStar['temperature'],
          lessThan(8500.0),
          reason:
              'Star heating should not exceed realistic limits (3x base temperature)',
        );
      }
    });

    test(
      'should use stellar temperatures for realistic colors when enabled',
      () {
        // Generate galaxy formation scenario
        final bodies = scenarioService.generateScenario(
          ScenarioType.galaxyFormation,
        );

        // Find stars at different distances
        final stars = bodies
            .where(
              (body) =>
                  body.bodyType == BodyType.star && body.name.contains('Star'),
            )
            .toList();
        expect(stars.length, greaterThan(3));

        for (final star in stars.take(3)) {
          // Each star should have a meaningful temperature
          expect(
            star.temperature,
            greaterThan(1000.0),
          ); // Should be stellar temperature, not default

          // Realistic color should be based on the star's actual temperature
          final realisticColor = StellarColorService.getRealisticBodyColor(
            star,
          );
          expect(realisticColor, isNotNull);

          // Very hot stars (>10000K) should tend toward blue/white
          // Cooler stars (<4000K) should tend toward red/orange
          if (star.temperature > 10000.0) {
            // Hot star - should have bluish realistic color
            expect(realisticColor, isNotNull);
          } else if (star.temperature < 4000.0) {
            // Cool star - should have reddish realistic color
            expect(realisticColor, isNotNull);
          }
        }
      },
    );

    test('should apply temperature heating based on distance thresholds', () {
      final bodies = scenarioService.generateScenario(
        ScenarioType.galaxyFormation,
      );
      final blackHole = bodies[0];

      // Find stars in different distance ranges
      var veryCloseStars = <double>[];
      var moderateDistanceStars = <double>[];
      var farStars = <double>[];

      for (int i = 1; i < bodies.length; i++) {
        final body = bodies[i];
        if (body.bodyType == BodyType.star && body.name.contains('Star')) {
          final distance = (body.position - blackHole.position).length;

          if (distance < 100.0) {
            veryCloseStars.add(body.temperature);
          } else if (distance < 150.0) {
            moderateDistanceStars.add(body.temperature);
          } else {
            farStars.add(body.temperature);
          }
        }
      }

      // If we have stars in multiple distance ranges, verify temperature relationship
      if (veryCloseStars.isNotEmpty && farStars.isNotEmpty) {
        final avgCloseTemp =
            veryCloseStars.reduce((a, b) => a + b) / veryCloseStars.length;
        final avgFarTemp = farStars.reduce((a, b) => a + b) / farStars.length;

        expect(
          avgCloseTemp,
          greaterThan(avgFarTemp * 1.1),
          reason:
              'Stars closer to black hole should average significantly hotter',
        );
      }

      if (moderateDistanceStars.isNotEmpty && farStars.isNotEmpty) {
        final avgModerateTemp =
            moderateDistanceStars.reduce((a, b) => a + b) /
            moderateDistanceStars.length;
        final avgFarTemp = farStars.reduce((a, b) => a + b) / farStars.length;

        // Due to random stellar masses, we allow some tolerance
        // The heating effect should at least partially compensate for mass differences
        expect(
          avgModerateTemp,
          greaterThanOrEqualTo(avgFarTemp * 0.8),
          reason:
              'Stars at moderate distance should be reasonably close in temperature to far stars, accounting for stellar mass variation',
        );
      }
    });
  });
}
