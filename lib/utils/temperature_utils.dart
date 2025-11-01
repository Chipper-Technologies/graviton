import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';

/// Utility functions for stellar temperature calculations and color mapping
/// Based on Harvard spectral classification system for stars (O, B, A, F, G, K, M)
class TemperatureUtils {
  TemperatureUtils._(); // Private constructor to prevent instantiation

  /// Calculate stellar surface temperature from mass
  /// Based on main sequence mass-temperature relationship
  ///
  /// Uses the mass-temperature relationship for main sequence stars:
  /// - High mass stars (>1.5 solar masses): T ∝ M^0.8
  /// - Lower mass stars (≤1.5 solar masses): T ∝ M^0.5
  static double calculateStellarTemperature(double mass) {
    // Sun has mass ~10 units in our simulation, temperature ~5778K
    final sunMass = SimulationConstants.sunMassReference;
    final sunTemperature = SimulationConstants.sunTemperatureReference;

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
  /// Based on Harvard spectral classification system
  ///
  /// Stellar classification based on surface temperature:
  /// - O: > 30,000K (blue)
  /// - B: 10,000-30,000K (blue-white)
  /// - A: 7,500-10,000K (white)
  /// - F: 6,000-7,500K (yellow-white)
  /// - G: 5,200-6,000K (yellow) - Sun-like
  /// - K: 3,700-5,200K (orange)
  /// - M: < 3,700K (red)
  static Color getColorFromTemperature(double temperature) {
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

  /// Get Harvard spectral class from temperature
  /// Returns the single-letter spectral classification
  static String getSpectralClass(double temperature) {
    if (temperature > 30000) {
      return 'O';
    } else if (temperature > 10000) {
      return 'B';
    } else if (temperature > 7500) {
      return 'A';
    } else if (temperature > 6000) {
      return 'F';
    } else if (temperature > 5200) {
      return 'G';
    } else if (temperature > 3700) {
      return 'K';
    } else {
      return 'M';
    }
  }

  /// Get descriptive temperature range for a spectral class
  static String getTemperatureRange(
    String spectralClass, {
    AppLocalizations? l10n,
  }) {
    switch (spectralClass.toUpperCase()) {
      case 'O':
        return '> 30,000K';
      case 'B':
        return '10,000-30,000K';
      case 'A':
        return '7,500-10,000K';
      case 'F':
        return '6,000-7,500K';
      case 'G':
        return '5,200-6,000K';
      case 'K':
        return '3,700-5,200K';
      case 'M':
        return '< 3,700K';
      default:
        return l10n?.habitabilityUnknown ?? 'Unknown';
    }
  }

  /// Get color description for a spectral class
  static String getColorDescription(
    String spectralClass, {
    AppLocalizations? l10n,
  }) {
    switch (spectralClass.toUpperCase()) {
      case 'O':
        return l10n?.stellarColorBlue ?? 'Blue';
      case 'B':
        return l10n?.stellarColorBlueWhite ?? 'Blue-white';
      case 'A':
        return l10n?.stellarColorWhite ?? 'White';
      case 'F':
        return l10n?.stellarColorYellowWhite ?? 'Yellow-white';
      case 'G':
        return l10n?.stellarColorYellow ?? 'Yellow';
      case 'K':
        return l10n?.stellarColorOrange ?? 'Orange';
      case 'M':
        return l10n?.stellarColorRed ?? 'Red';
      default:
        return l10n?.habitabilityUnknown ?? 'Unknown';
    }
  }

  /// Calculate approximate luminosity from temperature and mass
  /// Uses the mass-luminosity relationship: L ∝ M^3.5 for main sequence stars
  static double calculateLuminosity(double mass, double temperature) {
    final sunMass = SimulationConstants.sunMassReference;
    final massRatio = mass / sunMass;

    // Mass-luminosity relationship for main sequence stars
    return math.pow(massRatio, 3.5).toDouble();
  }

  /// Check if temperature indicates a meaningful stellar temperature
  /// Returns true if temperature is above the threshold for stellar classification
  static bool isMeaningfulStellarTemperature(double temperature) {
    return temperature >
        SimulationConstants.meaningfulStellarTemperatureThreshold;
  }
}
