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
      nameBuilder: (l) => l.experimentGalacticDanceName,
      descriptionBuilder: (l) => l.experimentGalacticDanceDescription,
      icon: Icons.blur_circular,
      color: AppColors.starMediumSlateBlue, // Purple for cosmic phenomena
      tags: ['galaxies', 'collision', 'evolution'],
      durationBuilder: (l) => l.experimentGalacticDanceDuration,
      difficultyBuilder: (l) => l.experimentDifficultyAdvanced,
    ),
    ExperimentalScenarioConfig(
      nameBuilder: (l) => l.experimentRingFormationName,
      descriptionBuilder: (l) => l.experimentRingFormationDescription,
      icon: Icons.panorama_fish_eye,
      color: AppColors.stellarKType, // Orange for dynamic processes
      tags: ['rings', 'tidal forces', 'disruption'],
      durationBuilder: (l) => l.experimentRingFormationDuration,
      difficultyBuilder: (l) => l.experimentDifficultyIntermediate,
    ),
    ExperimentalScenarioConfig(
      nameBuilder: (l) => l.experimentCometTrajectoryName,
      descriptionBuilder: (l) => l.experimentCometTrajectoryDescription,
      icon: Icons.timeline,
      color: AppColors.iceGiantUranusLike, // Cyan for icy bodies
      tags: ['comet', 'ellipse', 'conservation'],
      durationBuilder: (l) => l.experimentCometTrajectoryDuration,
      difficultyBuilder: (l) => l.experimentDifficultyBeginner,
    ),
    ExperimentalScenarioConfig(
      nameBuilder: (l) => l.experimentStellarNurseryName,
      descriptionBuilder: (l) => l.experimentStellarNurseryDescription,
      icon: Icons.star_border,
      color: AppColors.stellarMType, // Red-orange for star formation regions
      tags: ['formation', 'gas', 'collapse'],
      durationBuilder: (l) => l.experimentStellarNurseryDuration,
      difficultyBuilder: (l) => l.experimentDifficultyAdvanced,
    ),
  ];
}
