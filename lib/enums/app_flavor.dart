/// App flavor configuration enum
enum AppFlavor {
  dev,
  prod;

  String get name {
    switch (this) {
      case AppFlavor.dev:
        return 'Development';
      case AppFlavor.prod:
        return 'Production';
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
