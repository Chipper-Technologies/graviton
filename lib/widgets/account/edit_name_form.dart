import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';

/// Edit name form widget
///
/// Simple form for editing the user's display name.
/// Contains a single text field and save button.
class EditNameForm extends StatelessWidget {
  /// Text controller for the name field
  final TextEditingController nameController;

  /// Callback when save button is pressed
  final VoidCallback onSave;

  /// Callback when name field changes
  final ValueChanged<String> onChanged;

  const EditNameForm({
    super.key,
    required this.nameController,
    required this.onSave,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstraints.contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppTypography.spacingXLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StyledTextField(
                controller: nameController,
                icon: Icons.person,
                labelText: l10n.displayNameFieldLabel,
                hintText: l10n.displayNameFieldHint,
                onChanged: onChanged,
              ),
              const SizedBox(height: AppTypography.spacingXXLarge),
              HapticElevatedButton(
                onPressed: onSave,
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
        ),
      ),
    );
  }
}
