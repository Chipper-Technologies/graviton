import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable header for bottom sheets
class BottomSheetHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const BottomSheetHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTypography.spacingXLarge,
        vertical: AppTypography.spacingSmall,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: AppTypography.iconSizeXXLarge,
          ),
          const SizedBox(width: AppTypography.spacingMedium),
          Text(
            title,
            style: AppTypography.titleText.copyWith(
              color: AppColors.uiWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
