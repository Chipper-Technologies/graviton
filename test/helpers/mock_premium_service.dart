import 'package:graviton/core/enums/premium_tier.dart';
import 'package:graviton/features/premium/data/premium_service.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';

/// Mock implementation of [PremiumService] for testing.
///
/// Allows tests to control premium access state without requiring
/// RevenueCat or Stripe integration.
///
/// ## Usage
/// ```dart
/// setUp(() {
///   PremiumService.setInstance(MockPremiumService(hasPremium: true));
/// });
///
/// tearDown(() {
///   PremiumService.resetInstance();
/// });
/// ```
class MockPremiumService extends PremiumService {
  /// Creates a mock premium service.
  ///
  /// [hasPremium] controls whether the user has premium access.
  /// [tier] specifies the premium tier (defaults to [PremiumTier.premium]
  /// if [hasPremium] is true, otherwise [PremiumTier.free]).
  MockPremiumService({this.hasPremium = false, PremiumTier? tier})
    : _tier = tier ?? (hasPremium ? PremiumTier.premium : PremiumTier.free),
      super.internal();

  /// Whether the mock user has premium access
  final bool hasPremium;

  /// The premium tier for this mock
  final PremiumTier _tier;

  @override
  bool get isInitialized => true;

  @override
  PremiumTier get currentTier => _tier;

  @override
  bool get hasPremiumAccess => hasPremium;

  @override
  bool canUseFeature(PremiumFeature feature) {
    if (hasPremium) return true;
    // When not premium, check if feature requires premium
    return !doesFeatureRequirePremium(feature);
  }

  @override
  bool doesFeatureRequirePremium(PremiumFeature feature) {
    // All premium features require premium in tests by default
    switch (feature) {
      case PremiumFeature.cameraSync:
      case PremiumFeature.passwordProtection:
      case PremiumFeature.unlimitedSessionDuration:
      case PremiumFeature.unlimitedViewers:
      case PremiumFeature.unlimitedSessionsPerDay:
        return true;
    }
  }
}
