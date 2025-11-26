import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/account/avatar_display.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';

/// Profile card widget
///
/// Displays user avatar, name, and email with an edit button for avatar selection.
class ProfileCard extends StatelessWidget {
  /// User profile data
  final UserProfile user;

  /// Callback when edit avatar button is pressed
  final VoidCallback onEditAvatar;

  /// Whether the edit button should be disabled
  final bool isDisabled;

  const ProfileCard({
    required this.user,
    required this.onEditAvatar,
    this.isDisabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: Border.all(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          width: AppTypography.borderThin,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AvatarDisplay(
                avatar: user.avatar,
                photoUrl: user.photoUrl,
                size:
                    AppTypography.iconSizeHuge *
                    AppTypography.avatarDisplayMultiplier,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Opacity(
                  opacity: isDisabled ? AppTypography.opacityDisabled : 1.0,
                  child: HapticIconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: AppTypography.iconSizeSmall,
                    ),
                    tooltip: l10n.changeAvatarTooltip,
                    onPressed: isDisabled ? null : onEditAvatar,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.uiWhite,
                      padding: const EdgeInsets.all(
                        AppTypography.spacingXSmall,
                      ),
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTypography.spacingLarge),
          SizedBox(
            width: double.infinity,
            child: Text(
              user.displayName ?? l10n.anonymousUserLabel,
              style: AppTypography.titleText.copyWith(
                color: AppColors.uiWhite,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (user.email != null) ...[
            const SizedBox(height: AppTypography.spacingXSmall),
            Text(
              user.email!,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacitySemiTransparent,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
