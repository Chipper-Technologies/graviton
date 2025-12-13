import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_list_tile.dart';

/// Danger zone section widget
///
/// Displays a single action item for deleting the user's account.
/// Styled with red colors to indicate destructive action.
class DangerZoneSection extends StatelessWidget {
  /// Callback when delete account is tapped
  final VoidCallback onDeleteAccount;

  /// Whether account deletion is in progress
  final bool isDeletingAccount;

  /// Whether the section should be disabled (e.g., during sign out)
  final bool isDisabled;

  const DangerZoneSection({
    super.key,
    required this.onDeleteAccount,
    this.isDeletingAccount = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTypography.spacingLarge,
      ),
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: Border.all(
          color: AppColors.uiRed.withValues(alpha: AppTypography.opacityFaint),
          width: AppTypography.borderThin,
        ),
      ),
      child: HapticListTile(
        leading: isDeletingAccount
            ? SizedBox(
                width: AppTypography.iconSizeMedium,
                height: AppTypography.iconSizeMedium,
                child: CircularProgressIndicator(
                  strokeWidth: AppTypography.borderMedium,
                  color: AppColors.uiRed,
                ),
              )
            : Icon(
                Icons.delete_forever,
                color: AppColors.uiRed.withValues(
                  alpha: (isDisabled || isDeletingAccount)
                      ? AppTypography.opacityDisabled
                      : AppTypography.opacityHigh,
                ),
              ),
        title: Opacity(
          opacity: (isDisabled || isDeletingAccount)
              ? AppTypography.opacityDisabled
              : 1.0,
          child: Text(
            l10n.deleteAccountButton,
            style: AppTypography.mediumText.copyWith(color: AppColors.uiRed),
          ),
        ),
        onTap: (isDisabled || isDeletingAccount) ? null : onDeleteAccount,
      ),
    );
  }
}
