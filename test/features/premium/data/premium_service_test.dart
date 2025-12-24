import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/constants/premium_constants.dart';
import 'package:graviton/core/enums/premium_tier.dart';
import 'package:graviton/features/premium/data/premium_service.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/domain/premium_limits.dart';
import 'package:graviton/features/premium/domain/premium_pricing.dart';

void main() {
  group('PremiumService', () {
    late PremiumService service;

    setUp(() {
      service = PremiumService.instance;
    });

    test('initial tier is free', () {
      expect(service.currentTier, equals(PremiumTier.free));
    });

    test('free tier does not have premium access', () {
      expect(service.hasPremiumAccess, isFalse);
    });

    test('limits returns valid PremiumLimits', () {
      final limits = service.limits;
      expect(limits, isA<PremiumLimits>());
      expect(limits.freeSessionsPerDay, greaterThan(0));
      expect(limits.freeSessionDurationMinutes, greaterThan(0));
      expect(limits.freeMaxViewers, greaterThan(0));
      expect(limits.premiumMaxViewers, greaterThan(limits.freeMaxViewers));
    });

    test('pricing returns valid PremiumPricing', () {
      final pricing = service.pricing;
      expect(pricing, isA<PremiumPricing>());
      expect(pricing.monthlyPriceUsd, greaterThan(0));
      expect(pricing.yearlyPriceUsd, greaterThan(0));
      expect(pricing.lifetimePriceUsd, greaterThan(0));
    });

    group('PremiumFeature access', () {
      test('free tier cannot use camera sync', () {
        expect(service.canUseFeature(PremiumFeature.cameraSync), isFalse);
      });

      test('free tier cannot use password protection', () {
        expect(
          service.canUseFeature(PremiumFeature.passwordProtection),
          isFalse,
        );
      });

      test('free tier cannot use unlimited viewers', () {
        expect(service.canUseFeature(PremiumFeature.unlimitedViewers), isFalse);
      });

      test('camera sync requires premium', () {
        expect(
          service.doesFeatureRequirePremium(PremiumFeature.cameraSync),
          isTrue,
        );
      });
    });

    group('RevenueCat Configuration', () {
      test('AppConfig.revenueCatApiKey is accessible', () {
        // Verify the config getter exists and returns a string
        expect(AppConfig.revenueCatApiKey, isA<String>());
      });

      test('revenueCatApiKey defaults to empty when not configured', () {
        // In test environment, config key is empty (no dart-define)
        expect(AppConfig.revenueCatApiKey, equals(''));
      });

      test('PremiumConstants has entitlement IDs', () {
        // Verify entitlement constants exist
        expect(PremiumConstants.premiumEntitlementId, equals('premium'));
        expect(PremiumConstants.lifetimeEntitlementId, equals('lifetime'));
      });
    });

    group('Stripe Configuration', () {
      test('AppConfig.stripeMonthlyPaymentLink is accessible', () {
        expect(AppConfig.stripeMonthlyPaymentLink, isA<String>());
      });

      test('AppConfig.stripeYearlyPaymentLink is accessible', () {
        expect(AppConfig.stripeYearlyPaymentLink, isA<String>());
      });

      test('AppConfig.stripeLifetimePaymentLink is accessible', () {
        expect(AppConfig.stripeLifetimePaymentLink, isA<String>());
      });

      test('Stripe Payment Links default to empty when not configured', () {
        // In test environment, config keys are empty (no dart-define)
        expect(AppConfig.stripeMonthlyPaymentLink, equals(''));
        expect(AppConfig.stripeYearlyPaymentLink, equals(''));
        expect(AppConfig.stripeLifetimePaymentLink, equals(''));
      });
    });
  });
}
