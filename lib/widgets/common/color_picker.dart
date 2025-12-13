import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable widget for selecting colors with proper styling and accessibility
class ColorPicker extends StatefulWidget {
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
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late FocusNode _focusNode;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Set initial focus to selected color if available
    _focusedIndex = widget.colors.indexWhere(
      (color) => _colorsAreEqual(widget.selectedColor, color),
    );
    if (_focusedIndex == -1) _focusedIndex = 0;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'Arrow Left':
          setState(() {
            _focusedIndex = (_focusedIndex - 1) % widget.colors.length;
          });
          break;
        case 'Arrow Right':
          setState(() {
            _focusedIndex = (_focusedIndex + 1) % widget.colors.length;
          });
          break;
        case 'Arrow Up':
          setState(() {
            // Move up a row (assuming roughly 4 colors per row)
            _focusedIndex = (_focusedIndex - 4).clamp(
              0,
              widget.colors.length - 1,
            );
          });
          break;
        case 'Arrow Down':
          setState(() {
            // Move down a row (assuming roughly 4 colors per row)
            _focusedIndex = (_focusedIndex + 4).clamp(
              0,
              widget.colors.length - 1,
            );
          });
          break;
        case 'Enter':
        case 'Space':
          if (widget.enabled) {
            HapticFeedback.lightImpact();
            widget.onColorChanged(widget.colors[_focusedIndex]);
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size =
        widget.itemSize ??
        32.0; // Increased to 32px for better visibility and touch

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: Semantics(
        label: AppLocalizations.of(context)?.colorSelector,
        hint: AppLocalizations.of(context)?.selectAColorForTheCelestialBody,
        enabled: widget.enabled,
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
            children: widget.colors.asMap().entries.map((entry) {
              final index = entry.key;
              final color = entry.value;
              final isSelected = _colorsAreEqual(widget.selectedColor, color);
              final isFocused = _focusedIndex == index;

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
                enabled: widget.enabled,
                button: true,
                child: Tooltip(
                  message:
                      AppLocalizations.of(
                        context,
                      )?.colorOptionTooltip(_getColorName(context, color)) ??
                      'Select ${_getColorName(context, color)} color for celestial body',
                  child: Material(
                    color: AppColors.transparentColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(size / 2),
                      onTap: widget.enabled
                          ? () {
                              setState(() {
                                _focusedIndex = index;
                              });
                              _focusNode.requestFocus();
                              HapticFeedback.lightImpact();
                              widget.onColorChanged(color);
                            }
                          : null,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFocused
                                ? AppColors.uiWhite
                                : isSelected
                                ? AppColors.primaryColor
                                : AppColors.uiWhite.withValues(alpha: 0.3),
                            width: isFocused
                                ? 2
                                : isSelected
                                ? 3
                                : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            if (isFocused)
                              BoxShadow(
                                color: AppColors.uiWhite.withValues(alpha: 0.6),
                                blurRadius: 6,
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
                                semanticLabel:
                                    AppLocalizations.of(
                                      context,
                                    )?.currentlySelected ??
                                    'Currently selected',
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
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
    final l10n = AppLocalizations.of(context)!;

    // AppColors celestial bodies
    if (color == AppColors.planetEarth) {
      return l10n.earthBlueColor;
    }
    if (color == AppColors.planetMars) {
      return l10n.marsRedColor;
    }
    if (color == AppColors.planetJupiter) {
      return l10n.jupiterTanColor;
    }
    if (color == AppColors.planetVenus) {
      return l10n.venusYellowColor;
    }
    if (color == AppColors.planetMercury) {
      return l10n.mercuryGrayColor;
    }
    if (color == AppColors.planetUranus) {
      return l10n.uranusCyanColor;
    }
    if (color == AppColors.planetNeptune) {
      return l10n.neptuneBlueColor;
    }
    if (color == AppColors.planetSaturn) {
      return l10n.saturnCreamColor;
    }

    // AppColors UI colors
    if (color == AppColors.uiOrange) {
      return l10n.orangeColor;
    }
    if (color == AppColors.uiRed) {
      return l10n.redColor;
    }
    if (color == AppColors.uiWhite) {
      return l10n.whiteColor;
    }
    if (color == AppColors.uiBlack) {
      return l10n.blackColor;
    }
    if (color == AppColors.uiGreen) {
      return l10n.greenColor;
    }
    if (color == AppColors.uiYellow) {
      return l10n.yellowColor;
    }
    if (color == AppColors.uiCyan) {
      return l10n.cyanColor;
    }

    // Fallback for any other colors
    return l10n.customColor;
  }
}
