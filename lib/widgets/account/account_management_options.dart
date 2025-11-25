import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_list_tile.dart';

/// Account management options widget
///
/// Displays a list of account management actions including:
/// - Edit account information (name)
/// - Change avatar
/// - Sign out / Reset session (for anonymous users)
///
/// Each option is a tappable list tile with an icon and label.
class AccountManagementOptions extends StatelessWidget {
  /// Callback when edit account information is tapped
  final VoidCallback onEditAccount;

  /// Callback when change avatar is tapped
  final VoidCallback onChangeAvatar;

  /// Callback when sign out/reset session is tapped
  final VoidCallback onSignOut;

  /// Whether the user is anonymous (affects sign out label)
  final bool isAnonymous;

  const AccountManagementOptions({
    super.key,
    required this.onEditAccount,
    required this.onChangeAvatar,
    required this.onSignOut,
    required this.isAnonymous,
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
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          width: AppTypography.borderThin,
        ),
      ),
      child: Column(
        children: [
          HapticListTile(
            leading: Icon(
              Icons.edit,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
            title: Text(
              l10n.editAccountInformationTitle,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite,
              ),
            ),
            onTap: onEditAccount,
          ),
          const SectionDivider.plain(),
          HapticListTile(
            leading: Icon(
              Icons.account_circle,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
            title: Text(
              l10n.changeAvatarTooltip,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite,
              ),
            ),
            onTap: onChangeAvatar,
          ),
          const SectionDivider.plain(),
          HapticListTile(
            leading: Icon(
              Icons.logout,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
            title: Text(
              isAnonymous ? l10n.resetSessionButton : l10n.signOutButton,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite,
              ),
            ),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
