import 'package:flutter/material.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';

/// Avatar selection grid widget
///
/// Displays a grid of avatar options (emoji-based) for the user to choose from.
/// Optionally shows a profile photo option if available (from social auth).
///
/// Features:
/// - Profile photo option (if available)
/// - Grid of emoji avatars
/// - Visual selection indicator
/// - Save and cancel buttons
class AvatarSelectionGrid extends StatelessWidget {
  /// Currently selected avatar (null means profile photo is selected)
  final UserAvatar? selectedAvatar;

  /// User's profile photo URL (from social auth providers)
  final String? photoUrl;

  /// Callback when avatar is selected
  final ValueChanged<UserAvatar?> onAvatarSelected;

  /// Callback when save button is pressed
  final VoidCallback onSave;

  /// Callback when cancel button is pressed
  final VoidCallback onCancel;

  const AvatarSelectionGrid({
    super.key,
    required this.selectedAvatar,
    this.photoUrl,
    required this.onAvatarSelected,
    required this.onSave,
    required this.onCancel,
  });

  bool get _hasProfilePhoto => photoUrl != null && photoUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        children: [
          // Profile photo option
          if (_hasProfilePhoto) ...[
            GestureDetector(
              onTap: () => onAvatarSelected(null),
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
                    color: selectedAvatar == null
                        ? AppColors.primaryColor
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityFaint,
                          ),
                    width: selectedAvatar == null ? 3 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        photoUrl!,
                        width: AppTypography.avatarSelectionSize,
                        height: AppTypography.avatarSelectionSize,
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
          // Avatar grid
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
                final isSelected = selectedAvatar == avatar;

                return GestureDetector(
                  onTap: () => onAvatarSelected(avatar),
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
          // Save button
          HapticElevatedButton(
            onPressed: onSave,
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
          // Cancel button
          Center(
            child: HapticTextButton(
              onPressed: onCancel,
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
}
