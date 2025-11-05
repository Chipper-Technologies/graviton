import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/screens/about_screen.dart';
import 'package:graviton/widgets/common/haptic_gesture_detector.dart';

/// Copyright text widget positioned in bottom center
class CopyrightText extends StatelessWidget {
  const CopyrightText({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Positioned(
      bottom: 10, // Moved down from 20
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          // Removed background and border for cleaner look
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '© $currentYear ${AppLocalizations.of(context)!.companyName}. ',
                style: TextStyle(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              HapticGestureDetector(
                onTap: () => _showAbout(context),
                child: Text(
                  AppLocalizations.of(context)!.aboutButtonTooltip,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    fontSize: AppTypography.fontSizeSmall,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary
                        .withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AboutScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false,
      ),
    );
  }
}
