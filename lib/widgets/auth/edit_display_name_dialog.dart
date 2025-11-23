import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Dialog for editing user's display name
///
/// Allows users to update their display name shown in their profile.
/// Validates that the name is not empty before saving.
class EditDisplayNameDialog extends StatefulWidget {
  final String? currentName;

  const EditDisplayNameDialog({super.key, this.currentName});

  @override
  State<EditDisplayNameDialog> createState() => _EditDisplayNameDialogState();
}

class _EditDisplayNameDialogState extends State<EditDisplayNameDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authState = context.read<AuthState>();
    final success = await authState.updateDisplayName(
      _nameController.text.trim(),
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

    return AlertDialog(
      backgroundColor: AppColors.backgroundBlack,
      title: Text(
        l10n.editDisplayNameTitle,
        style: const TextStyle(
          color: AppColors.uiWhite,
          fontSize: AppTypography.fontSizeLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(
                  color: AppColors.uiWhite,
                  fontSize: AppTypography.fontSizeMedium,
                ),
                decoration: InputDecoration(
                  labelText: l10n.displayNameLabel,
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
                autofocus: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterDisplayName;
                  }
                  if (value.trim().length < 2) {
                    return l10n.displayNameMinLength;
                  }
                  return null;
                },
              ),
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
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
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
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            ),
          )
        else
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.backgroundBlack,
            ),
            onPressed: _saveName,
            child: Text(
              l10n.saveButton,
              style: const TextStyle(
                fontSize: AppTypography.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
