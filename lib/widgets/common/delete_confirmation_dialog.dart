import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/base_confirmation_dialog.dart';

/// A reusable delete confirmation dialog widget
///
/// This widget provides a consistent delete confirmation experience across the app
/// with proper styling, localization, and accessibility features.
class DeleteConfirmationDialog extends StatelessWidget {
  /// The title text for the dialog
  final String title;

  /// The message content explaining what will be deleted
  final String message;

  /// Optional icon to display in the title row
  final IconData? titleIcon;

  /// Color for the title icon and delete button
  final Color? warningColor;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.titleIcon,
    this.warningColor,
  });

  /// Shows the delete confirmation dialog and returns true if confirmed
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData? titleIcon,
    Color? warningColor,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveWarningColor = warningColor ?? AppColors.celestialRed;

    return BaseConfirmationDialog.show<bool>(
      context: context,
      title: title,
      message: message,
      titleIcon: titleIcon,
      iconColor: effectiveWarningColor.withValues(
        alpha: AppTypography.opacityVeryFaint,
      ),
      actions: [
        DialogAction(
          text: l10n.cancel,
          onPressed: () => Navigator.of(context).pop(false),
          textColor: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityHigh,
          ),
        ),
        DialogAction(
          text: l10n.deleteButton,
          onPressed: () => Navigator.of(context).pop(true),
          textColor: effectiveWarningColor,
          backgroundColor: effectiveWarningColor.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          fontWeight: FontWeight.w600,
          isDestructive: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveWarningColor = warningColor ?? AppColors.celestialRed;

    return BaseConfirmationDialog(
      title: title,
      message: message,
      titleIcon: titleIcon,
      iconColor: effectiveWarningColor,
      borderColor: effectiveWarningColor.withValues(
        alpha: AppTypography.opacityVeryFaint,
      ),
      actions: [
        DialogAction(
          text: l10n.cancel,
          onPressed: () => Navigator.pop(context, false),
          textColor: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityHigh,
          ),
        ),
        DialogAction(
          text: l10n.deleteButton,
          onPressed: () => Navigator.pop(context, true),
          textColor: effectiveWarningColor,
          backgroundColor: effectiveWarningColor.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          fontWeight: FontWeight.w600,
          isDestructive: true,
        ),
      ],
    );
  }
}
