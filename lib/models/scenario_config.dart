import 'package:flutter/material.dart';
import 'package:graviton/constants/educational_focus_keys.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/theme/app_colors.dart';

/// Configuration for generating a preset scenario
class ScenarioConfig {
  final ScenarioType type;
  final IconData icon;
  final Color primaryColor;
  final int expectedBodyCount;
  final String educationalFocus;
  final double? optimalCameraDistance; // Optional: if null, auto-calculate
  final double
  cameraDistanceMultiplier; // Multiplier for auto-calculated distance

  const ScenarioConfig({
    required this.type,
    required this.icon,
    required this.primaryColor,
    required this.expectedBodyCount,
    required this.educationalFocus,
    this.optimalCameraDistance,
    this.cameraDistanceMultiplier = 1.2, // Default 20% padding
  });

  /// Default configurations for all scenario types
  static const Map<ScenarioType, ScenarioConfig> defaults = {
    ScenarioType.random: ScenarioConfig(
      type: ScenarioType.random,
      icon: Icons.shuffle,
      primaryColor: AppColors.celestialAmber,
      expectedBodyCount: 4,
      educationalFocus: EducationalFocusKeys.chaoticDynamics,
    ),
    ScenarioType.earthMoonSun: ScenarioConfig(
      type: ScenarioType.earthMoonSun,
      icon: Icons.public,
      primaryColor: AppColors.celestialTeal,
      expectedBodyCount: 3,
      educationalFocus: EducationalFocusKeys.realWorldSystem,
    ),
    ScenarioType.binaryStars: ScenarioConfig(
      type: ScenarioType.binaryStars,
      icon: Icons.brightness_7,
      primaryColor: AppColors.celestialRed,
      expectedBodyCount: 4,
      educationalFocus: EducationalFocusKeys.binaryOrbits,
    ),
    ScenarioType.asteroidBelt: ScenarioConfig(
      type: ScenarioType.asteroidBelt,
      icon: Icons.scatter_plot,
      primaryColor: AppColors.celestialBlue,
      expectedBodyCount: 3,
      educationalFocus: EducationalFocusKeys.manyBodyDynamics,
    ),
    ScenarioType.galaxyFormation: ScenarioConfig(
      type: ScenarioType.galaxyFormation,
      icon: Icons.blur_circular,
      primaryColor: AppColors.celestialPink,
      expectedBodyCount: 31,
      educationalFocus: EducationalFocusKeys.structureFormation,
      optimalCameraDistance: 600.0, // Fixed distance for optimal galaxy view
    ),
    ScenarioType.solarSystem: ScenarioConfig(
      type: ScenarioType.solarSystem,
      icon: Icons.wb_sunny,
      primaryColor: AppColors.celestialOrange,
      expectedBodyCount: 9,
      educationalFocus: EducationalFocusKeys.planetaryMotion,
      optimalCameraDistance:
          1200.0, // Fixed distance for optimal solar system view
    ),
  };
}
