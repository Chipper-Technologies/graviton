import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Empty state widget for live session screens
///
/// Displays an icon and message when no sessions are available.
class SessionEmptyState extends StatelessWidget {
  /// The message to display
  final String message;

  /// The icon to display (defaults to wifi_tethering_off)
  final IconData icon;

  const SessionEmptyState({
    required this.message,
    this.icon = Icons.wifi_tethering_off,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTypography.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              size: AppTypography.iconSizeXXXLarge,
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            Text(
              message,
              style: TextStyle(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
                fontSize: AppTypography.fontSizeMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
