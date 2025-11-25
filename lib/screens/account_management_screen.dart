import 'package:flutter/material.dart';
import 'package:graviton/enums/screen_mode.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/auth/social_auth_button.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_button.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:graviton/widgets/haptics/haptic_list_tile.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Account management screen - single screen with mode-based content
class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  ScreenMode _mode = ScreenMode.accountView;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;

  bool _isCreatingAccount = false;
  bool _obscurePassword = true;
  UserAvatar? _selectedAvatar;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// Translates error codes/messages to localized strings
  String _getLocalizedErrorMessage(String? error, AppLocalizations l10n) {
    if (error == null) return '';

    // Check if error starts with firebaseErrorDefault (has embedded message)
    if (error.startsWith('firebaseErrorDefault:')) {
      final message = error.substring('firebaseErrorDefault:'.length);
      return l10n.firebaseErrorDefault(message);
    }

    // Check if error is a localization key
    switch (error) {
      // Auth service exceptions
      case 'exceptionGoogleSignInNotInitialized':
        return l10n.exceptionGoogleSignInNotInitialized;
      case 'exceptionGoogleSignInTimeout':
        return l10n.exceptionGoogleSignInTimeout;
      case 'exceptionAppleSignInPlatform':
        return l10n.exceptionAppleSignInPlatform;
      case 'exceptionNoAnonymousUser':
        return l10n.exceptionNoAnonymousUser;
      case 'exceptionNoUserSignedIn':
        return l10n.exceptionNoUserSignedIn;

      // Firebase auth errors
      case 'firebaseErrorUserNotFound':
        return l10n.firebaseErrorUserNotFound;
      case 'firebaseErrorWrongPassword':
        return l10n.firebaseErrorWrongPassword;
      case 'firebaseErrorInvalidEmail':
        return l10n.firebaseErrorInvalidEmail;
      case 'firebaseErrorUserDisabled':
        return l10n.firebaseErrorUserDisabled;
      case 'firebaseErrorEmailInUse':
        return l10n.firebaseErrorEmailInUse;
      case 'firebaseErrorWeakPassword':
        return l10n.firebaseErrorWeakPassword;
      case 'firebaseErrorOperationNotAllowed':
        return l10n.firebaseErrorOperationNotAllowed;
      case 'firebaseErrorRequiresRecentLogin':
        return l10n.firebaseErrorRequiresRecentLogin;
      case 'firebaseErrorNetworkFailed':
        return l10n.firebaseErrorNetworkFailed;

      default:
        // Return the error as-is if it's not a known key
        return error;
    }
  }

  void _resetToAccountView() {
    setState(() {
      _mode = ScreenMode.accountView;
      _isCreatingAccount = false;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _selectedAvatar = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AuthState>(
      builder: (context, authState, child) {
        String title;
        switch (_mode) {
          case ScreenMode.signIn:
            title = _isCreatingAccount
                ? l10n.createAccountButton
                : l10n.signInPromptTitle;
            break;
          case ScreenMode.avatarSelection:
            title = l10n.changeAvatarTooltip;
            break;
          case ScreenMode.editName:
            title = l10n.editAccountInformationTitle;
            break;
          case ScreenMode.deleteConfirmation:
            title = l10n.deleteAccountButton;
            break;
          default:
            title = l10n.accountManagementTitle;
        }

        return PopScope(
          canPop: _mode == ScreenMode.accountView,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _mode != ScreenMode.accountView) {
              _resetToAccountView();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.transparentColor,
            appBar: HapticAppBar(
              title: title,
              leading: _mode != ScreenMode.accountView
                  ? HapticIconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _resetToAccountView,
                    )
                  : null,
            ),
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityNearlyOpaque,
                  ),
                ),
                child: _buildContent(authState, l10n),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(AuthState authState, AppLocalizations l10n) {
    switch (_mode) {
      case ScreenMode.signIn:
        return _buildSignInScreen(authState, l10n);
      case ScreenMode.avatarSelection:
        return _buildAvatarSelectionScreen(authState, l10n);
      case ScreenMode.editName:
        return _buildEditNameScreen(authState, l10n);
      case ScreenMode.deleteConfirmation:
        return _buildDeleteConfirmationScreen(authState, l10n);
      default:
        return authState.currentUser == null
            ? _buildSignInPrompt(authState, l10n)
            : _buildAccountView(authState, l10n);
    }
  }

  Widget _buildSignInPrompt(AuthState authState, AppLocalizations l10n) {
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
            HapticButton.primary(
              onPressed: () => setState(() => _mode = ScreenMode.signIn),
              text: l10n.signInButton,
              isFullWidth: true,
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            HapticButton.primary(
              onPressed: () => setState(() {
                _mode = ScreenMode.signIn;
                _isCreatingAccount = true;
              }),
              text: l10n.createAccountButton,
              isFullWidth: true,
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            HapticButton.secondary(
              onPressed: () => _signInAnonymously(authState, l10n),
              text: l10n.continueAsGuestButton,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountView(AuthState authState, AppLocalizations l10n) {
    final user = authState.currentUser!;

    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(authState, user, l10n),
            const SizedBox(height: AppTypography.spacingMedium),
            SectionDivider.labeled(
              l10n.accountManagementSection,
              bottomSpacing: AppTypography.spacingMedium,
            ),
            _buildAccountManagementOptions(authState, user, l10n),
            const SizedBox(height: AppTypography.spacingMedium),
            SectionDivider.labeled(
              l10n.dangerZoneSection,
              bottomSpacing: AppTypography.spacingMedium,
              color: AppColors.uiRed,
              labelStyle: AppTypography.mediumText.copyWith(
                color: AppColors.uiRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            _buildDangerZone(authState, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    AuthState authState,
    dynamic user,
    AppLocalizations l10n,
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
                    size: AppTypography.iconSizeSmall,
                  ),
                  tooltip: l10n.changeAvatarTooltip,
                  onPressed: () => setState(() {
                    _selectedAvatar = user.avatar;
                    _mode = ScreenMode.avatarSelection;
                  }),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.uiWhite,
                    padding: const EdgeInsets.all(AppTypography.spacingXSmall),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTypography.spacingLarge),
          SizedBox(
            width: double.infinity,
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
        ],
      ),
    );
  }

  Widget _buildAvatarDisplay(dynamic user) {
    // Prioritize custom avatar over Google/Apple photo
    if (user.avatar != null) {
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
    } else if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
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
    } else {
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

  Widget _buildAccountManagementOptions(
    AuthState authState,
    dynamic user,
    AppLocalizations l10n,
  ) {
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
            onTap: () {
              _nameController.text = user.displayName ?? '';
              setState(() => _mode = ScreenMode.editName);
            },
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
            onTap: () => setState(() {
              _selectedAvatar = authState.currentUser?.avatar;
              _mode = ScreenMode.avatarSelection;
            }),
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
              authState.isAnonymous
                  ? l10n.resetSessionButton
                  : l10n.signOutButton,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite,
              ),
            ),
            onTap: () => _signOut(authState, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(AuthState authState, AppLocalizations l10n) {
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
        onTap: () => setState(() => _mode = ScreenMode.deleteConfirmation),
      ),
    );
  }

  Widget _buildSignInScreen(AuthState authState, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTypography.spacingXLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: Implement Apple sign-in
              // if (PlatformUtils.isApple) ...[
              //   SocialAuthButton(
              //     icon: Icons.apple,
              //     label: 'Continue with Apple',
              //     onPressed: () => _handleAppleSignIn(authState, l10n),
              //   ),
              //   const SizedBox(height: AppTypography.spacingMedium),
              // ],
              SocialAuthButton(
                assetPath: 'assets/images/google-logo.svg',
                animatedBorder: true,
                label: l10n.continueWithGoogle,
                onPressed: () => _handleGoogleSignIn(authState, l10n),
              ),
              SectionDivider.labeled(
                l10n.orDivider,
                topSpacing: AppTypography.spacingMedium,
                bottomSpacing: AppTypography.spacingMedium,
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
                labelStyle: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
                ),
              ),
              if (_isCreatingAccount) ...[
                StyledTextField(
                  controller: _nameController,
                  icon: Icons.person,
                  labelText: l10n.displayNameLabel,
                  hintText: l10n.displayNameHint,
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppTypography.spacingMedium),
              ],
              StyledTextField(
                controller: _emailController,
                icon: Icons.email,
                labelText: l10n.emailLabel,
                hintText: l10n.emailHint,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (value) => setState(() => _emailError = null),
              ),
              const SizedBox(height: AppTypography.spacingMedium),
              StyledTextField(
                controller: _passwordController,
                icon: Icons.lock,
                labelText: l10n.passwordLabel,
                hintText: l10n.passwordHint,
                obscureText: _obscurePassword,
                errorText: _passwordError,
                suffixIcon: HapticIconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacitySemiTransparent,
                    ),
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: (value) => setState(() => _passwordError = null),
              ),
              const SizedBox(height: AppTypography.spacingXXLarge),
              HapticElevatedButton(
                onPressed: () => _handleEmailPasswordAuth(authState, l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.uiWhite,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTypography.spacingLarge,
                  ),
                ),
                child: Text(
                  _isCreatingAccount
                      ? l10n.createAccountButton
                      : l10n.signInButton,
                ),
              ),
              const SizedBox(height: AppTypography.spacingMedium),
              HapticTextButton(
                onPressed: () =>
                    setState(() => _isCreatingAccount = !_isCreatingAccount),
                child: Text(
                  _isCreatingAccount
                      ? l10n.alreadyHaveAccountSignIn
                      : l10n.needAccountCreateOne,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSelectionScreen(
    AuthState authState,
    AppLocalizations l10n,
  ) {
    final user = authState.currentUser;
    final hasProfilePhoto =
        user?.photoUrl != null && user!.photoUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        children: [
          if (hasProfilePhoto) ...[
            GestureDetector(
              onTap: () => setState(() => _selectedAvatar = null),
              child: Container(
                padding: const EdgeInsets.all(AppTypography.spacingMedium),
                decoration: BoxDecoration(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityBarely,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                  border: Border.all(
                    color: _selectedAvatar == null
                        ? AppColors.primaryColor
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityFaint,
                          ),
                    width: _selectedAvatar == null ? 3 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        user.photoUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: AppTypography.spacingMedium),
                    Expanded(
                      child: Text(
                        l10n.useGoogleProfilePhoto,
                        style: AppTypography.mediumText.copyWith(
                          color: AppColors.uiWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            SectionDivider.labeled(
              l10n.customAvatars,
              bottomSpacing: AppTypography.spacingMedium,
            ),
          ],
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: AppTypography.spacingMedium,
                crossAxisSpacing: AppTypography.spacingMedium,
              ),
              itemCount: UserAvatar.values.length,
              itemBuilder: (context, index) {
                final avatar = UserAvatar.values[index];
                final isSelected = _selectedAvatar == avatar;

                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatar = avatar),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityBarely,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppTypography.radiusMedium,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityFaint,
                              ),
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        avatar.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppTypography.spacingLarge),
          HapticElevatedButton(
            onPressed: () => _saveAvatar(authState, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.uiWhite,
              padding: const EdgeInsets.symmetric(
                vertical: AppTypography.spacingLarge,
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: Text(l10n.saveAvatar),
          ),
          const SizedBox(height: AppTypography.spacingMedium),
          Center(
            child: HapticTextButton(
              onPressed: _resetToAccountView,
              child: Text(
                l10n.cancel,
                style: AppTypography.mediumText.copyWith(
                  color: AppColors.uiWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditNameScreen(AuthState authState, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingXLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledTextField(
            controller: _nameController,
            icon: Icons.person,
            labelText: l10n.displayNameFieldLabel,
            hintText: l10n.displayNameFieldHint,
            onChanged: (value) {},
          ),
          const SizedBox(height: AppTypography.spacingXXLarge),
          HapticElevatedButton(
            onPressed: () => _saveName(authState, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.uiWhite,
              padding: const EdgeInsets.symmetric(
                vertical: AppTypography.spacingLarge,
              ),
            ),
            child: Text(l10n.saveAccountInformation),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteConfirmationScreen(
    AuthState authState,
    AppLocalizations l10n,
  ) {
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
            onPressed: () => _deleteAccount(authState, l10n),
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
            onPressed: _resetToAccountView,
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

  Future<void> _signInAnonymously(
    AuthState authState,
    AppLocalizations l10n,
  ) async {
    final success = await authState.signInAnonymously();
    if (mounted && success) {
      GravitonSnackBar.show(
        context: context,
        message: l10n.signInAnonymousSuccess,
      );
      _resetToAccountView();
    }
  }

  Future<void> _handleEmailPasswordAuth(
    AuthState authState,
    AppLocalizations l10n,
  ) async {
    // Clear previous errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Validate email
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = l10n.emailRequired);
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = l10n.emailInvalid);
      return;
    }

    // Validate password
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _passwordError = l10n.passwordRequired);
      return;
    }
    if (_isCreatingAccount && password.length < 6) {
      setState(() => _passwordError = l10n.passwordTooShort);
      return;
    }

    bool success;
    if (_isCreatingAccount) {
      final displayName = _nameController.text.trim().isEmpty
          ? l10n.defaultUserName
          : _nameController.text.trim();
      success = await authState.createAccount(
        email: email,
        password: password,
        displayName: displayName,
      );
    } else {
      success = await authState.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }

    if (mounted) {
      if (success) {
        _resetToAccountView();
      } else if (authState.error != null) {
        GravitonSnackBar.show(
          context: context,
          message: _getLocalizedErrorMessage(authState.error, l10n),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn(
    AuthState authState,
    AppLocalizations l10n,
  ) async {
    final success = await authState.signInWithGoogle();
    if (mounted) {
      if (success) {
        _resetToAccountView();
      } else {
        GravitonSnackBar.show(
          context: context,
          message: l10n.googleSignInError,
        );
      }
    }
  }

  Future<void> _saveAvatar(AuthState authState, AppLocalizations l10n) async {
    // If _selectedAvatar is null, user wants to use their profile photo (clear custom avatar)
    final success = _selectedAvatar == null
        ? await authState.clearAvatar()
        : await authState.setAvatar(_selectedAvatar!);

    if (mounted) {
      GravitonSnackBar.show(
        context: context,
        message: success ? l10n.avatarChangedSuccess : l10n.avatarChangedError,
      );
      if (success) _resetToAccountView();
    }
  }

  Future<void> _saveName(AuthState authState, AppLocalizations l10n) async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    final success = await authState.updateDisplayName(newName);
    if (mounted) {
      GravitonSnackBar.show(
        context: context,
        message: success
            ? l10n.displayNameUpdated
            : l10n.displayNameUpdateFailed,
      );
      if (success) _resetToAccountView();
    }
  }

  Future<void> _signOut(AuthState authState, AppLocalizations l10n) async {
    if (authState.isAnonymous) {
      // For anonymous users, clear local data and sign in again as a fresh anonymous user
      await authState.clearAvatar();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('anonymous_display_name');
      await authState.signOut();
      await authState.signInAnonymously();
      if (mounted) {
        GravitonSnackBar.show(
          context: context,
          message: l10n.sessionResetSuccess,
        );
        Navigator.of(context).pop();
      }
    } else {
      // For authenticated users, normal sign out
      final success = await authState.signOut();
      if (mounted && success) {
        GravitonSnackBar.show(context: context, message: l10n.signOutSuccess);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _deleteAccount(
    AuthState authState,
    AppLocalizations l10n,
  ) async {
    final success = await authState.deleteAccount();
    if (mounted && success) {
      GravitonSnackBar.show(
        context: context,
        message: l10n.accountDeletedSuccess,
      );
      Navigator.of(context).pop();
    }
  }
}
