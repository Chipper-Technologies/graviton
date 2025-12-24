import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Badge displaying the number of viewers for a live session
///
/// Can be styled in two variants:
/// - [ViewerCountBadgeStyle.solid]: Solid background with white text
/// - [ViewerCountBadgeStyle.subtle]: Semi-transparent background with primary color
class ViewerCountBadge extends StatelessWidget {
  /// The number of viewers to display
  final int count;

  /// The visual style of the badge
  final ViewerCountBadgeStyle style;

  const ViewerCountBadge({
    required this.count,
    this.style = ViewerCountBadgeStyle.solid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isSolid = style == ViewerCountBadgeStyle.solid;
    final backgroundColor = isSolid
        ? AppColors.primaryColor
        : AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityMidFade,
          );
    final contentColor = isSolid ? AppColors.uiWhite : AppColors.primaryColor;
    final horizontalPadding = isSolid
        ? AppTypography.spacingSmall
        : AppTypography.spacingMedium;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppTypography.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.visibility,
            color: contentColor,
            size: AppTypography.iconSizeSmall,
          ),
          const SizedBox(width: AppTypography.spacingXSmall),
          Text(
            l10n.liveSessionViewerCount(count),
            style: TextStyle(
              color: contentColor,
              fontSize: isSolid
                  ? AppTypography.fontSizeXSmall
                  : AppTypography.fontSizeSmall,
              fontWeight: isSolid ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Visual style for [ViewerCountBadge]
enum ViewerCountBadgeStyle {
  /// Solid background with white text
  solid,

  /// Semi-transparent background with primary colored text
  subtle,
}
