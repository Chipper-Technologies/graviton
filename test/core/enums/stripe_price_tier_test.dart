import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/stripe_price_tier.dart';

void main() {
  group('StripePriceTier Enum', () {
    test('should have all expected tiers', () {
      expect(StripePriceTier.values.length, equals(3));
      expect(StripePriceTier.values, contains(StripePriceTier.monthly));
      expect(StripePriceTier.values, contains(StripePriceTier.yearly));
      expect(StripePriceTier.values, contains(StripePriceTier.lifetime));
    });

    test('should have correct enum names', () {
      expect(StripePriceTier.monthly.name, equals('monthly'));
      expect(StripePriceTier.yearly.name, equals('yearly'));
      expect(StripePriceTier.lifetime.name, equals('lifetime'));
    });

    test('should maintain correct order', () {
      final values = StripePriceTier.values;
      expect(values[0], equals(StripePriceTier.monthly));
      expect(values[1], equals(StripePriceTier.yearly));
      expect(values[2], equals(StripePriceTier.lifetime));
    });

    test('should be usable in switch statements', () {
      String getTierDescription(StripePriceTier tier) {
        switch (tier) {
          case StripePriceTier.monthly:
            return 'Monthly subscription';
          case StripePriceTier.yearly:
            return 'Yearly subscription';
          case StripePriceTier.lifetime:
            return 'Lifetime access';
        }
      }

      expect(
        getTierDescription(StripePriceTier.monthly),
        equals('Monthly subscription'),
      );
      expect(
        getTierDescription(StripePriceTier.yearly),
        equals('Yearly subscription'),
      );
      expect(
        getTierDescription(StripePriceTier.lifetime),
        equals('Lifetime access'),
      );
    });

    test('should be comparable by index', () {
      expect(
        StripePriceTier.monthly.index,
        lessThan(StripePriceTier.yearly.index),
      );
      expect(
        StripePriceTier.yearly.index,
        lessThan(StripePriceTier.lifetime.index),
      );
    });

    test('should convert to/from string via name', () {
      for (final tier in StripePriceTier.values) {
        final name = tier.name;
        final fromName = StripePriceTier.values.firstWhere(
          (t) => t.name == name,
        );
        expect(fromName, equals(tier));
      }
    });
  });
}
