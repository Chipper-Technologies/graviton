import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable circular button widget with haptic feedback and consistent styling
///
/// This widget provides a standardized circular button implementation with:
/// - Automatic haptic feedback on tap
/// - Customizable colors for icon, background, and border
/// - Semantic accessibility support
/// - Consistent sizing and visual styling
/// - Optional tooltip support
class HapticCircularButton extends StatelessWidget {
  /// The icon to display in the button
  final IconData icon;

  /// Callback function when the button is tapped
  final VoidCallback onTap;

  /// The color of the icon (defaults to white with high opacity)
  final Color? iconColor;

  /// The background color of the button (defaults to white with disabled opacity)
  final Color? backgroundColor;

  /// The border color of the button (defaults to white with faint opacity)
  final Color? borderColor;

  /// The size of the button (defaults to AppTypography.spacingXXXLarge)
  final double? size;

  /// The size of the icon (defaults to AppTypography.iconSizeMedium)
  final double? iconSize;

  /// Accessibility label for screen readers
  final String? semanticsLabel;

  /// Accessibility hint for screen readers
  final String? semanticsHint;

  /// Optional tooltip text
  final String? tooltip;

  /// Type of haptic feedback to provide (defaults to light impact)
  final HapticFeedbackType hapticFeedbackType;

  const HapticCircularButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.size,
    this.iconSize,
    this.semanticsLabel,
    this.semanticsHint,
    this.tooltip,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
  });

  /// Factory constructor for edit buttons with preset styling
  factory HapticCircularButton.edit({
    required VoidCallback onTap,
    String? semanticsLabel,
    String? semanticsHint,
    String? tooltip,
  }) {
    return HapticCircularButton(
      icon: Icons.edit,
      onTap: onTap,
      iconColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityVeryHigh,
      ),
      backgroundColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityDisabled,
      ),
      borderColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityFaint,
      ),
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for delete buttons with preset styling
  factory HapticCircularButton.delete({
    required VoidCallback onTap,
    String? semanticsLabel,
    String? semanticsHint,
    String? tooltip,
  }) {
    return HapticCircularButton(
      icon: Icons.delete_outline,
      onTap: onTap,
      iconColor: AppColors.uiRed.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      backgroundColor: AppColors.uiRed.withValues(
        alpha: AppTypography.opacityDisabled,
      ),
      borderColor: AppColors.uiRed.withValues(
        alpha: AppTypography.opacityFaint,
      ),
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for duplicate/copy buttons with preset styling
  factory HapticCircularButton.duplicate({
    required VoidCallback onTap,
    String? semanticsLabel,
    String? semanticsHint,
    String? tooltip,
  }) {
    return HapticCircularButton(
      icon: Icons.content_copy,
      onTap: onTap,
      iconColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityVeryHigh,
      ),
      backgroundColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityDisabled,
      ),
      borderColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityFaint,
      ),
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for play buttons with preset styling (primary style)
  factory HapticCircularButton.play({
    required VoidCallback onTap,
    String? semanticsLabel,
    String? semanticsHint,
    String? tooltip,
  }) {
    return HapticCircularButton(
      icon: Icons.play_arrow,
      onTap: onTap,
      size: 36,
      iconColor: AppColors.uiWhite,
      backgroundColor: AppColors.primaryColor.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      borderColor: null, // No border for primary buttons
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for pause buttons with preset styling (primary style)
  factory HapticCircularButton.pause({
    required VoidCallback onTap,
    String? semanticsLabel,
    String? semanticsHint,
    String? tooltip,
  }) {
    return HapticCircularButton(
      icon: Icons.pause,
      onTap: onTap,
      size: 36,
      iconColor: AppColors.uiWhite,
      backgroundColor: AppColors.primaryColor.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      borderColor: null, // No border for primary buttons
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for reset buttons with preset styling (dark style)
  factory HapticCircularButton.reset({
    required VoidCallback onTap,
    String? semanticsLabel,
    String? semanticsHint,
    String? tooltip,
  }) {
    return HapticCircularButton(
      icon: Icons.refresh,
      onTap: onTap,
      size: 36,
      iconColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      backgroundColor: AppColors.uiBlack.withValues(
        alpha: AppTypography.opacityHigh,
      ),
      borderColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityFaint,
      ),
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      tooltip: tooltip,
      hapticFeedbackType: HapticFeedbackType.mediumImpact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? AppTypography.spacingXXXLarge;
    final buttonIconSize = iconSize ?? AppTypography.iconSizeMedium;

    final button = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Provide haptic feedback
          switch (hapticFeedbackType) {
            case HapticFeedbackType.lightImpact:
              HapticFeedback.lightImpact();
              break;
            case HapticFeedbackType.mediumImpact:
              HapticFeedback.mediumImpact();
              break;
            case HapticFeedbackType.heavyImpact:
              HapticFeedback.heavyImpact();
              break;
            case HapticFeedbackType.selectionClick:
              HapticFeedback.selectionClick();
              break;
            case HapticFeedbackType.vibrate:
              HapticFeedback.vibrate();
              break;
          }

          // Call the provided callback
          onTap();
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                backgroundColor ??
                AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
          ),
          child: Icon(
            icon,
            size: buttonIconSize,
            color:
                iconColor ??
                AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityVeryHigh,
                ),
          ),
        ),
      ),
    );

    Widget finalButton = button;

    // Wrap with semantics if accessibility properties are provided
    if (semanticsLabel != null || semanticsHint != null) {
      finalButton = Semantics(
        label: semanticsLabel,
        hint: semanticsHint,
        button: true,
        child: finalButton,
      );
    }

    // Wrap with tooltip if provided
    if (tooltip != null) {
      finalButton = Tooltip(message: tooltip, child: finalButton);
    }

    return finalButton;
  }
}

/// Enumeration of haptic feedback types supported by the button
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}
