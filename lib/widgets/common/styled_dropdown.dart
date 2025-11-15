import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A beautifully styled dropdown with consistent theming and container design
///
/// Features:
/// - Primary purple border with enhanced visual prominence
/// - Icon integration on the left side
/// - Generous padding for luxurious feel
/// - Consistent typography and color scheme
/// - Custom dropdown styling with proper dark theme support
class StyledDropdown<T> extends StatelessWidget {
  final T value;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final String? hintText;

  const StyledDropdown({
    super.key,
    required this.value,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.enabled = true,
    this.errorText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: TextStyle(
              color: AppColors.uiWhite,
              fontSize: AppTypography.fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppTypography.spacingSmall),
        ],
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityBarely,
                  )
                : AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityFaint,
                  ),
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            border: Border.all(
              color: errorText != null
                  ? AppColors.uiRed
                  : enabled
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityHigh,
                    )
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityDisabled,
                    ),
              width: AppTypography.borderMedium,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppTypography.spacingXLarge,
                  right: AppTypography.spacingLarge,
                ),
                child: Icon(
                  icon,
                  color: errorText != null
                      ? AppColors.uiRed
                      : enabled
                      ? AppColors.primaryColor
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityDisabled,
                        ),
                  size: AppTypography.iconSizeXXLarge,
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<T>(
                  initialValue: value,
                  onChanged: enabled ? onChanged : null,
                  items: items,
                  dropdownColor: AppColors.uiBlack,
                  style: TextStyle(
                    color: enabled
                        ? AppColors.uiWhite
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityDisabled,
                          ),
                    fontSize: AppTypography.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityHigh,
                      ),
                      fontSize: AppTypography.fontSizeLarge,
                      fontWeight: FontWeight.normal,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppTypography.spacingXLarge,
                      horizontal: AppTypography.spacingLarge,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: errorText != null
                        ? AppColors.uiRed
                        : enabled
                        ? AppColors.primaryColor
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityDisabled,
                          ),
                  ),
                ),
              ),
              SizedBox(width: AppTypography.spacingLarge),
            ],
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: AppTypography.spacingSmall),
          Padding(
            padding: EdgeInsets.only(left: AppTypography.spacingMedium),
            child: Text(
              errorText!,
              style: TextStyle(
                color: AppColors.uiRed,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
