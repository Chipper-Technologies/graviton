import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Configuration for experimental scenarios with predefined physics experiments
class ExperimentalScenarioConfig {
  /// The localized display name of the experimental scenario
  final String Function(AppLocalizations) nameBuilder;

  /// Localized brief description of the physics experiment
  final String Function(AppLocalizations) descriptionBuilder;

  /// Icon to display for this experiment
  final IconData icon;

  /// Color theme for this experiment
  final Color color;

  /// Tags for categorization
  final List<String> tags;

  /// Localized expected duration in simulation time
  final String Function(AppLocalizations) durationBuilder;

  /// Localized difficulty level
  final String Function(AppLocalizations) difficultyBuilder;

  ExperimentalScenarioConfig({
    required this.nameBuilder,
    required this.descriptionBuilder,
    required this.icon,
    required this.color,
    required this.tags,
    required this.durationBuilder,
    required this.difficultyBuilder,
  });

  /// Get localized name
  String name(AppLocalizations localizations) => nameBuilder(localizations);

  /// Get localized description
  String description(AppLocalizations localizations) =>
      descriptionBuilder(localizations);

  /// Get localized duration
  String duration(AppLocalizations localizations) =>
      durationBuilder(localizations);

  /// Get localized difficulty
  String difficulty(AppLocalizations localizations) =>
      difficultyBuilder(localizations);

  /// Predefined experimental scenarios
  static List<ExperimentalScenarioConfig> experiments = [
    ExperimentalScenarioConfig(
      nameBuilder: (l) => l.experimentBinaryPulsarName,
      descriptionBuilder: (l) => l.experimentBinaryPulsarDescription,
      icon: Icons.blur_on,
      color: AppColors.stellarOType, // Blue for high-energy neutron stars
      tags: ['neutron stars', 'relativity', 'waves'],
      durationBuilder: (l) => l.experimentBinaryPulsarDuration,
      difficultyBuilder: (l) => l.experimentDifficultyAdvanced,
    ),
    ExperimentalScenarioConfig(
      nameBuilder: (l) => l.experimentTrojanAsteroidsName,
      descriptionBuilder: (l) => l.experimentTrojanAsteroidsDescription,
      icon: Icons.scatter_plot,
      color:
          AppColors.habitabilityHabitable, // Green for stable orbital mechanics
      tags: ['asteroids', 'lagrange', 'stability'],
      durationBuilder: (l) => l.experimentTrojanAsteroidsDuration,
      difficultyBuilder: (l) => l.experimentDifficultyIntermediate,
    ),
    ExperimentalScenarioConfig(
      nameBuilder: (l) => l.experimentDoubleStarEclipseName,
      descriptionBuilder: (l) => l.experimentDoubleStarEclipseDescription,
      icon: Icons.brightness_2,
      color: AppColors.stellarKType, // Orange for eclipsing stars
      tags: ['binary', 'eclipse', 'photometry'],
      durationBuilder: (l) => l.experimentDoubleStarEclipseDuration,
      difficultyBuilder: (l) => l.experimentDifficultyIntermediate,
    ),
    ExperimentalScenarioConfig(
      nameBuilder: (l) => l.experimentRoguePlanetName,
      descriptionBuilder: (l) => l.experimentRoguePlanetDescription,
      icon: Icons.explore,
      color: AppColors
          .starMediumSlateBlue, // Purple for mysterious wandering planet
      tags: ['rogue', 'encounter', 'dynamics'],
      durationBuilder: (l) => l.experimentRoguePlanetDuration,
      difficultyBuilder: (l) => l.experimentDifficultyAdvanced,
    ),
  ];
}
