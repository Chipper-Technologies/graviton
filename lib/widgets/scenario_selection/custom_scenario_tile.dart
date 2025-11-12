import 'package:flutter/material.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/common/graviton_popup_menu.dart';

/// Widget for displaying custom scenarios with edit/delete actions
///
/// This tile represents a single custom scenario created by the user,
/// providing visual feedback for selection state and action buttons for
/// editing and deleting the scenario.
class CustomScenarioTile extends StatelessWidget {
  /// The name of the custom scenario
  final String scenarioName;

  /// Whether this scenario is currently selected
  final bool isSelected;

  /// Callback when the tile is tapped to select the scenario
  final VoidCallback onTap;

  /// Callback when the edit button is tapped
  final VoidCallback onEdit;

  /// Callback when the delete button is tapped
  final VoidCallback onDelete;

  const CustomScenarioTile({
    super.key,
    required this.scenarioName,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customColor = AppColors.celestialPlumPlanet;

    return Card(
      margin: EdgeInsets.zero,
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? customColor.withValues(alpha: AppTypography.opacityDisabled)
          : null,
      child: HapticInkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Custom icon
              Container(
                width: AppTypography.iconSizeXXXXLarge,
                height: AppTypography.iconSizeXXXXLarge,
                decoration: BoxDecoration(
                  color: customColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusXXLarge + AppTypography.radiusSmall,
                  ), // 24.0
                ),
                child: Icon(
                  Icons.palette,
                  color: customColor,
                  size: AppTypography.iconSizeXXXLarge,
                ),
              ),
              SizedBox(width: AppTypography.spacingLarge),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            scenarioName,
                            style: AppTypography.largeText.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected ? customColor : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: customColor,
                            size: AppTypography.iconSizeXXLarge,
                          ),
                      ],
                    ),
                    SizedBox(height: AppTypography.spacingXSmall),
                    Text(
                      l10n.customScenarioDescription,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        ),
                      ),
                    ),
                    SizedBox(height: AppTypography.spacingSmall),
                    // Action buttons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: AppTypography.iconSizeLarge,
                          color: customColor.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        SizedBox(width: AppTypography.spacingXSmall),
                        Text(
                          l10n.customLabel,
                          style: AppTypography.smallText.copyWith(
                            color: customColor.withValues(
                              alpha: AppTypography.opacityMediumHigh,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              // 3-dot menu (only shown when not selected)
              if (!isSelected) ...[
                SizedBox(width: AppTypography.spacingMedium),
                GravitonPopupMenu(
                  accessibilityLabel: l10n.moreActionsAccessibility,
                  accessibilityHint: l10n.moreActionsHint,
                  analyticsElement: UIElement.customScenariosTab,
                  additionalAnalyticsParams: {'scenario_name': scenarioName},
                  menuItems: [
                    GravitonMenuItemConfig(
                      value: 'edit',
                      labelKey: 'editScenarioButton',
                      hintKey: 'editScenarioHint',
                      icon: Icons.edit_outlined,
                      onTap: onEdit,
                    ),
                    GravitonMenuItemConfig(
                      value: 'delete',
                      labelKey: 'deleteScenarioButton',
                      hintKey: 'deleteScenarioHint',
                      icon: Icons.delete_outline,
                      iconColor: AppColors.accretionRed,
                      borderColor: AppColors.accretionRed.withValues(
                        alpha: AppColors.alphaMediumVisible,
                      ),
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
