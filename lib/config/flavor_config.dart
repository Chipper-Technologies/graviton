import 'package:graviton/core/constants/app_constants.dart';
import 'package:graviton/core/enums/app_flavor.dart';

/// Configuration service for managing app flavors
class FlavorConfig {
  static FlavorConfig? _instance;
  static FlavorConfig get instance => _instance ??= FlavorConfig._();

  FlavorConfig._();

  AppFlavor _flavor = AppFlavor.prod; // Default to prod
  String _appName = 'Graviton';

  AppFlavor get flavor => _flavor;
  String get appName => _appName;
  bool get isDevelopment => _flavor.isDevelopment;
  bool get isProduction => _flavor.isProduction;

  /// Initialize the flavor configuration
  void initialize({required AppFlavor flavor, String? appName}) {
    _flavor = flavor;
    _appName = appName ?? 'Graviton${flavor.suffix}';
  }

  /// Get configuration based on flavor
  T getFlavorValue<T>({required T dev, required T prod}) {
    switch (_flavor) {
      case AppFlavor.dev:
        return dev;
      case AppFlavor.prod:
        return prod;
    }
  }

  /// Get the Android package name based on current flavor
  String getPackageName() {
    return getFlavorValue(
      dev: AppConstants.packageNameDev,
      prod: AppConstants.packageNameProd,
    );
  }
}

/// App configuration constants
class AppConfig {
  static FlavorConfig get flavor => FlavorConfig.instance;

  // API endpoints
  static String get apiUrl => const String.fromEnvironment('urls.api');

  static String get playIntegrityVerificationUrl =>
      const String.fromEnvironment('urls.playIntegrityVerification');

  // Version information (injected at build time for web)
  static String get appVersion =>
      const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');

  static String get buildNumber =>
      const String.fromEnvironment('BUILD_NUMBER', defaultValue: '1');

  // External URLs
  static String get githubUrl => const String.fromEnvironment('urls.github');

  static String get websiteUrl => const String.fromEnvironment('urls.website');

  static String get privacyPolicyUrl =>
      const String.fromEnvironment('urls.privacyPolicy');

  static String get termsOfServiceUrl =>
      const String.fromEnvironment('urls.termsOfService');

  static String get companyWebsiteUrl =>
      const String.fromEnvironment('urls.companyWebsite');

  // Asset paths
  static String get appLogoPath => const String.fromEnvironment(
    'assets.appLogo',
    defaultValue: 'assets/images/app-logo.png',
  );

  static String get chipperLogoPath => const String.fromEnvironment(
    'assets.chipperLogo',
    defaultValue: 'assets/images/chipper-logo.svg',
  );

  static String get gravitonLogoPath => const String.fromEnvironment(
    'assets.gravitonLogo',
    defaultValue: 'assets/images/graviton-logo.svg',
  );

  // Analytics
  static bool get enableAnalytics => flavor.getFlavorValue(
    dev: true, // Enable for testing
    prod: true,
  );

  // Crashlytics
  static bool get enableCrashlytics => flavor.getFlavorValue(
    dev: false, // Disabled in dev to avoid noise
    prod: true,
  );

  // Logging
  static bool get enableVerboseLogging =>
      flavor.getFlavorValue(dev: true, prod: false);

  // Debug features
  static bool get showDebugBanner =>
      flavor.getFlavorValue(dev: true, prod: false);

  // Remote config refresh intervals
  static Duration get remoteConfigFetchInterval => flavor.getFlavorValue(
    dev: const Duration(minutes: 1),
    prod: const Duration(hours: 1),
  );

  // Screenshot mode for capturing marketing materials
  static bool get enableScreenshotMode =>
      flavor.getFlavorValue(dev: true, prod: false);

  // Apple Sign-In configuration
  static String get appleClientId =>
      const String.fromEnvironment('apple.clientId');

  static String get appleRedirectUri =>
      const String.fromEnvironment('apple.redirectUri');

  // RevenueCat configuration
  /// RevenueCat API key loaded from config file.
  /// Empty string on unsupported platforms (web, windows).
  static String get revenueCatApiKey =>
      const String.fromEnvironment('revenuecat.apiKey');

  // Stripe configuration (Web only)
  /// Stripe Payment Link URL for monthly subscription.
  /// Create in Stripe Dashboard > Payment Links.
  /// Example: https://buy.stripe.com/xxx
  static String get stripeMonthlyPaymentLink =>
      const String.fromEnvironment('stripe.monthlyPaymentLink');

  /// Stripe Payment Link URL for yearly subscription.
  /// Create in Stripe Dashboard > Payment Links.
  /// Example: https://buy.stripe.com/xxx
  static String get stripeYearlyPaymentLink =>
      const String.fromEnvironment('stripe.yearlyPaymentLink');

  /// Stripe Payment Link URL for lifetime purchase.
  /// Create in Stripe Dashboard > Payment Links.
  /// Example: https://buy.stripe.com/xxx
  static String get stripeLifetimePaymentLink =>
      const String.fromEnvironment('stripe.lifetimePaymentLink');
}
