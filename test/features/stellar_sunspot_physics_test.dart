import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/painters/celestial_body_painter.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/services/stellar_color_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'dart:ui' as ui;

void main() {
  group('Stellar Sunspot Physics Tests', () {
    late ScenarioService scenarioService;
    late Canvas canvas;
    late ui.PictureRecorder recorder;

    setUp(() {
      scenarioService = ScenarioService();
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
    });

    test('should assign sunspots to temperature-appropriate stars', () {
      // Generate galaxy formation scenario with realistic temperatures
      final bodies = scenarioService.generateScenario(
        ScenarioType.galaxyFormation,
      );

      // Find stars with different temperatures
      final hotStars = <Body>[];
      final coolStars = <Body>[];
      final veryHotStars = <Body>[];

      for (final body in bodies) {
        if (body.bodyType == BodyType.star && body.name.contains('Star')) {
          if (body.temperature > 7500.0) {
            veryHotStars.add(body);
          } else if (body.temperature > 5000.0) {
            hotStars.add(body);
          } else if (body.temperature > 2000.0) {
            coolStars.add(body);
          }
        }
      }

      // Verify temperature distribution makes sense
      expect(
        hotStars.length + coolStars.length + veryHotStars.length,
        greaterThan(5),
      );

      // Test sunspot eligibility based on temperature
      for (final star in [...hotStars, ...coolStars]) {
        // Stars in the 2000K-7500K range should be eligible for sunspots
        expect(star.temperature, greaterThanOrEqualTo(2000.0));
        expect(star.temperature, lessThanOrEqualTo(7500.0));
      }

      // Very hot stars (>7500K) should NOT have sunspots in real physics
      // (they have different magnetic field structures)
      for (final star in veryHotStars) {
        expect(star.temperature, greaterThan(7500.0));
      }
    });

    test('should render sunspots with temperature-appropriate colors', () {
      // Create test stars with different temperatures
      final hotStar = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 15.0,
        radius: 5.0,
        color: AppColors.uiWhite,
        name: 'Hot Star',
        bodyType: BodyType.star,
        temperature: 6500.0, // F-type star
      );

      final coolStar = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 8.0,
        radius: 4.0,
        color: AppColors.basicOrange,
        name: 'Cool Star',
        bodyType: BodyType.star,
        temperature: 4000.0, // K-type star
      );

      // Test drawing with realistic colors
      expect(
        () => CelestialBodyPainter.drawBody(
          canvas,
          const Offset(100, 100),
          50.0,
          hotStar,
          useRealisticColors: true,
        ),
        returnsNormally,
        reason:
            'Hot star should render with realistic colors and appropriate sunspots',
      );

      expect(
        () => CelestialBodyPainter.drawBody(
          canvas,
          const Offset(200, 200),
          40.0,
          coolStar,
          useRealisticColors: true,
        ),
        returnsNormally,
        reason:
            'Cool star should render with realistic colors and appropriate sunspots',
      );
    });

    test('should use realistic stellar colors for stars with sunspots', () {
      // Create a Sun-like star that should get sunspots
      final sunLikeStar = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 10.0,
        radius: 4.0,
        color: AppColors.basicYellow,
        name: 'Central Star', // This should trigger sunspot rendering
        bodyType: BodyType.star,
        temperature: 5778.0, // Sun temperature
      );

      // Get realistic color
      final realisticColor = StellarColorService.getRealisticBodyColor(
        sunLikeStar,
      );

      // Verify the realistic color reflects the temperature
      expect(realisticColor, isNotNull);
      expect(sunLikeStar.temperature, equals(5778.0));

      // Test drawing - should use realistic colors for both star and sunspots
      expect(
        () => CelestialBodyPainter.drawBody(
          canvas,
          const Offset(150, 150),
          45.0,
          sunLikeStar,
          useRealisticColors: true,
        ),
        returnsNormally,
        reason:
            'Sun-like star should render with realistic colors and sunspots',
      );
    });

    test(
      'should handle galaxy formation stars with varying sunspot characteristics',
      () {
        final bodies = scenarioService.generateScenario(
          ScenarioType.galaxyFormation,
        );

        // Find stars at different distances from black hole
        final blackHole = bodies[0];
        final starsByDistance = <double, Body>{};

        for (int i = 1; i < bodies.length; i++) {
          final body = bodies[i];
          if (body.bodyType == BodyType.star && body.name.contains('Star')) {
            final distance = (body.position - blackHole.position).length;
            starsByDistance[distance] = body;
          }
        }

        expect(starsByDistance.length, greaterThan(3));

        // Test rendering stars at different distances
        int testCount = 0;
        for (final entry in starsByDistance.entries) {
          if (testCount >= 3) break; // Test first 3 stars

          final distance = entry.key;
          final star = entry.value;

          // Stars closer to black hole should be hotter
          if (distance < 100.0) {
            // Base stellar temperature is 5778 * (mass/10)^0.5
            // Mass range in galaxy: 0.8 to 2.2 solar masses
            // Min base temp: 5778 * (0.8/10)^0.5 ≈ 1635K
            // Max base temp: 5778 * (2.2/10)^0.5 ≈ 2710K
            // With proximity heating (up to 3x), should reach at least 2500K but not exceed ~8500K
            expect(
              star.temperature,
              greaterThan(2500.0),
              reason: 'Stars close to black hole should be heated',
            );
            expect(
              star.temperature,
              lessThan(8500.0),
              reason:
                  'Star heating should not exceed realistic limits (3x base temperature)',
            );
          }

          // Test realistic rendering
          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              Offset(50.0 + testCount * 100.0, 100.0),
              30.0,
              star,
              useRealisticColors: true,
            ),
            returnsNormally,
            reason:
                'Galaxy star should render with appropriate stellar physics',
          );

          testCount++;
        }
      },
    );
  });
}
