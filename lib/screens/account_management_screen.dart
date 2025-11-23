import 'package:flutter/material.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/auth/avatar_selector_dialog.dart';
import 'package:graviton/widgets/auth/delete_account_dialog.dart';
import 'package:graviton/widgets/auth/edit_display_name_dialog.dart';
import 'package:graviton/widgets/auth/sign_in_dialog.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:graviton/widgets/haptics/haptic_list_tile.dart';
import 'package:provider/provider.dart';

/// Account management screen
///
/// Allows users to view and manage their account including:
/// - Profile information (email, display name, avatar)
/// - Sign in / sign out
/// - Delete account
class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AuthState>(
      builder: (context, authState, child) {
        final user = authState.currentUser;
        final isAuthenticated = authState.isAuthenticated;
        final isAnonymous = authState.isAnonymous;

        return Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: HapticAppBar(title: l10n.accountManagementTitle),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.uiBlack.withValues(
                  alpha: AppTypography.opacityNearlyOpaque,
                ),
              ),
              child: user == null
                  ? _buildSignInPrompt(context, l10n, authState)
                  : _buildAccountDetails(
                      context,
                      l10n,
                      authState,
                      isAuthenticated,
                      isAnonymous,
                    ),
            ),
          ),
        );
      },
    );
  }

  /// Build sign-in prompt for users who aren't signed in
  Widget _buildSignInPrompt(
    BuildContext context,
    AppLocalizations l10n,
    AuthState authState,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTypography.spacingXXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: AppTypography.iconSizeHuge * 2,
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMedium,
              ),
            ),
            const SizedBox(height: AppTypography.spacingXXLarge),
            Text(
              l10n.signInPromptTitle,
              style: AppTypography.titleText.copyWith(color: AppColors.uiWhite),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            Text(
              l10n.signInPromptMessage,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacitySemiTransparent,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTypography.spacingXXLarge),
            HapticElevatedButton(
              onPressed: () => _showSignInDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.uiWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTypography.spacingXXLarge,
                  vertical: AppTypography.spacingLarge,
                ),
              ),
              child: Text(l10n.signInButton),
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            HapticElevatedButton(
              onPressed: () => _signInAnonymously(context, authState),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityVeryFaint,
                ),
                foregroundColor: AppColors.uiWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTypography.spacingXXLarge,
                  vertical: AppTypography.spacingLarge,
                ),
              ),
              child: Text(l10n.continueAsGuestButton),
            ),
          ],
        ),
      ),
    );
  }

  /// Build account details for signed-in users
  Widget _buildAccountDetails(
    BuildContext context,
    AppLocalizations l10n,
    AuthState authState,
    bool isAuthenticated,
    bool isAnonymous,
  ) {
    final user = authState.currentUser!;

    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  _buildProfileSection(context, l10n, authState, user),
                  const SizedBox(height: AppTypography.spacingXXLarge),

                  // Account Actions Section
                  if (isAnonymous) ...[
                    SectionDivider.labeled(
                      l10n.accountActionsSection,
                      bottomSpacing: AppTypography.spacingMedium,
                    ),
                    _buildUpgradeAccountOption(context, l10n),
                    const SizedBox(height: AppTypography.spacingXXLarge),
                  ],

                  // Danger Zone Section
                  SectionDivider.labeled(
                    l10n.dangerZoneSection,
                    bottomSpacing: AppTypography.spacingMedium,
                  ),
                  _buildDangerZoneOptions(context, l10n, authState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build profile section with avatar and user info
  Widget _buildProfileSection(
    BuildContext context,
    AppLocalizations l10n,
    AuthState authState,
    dynamic user,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
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
          // Avatar
          Stack(
            alignment: Alignment.center,
            children: [
              _buildAvatarDisplay(user),
              Positioned(
                bottom: 0,
                right: 0,
                child: HapticIconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: AppTypography.iconSizeLarge,
                  ),
                  tooltip: l10n.changeAvatarTooltip,
                  onPressed: () => _showAvatarSelector(context, authState),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.uiWhite,
                    padding: const EdgeInsets.all(AppTypography.spacingSmall),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTypography.spacingLarge),

          // Display Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  user.displayName ?? l10n.anonymousUserLabel,
                  style: AppTypography.titleText.copyWith(
                    color: AppColors.uiWhite,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!authState.isAnonymous) ...[
                const SizedBox(width: AppTypography.spacingSmall),
                HapticIconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: AppTypography.iconSizeMedium,
                  ),
                  tooltip: l10n.editDisplayNameTooltip,
                  onPressed: () =>
                      _showEditDisplayNameDialog(context, authState),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(24, 24),
                  ),
                ),
              ],
            ],
          ),

          // Email
          if (user.email != null) ...[
            const SizedBox(height: AppTypography.spacingXSmall),
            Text(
              user.email!,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacitySemiTransparent,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // Account Type Badge
          const SizedBox(height: AppTypography.spacingMedium),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
              vertical: AppTypography.spacingXSmall,
            ),
            decoration: BoxDecoration(
              color: authState.isAnonymous
                  ? AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityVeryFaint,
                    )
                  : AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityFaint,
                    ),
              borderRadius: BorderRadius.circular(AppTypography.radiusRound),
            ),
            child: Text(
              authState.isAnonymous
                  ? l10n.guestAccountLabel
                  : user.authProvider?.displayName ?? l10n.authenticatedLabel,
              style: AppTypography.smallText.copyWith(
                color: AppColors.uiWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build avatar display (emoji or photo)
  Widget _buildAvatarDisplay(dynamic user) {
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      // Show profile photo from social auth
      return Container(
        width: AppTypography.iconSizeHuge * 1.5,
        height: AppTypography.iconSizeHuge * 1.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: AppTypography.borderThick,
          ),
          image: DecorationImage(
            image: NetworkImage(user.photoUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (user.avatar != null) {
      // Show selected emoji avatar
      return Container(
        width: AppTypography.iconSizeHuge * 1.5,
        height: AppTypography.iconSizeHuge * 1.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: AppTypography.borderThick,
          ),
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
        ),
        child: Center(
          child: Text(user.avatar!.emoji, style: const TextStyle(fontSize: 48)),
        ),
      );
    } else {
      // Default avatar icon
      return Container(
        width: AppTypography.iconSizeHuge * 1.5,
        height: AppTypography.iconSizeHuge * 1.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: AppTypography.borderThick,
          ),
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
        ),
        child: Icon(
          Icons.account_circle,
          size: AppTypography.iconSizeHuge,
          color: AppColors.primaryColor,
        ),
      );
    }
  }

  /// Build upgrade account option for anonymous users
  Widget _buildUpgradeAccountOption(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return HapticListTile(
      leading: Container(
        width: AppTypography.iconSizeXLarge * 1.8,
        height: AppTypography.iconSizeXLarge * 1.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityMedium,
            ),
            width: AppTypography.borderMedium,
          ),
        ),
        child: Icon(
          Icons.upgrade,
          size: AppTypography.iconSizeLarge,
          color: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityHigh,
          ),
        ),
      ),
      title: Text(
        l10n.upgradeAccountTitle,
        style: AppTypography.mediumText.copyWith(
          color: AppColors.uiWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        l10n.upgradeAccountDescription,
        style: AppTypography.smallText.copyWith(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacitySemiTransparent,
          ),
        ),
      ),
      onTap: () => _showSignInDialog(context),
    );
  }

  /// Build danger zone options (sign out, delete account)
  Widget _buildDangerZoneOptions(
    BuildContext context,
    AppLocalizations l10n,
    AuthState authState,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: Border.all(
          color: AppColors.uiRed.withValues(alpha: AppTypography.opacityFaint),
          width: AppTypography.borderThin,
        ),
      ),
      child: Column(
        children: [
          // Sign Out
          HapticListTile(
            leading: Icon(
              Icons.logout,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
            title: Text(
              l10n.signOutButton,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite,
              ),
            ),
            onTap: () => _signOut(context, authState),
            contentPadding: EdgeInsets.zero,
          ),

          const SectionDivider.plain(),

          // Delete Account
          HapticListTile(
            leading: Icon(Icons.delete_forever, color: AppColors.uiRed),
            title: Text(
              l10n.deleteAccountButton,
              style: AppTypography.mediumText.copyWith(color: AppColors.uiRed),
            ),
            onTap: () => _showDeleteAccountDialog(context, authState),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // Action methods

  Future<void> _showSignInDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const SignInDialog(),
    );
  }

  Future<void> _signInAnonymously(
    BuildContext context,
    AuthState authState,
  ) async {
    final success = await authState.signInAnonymously();
    if (context.mounted) {
      if (success) {
        final l10n = AppLocalizations.of(context)!;
        GravitonSnackBar.show(
          context: context,
          message: l10n.signInAnonymousSuccess,
        );
      }
    }
  }

  Future<void> _showAvatarSelector(
    BuildContext context,
    AuthState authState,
  ) async {
    final selectedAvatar = await showDialog<UserAvatar>(
      context: context,
      builder: (context) => const AvatarSelectorDialog(),
    );

    if (selectedAvatar != null) {
      final success = await authState.setAvatar(selectedAvatar);
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        GravitonSnackBar.show(
          context: context,
          message: success
              ? l10n.avatarChangedSuccess
              : l10n.avatarChangedError,
        );
      }
    }
  }

  Future<void> _showEditDisplayNameDialog(
    BuildContext context,
    AuthState authState,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => EditDisplayNameDialog(
        currentName: authState.currentUser?.displayName,
      ),
    );
  }

  Future<void> _signOut(BuildContext context, AuthState authState) async {
    final success = await authState.signOut();
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (success) {
        GravitonSnackBar.show(context: context, message: l10n.signOutSuccess);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _showDeleteAccountDialog(
    BuildContext context,
    AuthState authState,
  ) async {
    final deleted = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );

    if (deleted == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
