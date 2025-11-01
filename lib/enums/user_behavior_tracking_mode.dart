/// Represents user behavior tracking modes for analytics
enum UserBehaviorTrackingMode {
  /// Full tracking enabled (all events)
  full,

  /// Essential tracking only (core events)
  essential,

  /// No tracking (privacy mode)
  none,

  /// Limited tracking (user-defined subset)
  limited,
}

/// Extension methods for UserBehaviorTrackingMode
extension UserBehaviorTrackingModeExtension on UserBehaviorTrackingMode {
  /// Get string value for storage
  String get configValue {
    switch (this) {
      case UserBehaviorTrackingMode.full:
        return 'full';
      case UserBehaviorTrackingMode.essential:
        return 'essential';
      case UserBehaviorTrackingMode.none:
        return 'none';
      case UserBehaviorTrackingMode.limited:
        return 'limited';
    }
  }

  /// Create from string value
  static UserBehaviorTrackingMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'full':
        return UserBehaviorTrackingMode.full;
      case 'essential':
        return UserBehaviorTrackingMode.essential;
      case 'none':
        return UserBehaviorTrackingMode.none;
      case 'limited':
        return UserBehaviorTrackingMode.limited;
      default:
        return UserBehaviorTrackingMode.essential; // Safe default
    }
  }

  /// Whether analytics should be collected
  bool get allowsAnalytics => this != UserBehaviorTrackingMode.none;

  /// Whether crash reporting is enabled
  bool get allowsCrashReporting =>
      this == UserBehaviorTrackingMode.full ||
      this == UserBehaviorTrackingMode.essential;

  /// Whether performance monitoring is enabled
  bool get allowsPerformanceMonitoring => this == UserBehaviorTrackingMode.full;

  /// Whether user interaction tracking is enabled
  bool get allowsInteractionTracking =>
      this == UserBehaviorTrackingMode.full ||
      this == UserBehaviorTrackingMode.limited;

  /// Display name for settings UI
  String get displayName {
    switch (this) {
      case UserBehaviorTrackingMode.full:
        return 'Full Tracking';
      case UserBehaviorTrackingMode.essential:
        return 'Essential Only';
      case UserBehaviorTrackingMode.none:
        return 'No Tracking';
      case UserBehaviorTrackingMode.limited:
        return 'Limited Tracking';
    }
  }

  /// Description for settings UI
  String get description {
    switch (this) {
      case UserBehaviorTrackingMode.full:
        return 'All analytics, crashes, and interactions';
      case UserBehaviorTrackingMode.essential:
        return 'Critical crashes and errors only';
      case UserBehaviorTrackingMode.none:
        return 'No data collection';
      case UserBehaviorTrackingMode.limited:
        return 'User interactions only';
    }
  }
}
