/// Changelog entry categories
enum ChangelogCategory {
  /// New features or capabilities
  added('added'),

  /// Improvements to existing features
  improved('improved'),

  /// Bug fixes and corrections
  fixed('fixed');

  const ChangelogCategory(this.value);

  /// The string value used in Firestore
  final String value;

  /// Create from string value
  static ChangelogCategory fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'added':
        return ChangelogCategory.added;
      case 'improved':
        return ChangelogCategory.improved;
      case 'fixed':
        return ChangelogCategory.fixed;
      default:
        return ChangelogCategory.added; // Default fallback
    }
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case ChangelogCategory.added:
        return 'Added';
      case ChangelogCategory.improved:
        return 'Improved';
      case ChangelogCategory.fixed:
        return 'Fixed';
    }
  }

  @override
  String toString() => value;
}
