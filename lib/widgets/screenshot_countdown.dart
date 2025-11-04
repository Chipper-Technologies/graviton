import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Countdown timer widget for screenshot mode
class ScreenshotCountdown extends StatelessWidget {
  final ScreenshotModeService screenshotService;

  const ScreenshotCountdown({super.key, required this.screenshotService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: screenshotService,
      builder: (context, child) {
        if (!screenshotService.showCountdown) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 100, // Below the app bar
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.uiBlack.withValues(
                  alpha: AppTypography.opacityVeryHigh,
                ),
                borderRadius: BorderRadius.circular(AppTypography.radiusRound),
                border: Border.all(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityLowMedium,
                  ),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    color: AppColors.uiWhite,
                    size: AppTypography.iconSizeXLarge,
                  ),
                  const SizedBox(width: AppTypography.spacingSmall),
                  Text(
                    l10n.screenshotCountdown(
                      screenshotService.countdownSeconds,
                    ),
                    style: const TextStyle(
                      color: AppColors.uiWhite,
                      fontSize: AppTypography.fontSizeLarge,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
