import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// A reusable haptic-enabled button with cosmic space theme styling
///
/// This button follows the design pattern used in orbital placement controls
/// with proper space-themed styling, haptic feedback, and accessibility support.
///
/// Usage examples:
/// ```dart
/// HapticButton.primary(
///   onPressed: () => placeInOrbit(),
///   text: 'Place in Orbit',
///   icon: Icons.rocket_launch,
/// )
///
/// HapticButton.destructive(
///   onPressed: () => cancelAction(),
///   text: 'Cancel Orbit Placement',
///   icon: Icons.cancel,
/// )
/// ```
class HapticButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isDestructive;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;

  const HapticButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isDestructive = false,
    this.isFullWidth = false,
    this.padding,
    this.tooltip,
  });

  /// Factory constructor for primary action buttons
  factory HapticButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    IconData? icon,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
    String? tooltip,
  }) {
    return HapticButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.uiWhite,
      isFullWidth: isFullWidth,
      padding: padding,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for destructive action buttons
  factory HapticButton.destructive({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    IconData? icon,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
    String? tooltip,
  }) {
    return HapticButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: AppColors.celestialRed,
      foregroundColor: AppColors.uiWhite,
      isDestructive: true,
      isFullWidth: isFullWidth,
      padding: padding,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for secondary action buttons
  factory HapticButton.secondary({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    IconData? icon,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
    String? tooltip,
  }) {
    return HapticButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityBarely,
      ),
      foregroundColor: AppColors.uiWhite,
      isFullWidth: isFullWidth,
      padding: padding,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget buttonChild = icon != null
        ? Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: _effectiveForegroundColor,
                size: AppTypography.iconSizeMedium,
              ),
              SizedBox(width: AppTypography.spacingSmall),
              Text(
                text,
                style: TextStyle(
                  color: _effectiveForegroundColor,
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        : Text(
            text,
            style: TextStyle(
              color: _effectiveForegroundColor,
              fontSize: AppTypography.fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          );

    final Widget button = SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () {
                // Provide appropriate haptic feedback based on button type
                if (isDestructive) {
                  HapticUtils.impact();
                } else {
                  HapticUtils.tap();
                }
                onPressed!();
              },
        style:
            ElevatedButton.styleFrom(
              backgroundColor: _effectiveBackgroundColor,
              foregroundColor: _effectiveForegroundColor,
              padding: _effectivePadding,
              elevation: AppTypography.spacingXSmall,
              shadowColor: _effectiveBackgroundColor.withValues(
                alpha: AppTypography.opacityFaint,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return _effectiveForegroundColor.withValues(
                    alpha: AppTypography.opacityBarely,
                  );
                }
                if (states.contains(WidgetState.pressed)) {
                  return _effectiveForegroundColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  );
                }
                return null;
              }),
            ),
        child: buttonChild,
      ),
    );

    // Wrap with tooltip if provided
    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        padding: EdgeInsets.all(AppTypography.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityNearlyOpaque,
          ),
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        ),
        textStyle: TextStyle(
          color: AppColors.uiWhite,
          fontSize: AppTypography.fontSizeSmall,
        ),
        child: button,
      );
    }

    return button;
  }

  Color get _effectiveBackgroundColor =>
      backgroundColor ??
      (isDestructive ? AppColors.celestialRed : AppColors.primaryColor);

  Color get _effectiveForegroundColor => foregroundColor ?? AppColors.uiWhite;

  EdgeInsetsGeometry get _effectivePadding =>
      padding ?? EdgeInsets.all(AppTypography.spacingMedium);
}
