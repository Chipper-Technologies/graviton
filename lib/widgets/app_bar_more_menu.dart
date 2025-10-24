import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// App bar menu for secondary functions (help, scenarios, settings)
class AppBarMoreMenu extends StatelessWidget {
  final VoidCallback onShowHelp;
  final VoidCallback onShowSettings;
  final VoidCallback onShowScenarios;

  const AppBarMoreMenu({
    super.key,
    required this.onShowHelp,
    required this.onShowSettings,
    required this.onShowScenarios,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      tooltip: 'More options',
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'scenarios':
            onShowScenarios();
            break;
          case 'settings':
            onShowSettings();
            break;
          case 'help':
            onShowHelp();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'scenarios',
          child: Row(
            children: [
              const Icon(
                Icons.explore,
                size: 20,
                color: AppColors.uiCyanAccent,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.selectScenarioTooltip,
                    style: AppTypography.mediumText.copyWith(
                      color: AppColors.uiWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Explore different scenarios',
                    style: AppTypography.smallText.copyWith(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          child: Divider(
            color: AppColors.uiDividerGrey,
            thickness: 1,
            height: 1,
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.tune, size: 20, color: AppColors.uiOrangeAccent),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.settingsTitle,
                    style: AppTypography.mediumText.copyWith(
                      color: AppColors.uiWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Visual & behavior options',
                    style: AppTypography.smallText.copyWith(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          child: Divider(
            color: AppColors.uiDividerGrey,
            thickness: 1,
            height: 1,
          ),
        ),
        PopupMenuItem<String>(
          value: 'help',
          child: Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.showHelpTooltip,
                    style: AppTypography.mediumText.copyWith(
                      color: AppColors.uiWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Tutorial & objectives',
                    style: AppTypography.smallText.copyWith(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      color: AppColors.uiBlack.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.uiWhite.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
    );
  }
}
