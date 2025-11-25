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

  const DangerZoneSection({super.key, required this.onDeleteAccount});

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
        leading: Icon(Icons.delete_forever, color: AppColors.uiRed),
        title: Text(
          l10n.deleteAccountButton,
          style: AppTypography.mediumText.copyWith(color: AppColors.uiRed),
        ),
        onTap: onDeleteAccount,
      ),
    );
  }
}
