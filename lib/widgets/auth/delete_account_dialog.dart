import 'package:flutter/material.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Dialog for permanently deleting user account
///
/// Shows a warning message and requires password confirmation for
/// email/password accounts. This action is irreversible.
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    final authState = context.read<AuthState>();
    final requiresPassword =
        authState.currentUser?.authProvider == AuthProviderType.emailPassword;

    if (requiresPassword && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await authState.deleteAccount(
      password: requiresPassword ? _passwordController.text : null,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthState>();
    final requiresPassword =
        authState.currentUser?.authProvider == AuthProviderType.emailPassword;

    return AlertDialog(
      backgroundColor: AppColors.backgroundBlack,
      title: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.uiRed,
            size: AppTypography.iconSizeXLarge,
          ),
          const SizedBox(width: AppTypography.spacingMedium),
          Text(
            l10n.deleteAccountTitle,
            style: const TextStyle(
              color: AppColors.uiRed,
              fontSize: AppTypography.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.deleteAccountWarning,
                style: const TextStyle(
                  color: AppColors.uiWhite,
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTypography.spacingMedium),
              Text(
                l10n.deleteAccountMessage,
                style: TextStyle(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  fontSize: AppTypography.fontSizeMedium,
                ),
              ),
              const SizedBox(height: AppTypography.spacingSmall),
              _buildBulletPoint(l10n.deleteAccountItem1),
              _buildBulletPoint(l10n.deleteAccountItem2),
              _buildBulletPoint(l10n.deleteAccountItem3),
              _buildBulletPoint(l10n.deleteAccountItem4),
              const SizedBox(height: AppTypography.spacingLarge),

              if (requiresPassword) ...[
                Text(
                  l10n.deleteAccountPasswordPrompt,
                  style: const TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTypography.spacingMedium),
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
                        color: AppColors.uiRed.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.uiRed.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.uiRed,
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
                    return null;
                  },
                ),
              ],

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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: TextStyle(
              color: _isLoading
                  ? AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityDisabled,
                    )
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacitySemiTransparent,
                    ),
            ),
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
            ),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.uiRed,
                strokeWidth: 2,
              ),
            ),
          )
        else
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.uiRed,
              foregroundColor: AppColors.uiWhite,
            ),
            onPressed: _deleteAccount,
            child: Text(
              l10n.deleteAccountButton,
              style: const TextStyle(
                fontSize: AppTypography.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppTypography.spacingMedium,
        bottom: AppTypography.spacingSmall,
      ),
      child: Row(
        children: [
          Text(
            '•',
            style: TextStyle(
              color: AppColors.uiRed,
              fontSize: AppTypography.fontSizeMedium,
            ),
          ),
          const SizedBox(width: AppTypography.spacingSmall),
          Text(
            text,
            style: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontSize: AppTypography.fontSizeSmall,
            ),
          ),
        ],
      ),
    );
  }
}
