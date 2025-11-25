import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graviton/enums/screen_mode.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/auth_service.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/account/account_management_options.dart';
import 'package:graviton/widgets/account/avatar_selection_grid.dart';
import 'package:graviton/widgets/account/danger_zone_section.dart';
import 'package:graviton/widgets/account/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/account/edit_name_form.dart';
import 'package:graviton/widgets/account/email_verification_banner.dart';
import 'package:graviton/widgets/account/profile_card.dart';
import 'package:graviton/widgets/account/sign_in_form.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_button.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
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
  bool _acceptedTerms = false;
  bool _isSendingVerification = false;

  Timer? _emailVerificationTimer;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationMonitoring();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailVerificationTimer?.cancel();
    super.dispose();
  }

  /// Start monitoring email verification status
  void _startEmailVerificationMonitoring() {
    // Check every 5 seconds
    _emailVerificationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        // Only check if email is not verified
        if (!AuthService.instance.isEmailVerified) {
          await AuthService.instance.checkEmailVerified();
          if (mounted) {
            setState(() {}); // Refresh UI when verification status changes
          }
        }
      },
    );
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

      // Email verification exceptions
      case 'exceptionEmailVerificationFailed':
        return l10n.exceptionEmailVerificationFailed;
      case 'exceptionEmailVerificationCooldown':
        return l10n.exceptionEmailVerificationCooldown;
      case 'exceptionTermsNotAccepted':
        return l10n.exceptionTermsNotAccepted;

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
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTypography.spacingXLarge),
            child: SignInForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              nameController: _nameController,
              obscurePassword: _obscurePassword,
              isCreatingAccount: _isCreatingAccount,
              acceptedTerms: _acceptedTerms,
              emailError: _emailError,
              passwordError: _passwordError,
              onGoogleSignIn: () => _handleGoogleSignIn(authState, l10n),
              onEmailPasswordAuth: () =>
                  _handleEmailPasswordAuth(authState, l10n),
              onTogglePasswordVisibility: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onToggleMode: () =>
                  setState(() => _isCreatingAccount = !_isCreatingAccount),
              onEmailChanged: (value) => setState(() => _emailError = null),
              onPasswordChanged: (value) =>
                  setState(() => _passwordError = null),
              onNameChanged: (value) {},
              onTermsChanged: (value) =>
                  setState(() => _acceptedTerms = value),
              onTermsTapped: () {
                // TODO: Open Terms of Service
              },
              onPrivacyTapped: () {
                // TODO: Open Privacy Policy
              },
            ),
          ),
        );
      case ScreenMode.avatarSelection:
        final user = authState.currentUser;
        return AvatarSelectionGrid(
          selectedAvatar: _selectedAvatar,
          photoUrl: user?.photoUrl,
          onAvatarSelected: (avatar) =>
              setState(() => _selectedAvatar = avatar),
          onSave: () => _saveAvatar(authState, l10n),
          onCancel: _resetToAccountView,
        );
      case ScreenMode.editName:
        return EditNameForm(
          nameController: _nameController,
          onSave: () => _saveName(authState, l10n),
          onChanged: (value) {},
        );
      case ScreenMode.deleteConfirmation:
        return DeleteConfirmationDialog(
          onConfirmDelete: () => _deleteAccount(authState, l10n),
          onCancel: _resetToAccountView,
        );
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
            if (!authState.isAnonymous &&
                user.email != null &&
                !AuthService.instance.isEmailVerified) ...[
              EmailVerificationBanner(
                onResendVerification: () => _sendEmailVerification(l10n),
                isSendingVerification: _isSendingVerification,
              ),
              const SizedBox(height: AppTypography.spacingMedium),
            ],
            if (authState.isAnonymous || AuthService.instance.isEmailVerified) ...[
              SectionDivider.labeled(
                l10n.accountManagementSection,
                bottomSpacing: AppTypography.spacingMedium,
              ),
              AccountManagementOptions(
                onEditAccount: () {
                  _nameController.text = user.displayName ?? '';
                  setState(() => _mode = ScreenMode.editName);
                },
                onChangeAvatar: () => setState(() {
                  _selectedAvatar = authState.currentUser?.avatar;
                  _mode = ScreenMode.avatarSelection;
                }),
                onSignOut: () => _signOut(authState, l10n),
                isAnonymous: authState.isAnonymous,
              ),
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
              DangerZoneSection(
                onDeleteAccount: () =>
                    setState(() => _mode = ScreenMode.deleteConfirmation),
              ),
            ],
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
    return ProfileCard(
      user: user,
      onEditAvatar: () => setState(() {
        _selectedAvatar = user.avatar;
        _mode = ScreenMode.avatarSelection;
      }),
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

      // Save terms acceptance after successful account creation
      if (success && _acceptedTerms) {
        try {
          await AuthService.instance.saveTermsAcceptance();
        } catch (e) {
          debugPrint('Failed to save terms acceptance: $e');
        }
      }

      // Auto-send verification email for new accounts
      if (success) {
        await _sendEmailVerification(l10n);
      }
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

  Future<void> _sendEmailVerification(AppLocalizations l10n) async {
    setState(() => _isSendingVerification = true);

    try {
      final messageKey = await AuthService.instance.sendEmailVerification();

      if (mounted) {
        String message;
        switch (messageKey) {
          case 'emailVerificationSent':
            message = l10n.emailVerificationSent;
            break;
          case 'emailVerified':
            message = l10n.emailVerified;
            break;
          default:
            message = messageKey;
        }

        GravitonSnackBar.show(context: context, message: message);
      }
    } catch (e) {
      if (mounted) {
        GravitonSnackBar.show(
          context: context,
          message: _getLocalizedErrorMessage(e.toString(), l10n),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSendingVerification = false);
      }
    }
  }

}
