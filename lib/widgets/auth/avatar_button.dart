import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';
import 'package:provider/provider.dart';

/// Avatar button widget for AppBar
///
/// Shows user's avatar or default icon. Taps navigate to account management.
class AvatarButton extends StatelessWidget {
  final VoidCallback onTap;

  const AvatarButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AuthState>(
      builder: (context, authState, child) {
        final user = authState.currentUser;

        return Padding(
          padding: const EdgeInsets.only(left: AppTypography.spacingLarge),
          child: HapticGestureDetector(
            onTap: onTap,
            child: Tooltip(
              message: l10n.accountButtonTooltip,
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                  color: user == null
                      ? AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityBarely,
                        )
                      : null,
                ),
                child: _buildAvatarContent(user),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarContent(dynamic user) {
    if (user == null) {
      // Not signed in - show default icon
      return Icon(
        Icons.account_circle_outlined,
        size: AppTypography.iconSizeXLarge,
        color: AppColors.uiWhite,
      );
    }

    // Prioritize custom avatar over social profile photo
    if (user.avatar != null) {
      return Center(
        child: Text(user.avatar!.emoji, style: const TextStyle(fontSize: 20)),
      );
    }

    // Check for social profile photo
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          user.photoUrl!,
          fit: BoxFit.cover,
          width: 32,
          height: 32,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar(user);
          },
        ),
      );
    }

    return _buildDefaultAvatar(user);
  }

  Widget _buildDefaultAvatar(dynamic user) {
    return Icon(
      Icons.account_circle,
      size: AppTypography.iconSizeXLarge,
      color: AppColors.primaryColor,
    );
  }
}
