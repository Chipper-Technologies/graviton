import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/temperature_utils.dart';

/// Service for calculating realistic colors for all celestial bodies
/// Uses Harvard spectral classification for stars (O, B, A, F, G, K, M)
/// Provides temperature-based colors for planets, moons, and asteroids
class StellarColorService {
  StellarColorService._(); // Private constructor for singleton

  /// Calculate realistic body color based on temperature, mass, and body type
  /// Uses Harvard spectral classification system for stars (O, B, A, F, G, K, M)
  /// Excludes ALL planets and moons to preserve their designed appearance
  static Color getRealisticBodyColor(Body body) {
    // Exclude ALL planets and moons from realistic coloring to preserve their design
    if (body.bodyType == BodyType.planet || body.bodyType == BodyType.moon) {
      return body.color; // Return original color for planets and moons
    }

    // First check for specific named celestial bodies for accurate representation
    final specificColor = _getSpecificBodyColor(body);
    if (specificColor != null) {
      return specificColor;
    }

    if (!body.isLuminous) {
      // For non-luminous bodies, use temperature-based color
      return _getPlanetaryColor(body);
    }

    // Use the body's actual temperature if available (for galaxy formation scenario),
    // otherwise calculate effective temperature from mass using mass-temperature relationship
    final effectiveTemperature =
        body.temperature >
            SimulationConstants
                .meaningfulStellarTemperatureThreshold // Has a meaningful stellar temperature
        ? body.temperature
        : TemperatureUtils.calculateStellarTemperature(body.mass);

    return TemperatureUtils.getColorFromTemperature(effectiveTemperature);
  }

  /// Get realistic color for specific named celestial bodies
  /// Returns null if body is not a recognized specific celestial object
  /// Note: ALL planets and moons are excluded to preserve their original designed appearance and trail colors
  static Color? _getSpecificBodyColor(Body body) {
    final bodyEnum = CelestialBodyName.fromString(body.name);

    // Only apply realistic colors to stars and asteroids
    if (bodyEnum == CelestialBodyName.sun) {
      return AppColors.stellarGType; // G-type star (yellow, like our Sun)
    } else if (bodyEnum == CelestialBodyName.asteroid ||
        body.name.toLowerCase().contains('asteroid')) {
      return AppColors.asteroidBrownish; // Brownish rocky asteroids
    } else if (bodyEnum == CelestialBodyName.centralStar ||
        bodyEnum == CelestialBodyName.starA ||
        bodyEnum == CelestialBodyName.starB) {
      // Binary star system stars - use realistic stellar classification
      final effectiveTemperature = TemperatureUtils.calculateStellarTemperature(
        body.mass,
      );
      return TemperatureUtils.getColorFromTemperature(effectiveTemperature);
    }

    // Not a specific recognized body type for realistic coloring
    return null;
  }

  /// Get realistic colors for non-stellar, non-planetary bodies (primarily asteroids)
  /// Note: Planets and moons are excluded by early return in getRealisticBodyColor
  static Color _getPlanetaryColor(Body body) {
    switch (body.bodyType) {
      case BodyType.asteroid:
        return AppColors.asteroidBrownish;
      case BodyType.star:
        // Fallback for edge cases where a non-luminous star reaches this point
        return AppColors.celestialGold;
      case BodyType.planet:
      case BodyType.moon:
        // These cases should never be reached due to early return in getRealisticBodyColor,
        // but included for completeness and to handle potential future changes
        return body.color;
    }
  }

  /// Get realistic trail color for a body (typically matches the body color)
  static Color getRealisticTrailColor(Body body) {
    // Trail color matches the realistic body color but with some transparency
    final bodyColor = getRealisticBodyColor(body);
    return bodyColor.withValues(alpha: AppTypography.opacityVeryHigh);
  }
}
