import 'package:graviton/enums/app_flavor.dart';

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
}

/// App configuration constants
class AppConfig {
  static FlavorConfig get flavor => FlavorConfig.instance;

  // API endpoints
  static String get baseUrl => flavor.getFlavorValue(
    dev: 'https://api.dev.chipperlabs.com',
    prod: 'https://api.chipperlabs.com',
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
}
