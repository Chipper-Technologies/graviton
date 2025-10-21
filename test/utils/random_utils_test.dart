import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/random_utils.dart';

void main() {
  group('RandomUtils Tests', () {
    late math.Random seededRandom;

    setUp(() {
      seededRandom = math.Random(
        42,
      ); // Use seeded random for reproducible tests
    });

    group('Basic Random Generation', () {
      test('should generate random range correctly', () {
        const min = 1.0;
        const max = 5.0;

        final value = RandomUtils.randomRange(min, max, seededRandom);

        expect(value, greaterThanOrEqualTo(min));
        expect(value, lessThanOrEqualTo(max));
      });

      test('should generate same value for equal min and max', () {
        const value = 3.0;

        final result = RandomUtils.randomRange(value, value, seededRandom);

        expect(result, equals(value));
      });

      test('should generate random integer correctly', () {
        const min = 1;
        const max = 10;

        final value = RandomUtils.randomInt(min, max, seededRandom);

        expect(value, greaterThanOrEqualTo(min));
        expect(value, lessThanOrEqualTo(max));
        expect(value, isA<int>());
      });

      test('should generate random angle in correct range', () {
        final angle = RandomUtils.randomAngle(seededRandom);

        expect(angle, greaterThanOrEqualTo(0.0));
        expect(angle, lessThanOrEqualTo(2 * math.pi));
      });

      test('should generate random angle with offset', () {
        const baseAngle = math.pi;
        const randomness = 0.1;

        final angle = RandomUtils.randomAngleWithOffset(
          baseAngle,
          randomness,
          seededRandom,
        );

        expect((angle - baseAngle).abs(), lessThanOrEqualTo(randomness / 2));
      });
    });

    group('Physical Property Generation', () {
      test('should generate random mass', () {
        const min = 0.5;
        const max = 2.0;

        final mass = RandomUtils.randomMass(min, max, seededRandom);

        expect(mass, greaterThanOrEqualTo(min));
        expect(mass, lessThanOrEqualTo(max));
      });

      test('should generate random radius', () {
        const min = 0.1;
        const max = 1.0;

        final radius = RandomUtils.randomRadius(min, max, seededRandom);

        expect(radius, greaterThanOrEqualTo(min));
        expect(radius, lessThanOrEqualTo(max));
      });

      test('should generate random distance', () {
        const min = 5.0;
        const max = 15.0;

        final distance = RandomUtils.randomDistance(min, max, seededRandom);

        expect(distance, greaterThanOrEqualTo(min));
        expect(distance, lessThanOrEqualTo(max));
      });

      test('should generate symmetric random height', () {
        const range = 2.0;

        final height = RandomUtils.randomHeight(range, seededRandom);

        expect(height.abs(), lessThanOrEqualTo(range / 2));
      });

      test('should generate random Z velocity with direction', () {
        const min = 0.1;
        const max = 1.0;

        final zVelocity = RandomUtils.randomZVelocity(min, max, seededRandom);

        expect(zVelocity.abs(), greaterThanOrEqualTo(min));
        expect(zVelocity.abs(), lessThanOrEqualTo(max));
      });

      test('should generate random velocity component with randomness', () {
        const baseValue = 1.0;
        const randomness = 0.2;

        final component = RandomUtils.randomVelocityComponent(
          baseValue,
          randomness,
          seededRandom,
        );

        expect(
          (component - baseValue).abs(),
          lessThanOrEqualTo(randomness / 2),
        );
      });
    });

    group('3D Position Generation', () {
      test('should generate position within sphere constraints', () {
        const minRadius = 1.0;
        const maxRadius = 3.0;
        const heightRange = 2.0;

        final position = RandomUtils.randomPositionInSphere(
          minRadius,
          maxRadius,
          heightRange,
          seededRandom,
        );

        final distance = math.sqrt(
          position.x * position.x + position.y * position.y,
        );
        expect(distance, greaterThanOrEqualTo(minRadius));
        expect(distance, lessThanOrEqualTo(maxRadius));
        expect(position.z.abs(), lessThanOrEqualTo(heightRange / 2));
      });
    });

    group('Color Generation', () {
      test('should generate stellar color', () {
        final color = RandomUtils.randomStellarColor(seededRandom);

        expect(color, isA<Color>());
        expect(
          (color.a * 255.0).round() & 0xff,
          equals(255),
        ); // Should be opaque
      });

      test('should generate planetary color', () {
        final color = RandomUtils.randomPlanetaryColor(seededRandom);

        expect(color, isA<Color>());
        expect(
          (color.a * 255.0).round() & 0xff,
          equals(255),
        ); // Should be opaque
      });

      test('should generate asteroid color with grayish tones', () {
        final color = RandomUtils.randomAsteroidColor(seededRandom);

        expect(color, isA<Color>());
        expect(
          (color.a * 255.0).round() & 0xff,
          equals(255),
        ); // Should be opaque

        // Should be grayish (components shouldn't vary too much)
        final r = ((color.r * 255.0).round() & 0xff) / 255.0;
        final g = ((color.g * 255.0).round() & 0xff) / 255.0;
        final b = ((color.b * 255.0).round() & 0xff) / 255.0;

        expect(r, greaterThan(0.2));
        expect(r, lessThan(0.8));
        expect((r - g).abs(), lessThan(0.3));
        expect((r - b).abs(), lessThan(0.3));
      });
    });

    group('Weighted Random Selection', () {
      test('should select from weighted options', () {
        final options = ['A', 'B', 'C'];
        final weights = [0.1, 0.8, 0.1]; // B is much more likely

        final selection = RandomUtils.weightedChoice(
          options,
          weights,
          seededRandom,
        );

        expect(options, contains(selection));
      });

      test('should throw error for empty options', () {
        final options = <String>[];
        final weights = <double>[];

        expect(
          () => RandomUtils.weightedChoice(options, weights, seededRandom),
          throwsArgumentError,
        );
      });

      test('should throw error for mismatched lengths', () {
        final options = ['A', 'B'];
        final weights = [0.5]; // Different length

        expect(
          () => RandomUtils.weightedChoice(options, weights, seededRandom),
          throwsArgumentError,
        );
      });

      test('should throw error for zero total weight', () {
        final options = ['A', 'B'];
        final weights = [0.0, 0.0];

        expect(
          () => RandomUtils.weightedChoice(options, weights, seededRandom),
          throwsArgumentError,
        );
      });

      test('should handle single option', () {
        final options = ['Only'];
        final weights = [1.0];

        final selection = RandomUtils.weightedChoice(
          options,
          weights,
          seededRandom,
        );

        expect(selection, equals('Only'));
      });
    });

    group('Random Boolean', () {
      test('should generate random boolean with probability', () {
        const probability = 0.7;

        final result = RandomUtils.randomBool(probability, seededRandom);

        expect(result, isA<bool>());
      });

      test('should always return true for probability 1.0', () {
        const probability = 1.0;

        final result = RandomUtils.randomBool(probability, seededRandom);

        expect(result, isTrue);
      });

      test('should always return false for probability 0.0', () {
        const probability = 0.0;

        final result = RandomUtils.randomBool(probability, seededRandom);

        expect(result, isFalse);
      });

      test('should clamp probability to valid range', () {
        expect(
          () => RandomUtils.randomBool(-0.5, seededRandom),
          returnsNormally,
        );
        expect(
          () => RandomUtils.randomBool(1.5, seededRandom),
          returnsNormally,
        );
      });
    });

    group('Statistical Distributions', () {
      test('should generate Gaussian distribution values', () {
        const mean = 5.0;
        const standardDeviation = 2.0;

        final value = RandomUtils.randomGaussian(
          mean,
          standardDeviation,
          seededRandom,
        );

        expect(value, isA<double>());
        // Value should be reasonably close to mean (within 3 standard deviations)
        expect((value - mean).abs(), lessThan(3 * standardDeviation));
      });

      test('should generate exponential distribution values', () {
        const lambda = 1.0;

        final value = RandomUtils.randomExponential(lambda, seededRandom);

        expect(
          value,
          greaterThanOrEqualTo(0),
        ); // Exponential values are non-negative
        expect(value, isA<double>());
      });

      test('should generate power law distribution values', () {
        const min = 1.0;
        const max = 10.0;
        const exponent = -2.0;

        final value = RandomUtils.randomPowerLaw(
          min,
          max,
          exponent,
          seededRandom,
        );

        expect(value, greaterThanOrEqualTo(min));
        expect(value, lessThanOrEqualTo(max));
      });

      test('should handle special case exponent -1 in power law', () {
        const min = 1.0;
        const max = 10.0;
        const exponent = -1.0;

        final value = RandomUtils.randomPowerLaw(
          min,
          max,
          exponent,
          seededRandom,
        );

        expect(value, greaterThanOrEqualTo(min));
        expect(value, lessThanOrEqualTo(max));
      });
    });

    group('Utility Functions', () {
      test('should shuffle list correctly', () {
        final originalList = [1, 2, 3, 4, 5];
        final shuffled = RandomUtils.shuffle(originalList, seededRandom);

        expect(shuffled, hasLength(originalList.length));
        // Should contain all original elements
        for (final item in originalList) {
          expect(shuffled, contains(item));
        }
        // Original list should be unchanged
        expect(originalList, equals([1, 2, 3, 4, 5]));
      });

      test('should handle empty list shuffle', () {
        final emptyList = <int>[];
        final shuffled = RandomUtils.shuffle(emptyList, seededRandom);

        expect(shuffled, isEmpty);
      });

      test('should handle single item list shuffle', () {
        final singleList = [42];
        final shuffled = RandomUtils.shuffle(singleList, seededRandom);

        expect(shuffled, equals([42]));
      });
    });

    group('Name Generation', () {
      test('should generate celestial names', () {
        final name = RandomUtils.randomCelestialName(seededRandom);

        expect(name, isA<String>());
        expect(name, isNotEmpty);
      });

      test('should generate different types of names', () {
        final names = <String>{};
        for (int i = 0; i < 20; i++) {
          names.add(RandomUtils.randomCelestialName(math.Random(i)));
        }

        expect(names, hasLength(greaterThan(1))); // Should generate variety
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle zero range in random range', () {
        const value = 5.0;
        final result = RandomUtils.randomRange(value, value, seededRandom);

        expect(result, equals(value));
      });

      test('should handle negative ranges gracefully', () {
        expect(
          () => RandomUtils.randomRange(5.0, 1.0, seededRandom),
          returnsNormally,
        );
      });

      test('should handle zero standard deviation in Gaussian', () {
        const mean = 5.0;
        const standardDeviation = 0.0;

        final value = RandomUtils.randomGaussian(
          mean,
          standardDeviation,
          seededRandom,
        );

        expect(value, equals(mean));
      });

      test('should handle zero lambda in exponential distribution', () {
        expect(
          () => RandomUtils.randomExponential(0.0, seededRandom),
          returnsNormally,
        );
      });
    });

    group('Reproducibility', () {
      test('should produce same results with same seed', () {
        final random1 = math.Random(123);
        final random2 = math.Random(123);

        final value1 = RandomUtils.randomRange(0.0, 1.0, random1);
        final value2 = RandomUtils.randomRange(0.0, 1.0, random2);

        expect(value1, equals(value2));
      });

      test('should produce different results with different seeds', () {
        final random1 = math.Random(123);
        final random2 = math.Random(456);

        final value1 = RandomUtils.randomRange(0.0, 1.0, random1);
        final value2 = RandomUtils.randomRange(0.0, 1.0, random2);

        expect(value1, isNot(equals(value2)));
      });
    });

    group('Performance Edge Cases', () {
      test('should handle large ranges efficiently', () {
        const min = -1e6;
        const max = 1e6;

        expect(
          () => RandomUtils.randomRange(min, max, seededRandom),
          returnsNormally,
        );
      });

      test('should handle very small ranges', () {
        const min = 1.0;
        const max = 1.0000001;

        final value = RandomUtils.randomRange(min, max, seededRandom);

        expect(value, greaterThanOrEqualTo(min));
        expect(value, lessThanOrEqualTo(max));
      });
    });
  });
}
