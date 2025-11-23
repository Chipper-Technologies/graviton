import 'package:flutter/material.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:provider/provider.dart';

/// Avatar selector dialog for choosing cosmic-themed avatars
///
/// Displays all available UserAvatar options in a grid layout.
/// When selected, updates the user's profile with the chosen avatar.
class AvatarSelectorDialog extends StatefulWidget {
  const AvatarSelectorDialog({super.key});

  @override
  State<AvatarSelectorDialog> createState() => _AvatarSelectorDialogState();
}

class _AvatarSelectorDialogState extends State<AvatarSelectorDialog> {
  UserAvatar? _selectedAvatar;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthState>();
    _selectedAvatar = authState.currentUser?.avatar;
  }

  Future<void> _saveAvatar() async {
    if (_selectedAvatar == null) return;

    setState(() {
      _isLoading = true;
    });

    final authState = context.read<AuthState>();
    final success = await authState.setAvatar(_selectedAvatar!);

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
        l10n.selectAvatarTitle,
        style: const TextStyle(
          color: AppColors.uiWhite,
          fontSize: AppTypography.fontSizeLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: authState.isLoading || _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : GridView.count(
                crossAxisCount: 5,
                mainAxisSpacing: AppTypography.spacingMedium,
                crossAxisSpacing: AppTypography.spacingMedium,
                children: UserAvatar.values.map((avatar) {
                  final isSelected = _selectedAvatar == avatar;
                  return HapticInkWell(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = avatar;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor.withValues(
                                alpha: AppTypography.opacityBarely,
                              )
                            : AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityBarely,
                              ),
                        borderRadius: BorderRadius.circular(12),
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
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.backgroundBlack,
          ),
          onPressed: _isLoading || _selectedAvatar == null ? null : _saveAvatar,
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
