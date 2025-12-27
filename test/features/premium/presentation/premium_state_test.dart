import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/premium_tier.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';

void main() {
  group('PremiumState', () {
    late PremiumState state;

    setUp(() {
      state = PremiumState();
    });

    tearDown(() {
      try {
        state.dispose();
      } catch (_) {
        // Already disposed, this is expected for dispose tests
      }
    });

    group('Initial state', () {
      test('isLoading is false initially', () {
        expect(state.isLoading, isFalse);
      });

      test('error is null initially', () {
        expect(state.error, isNull);
      });

      test('tier is free initially', () {
        expect(state.tier, equals(PremiumTier.free));
      });

      test('isFreeTier is true initially', () {
        expect(state.isFreeTier, isTrue);
      });

      test('hasPremiumAccess is false initially', () {
        expect(state.hasPremiumAccess, isFalse);
      });
    });

    group('Limits', () {
      test('limits are available', () {
        expect(state.limits, isNotNull);
        expect(state.limits.freeSessionsPerDay, greaterThan(0));
        expect(state.limits.freeSessionDurationMinutes, greaterThan(0));
      });

      test('maxViewers returns free tier value when not premium', () {
        expect(state.maxViewers, equals(state.limits.freeMaxViewers));
      });
    });

    group('Pricing', () {
      test('pricing is available', () {
        expect(state.pricing, isNotNull);
        expect(state.pricing.monthlyPriceUsd, greaterThan(0));
        expect(state.pricing.yearlyPriceUsd, greaterThan(0));
        expect(state.pricing.lifetimePriceUsd, greaterThan(0));
      });
    });

    group('Session tracking', () {
      test('canStartSession is true when under daily limit', () {
        // Fresh state should allow starting session
        expect(state.canStartSession, isTrue);
      });

      test('sessionsRemainingToday returns correct count', () {
        final remaining = state.sessionsRemainingToday;
        expect(remaining, equals(state.limits.freeSessionsPerDay));
      });

      test('remainingSessionTime is zero initially', () {
        expect(state.remainingSessionTime, equals(Duration.zero));
      });

      test('formatRemainingTime returns formatted string', () {
        final formatted = state.formatRemainingTime();
        expect(formatted, matches(RegExp(r'^\d{2}:\d{2}$')));
      });

      test('shouldShowTimeWarning is false initially', () {
        expect(state.shouldShowTimeWarning, isFalse);
      });

      test('hasExceededDurationLimit is false initially', () {
        expect(state.hasExceededDurationLimit, isFalse);
      });
    });

    group('Feature access', () {
      test('doesFeatureRequirePremium returns true for premium features', () {
        expect(
          state.doesFeatureRequirePremium(PremiumFeature.cameraSync),
          isTrue,
        );
        expect(
          state.doesFeatureRequirePremium(PremiumFeature.passwordProtection),
          isTrue,
        );
      });

      test('canUseFeature returns false for premium features on free tier', () {
        expect(state.canUseFeature(PremiumFeature.cameraSync), isFalse);
        expect(state.canUseFeature(PremiumFeature.passwordProtection), isFalse);
      });
    });

    group('ChangeNotifier', () {
      test('notifies listeners on loading state change', () {
        var notified = false;
        state.addListener(() => notified = true);

        // Trigger a state change via startSessionTracking
        state.startSessionTracking();

        expect(notified, isTrue);
      });

      test('can safely dispose', () {
        expect(() => state.dispose(), returnsNormally);
      });
    });
  });
}
