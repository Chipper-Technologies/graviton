import 'package:flutter/material.dart';
import 'package:graviton/core/enums/auth_provider_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';

/// Delete account dialog with reauthentication for email/password users
///
/// Shows warning message and requests password for email/password users
/// or confirmation for social auth users before deleting account.
class DeleteAccountWithReauthDialog extends StatefulWidget {
  /// Current user's auth provider
  final AuthProviderType providerType;

  /// Callback when delete is confirmed (with optional password)
  final Future<bool> Function(String? password) onConfirmDelete;

  /// Callback when cancel is pressed
  final VoidCallback onCancel;

  const DeleteAccountWithReauthDialog({
    super.key,
    required this.providerType,
    required this.onConfirmDelete,
    required this.onCancel,
  });

  @override
  State<DeleteAccountWithReauthDialog> createState() =>
      _DeleteAccountWithReauthDialogState();
}

class _DeleteAccountWithReauthDialogState
    extends State<DeleteAccountWithReauthDialog> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isDeleting = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    setState(() {
      _isDeleting = true;
      _error = null;
    });

    try {
      final password = widget.providerType == AuthProviderType.emailPassword
          ? _passwordController.text.trim()
          : null;

      final success = await widget.onConfirmDelete(password);

      if (mounted) {
        if (success) {
          // Success - dialog will be closed by parent
          return;
        } else {
          // Failed - reset spinner
          setState(() {
            _isDeleting = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppConstraints.contentMaxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTypography.spacingXXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size:
                    AppTypography.iconSizeHuge *
                    AppTypography.iconWarningMultiplier,
                color: AppColors.uiRed,
              ),
              const SizedBox(height: AppTypography.spacingXXLarge),
              Text(
                l10n.deleteAccountWarning,
                style: AppTypography.titleText.copyWith(
                  color: AppColors.uiWhite,
                ),
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

              // Password field for email/password users
              if (widget.providerType == AuthProviderType.emailPassword) ...[
                Text(
                  l10n.deleteAccountPasswordPrompt,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTypography.spacingLarge),
                StyledTextField(
                  controller: _passwordController,
                  icon: Icons.lock,
                  labelText: l10n.passwordLabel,
                  hintText: l10n.passwordHint,
                  obscureText: _obscurePassword,
                  enabled: !_isDeleting,
                  onChanged: (_) {}, // No-op, we read from controller
                  suffixIcon: HapticIconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: AppTypography.spacingLarge),
              ],

              // Error message
              if (_error != null) ...[
                Text(
                  _error!,
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.uiRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTypography.spacingLarge),
              ],

              // Delete button
              HapticElevatedButton(
                onPressed: _isDeleting ? null : _handleDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.uiRed,
                  foregroundColor: AppColors.uiWhite,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTypography.spacingLarge,
                  ),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: _isDeleting
                    ? const SizedBox(
                        height: AppTypography.iconSizeLarge,
                        width: AppTypography.iconSizeLarge,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.uiWhite),
                        ),
                      )
                    : Text(l10n.deleteAccountButton),
              ),
              const SizedBox(height: AppTypography.spacingMedium),
              HapticTextButton(
                onPressed: _isDeleting ? null : widget.onCancel,
                child: Text(
                  l10n.cancel,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite,
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
