import 'package:flutter/material.dart';
import 'package:graviton/constants/educational_focus_keys.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';

/// A dialog that allows users to select a preset astronomical scenario
class ScenarioSelectionDialog extends StatelessWidget {
  final ScenarioType currentScenario;
  final ValueChanged<ScenarioType> onScenarioSelected;

  const ScenarioSelectionDialog({
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
      ),
      child: Container(
        constraints: AppConstraints.dialogMedium,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with close button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.uiCyanAccent.withValues(alpha: 0.15),
                    AppColors.uiCyanAccent.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTypography.radiusXLarge),
                  topRight: Radius.circular(AppTypography.radiusXLarge),
                ),
              ),
              padding: EdgeInsets.all(AppTypography.spacingLarge),
              child: Row(
                children: [
                  Icon(Icons.explore, color: AppColors.uiCyanAccent, size: 28),
                  SizedBox(width: AppTypography.spacingMedium),
                  Text(
                    l10n.selectScenarioTooltip,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Scenario list
            Flexible(
              child: Padding(
                padding: AppConstraints.dialogPadding,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: availableScenarios.length,
                  itemBuilder: (context, index) {
                    final scenario = availableScenarios[index];
                    final config = ScenarioConfig.defaults[scenario]!;
                    final isSelected = scenario == currentScenario;

                    return _ScenarioTile(
                      scenario: scenario,
                      config: config,
                      isSelected: isSelected,
                      onTap: () => _selectScenario(context, scenario),
                    );
                  },
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
            ),
          ],
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
    final name = _getLocalizedName(l10n, scenario);
    final description = _getLocalizedDescription(l10n, scenario);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? config.primaryColor.withValues(alpha: AppTypography.opacityDisabled)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Padding(
          padding: EdgeInsets.all(AppTypography.spacingLarge),
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
                  borderRadius: BorderRadius.circular(
                    AppTypography.spacingXXLarge,
                  ),
                ),
                child: Icon(config.icon, color: config.primaryColor, size: 24),
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
                            size: 20,
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
                    Container(
                      padding: EdgeInsets.only(
                        left: AppTypography.spacingSmall,
                        right: AppTypography.spacingSmall,
                      ),
                      child: _buildScenarioObjectives(l10n, scenario),
                    ),

                    SizedBox(height: AppTypography.spacingMedium),

                    // Metadata
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 14,
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
                          size: 14,
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        SizedBox(width: AppTypography.spacingXSmall),
                        Expanded(
                          child: Text(
                            _getLocalizedEducationalFocus(l10n, scenario),
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

  String _getLocalizedName(AppLocalizations l10n, ScenarioType scenario) {
    switch (scenario) {
      case ScenarioType.random:
        return l10n.scenarioRandom;
      case ScenarioType.earthMoonSun:
        return l10n.scenarioEarthMoonSun;
      case ScenarioType.binaryStars:
        return l10n.scenarioBinaryStars;
      case ScenarioType.asteroidBelt:
        return l10n.scenarioAsteroidBelt;
      case ScenarioType.galaxyFormation:
        return l10n.scenarioGalaxyFormation;
      case ScenarioType.solarSystem:
        return l10n.scenarioSolarSystem;
      case ScenarioType.threeBodyClassic:
      case ScenarioType.collisionDemo:
      case ScenarioType.deepSpace:
        // These scenarios are used by screenshot presets but not available in the main scenario selection
        return 'Special Scenario';
    }
  }

  String _getLocalizedDescription(
    AppLocalizations l10n,
    ScenarioType scenario,
  ) {
    switch (scenario) {
      case ScenarioType.random:
        return l10n.scenarioRandomDescription;
      case ScenarioType.earthMoonSun:
        return l10n.scenarioEarthMoonSunDescription;
      case ScenarioType.binaryStars:
        return l10n.scenarioBinaryStarsDescription;
      case ScenarioType.asteroidBelt:
        return l10n.scenarioAsteroidBeltDescription;
      case ScenarioType.galaxyFormation:
        return l10n.scenarioGalaxyFormationDescription;
      case ScenarioType.solarSystem:
        return l10n.scenarioSolarSystemDescription;
      case ScenarioType.threeBodyClassic:
      case ScenarioType.collisionDemo:
      case ScenarioType.deepSpace:
        // These scenarios are used by screenshot presets but not available in the main scenario selection
        return 'Special scenario for screenshot mode.';
    }
  }

  String _getLocalizedEducationalFocus(
    AppLocalizations l10n,
    ScenarioType scenario,
  ) {
    final config = ScenarioConfig.defaults[scenario];

    // Return fallback for scenarios without config (screenshot-only scenarios)
    if (config == null) {
      return 'Special scenario';
    }

    // Map educational focus keys to localized strings
    switch (config.educationalFocus) {
      case EducationalFocusKeys.chaoticDynamics:
        return l10n.educationalFocusChaoticDynamics;
      case EducationalFocusKeys.realWorldSystem:
        return l10n.educationalFocusRealWorldSystem;
      case EducationalFocusKeys.binaryOrbits:
        return l10n.educationalFocusBinaryOrbits;
      case EducationalFocusKeys.manyBodyDynamics:
        return l10n.educationalFocusManyBodyDynamics;
      case EducationalFocusKeys.structureFormation:
        return l10n.educationalFocusStructureFormation;
      case EducationalFocusKeys.planetaryMotion:
        return l10n.educationalFocusPlanetaryMotion;
      default:
        // Fallback for unknown keys
        return config.educationalFocus;
    }
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
            SizedBox(width: AppTypography.spacingXSmall),
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
        SizedBox(height: AppTypography.spacingXSmall),
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
            SizedBox(width: AppTypography.spacingXSmall),
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
