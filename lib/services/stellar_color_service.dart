import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

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
            1000.0 // Has a meaningful stellar temperature (threshold: 1000K)
        ? body.temperature
        : _calculateStellarTemperature(body.mass);

    return _getColorFromTemperature(effectiveTemperature);
  }

  /// Get realistic color for specific named celestial bodies
  /// Returns null if body is not a recognized specific celestial object
  /// Note: ALL planets and moons are excluded to preserve their original designed appearance and trail colors
  static Color? _getSpecificBodyColor(Body body) {
    final bodyName = body.name.toLowerCase();

    // Only apply realistic colors to stars and asteroids
    if (bodyName.contains('sun')) {
      return AppColors.stellarGType; // G-type star (yellow, like our Sun)
    } else if (bodyName.contains('asteroid')) {
      return AppColors.asteroidBrownish; // Brownish rocky asteroids
    } else if (bodyName.contains('central star') || bodyName.contains('star a') || bodyName.contains('star b')) {
      // Binary star system stars - use realistic stellar classification
      final effectiveTemperature = _calculateStellarTemperature(body.mass);
      return _getColorFromTemperature(effectiveTemperature);
    }

    // Not a specific recognized body type for realistic coloring
    return null;
  }

  /// Calculate stellar surface temperature from mass
  /// Based on main sequence mass-temperature relationship
  static double _calculateStellarTemperature(double mass) {
    // Sun has mass ~10 units in our simulation, temperature ~5778K
    const sunMass = 10.0;
    const sunTemperature = 5778.0;

    // Mass-temperature relationship for main sequence stars
    // More massive stars are hotter: T ∝ M^0.5 to M^0.8 depending on mass range
    final massRatio = mass / sunMass;

    if (massRatio > 1.5) {
      // High mass stars: stronger dependence
      return sunTemperature * math.pow(massRatio, 0.8);
    } else {
      // Lower mass stars: weaker dependence
      return sunTemperature * math.pow(massRatio, 0.5);
    }
  }

  /// Convert temperature to realistic stellar color using black-body radiation
  static Color _getColorFromTemperature(double temperature) {
    // Stellar classification based on surface temperature:
    // O: > 30,000K (blue)
    // B: 10,000-30,000K (blue-white)
    // A: 7,500-10,000K (white)
    // F: 6,000-7,500K (yellow-white)
    // G: 5,200-6,000K (yellow) - Sun-like
    // K: 3,700-5,200K (orange)
    // M: < 3,700K (red)

    if (temperature > 30000) {
      // O-type: Hot blue stars
      return AppColors.stellarOType;
    } else if (temperature > 10000) {
      // B-type: Blue-white stars
      return AppColors.stellarBType;
    } else if (temperature > 7500) {
      // A-type: White stars
      return AppColors.stellarAType;
    } else if (temperature > 6000) {
      // F-type: Yellow-white stars
      return AppColors.stellarFType;
    } else if (temperature > 5200) {
      // G-type: Yellow stars (Sun-like)
      return AppColors.stellarGType;
    } else if (temperature > 3700) {
      // K-type: Orange stars
      return AppColors.stellarKType;
    } else {
      // M-type: Red dwarf stars
      return AppColors.stellarMType;
    }
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
