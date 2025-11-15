import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/scenario_selection/preset_scenario_tile.dart';

// Export the tile component
export 'preset_scenario_tile.dart';

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
    final l10n = AppLocalizations.of(context)!;

    // Filter scenarios to only show those available in the main selection
    final availableScenarios = ScenarioType.values.where((scenario) {
      return ScenarioConfig.defaults.containsKey(scenario) &&
          scenario != ScenarioType.custom;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scenarios count header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTypography.spacingXXLarge,
            vertical: AppTypography.spacingMedium,
          ),
          child: Text(
            l10n.scenariosHeaderPlural(availableScenarios.length),
            style: AppTypography.titleText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
          ),
        ),

        // Scenarios list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
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
          ),
        ),
      ],
    );
  }
}
