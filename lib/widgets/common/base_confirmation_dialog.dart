import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';

/// Base configuration for dialog actions
class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final bool isDestructive;

  const DialogAction({
    required this.text,
    required this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.fontWeight,
    this.isDestructive = false,
  });
}

/// A reusable base confirmation dialog widget that provides consistent styling,
/// layout, and behavior across all confirmation dialogs in the app.
///
/// This widget standardizes:
/// - Dark theme styling with consistent colors and opacity
/// - Dialog constraints and shape
/// - Title layout with optional icons
/// - Action button styling and haptic feedback
/// - Accessibility features
class BaseConfirmationDialog extends StatelessWidget {
  /// The title text for the dialog
  final String title;

  /// The message content explaining the action or consequences
  final String message;

  /// Optional icon to display in the title
  final IconData? titleIcon;

  /// Color for the title icon (defaults to appropriate theme color)
  final Color? iconColor;

  /// List of dialog actions (buttons)
  final List<DialogAction> actions;

  /// Whether to use constraints for compact dialog sizing
  final bool useConstraints;

  /// Custom background color override
  final Color? backgroundColor;

  /// Custom border color for the dialog
  final Color? borderColor;

  /// Whether the dialog can be dismissed by tapping outside
  final bool barrierDismissible;

  const BaseConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.titleIcon,
    this.iconColor,
    required this.actions,
    this.useConstraints = true,
    this.backgroundColor,
    this.borderColor,
    this.barrierDismissible = true,
  });

  /// Shows a confirmation dialog and returns the result
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    IconData? titleIcon,
    Color? iconColor,
    required List<DialogAction> actions,
    bool useConstraints = true,
    Color? backgroundColor,
    Color? borderColor,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => BaseConfirmationDialog(
        title: title,
        message: message,
        titleIcon: titleIcon,
        iconColor: iconColor,
        actions: actions,
        useConstraints: useConstraints,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Convenience method for simple yes/no confirmation dialogs
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? titleIcon,
    Color? iconColor,
    Color? confirmColor,
    bool isDestructive = false,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return show<bool>(
      context: context,
      title: title,
      message: message,
      titleIcon: titleIcon,
      iconColor: iconColor,
      actions: [
        DialogAction(
          text: cancelText ?? l10n.cancel,
          onPressed: () => Navigator.of(context).pop(false),
          textColor: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityMediumHigh,
          ),
        ),
        DialogAction(
          text: confirmText ?? (isDestructive ? l10n.deleteButton : l10n.ok),
          onPressed: () => Navigator.of(context).pop(true),
          textColor:
              confirmColor ??
              (isDestructive ? AppColors.celestialRed : AppColors.primaryColor),
          backgroundColor:
              (confirmColor ??
                      (isDestructive
                          ? AppColors.celestialRed
                          : AppColors.primaryColor))
                  .withValues(alpha: AppTypography.opacityDisabled),
          fontWeight: FontWeight.w600,
          isDestructive: isDestructive,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ??
        AppColors.uiBlack.withValues(alpha: AppTypography.opacityAlmostOpaque);

    final effectiveBorderColor =
        borderColor ??
        (iconColor ?? AppColors.primaryColor).withValues(
          alpha: AppTypography.opacityFaint,
        );

    final dialogContent = AlertDialog(
      backgroundColor: effectiveBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        side: BorderSide(
          color: effectiveBorderColor,
          width: AppTypography.borderThin,
        ),
      ),
      title: titleIcon != null
          ? DialogTitle(
              title: title,
              icon: titleIcon!,
              iconColor: iconColor ?? AppColors.primaryColor,
              titleStyle: AppTypography.largeText.copyWith(
                color: AppColors.uiWhite,
                fontWeight: FontWeight.w600,
              ),
            )
          : Text(
              title,
              style: AppTypography.largeText.copyWith(
                color: AppColors.uiWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
      content: Text(
        message,
        style: AppTypography.mediumText.copyWith(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ),
        ),
      ),
      actions: actions.map(_buildActionButton).toList(),
    );

    if (useConstraints) {
      return ConstrainedBox(
        constraints: AppConstraints.dialogCompact,
        child: dialogContent,
      );
    }

    return dialogContent;
  }

  Widget _buildActionButton(DialogAction action) {
    return HapticTextButton(
      onPressed: action.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: action.textColor ?? AppColors.uiWhite,
        backgroundColor: action.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
        ),
      ),
      child: Text(
        action.text,
        style: AppTypography.mediumText.copyWith(
          color: action.textColor ?? AppColors.uiWhite,
          fontWeight: action.fontWeight,
        ),
      ),
    );
  }
}
