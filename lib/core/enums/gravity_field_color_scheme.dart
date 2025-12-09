import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';

/// Represents different color schemes for gravity field visualization
enum GravityFieldColorScheme {
  /// Classic blue/yellow scheme (stars yellow, others blue)
  classic,

  /// Rainbow spectrum based on field strength
  spectral,

  /// Grayscale monochrome scheme
  monochrome,

  /// Bright neon colors for dramatic effect
  neon,

  /// Green-based color palette
  emerald;

  const GravityFieldColorScheme();
}

/// Extension methods for GravityFieldColorScheme
extension GravityFieldColorSchemeExtension on GravityFieldColorScheme {
  /// Get localization key for this color scheme
  String get localizationKey {
    switch (this) {
      case GravityFieldColorScheme.classic:
        return 'gravityColorSchemeClassic';
      case GravityFieldColorScheme.spectral:
        return 'gravityColorSchemeSpectral';
      case GravityFieldColorScheme.monochrome:
        return 'gravityColorSchemeMonochrome';
      case GravityFieldColorScheme.neon:
        return 'gravityColorSchemeNeon';
      case GravityFieldColorScheme.emerald:
        return 'gravityColorSchemeEmerald';
    }
  }

  /// Get localized display name
  String getLocalizedDisplayName(AppLocalizations l10n) {
    switch (this) {
      case GravityFieldColorScheme.classic:
        return l10n.gravityColorSchemeClassic;
      case GravityFieldColorScheme.spectral:
        return l10n.gravityColorSchemeSpectral;
      case GravityFieldColorScheme.monochrome:
        return l10n.gravityColorSchemeMonochrome;
      case GravityFieldColorScheme.neon:
        return l10n.gravityColorSchemeNeon;
      case GravityFieldColorScheme.emerald:
        return l10n.gravityColorSchemeEmerald;
    }
  }

  /// Get primary color for star-type bodies in this scheme
  Color get starPrimaryColor {
    switch (this) {
      case GravityFieldColorScheme.classic:
        return AppColors.gravityFieldClassicStarPrimary;
      case GravityFieldColorScheme.spectral:
        return AppColors.gravityFieldSpectralRed;
      case GravityFieldColorScheme.monochrome:
        return AppColors.gravityFieldMonochromeWhite;
      case GravityFieldColorScheme.neon:
        return AppColors.gravityFieldNeonPink;
      case GravityFieldColorScheme.emerald:
        return AppColors.gravityFieldEmeraldBright;
    }
  }

  /// Get primary color for non-star bodies in this scheme
  Color get bodyPrimaryColor {
    switch (this) {
      case GravityFieldColorScheme.classic:
        return AppColors.gravityFieldClassicBodyPrimary;
      case GravityFieldColorScheme.spectral:
        return AppColors.gravityFieldSpectralBlue;
      case GravityFieldColorScheme.monochrome:
        return AppColors.gravityFieldMonochromeLightGray;
      case GravityFieldColorScheme.neon:
        // Return cyan as it's distinctly different from the pink star color
        return AppColors.gravityFieldNeonCyan;
      case GravityFieldColorScheme.emerald:
        return AppColors.gravityFieldEmeraldForest;
    }
  }

  /// Get secondary color for gradient effects in this scheme
  Color get secondaryColor {
    switch (this) {
      case GravityFieldColorScheme.classic:
        return AppColors.gravityFieldClassicSecondary;
      case GravityFieldColorScheme.spectral:
        return AppColors.gravityFieldSpectralGreen;
      case GravityFieldColorScheme.monochrome:
        return AppColors.gravityFieldMonochromeDarkGray;
      case GravityFieldColorScheme.neon:
        // Return a consistent neon color for secondary
        final neonColors = AppColors.gravityFieldNeonColors;
        // Use a fixed index for consistency (second color in the neon palette)
        return neonColors.length > 1 ? neonColors[1] : neonColors[0];
      case GravityFieldColorScheme.emerald:
        return AppColors.gravityFieldEmeraldDark;
    }
  }

  /// Get accent color for field strength indicators
  Color get accentColor {
    switch (this) {
      case GravityFieldColorScheme.classic:
        return AppColors.gravityFieldClassicAccent;
      case GravityFieldColorScheme.spectral:
        return AppColors.gravityFieldSpectralMagenta;
      case GravityFieldColorScheme.monochrome:
        return AppColors.gravityFieldMonochromeMediumGray;
      case GravityFieldColorScheme.neon:
        // Return another random neon color for accent
        final random = math.Random();
        final neonColors = AppColors.gravityFieldNeonColors;
        return neonColors[random.nextInt(neonColors.length)];
      case GravityFieldColorScheme.emerald:
        return AppColors.gravityFieldEmeraldLight;
    }
  }

  /// Get color for equipotential surface at given field strength ratio (0.0 to 1.0)
  /// For neon scheme, bodyHashCode can be provided to ensure consistent random color per body
  Color getEquipotentialColor(double fieldStrengthRatio, [int? bodyHashCode]) {
    final ratio = fieldStrengthRatio.clamp(0.0, 1.0);

    switch (this) {
      case GravityFieldColorScheme.classic:
        // Blue to yellow gradient using AppColors
        return Color.lerp(
          AppColors.fieldStrengthWeak,
          AppColors.fieldStrengthVeryStrong,
          ratio,
        )!;

      case GravityFieldColorScheme.spectral:
        // Full spectrum using AppColors field strength indicators
        if (ratio < 0.33) {
          return Color.lerp(
            AppColors.fieldStrengthWeak,
            AppColors.fieldStrengthStrong,
            ratio * 3,
          )!;
        } else if (ratio < 0.67) {
          return Color.lerp(
            AppColors.fieldStrengthStrong,
            AppColors.fieldStrengthVeryStrong,
            (ratio - 0.33) * 3,
          )!;
        } else {
          return Color.lerp(
            AppColors.fieldStrengthVeryStrong,
            AppColors.fieldStrengthExtreme,
            (ratio - 0.67) * 3,
          )!;
        }

      case GravityFieldColorScheme.monochrome:
        // Black to white gradient using AppColors
        return Color.lerp(
          AppColors.gravityFieldMonochromeBlack,
          AppColors.gravityFieldMonochromeWhite,
          ratio,
        )!;

      case GravityFieldColorScheme.neon:
        // Use consistent random color per body/well
        final neonColors = AppColors.gravityFieldNeonColors;
        Color selectedNeonColor;

        if (bodyHashCode != null) {
          // Use body hash to get consistent random color for this specific body
          final random = math.Random(bodyHashCode);
          selectedNeonColor = neonColors[random.nextInt(neonColors.length)];
        } else {
          // Fallback to cyan if no body identifier provided
          selectedNeonColor = AppColors.gravityFieldNeonCyan;
        }

        // Gradient from dark to selected neon color
        return Color.lerp(
          AppColors.gravityFieldNeonDark,
          selectedNeonColor,
          ratio,
        )!;

      case GravityFieldColorScheme.emerald:
        // Dark green to bright emerald using AppColors
        return Color.lerp(
          AppColors.gravityFieldEmeraldDeep,
          AppColors.gravityFieldEmeraldVibrant,
          ratio,
        )!;
    }
  }

  /// Find color scheme from string identifier
  static GravityFieldColorScheme fromString(String value) {
    return GravityFieldColorScheme.values.firstWhere(
      (scheme) => scheme.name == value,
      orElse: () => GravityFieldColorScheme.classic,
    );
  }
}
