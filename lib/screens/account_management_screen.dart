import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/screen_mode.dart';
import 'package:graviton/enums/snack_bar_severity.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/auth_service.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/utils/auth_ui_handler.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/account/account_management_options.dart';
import 'package:graviton/widgets/account/avatar_selection_grid.dart';
import 'package:graviton/widgets/account/danger_zone_section.dart';
import 'package:graviton/widgets/account/delete_account_with_reauth_dialog.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  bool _isProcessing = false;
  bool _isSigningOut = false;
  bool _isDeletingAccount = false;
  static const Duration _operationTimeout = Duration(seconds: 30);

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
    _emailVerificationTimer = Timer.periodic(const Duration(seconds: 5), (
      _,
    ) async {
      // Only check if email is not verified
      if (!AuthService.instance.isEmailVerified) {
        await AuthService.instance.checkEmailVerified();
        if (mounted) {
          setState(() {}); // Refresh UI when verification status changes
        }
      }
    });
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
            backgroundColor: AppColors.backgroundBlack,
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
              isProcessing: _isProcessing,
              onAppleSignIn: () => _handleSocialSignIn(
                authState,
                l10n,
                authState.signInWithApple,
                l10n.appleSignInError,
              ),
              onGoogleSignIn: () => _handleSocialSignIn(
                authState,
                l10n,
                authState.signInWithGoogle,
                l10n.googleSignInError,
              ),
              onGitHubSignIn: () => _handleSocialSignIn(
                authState,
                l10n,
                authState.signInWithGitHub,
                l10n.gitHubSignInError,
              ),
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
              onTermsChanged: (value) => setState(() => _acceptedTerms = value),
              onTermsTapped: () =>
                  _launchUrl(AppConfig.termsOfServiceUrl, l10n),
              onPrivacyTapped: () =>
                  _launchUrl(AppConfig.privacyPolicyUrl, l10n),
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
        return DeleteAccountWithReauthDialog(
          providerType:
              authState.currentUser?.authProvider ??
              AuthProviderType.emailPassword,
          onConfirmDelete: (password) =>
              _deleteAccountWithPassword(authState, password, l10n),
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
      child: SingleChildScrollView(
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
                style: AppTypography.titleText.copyWith(
                  color: AppColors.uiWhite,
                ),
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
      ),
    );
  }

  Widget _buildAccountView(AuthState authState, AppLocalizations l10n) {
    final user = authState.currentUser!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppTypography.spacingLarge),
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
            if (authState.isAnonymous ||
                AuthService.instance.isEmailVerified) ...[
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
                isSigningOut: _isSigningOut,
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
                isDeletingAccount: _isDeletingAccount,
                isDisabled: _isSigningOut,
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
      isDisabled: _isSigningOut,
    );
  }

  Future<void> _signInAnonymously(
    AuthState authState,
    AppLocalizations l10n,
  ) async {
    if (!_canProceed()) return;

    setState(() => _isProcessing = true);

    try {
      final success = await AuthUIHandler.handleAnonymousSignIn(
        context: context,
        authState: authState,
        l10n: l10n,
      );

      if (mounted && success) {
        _resetToAccountView();
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleEmailPasswordAuth(
    AuthState authState,
    AppLocalizations l10n,
  ) async {
    if (!_canProceed()) return;

    // Clear previous errors and validate
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate inputs
    final emailError = AuthUIHandler.validateEmail(email, l10n);
    final passwordError = AuthUIHandler.validatePassword(
      password,
      l10n,
      isCreatingAccount: _isCreatingAccount,
    );

    if (emailError != null || passwordError != null) {
      setState(() {
        _emailError = emailError;
        _passwordError = passwordError;
      });
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final success = await AuthUIHandler.handleEmailPasswordAuth(
        context: context,
        authState: authState,
        l10n: l10n,
        email: email,
        password: password,
        isCreatingAccount: _isCreatingAccount,
        displayName: _nameController.text.trim(),
        acceptedTerms: _acceptedTerms,
      );

      if (mounted && success) {
        _resetToAccountView();
      } else if (mounted && authState.error != null) {
        // Check for rate limiting
        if (authState.error!.contains('too-many-requests')) {
          _handleRateLimit(l10n, cooldown: const Duration(minutes: 1));
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  /// Unified handler for social sign-in (Google, Apple, GitHub)
  Future<void> _handleSocialSignIn(
    AuthState authState,
    AppLocalizations l10n,
    Future<bool> Function() signInMethod,
    String errorMessage,
  ) async {
    if (!_canProceed()) return;

    setState(() => _isProcessing = true);

    try {
      final success = await AuthUIHandler.handleSocialSignIn(
        context: context,
        authState: authState,
        l10n: l10n,
        signInMethod: signInMethod,
        errorMessage: errorMessage,
      );

      if (mounted) {
        if (success) {
          _resetToAccountView();
        } else if (authState.error != null) {
          // Show specific error from AuthState if available
          GravitonSnackBar.show(
            context: context,
            message: AuthUIHandler.getLocalizedErrorMessage(
              authState.error,
              l10n,
            ),
            severity: SnackBarSeverity.error,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
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
    setState(() => _isSigningOut = true);

    try {
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
          // Stay on account screen after sign out
        }
      } else {
        // For authenticated users, normal sign out
        final success = await authState.signOut();
        if (mounted && success) {
          GravitonSnackBar.show(context: context, message: l10n.signOutSuccess);
          // Stay on account screen after sign out
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  Future<bool> _deleteAccountWithPassword(
    AuthState authState,
    String? password,
    AppLocalizations l10n,
  ) async {
    setState(() => _isDeletingAccount = true);

    try {
      final success = await authState.deleteAccount(password: password);
      if (mounted) {
        if (success) {
          GravitonSnackBar.show(
            context: context,
            message: l10n.accountDeletedSuccess,
          );
          // Reset to account view after successful deletion
          _resetToAccountView();
        } else if (authState.error != null) {
          // Show error from AuthState in snackbar
          GravitonSnackBar.show(context: context, message: authState.error!);
        }
      }
      return success;
    } finally {
      if (mounted) {
        setState(() => _isDeletingAccount = false);
      }
    }
  }

  Future<void> _sendEmailVerification(AppLocalizations l10n) async {
    setState(() => _isSendingVerification = true);

    try {
      await AuthUIHandler.sendEmailVerification(context: context, l10n: l10n);
    } finally {
      if (mounted) {
        setState(() => _isSendingVerification = false);
      }
    }
  }

  /// Launch a URL in the default browser with timeout and error handling
  Future<void> _launchUrl(String url, AppLocalizations l10n) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final uri = Uri.parse(url);
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication).timeout(
            _operationTimeout,
            onTimeout: () {
              if (mounted) {
                GravitonSnackBar.show(
                  context: context,
                  message: l10n.operationTimeout,
                );
              }
              return false;
            },
          );

      if (!launched && mounted) {
        GravitonSnackBar.show(context: context, message: l10n.couldNotOpenLink);
      }
    } catch (e) {
      FirebaseService.instance.recordError(e, StackTrace.current);
      if (mounted) {
        GravitonSnackBar.show(context: context, message: l10n.couldNotOpenLink);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  /// Check if operation should proceed (not already processing)
  bool _canProceed() {
    if (_isProcessing) {
      return false;
    }
    return true;
  }

  /// Handle rate limiting with user feedback
  void _handleRateLimit(AppLocalizations l10n, {Duration? cooldown}) {
    final message = cooldown != null
        ? l10n.rateLimitWithCooldown(cooldown.inSeconds)
        : l10n.pleaseWaitBeforeRetrying;

    GravitonSnackBar.show(context: context, message: message);
  }
}
