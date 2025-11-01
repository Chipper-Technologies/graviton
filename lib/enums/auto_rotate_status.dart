/// Represents the auto-rotation status of the camera
enum AutoRotateStatus {
  /// Auto-rotation is enabled
  on,

  /// Auto-rotation is disabled
  off,
}

/// Extension methods for AutoRotateStatus
extension AutoRotateStatusExtension on AutoRotateStatus {
  /// Whether auto-rotation is enabled
  bool get isEnabled => this == AutoRotateStatus.on;

  /// Toggle between on and off
  AutoRotateStatus get toggle =>
      this == AutoRotateStatus.on ? AutoRotateStatus.off : AutoRotateStatus.on;

  /// Get localization key for this status
  String get localizationKey {
    switch (this) {
      case AutoRotateStatus.on:
        return 'autoRotateOn';
      case AutoRotateStatus.off:
        return 'autoRotateOff';
    }
  }

  /// Create from boolean value
  static AutoRotateStatus fromBool(bool enabled) {
    return enabled ? AutoRotateStatus.on : AutoRotateStatus.off;
  }

  /// Convert to boolean value for backward compatibility
  bool toBool() => isEnabled;
}
