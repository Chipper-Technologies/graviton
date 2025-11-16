import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/success_criteria.dart';

void main() {
  group('SuccessCriteria', () {
    group('constructor and properties', () {
      test('creates instance with all required properties', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.5,
          minimumTime: 300,
          allowedCollisions: 2,
        );

        expect(criteria.stabilityThreshold, equals(0.5));
        expect(criteria.minimumTime, equals(300));
        expect(criteria.allowedCollisions, equals(2));
      });

      test('handles zero values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.0,
          minimumTime: 0,
          allowedCollisions: 0,
        );

        expect(criteria.stabilityThreshold, equals(0.0));
        expect(criteria.minimumTime, equals(0));
        expect(criteria.allowedCollisions, equals(0));
      });

      test('handles negative values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: -0.1,
          minimumTime: -100,
          allowedCollisions: -1,
        );

        expect(criteria.stabilityThreshold, equals(-0.1));
        expect(criteria.minimumTime, equals(-100));
        expect(criteria.allowedCollisions, equals(-1));
      });

      test('handles large values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 1e6,
          minimumTime: 2147483647, // Max int32
          allowedCollisions: 1000000,
        );

        expect(criteria.stabilityThreshold, equals(1e6));
        expect(criteria.minimumTime, equals(2147483647));
        expect(criteria.allowedCollisions, equals(1000000));
      });

      test('handles very small positive values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 1e-10,
          minimumTime: 1,
          allowedCollisions: 1,
        );

        expect(criteria.stabilityThreshold, equals(1e-10));
        expect(criteria.minimumTime, equals(1));
        expect(criteria.allowedCollisions, equals(1));
      });

      test('handles fractional threshold values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.123456789,
          minimumTime: 100,
          allowedCollisions: 0,
        );

        expect(criteria.stabilityThreshold, closeTo(0.123456789, 1e-15));
        expect(criteria.minimumTime, equals(100));
        expect(criteria.allowedCollisions, equals(0));
      });
    });

    group('fromJson factory constructor', () {
      test('creates from complete JSON map', () {
        final json = {
          'stabilityThreshold': 0.8,
          'minimumTime': 600,
          'allowedCollisions': 1,
        };

        final criteria = SuccessCriteria.fromJson(json);

        expect(criteria.stabilityThreshold, equals(0.8));
        expect(criteria.minimumTime, equals(600));
        expect(criteria.allowedCollisions, equals(1));
      });

      test('handles integer values for threshold', () {
        final json = {
          'stabilityThreshold': 1, // Integer instead of double
          'minimumTime': 300,
          'allowedCollisions': 0,
        };

        final criteria = SuccessCriteria.fromJson(json);

        expect(criteria.stabilityThreshold, equals(1.0));
      });

      test('handles double values for integer fields', () {
        final json = {
          'stabilityThreshold': 0.5,
          'minimumTime': 300.0, // Double instead of int
          'allowedCollisions': 2.0, // Double instead of int
        };

        final criteria = SuccessCriteria.fromJson(json);

        expect(criteria.minimumTime, equals(300));
        expect(criteria.allowedCollisions, equals(2));
      });

      test('handles very large numbers', () {
        final json = {
          'stabilityThreshold': 1e20,
          'minimumTime': 9999999,
          'allowedCollisions': 1000000,
        };

        final criteria = SuccessCriteria.fromJson(json);

        expect(criteria.stabilityThreshold, equals(1e20));
        expect(criteria.minimumTime, equals(9999999));
        expect(criteria.allowedCollisions, equals(1000000));
      });

      test('handles very small numbers', () {
        final json = {
          'stabilityThreshold': 1e-20,
          'minimumTime': 1,
          'allowedCollisions': 0,
        };

        final criteria = SuccessCriteria.fromJson(json);

        expect(criteria.stabilityThreshold, equals(1e-20));
      });

      test('handles zero values in JSON', () {
        final json = {
          'stabilityThreshold': 0,
          'minimumTime': 0,
          'allowedCollisions': 0,
        };

        final criteria = SuccessCriteria.fromJson(json);

        expect(criteria.stabilityThreshold, equals(0.0));
        expect(criteria.minimumTime, equals(0));
        expect(criteria.allowedCollisions, equals(0));
      });

      test('handles negative values in JSON', () {
        final json = {
          'stabilityThreshold': -0.5,
          'minimumTime': -100,
          'allowedCollisions': -1,
        };

        final criteria = SuccessCriteria.fromJson(json);

        expect(criteria.stabilityThreshold, equals(-0.5));
        expect(criteria.minimumTime, equals(-100));
        expect(criteria.allowedCollisions, equals(-1));
      });
    });

    group('toJson method', () {
      test('converts to JSON correctly', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.75,
          minimumTime: 450,
          allowedCollisions: 3,
        );

        final json = criteria.toJson();

        expect(json['stabilityThreshold'], equals(0.75));
        expect(json['minimumTime'], equals(450));
        expect(json['allowedCollisions'], equals(3));
      });

      test('converts zero values to JSON', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.0,
          minimumTime: 0,
          allowedCollisions: 0,
        );

        final json = criteria.toJson();

        expect(json['stabilityThreshold'], equals(0.0));
        expect(json['minimumTime'], equals(0));
        expect(json['allowedCollisions'], equals(0));
      });

      test('converts negative values to JSON', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: -0.2,
          minimumTime: -50,
          allowedCollisions: -1,
        );

        final json = criteria.toJson();

        expect(json['stabilityThreshold'], equals(-0.2));
        expect(json['minimumTime'], equals(-50));
        expect(json['allowedCollisions'], equals(-1));
      });

      test('converts very large values to JSON', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 1e15,
          minimumTime: 2000000000,
          allowedCollisions: 999999,
        );

        final json = criteria.toJson();

        expect(json['stabilityThreshold'], equals(1e15));
        expect(json['minimumTime'], equals(2000000000));
        expect(json['allowedCollisions'], equals(999999));
      });

      test('converts very small values to JSON', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 1e-15,
          minimumTime: 1,
          allowedCollisions: 0,
        );

        final json = criteria.toJson();

        expect(json['stabilityThreshold'], equals(1e-15));
        expect(json['minimumTime'], equals(1));
        expect(json['allowedCollisions'], equals(0));
      });

      test('returns map with correct keys', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.5,
          minimumTime: 300,
          allowedCollisions: 2,
        );

        final json = criteria.toJson();

        expect(
          json.keys,
          containsAll([
            'stabilityThreshold',
            'minimumTime',
            'allowedCollisions',
          ]),
        );
        expect(json.keys.length, equals(3));
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through fromJson/toJson cycle', () {
        final originalCriteria = SuccessCriteria(
          stabilityThreshold: 0.123456789,
          minimumTime: 987654321,
          allowedCollisions: 42,
        );

        final json = originalCriteria.toJson();
        final reconstructedCriteria = SuccessCriteria.fromJson(json);

        expect(
          reconstructedCriteria.stabilityThreshold,
          equals(originalCriteria.stabilityThreshold),
        );
        expect(
          reconstructedCriteria.minimumTime,
          equals(originalCriteria.minimumTime),
        );
        expect(
          reconstructedCriteria.allowedCollisions,
          equals(originalCriteria.allowedCollisions),
        );
      });

      test('handles zero values in round-trip', () {
        final originalCriteria = SuccessCriteria(
          stabilityThreshold: 0.0,
          minimumTime: 0,
          allowedCollisions: 0,
        );

        final json = originalCriteria.toJson();
        final reconstructedCriteria = SuccessCriteria.fromJson(json);

        expect(reconstructedCriteria.stabilityThreshold, equals(0.0));
        expect(reconstructedCriteria.minimumTime, equals(0));
        expect(reconstructedCriteria.allowedCollisions, equals(0));
      });

      test('handles negative values in round-trip', () {
        final originalCriteria = SuccessCriteria(
          stabilityThreshold: -0.5,
          minimumTime: -100,
          allowedCollisions: -1,
        );

        final json = originalCriteria.toJson();
        final reconstructedCriteria = SuccessCriteria.fromJson(json);

        expect(reconstructedCriteria.stabilityThreshold, equals(-0.5));
        expect(reconstructedCriteria.minimumTime, equals(-100));
        expect(reconstructedCriteria.allowedCollisions, equals(-1));
      });

      test('handles extreme values in round-trip', () {
        final originalCriteria = SuccessCriteria(
          stabilityThreshold: 1e-20,
          minimumTime: 2147483647, // Max int32
          allowedCollisions: 0,
        );

        final json = originalCriteria.toJson();
        final reconstructedCriteria = SuccessCriteria.fromJson(json);

        expect(reconstructedCriteria.stabilityThreshold, equals(1e-20));
        expect(reconstructedCriteria.minimumTime, equals(2147483647));
        expect(reconstructedCriteria.allowedCollisions, equals(0));
      });
    });

    group('realistic scenario examples', () {
      test('easy scenario criteria', () {
        final easyCriteria = SuccessCriteria(
          stabilityThreshold: 0.9, // High stability required
          minimumTime: 300, // 5 minutes
          allowedCollisions: 0, // No collisions allowed
        );

        expect(easyCriteria.stabilityThreshold, equals(0.9));
        expect(easyCriteria.minimumTime, equals(300));
        expect(easyCriteria.allowedCollisions, equals(0));

        // Should serialize correctly
        final json = easyCriteria.toJson();
        final reconstructed = SuccessCriteria.fromJson(json);
        expect(
          reconstructed.stabilityThreshold,
          equals(easyCriteria.stabilityThreshold),
        );
      });

      test('medium scenario criteria', () {
        final mediumCriteria = SuccessCriteria(
          stabilityThreshold: 0.7, // Moderate stability
          minimumTime: 600, // 10 minutes
          allowedCollisions: 1, // One collision allowed
        );

        expect(mediumCriteria.stabilityThreshold, equals(0.7));
        expect(mediumCriteria.minimumTime, equals(600));
        expect(mediumCriteria.allowedCollisions, equals(1));
      });

      test('hard scenario criteria', () {
        final hardCriteria = SuccessCriteria(
          stabilityThreshold: 0.5, // Lower stability required
          minimumTime: 900, // 15 minutes
          allowedCollisions: 3, // Multiple collisions allowed
        );

        expect(hardCriteria.stabilityThreshold, equals(0.5));
        expect(hardCriteria.minimumTime, equals(900));
        expect(hardCriteria.allowedCollisions, equals(3));
      });

      test('sandbox scenario criteria', () {
        final sandboxCriteria = SuccessCriteria(
          stabilityThreshold: 0.0, // No stability requirement
          minimumTime: 0, // No minimum time
          allowedCollisions: 999999, // Unlimited collisions
        );

        expect(sandboxCriteria.stabilityThreshold, equals(0.0));
        expect(sandboxCriteria.minimumTime, equals(0));
        expect(sandboxCriteria.allowedCollisions, equals(999999));
      });

      test('precision simulation criteria', () {
        final precisionCriteria = SuccessCriteria(
          stabilityThreshold: 0.99999, // Very high precision
          minimumTime: 3600, // 1 hour
          allowedCollisions: 0, // Perfect precision
        );

        expect(precisionCriteria.stabilityThreshold, equals(0.99999));
        expect(precisionCriteria.minimumTime, equals(3600));
        expect(precisionCriteria.allowedCollisions, equals(0));

        // Should maintain precision in serialization
        final json = precisionCriteria.toJson();
        final reconstructed = SuccessCriteria.fromJson(json);
        expect(reconstructed.stabilityThreshold, closeTo(0.99999, 1e-10));
      });
    });

    group('edge cases and validation', () {
      test('handles maximum double values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: double.maxFinite,
          minimumTime: 1000,
          allowedCollisions: 1,
        );

        expect(criteria.stabilityThreshold, equals(double.maxFinite));
        expect(criteria.stabilityThreshold.isFinite, isTrue);

        final json = criteria.toJson();
        final reconstructed = SuccessCriteria.fromJson(json);
        expect(reconstructed.stabilityThreshold, equals(double.maxFinite));
      });

      test('handles minimum positive double values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: double.minPositive,
          minimumTime: 1,
          allowedCollisions: 0,
        );

        expect(criteria.stabilityThreshold, equals(double.minPositive));
        expect(criteria.stabilityThreshold > 0, isTrue);

        final json = criteria.toJson();
        final reconstructed = SuccessCriteria.fromJson(json);
        expect(reconstructed.stabilityThreshold, equals(double.minPositive));
      });

      test('validates all numeric types are finite', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.5,
          minimumTime: 300,
          allowedCollisions: 2,
        );

        expect(criteria.stabilityThreshold.isFinite, isTrue);
        expect(criteria.minimumTime.isFinite, isTrue);
        expect(criteria.allowedCollisions.isFinite, isTrue);
      });

      test('handles precision around 1.0', () {
        final values = [0.9999999, 1.0, 1.0000001];

        for (final value in values) {
          final criteria = SuccessCriteria(
            stabilityThreshold: value,
            minimumTime: 100,
            allowedCollisions: 0,
          );

          final json = criteria.toJson();
          final reconstructed = SuccessCriteria.fromJson(json);
          expect(reconstructed.stabilityThreshold, closeTo(value, 1e-15));
        }
      });

      test('handles boundary integer values', () {
        final criteria = SuccessCriteria(
          stabilityThreshold: 0.5,
          minimumTime: 2147483647, // Max 32-bit signed integer
          allowedCollisions: 0,
        );

        expect(criteria.minimumTime, equals(2147483647));

        final json = criteria.toJson();
        final reconstructed = SuccessCriteria.fromJson(json);
        expect(reconstructed.minimumTime, equals(2147483647));
      });
    });
  });
}
