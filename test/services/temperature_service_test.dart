/// Tests for temperature service calculations and conversions.
///
/// This module tests the temperature calculation system including:
/// - Planetary temperature calculations based on stellar radiation
/// - Initial temperature assignment for different body types
/// - Temperature formatting and localization
/// - Greenhouse effect modeling
/// - Mass-based temperature scaling
///
/// The temperature service is critical for accurate habitability zone
/// calculations and realistic thermal modeling in the simulation.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/temperature_service.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Custom matcher for checking if a number is finite
Matcher get isFiniteNumber => predicate<num>((n) => n.isFinite, 'is finite');

void main() {
  group('TemperatureService Tests', () {
    late Body testPlanet;
    late Body testStar;
    late List<Body> testBodies;

    setUp(() {
      // Create test planet
      testPlanet = Body(
        position: vm.Vector3(1.0, 0.0, 0.0),
        velocity: vm.Vector3.zero(),
        mass: 1.0,
        radius: 0.1,
        name: 'Test Planet',
        bodyType: BodyType.planet,
        color: Colors.blue,
      );

      // Create test star
      testStar = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 10.0,
        radius: 0.5,
        name: 'Test Star',
        bodyType: BodyType.star,
        color: Colors.yellow,
      );
      testStar.stellarLuminosity = 1.0;

      testBodies = [testPlanet, testStar];
    });

    group('Planetary Temperature Calculation', () {
      test('Should calculate temperature from stellar radiation', () {
        final temperature = TemperatureService.calculatePlanetaryTemperature(
          testPlanet,
          [testStar],
        );

        // Should be above cosmic background temperature
        expect(
          temperature,
          greaterThan(SimulationConstants.cosmicMicrowaveBackgroundTemperature),
        );
        expect(temperature, isFiniteNumber);
        expect(temperature, greaterThan(0));
      });

      test('Should handle multiple stars', () {
        final star2 = Body(
          position: vm.Vector3(2.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 5.0,
          radius: 0.3,
          name: 'Second Star',
          bodyType: BodyType.star,
          color: Colors.orange,
        );
        star2.stellarLuminosity = 0.5;

        final tempOnestar = TemperatureService.calculatePlanetaryTemperature(
          testPlanet,
          [testStar],
        );
        final tempTwoStars = TemperatureService.calculatePlanetaryTemperature(
          testPlanet,
          [testStar, star2],
        );

        // Temperature should be higher with two stars
        expect(tempTwoStars, greaterThan(tempOnestar));
      });

      test('Should return original temperature for non-habitable bodies', () {
        final asteroid = Body(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 0.1,
          radius: 0.05,
          name: 'Test Asteroid',
          bodyType: BodyType.asteroid,
          color: Colors.grey,
        );
        final originalTemp = asteroid.temperature;

        final newTemp = TemperatureService.calculatePlanetaryTemperature(
          asteroid,
          [testStar],
        );

        expect(newTemp, equals(originalTemp));
      });

      test('Should handle empty star list', () {
        final temperature = TemperatureService.calculatePlanetaryTemperature(
          testPlanet,
          [],
        );

        expect(temperature, equals(testPlanet.temperature));
      });

      test('Should handle very close distances safely', () {
        final closeStar = Body(
          position: vm.Vector3(0.05, 0.0, 0.0), // Very close
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 0.5,
          name: 'Close Star',
          bodyType: BodyType.star,
          color: Colors.yellow,
        );
        closeStar.stellarLuminosity = 1.0;

        final temperature = TemperatureService.calculatePlanetaryTemperature(
          testPlanet,
          [closeStar],
        );

        // Should not crash and should be finite
        expect(temperature, isFiniteNumber);
        expect(temperature, greaterThan(0));
      });

      test('Should apply greenhouse effect for massive planets', () {
        final lightPlanet = Body(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 0.5, // Light planet
          radius: 0.1,
          name: 'Light Planet',
          bodyType: BodyType.planet,
          color: Colors.blue,
        );

        final heavyPlanet = Body(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 2.0, // Heavy planet
          radius: 0.1,
          name: 'Heavy Planet',
          bodyType: BodyType.planet,
          color: Colors.blue,
        );

        final lightTemp = TemperatureService.calculatePlanetaryTemperature(
          lightPlanet,
          [testStar],
        );
        final heavyTemp = TemperatureService.calculatePlanetaryTemperature(
          heavyPlanet,
          [testStar],
        );

        // Heavy planet should be warmer due to greenhouse effect
        expect(heavyTemp, greaterThan(lightTemp));
      });

      test('Should cap greenhouse effect at reasonable maximum', () {
        final superMassivePlanet = Body(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 100.0, // Extremely massive
          radius: 0.1,
          name: 'Super Massive Planet',
          bodyType: BodyType.planet,
          color: Colors.blue,
        );

        final temperature = TemperatureService.calculatePlanetaryTemperature(
          superMassivePlanet,
          [testStar],
        );

        // Should be finite and not absurdly high
        expect(temperature, isFiniteNumber);
        expect(temperature, lessThan(10000)); // Reasonable upper bound
      });
    });

    group('Bulk Temperature Updates', () {
      test('Should update all planetary temperatures', () {
        final originalPlanetTemp = testPlanet.temperature;

        TemperatureService.updateAllTemperatures(testBodies);

        // Planet temperature should have changed
        expect(testPlanet.temperature, isNot(equals(originalPlanetTemp)));
        expect(testPlanet.temperature, isFiniteNumber);
      });

      test('Should not affect star temperatures during bulk update', () {
        final originalStarTemp = testStar.temperature;

        TemperatureService.updateAllTemperatures(testBodies);

        // Star temperature should remain unchanged
        expect(testStar.temperature, equals(originalStarTemp));
      });

      test('Should handle empty body list', () {
        expect(
          () => TemperatureService.updateAllTemperatures([]),
          returnsNormally,
        );
      });
    });

    group('Initial Temperature Assignment', () {
      test('Should assign stellar temperatures based on mass', () {
        final lightStar = TemperatureService.getInitialTemperature(
          BodyType.star,
          5.0,
        );
        final heavyStar = TemperatureService.getInitialTemperature(
          BodyType.star,
          20.0,
        );

        expect(lightStar, greaterThan(0));
        expect(heavyStar, greaterThan(lightStar));
        expect(heavyStar, isFiniteNumber);
      });

      test('Should assign planetary temperatures based on distance', () {
        final nearPlanet = TemperatureService.getInitialTemperature(
          BodyType.planet,
          1.0,
          distance: 25.0, // Close to star
        );
        final farPlanet = TemperatureService.getInitialTemperature(
          BodyType.planet,
          1.0,
          distance: 100.0, // Far from star
        );

        expect(nearPlanet, greaterThan(farPlanet));
        expect(nearPlanet, isFiniteNumber);
        expect(farPlanet, isFiniteNumber);
      });

      test('Should handle planetary temperatures without distance', () {
        final temp = TemperatureService.getInitialTemperature(
          BodyType.planet,
          1.0,
        );

        expect(temp, equals(220.0)); // Default cold temperature
      });

      test('Should assign moon temperatures similar to planets', () {
        final moonTemp = TemperatureService.getInitialTemperature(
          BodyType.moon,
          0.5,
          distance: 50.0,
        );
        final planetTemp = TemperatureService.getInitialTemperature(
          BodyType.planet,
          1.0,
          distance: 50.0,
        );

        // Should be in similar range (both use same calculation)
        expect((moonTemp - planetTemp).abs(), lessThan(100));
      });

      test('Should assign cold temperatures to asteroids', () {
        final asteroidTemp = TemperatureService.getInitialTemperature(
          BodyType.asteroid,
          0.1,
        );

        expect(asteroidTemp, equals(200.0));
        expect(asteroidTemp, lessThan(273.15)); // Below freezing
      });
    });

    group('Temperature Formatting', () {
      test('Should format temperature with units by default', () {
        final formatted = TemperatureService.formatTemperature(288.15);

        expect(formatted, contains('15'));
        expect(formatted, contains('°C'));
      });

      test('Should format temperature without units when requested', () {
        final formatted = TemperatureService.formatTemperature(
          288.15,
          showUnit: false,
        );

        expect(formatted, contains('15'));
        expect(formatted, isNot(contains('°C')));
      });

      test('Should handle very high temperatures with k suffix', () {
        final formatted = TemperatureService.formatTemperature(1273.15);

        expect(formatted, contains('k'));
        expect(formatted, contains('1.0k°C'));
      });

      test('Should handle negative temperatures', () {
        final formatted = TemperatureService.formatTemperature(200.0);

        expect(formatted, contains('-73°C'));
      });

      test('Should round temperatures appropriately', () {
        final formatted = TemperatureService.formatTemperature(288.7);

        expect(formatted, contains('16°C')); // Rounded to nearest degree
      });
    });

    group('Temperature Categories', () {
      test('Should handle category method exists', () {
        // Test that the method exists - full testing requires widget test environment
        // This is a basic smoke test to ensure the method signature is correct
        expect(
          TemperatureService.getLocalizedTemperatureCategory,
          isA<Function>(),
        );
      });
    });

    group('Temperature Colors', () {
      test('Should return color for temperature visualization', () {
        final color = TemperatureService.getTemperatureColor(288.15);

        expect(color, isA<Color>());
        expect(color.alpha, equals(255)); // Should be opaque
      });

      test('Should handle extreme temperatures', () {
        final coldColor = TemperatureService.getTemperatureColor(100.0);
        final hotColor = TemperatureService.getTemperatureColor(1000.0);

        expect(coldColor, isA<Color>());
        expect(hotColor, isA<Color>());
        expect(coldColor, isNot(equals(hotColor)));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Should handle zero luminosity stars', () {
        final dimStar = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 0.5,
          name: 'Dim Star',
          bodyType: BodyType.star,
          color: Colors.red,
        );
        dimStar.stellarLuminosity = 0.0; // No luminosity

        final temperature = TemperatureService.calculatePlanetaryTemperature(
          testPlanet,
          [dimStar],
        );

        // Should fallback to cosmic background + negligible heating
        expect(
          temperature,
          closeTo(
            SimulationConstants.cosmicMicrowaveBackgroundTemperature,
            10.0,
          ),
        );
      });

      test('Should handle negative masses gracefully', () {
        expect(
          () => TemperatureService.getInitialTemperature(BodyType.planet, -1.0),
          returnsNormally,
        );
      });

      test('Should handle zero distance in initial temperature', () {
        final temp = TemperatureService.getInitialTemperature(
          BodyType.planet,
          1.0,
          distance: 0.0,
        );

        expect(temp, equals(220.0)); // Should use default
      });

      test('Should handle extremely large distances', () {
        final temp = TemperatureService.getInitialTemperature(
          BodyType.planet,
          1.0,
          distance: 1000000.0,
        );

        expect(temp, isFiniteNumber);
        expect(temp, greaterThan(0));
      });
    });
  });
}
