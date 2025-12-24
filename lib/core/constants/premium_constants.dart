/// Constants for premium features and subscription management
///
/// Contains product identifiers, default limits, and configuration
/// values for the premium subscription system.
///
/// Note: RevenueCat and Stripe API keys are configured in config/*.json files
/// and accessed via AppConfig. See config/README.md for details.
class PremiumConstants {
  PremiumConstants._();

  // =============================================================================
  // REVENUECAT ENTITLEMENTS
  // =============================================================================

  /// RevenueCat entitlement identifier for premium access
  static const String premiumEntitlementId = 'premium';

  /// RevenueCat entitlement identifier for lifetime access
  static const String lifetimeEntitlementId = 'lifetime';

  // =============================================================================
  // PRODUCT IDENTIFIERS
  // =============================================================================

  /// Product ID for monthly subscription
  static const String monthlyProductId = 'graviton_premium_monthly';

  /// Product ID for yearly subscription
  static const String yearlyProductId = 'graviton_premium_yearly';

  /// Product ID for lifetime purchase
  static const String lifetimeProductId = 'graviton_premium_lifetime';

  // =============================================================================
  // DEFAULT LIMITS (Overridden by Remote Config)
  // =============================================================================

  /// Default free tier session duration limit in minutes
  static const int defaultFreeSessionDurationMinutes = 15;

  /// Default free tier maximum viewers per session
  static const int defaultFreeMaxViewers = 3;

  /// Default free tier sessions per day
  static const int defaultFreeSessionsPerDay = 2;

  /// Premium tier maximum viewers per session
  static const int premiumMaxViewers = 25;

  /// Warning threshold before session expires (in seconds)
  static const int sessionExpiryWarningSeconds = 60;

  // =============================================================================
  // FREE TRIAL
  // =============================================================================

  /// Free trial duration in days
  static const int freeTrialDays = 7;

  // =============================================================================
  // DEFAULT PRICING (Overridden by Remote Config)
  // =============================================================================

  /// Default monthly price in USD
  static const double defaultMonthlyPriceUsd = 2.99;

  /// Default yearly price in USD
  static const double defaultYearlyPriceUsd = 19.99;

  /// Default lifetime price in USD
  static const double defaultLifetimePriceUsd = 39.99;

  // =============================================================================
  // USAGE TRACKING
  // =============================================================================

  /// SharedPreferences key for daily session count
  static const String dailySessionCountKey = 'premium_daily_session_count';

  /// SharedPreferences key for last session date
  static const String lastSessionDateKey = 'premium_last_session_date';

  /// SharedPreferences key for current session start time
  static const String sessionStartTimeKey = 'premium_session_start_time';

  /// SharedPreferences key for total session time today (in seconds)
  static const String dailySessionTimeKey = 'premium_daily_session_time';

  // =============================================================================
  // REMOTE CONFIG KEYS
  // =============================================================================

  /// Remote config key for free session duration
  static const String rcFreeSessionDuration = 'premium_free_session_duration';

  /// Remote config key for free max viewers
  static const String rcFreeMaxViewers = 'premium_free_max_viewers';

  /// Remote config key for free sessions per day
  static const String rcFreeSessionsPerDay = 'premium_free_sessions_per_day';

  /// Remote config key for monthly price
  static const String rcMonthlyPrice = 'premium_monthly_price';

  /// Remote config key for yearly price
  static const String rcYearlyPrice = 'premium_yearly_price';

  /// Remote config key for lifetime price
  static const String rcLifetimePrice = 'premium_lifetime_price';

  /// Remote config key for premium enabled flag
  static const String rcPremiumEnabled = 'premium_enabled';

  /// Remote config key for show paywall on session limit
  static const String rcShowPaywallOnLimit = 'premium_show_paywall_on_limit';

  /// Remote config key for targeted user discounts (JSON)
  static const String rcTargetedDiscounts = 'premium_targeted_discounts';

  /// Remote config key for camera sync requires premium
  static const String rcCameraSyncRequiresPremium =
      'premium_camera_sync_requires_premium';

  /// Remote config key for password protection requires premium
  static const String rcPasswordRequiresPremium =
      'premium_password_requires_premium';
}
