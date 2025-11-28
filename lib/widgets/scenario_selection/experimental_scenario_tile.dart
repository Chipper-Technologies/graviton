import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/experimental_scenario_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../haptics/haptic_ink_well.dart';

/// Widget for displaying experimental physics scenarios in a grid
///
/// Each tile represents a pre-configured physics experiment that demonstrates
/// interesting gravitational phenomena and concepts.
class ExperimentalScenarioTile extends StatelessWidget {
  /// The experimental scenario configuration
  final ExperimentalScenarioConfig experiment;

  /// Whether this experiment is currently selected
  final bool isSelected;

  /// Callback when the tile is tapped
  final VoidCallback onTap;

  const ExperimentalScenarioTile({
    super.key,
    required this.experiment,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0, // Always use the higher elevation (activated appearance)
      child: HapticInkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Container(
          padding: EdgeInsets.all(AppTypography.spacingMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            // Always show the border (activated appearance)
            border: Border.all(color: experiment.color, width: 2.0),
            // Always show the gradient (activated appearance)
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                experiment.color.withValues(alpha: AppTypography.opacityFaint),
                experiment.color.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and difficulty indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppTypography.spacingSmall),
                        decoration: BoxDecoration(
                          color: experiment.color.withValues(
                            alpha: AppTypography.opacityFaint,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppTypography.radiusSmall,
                          ),
                        ),
                        child: Icon(
                          experiment.icon,
                          color: experiment.color,
                          size: AppTypography.iconSizeXXLarge,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTypography.spacingSmall,
                          vertical: AppTypography.spacingXSmall,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                            localizations,
                          ).withValues(alpha: AppTypography.opacityFaint),
                          borderRadius: BorderRadius.circular(
                            AppTypography.radiusSmall,
                          ),
                        ),
                        child: Text(
                          experiment.difficulty(localizations).toUpperCase(),
                          style: TextStyle(
                            fontSize: AppTypography.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: _getDifficultyColor(localizations),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppTypography.spacingMedium),

                  // Title
                  Text(
                    experiment.name(localizations),
                    style: TextStyle(
                      fontSize: AppTypography.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.uiWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: AppTypography.spacingXSmall),

                  // Description
                  Text(
                    experiment.description(localizations),
                    style: TextStyle(
                      fontSize: AppTypography.fontSizeSmall,
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityHigh,
                      ),
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              // Duration and tags
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: AppTypography.iconSizeSmall,
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityMedium,
                        ),
                      ),
                      SizedBox(width: AppTypography.spacingXSmall),
                      Text(
                        experiment.duration(localizations),
                        style: TextStyle(
                          fontSize: AppTypography.fontSizeSmall,
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (experiment.tags.isNotEmpty) ...[
                    SizedBox(height: AppTypography.spacingXSmall),
                    Wrap(
                      spacing: AppTypography.spacingXSmall,
                      children: experiment.tags.take(2).map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTypography.spacingSmall,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundBlack.withValues(
                              alpha: AppTypography.opacityHigh,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTypography.radiusSmall,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeSmall - 1,
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityMedium,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get color based on difficulty level
  Color _getDifficultyColor(AppLocalizations localizations) {
    switch (experiment.difficulty(localizations).toLowerCase()) {
      case 'beginner':
        return AppColors.stellarGType; // Yellow like our Sun
      case 'intermediate':
        return AppColors.stellarFType; // Yellow-white
      case 'advanced':
        return AppColors.stellarOType; // Blue giants
      default:
        return AppColors.uiWhite;
    }
  }
}
