import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable widget for selecting colors with proper styling and accessibility
class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> colors;
  final bool enabled;
  final double? itemSize;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    this.colors = _defaultColors,
    this.enabled = true,
    this.itemSize,
  });

  /// Default color palette for celestial bodies using AppColors
  static const List<Color> _defaultColors = [
    AppColors.planetEarth, // Earth blue
    AppColors.planetMars, // Mars red
    AppColors.planetJupiter, // Jupiter tan
    AppColors.planetVenus, // Venus yellow
    AppColors.planetMercury, // Mercury gray-brown
    AppColors.planetUranus, // Uranus cyan
    AppColors.planetNeptune, // Neptune blue
    AppColors.planetSaturn, // Saturn cream
    AppColors.uiOrange, // Orange
    AppColors.uiRed, // Red
    AppColors.uiWhite, // White
    AppColors.uiBlack, // Black
  ];

  @override
  Widget build(BuildContext context) {
    final size =
        itemSize ?? 32.0; // Increased to 32px for better visibility and touch

    return Semantics(
      label: AppLocalizations.of(context)?.colorSelector ?? 'Color selector',
      hint:
          AppLocalizations.of(context)?.selectAColorForTheCelestialBody ??
          'Select a color for the celestial body',
      enabled: enabled,
      child: Container(
        width: double.infinity, // Force container to fill available width
        padding: EdgeInsets.all(AppTypography.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityBarely,
          ),
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          border: Border.all(
            color: AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityHigh,
            ),
            width: AppTypography.borderMedium,
          ),
        ),
        child: Wrap(
          spacing: AppTypography
              .spacingMedium, // Increased spacing for larger circles
          runSpacing: AppTypography.spacingMedium,
          alignment: WrapAlignment
              .start, // Ensure circles align to start and fill width
          children: colors.map((color) {
            final isSelected = _colorsAreEqual(selectedColor, color);

            return Semantics(
              label:
                  AppLocalizations.of(context)?.colorOptionTemplate(
                    _getColorName(context, color),
                    color,
                  ) ??
                  'Color option ${_getColorName(context, color)}',
              hint: isSelected
                  ? (AppLocalizations.of(context)?.currentlySelected ??
                        'Currently selected')
                  : (AppLocalizations.of(context)?.tapToSelect ??
                        'Tap to select'),
              selected: isSelected,
              enabled: enabled,
              button: true,
              child: GestureDetector(
                onTap: enabled
                    ? () {
                        HapticFeedback.lightImpact();
                        onColorChanged(color);
                      }
                    : null,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.uiWhite.withValues(alpha: 0.3),
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      // Add shadow for better visibility against background
                      BoxShadow(
                        color: AppColors.uiBlack.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: _getContrastingColor(color),
                          size: size * 0.4,
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Compare two colors for equality
  bool _colorsAreEqual(Color color1, Color color2) {
    return color1 == color2;
  }

  /// Get a contrasting color for the check icon
  Color _getContrastingColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppColors.uiBlack : AppColors.uiWhite;
  }

  /// Get a human-readable name for common colors
  String _getColorName(BuildContext context, Color color) {
    final l10n = AppLocalizations.of(context);

    // AppColors celestial bodies
    if (color == AppColors.planetEarth) {
      return l10n?.earthBlueColor ?? 'earth blue';
    }
    if (color == AppColors.planetMars) {
      return l10n?.marsRedColor ?? 'mars red';
    }
    if (color == AppColors.planetJupiter) {
      return l10n?.jupiterTanColor ?? 'jupiter tan';
    }
    if (color == AppColors.planetVenus) {
      return l10n?.venusYellowColor ?? 'venus yellow';
    }
    if (color == AppColors.planetMercury) {
      return l10n?.mercuryGrayColor ?? 'mercury gray';
    }
    if (color == AppColors.planetUranus) {
      return l10n?.uranusCyanColor ?? 'uranus cyan';
    }
    if (color == AppColors.planetNeptune) {
      return l10n?.neptuneBlueColor ?? 'neptune blue';
    }
    if (color == AppColors.planetSaturn) {
      return l10n?.saturnCreamColor ?? 'saturn cream';
    }

    // AppColors UI colors
    if (color == AppColors.uiOrange) {
      return l10n?.orangeColor ?? 'orange';
    }
    if (color == AppColors.uiRed) {
      return l10n?.redColor ?? 'red';
    }
    if (color == AppColors.uiWhite) {
      return l10n?.whiteColor ?? 'white';
    }
    if (color == AppColors.uiBlack) {
      return l10n?.blackColor ?? 'black';
    }
    if (color == AppColors.uiGreen) {
      return l10n?.greenColor ?? 'green';
    }
    if (color == AppColors.uiYellow) {
      return l10n?.yellowColor ?? 'yellow';
    }
    if (color == AppColors.uiCyan) {
      return l10n?.cyanColor ?? 'cyan';
    }

    // Fallback for any other colors
    return l10n?.customColor ?? 'custom color';
  }
}
