import 'package:flutter/material.dart';
import 'package:graviton/constants/educational_focus_keys.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_config.dart';
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
    final theme = Theme.of(context);

    // Filter scenarios to only show those available in the main selection
    // (excluding screenshot-only scenarios: threeBodyClassic, collisionDemo, deepSpace)
    final availableScenarios = ScenarioType.values.where((scenario) {
      return ScenarioConfig.defaults.containsKey(scenario);
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.science, color: theme.primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    l10n.scenarioSelectionTitle,
                    style: AppTypography.titleText.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Scenario list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
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
    final theme = Theme.of(context);

    // Get localized name and description
    final name = _getLocalizedName(l10n, scenario);
    final description = _getLocalizedDescription(l10n, scenario);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? config.primaryColor.withValues(alpha: AppTypography.opacityDisabled)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(config.icon, color: config.primaryColor, size: 24),
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
                            size: 20,
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style: AppTypography.smallText.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Learning objectives
                    Text(
                      _getScenarioObjectives(l10n, scenario),
                      style: AppTypography.smallText.copyWith(
                        color: config.primaryColor,
                        fontSize: 11,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Metadata
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 14,
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${config.expectedBodyCount} ${l10n.bodies}',
                          style: AppTypography.smallText.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: AppTypography.opacityMediumHigh,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.school,
                          size: 14,
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getLocalizedEducationalFocus(l10n, scenario),
                            style: AppTypography.smallText.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(
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

  String _getScenarioObjectives(AppLocalizations l10n, ScenarioType scenario) {
    switch (scenario) {
      case ScenarioType.solarSystem:
        return l10n.scenarioObjectivesSolar;
      case ScenarioType.earthMoonSun:
        return l10n.scenarioObjectivesEarthMoon;
      case ScenarioType.binaryStars:
        return l10n.scenarioObjectivesBinary;
      case ScenarioType.threeBodyClassic:
        return l10n.scenarioObjectivesThreeBody;
      case ScenarioType.random:
        return l10n.scenarioObjectivesRandom;
      case ScenarioType.asteroidBelt:
        return l10n.scenarioObjectivesRandom; // Fallback to random objectives
      case ScenarioType.galaxyFormation:
        return l10n.scenarioObjectivesRandom; // Fallback to random objectives
      default:
        return l10n.scenarioObjectivesRandom; // Safe fallback
    }
  }
}
