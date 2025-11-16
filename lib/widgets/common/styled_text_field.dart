import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A beautifully styled text field with consistent theming and container design
///
/// Features:
/// - Primary purple border with enhanced visual prominence
/// - Icon integration on the left side
/// - Generous padding for luxurious feel
/// - Consistent typography and color scheme
/// - Borderless input field within styled container
class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final ValueChanged<String> onChanged;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final String? errorText;

  const StyledTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.onChanged,
    this.labelText,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.errorText,
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
                child: TextField(
                  controller: controller,
                  onChanged: enabled ? onChanged : null,
                  enabled: enabled,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  minLines: minLines,
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
