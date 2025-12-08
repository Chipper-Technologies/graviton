import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

/// A camera mode selection option widget
class CameraModeOption extends StatelessWidget {
  final String title;
  final String description;
  final CinematicCameraTechnique mode;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CameraModeOption({
    super.key,
    required this.title,
    required this.description,
    required this.mode,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTypography.spacingMedium),
      child: Material(
        color: AppColors.transparentColor,
        child: HapticInkWell(
          onTap: onTap,
          borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
          child: Container(
            padding: const EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityMidFade,
                    )
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
              borderRadius: AppTypography.createRadius(
                AppTypography.radiusLarge,
              ),
              border: isSelected
                  ? Border.all(
                      color: AppColors.primaryColor,
                      width: AppTypography.borderThin,
                    )
                  : AppTypography.createBorder(
                      opacity: AppTypography.opacityDisabled,
                      width: AppTypography.borderThin,
                    ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                  size: AppTypography.iconSizeXXLarge,
                ),
                const SizedBox(width: AppTypography.spacingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.largeText.copyWith(
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.uiWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        description,
                        style: AppTypography.mediumText.copyWith(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primaryColor,
                    size: AppTypography.iconSizeLarge,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
