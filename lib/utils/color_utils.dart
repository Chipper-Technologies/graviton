import 'package:flutter/material.dart';
import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';

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
    return luminance > 0.5 ? Colors.black : Colors.white;
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
}
