import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/targeted_discount.dart';

void main() {
  group('TargetedDiscount', () {
    group('constructor', () {
      test('creates instance with required fields', () {
        const discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Early adopter',
        );

        expect(discount.userId, equals('user123'));
        expect(discount.discountPercentage, equals(20));
        expect(discount.reason, equals('Early adopter'));
        expect(discount.expiresAt, isNull);
        expect(discount.appliesToMonthly, isTrue);
        expect(discount.appliesToYearly, isTrue);
        expect(discount.appliesToLifetime, isTrue);
      });

      test('creates instance with all optional fields', () {
        final expiry = DateTime(2025, 12, 31);
        final discount = TargetedDiscount(
          userId: 'user456',
          discountPercentage: 50,
          reason: 'VIP customer',
          expiresAt: expiry,
          appliesToMonthly: false,
          appliesToYearly: true,
          appliesToLifetime: false,
        );

        expect(discount.expiresAt, equals(expiry));
        expect(discount.appliesToMonthly, isFalse);
        expect(discount.appliesToYearly, isTrue);
        expect(discount.appliesToLifetime, isFalse);
      });
    });

    group('isValid', () {
      test('returns true when expiresAt is null', () {
        const discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'No expiry',
        );

        expect(discount.isValid, isTrue);
      });

      test('returns true when expiry is in the future', () {
        final discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Future expiry',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        );

        expect(discount.isValid, isTrue);
      });

      test('returns false when expiry is in the past', () {
        final discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Expired',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        );

        expect(discount.isValid, isFalse);
      });
    });

    group('JSON serialization', () {
      test('fromJson creates valid instance', () {
        final json = {
          'user_id': 'user123',
          'discount_percentage': 25,
          'reason': 'Promo code',
        };

        final discount = TargetedDiscount.fromJson(json);

        expect(discount.userId, equals('user123'));
        expect(discount.discountPercentage, equals(25));
        expect(discount.reason, equals('Promo code'));
      });

      test('fromJson handles missing optional fields with defaults', () {
        final json = {'user_id': 'user123'};

        final discount = TargetedDiscount.fromJson(json);

        expect(discount.discountPercentage, equals(0));
        expect(discount.reason, equals(''));
        expect(discount.appliesToMonthly, isTrue);
        expect(discount.appliesToYearly, isTrue);
        expect(discount.appliesToLifetime, isTrue);
      });

      test('fromJson parses expiry date', () {
        final json = {
          'user_id': 'user123',
          'discount_percentage': 20,
          'reason': 'Test',
          'expires_at': '2025-12-31T23:59:59.000',
        };

        final discount = TargetedDiscount.fromJson(json);

        expect(discount.expiresAt, isNotNull);
        expect(discount.expiresAt!.year, equals(2025));
        expect(discount.expiresAt!.month, equals(12));
        expect(discount.expiresAt!.day, equals(31));
      });

      test('fromJson parses subscription type flags', () {
        final json = {
          'user_id': 'user123',
          'discount_percentage': 20,
          'reason': 'Test',
          'applies_to_monthly': false,
          'applies_to_yearly': true,
          'applies_to_lifetime': false,
        };

        final discount = TargetedDiscount.fromJson(json);

        expect(discount.appliesToMonthly, isFalse);
        expect(discount.appliesToYearly, isTrue);
        expect(discount.appliesToLifetime, isFalse);
      });

      test('toJson creates valid map', () {
        const discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 30,
          reason: 'Special offer',
        );

        final json = discount.toJson();

        expect(json['user_id'], equals('user123'));
        expect(json['discount_percentage'], equals(30));
        expect(json['reason'], equals('Special offer'));
        expect(json['applies_to_monthly'], isTrue);
        expect(json['applies_to_yearly'], isTrue);
        expect(json['applies_to_lifetime'], isTrue);
      });

      test('toJson includes expiry when present', () {
        final discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Test',
          expiresAt: DateTime(2025, 12, 31),
        );

        final json = discount.toJson();

        expect(json['expires_at'], contains('2025-12-31'));
      });

      test('toJson excludes expiry when null', () {
        const discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Test',
        );

        final json = discount.toJson();

        expect(json.containsKey('expires_at'), isFalse);
      });

      test('round-trip serialization preserves data', () {
        final original = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 35,
          reason: 'Beta tester',
          expiresAt: DateTime(2025, 6, 15),
          appliesToMonthly: true,
          appliesToYearly: false,
          appliesToLifetime: true,
        );

        final json = original.toJson();
        final restored = TargetedDiscount.fromJson(json);

        expect(restored.userId, equals(original.userId));
        expect(
          restored.discountPercentage,
          equals(original.discountPercentage),
        );
        expect(restored.reason, equals(original.reason));
        expect(restored.appliesToMonthly, equals(original.appliesToMonthly));
        expect(restored.appliesToYearly, equals(original.appliesToYearly));
        expect(restored.appliesToLifetime, equals(original.appliesToLifetime));
      });
    });

    group('parseList', () {
      test('parses list of valid discounts', () {
        final jsonList = [
          {
            'user_id': 'user1',
            'discount_percentage': 10,
            'reason': 'Discount 1',
            'expires_at': DateTime.now()
                .add(const Duration(days: 30))
                .toIso8601String(),
          },
          {
            'user_id': 'user2',
            'discount_percentage': 20,
            'reason': 'Discount 2',
          },
        ];

        final discounts = TargetedDiscount.parseList(jsonList);

        expect(discounts.length, equals(2));
        expect(discounts[0].userId, equals('user1'));
        expect(discounts[1].userId, equals('user2'));
      });

      test('filters out expired discounts', () {
        final jsonList = [
          {'user_id': 'valid', 'discount_percentage': 10, 'reason': 'Valid'},
          {
            'user_id': 'expired',
            'discount_percentage': 50,
            'reason': 'Expired',
            'expires_at': DateTime.now()
                .subtract(const Duration(days: 1))
                .toIso8601String(),
          },
        ];

        final discounts = TargetedDiscount.parseList(jsonList);

        expect(discounts.length, equals(1));
        expect(discounts[0].userId, equals('valid'));
      });

      test('returns empty list for empty input', () {
        final discounts = TargetedDiscount.parseList([]);

        expect(discounts, isEmpty);
      });
    });

    group('equality', () {
      test('equal instances have same hashCode', () {
        const a = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Test',
        );
        const b = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Test',
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different instances are not equal', () {
        const a = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Test',
        );
        const b = TargetedDiscount(
          userId: 'user456',
          discountPercentage: 20,
          reason: 'Test',
        );

        expect(a, isNot(equals(b)));
      });

      test('identical instance equals itself', () {
        const discount = TargetedDiscount(
          userId: 'user123',
          discountPercentage: 20,
          reason: 'Test',
        );
        expect(discount == discount, isTrue);
      });
    });
  });
}
