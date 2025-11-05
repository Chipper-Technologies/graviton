import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';

/// An action button for camera controls
class CameraActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const CameraActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: HapticInkWell(
        onTap: onPressed,
        borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppTypography.spacingLarge,
            horizontal: AppTypography.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityBarely,
            ),
            borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
            border: AppTypography.createBorder(
              opacity: AppTypography.opacityDisabled,
              width: AppTypography.borderThin,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isEnabled
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
                  color: isEnabled
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
