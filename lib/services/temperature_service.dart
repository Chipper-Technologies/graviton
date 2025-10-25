import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';

/// Service for calculating planetary surface temperatures based on stellar radiation
class TemperatureService {
  TemperatureService._(); // Private constructor for singleton

  /// Calculate planetary temperature based on stellar radiation
  /// Uses simplified blackbody radiation model
  static double calculatePlanetaryTemperature(Body planet, List<Body> stars) {
    if (!planet.canBeHabitable || stars.isEmpty) {
      return planet.temperature; // Keep current temperature for non-planets
    }

    double totalRadiation = 0.0;

    // Calculate radiation received from all stars
    for (final star in stars) {
      if (!star.isLuminous || star.stellarLuminosity <= 0) continue;

      final distance = (planet.position - star.position).length;
      if (distance < 0.1) continue; // Avoid division by zero

      // Inverse square law: radiation intensity ∝ luminosity / distance²
      final radiationIntensity = star.stellarLuminosity / (distance * distance);
      totalRadiation += radiationIntensity;
    }

    // Convert radiation to temperature using Stefan-Boltzmann approximation
    // T = (L/(4πσr²))^(1/4) where σ is Stefan-Boltzmann constant
    // Simplified for our simulation units
    const double baseTemperature =
        SimulationConstants.cosmicMicrowaveBackgroundTemperature;
    const double radiationConstant =
        SimulationConstants.stellarRadiationToTemperatureConstant;

    final effectiveTemperature =
        baseTemperature + radiationConstant * math.pow(totalRadiation, 0.25);

    // Apply greenhouse effect for planets with substantial mass (thicker atmosphere)
    double greenhouseMultiplier = 1.0;
    if (planet.mass > 1.0) {
      // Substantial atmosphere
      greenhouseMultiplier =
          1.0 + (planet.mass - 1.0) * 0.1; // Up to 40% greenhouse effect
      greenhouseMultiplier = math.min(
        greenhouseMultiplier,
        1.4,
      ); // Cap at 40% increase
    }

    return effectiveTemperature * greenhouseMultiplier;
  }

  /// Update all planetary temperatures in the simulation
  static void updateAllTemperatures(List<Body> bodies) {
    // Find all stars
    final stars = bodies.where((body) => body.isLuminous).toList();

    // Update temperature for all planets and moons
    for (final body in bodies) {
      if (body.canBeHabitable) {
        final newTemperature = calculatePlanetaryTemperature(body, stars);
        body.updateTemperature(newTemperature);
      }
    }
  }

  /// Get initial temperature for a new body based on its type and mass
  static double getInitialTemperature(
    BodyType bodyType,
    double mass, {
    double? distance,
  }) {
    switch (bodyType) {
      case BodyType.star:
        // Stellar core temperature based on mass (rough approximation)
        // More massive stars are hotter
        return 5778.0 *
            math.pow(mass / 10.0, 0.5); // Sun surface temp * mass factor

      case BodyType.planet:
      case BodyType.moon:
        // Base temperature for distant bodies
        if (distance != null && distance > 0) {
          // Rough estimate: T ∝ 1/sqrt(distance)
          // At distance 50 (Earth-like), temperature ≈ 288K (15°C)
          return 288.0 * math.pow(50.0 / distance, 0.5);
        }
        return 220.0; // Cold by default (about -53°C)

      case BodyType.asteroid:
        return 200.0; // Very cold (-73°C)
    }
  }

  /// Format temperature for display
  static String formatTemperature(
    double temperatureKelvin, {
    bool showUnit = true,
    AppLocalizations? l10n,
  }) {
    final celsius = temperatureKelvin - 273.15;
    final unitSymbol = l10n?.temperatureUnitCelsius ?? '°C';

    if (showUnit) {
      if (celsius.abs() < 1000) {
        return '${celsius.toStringAsFixed(0)}$unitSymbol';
      } else {
        return '${(celsius / 1000).toStringAsFixed(1)}k$unitSymbol';
      }
    }
    return celsius.toStringAsFixed(0);
  }

  /// Get localized temperature category string
  static String getLocalizedTemperatureCategory(
    String categoryKey,
    AppLocalizations l10n,
  ) {
    switch (categoryKey) {
      case 'temperatureFrozen':
        return l10n.temperatureFrozen;
      case 'temperatureCold':
        return l10n.temperatureCold;
      case 'temperatureModerate':
        return l10n.temperatureModerate;
      case 'temperatureHot':
        return l10n.temperatureHot;
      case 'temperatureScorching':
        return l10n.temperatureScorching;
      case 'temperatureNotApplicable':
        return l10n.temperatureNotApplicable;
      default:
        return l10n.temperatureNotApplicable;
    }
  }

  /// Get color for temperature visualization
  static Color getTemperatureColor(double temperatureKelvin) {
    return AppColors.getTemperatureColor(temperatureKelvin);
  }
}
