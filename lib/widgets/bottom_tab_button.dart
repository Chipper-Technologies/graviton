import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A tab button for the bottom navigation bar with proper theming
class BottomTabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  const BottomTabButton({
    super.key,
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
          splashColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          highlightColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityBarely,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: 80,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTypography.spacingSmall,
            ),
            decoration: BoxDecoration(
              // Downward gradient for active items
              gradient: isActive
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacityVeryFaint,
                        ),
                        AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacityDisabled,
                        ),
                      ],
                    )
                  : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: AppTypography.createRadius(
                AppTypography.radiusLarge,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon (darker than text)
                Icon(
                  icon,
                  color: isEnabled
                      ? AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityMedium,
                        )
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryFaint,
                        ),
                  size: AppTypography.iconSizeLarge,
                ),

                const SizedBox(width: AppTypography.spacingSmall),

                // Label with drop shadow
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTypography.smallText.copyWith(
                      color: isEnabled
                          ? AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacityVeryHigh,
                            )
                          : AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacitySemiTransparent,
                            ),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      letterSpacing: 0.3,
                      // Text drop shadow
                      shadows: [
                        Shadow(
                          color: AppColors.uiBlack.withValues(
                            alpha: AppTypography.opacityMedium,
                          ),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(label),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
