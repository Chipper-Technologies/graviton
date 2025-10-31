import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized typography, spacing, and dimension constants for Graviton.
///
/// This class provides consistent styling values across the entire application,
/// including font sizes, opacity levels, spacing, and commonly used dimensions.
class AppTypography {
  // =============================================================================
  // FONT SIZES
  // =============================================================================

  /// Standard font sizes used throughout the app
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeader = 28.0;

  // =============================================================================
  // OPACITY VALUES
  // =============================================================================

  /// UI opacity levels for common interface elements
  static const double opacityDisabled = 0.1;
  static const double opacityVeryFaint = 0.2;
  static const double opacityFaint = 0.3;
  static const double opacitySemiTransparent = 0.4;
  static const double opacityMedium = 0.5;
  static const double opacityMediumHigh = 0.6;
  static const double opacityHigh = 0.7;
  static const double opacityVeryHigh = 0.8;
  static const double opacityNearlyOpaque = 0.9;
  static const double opacityFull = 1.0;

  /// Additional specialized opacity values for visual effects
  static const double opacityMidFade = 0.15; // Between disabled and very faint
  static const double opacityLowMedium = 0.25; // Between very faint and faint
  static const double opacityTransparent = 0.0; // Fully transparent

  // =============================================================================
  // ICON SIZES
  // =============================================================================

  /// Standard icon sizes
  static const double iconSizeSmall = 14.0;
  static const double iconSizeMedium = 16.0;
  static const double iconSizeLarge = 18.0;
  static const double iconSizeXLarge = 20.0;
  static const double iconSizeXXLarge = 24.0;

  // =============================================================================
  // SPACING & DIMENSIONS
  // =============================================================================

  /// Standard spacing values
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingXXLarge = 24.0;
  static const double spacingXXXLarge = 32.0;

  /// Border radius values
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusXXLarge = 20.0;
  static const double radiusXXXLarge = 24.0;
  static const double radiusRound = 25.0;

  /// Border widths
  static const double borderThin = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;

  /// UI component dimensions
  /// Height for dropdown items, specifically used for cinematic camera technique
  /// selection dropdowns to ensure consistent sizing and proper text display
  static const double dropdownItemHeight = 44.0;

  // =============================================================================
  // TEXT STYLES
  // =============================================================================

  /// Common text styles using centralized values
  static const TextStyle smallText = TextStyle(fontSize: fontSizeSmall);

  static const TextStyle mediumText = TextStyle(fontSize: fontSizeMedium);

  static const TextStyle largeText = TextStyle(fontSize: fontSizeLarge);

  static const TextStyle titleText = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerText = TextStyle(
    fontSize: fontSizeHeader,
    fontWeight: FontWeight.bold,
  );

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Create a TextStyle with specified color and opacity
  static TextStyle textWithOpacity(
    Color color,
    double opacity, {
    double? fontSize,
  }) {
    return TextStyle(
      color: color.withValues(alpha: opacity),
      fontSize: fontSize ?? fontSizeSmall,
    );
  }

  /// Create consistent shadow effects
  static List<Shadow> createTextShadow({
    Color? color,
    double opacity = opacityVeryHigh,
    double blurRadius = 2.0,
    Offset offset = const Offset(1, 1),
  }) {
    return [
      Shadow(
        offset: offset,
        blurRadius: blurRadius,
        color: (color ?? AppColors.uiBlack).withValues(alpha: opacity),
      ),
    ];
  }

  /// Create consistent border with opacity
  static Border createBorder({
    Color? color,
    double opacity = opacityVeryFaint,
    double width = borderThin,
  }) {
    return Border.all(
      color: (color ?? AppColors.uiWhite).withValues(alpha: opacity),
      width: width,
    );
  }

  /// Create consistent border radius
  static BorderRadius createRadius(double radius) {
    return BorderRadius.circular(radius);
  }
}
