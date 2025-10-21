import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/l10n/app_localizations.dart';

import 'about_dialog.dart';

/// Copyright text widget positioned in bottom center
class CopyrightText extends StatelessWidget {
  const CopyrightText({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.uiBlack.withValues(alpha: AppTypography.opacitySemiTransparent),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityDisabled), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '© $currentYear ${AppLocalizations.of(context)!.companyName}. ',
                style: TextStyle(
                  color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityMedium),
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              GestureDetector(
                onTap: () => _showAbout(context),
                child: Text(
                  AppLocalizations.of(context)!.aboutButtonTooltip,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: AppTypography.opacityHigh),
                    fontSize: AppTypography.fontSizeSmall,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: AppTypography.opacitySemiTransparent),
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
    showDialog<void>(context: context, builder: (context) => const AppAboutDialog());
  }
}
