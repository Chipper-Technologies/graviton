import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

/// A reusable action option widget with consistent styling
/// Used across dialogs for actionable items with arrow indicators
class ActionOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const ActionOption({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingMedium),
      child: Material(
        color: AppColors.transparentColor,
        child: HapticInkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: isPrimary
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityBarely,
                    )
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: Border.all(
                color: isPrimary
                    ? AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityMedium,
                      )
                    : AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityDisabled,
                      ),
                width: AppTypography.borderThin,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppTypography.spacingMedium),
                  decoration: BoxDecoration(
                    color:
                        (isPrimary ? AppColors.primaryColor : AppColors.uiWhite)
                            .withValues(alpha: AppTypography.opacityFaint),
                    borderRadius: BorderRadius.circular(
                      AppTypography.radiusMedium,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary
                        ? AppColors.primaryColor
                        : AppColors.uiWhite,
                    size: AppTypography.iconSizeLarge,
                  ),
                ),
                SizedBox(width: AppTypography.spacingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.uiWhite,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        description,
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
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
                  size: AppTypography.iconSizeSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
