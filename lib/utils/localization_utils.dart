import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/constants/educational_focus_keys.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Utility functions for localization mapping and text handling
class LocalizationUtils {
  LocalizationUtils._(); // Private constructor to prevent instantiation

  /// Translate a stored body name to the current localized name
  /// Used for translating body names from storage/config to display names
  static String getLocalizedBodyName(
    String storedName,
    AppLocalizations? l10n,
  ) {
    if (l10n == null) return storedName;

    // Try to find a matching enum value
    final bodyEnum = CelestialBodyName.fromString(storedName);
    if (bodyEnum != null) {
      // Handle numbered bodies like "Asteroid 1"
      final RegExp numberedPattern = RegExp(r'^(\w+(?:\s+\w+)*)\s+(\d+)$');
      final match = numberedPattern.firstMatch(storedName);
      if (match != null) {
        final number = int.tryParse(match.group(2)!);
        if (number != null) {
          return bodyEnum.getNumberedLocalizedName(l10n, number);
        }
      }

      // Regular body name
      return bodyEnum.getLocalizedName(l10n);
    }

    // Fallback to the original name if no enum match found
    return storedName;
  }

  /// Get localized scenario name
  static String getLocalizedScenarioName(
    AppLocalizations l10n,
    ScenarioType scenario,
  ) {
    switch (scenario) {
      case ScenarioType.random:
        return l10n.scenarioRandom;
      case ScenarioType.earthMoonSun:
        return l10n.scenarioEarthMoonSun;
      case ScenarioType.binaryStars:
        return l10n.scenarioBinaryStars;
      case ScenarioType.asteroidBelt:
        return l10n.scenarioAsteroidBelt;
      case ScenarioType.galaxyFormation:
        return l10n.scenarioGalaxyFormation;
      case ScenarioType.solarSystem:
        return l10n.scenarioSolarSystem;
      case ScenarioType.threeBodyClassic:
      case ScenarioType.collisionDemo:
      case ScenarioType.deepSpace:
        // These scenarios are used by screenshot presets but not available in the main scenario selection
        return l10n.scenarioSpecial;
    }
  }

  /// Get localized scenario description
  static String getLocalizedScenarioDescription(
    AppLocalizations l10n,
    ScenarioType scenario,
  ) {
    switch (scenario) {
      case ScenarioType.random:
        return l10n.scenarioRandomDescription;
      case ScenarioType.earthMoonSun:
        return l10n.scenarioEarthMoonSunDescription;
      case ScenarioType.binaryStars:
        return l10n.scenarioBinaryStarsDescription;
      case ScenarioType.asteroidBelt:
        return l10n.scenarioAsteroidBeltDescription;
      case ScenarioType.galaxyFormation:
        return l10n.scenarioGalaxyFormationDescription;
      case ScenarioType.solarSystem:
        return l10n.scenarioSolarSystemDescription;
      case ScenarioType.threeBodyClassic:
      case ScenarioType.collisionDemo:
      case ScenarioType.deepSpace:
        // These scenarios are used by screenshot presets but not available in the main scenario selection
        return l10n.scenarioSpecialDescription;
    }
  }

  /// Get localized educational focus
  static String getLocalizedEducationalFocus(
    AppLocalizations l10n,
    String focus,
  ) {
    switch (focus) {
      case EducationalFocusKeys.chaoticDynamics:
        return l10n.educationalFocusChaoticDynamics;
      case EducationalFocusKeys.realWorldSystem:
        return l10n.educationalFocusRealWorldSystem;
      case EducationalFocusKeys.binaryOrbits:
        return l10n.educationalFocusBinaryOrbits;
      case EducationalFocusKeys.manyBodyDynamics:
        return l10n.educationalFocusManyBodyDynamics;
      case EducationalFocusKeys.structureFormation:
        return l10n.educationalFocusStructureFormation;
      case EducationalFocusKeys.planetaryMotion:
        return l10n.educationalFocusPlanetaryMotion;
      default:
        // Fallback for unknown keys
        return focus;
    }
  }

  /// Get localized habitability status string
  static String getLocalizedHabitabilityStatus(
    AppLocalizations l10n,
    HabitabilityStatus status,
  ) {
    switch (status) {
      case HabitabilityStatus.habitable:
        return l10n.habitabilityHabitable;
      case HabitabilityStatus.tooHot:
        return l10n.habitabilityTooHot;
      case HabitabilityStatus.tooCold:
        return l10n.habitabilityTooCold;
      case HabitabilityStatus.unknown:
        return l10n.habitabilityUnknown;
    }
  }
}
