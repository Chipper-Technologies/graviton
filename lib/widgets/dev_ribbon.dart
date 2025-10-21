import 'package:flutter/material.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A banner widget that displays "DEV" in the top-right corner when in development mode
class DevRibbon extends StatelessWidget {
  final Widget child;

  const DevRibbon({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!FlavorConfig.instance.isDevelopment) {
      return child;
    }

    final screenshotService = ScreenshotModeService();

    return ListenableBuilder(
      listenable: screenshotService,
      builder: (context, _) {
        // Hide dev ribbon when screenshot mode is active
        if (screenshotService.isActive) {
          return child;
        }

        return Banner(
          message: 'DEV',
          location: BannerLocation.topEnd,
          color: AppColors.testRed,
          shadow: const BoxShadow(color: AppColors.uiBlack, blurRadius: 4, offset: Offset(2, 2)),
          textStyle: const TextStyle(
            color: AppColors.uiWhite,
            fontSize: AppTypography.fontSizeSmall,
            fontWeight: FontWeight.bold,
          ),
          child: child,
        );
      },
    );
  }
}
