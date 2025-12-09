import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';

/// Delete confirmation dialog widget
///
/// Displays a warning message and confirmation buttons for account deletion.
/// Uses red colors to emphasize the destructive nature of the action.
class DeleteConfirmationDialog extends StatelessWidget {
  /// Callback when delete is confirmed
  final VoidCallback onConfirmDelete;

  /// Callback when cancel is pressed
  final VoidCallback onCancel;

  const DeleteConfirmationDialog({
    super.key,
    required this.onConfirmDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingXXLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: AppTypography.iconSizeHuge * 2,
            color: AppColors.uiRed,
          ),
          const SizedBox(height: AppTypography.spacingXXLarge),
          Text(
            l10n.deleteAccountWarning,
            style: AppTypography.titleText.copyWith(color: AppColors.uiWhite),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTypography.spacingMedium),
          Text(
            l10n.deleteAccountMessage,
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacitySemiTransparent,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTypography.spacingXXLarge),
          HapticElevatedButton(
            onPressed: onConfirmDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.uiRed,
              foregroundColor: AppColors.uiWhite,
              padding: const EdgeInsets.symmetric(
                vertical: AppTypography.spacingLarge,
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: Text(l10n.deleteAccountButton),
          ),
          const SizedBox(height: AppTypography.spacingMedium),
          HapticTextButton(
            onPressed: onCancel,
            child: Text(
              l10n.cancel,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
