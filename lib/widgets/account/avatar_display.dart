import 'package:flutter/material.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Avatar display widget
///
/// Displays user avatar with priority: custom avatar > photo URL > default icon
class AvatarDisplay extends StatelessWidget {
  /// Selected custom avatar
  final UserAvatar? avatar;

  /// Photo URL from social auth provider
  final String? photoUrl;

  /// Size of the avatar
  final double size;

  const AvatarDisplay({
    this.avatar,
    this.photoUrl,
    this.size = 96.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Prioritize custom avatar over Google/Apple photo
    if (avatar != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: AppTypography.borderThick,
          ),
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
        ),
        child: Center(
          child: Text(avatar!.emoji, style: TextStyle(fontSize: size * 0.5)),
        ),
      );
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: AppTypography.borderThick,
          ),
          image: DecorationImage(
            image: NetworkImage(photoUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: AppTypography.borderThick,
          ),
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
        ),
        child: Icon(
          Icons.account_circle,
          size: size * 0.67,
          color: AppColors.primaryColor,
        ),
      );
    }
  }
}
