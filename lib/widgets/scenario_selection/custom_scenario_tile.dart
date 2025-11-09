import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: customColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Icon(Icons.palette, color: customColor, size: 28),
              ),
              const SizedBox(width: 16),
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
                            size: 24,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.customScenarioDescription,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Action buttons
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: customColor.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.customLabel,
                          style: AppTypography.smallText.copyWith(
                            color: customColor.withValues(
                              alpha: AppTypography.opacityMediumHigh,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Edit button
                        GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityMediumHigh,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete button
                        GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: AppColors.celestialRed.withValues(
                                alpha: AppTypography.opacityMediumHigh,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
