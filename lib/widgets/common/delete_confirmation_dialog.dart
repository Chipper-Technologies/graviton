import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

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
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: title,
        message: message,
        titleIcon: titleIcon,
        warningColor: warningColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveWarningColor = warningColor ?? AppColors.celestialRed;

    return AlertDialog(
      backgroundColor: AppColors.uiBlack.withValues(
        alpha: AppTypography.opacityAlmostOpaque,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        side: BorderSide(
          color: effectiveWarningColor.withValues(
            alpha: AppTypography.opacityFaint,
          ),
          width: AppTypography.borderThin,
        ),
      ),
      title: Row(
        children: [
          if (titleIcon != null) ...[
            Icon(
              titleIcon,
              color: effectiveWarningColor,
              size: AppTypography.iconSizeXXLarge,
            ),
            SizedBox(width: AppTypography.spacingMedium),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTypography.largeText.copyWith(
                color: AppColors.uiWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: AppTypography.mediumText.copyWith(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityMediumHigh,
            ),
          ),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: effectiveWarningColor,
            backgroundColor: effectiveWarningColor.withValues(
              alpha: AppTypography.opacityDisabled,
            ),
          ),
          child: Text(l10n.deleteButton),
        ),
      ],
    );
  }
}
