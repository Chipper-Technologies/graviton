/// Represents the habitability status of a celestial body
enum HabitabilityStatus {
  /// The body is within the habitable zone and potentially suitable for life
  habitable,

  /// The body is too close to its star(s) and too hot for liquid water
  tooHot,

  /// The body is too far from its star(s) and too cold for liquid water
  tooCold,

  /// The body's habitability cannot be determined (e.g., no nearby stars, asteroid)
  unknown,
}

/// Extension methods for HabitabilityStatus
extension HabitabilityStatusExtension on HabitabilityStatus {
  /// Color associated with this habitability status
  int get statusColor {
    switch (this) {
      case HabitabilityStatus.habitable:
        return 0xFF4CAF50; // Green
      case HabitabilityStatus.tooHot:
        return 0xFFF44336; // Red
      case HabitabilityStatus.tooCold:
        return 0xFF2196F3; // Blue
      case HabitabilityStatus.unknown:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Display name for the status
  String get displayName {
    switch (this) {
      case HabitabilityStatus.habitable:
        return 'Habitable';
      case HabitabilityStatus.tooHot:
        return 'Too Hot';
      case HabitabilityStatus.tooCold:
        return 'Too Cold';
      case HabitabilityStatus.unknown:
        return 'Unknown';
    }
  }

  /// Localization key for the status
  String get localizationKey {
    switch (this) {
      case HabitabilityStatus.habitable:
        return 'habitabilityHabitable';
      case HabitabilityStatus.tooHot:
        return 'habitabilityTooHot';
      case HabitabilityStatus.tooCold:
        return 'habitabilityTooCold';
      case HabitabilityStatus.unknown:
        return 'habitabilityUnknown';
    }
  }
}
