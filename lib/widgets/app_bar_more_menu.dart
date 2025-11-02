import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graviton/enums/app_bar_menu_item.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// App bar menu for secondary functions (help, scenarios, settings)
class AppBarMoreMenu extends StatelessWidget {
  final VoidCallback onShowHelp;
  final VoidCallback onShowSettings;
  final VoidCallback onShowScenarios;
  final VoidCallback onShowPhysicsSettings;
  final VoidCallback onShowAbout;
  final VoidCallback onShowDeveloperTools;

  const AppBarMoreMenu({
    super.key,
    required this.onShowHelp,
    required this.onShowSettings,
    required this.onShowScenarios,
    required this.onShowPhysicsSettings,
    required this.onShowAbout,
    required this.onShowDeveloperTools,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<AppBarMenuItem>(
      tooltip: l10n.moreOptionsTooltip,
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case AppBarMenuItem.scenarios:
            onShowScenarios();
            break;
          case AppBarMenuItem.physics:
            onShowPhysicsSettings();
            break;
          case AppBarMenuItem.settings:
            onShowSettings();
            break;
          case AppBarMenuItem.help:
            onShowHelp();
            break;
          case AppBarMenuItem.about:
            onShowAbout();
            break;
          case AppBarMenuItem.developerTools:
            onShowDeveloperTools();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<AppBarMenuItem>(
          value: AppBarMenuItem.scenarios,
          child: Row(
            children: [
              Icon(
                Icons.explore,
                size: 20,
                color: AppColors.sectionTitlePurple,
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<AppBarMenuItem>(
          enabled: false,
          height: 1,
          child: Divider(
            color: AppColors.uiDividerGrey,
            thickness: 1,
            height: 1,
          ),
        ),
        PopupMenuItem<AppBarMenuItem>(
          value: AppBarMenuItem.physics,
          child: Row(
            children: [
              Icon(
                Icons.science,
                size: 20,
                color: AppColors.sectionTitlePurple,
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<AppBarMenuItem>(
          enabled: false,
          height: 1,
          child: Divider(
            color: AppColors.uiDividerGrey,
            thickness: 1,
            height: 1,
          ),
        ),
        PopupMenuItem<AppBarMenuItem>(
          value: AppBarMenuItem.settings,
          child: Row(
            children: [
              Icon(Icons.tune, size: 20, color: AppColors.sectionTitlePurple),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<AppBarMenuItem>(
          enabled: false,
          height: 1,
          child: Divider(
            color: AppColors.uiDividerGrey,
            thickness: 1,
            height: 1,
          ),
        ),
        PopupMenuItem<AppBarMenuItem>(
          value: AppBarMenuItem.help,
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: AppColors.sectionTitlePurple,
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<AppBarMenuItem>(
          enabled: false,
          height: 1,
          child: Divider(
            color: AppColors.uiDividerGrey,
            thickness: 1,
            height: 1,
          ),
        ),
        // Developer Tools (Debug only)
        if (kDebugMode) ...[
          PopupMenuItem<AppBarMenuItem>(
            enabled: false,
            height: 1,
            child: Divider(
              color: AppColors.uiDividerGrey,
              thickness: 1,
              height: 1,
            ),
          ),
          PopupMenuItem<AppBarMenuItem>(
            value: AppBarMenuItem.developerTools,
            child: Row(
              children: [
                Icon(
                  Icons.developer_mode,
                  size: 20,
                  color: AppColors.sectionTitlePurple,
                ),
                const SizedBox(width: AppTypography.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.developerToolsTitle,
                        style: AppTypography.mediumText.copyWith(
                          color: AppColors.uiWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        l10n.developerToolsMenuDescription,
                        style: AppTypography.smallText.copyWith(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacitySemiTransparent,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<AppBarMenuItem>(
            enabled: false,
            height: 1,
            child: Divider(
              color: AppColors.uiDividerGrey,
              thickness: 1,
              height: 1,
            ),
          ),
        ],
        PopupMenuItem<AppBarMenuItem>(
          value: AppBarMenuItem.about,
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: AppColors.sectionTitlePurple,
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.aboutButtonTooltip,
                      style: AppTypography.mediumText.copyWith(
                        color: AppColors.uiWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      l10n.aboutMenuDescription,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacitySemiTransparent,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
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
