import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/screens/scenario_editor_screen.dart';
import 'package:graviton/services/custom_scenario_manager.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/scenario_selection/create_scenario_tile.dart';
import 'package:graviton/widgets/scenario_selection/custom_scenario_tile.dart';

/// Tab widget displaying custom scenarios with create/manage options
class CustomScenariosTab extends StatefulWidget {
  final ValueChanged<ScenarioType> onScenarioSelected;
  final Function(String)? onCustomScenarioSelected;

  const CustomScenariosTab({
    super.key,
    required this.onScenarioSelected,
    this.onCustomScenarioSelected,
  });

  @override
  State<CustomScenariosTab> createState() => _CustomScenariosTabState();
}

class _CustomScenariosTabState extends State<CustomScenariosTab> {
  List<String> _customScenarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomScenarios();
  }

  Future<void> _loadCustomScenarios() async {
    try {
      final scenarios = await CustomScenarioStorage.getAllScenarios();
      if (mounted) {
        setState(() {
          _customScenarios = scenarios.map((s) => s.metadata.name).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load custom scenarios: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      itemCount: _customScenarios.length + 1, // +1 for create button
      itemBuilder: (context, index) {
        // Create new scenario button (always first)
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppTypography.spacingSmall),
            child: CreateScenarioTile(onTap: () => _createNewScenario(context)),
          );
        }

        // Custom scenario tiles
        final customIndex = index - 1;
        if (customIndex < _customScenarios.length) {
          final customScenarioName = _customScenarios[customIndex];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppTypography.spacingSmall),
            child: CustomScenarioTile(
              scenarioName: customScenarioName,
              isSelected: false, // TODO: Track selected custom scenario
              onTap: () => _selectCustomScenario(context, customScenarioName),
              onEdit: () => _editCustomScenario(context, customScenarioName),
              onDelete: () =>
                  _deleteCustomScenario(context, customScenarioName),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _createNewScenario(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const ScenarioEditorScreen(isEditing: false),
      ),
    );

    if (result == true) {
      // Reload custom scenarios if a new one was saved
      await _loadCustomScenarios();
    }
  }

  void _selectCustomScenario(BuildContext context, String scenarioName) {
    // Log analytics for custom scenario selection
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.customScenarioLoaded,
      element: UIElement.customScenariosTab,
      value: scenarioName,
    );

    // Load the custom scenario into the manager and switch to custom scenario type
    CustomScenarioManager.instance.loadCustomScenario(scenarioName);
    widget.onScenarioSelected(ScenarioType.custom);
  }

  Future<void> _editCustomScenario(
    BuildContext context,
    String scenarioName,
  ) async {
    final customScenario = await CustomScenarioStorage.loadScenario(
      scenarioName,
    );
    if (customScenario == null) return;

    if (!context.mounted) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioEditorScreen(
          isEditing: true,
          initialScenario: customScenario,
        ),
      ),
    );

    if (result == true) {
      // Reload custom scenarios if changes were saved
      await _loadCustomScenarios();
    }
  }

  Future<void> _deleteCustomScenario(
    BuildContext context,
    String scenarioName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await DeleteConfirmationDialog.show(
      context: context,
      title: l10n.deleteScenarioTitle,
      message: l10n.deleteScenarioConfirmMessage(scenarioName),
      titleIcon: Icons.warning_amber_rounded,
    );

    if (confirmed == true) {
      try {
        // Log analytics for scenario deletion
        FirebaseService.instance.logUIEventWithEnums(
          UIAction.customScenarioDeleted,
          element: UIElement.customScenariosTab,
          value: scenarioName,
        );

        await CustomScenarioStorage.deleteScenario(scenarioName);
        await _loadCustomScenarios();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.deleteScenarioSuccessMessage(scenarioName)),
              backgroundColor: AppColors.primaryColor,
            ),
          );
        }
      } catch (e) {
        // Log error analytics
        FirebaseService.instance.logErrorEvent(
          'custom_scenario_deletion_failed',
          errorMessage: e.toString(),
          context: 'custom_scenarios_tab',
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.deleteScenarioFailedMessage(e.toString())),
              backgroundColor: AppColors.celestialRed,
            ),
          );
        }
      }
    }
  }
}
