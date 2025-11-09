import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/localization_utils.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';

/// Tab widget displaying preset scenarios
class PresetScenariosTab extends StatelessWidget {
  final ScenarioType currentScenario;
  final ValueChanged<ScenarioType> onScenarioSelected;

  const PresetScenariosTab({
    super.key,
    required this.currentScenario,
    required this.onScenarioSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Filter scenarios to only show those available in the main selection
    final availableScenarios = ScenarioType.values.where((scenario) {
      return ScenarioConfig.defaults.containsKey(scenario) &&
          scenario != ScenarioType.custom;
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      itemCount: availableScenarios.length,
      itemBuilder: (context, index) {
        final scenario = availableScenarios[index];
        final config = ScenarioConfig.defaults[scenario]!;
        final isSelected = scenario == currentScenario;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppTypography.spacingSmall),
          child: PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: isSelected,
            onTap: () {
              // Log analytics for preset scenario selection
              FirebaseService.instance.logUIEventWithEnums(
                UIAction.scenarioSelected,
                element: UIElement.presetScenariosTab,
                value: scenario.name,
              );
              onScenarioSelected(scenario);
            },
          ),
        );
      },
    );
  }
}

/// Individual tile for preset scenarios
class PresetScenarioTile extends StatelessWidget {
  final ScenarioType scenario;
  final ScenarioConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const PresetScenarioTile({
    super.key,
    required this.scenario,
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get localized name and description
    final name = LocalizationUtils.getLocalizedScenarioName(l10n, scenario);
    final description = LocalizationUtils.getLocalizedScenarioDescription(
      l10n,
      scenario,
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? config.primaryColor.withValues(alpha: AppTypography.opacityDisabled)
          : null,
      child: HapticInkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: AppTypography.iconSizeXXXXLarge,
                height: AppTypography.iconSizeXXXXLarge,
                decoration: BoxDecoration(
                  color: config.primaryColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Icon(
                  config.icon,
                  color: config.primaryColor,
                  size: AppTypography.iconSizeXXXLarge,
                ),
              ),

              SizedBox(width: AppTypography.spacingLarge),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: AppTypography.largeText.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected ? config.primaryColor : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: config.primaryColor,
                            size: AppTypography.iconSizeXXLarge,
                          ),
                      ],
                    ),

                    SizedBox(height: AppTypography.spacingXSmall),

                    Text(
                      description,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: AppTypography.spacingSmall),

                    // Learning objectives
                    _buildScenarioObjectives(l10n, scenario),

                    SizedBox(height: AppTypography.spacingMedium),

                    // Metadata
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: AppTypography.iconSizeMedium,
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        SizedBox(width: AppTypography.spacingXSmall),
                        Text(
                          '${config.expectedBodyCount} ${l10n.bodies}',
                          style: AppTypography.smallText.copyWith(
                            color: AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacityMediumHigh,
                            ),
                          ),
                        ),
                        SizedBox(width: AppTypography.spacingLarge),
                        Icon(
                          Icons.school,
                          size: AppTypography.iconSizeMedium,
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        SizedBox(width: AppTypography.spacingXSmall),
                        Expanded(
                          child: Text(
                            LocalizationUtils.getLocalizedEducationalFocus(
                              l10n,
                              config.educationalFocus,
                            ),
                            style: AppTypography.smallText.copyWith(
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityMediumHigh,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioObjectives(
    AppLocalizations l10n,
    ScenarioType scenario,
  ) {
    String learnEmoji = l10n.scenarioLearnEmoji;
    String bestEmoji = l10n.scenarioBestEmoji;
    String learnText = '';
    String bestText = '';

    switch (scenario) {
      case ScenarioType.solarSystem:
        learnText = l10n.scenarioLearnSolar;
        bestText = l10n.scenarioBestSolar;
        break;
      case ScenarioType.earthMoonSun:
        learnText = l10n.scenarioLearnEarthMoon;
        bestText = l10n.scenarioBestEarthMoon;
        break;
      case ScenarioType.binaryStars:
        learnText = l10n.scenarioLearnBinary;
        bestText = l10n.scenarioBestBinary;
        break;
      case ScenarioType.threeBodyClassic:
        learnText = l10n.scenarioLearnThreeBody;
        bestText = l10n.scenarioBestThreeBody;
        break;
      case ScenarioType.random:
        learnText = l10n.scenarioLearnRandom;
        bestText = l10n.scenarioBestRandom;
        break;
      case ScenarioType.asteroidBelt:
        learnText = l10n.scenarioLearnRandom; // Fallback to random objectives
        bestText = l10n.scenarioBestRandom;
        break;
      case ScenarioType.galaxyFormation:
        learnText = l10n.scenarioLearnRandom; // Fallback to random objectives
        bestText = l10n.scenarioBestRandom;
        break;
      default:
        learnText = l10n.scenarioLearnRandom; // Safe fallback
        bestText = l10n.scenarioBestRandom;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              learnEmoji,
              style: AppTypography.smallText.copyWith(
                color: config.primaryColor,
                fontSize: AppTypography.fontSizeXXSmall,
              ),
            ),
            SizedBox(width: AppTypography.spacingXSmall),
            Expanded(
              child: Text(
                learnText,
                style: AppTypography.smallText.copyWith(
                  color: config.primaryColor,
                  fontSize: AppTypography.fontSizeXXSmall,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: AppTypography.spacingXSmall),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bestEmoji,
              style: AppTypography.smallText.copyWith(
                color: config.primaryColor,
                fontSize: AppTypography.fontSizeXXSmall,
              ),
            ),
            SizedBox(width: AppTypography.spacingXSmall),
            Expanded(
              child: Text(
                bestText,
                style: AppTypography.smallText.copyWith(
                  color: config.primaryColor,
                  fontSize: AppTypography.fontSizeXXSmall,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
