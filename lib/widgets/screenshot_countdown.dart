import 'package:flutter/material.dart';
import 'package:graviton/services/screenshot_mode_service.dart';

/// Countdown timer widget for screenshot mode
class ScreenshotCountdown extends StatelessWidget {
  final ScreenshotModeService screenshotService;

  const ScreenshotCountdown({super.key, required this.screenshotService});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black87,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Screenshot in ${screenshotService.countdownSeconds}s',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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
