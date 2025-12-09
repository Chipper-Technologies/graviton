import 'package:flutter/material.dart';
import 'package:graviton/core/enums/user_avatar.dart';
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
    this.size = AppTypography.avatarDisplaySize,
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
        ),
        child: ClipOval(
          child: Image.network(
            photoUrl!,
            fit: BoxFit.cover,
            width: size,
            height: size,
            cacheWidth: (size * MediaQuery.of(context).devicePixelRatio)
                .round(),
            cacheHeight: (size * MediaQuery.of(context).devicePixelRatio)
                .round(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Fallback to default avatar icon on error (e.g., 429 rate limit)
              return Container(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityVeryFaint,
                ),
                child: Icon(
                  Icons.account_circle,
                  size: size * 0.67,
                  color: AppColors.primaryColor,
                ),
              );
            },
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
