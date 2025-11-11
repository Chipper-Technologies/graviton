import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/scenario_selection/preset_scenario_tile.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';

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
