import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/number_utils.dart';

/// A simple tile widget for displaying body information
/// Used in both scenario editor body list and preview screens
class ScenarioBodyTile extends StatelessWidget {
  final Body body;
  final VoidCallback? onTap;
  final bool showActions;

  const ScenarioBodyTile({
    super.key,
    required this.body,
    this.onTap,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      child: Material(
        color: AppColors.transparentColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityBarely,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: Row(
              children: [
                // Body color indicator with icon - matching bodies tab style
                Container(
                  width: AppTypography.spacingXXXLarge,
                  height: AppTypography.spacingXXXLarge,
                  decoration: BoxDecoration(
                    color: body.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _getIconForBodyType(body.bodyType),
                    size: AppTypography.iconSizeMedium,
                    color: AppColors.uiWhite,
                  ),
                ),
                SizedBox(width: AppTypography.spacingLarge),
                // Body name and info - matching bodies tab style
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body.name,
                        style: TextStyle(
                          color: AppColors.uiWhite,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        '${body.bodyType.name} • ${NumberUtils.formatMassInSolarMasses(body.mass)}',
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get the appropriate icon for each body type
  IconData _getIconForBodyType(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return Icons.wb_sunny; // Sun icon for stars
      case BodyType.planet:
        return Icons.public; // Globe icon for planets
      case BodyType.moon:
        return Icons.brightness_3; // Crescent moon icon for moons
      case BodyType.asteroid:
        return Icons.scatter_plot; // Scatter plot icon for asteroids
    }
  }
}
