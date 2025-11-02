import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/celestial_body_name.dart';

void main() {
  group('CelestialBodyName Enum', () {
    test('should correctly identify solar system planets', () {
      expect(CelestialBodyName.mercury.isSolarSystemPlanet, isTrue);
      expect(CelestialBodyName.venus.isSolarSystemPlanet, isTrue);
      expect(CelestialBodyName.earth.isSolarSystemPlanet, isTrue);
      expect(CelestialBodyName.mars.isSolarSystemPlanet, isTrue);
      expect(CelestialBodyName.jupiter.isSolarSystemPlanet, isTrue);
      expect(CelestialBodyName.saturn.isSolarSystemPlanet, isTrue);
      expect(CelestialBodyName.uranus.isSolarSystemPlanet, isTrue);
      expect(CelestialBodyName.neptune.isSolarSystemPlanet, isTrue);

      // Non-planets should return false
      expect(CelestialBodyName.sun.isSolarSystemPlanet, isFalse);
      expect(CelestialBodyName.moon.isSolarSystemPlanet, isFalse);
      expect(CelestialBodyName.alpha.isSolarSystemPlanet, isFalse);
    });

    test('should correctly identify stars', () {
      expect(CelestialBodyName.sun.isStar, isTrue);
      expect(CelestialBodyName.starA.isStar, isTrue);
      expect(CelestialBodyName.starB.isStar, isTrue);
      expect(CelestialBodyName.centralStar.isStar, isTrue);
      expect(CelestialBodyName.alpha.isStar, isTrue);
      expect(CelestialBodyName.beta.isStar, isTrue);
      expect(CelestialBodyName.gamma.isStar, isTrue);

      // Non-stars should return false
      expect(CelestialBodyName.earth.isStar, isFalse);
      expect(CelestialBodyName.moon.isStar, isFalse);
      expect(CelestialBodyName.blackHole.isStar, isFalse);
    });

    test('should correctly identify black holes', () {
      expect(CelestialBodyName.blackHole.isBlackHole, isTrue);
      expect(CelestialBodyName.supermassiveBlackHole.isBlackHole, isTrue);

      // Non-black holes should return false
      expect(CelestialBodyName.sun.isBlackHole, isFalse);
      expect(CelestialBodyName.earth.isBlackHole, isFalse);
      expect(CelestialBodyName.alpha.isBlackHole, isFalse);
    });

    test('should correctly identify moons', () {
      expect(CelestialBodyName.moon.isMoon, isTrue);
      expect(CelestialBodyName.moonM.isMoon, isTrue);

      // Non-moons should return false
      expect(CelestialBodyName.earth.isMoon, isFalse);
      expect(CelestialBodyName.sun.isMoon, isFalse);
    });

    test('should parse string names correctly', () {
      expect(
        CelestialBodyName.fromString('Sun'),
        equals(CelestialBodyName.sun),
      );
      expect(
        CelestialBodyName.fromString('Earth'),
        equals(CelestialBodyName.earth),
      );
      expect(
        CelestialBodyName.fromString('Moon'),
        equals(CelestialBodyName.moon),
      );
      expect(
        CelestialBodyName.fromString('Jupiter'),
        equals(CelestialBodyName.jupiter),
      );
      expect(
        CelestialBodyName.fromString('Black Hole'),
        equals(CelestialBodyName.blackHole),
      );
      expect(
        CelestialBodyName.fromString('Star A'),
        equals(CelestialBodyName.starA),
      );
      expect(
        CelestialBodyName.fromString('Central Star'),
        equals(CelestialBodyName.centralStar),
      );

      // Should return null for unknown names
      expect(CelestialBodyName.fromString('Unknown Body'), isNull);
    });

    test('should parse numbered body names correctly', () {
      expect(
        CelestialBodyName.fromString('Asteroid 1'),
        equals(CelestialBodyName.asteroid),
      );
      expect(
        CelestialBodyName.fromString('Star 42'),
        equals(CelestialBodyName.star),
      );
      expect(
        CelestialBodyName.fromString('Ring 5'),
        equals(CelestialBodyName.ring),
      );

      // Should return null for unknown numbered names
      expect(CelestialBodyName.fromString('Unknown 1'), isNull);
    });

    test('should match body names correctly', () {
      expect(CelestialBodyName.sun.matches('Sun'), isTrue);
      expect(CelestialBodyName.earth.matches('Earth'), isTrue);
      expect(CelestialBodyName.asteroid.matches('Asteroid 1'), isTrue);
      expect(CelestialBodyName.asteroid.matches('Asteroid 42'), isTrue);
      expect(CelestialBodyName.star.matches('Star 5'), isTrue);

      // Should not match incorrect names
      expect(CelestialBodyName.sun.matches('Moon'), isFalse);
      expect(CelestialBodyName.asteroid.matches('Star 1'), isFalse);
    });

    test('should provide fallback localized names when l10n is null', () {
      expect(CelestialBodyName.sun.getLocalizedName(null), equals('Sun'));
      expect(CelestialBodyName.earth.getLocalizedName(null), equals('Earth'));
      expect(
        CelestialBodyName.blackHole.getLocalizedName(null),
        equals('Black Hole'),
      );
    });

    test('should provide fallback numbered names when l10n is null', () {
      expect(
        CelestialBodyName.asteroid.getNumberedLocalizedName(null, 1),
        equals('Asteroid 1'),
      );
      expect(
        CelestialBodyName.star.getNumberedLocalizedName(null, 42),
        equals('Star 42'),
      );
    });

    test('should have all defined body types', () {
      // Test that all expected celestial bodies are defined
      final expectedBodies = [
        'Sun',
        'Mercury',
        'Venus',
        'Earth',
        'Moon',
        'Mars',
        'Jupiter',
        'Saturn',
        'Uranus',
        'Neptune',
        'Pluto',
        'Moon M',
        'Alpha',
        'Beta',
        'Gamma',
        'Star A',
        'Star B',
        'Black Hole',
        'Supermassive Black Hole',
        'Central Star',
        'Asteroid',
        'Star',
        'Ring',
        'Fragment',
        'Planetoid',
      ];

      for (final bodyName in expectedBodies) {
        final parsed = CelestialBodyName.fromString(bodyName);
        expect(
          parsed,
          isNotNull,
          reason: 'Body name "$bodyName" should be parseable',
        );
        expect(parsed!.value, equals(bodyName));
      }
    });

    test('should correctly group body types', () {
      expect(CelestialBodyName.solarSystemPlanets, hasLength(8));
      expect(CelestialBodyName.threeBodySystem, hasLength(3));
      expect(
        CelestialBodyName.binaryStarSystem,
        hasLength(3),
      ); // starA, starB, planetP

      expect(
        CelestialBodyName.solarSystemPlanets,
        contains(CelestialBodyName.earth),
      );
      expect(
        CelestialBodyName.threeBodySystem,
        contains(CelestialBodyName.alpha),
      );
      expect(
        CelestialBodyName.binaryStarSystem,
        contains(CelestialBodyName.starA),
      );
      expect(
        CelestialBodyName.binaryStarSystem,
        contains(CelestialBodyName.planetP),
      );
    });
  });
}
