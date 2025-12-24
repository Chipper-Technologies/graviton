import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/premium_pricing.dart';

void main() {
  group('PremiumPricing', () {
    group('constructor', () {
      test('should create with required parameters', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing.monthlyPriceUsd, equals(2.99));
        expect(pricing.yearlyPriceUsd, equals(19.99));
        expect(pricing.lifetimePriceUsd, equals(39.99));
        expect(pricing.discountPercentage, isNull);
        expect(pricing.discountReason, isNull);
      });

      test('should create with optional discount parameters', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 20,
          discountReason: 'Holiday Sale',
        );

        expect(pricing.discountPercentage, equals(20));
        expect(pricing.discountReason, equals('Holiday Sale'));
      });
    });

    group('defaults', () {
      test('should have correct default monthly price', () {
        expect(PremiumPricing.defaults.monthlyPriceUsd, equals(2.99));
      });

      test('should have correct default yearly price', () {
        expect(PremiumPricing.defaults.yearlyPriceUsd, equals(19.99));
      });

      test('should have correct default lifetime price', () {
        expect(PremiumPricing.defaults.lifetimePriceUsd, equals(39.99));
      });

      test('should have no discount by default', () {
        expect(PremiumPricing.defaults.discountPercentage, isNull);
        expect(PremiumPricing.defaults.discountReason, isNull);
        expect(PremiumPricing.defaults.hasDiscount, isFalse);
      });
    });

    group('hasDiscount', () {
      test('should return false when discountPercentage is null', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing.hasDiscount, isFalse);
      });

      test('should return false when discountPercentage is 0', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 0,
        );

        expect(pricing.hasDiscount, isFalse);
      });

      test('should return true when discountPercentage is positive', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 10,
        );

        expect(pricing.hasDiscount, isTrue);
      });
    });

    group('discountedMonthlyPrice', () {
      test('should return original price when no discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing.discountedMonthlyPrice, equals(2.99));
      });

      test('should return discounted price when discount is active', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 100.0,
          lifetimePriceUsd: 200.0,
          discountPercentage: 20,
        );

        expect(pricing.discountedMonthlyPrice, equals(8.0));
      });

      test('should handle 50% discount correctly', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 100.0,
          lifetimePriceUsd: 200.0,
          discountPercentage: 50,
        );

        expect(pricing.discountedMonthlyPrice, equals(5.0));
      });
    });

    group('discountedYearlyPrice', () {
      test('should return original price when no discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing.discountedYearlyPrice, equals(19.99));
      });

      test('should return discounted price when discount is active', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 100.0,
          lifetimePriceUsd: 200.0,
          discountPercentage: 25,
        );

        expect(pricing.discountedYearlyPrice, equals(75.0));
      });
    });

    group('discountedLifetimePrice', () {
      test('should return original price when no discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing.discountedLifetimePrice, equals(39.99));
      });

      test('should return discounted price when discount is active', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 100.0,
          lifetimePriceUsd: 200.0,
          discountPercentage: 30,
        );

        expect(pricing.discountedLifetimePrice, equals(140.0));
      });
    });

    group('yearlySavings', () {
      test('should calculate savings without discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 100.0,
          lifetimePriceUsd: 200.0,
        );

        // 10 * 12 = 120, 120 - 100 = 20
        expect(pricing.yearlySavings, equals(20.0));
      });

      test('should calculate savings with discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 100.0,
          lifetimePriceUsd: 200.0,
          discountPercentage: 50,
        );

        // Discounted monthly: 5, 5 * 12 = 60
        // Discounted yearly: 50
        // Savings: 60 - 50 = 10
        expect(pricing.yearlySavings, equals(10.0));
      });
    });

    group('yearlySavingsPercentage', () {
      test('should calculate savings percentage without discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 60.0,
          lifetimePriceUsd: 200.0,
        );

        // 10 * 12 = 120, 120 - 60 = 60 savings
        // 60 / 120 = 0.5 = 50%
        expect(pricing.yearlySavingsPercentage, equals(50));
      });

      test('should return 0 when yearly equals monthly total', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 10.0,
          yearlyPriceUsd: 120.0,
          lifetimePriceUsd: 200.0,
        );

        expect(pricing.yearlySavingsPercentage, equals(0));
      });
    });

    group('fromJson', () {
      test('should parse complete JSON', () {
        final json = {
          'monthly_price': 3.99,
          'yearly_price': 29.99,
          'lifetime_price': 49.99,
          'discount_percentage': 15,
          'discount_reason': 'Black Friday',
        };

        final pricing = PremiumPricing.fromJson(json);

        expect(pricing.monthlyPriceUsd, equals(3.99));
        expect(pricing.yearlyPriceUsd, equals(29.99));
        expect(pricing.lifetimePriceUsd, equals(49.99));
        expect(pricing.discountPercentage, equals(15));
        expect(pricing.discountReason, equals('Black Friday'));
      });

      test('should use defaults for missing prices', () {
        final json = <String, dynamic>{};

        final pricing = PremiumPricing.fromJson(json);

        expect(pricing.monthlyPriceUsd, equals(2.99));
        expect(pricing.yearlyPriceUsd, equals(19.99));
        expect(pricing.lifetimePriceUsd, equals(39.99));
      });

      test('should handle integer prices from JSON', () {
        final json = {
          'monthly_price': 3,
          'yearly_price': 30,
          'lifetime_price': 50,
        };

        final pricing = PremiumPricing.fromJson(json);

        expect(pricing.monthlyPriceUsd, equals(3.0));
        expect(pricing.yearlyPriceUsd, equals(30.0));
        expect(pricing.lifetimePriceUsd, equals(50.0));
      });

      test('should handle null discount fields', () {
        final json = {
          'monthly_price': 2.99,
          'yearly_price': 19.99,
          'lifetime_price': 39.99,
          'discount_percentage': null,
          'discount_reason': null,
        };

        final pricing = PremiumPricing.fromJson(json);

        expect(pricing.discountPercentage, isNull);
        expect(pricing.discountReason, isNull);
      });
    });

    group('toJson', () {
      test('should convert to JSON without discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        final json = pricing.toJson();

        expect(json['monthly_price'], equals(2.99));
        expect(json['yearly_price'], equals(19.99));
        expect(json['lifetime_price'], equals(39.99));
        expect(json.containsKey('discount_percentage'), isFalse);
        expect(json.containsKey('discount_reason'), isFalse);
      });

      test('should convert to JSON with discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 20,
          discountReason: 'Special Offer',
        );

        final json = pricing.toJson();

        expect(json['discount_percentage'], equals(20));
        expect(json['discount_reason'], equals('Special Offer'));
      });

      test('should round-trip through JSON', () {
        const original = PremiumPricing(
          monthlyPriceUsd: 4.99,
          yearlyPriceUsd: 34.99,
          lifetimePriceUsd: 59.99,
          discountPercentage: 25,
          discountReason: 'Launch Special',
        );

        final json = original.toJson();
        final restored = PremiumPricing.fromJson(json);

        expect(restored, equals(original));
      });
    });

    group('copyWith', () {
      test('should copy with all values unchanged', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 10,
          discountReason: 'Test',
        );

        final copy = pricing.copyWith();

        expect(copy, equals(pricing));
      });

      test('should copy with changed monthly price', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        final copy = pricing.copyWith(monthlyPriceUsd: 3.99);

        expect(copy.monthlyPriceUsd, equals(3.99));
        expect(copy.yearlyPriceUsd, equals(19.99));
        expect(copy.lifetimePriceUsd, equals(39.99));
      });

      test('should copy with changed yearly price', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        final copy = pricing.copyWith(yearlyPriceUsd: 24.99);

        expect(copy.yearlyPriceUsd, equals(24.99));
      });

      test('should copy with changed lifetime price', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        final copy = pricing.copyWith(lifetimePriceUsd: 49.99);

        expect(copy.lifetimePriceUsd, equals(49.99));
      });

      test('should copy with added discount', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        final copy = pricing.copyWith(
          discountPercentage: 30,
          discountReason: 'New Year Sale',
        );

        expect(copy.discountPercentage, equals(30));
        expect(copy.discountReason, equals('New Year Sale'));
        expect(copy.hasDiscount, isTrue);
      });
    });

    group('equality', () {
      test('identical instances should be equal', () {
        const pricing1 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );
        const pricing2 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing1, equals(pricing2));
        expect(pricing1 == pricing2, isTrue);
      });

      test('different prices should not be equal', () {
        const pricing1 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );
        const pricing2 = PremiumPricing(
          monthlyPriceUsd: 3.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing1, isNot(equals(pricing2)));
      });

      test('same values with different discounts should not be equal', () {
        const pricing1 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 10,
        );
        const pricing2 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 20,
        );

        expect(pricing1, isNot(equals(pricing2)));
      });
    });

    group('hashCode', () {
      test('equal instances should have same hashCode', () {
        const pricing1 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );
        const pricing2 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );

        expect(pricing1.hashCode, equals(pricing2.hashCode));
      });

      test('different instances should likely have different hashCode', () {
        const pricing1 = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
        );
        const pricing2 = PremiumPricing(
          monthlyPriceUsd: 9.99,
          yearlyPriceUsd: 79.99,
          lifetimePriceUsd: 149.99,
        );

        expect(pricing1.hashCode, isNot(equals(pricing2.hashCode)));
      });
    });

    group('toString', () {
      test('should include all fields', () {
        const pricing = PremiumPricing(
          monthlyPriceUsd: 2.99,
          yearlyPriceUsd: 19.99,
          lifetimePriceUsd: 39.99,
          discountPercentage: 10,
          discountReason: 'Sale',
        );

        final str = pricing.toString();

        expect(str, contains('PremiumPricing'));
        expect(str, contains('monthlyPriceUsd: 2.99'));
        expect(str, contains('yearlyPriceUsd: 19.99'));
        expect(str, contains('lifetimePriceUsd: 39.99'));
        expect(str, contains('discountPercentage: 10'));
        expect(str, contains('discountReason: Sale'));
      });
    });
  });
}
