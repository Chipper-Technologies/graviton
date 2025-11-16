import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable widget for selecting body types with proper styling and accessibility
class BodyTypePicker extends StatelessWidget {
  final BodyType selectedType;
  final ValueChanged<BodyType> onTypeChanged;
  final bool enabled;

  const BodyTypePicker({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bodyTypes = BodyType.values;

    return Semantics(
      label:
          AppLocalizations.of(context)?.bodyTypeSelector ??
          'Body type selector',
      hint:
          AppLocalizations.of(context)?.selectTheTypeOfCelestialBody ??
          'Select the type of celestial body',
      enabled: enabled,
      child: Container(
        padding: EdgeInsets.all(AppTypography.spacingSmall),
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
        child: Row(
          children: bodyTypes.map((bodyType) {
            final isSelected = selectedType == bodyType;
            return Expanded(
              child: Tooltip(
                message: _getBodyTypeTooltip(bodyType, context),
                padding: EdgeInsets.all(AppTypography.spacingMedium),
                margin: EdgeInsets.symmetric(
                  horizontal: AppTypography.spacingLarge,
                ),
                decoration: BoxDecoration(
                  color: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityNearlyOpaque,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.uiBlack.withValues(
                        alpha: AppTypography.opacityMedium,
                      ),
                      blurRadius: AppTypography.spacingSmall,
                      offset: Offset(0, AppTypography.spacingXSmall),
                    ),
                  ],
                ),
                textStyle: TextStyle(
                  color: AppColors.uiWhite,
                  fontSize: AppTypography.fontSizeSmall,
                ),
                preferBelow: false,
                child: Semantics(
                  label:
                      AppLocalizations.of(
                        context,
                      )?.bodyTypeTemplate(bodyType.name, bodyType) ??
                      '${bodyType.name} body type',
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
                            onTypeChanged(bodyType);
                          }
                        : null,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: AppTypography.spacingXSmall,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTypography.spacingSmall,
                        vertical: AppTypography.spacingMedium,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.transparentColor,
                        borderRadius: BorderRadius.circular(
                          AppTypography.radiusMedium,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: AppTypography.opacityFaint,
                                  ),
                                  blurRadius: AppTypography.spacingXSmall,
                                  spreadRadius: AppTypography.borderThin,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getBodyTypeIcon(bodyType),
                            color: isSelected
                                ? AppColors.uiBlack
                                : (enabled
                                      ? AppColors.uiWhite.withValues(
                                          alpha: AppTypography.opacityHigh,
                                        )
                                      : AppColors.uiWhite.withValues(
                                          alpha: AppTypography.opacityDisabled,
                                        )),
                            size: AppTypography.iconSizeLarge,
                          ),
                          SizedBox(height: AppTypography.spacingXSmall),
                          Text(
                            _getBodyTypeDisplayName(bodyType, context),
                            style: AppTypography.smallText.copyWith(
                              color: isSelected
                                  ? AppColors.uiBlack
                                  : (enabled
                                        ? AppColors.uiWhite.withValues(
                                            alpha: AppTypography.opacityHigh,
                                          )
                                        : AppColors.uiWhite.withValues(
                                            alpha:
                                                AppTypography.opacityDisabled,
                                          )),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: AppTypography.fontSizeXSmall,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Get the appropriate icon for each body type
  IconData _getBodyTypeIcon(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return Icons.wb_sunny;
      case BodyType.planet:
        return Icons.public;
      case BodyType.moon:
        return Icons.brightness_2;
      case BodyType.asteroid:
        return Icons.grain;
      case BodyType.blackHole:
        return Icons.donut_large;
      case BodyType.neutronStar:
        return Icons.flash_on;
    }
  }

  /// Get the tooltip text for each body type
  String _getBodyTypeTooltip(BodyType bodyType, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (bodyType) {
      case BodyType.star:
        return l10n.bodyTypeTooltipStar;
      case BodyType.planet:
        return l10n.bodyTypeTooltipPlanet;
      case BodyType.moon:
        return l10n.bodyTypeTooltipMoon;
      case BodyType.asteroid:
        return l10n.bodyTypeTooltipAsteroid;
      case BodyType.blackHole:
        return l10n.bodyTypeTooltipBlackHole;
      case BodyType.neutronStar:
        return l10n.bodyTypeTooltipNeutronStar;
    }
  }

  /// Get the display name for each body type
  String _getBodyTypeDisplayName(BodyType bodyType, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (bodyType) {
      case BodyType.star:
        return l10n.bodyTypeStar.toUpperCase();
      case BodyType.planet:
        return l10n.bodyTypePlanet.toUpperCase();
      case BodyType.moon:
        return l10n.bodyTypeMoon.toUpperCase();
      case BodyType.asteroid:
        return l10n.bodyTypeAsteroid.toUpperCase();
      case BodyType.blackHole:
        return l10n.bodyTypeBlackHole.toUpperCase();
      case BodyType.neutronStar:
        return l10n.bodyTypeNeutronStar.toUpperCase();
    }
  }
}
