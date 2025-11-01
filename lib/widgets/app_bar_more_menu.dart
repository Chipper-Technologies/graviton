import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// App bar menu for secondary functions (help, scenarios, settings)
class AppBarMoreMenu extends StatelessWidget {
  final VoidCallback onShowHelp;
  final VoidCallback onShowSettings;
  final VoidCallback onShowScenarios;
  final VoidCallback onShowPhysicsSettings;

  const AppBarMoreMenu({
    super.key,
    required this.onShowHelp,
    required this.onShowSettings,
    required this.onShowScenarios,
    required this.onShowPhysicsSettings,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      tooltip: l10n.moreOptionsTooltip,
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'scenarios':
            onShowScenarios();
            break;
          case 'physics':
            onShowPhysicsSettings();
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
              const SizedBox(width: AppTypography.spacingMedium),
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
                    l10n.scenariosMenuDescription,
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
          value: 'physics',
          child: Row(
            children: [
              const Icon(
                Icons.science,
                size: 20,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.physicsSettingsTitle,
                    style: AppTypography.mediumText.copyWith(
                      color: AppColors.uiWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    l10n.physicsSettingsDescription,
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
              const SizedBox(width: AppTypography.spacingMedium),
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
                    l10n.settingsMenuDescription,
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
              const SizedBox(width: AppTypography.spacingMedium),
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
                    l10n.helpMenuDescription,
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
      color: AppColors.uiBlack.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        side: BorderSide(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
          width: 1,
        ),
      ),
    );
  }
}
