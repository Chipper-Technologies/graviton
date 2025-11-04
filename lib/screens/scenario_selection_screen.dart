import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/localization_utils.dart';

/// Full-screen scenario selection page with transparent background
class ScenarioSelectionScreen extends StatelessWidget {
  final ScenarioType currentScenario;
  final ValueChanged<ScenarioType> onScenarioSelected;

  const ScenarioSelectionScreen({
    super.key,
    required this.currentScenario,
    required this.onScenarioSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Filter scenarios to only show those available in the main selection
    // (excluding screenshot-only scenarios: threeBodyClassic, collisionDemo, deepSpace)
    final availableScenarios = ScenarioType.values.where((scenario) {
      return ScenarioConfig.defaults.containsKey(scenario);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.selectScenarioTooltip),
        backgroundColor: AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityNearlyOpaque,
        ),
        foregroundColor: AppColors.uiWhite,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityNearlyOpaque,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: AppTypography.spacingMedium,
                bottom: AppTypography.spacingXXLarge,
              ),
              itemCount: availableScenarios.length,
              itemBuilder: (context, index) {
                final scenario = availableScenarios[index];
                final config = ScenarioConfig.defaults[scenario]!;
                final isSelected = scenario == currentScenario;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppTypography.spacingSmall,
                  ),
                  child: _ScenarioTile(
                    scenario: scenario,
                    config: config,
                    isSelected: isSelected,
                    onTap: () => _selectScenario(context, scenario),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _selectScenario(BuildContext context, ScenarioType scenario) {
    onScenarioSelected(scenario);
    Navigator.of(context).pop();
  }
}

class _ScenarioTile extends StatelessWidget {
  final ScenarioType scenario;
  final ScenarioConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScenarioTile({
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: config.primaryColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Icon(config.icon, color: config.primaryColor, size: 28),
              ),

              const SizedBox(width: 16),

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
                            size: 24,
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

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

                    const SizedBox(height: 8),

                    // Learning objectives
                    _buildScenarioObjectives(l10n, scenario),

                    const SizedBox(height: 12),

                    // Metadata
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 16,
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${config.expectedBodyCount} ${l10n.bodies}',
                          style: AppTypography.smallText.copyWith(
                            color: AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacityMediumHigh,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.school,
                          size: 16,
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        const SizedBox(width: 4),
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
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                learnText,
                style: AppTypography.smallText.copyWith(
                  color: config.primaryColor,
                  fontSize: 11,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bestEmoji,
              style: AppTypography.smallText.copyWith(
                color: config.primaryColor,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                bestText,
                style: AppTypography.smallText.copyWith(
                  color: config.primaryColor,
                  fontSize: 11,
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
