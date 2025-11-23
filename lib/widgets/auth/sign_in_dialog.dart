import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/widgets/auth/social_auth_button.dart';
import 'package:provider/provider.dart';

/// Sign-in dialog with email/password and social auth options
///
/// Provides options for:
/// - Email and password authentication
/// - Google Sign-In
/// - Apple Sign-In (on Apple platforms)
/// - Create new account
/// - Continue as guest
class SignInDialog extends StatefulWidget {
  const SignInDialog({super.key});

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCreatingAccount = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailPasswordAuth() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthState>();
    bool success;

    if (_isCreatingAccount) {
      success = await authState.createAccount(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      success = await authState.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authState = context.read<AuthState>();
    final success = await authState.signInWithGoogle();

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleAppleSignIn() async {
    final authState = context.read<AuthState>();
    final success = await authState.signInWithApple();

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleGuestMode() async {
    final authState = context.read<AuthState>();
    final success = await authState.signInAnonymously();

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthState>();

    return AlertDialog(
      backgroundColor: AppColors.backgroundBlack,
      title: Text(
        _isCreatingAccount ? l10n.createAccountButton : l10n.signInPromptTitle,
        style: const TextStyle(
          color: AppColors.uiWhite,
          fontSize: AppTypography.fontSizeLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email field
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeMedium,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    labelStyle: TextStyle(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.uiRed),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterEmail;
                    }
                    if (!value.contains('@')) {
                      return l10n.pleaseEnterValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTypography.spacingMedium),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeMedium,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.passwordLabel,
                    labelStyle: TextStyle(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.uiRed),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                        size: AppTypography.iconSizeMedium,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterPassword;
                    }
                    if (_isCreatingAccount && value.length < 6) {
                      return l10n.passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTypography.spacingLarge),

                // Email/Password button
                if (authState.isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.backgroundBlack,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTypography.spacingMedium,
                      ),
                    ),
                    onPressed: _handleEmailPasswordAuth,
                    child: Text(
                      _isCreatingAccount
                          ? l10n.createAccountButton
                          : l10n.signInButton,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Toggle create account
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isCreatingAccount = !_isCreatingAccount;
                    });
                  },
                  child: Text(
                    _isCreatingAccount
                        ? l10n.alreadyHaveAccount
                        : l10n.needAccount,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: AppTypography.fontSizeSmall,
                    ),
                  ),
                ),

                // Error message
                if (authState.error != null) ...[
                  const SizedBox(height: AppTypography.spacingMedium),
                  Container(
                    padding: const EdgeInsets.all(AppTypography.spacingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.uiRed.withValues(
                        alpha: AppTypography.opacityBarely,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.uiRed.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                    ),
                    child: Text(
                      authState.error!,
                      style: TextStyle(
                        color: AppColors.uiRed,
                        fontSize: AppTypography.fontSizeSmall,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: AppTypography.spacingLarge),
                const Divider(color: AppColors.uiWhite, height: 1),
                const SizedBox(height: AppTypography.spacingLarge),

                // Social auth buttons
                if (!authState.isLoading) ...[
                  SocialAuthButton(
                    icon: Icons.g_mobiledata,
                    label: l10n.continueWithGoogle,
                    onPressed: _handleGoogleSignIn,
                  ),
                  const SizedBox(height: AppTypography.spacingMedium),

                  if (PlatformUtils.isApple)
                    SocialAuthButton(
                      icon: Icons.apple,
                      label: l10n.continueWithApple,
                      onPressed: _handleAppleSignIn,
                    ),
                  if (PlatformUtils.isApple)
                    const SizedBox(height: AppTypography.spacingMedium),

                  SocialAuthButton(
                    icon: Icons.person_outline,
                    label: l10n.continueAsGuestButton,
                    onPressed: _handleGuestMode,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.closeButton,
            style: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacitySemiTransparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
