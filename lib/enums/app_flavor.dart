/// App flavor configuration enum
enum AppFlavor {
  dev,
  prod;

  /// Localization key for the flavor display name
  String get localizationKey {
    switch (this) {
      case AppFlavor.dev:
        return 'appFlavorDevelopment';
      case AppFlavor.prod:
        return 'appFlavorProduction';
    }
  }

  String get suffix {
    switch (this) {
      case AppFlavor.dev:
        return ' Dev';
      case AppFlavor.prod:
        return '';
    }
  }

  bool get isDevelopment => this == AppFlavor.dev;
  bool get isProduction => this == AppFlavor.prod;
}
