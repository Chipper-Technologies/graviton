import 'package:graviton/theme/app_colors.dart';

/// Represents the habitability status of a celestial body
enum HabitabilityStatus {
  /// The body is within the habitable zone and potentially suitable for life
  habitable,

  /// The body is too close to its star(s) and too hot for liquid water
  tooHot,

  /// The body is too far from its star(s) and too cold for liquid water
  tooCold,

  /// Gas giant planet - no solid surface for life as we know it
  gasGiant,

  /// Body is too small to retain atmosphere and maintain stable conditions
  tooSmall,

  /// Body lacks sufficient atmosphere for liquid water
  noAtmosphere,

  /// Body has toxic atmosphere incompatible with known life forms
  toxicAtmosphere,

  /// Body experiences extreme radiation levels harmful to life
  highRadiation,

  /// Body is tidally locked with extreme temperature differences
  tidallyLocked,

  /// Body orbits too close to a black hole or neutron star
  extremeGravity,

  /// The body's habitability cannot be determined (e.g., no nearby stars, asteroid)
  unknown,
}

/// Extension methods for HabitabilityStatus
extension HabitabilityStatusExtension on HabitabilityStatus {
  /// Color associated with this habitability status
  int get statusColor {
    switch (this) {
      case HabitabilityStatus.habitable:
        return AppColors.habitabilityHabitable.toARGB32();
      case HabitabilityStatus.tooHot:
        return AppColors.habitabilityTooHot.toARGB32();
      case HabitabilityStatus.tooCold:
        return AppColors.habitabilityTooCold.toARGB32();
      case HabitabilityStatus.gasGiant:
        return AppColors.habitabilityGasGiant.toARGB32();
      case HabitabilityStatus.tooSmall:
        return AppColors.habitabilityTooSmall.toARGB32();
      case HabitabilityStatus.noAtmosphere:
        return AppColors.habitabilityNoAtmosphere.toARGB32();
      case HabitabilityStatus.toxicAtmosphere:
        return AppColors.habitabilityToxicAtmosphere.toARGB32();
      case HabitabilityStatus.highRadiation:
        return AppColors.habitabilityHighRadiation.toARGB32();
      case HabitabilityStatus.tidallyLocked:
        return AppColors.habitabilityTidallyLocked.toARGB32();
      case HabitabilityStatus.extremeGravity:
        return AppColors.habitabilityExtremeGravity.toARGB32();
      case HabitabilityStatus.unknown:
        return AppColors.habitabilityUnknown.toARGB32();
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
      case HabitabilityStatus.gasGiant:
        return 'habitabilityGasGiant';
      case HabitabilityStatus.tooSmall:
        return 'habitabilityTooSmall';
      case HabitabilityStatus.noAtmosphere:
        return 'habitabilityNoAtmosphere';
      case HabitabilityStatus.toxicAtmosphere:
        return 'habitabilityToxicAtmosphere';
      case HabitabilityStatus.highRadiation:
        return 'habitabilityHighRadiation';
      case HabitabilityStatus.tidallyLocked:
        return 'habitabilityTidallyLocked';
      case HabitabilityStatus.extremeGravity:
        return 'habitabilityExtremeGravity';
      case HabitabilityStatus.unknown:
        return 'habitabilityUnknown';
    }
  }

  /// Whether this status indicates a habitable world
  bool get isHabitable {
    return this == HabitabilityStatus.habitable;
  }
}
