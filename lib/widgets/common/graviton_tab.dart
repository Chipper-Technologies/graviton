import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Custom tab widget that follows Graviton design system
class GravitonTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isEnabled;

  const GravitonTab({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = !isEnabled
        ? AppColors.uiWhite.withValues(alpha: AppTypography.opacityMedium)
        : isActive
        ? AppColors.primaryColor
        : null;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.7,
      child: SizedBox(
        height: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  size: AppTypography.iconSizeLarge,
                  color: effectiveColor,
                ),
                // Active indicator dot - always show on active tabs
                if (isActive && isEnabled)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.uiOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Text(label, style: TextStyle(color: effectiveColor)),
          ],
        ),
      ),
    );
  }
}
