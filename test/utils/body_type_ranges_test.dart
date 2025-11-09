import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/body_type_ranges.dart';
import 'package:graviton/enums/body_type.dart';

void main() {
  group('BodyTypeRanges', () {
    group('getMassRange', () {
      test('returns correct range for star', () {
        final range = BodyTypeRanges.getMassRange(BodyType.star);
        expect(range['min'], equals(5.0));
        expect(range['max'], equals(300.0));
      });

      test('returns correct range for planet', () {
        final range = BodyTypeRanges.getMassRange(BodyType.planet);
        expect(range['min'], equals(0.5));
        expect(range['max'], equals(15.0));
      });

      test('returns correct range for moon', () {
        final range = BodyTypeRanges.getMassRange(BodyType.moon);
        expect(range['min'], equals(0.05));
        expect(range['max'], equals(2.0));
      });

      test('returns correct range for asteroid', () {
        final range = BodyTypeRanges.getMassRange(BodyType.asteroid);
        expect(range['min'], equals(0.01));
        expect(range['max'], equals(0.5));
      });

      test('min is always less than max for all body types', () {
        for (final bodyType in BodyType.values) {
          final range = BodyTypeRanges.getMassRange(bodyType);
          expect(
            range['min']!,
            lessThan(range['max']!),
            reason: 'Mass range for $bodyType should have min < max',
          );
        }
      });
    });

    group('getRadiusRange', () {
      test('returns correct range for star', () {
        final range = BodyTypeRanges.getRadiusRange(BodyType.star);
        expect(range['min'], equals(0.8));
        expect(range['max'], equals(8.0));
      });

      test('returns correct range for planet', () {
        final range = BodyTypeRanges.getRadiusRange(BodyType.planet);
        expect(range['min'], equals(0.3));
        expect(range['max'], equals(4.0));
      });

      test('returns correct range for moon', () {
        final range = BodyTypeRanges.getRadiusRange(BodyType.moon);
        expect(range['min'], equals(0.1));
        expect(range['max'], equals(1.2));
      });

      test('returns correct range for asteroid', () {
        final range = BodyTypeRanges.getRadiusRange(BodyType.asteroid);
        expect(range['min'], equals(0.05));
        expect(range['max'], equals(0.8));
      });

      test('min is always less than max for all body types', () {
        for (final bodyType in BodyType.values) {
          final range = BodyTypeRanges.getRadiusRange(bodyType);
          expect(
            range['min']!,
            lessThan(range['max']!),
            reason: 'Radius range for $bodyType should have min < max',
          );
        }
      });
    });

    group('getLuminosityRange', () {
      test('returns correct range for star', () {
        final range = BodyTypeRanges.getLuminosityRange(BodyType.star);
        expect(range['min'], equals(0.1));
        expect(range['max'], equals(10.0));
      });

      test('returns zero range for non-luminous bodies', () {
        final nonLuminousBodies = [
          BodyType.planet,
          BodyType.moon,
          BodyType.asteroid,
        ];

        for (final bodyType in nonLuminousBodies) {
          final range = BodyTypeRanges.getLuminosityRange(bodyType);
          expect(
            range['min'],
            equals(0.0),
            reason: '$bodyType should have min luminosity of 0.0',
          );
          expect(
            range['max'],
            equals(0.0),
            reason: '$bodyType should have max luminosity of 0.0',
          );
        }
      });

      test('min is always less than or equal to max for all body types', () {
        for (final bodyType in BodyType.values) {
          final range = BodyTypeRanges.getLuminosityRange(bodyType);
          expect(
            range['min']!,
            lessThanOrEqualTo(range['max']!),
            reason: 'Luminosity range for $bodyType should have min <= max',
          );
        }
      });
    });

    group('getDefaultProperties', () {
      test('returns valid defaults for star', () {
        final defaults = BodyTypeRanges.getDefaultProperties(BodyType.star);
        final massRange = BodyTypeRanges.getMassRange(BodyType.star);
        final radiusRange = BodyTypeRanges.getRadiusRange(BodyType.star);
        final luminosityRange = BodyTypeRanges.getLuminosityRange(
          BodyType.star,
        );

        expect(defaults['mass']!, greaterThanOrEqualTo(massRange['min']!));
        expect(defaults['mass']!, lessThanOrEqualTo(massRange['max']!));
        expect(defaults['radius']!, greaterThanOrEqualTo(radiusRange['min']!));
        expect(defaults['radius']!, lessThanOrEqualTo(radiusRange['max']!));
        expect(
          defaults['luminosity']!,
          greaterThanOrEqualTo(luminosityRange['min']!),
        );
        expect(
          defaults['luminosity']!,
          lessThanOrEqualTo(luminosityRange['max']!),
        );
      });

      test('returns valid defaults for planet', () {
        final defaults = BodyTypeRanges.getDefaultProperties(BodyType.planet);
        final massRange = BodyTypeRanges.getMassRange(BodyType.planet);
        final radiusRange = BodyTypeRanges.getRadiusRange(BodyType.planet);
        final luminosityRange = BodyTypeRanges.getLuminosityRange(
          BodyType.planet,
        );

        expect(defaults['mass']!, greaterThanOrEqualTo(massRange['min']!));
        expect(defaults['mass']!, lessThanOrEqualTo(massRange['max']!));
        expect(defaults['radius']!, greaterThanOrEqualTo(radiusRange['min']!));
        expect(defaults['radius']!, lessThanOrEqualTo(radiusRange['max']!));
        expect(
          defaults['luminosity']!,
          greaterThanOrEqualTo(luminosityRange['min']!),
        );
        expect(
          defaults['luminosity']!,
          lessThanOrEqualTo(luminosityRange['max']!),
        );
      });

      test('default values are in the lower portion of ranges', () {
        for (final bodyType in BodyType.values) {
          final defaults = BodyTypeRanges.getDefaultProperties(bodyType);
          final massRange = BodyTypeRanges.getMassRange(bodyType);
          final radiusRange = BodyTypeRanges.getRadiusRange(bodyType);

          // Check that defaults are around 30% of the range (lower-middle portion)
          final expectedMass =
              massRange['min']! + (massRange['max']! - massRange['min']!) * 0.3;
          final expectedRadius =
              radiusRange['min']! +
              (radiusRange['max']! - radiusRange['min']!) * 0.3;

          expect(
            defaults['mass']!,
            closeTo(expectedMass, 0.001),
            reason: 'Default mass for $bodyType should be at ~30% of range',
          );
          expect(
            defaults['radius']!,
            closeTo(expectedRadius, 0.001),
            reason: 'Default radius for $bodyType should be at ~30% of range',
          );
        }
      });

      test('contains all required properties', () {
        for (final bodyType in BodyType.values) {
          final defaults = BodyTypeRanges.getDefaultProperties(bodyType);
          expect(
            defaults.containsKey('mass'),
            isTrue,
            reason: '$bodyType defaults should contain mass',
          );
          expect(
            defaults.containsKey('radius'),
            isTrue,
            reason: '$bodyType defaults should contain radius',
          );
          expect(
            defaults.containsKey('luminosity'),
            isTrue,
            reason: '$bodyType defaults should contain luminosity',
          );
        }
      });
    });

    group('isValidMass', () {
      test('validates mass within range for star', () {
        expect(BodyTypeRanges.isValidMass(BodyType.star, 5.0), isTrue);
        expect(BodyTypeRanges.isValidMass(BodyType.star, 150.0), isTrue);
        expect(BodyTypeRanges.isValidMass(BodyType.star, 300.0), isTrue);
        expect(BodyTypeRanges.isValidMass(BodyType.star, 4.9), isFalse);
        expect(BodyTypeRanges.isValidMass(BodyType.star, 300.1), isFalse);
      });

      test('validates mass within range for planet', () {
        expect(BodyTypeRanges.isValidMass(BodyType.planet, 0.5), isTrue);
        expect(BodyTypeRanges.isValidMass(BodyType.planet, 7.5), isTrue);
        expect(BodyTypeRanges.isValidMass(BodyType.planet, 15.0), isTrue);
        expect(BodyTypeRanges.isValidMass(BodyType.planet, 0.4), isFalse);
        expect(BodyTypeRanges.isValidMass(BodyType.planet, 15.1), isFalse);
      });

      test('validates edge cases', () {
        // Test exact boundary values
        for (final bodyType in BodyType.values) {
          final range = BodyTypeRanges.getMassRange(bodyType);
          expect(
            BodyTypeRanges.isValidMass(bodyType, range['min']!),
            isTrue,
            reason: 'Minimum mass should be valid for $bodyType',
          );
          expect(
            BodyTypeRanges.isValidMass(bodyType, range['max']!),
            isTrue,
            reason: 'Maximum mass should be valid for $bodyType',
          );
        }
      });
    });

    group('isValidRadius', () {
      test('validates radius within range for star', () {
        expect(BodyTypeRanges.isValidRadius(BodyType.star, 0.8), isTrue);
        expect(BodyTypeRanges.isValidRadius(BodyType.star, 4.0), isTrue);
        expect(BodyTypeRanges.isValidRadius(BodyType.star, 8.0), isTrue);
        expect(BodyTypeRanges.isValidRadius(BodyType.star, 0.7), isFalse);
        expect(BodyTypeRanges.isValidRadius(BodyType.star, 8.1), isFalse);
      });

      test('validates radius within range for moon', () {
        expect(BodyTypeRanges.isValidRadius(BodyType.moon, 0.1), isTrue);
        expect(BodyTypeRanges.isValidRadius(BodyType.moon, 0.6), isTrue);
        expect(BodyTypeRanges.isValidRadius(BodyType.moon, 1.2), isTrue);
        expect(BodyTypeRanges.isValidRadius(BodyType.moon, 0.09), isFalse);
        expect(BodyTypeRanges.isValidRadius(BodyType.moon, 1.21), isFalse);
      });

      test('validates edge cases', () {
        for (final bodyType in BodyType.values) {
          final range = BodyTypeRanges.getRadiusRange(bodyType);
          expect(
            BodyTypeRanges.isValidRadius(bodyType, range['min']!),
            isTrue,
            reason: 'Minimum radius should be valid for $bodyType',
          );
          expect(
            BodyTypeRanges.isValidRadius(bodyType, range['max']!),
            isTrue,
            reason: 'Maximum radius should be valid for $bodyType',
          );
        }
      });
    });

    group('isValidLuminosity', () {
      test('validates luminosity within range for star', () {
        expect(BodyTypeRanges.isValidLuminosity(BodyType.star, 0.1), isTrue);
        expect(BodyTypeRanges.isValidLuminosity(BodyType.star, 5.0), isTrue);
        expect(BodyTypeRanges.isValidLuminosity(BodyType.star, 10.0), isTrue);
        expect(BodyTypeRanges.isValidLuminosity(BodyType.star, 0.09), isFalse);
        expect(BodyTypeRanges.isValidLuminosity(BodyType.star, 10.1), isFalse);
      });

      test('validates luminosity for non-luminous bodies', () {
        final nonLuminousBodies = [
          BodyType.planet,
          BodyType.moon,
          BodyType.asteroid,
        ];

        for (final bodyType in nonLuminousBodies) {
          expect(
            BodyTypeRanges.isValidLuminosity(bodyType, 0.0),
            isTrue,
            reason: '$bodyType should accept zero luminosity',
          );
          expect(
            BodyTypeRanges.isValidLuminosity(bodyType, 0.1),
            isFalse,
            reason: '$bodyType should reject positive luminosity',
          );
          expect(
            BodyTypeRanges.isValidLuminosity(bodyType, -0.1),
            isFalse,
            reason: '$bodyType should reject negative luminosity',
          );
        }
      });

      test('validates edge cases', () {
        for (final bodyType in BodyType.values) {
          final range = BodyTypeRanges.getLuminosityRange(bodyType);
          expect(
            BodyTypeRanges.isValidLuminosity(bodyType, range['min']!),
            isTrue,
            reason: 'Minimum luminosity should be valid for $bodyType',
          );
          expect(
            BodyTypeRanges.isValidLuminosity(bodyType, range['max']!),
            isTrue,
            reason: 'Maximum luminosity should be valid for $bodyType',
          );
        }
      });
    });

    group('range consistency', () {
      test('mass ranges are reasonable for each body type', () {
        final starMass = BodyTypeRanges.getMassRange(BodyType.star);
        final planetMass = BodyTypeRanges.getMassRange(BodyType.planet);
        final moonMass = BodyTypeRanges.getMassRange(BodyType.moon);
        final asteroidMass = BodyTypeRanges.getMassRange(BodyType.asteroid);

        // Stars generally have higher mass ranges than other bodies
        expect(
          starMass['max']!,
          greaterThan(planetMass['max']!),
          reason: 'Star maximum mass should exceed planet maximum mass',
        );

        // Planets can be more massive than moons in most cases
        expect(
          planetMass['max']!,
          greaterThan(moonMass['max']!),
          reason: 'Planet maximum mass should exceed moon maximum mass',
        );

        // Moons can be more massive than asteroids
        expect(
          moonMass['max']!,
          greaterThan(asteroidMass['max']!),
          reason: 'Moon maximum mass should exceed asteroid maximum mass',
        );

        // Minimum asteroid mass should be smallest
        expect(
          asteroidMass['min']!,
          lessThan(moonMass['min']!),
          reason: 'Asteroid minimum mass should be less than moon minimum mass',
        );
      });

      test('radius ranges are reasonable for each body type', () {
        final starRadius = BodyTypeRanges.getRadiusRange(BodyType.star);
        final planetRadius = BodyTypeRanges.getRadiusRange(BodyType.planet);
        final moonRadius = BodyTypeRanges.getRadiusRange(BodyType.moon);
        final asteroidRadius = BodyTypeRanges.getRadiusRange(BodyType.asteroid);

        // Stars can be much larger than planets in their maximum range
        expect(
          starRadius['max']!,
          greaterThan(planetRadius['max']!),
          reason: 'Star maximum radius should exceed planet maximum radius',
        );

        // Planets can be larger than moons in most cases
        expect(
          planetRadius['max']!,
          greaterThan(moonRadius['max']!),
          reason: 'Planet maximum radius should exceed moon maximum radius',
        );

        // Moons can be larger than asteroids
        expect(
          moonRadius['max']!,
          greaterThan(asteroidRadius['max']!),
          reason: 'Moon maximum radius should exceed asteroid maximum radius',
        );

        // Minimum asteroid radius should be smallest
        expect(
          asteroidRadius['min']!,
          lessThan(moonRadius['min']!),
          reason:
              'Asteroid minimum radius should be less than moon minimum radius',
        );
      });

      test('luminosity ranges are logical', () {
        final starLuminosity = BodyTypeRanges.getLuminosityRange(BodyType.star);
        final planetLuminosity = BodyTypeRanges.getLuminosityRange(
          BodyType.planet,
        );

        // Only stars should be luminous
        expect(
          starLuminosity['max']!,
          greaterThan(0.0),
          reason: 'Stars should have positive luminosity',
        );
        expect(
          planetLuminosity['max'],
          equals(0.0),
          reason: 'Planets should have zero luminosity',
        );
      });
    });

    group('utility class behavior', () {
      test('cannot be instantiated', () {
        // This test ensures the private constructor prevents instantiation
        // We can't directly test this in Dart, but we document the expectation
        expect(
          () => BodyTypeRanges,
          returnsNormally,
          reason: 'BodyTypeRanges class should be accessible',
        );

        // All methods should be static and accessible without instantiation
        expect(
          BodyTypeRanges.getMassRange(BodyType.star),
          isA<Map<String, double>>(),
        );
        expect(
          BodyTypeRanges.getRadiusRange(BodyType.planet),
          isA<Map<String, double>>(),
        );
        expect(
          BodyTypeRanges.getLuminosityRange(BodyType.moon),
          isA<Map<String, double>>(),
        );
      });
    });
  });
}
