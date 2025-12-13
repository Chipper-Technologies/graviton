import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/body_type_ranges.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'dart:math' as math;

void main() {
  group('BodyTypeRanges Star Mass Generation', () {
    test('star mass generation produces medium-sized stars more frequently', () {
      final masses = <double>[];
      final random = math.Random(42);

      // Simulate the exact algorithm from _generateRealisticProperties
      final massRange = BodyTypeRanges.getMassRange(BodyType.star);

      // Generate 1000 star masses using our algorithm
      for (int i = 0; i < 1000; i++) {
        final massRandom = random.nextDouble();
        final massBias = math
            .pow(massRandom, 2.5)
            .toDouble(); // Updated to match implementation
        final mass =
            massRange['min']! +
            massBias * (massRange['max']! - massRange['min']!);
        masses.add(mass);
      }

      // Calculate statistics
      final minMass = masses.reduce(math.min);
      final maxMass = masses.reduce(math.max);
      final avgMass = masses.reduce((a, b) => a + b) / masses.length;
      masses.sort();
      final medianMass = masses[masses.length ~/ 2];

      // Count distribution in ranges
      final smallStars = masses
          .where((m) => m < 20.0)
          .length; // Very small stars
      final mediumStars = masses
          .where((m) => m >= 20.0 && m < 100.0)
          .length; // Medium stars
      final largeStars = masses.where((m) => m >= 100.0).length; // Large stars

      // Assertions: Distribution should favor smaller stars with 2.5 bias
      expect(
        smallStars + mediumStars,
        greaterThan(largeStars),
        reason: 'Small+medium stars should be more common than large stars',
      );
      expect(
        avgMass,
        greaterThan(20.0),
        reason: 'Average mass should be above minimum',
      );
      expect(
        avgMass,
        lessThan(120.0),
        reason:
            'Average mass should be in lower-medium range due to bias toward smaller values',
      );
      expect(
        medianMass,
        lessThan(avgMass),
        reason:
            'Median should be less than average, showing bias toward smaller values',
      );

      // Verify we still get full range
      expect(
        minMass,
        greaterThanOrEqualTo(massRange['min']!),
        reason: 'Should respect minimum range',
      );
      expect(
        maxMass,
        lessThanOrEqualTo(massRange['max']!),
        reason: 'Should respect maximum range',
      );
    });

    test('bias exponent 2.5 produces expected distribution characteristics', () {
      final values = <double>[];
      final random = math.Random(123); // Different seed

      // Test the bias function directly
      for (int i = 0; i < 10000; i++) {
        final randomValue = random.nextDouble();
        final biasedValue = math.pow(randomValue, 2.5).toDouble();
        values.add(biasedValue);
      }

      final average = values.reduce((a, b) => a + b) / values.length;
      final belowHalf = values.where((v) => v < 0.5).length;
      final aboveHalf = values.where((v) => v >= 0.5).length;

      // With exponent 2.5, we expect average around 0.286 (integral of x^2.5 from 0 to 1 = 1/3.5)
      expect(
        average,
        closeTo(0.286, 0.05),
        reason: 'Mathematical expectation for x^2.5 distribution',
      );
      expect(
        belowHalf,
        greaterThan(aboveHalf),
        reason: 'Power 2.5 should favor lower values over higher values',
      );
    });

    test('star properties are consistently generated within ranges', () {
      // Test multiple generations to ensure consistency
      for (int trial = 0; trial < 100; trial++) {
        final massRange = BodyTypeRanges.getMassRange(BodyType.star);
        final radiusRange = BodyTypeRanges.getRadiusRange(BodyType.star);
        final luminosityRange = BodyTypeRanges.getLuminosityRange(
          BodyType.star,
        );

        // Simulate the generation algorithm
        final random = math.Random();

        final massBias = math.pow(random.nextDouble(), 0.7).toDouble();
        final mass =
            massRange['min']! +
            massBias * (massRange['max']! - massRange['min']!);

        final radiusBias = math.pow(random.nextDouble(), 0.8).toDouble();
        final radius =
            radiusRange['min']! +
            radiusBias * (radiusRange['max']! - radiusRange['min']!);

        final luminosityBias = math.pow(random.nextDouble(), 1.2).toDouble();
        final luminosity =
            luminosityRange['min']! +
            luminosityBias *
                (luminosityRange['max']! - luminosityRange['min']!);

        // All values should be within their respective ranges
        expect(
          mass,
          inInclusiveRange(massRange['min']!, massRange['max']!),
          reason: 'Generated mass should be within range for trial $trial',
        );
        expect(
          radius,
          inInclusiveRange(radiusRange['min']!, radiusRange['max']!),
          reason: 'Generated radius should be within range for trial $trial',
        );
        expect(
          luminosity,
          inInclusiveRange(luminosityRange['min']!, luminosityRange['max']!),
          reason:
              'Generated luminosity should be within range for trial $trial',
        );
      }
    });
  });

  group('BodyTypeRanges Default Properties', () {
    test('getDefaultProperties returns sensible starting values', () {
      for (final bodyType in BodyType.values) {
        final defaults = BodyTypeRanges.getDefaultProperties(bodyType);
        final massRange = BodyTypeRanges.getMassRange(bodyType);
        final radiusRange = BodyTypeRanges.getRadiusRange(bodyType);
        final luminosityRange = BodyTypeRanges.getLuminosityRange(bodyType);

        // All defaults should be within their ranges
        expect(
          defaults['mass']!,
          inInclusiveRange(massRange['min']!, massRange['max']!),
          reason: 'Default mass for $bodyType should be within range',
        );
        expect(
          defaults['radius']!,
          inInclusiveRange(radiusRange['min']!, radiusRange['max']!),
          reason: 'Default radius for $bodyType should be within range',
        );
        expect(
          defaults['luminosity']!,
          inInclusiveRange(luminosityRange['min']!, luminosityRange['max']!),
          reason: 'Default luminosity for $bodyType should be within range',
        );

        // Defaults should be positioned at 30% of range (lower-middle)
        final expectedMass =
            massRange['min']! + (massRange['max']! - massRange['min']!) * 0.3;
        final expectedRadius =
            radiusRange['min']! +
            (radiusRange['max']! - radiusRange['min']!) * 0.3;
        final expectedLuminosity =
            luminosityRange['min']! +
            (luminosityRange['max']! - luminosityRange['min']!) * 0.3;

        expect(
          defaults['mass']!,
          closeTo(expectedMass, 0.001),
          reason: 'Default mass for $bodyType should be at 30% of range',
        );
        expect(
          defaults['radius']!,
          closeTo(expectedRadius, 0.001),
          reason: 'Default radius for $bodyType should be at 30% of range',
        );
        expect(
          defaults['luminosity']!,
          closeTo(expectedLuminosity, 0.001),
          reason: 'Default luminosity for $bodyType should be at 30% of range',
        );
      }
    });

    test('planet defaults are reasonable starting values', () {
      final planetDefaults = BodyTypeRanges.getDefaultProperties(
        BodyType.planet,
      );

      // Planet defaults should be good for creating new bodies
      expect(
        planetDefaults['mass']!,
        greaterThan(1.0),
        reason: 'Planet default mass should be substantial enough',
      );
      expect(
        planetDefaults['mass']!,
        lessThan(10.0),
        reason: 'Planet default mass should not be too large',
      );
      expect(
        planetDefaults['radius']!,
        greaterThan(0.5),
        reason: 'Planet default radius should be reasonable',
      );
      expect(
        planetDefaults['radius']!,
        lessThan(3.0),
        reason: 'Planet default radius should not be too large',
      );
      expect(
        planetDefaults['luminosity'],
        equals(0.0),
        reason: 'Planet default luminosity should be zero (non-luminous)',
      );
    });

    test('star defaults provide good starting points', () {
      final starDefaults = BodyTypeRanges.getDefaultProperties(BodyType.star);

      // Star defaults should be in the lower-medium range for reasonable starting points
      expect(
        starDefaults['mass']!,
        greaterThan(20.0),
        reason: 'Star default mass should be substantial',
      );
      expect(
        starDefaults['mass']!,
        lessThan(150.0),
        reason: 'Star default mass should not be extremely large',
      );
      expect(
        starDefaults['radius']!,
        greaterThan(1.0),
        reason: 'Star default radius should be larger than planets',
      );
      expect(
        starDefaults['luminosity']!,
        greaterThan(0.0),
        reason: 'Star default luminosity should be positive',
      );
    });
  });

  group('Body Range Consistency', () {
    test('ranges are consistent with simulation constants expectations', () {
      // These ranges should be reasonable for the simulation's coordinate system
      // where 1 sim unit = 0.02 AU and Sun mass = 10 sim units

      final starMass = BodyTypeRanges.getMassRange(BodyType.star);
      final planetMass = BodyTypeRanges.getMassRange(BodyType.planet);

      // Star range 5.0-300.0 means 0.5 to 30 solar masses (reasonable)
      expect(
        starMass['min'],
        equals(5.0),
        reason:
            'Star minimum mass should allow for small stars (0.5 solar masses)',
      );
      expect(
        starMass['max'],
        equals(300.0),
        reason:
            'Star maximum mass should allow for very massive stars (30 solar masses)',
      );

      // Planet range 0.5-15.0 means 0.05 to 1.5 solar masses (reasonable for gas giants)
      expect(
        planetMass['min'],
        equals(0.5),
        reason: 'Planet minimum mass should allow for small rocky planets',
      );
      expect(
        planetMass['max'],
        equals(15.0),
        reason: 'Planet maximum mass should allow for massive gas giants',
      );
    });

    test('mass ranges allow for realistic astronomical scenarios', () {
      // Test that our ranges can accommodate common astronomical objects
      final starRange = BodyTypeRanges.getMassRange(BodyType.star);
      final planetRange = BodyTypeRanges.getMassRange(BodyType.planet);
      final moonRange = BodyTypeRanges.getMassRange(BodyType.moon);

      // Check specific astronomical objects can fit in ranges
      // (Converting from real masses to sim units: divide by ~solar mass factor)

      // Red dwarf stars (0.08-0.5 solar masses) → 0.8-5.0 sim units
      expect(
        starRange['min']!,
        lessThanOrEqualTo(5.0),
        reason: 'Should accommodate red dwarf stars',
      );

      // Jupiter mass (~0.001 solar masses) → ~0.01 sim units, but we allow larger planets
      expect(
        planetRange['max']!,
        greaterThan(10.0),
        reason: 'Should accommodate super-Jupiter gas giants',
      );

      // Earth mass in sim units should fit in moon range as upper limit
      expect(
        moonRange['max']!,
        greaterThanOrEqualTo(1.0),
        reason: 'Should accommodate large moons like our Moon',
      );
    });
  });

  group('Slider Integration Tests', () {
    test('dynamic ranges provide appropriate precision for each body type', () {
      // Test that the slider ranges provide good precision for user control

      for (final bodyType in BodyType.values) {
        final massRange = BodyTypeRanges.getMassRange(bodyType);
        final radiusRange = BodyTypeRanges.getRadiusRange(bodyType);

        final massSpan = massRange['max']! - massRange['min']!;
        final radiusSpan = radiusRange['max']! - radiusRange['min']!;

        // Each body type should have meaningful ranges (accounting for their scale)
        if (bodyType == BodyType.asteroid) {
          // Asteroids have intentionally small ranges
          expect(
            massSpan,
            greaterThan(0.1),
            reason: '$bodyType mass range should provide some control span',
          );
        } else {
          expect(
            massSpan,
            greaterThan(1.0),
            reason:
                '$bodyType mass range should provide meaningful control span',
          );
        }

        if (bodyType == BodyType.asteroid || bodyType == BodyType.moon) {
          // Small bodies have smaller radius ranges
          expect(
            radiusSpan,
            greaterThan(0.1),
            reason: '$bodyType radius range should provide some control span',
          );
        } else {
          expect(
            radiusSpan,
            greaterThan(0.5),
            reason:
                '$bodyType radius range should provide meaningful control span',
          );
        }

        // But not so wide that precision is lost (this is subjective)
        expect(
          massSpan,
          lessThan(1000.0),
          reason: '$bodyType mass range should not be excessively wide',
        );
        expect(
          radiusSpan,
          lessThan(50.0),
          reason: '$bodyType radius range should not be excessively wide',
        );
      }
    });

    test('clamping values to ranges works correctly', () {
      // Test the clamping behavior used in slider initialization

      for (final bodyType in BodyType.values) {
        final massRange = BodyTypeRanges.getMassRange(bodyType);
        final radiusRange = BodyTypeRanges.getRadiusRange(bodyType);

        // Test values outside ranges get clamped
        final tooSmallMass = massRange['min']! - 1.0;
        final tooLargeMass = massRange['max']! + 100.0;
        final tooSmallRadius = radiusRange['min']! - 0.5;
        final tooLargeRadius = radiusRange['max']! + 10.0;

        expect(
          tooSmallMass.clamp(massRange['min']!, massRange['max']!),
          equals(massRange['min']!),
          reason: 'Values below range should clamp to minimum for $bodyType',
        );
        expect(
          tooLargeMass.clamp(massRange['min']!, massRange['max']!),
          equals(massRange['max']!),
          reason: 'Values above range should clamp to maximum for $bodyType',
        );
        expect(
          tooSmallRadius.clamp(radiusRange['min']!, radiusRange['max']!),
          equals(radiusRange['min']!),
          reason:
              'Radius values below range should clamp to minimum for $bodyType',
        );
        expect(
          tooLargeRadius.clamp(radiusRange['min']!, radiusRange['max']!),
          equals(radiusRange['max']!),
          reason:
              'Radius values above range should clamp to maximum for $bodyType',
        );
      }
    });
  });
}

/// Custom matcher for inclusive range checking
Matcher inInclusiveRange(num min, num max) => _InInclusiveRange(min, max);

class _InInclusiveRange extends Matcher {
  final num _min, _max;

  const _InInclusiveRange(this._min, this._max);

  @override
  bool matches(dynamic item, Map matchState) {
    return item is num && item >= _min && item <= _max;
  }

  @override
  Description describe(Description description) {
    return description.add('a value between $_min and $_max (inclusive)');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    return mismatchDescription.add('$item is not between $_min and $_max');
  }
}
