import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/premium_tier.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/domain/premium_limits.dart';
import 'package:graviton/features/premium/domain/usage_data.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/features/premium/presentation/widgets/premium_gate.dart';
import 'package:graviton/features/premium/presentation/widgets/default_locked_indicator.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Creates a test wrapper widget with localization and provider support
Widget createTestableWidget({
  required Widget child,
  required PremiumState premiumState,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: ChangeNotifierProvider<PremiumState>.value(
      value: premiumState,
      child: Scaffold(body: child),
    ),
  );
}

/// Integration tests for the premium purchase flow
///
/// These tests verify the complete flow from free tier to premium,
/// including UI state changes, feature gating, and session limits.
void main() {
  group('Premium Purchase Flow Integration', () {
    late PremiumState premiumState;

    setUp(() {
      premiumState = PremiumState();
    });

    tearDown(() {
      try {
        premiumState.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    group('Free Tier Initial State', () {
      test('user starts on free tier', () {
        expect(premiumState.tier, equals(PremiumTier.free));
        expect(premiumState.isFreeTier, isTrue);
        expect(premiumState.hasPremiumAccess, isFalse);
      });

      test('free tier has correct limits', () {
        expect(premiumState.limits.freeSessionsPerDay, greaterThan(0));
        expect(premiumState.limits.freeSessionDurationMinutes, greaterThan(0));
        expect(premiumState.limits.freeMaxViewers, greaterThan(0));
      });

      test('premium features are locked on free tier', () {
        for (final feature in PremiumFeature.values) {
          if (premiumState.doesFeatureRequirePremium(feature)) {
            expect(premiumState.canUseFeature(feature), isFalse);
          }
        }
      });

      test('cameraSync requires premium', () {
        expect(
          premiumState.doesFeatureRequirePremium(PremiumFeature.cameraSync),
          isTrue,
        );
        expect(premiumState.canUseFeature(PremiumFeature.cameraSync), isFalse);
      });

      test('passwordProtection requires premium', () {
        expect(
          premiumState.doesFeatureRequirePremium(
            PremiumFeature.passwordProtection,
          ),
          isTrue,
        );
        expect(
          premiumState.canUseFeature(PremiumFeature.passwordProtection),
          isFalse,
        );
      });
    });

    group('Session Limits Enforcement', () {
      test('free user can start sessions within daily limit', () {
        expect(premiumState.canStartSession, isTrue);
        expect(
          premiumState.sessionsRemainingToday,
          equals(premiumState.limits.freeSessionsPerDay),
        );
      });

      test('session timer starts at zero initially', () {
        expect(premiumState.remainingSessionTime, equals(Duration.zero));
      });

      test('hasExceededDurationLimit is false initially', () {
        expect(premiumState.hasExceededDurationLimit, isFalse);
      });

      test('formatRemainingTime returns valid format', () {
        final formatted = premiumState.formatRemainingTime();
        expect(formatted, matches(RegExp(r'^\d{2}:\d{2}$')));
      });
    });

    group('Viewer Limits', () {
      test('free tier has viewer limit', () {
        expect(
          premiumState.maxViewers,
          equals(premiumState.limits.freeMaxViewers),
        );
      });

      test('free viewer limit is less than premium limit', () {
        expect(
          premiumState.limits.freeMaxViewers,
          lessThan(premiumState.limits.premiumMaxViewers),
        );
      });
    });

    group('Pricing Information', () {
      test('pricing is available', () {
        expect(premiumState.pricing, isNotNull);
      });

      test('monthly pricing is set', () {
        expect(premiumState.pricing.monthlyPriceUsd, greaterThan(0));
      });

      test('annual pricing is set', () {
        expect(premiumState.pricing.yearlyPriceUsd, greaterThan(0));
      });

      test('lifetime pricing is set', () {
        expect(premiumState.pricing.lifetimePriceUsd, greaterThan(0));
      });

      test('annual savings percentage is correct', () {
        final monthly = premiumState.pricing.monthlyPriceUsd;
        final yearly = premiumState.pricing.yearlyPriceUsd;
        final yearlyIfMonthly = monthly * 12;
        final savings = premiumState.pricing.yearlySavingsPercentage;

        final expectedSavings =
            ((yearlyIfMonthly - yearly) / yearlyIfMonthly * 100).round();
        expect(savings, equals(expectedSavings));
      });
    });
  });

  group('PremiumGate Widget Integration', () {
    late PremiumState premiumState;

    setUp(() {
      premiumState = PremiumState();
    });

    tearDown(() {
      try {
        premiumState.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    testWidgets(
      'PremiumGate shows locked indicator for premium features on free tier',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            premiumState: premiumState,
            child: PremiumGate(
              feature: PremiumFeature.cameraSync,
              child: const Text('Premium Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Free tier should show locked indicator, not premium content
        expect(find.text('Premium Content'), findsNothing);
        expect(find.byType(DefaultLockedIndicator), findsOneWidget);
      },
    );

    testWidgets('PremiumGate hides content when hideWhenLocked is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            hideWhenLocked: true,
            child: const Text('Premium Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Premium Content'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('PremiumGate shows custom locked child when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            lockedChild: const Text('Upgrade Required'),
            child: const Text('Premium Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Premium Content'), findsNothing);
      expect(find.text('Upgrade Required'), findsOneWidget);
    });

    testWidgets('PremiumGate onLockedTap callback is triggered', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            lockedChild: const Text('Upgrade Required'),
            onLockedTap: () {
              tapped = true;
            },
            child: const Text('Premium Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Upgrade Required'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('Session Tracking Flow', () {
    late PremiumState premiumState;

    setUp(() {
      premiumState = PremiumState();
    });

    tearDown(() {
      try {
        premiumState.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    test('can query session status without crashing', () {
      // These methods should be callable without initialization
      expect(() => premiumState.usageData, returnsNormally);
      expect(() => premiumState.canStartSession, returnsNormally);
      expect(() => premiumState.sessionsRemainingToday, returnsNormally);
    });

    test('startSessionTracking does not throw', () {
      // Should not throw even without full initialization
      expect(() => premiumState.startSessionTracking(), returnsNormally);
      premiumState.stopSessionTracking();
    });

    test('stopSessionTracking does not throw', () {
      // Should not throw even without starting a session
      expect(() => premiumState.stopSessionTracking(), returnsNormally);
    });

    test('session count is trackable', () {
      final initialCount = premiumState.usageData.sessionsHostedToday;

      // After tracking starts, count should be >= initial
      premiumState.startSessionTracking();
      expect(
        premiumState.usageData.sessionsHostedToday,
        greaterThanOrEqualTo(initialCount),
      );

      premiumState.stopSessionTracking();
    });
  });

  group('Premium Limits Model', () {
    test('default limits have reasonable values', () {
      const limits = PremiumLimits.defaults;

      // Free tier limits
      expect(limits.freeSessionsPerDay, greaterThan(0));
      expect(limits.freeSessionDurationMinutes, greaterThan(0));
      expect(limits.freeMaxViewers, greaterThan(0));

      // Premium tier limits
      expect(limits.premiumMaxViewers, greaterThan(limits.freeMaxViewers));
    });

    test('custom limits override defaults', () {
      const limits = PremiumLimits(
        freeSessionsPerDay: 10,
        freeSessionDurationMinutes: 60,
        freeMaxViewers: 20,
        premiumMaxViewers: 200,
        cameraSyncRequiresPremium: true,
        passwordRequiresPremium: true,
      );

      expect(limits.freeSessionsPerDay, equals(10));
      expect(limits.freeSessionDurationMinutes, equals(60));
      expect(limits.freeMaxViewers, equals(20));
      expect(limits.premiumMaxViewers, equals(200));
    });
  });

  group('Usage Data Model', () {
    test('empty usage data has correct defaults', () {
      final usageData = UsageData.empty;

      expect(usageData.sessionsHostedToday, equals(0));
      expect(usageData.isInSession, isFalse);
    });

    test('usage data copyWith works correctly', () {
      final usageData = UsageData.empty;
      final updated = usageData.copyWith(
        sessionsHostedToday: 5,
        currentSessionStart: DateTime.now(),
      );

      expect(updated.sessionsHostedToday, equals(5));
      expect(updated.isInSession, isTrue);
    });
  });

  group('Feature Gating Logic', () {
    late PremiumState premiumState;

    setUp(() {
      premiumState = PremiumState();
    });

    tearDown(() {
      try {
        premiumState.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    test('all premium features are gated on free tier', () {
      // These specific features should require premium
      final premiumOnlyFeatures = [
        PremiumFeature.cameraSync,
        PremiumFeature.passwordProtection,
        PremiumFeature.unlimitedSessionDuration,
        PremiumFeature.unlimitedViewers,
        PremiumFeature.unlimitedSessionsPerDay,
      ];

      for (final feature in premiumOnlyFeatures) {
        expect(
          premiumState.doesFeatureRequirePremium(feature),
          isTrue,
          reason: '${feature.name} should require premium',
        );
        expect(
          premiumState.canUseFeature(feature),
          isFalse,
          reason: '${feature.name} should be locked on free tier',
        );
      }
    });
  });

  group('State Change Notifications', () {
    late PremiumState premiumState;
    int notificationCount = 0;

    setUp(() {
      premiumState = PremiumState();
      notificationCount = 0;
      premiumState.addListener(() {
        notificationCount++;
      });
    });

    tearDown(() {
      try {
        premiumState.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    test('startSessionTracking notifies listeners', () {
      premiumState.startSessionTracking();
      expect(notificationCount, greaterThan(0));
      premiumState.stopSessionTracking();
    });

    test('stopSessionTracking notifies listeners', () {
      premiumState.startSessionTracking();
      final countAfterStart = notificationCount;

      premiumState.stopSessionTracking();
      expect(notificationCount, greaterThan(countAfterStart));
    });
  });

  group('Error Handling', () {
    late PremiumState premiumState;

    setUp(() {
      premiumState = PremiumState();
    });

    tearDown(() {
      try {
        premiumState.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    test('error is null by default', () {
      expect(premiumState.error, isNull);
    });

    test('isLoading is false by default', () {
      expect(premiumState.isLoading, isFalse);
    });
  });
}
