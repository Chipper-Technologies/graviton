import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

/// An action button for camera controls
class CameraActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isActive;

  const CameraActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Material(
      color: AppColors.transparentColor,
      child: HapticInkWell(
        onTap: onPressed,
        borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppTypography.spacingLarge,
            horizontal: AppTypography.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityMidFade,
                  )
                : AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityBarely,
                  ),
            borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
            border: isActive
                ? Border.all(
                    color: AppColors.primaryColor,
                    width: AppTypography.borderThin,
                  )
                : AppTypography.createBorder(
                    opacity: AppTypography.opacityDisabled,
                    width: AppTypography.borderThin,
                  ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive
                    ? AppColors.primaryColor
                    : isEnabled
                    ? AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityVeryHigh,
                      )
                    : AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                size: AppTypography.iconSizeXXLarge,
              ),
              const SizedBox(height: AppTypography.spacingSmall),
              Text(
                label,
                style: AppTypography.smallText.copyWith(
                  color: isActive
                      ? AppColors.primaryColor
                      : isEnabled
                      ? AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        )
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityFaint,
                        ),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
