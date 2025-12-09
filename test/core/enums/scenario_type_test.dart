import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/scenario_type.dart';

void main() {
  group('ScenarioType Enum', () {
    test('should have all expected scenario types', () {
      expect(ScenarioType.values.length, equals(10));
      expect(ScenarioType.values, contains(ScenarioType.random));
      expect(ScenarioType.values, contains(ScenarioType.earthMoonSun));
      expect(ScenarioType.values, contains(ScenarioType.binaryStars));
      expect(ScenarioType.values, contains(ScenarioType.asteroidBelt));
      expect(ScenarioType.values, contains(ScenarioType.galaxyFormation));
      expect(ScenarioType.values, contains(ScenarioType.solarSystem));
      expect(ScenarioType.values, contains(ScenarioType.threeBodyClassic));
      expect(ScenarioType.values, contains(ScenarioType.collisionDemo));
      expect(ScenarioType.values, contains(ScenarioType.deepSpace));
      expect(ScenarioType.values, contains(ScenarioType.custom));
    });

    test('should convert from string correctly', () {
      expect(ScenarioType.fromString('random'), equals(ScenarioType.random));
      expect(
        ScenarioType.fromString('earth_moon_sun'),
        equals(ScenarioType.earthMoonSun),
      );
      expect(
        ScenarioType.fromString('binary_star'),
        equals(ScenarioType.binaryStars),
      );
      expect(
        ScenarioType.fromString('asteroid_belt'),
        equals(ScenarioType.asteroidBelt),
      );
      expect(
        ScenarioType.fromString('galaxy_formation'),
        equals(ScenarioType.galaxyFormation),
      );
      expect(
        ScenarioType.fromString('solar_system'),
        equals(ScenarioType.solarSystem),
      );
      expect(
        ScenarioType.fromString('three_body_classic'),
        equals(ScenarioType.threeBodyClassic),
      );
      expect(
        ScenarioType.fromString('collision_demo'),
        equals(ScenarioType.collisionDemo),
      );
      expect(
        ScenarioType.fromString('deep_space'),
        equals(ScenarioType.deepSpace),
      );
      expect(ScenarioType.fromString('custom'), equals(ScenarioType.custom));
    });

    test('should throw ArgumentError for invalid string', () {
      expect(() => ScenarioType.fromString('invalid'), throwsArgumentError);
      expect(() => ScenarioType.fromString(''), throwsArgumentError);
      expect(() => ScenarioType.fromString('RANDOM'), throwsArgumentError);
    });

    test('should have correct name keys', () {
      expect(ScenarioType.random.nameKey, equals('scenarioRandom'));
      expect(ScenarioType.earthMoonSun.nameKey, equals('scenarioEarthMoonSun'));
      expect(ScenarioType.binaryStars.nameKey, equals('scenarioBinaryStars'));
      expect(ScenarioType.asteroidBelt.nameKey, equals('scenarioAsteroidBelt'));
      expect(
        ScenarioType.galaxyFormation.nameKey,
        equals('scenarioGalaxyFormation'),
      );
      expect(ScenarioType.solarSystem.nameKey, equals('scenarioSolarSystem'));
      expect(
        ScenarioType.threeBodyClassic.nameKey,
        equals('scenarioThreeBodyClassic'),
      );
      expect(
        ScenarioType.collisionDemo.nameKey,
        equals('scenarioCollisionDemo'),
      );
      expect(ScenarioType.deepSpace.nameKey, equals('scenarioDeepSpace'));
      expect(ScenarioType.custom.nameKey, equals('scenarioCustom'));
    });

    test('should have correct description keys', () {
      expect(
        ScenarioType.random.descriptionKey,
        equals('scenarioRandomDescription'),
      );
      expect(
        ScenarioType.earthMoonSun.descriptionKey,
        equals('scenarioEarthMoonSunDescription'),
      );
      expect(
        ScenarioType.binaryStars.descriptionKey,
        equals('scenarioBinaryStarsDescription'),
      );
      expect(
        ScenarioType.asteroidBelt.descriptionKey,
        equals('scenarioAsteroidBeltDescription'),
      );
      expect(
        ScenarioType.galaxyFormation.descriptionKey,
        equals('scenarioGalaxyFormationDescription'),
      );
      expect(
        ScenarioType.solarSystem.descriptionKey,
        equals('scenarioSolarSystemDescription'),
      );
      expect(
        ScenarioType.threeBodyClassic.descriptionKey,
        equals('scenarioThreeBodyClassicDescription'),
      );
      expect(
        ScenarioType.collisionDemo.descriptionKey,
        equals('scenarioCollisionDemoDescription'),
      );
      expect(
        ScenarioType.deepSpace.descriptionKey,
        equals('scenarioDeepSpaceDescription'),
      );
      expect(
        ScenarioType.custom.descriptionKey,
        equals('scenarioCustomDescription'),
      );
    });

    test('should have correct string values', () {
      expect(ScenarioType.random.stringValue, equals('random'));
      expect(ScenarioType.earthMoonSun.stringValue, equals('earth_moon_sun'));
      expect(ScenarioType.binaryStars.stringValue, equals('binary_star'));
      expect(ScenarioType.asteroidBelt.stringValue, equals('asteroid_belt'));
      expect(
        ScenarioType.galaxyFormation.stringValue,
        equals('galaxy_formation'),
      );
      expect(ScenarioType.solarSystem.stringValue, equals('solar_system'));
      expect(
        ScenarioType.threeBodyClassic.stringValue,
        equals('three_body_classic'),
      );
      expect(ScenarioType.collisionDemo.stringValue, equals('collision_demo'));
      expect(ScenarioType.deepSpace.stringValue, equals('deep_space'));
      expect(ScenarioType.custom.stringValue, equals('custom'));
    });

    test('should have consistent fromString and stringValue', () {
      for (final scenario in ScenarioType.values) {
        final stringValue = scenario.stringValue;
        final parsedBack = ScenarioType.fromString(stringValue);
        expect(
          parsedBack,
          equals(scenario),
          reason: 'fromString(${scenario.stringValue}) should equal $scenario',
        );
      }
    });
  });
}
