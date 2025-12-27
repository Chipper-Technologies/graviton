import 'package:flutter/widgets.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Premium subscription tiers for the application
///
/// Defines the available subscription levels and their associated
/// identifiers for RevenueCat/Stripe integration.
enum PremiumTier {
  /// Free tier with usage limits
  free,

  /// Premium tier with unlimited access
  premium,

  /// Lifetime purchase (one-time)
  lifetime,
}

/// Extension methods for [PremiumTier]
extension PremiumTierExtension on PremiumTier {
  /// Returns the localized display name for the tier
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PremiumTier.free:
        return l10n.premiumTierFree;
      case PremiumTier.premium:
        return l10n.premiumTierPremium;
      case PremiumTier.lifetime:
        return l10n.premiumTierLifetime;
    }
  }

  /// Returns the RevenueCat entitlement identifier
  String get entitlementId {
    switch (this) {
      case PremiumTier.free:
        return '';
      case PremiumTier.premium:
        return 'premium';
      case PremiumTier.lifetime:
        return 'lifetime';
    }
  }

  /// Whether this tier has premium access
  bool get hasPremiumAccess {
    switch (this) {
      case PremiumTier.free:
        return false;
      case PremiumTier.premium:
      case PremiumTier.lifetime:
        return true;
    }
  }

  /// Create from string value
  static PremiumTier fromString(String value) {
    switch (value.toLowerCase()) {
      case 'premium':
        return PremiumTier.premium;
      case 'lifetime':
        return PremiumTier.lifetime;
      default:
        return PremiumTier.free;
    }
  }
}
