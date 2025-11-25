import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/account/terms_acceptance_checkbox.dart';
import 'package:graviton/widgets/auth/social_auth_button.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';

/// Sign-in form widget
///
/// Provides both social sign-in (Google) and email/password authentication.
/// Can be toggled between sign-in and account creation modes.
///
/// Features:
/// - Google sign-in button
/// - Email/password fields
/// - Optional display name field (create account mode)
/// - Terms acceptance checkbox (create account mode)
/// - Toggle between sign-in and create account
class SignInForm extends StatelessWidget {
  /// Form key for validation
  final GlobalKey<FormState> formKey;

  /// Email text controller
  final TextEditingController emailController;

  /// Password text controller
  final TextEditingController passwordController;

  /// Display name text controller (for account creation)
  final TextEditingController nameController;

  /// Whether password is obscured
  final bool obscurePassword;

  /// Whether in account creation mode
  final bool isCreatingAccount;

  /// Whether terms have been accepted (for account creation)
  final bool acceptedTerms;

  /// Email validation error message
  final String? emailError;

  /// Password validation error message
  final String? passwordError;

  /// Callback when Google sign-in is tapped
  final VoidCallback onGoogleSignIn;

  /// Callback when email/password auth is submitted
  final VoidCallback onEmailPasswordAuth;

  /// Callback when password visibility is toggled
  final VoidCallback onTogglePasswordVisibility;

  /// Callback when mode is toggled (sign-in ↔ create account)
  final VoidCallback onToggleMode;

  /// Callback when email field changes
  final ValueChanged<String> onEmailChanged;

  /// Callback when password field changes
  final ValueChanged<String> onPasswordChanged;

  /// Callback when name field changes
  final ValueChanged<String> onNameChanged;

  /// Callback when terms acceptance changes
  final ValueChanged<bool> onTermsChanged;

  /// Callback when Terms of Service is tapped
  final VoidCallback? onTermsTapped;

  /// Callback when Privacy Policy is tapped
  final VoidCallback? onPrivacyTapped;

  /// Whether authentication is in progress
  final bool isProcessing;

  const SignInForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.obscurePassword,
    required this.isCreatingAccount,
    required this.acceptedTerms,
    this.emailError,
    this.passwordError,
    required this.onGoogleSignIn,
    required this.onEmailPasswordAuth,
    required this.onTogglePasswordVisibility,
    required this.onToggleMode,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onNameChanged,
    required this.onTermsChanged,
    this.onTermsTapped,
    this.onPrivacyTapped,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTypography.spacingXLarge),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Google sign-in button
              if (isProcessing)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppTypography.spacingLarge),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                SocialAuthButton(
                  assetPath: 'assets/images/google-logo.svg',
                  animatedBorder: true,
                  label: l10n.continueWithGoogle,
                  onPressed: onGoogleSignIn,
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
              // Display name field (only for account creation)
              if (isCreatingAccount) ...[
                StyledTextField(
                  controller: nameController,
                  icon: Icons.person,
                  labelText: l10n.displayNameLabel,
                  hintText: l10n.displayNameHint,
                  onChanged: onNameChanged,
                ),
                const SizedBox(height: AppTypography.spacingMedium),
              ],
              // Email field
              StyledTextField(
                controller: emailController,
                icon: Icons.email,
                labelText: l10n.emailLabel,
                hintText: l10n.emailHint,
                keyboardType: TextInputType.emailAddress,
                errorText: emailError,
                onChanged: onEmailChanged,
              ),
              const SizedBox(height: AppTypography.spacingMedium),
              // Password field
              StyledTextField(
                controller: passwordController,
                icon: Icons.lock,
                labelText: l10n.passwordLabel,
                hintText: l10n.passwordHint,
                obscureText: obscurePassword,
                errorText: passwordError,
                suffixIcon: HapticIconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacitySemiTransparent,
                    ),
                  ),
                  onPressed: onTogglePasswordVisibility,
                ),
                onChanged: onPasswordChanged,
              ),
              // Terms acceptance (only for account creation)
              if (isCreatingAccount) ...[
                const SizedBox(height: AppTypography.spacingLarge),
                TermsAcceptanceCheckbox(
                  isAccepted: acceptedTerms,
                  onChanged: onTermsChanged,
                  onTermsTapped: onTermsTapped,
                  onPrivacyTapped: onPrivacyTapped,
                ),
              ],
              const SizedBox(height: AppTypography.spacingXXLarge),
              // Submit button
              HapticElevatedButton(
                onPressed: isProcessing || (isCreatingAccount && !acceptedTerms)
                    ? null
                    : onEmailPasswordAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.uiWhite,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTypography.spacingLarge,
                  ),
                ),
                child: Text(
                  isCreatingAccount
                      ? l10n.createAccountButton
                      : l10n.signInButton,
                ),
              ),
              const SizedBox(height: AppTypography.spacingMedium),
              // Toggle mode button
              HapticTextButton(
                onPressed: onToggleMode,
                child: Text(
                  isCreatingAccount
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
}
