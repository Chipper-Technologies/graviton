/// Extension to provide semantic importance levels for screen reader announcements
///
/// This enum is used to control how accessibility announcements are presented
/// to users with screen readers, following the ARIA live region patterns.
enum LiveRegionImportance {
  /// Polite announcements that don't interrupt current speech
  ///
  /// These announcements will wait for the screen reader to finish
  /// any current speech before being announced. Use this for
  /// non-critical information updates.
  polite,

  /// Assertive announcements that interrupt current speech
  ///
  /// These announcements will immediately interrupt any current
  /// screen reader speech. Use sparingly and only for critical
  /// information that users need to know immediately.
  assertive,
}

/// Extension methods for LiveRegionImportance
extension LiveRegionImportanceExtension on LiveRegionImportance {
  /// Convert to the string value used by accessibility services
  String get value {
    switch (this) {
      case LiveRegionImportance.polite:
        return 'polite';
      case LiveRegionImportance.assertive:
        return 'assertive';
    }
  }

  /// Get a human-readable description of this importance level
  String get description {
    switch (this) {
      case LiveRegionImportance.polite:
        return 'Polite announcements that don\'t interrupt current speech';
      case LiveRegionImportance.assertive:
        return 'Assertive announcements that interrupt current speech';
    }
  }

  /// Whether this importance level is high priority
  bool get isHighPriority {
    switch (this) {
      case LiveRegionImportance.polite:
        return false;
      case LiveRegionImportance.assertive:
        return true;
    }
  }

  /// Parse from string value
  static LiveRegionImportance fromString(String value) {
    switch (value.toLowerCase()) {
      case 'polite':
        return LiveRegionImportance.polite;
      case 'assertive':
        return LiveRegionImportance.assertive;
      default:
        return LiveRegionImportance.polite; // Default to polite
    }
  }
}
