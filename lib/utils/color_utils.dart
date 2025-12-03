import 'package:flutter/material.dart';
import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Utility functions for color operations and celestial body color mapping
class ColorUtils {
  ColorUtils._(); // Private constructor to prevent instantiation

  /// Get the appropriate color for a celestial body based on its name
  /// This matches the exact colors used in CelestialBodyPainter and offscreen indicators
  static Color getBodyColor(Body body) {
    final bodyEnum = CelestialBodyName.fromString(body.name);
    if (bodyEnum != null) {
      switch (bodyEnum) {
        case CelestialBodyName.blackHole:
        case CelestialBodyName.supermassiveBlackHole:
          return AppColors.uiBlack;
        case CelestialBodyName.sun:
          return AppColors.offScreenSun; // Gold
        case CelestialBodyName.mercury:
          return AppColors.offScreenMercury; // Brownish gray
        case CelestialBodyName.venus:
          return AppColors.offScreenVenus; // Yellowish
        case CelestialBodyName.earth:
          return AppColors.offScreenEarth; // Blue
        case CelestialBodyName.mars:
          return AppColors.offScreenMars; // Red
        case CelestialBodyName.jupiter:
          return AppColors.offScreenJupiter; // Tan/beige
        case CelestialBodyName.saturn:
          return AppColors.offScreenSaturn; // Light gold
        case CelestialBodyName.uranus:
          return AppColors.offScreenUranus; // Light blue
        case CelestialBodyName.neptune:
          return AppColors.offScreenNeptune; // Deep blue
        default:
          // Use the body's default color property for other objects
          return body.color;
      }
    }

    // Use the body's default color property for unrecognized objects
    return body.color;
  }

  /// Get a contrasting text color based on background color
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance to determine if we should use light or dark text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppColors.uiBlack : AppColors.uiWhite;
  }

  /// Create a color with adjusted opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity.clamp(0.0, 1.0));
  }

  /// Blend two colors together
  static Color blendColors(Color color1, Color color2, double ratio) {
    final clampedRatio = ratio.clamp(0.0, 1.0);
    return Color.lerp(color1, color2, clampedRatio) ?? color1;
  }

  /// Darken a color by a given factor
  static Color darken(Color color, double factor) {
    final f = 1.0 - factor.clamp(0.0, 1.0);
    return Color.fromARGB(
      (color.a * 255.0).round() & 0xff,
      ((color.r * 255.0).round() * f).round(),
      ((color.g * 255.0).round() * f).round(),
      ((color.b * 255.0).round() * f).round(),
    );
  }

  /// Lighten a color by a given factor
  static Color lighten(Color color, double factor) {
    final f = factor.clamp(0.0, 1.0);
    final r = (color.r * 255.0).round() & 0xff;
    final g = (color.g * 255.0).round() & 0xff;
    final b = (color.b * 255.0).round() & 0xff;
    return Color.fromARGB(
      (color.a * 255.0).round() & 0xff,
      r + ((255 - r) * f).round(),
      g + ((255 - g) * f).round(),
      b + ((255 - b) * f).round(),
    );
  }

  /// Get the icon color for tutorial steps or other indexed elements
  static Color getIconColor(int stepIndex) {
    final colors = [
      AppColors.primaryColor,
      AppColors.uiCyanAccent,
      AppColors.uiOrangeAccent,
      AppColors.uiRed,
      AppColors.basicBlue,
      AppColors.uiGreen,
    ];
    return colors[stepIndex % colors.length];
  }

  /// Parse a hex color string (e.g., '#FF5733') into a Flutter Color
  /// Supports both 6-digit and 8-digit hex formats
  static Color parseHexColor(String hexColor) {
    String hex = hexColor.replaceAll('#', '');

    // Add alpha if not provided (default to opaque)
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    if (hex.length != 8) {
      throw ArgumentError('Invalid hex color format: $hexColor');
    }

    try {
      return Color(int.parse('0x$hex'));
    } catch (e) {
      throw ArgumentError('Invalid hex color format: $hexColor');
    }
  }

  /// Convert a Flutter Color to a hex string (e.g., '#FF5733')
  /// Returns format '#AARRGGBB' including alpha channel
  static String colorToHex(Color color) {
    final alpha = (color.a * 255.0).round().toRadixString(16).padLeft(2, '0');
    final red = (color.r * 255.0).round().toRadixString(16).padLeft(2, '0');
    final green = (color.g * 255.0).round().toRadixString(16).padLeft(2, '0');
    final blue = (color.b * 255.0).round().toRadixString(16).padLeft(2, '0');
    return '#$alpha$red$green$blue'.toUpperCase();
  }

  /// Convert a Flutter Color to a hex string without alpha (e.g., '#5733FF')
  /// Returns format '#RRGGBB' excluding alpha channel
  static String colorToHexRGB(Color color) {
    final red = (color.r * 255.0).round().toRadixString(16).padLeft(2, '0');
    final green = (color.g * 255.0).round().toRadixString(16).padLeft(2, '0');
    final blue = (color.b * 255.0).round().toRadixString(16).padLeft(2, '0');
    return '#$red$green$blue'.toUpperCase();
  }

  /// Creates a color with modified alpha transparency
  /// [alpha] should be between 0.0 (transparent) and 1.0 (opaque)
  static Color withAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha.clamp(0.0, 1.0));
  }

  /// Creates a radial gradient with glow effect for celestial bodies
  /// Used in painters and visual effects
  static RadialGradient createGlowGradient(Color centerColor, Color edgeColor) {
    return RadialGradient(
      colors: [
        centerColor,
        edgeColor.withValues(alpha: AppTypography.opacityMedium),
        edgeColor.withValues(alpha: AppTypography.opacityVeryFaint),
        edgeColor.withValues(alpha: AppTypography.opacityTransparent),
        AppColors.transparentColor,
      ],
      stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
    );
  }

  /// Get color based on habitability status
  /// Supports all habitability status types with physics-accurate color coding
  static Color getHabitabilityColor(HabitabilityStatus status) {
    return Color(status.statusColor);
  }

  /// Get color based on temperature (Kelvin)
  /// Maps temperature ranges to appropriate colors for stellar objects
  static Color getTemperatureColor(double temperatureKelvin) {
    if (temperatureKelvin < 3500) {
      // Red dwarf / cool objects
      return AppColors.uiRed;
    } else if (temperatureKelvin < 5000) {
      // Orange / K-type stars
      return AppColors.uiOrangeAccent;
    } else if (temperatureKelvin < 6000) {
      // Yellow / G-type stars (like our Sun)
      return AppColors.offScreenSun;
    } else if (temperatureKelvin < 7500) {
      // White / F-type stars
      return AppColors.uiWhite;
    } else if (temperatureKelvin < 10000) {
      // Blue-white / A-type stars
      return AppColors.basicBlue;
    } else {
      // Blue / B and O-type stars
      return AppColors.uiCyanAccent;
    }
  }

  /// Get color based on celestial body name
  /// Provides accurate colors for known astronomical objects
  static Color getPlanetColor(String planetName) {
    final normalizedName = planetName.toLowerCase().trim();

    // Handle exact matches for known celestial bodies
    switch (normalizedName) {
      case 'sun':
      case 'sol':
        return AppColors.offScreenSun; // Gold/yellow
      case 'mercury':
        return AppColors.offScreenMercury; // Brownish gray
      case 'venus':
        return AppColors.offScreenVenus; // Yellowish
      case 'earth':
      case 'terra':
        return AppColors.offScreenEarth; // Blue
      case 'mars':
        return AppColors.offScreenMars; // Red
      case 'jupiter':
        return AppColors.offScreenJupiter; // Tan/beige
      case 'saturn':
        return AppColors.offScreenSaturn; // Light gold
      case 'uranus':
        return AppColors.offScreenUranus; // Light blue
      case 'neptune':
        return AppColors.offScreenNeptune; // Deep blue
      case 'moon':
      case 'luna':
        return AppColors.uiTextGrey; // Gray for moon
      case 'pulsar':
      case 'neutron star':
        return AppColors.uiCyanAccent; // Cyan for pulsar
      case 'black hole':
        return AppColors.offScreenBlackHole; // Black
      default:
        // For asteroid belts, custom objects, etc.
        if (normalizedName.contains('asteroid')) {
          return AppColors.offScreenMercury; // Brown/gray for asteroids
        } else if (normalizedName.contains('comet')) {
          return AppColors.accretionWhite; // Icy blue-white for comets
        } else if (normalizedName.contains('dwarf')) {
          return AppColors.uiTextGrey; // Dim gray for dwarf planets
        }
        // Default color for unknown objects
        return AppColors.primaryColor;
    }
  }
}
