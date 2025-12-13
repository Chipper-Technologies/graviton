import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/services/simulation/temperature_service.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Custom matcher for checking if a number is finite
Matcher get isFiniteNumber => predicate<num>((n) => n.isFinite, 'is finite');

void main() {
  group('TemperatureService Constants Integration Tests', () {
    group('Initial Temperature Assignment with Constants', () {
      test('star temperature should use sun surface temperature constant', () {
        final temperature = TemperatureService.getInitialTemperature(
          BodyType.star,
          10.0, // Standard mass for calculation
        );

        // Should use SimulationConstants.sunSurfaceTemperature as base
        // Formula: sunSurfaceTemperature * pow(mass / starMassReferenceValue, temperatureMassExponent)
        final expected =
            SimulationConstants.sunSurfaceTemperature *
            math.pow(
              10.0 / SimulationConstants.starMassReferenceValue,
              SimulationConstants.temperatureMassExponent,
            );
        expect(temperature, equals(expected));
      });

      test(
        'star temperature calculation should scale with mass using constant',
        () {
          // Test with different masses
          final mass1 = 5.0;
          final mass2 = 20.0;

          final temp1 = TemperatureService.getInitialTemperature(
            BodyType.star,
            mass1,
          );

          final temp2 = TemperatureService.getInitialTemperature(
            BodyType.star,
            mass2,
          );

          // Higher mass should give higher temperature
          expect(temp2, greaterThan(temp1));

          // Should be based on the sun surface temperature constant
          expect(
            temp1,
            greaterThan(SimulationConstants.sunSurfaceTemperature * 0.5),
          );
          expect(
            temp2,
            greaterThan(SimulationConstants.sunSurfaceTemperature * 1.0),
          );
        },
      );

      test('planet temperature should use earth-like temperature constant', () {
        final temperature = TemperatureService.getInitialTemperature(
          BodyType.planet,
          2.0,
          distance: SimulationConstants
              .earthLikeDistance, // Earth-like distance for baseline
        );

        // At earth-like distance, should be close to earth-like temperature
        // Formula: earthLikeTemperature * pow(earthLikeDistance / distance, temperatureMassExponent)
        final expected =
            SimulationConstants.earthLikeTemperature *
            math.pow(
              SimulationConstants.earthLikeDistance /
                  SimulationConstants.earthLikeDistance,
              SimulationConstants.temperatureMassExponent,
            );
        expect(temperature, equals(expected));
      });

      test('planet temperature should scale with distance using constant', () {
        final closerTemp = TemperatureService.getInitialTemperature(
          BodyType.planet,
          2.0,
          distance: 25.0, // Half the distance
        );

        final fartherTemp = TemperatureService.getInitialTemperature(
          BodyType.planet,
          2.0,
          distance: 100.0, // Double the distance
        );

        // Closer should be warmer than farther
        expect(closerTemp, greaterThan(fartherTemp));

        // Both should be based on the earth-like temperature constant
        expect(
          closerTemp,
          greaterThan(SimulationConstants.earthLikeTemperature),
        );
        expect(fartherTemp, lessThan(SimulationConstants.earthLikeTemperature));
      });

      test('constants should be reasonable for physics simulation', () {
        // Sun surface temperature should be in a reasonable range (5000-6000K)
        expect(
          SimulationConstants.sunSurfaceTemperature,
          inInclusiveRange(5000.0, 6000.0),
        );

        // Earth-like temperature should be reasonable (280-300K, ~7-27°C)
        expect(
          SimulationConstants.earthLikeTemperature,
          inInclusiveRange(280.0, 300.0),
        );

        // Sun should be much hotter than Earth
        expect(
          SimulationConstants.sunSurfaceTemperature,
          greaterThan(SimulationConstants.earthLikeTemperature * 15),
        );

        // Reference values should be positive
        expect(SimulationConstants.starMassReferenceValue, greaterThan(0.0));
        expect(SimulationConstants.temperatureMassExponent, greaterThan(0.0));
        expect(SimulationConstants.earthLikeDistance, greaterThan(0.0));

        // Temperature hierarchy should be logical
        expect(
          SimulationConstants.earthLikeTemperature,
          greaterThan(SimulationConstants.defaultColdTemperature),
        );
        expect(
          SimulationConstants.defaultColdTemperature,
          greaterThan(SimulationConstants.asteroidTemperature),
        );
      });
    });

    group('Planetary Temperature Calculation with Constants', () {
      late Body testPlanet;
      late Body testStar;

      setUp(() {
        testPlanet = Body(
          position: vm.Vector3(50.0, 0.0, 0.0), // Earth-like distance
          velocity: vm.Vector3.zero(),
          mass: 2.0,
          radius: 0.8,
          name: 'Test Planet',
          bodyType: BodyType.planet,
          color: AppColors.basicBlue,
        );

        testStar = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 1.0,
          name: 'Test Star',
          bodyType: BodyType.star,
          color: AppColors.basicYellow,
          stellarLuminosity: 1.0,
        );
      });

      test(
        'planetary temperature calculation should use constants appropriately',
        () {
          final temperature = TemperatureService.calculatePlanetaryTemperature(
            testPlanet,
            [testStar],
          );

          // Should be finite and positive
          expect(temperature, isFiniteNumber);
          expect(temperature, greaterThan(0.0));

          // Should be in a reasonable range for a planet
          expect(
            temperature,
            lessThan(SimulationConstants.sunSurfaceTemperature),
          );
          expect(
            temperature,
            greaterThan(10.0),
          ); // Above absolute zero with reasonable margin
        },
      );

      test(
        'temperature constants maintain consistency across calculations',
        () {
          // Test with multiple stars to ensure constants are used consistently
          final star2 = Body(
            position: vm.Vector3(100.0, 0.0, 0.0),
            velocity: vm.Vector3.zero(),
            mass: 8.0,
            radius: 0.9,
            name: 'Test Star 2',
            bodyType: BodyType.star,
            color: AppColors.basicOrange,
            stellarLuminosity: 0.8,
          );

          final tempWithOneStar =
              TemperatureService.calculatePlanetaryTemperature(testPlanet, [
                testStar,
              ]);

          final tempWithTwoStars =
              TemperatureService.calculatePlanetaryTemperature(testPlanet, [
                testStar,
                star2,
              ]);

          // More stars should generally increase temperature
          expect(tempWithTwoStars, greaterThanOrEqualTo(tempWithOneStar));

          // Both should use the same constants and be reasonable
          expect(tempWithOneStar, isFiniteNumber);
          expect(tempWithTwoStars, isFiniteNumber);
        },
      );
    });
  });
}
