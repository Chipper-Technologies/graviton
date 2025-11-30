/// Application-level constants for package identification and configuration.
class AppConstants {
  /// Private constructor to prevent instantiation.
  AppConstants._();

  /// Android package name for production flavor
  static const String packageNameProd = 'io.chipper.graviton';

  /// Android package name for development flavor
  static const String packageNameDev = 'io.chipper.graviton.dev';

  /// iOS bundle identifier for production flavor
  static const String bundleIdProd = 'io.chipper.graviton';

  /// iOS bundle identifier for development flavor
  static const String bundleIdDev = 'io.chipper.graviton.dev';
}
