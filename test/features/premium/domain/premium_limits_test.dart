import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/premium_limits.dart';

void main() {
  group('PremiumLimits', () {
    group('constructor', () {
      test('creates instance with all required fields', () {
        const limits = PremiumLimits(
          freeSessionDurationMinutes: 15,
          freeMaxViewers: 3,
          freeSessionsPerDay: 2,
          premiumMaxViewers: 25,
          cameraSyncRequiresPremium: true,
          passwordRequiresPremium: true,
        );

        expect(limits.freeSessionDurationMinutes, equals(15));
        expect(limits.freeMaxViewers, equals(3));
        expect(limits.freeSessionsPerDay, equals(2));
        expect(limits.premiumMaxViewers, equals(25));
        expect(limits.cameraSyncRequiresPremium, isTrue);
        expect(limits.passwordRequiresPremium, isTrue);
      });
    });

    group('defaults', () {
      test('has expected default values', () {
        const defaults = PremiumLimits.defaults;

        expect(defaults.freeSessionDurationMinutes, equals(15));
        expect(defaults.freeMaxViewers, equals(3));
        expect(defaults.freeSessionsPerDay, equals(2));
        expect(defaults.premiumMaxViewers, equals(25));
        expect(defaults.cameraSyncRequiresPremium, isTrue);
        expect(defaults.passwordRequiresPremium, isTrue);
      });

      test('defaults is a const value', () {
        const defaults1 = PremiumLimits.defaults;
        const defaults2 = PremiumLimits.defaults;

        expect(identical(defaults1, defaults2), isTrue);
      });
    });

    group('copyWith', () {
      test('copies all fields when no arguments provided', () {
        const original = PremiumLimits(
          freeSessionDurationMinutes: 20,
          freeMaxViewers: 5,
          freeSessionsPerDay: 3,
          premiumMaxViewers: 50,
          cameraSyncRequiresPremium: false,
          passwordRequiresPremium: false,
        );
        final copy = original.copyWith();

        expect(
          copy.freeSessionDurationMinutes,
          equals(original.freeSessionDurationMinutes),
        );
        expect(copy.freeMaxViewers, equals(original.freeMaxViewers));
        expect(copy.freeSessionsPerDay, equals(original.freeSessionsPerDay));
        expect(copy.premiumMaxViewers, equals(original.premiumMaxViewers));
        expect(
          copy.cameraSyncRequiresPremium,
          equals(original.cameraSyncRequiresPremium),
        );
        expect(
          copy.passwordRequiresPremium,
          equals(original.passwordRequiresPremium),
        );
      });

      test('updates freeSessionDurationMinutes', () {
        const original = PremiumLimits.defaults;
        final updated = original.copyWith(freeSessionDurationMinutes: 30);

        expect(updated.freeSessionDurationMinutes, equals(30));
        expect(updated.freeMaxViewers, equals(original.freeMaxViewers));
      });

      test('updates freeMaxViewers', () {
        const original = PremiumLimits.defaults;
        final updated = original.copyWith(freeMaxViewers: 10);

        expect(updated.freeMaxViewers, equals(10));
      });

      test('updates freeSessionsPerDay', () {
        const original = PremiumLimits.defaults;
        final updated = original.copyWith(freeSessionsPerDay: 5);

        expect(updated.freeSessionsPerDay, equals(5));
      });

      test('updates premiumMaxViewers', () {
        const original = PremiumLimits.defaults;
        final updated = original.copyWith(premiumMaxViewers: 100);

        expect(updated.premiumMaxViewers, equals(100));
      });

      test('updates cameraSyncRequiresPremium', () {
        const original = PremiumLimits.defaults;
        final updated = original.copyWith(cameraSyncRequiresPremium: false);

        expect(updated.cameraSyncRequiresPremium, isFalse);
      });

      test('updates passwordRequiresPremium', () {
        const original = PremiumLimits.defaults;
        final updated = original.copyWith(passwordRequiresPremium: false);

        expect(updated.passwordRequiresPremium, isFalse);
      });

      test('updates multiple fields at once', () {
        const original = PremiumLimits.defaults;
        final updated = original.copyWith(
          freeSessionDurationMinutes: 30,
          freeMaxViewers: 10,
          premiumMaxViewers: 100,
        );

        expect(updated.freeSessionDurationMinutes, equals(30));
        expect(updated.freeMaxViewers, equals(10));
        expect(updated.premiumMaxViewers, equals(100));
        expect(updated.freeSessionsPerDay, equals(original.freeSessionsPerDay));
      });
    });

    group('equality', () {
      test('equal instances have same hashCode', () {
        const a = PremiumLimits(
          freeSessionDurationMinutes: 15,
          freeMaxViewers: 3,
          freeSessionsPerDay: 2,
          premiumMaxViewers: 25,
          cameraSyncRequiresPremium: true,
          passwordRequiresPremium: true,
        );
        const b = PremiumLimits(
          freeSessionDurationMinutes: 15,
          freeMaxViewers: 3,
          freeSessionsPerDay: 2,
          premiumMaxViewers: 25,
          cameraSyncRequiresPremium: true,
          passwordRequiresPremium: true,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different instances are not equal', () {
        const a = PremiumLimits.defaults;
        final b = PremiumLimits.defaults.copyWith(freeMaxViewers: 10);

        expect(a, isNot(equals(b)));
      });

      test('identical instance equals itself', () {
        const limits = PremiumLimits.defaults;
        expect(limits == limits, isTrue);
      });

      test('defaults equals equivalent constructed instance', () {
        const defaults = PremiumLimits.defaults;
        const constructed = PremiumLimits(
          freeSessionDurationMinutes: 15,
          freeMaxViewers: 3,
          freeSessionsPerDay: 2,
          premiumMaxViewers: 25,
          cameraSyncRequiresPremium: true,
          passwordRequiresPremium: true,
        );

        expect(defaults, equals(constructed));
      });
    });

    group('toString', () {
      test('returns readable string', () {
        const limits = PremiumLimits.defaults;
        final str = limits.toString();

        expect(str, contains('PremiumLimits'));
        expect(str, contains('freeSessionDurationMinutes: 15'));
        expect(str, contains('freeMaxViewers: 3'));
        expect(str, contains('freeSessionsPerDay: 2'));
        expect(str, contains('premiumMaxViewers: 25'));
        expect(str, contains('cameraSyncRequiresPremium: true'));
        expect(str, contains('passwordRequiresPremium: true'));
      });
    });
  });
}
