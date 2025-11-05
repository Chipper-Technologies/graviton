import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';
import 'package:graviton/widgets/common/haptic_switch.dart';

/// A reusable toggle option widget with consistent styling
/// Used across bottom sheets and dialogs for toggle switches
class ToggleOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const ToggleOption({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isEnabled,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : AppTypography.spacingMedium),
      child: Material(
        color: Colors.transparent,
        child: Semantics(
          label: title,
          hint: description,
          value: isEnabled ? 'enabled' : 'disabled',
          toggled: isEnabled,
          button: true,
          onTap: () => onChanged(!isEnabled),
          child: HapticInkWell(
            onTap: () => onChanged(!isEnabled),
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            child: Container(
              padding: EdgeInsets.all(AppTypography.spacingLarge),
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityMidFade,
                      )
                    : AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityBarely,
                      ),
                borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
                border: isEnabled
                    ? Border.all(
                        color: AppColors.primaryColor,
                        width: AppTypography.borderThin,
                      )
                    : Border.all(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityDisabled,
                        ),
                        width: AppTypography.borderThin,
                      ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isEnabled
                        ? AppColors.primaryColor
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                    size: AppTypography.iconSizeXXLarge,
                  ),
                  SizedBox(width: AppTypography.spacingLarge),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isEnabled
                                ? AppColors.primaryColor
                                : AppColors.uiWhite,
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
                  HapticSwitch(
                    value: isEnabled,
                    onChanged: onChanged,
                    activeColor: AppColors.primaryColor,
                    inactiveThumbColor: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityMediumHigh,
                    ),
                    inactiveTrackColor: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityFaint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
