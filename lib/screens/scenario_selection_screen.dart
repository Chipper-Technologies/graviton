import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/common/haptic_app_bar.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/common/haptic_floating_action_button.dart';
import 'package:graviton/widgets/scenario_selection/preset_scenarios_tab.dart';
import 'package:graviton/widgets/scenario_selection/custom_scenarios_tab.dart';
import 'package:graviton/screens/scenario_editor_screen.dart';

/// Full-screen scenario selection page with tabbed interface
class ScenarioSelectionScreen extends StatefulWidget {
  final ScenarioType currentScenario;
  final ValueChanged<ScenarioType> onScenarioSelected;
  final Function(String)? onCustomScenarioSelected;

  const ScenarioSelectionScreen({
    super.key,
    required this.currentScenario,
    required this.onScenarioSelected,
    this.onCustomScenarioSelected,
  });

  @override
  State<ScenarioSelectionScreen> createState() =>
      _ScenarioSelectionScreenState();
}

class _ScenarioSelectionScreenState extends State<ScenarioSelectionScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      extendBodyBehindAppBar: true,
      appBar: HapticAppBar(
        title: l10n.selectScenarioTooltip,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: _currentTabIndex == 1 ? _buildFAB(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: GravitonTabbedView(
          onTabChanged: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          tabs: [
            GravitonTab(
              icon: Icons.explore,
              label:
                  AppLocalizations.of(context)?.scenarioTabPresets ?? 'Presets',
            ),
            GravitonTab(
              icon: Icons.palette,
              label:
                  AppLocalizations.of(context)?.scenarioTabCustom ?? 'Custom',
            ),
          ],
          children: [
            PresetScenariosTab(
              currentScenario: widget.currentScenario,
              onScenarioSelected: widget.onScenarioSelected,
            ),
            CustomScenariosTab(
              onScenarioSelected: widget.onScenarioSelected,
              onCustomScenarioSelected: widget.onCustomScenarioSelected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return HapticFloatingActionButton.extended(
      onPressed: () => _createNewScenario(context),
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.uiWhite,
      elevation: 8,
      icon: const Icon(Icons.add),
      label: Text(
        AppLocalizations.of(context)!.createScenarioButton,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _createNewScenario(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const ScenarioEditorScreen(isEditing: false),
      ),
    );

    // If a scenario was created, we might want to switch to the custom tab
    // and refresh the custom scenarios list
    if (result == true) {
      // The CustomScenariosTab will automatically reload when it's rebuilt
      setState(() {
        // This will trigger a rebuild which refreshes the custom scenarios
      });
    }
  }
}
