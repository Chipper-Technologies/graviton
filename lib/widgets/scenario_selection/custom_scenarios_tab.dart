import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/experimental_scenario_config.dart';
import 'package:graviton/screens/scenario_editor_screen.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/scenario_selection/create_scenario_tile.dart';
import 'package:graviton/widgets/scenario_selection/custom_scenario_tile.dart';
import 'package:graviton/widgets/scenario_selection/experimental_scenario_tile.dart';

/// Tab widget displaying custom scenarios with create/manage options
class CustomScenariosTab extends StatefulWidget {
  final ValueChanged<ScenarioType> onScenarioSelected;
  final Function(String)? onCustomScenarioSelected;
  final ScrollController? scrollController;

  const CustomScenariosTab({
    super.key,
    required this.onScenarioSelected,
    this.onCustomScenarioSelected,
    this.scrollController,
  });

  @override
  State<CustomScenariosTab> createState() => _CustomScenariosTabState();
}

class _CustomScenariosTabState extends State<CustomScenariosTab> {
  List<String> _customScenarios = [];
  bool _isLoading = true;
  String? _selectedExperiment;

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

    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create New Scenario button
          CreateScenarioTile(onTap: () => _createNewScenario(context)),

          // Saved Scenarios section
          SectionDivider.labeled(
            l10n.savedScenariosTitle,
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingMedium,
          ),

          // Saved scenarios list
          if (_customScenarios.isEmpty)
            _buildEmptyState(l10n)
          else
            ..._customScenarios.map((scenarioName) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppTypography.spacingSmall),
                child: CustomScenarioTile(
                  scenarioName: scenarioName,
                  isSelected: false,
                  onTap: () => _selectCustomScenario(context, scenarioName),
                  onEdit: () => _editCustomScenario(context, scenarioName),
                  onDelete: () => _deleteCustomScenario(context, scenarioName),
                ),
              );
            }),

          // Experiments section
          SectionDivider.labeled(
            l10n.experimentsTitle,
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingMedium,
          ),

          // Experiments subtitle
          Padding(
            padding: EdgeInsets.only(bottom: AppTypography.spacingMedium),
            child: Text(
              l10n.experimentsSubtitle,
              style: TextStyle(
                fontSize: AppTypography.fontSizeSmall,
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
              ),
            ),
          ),

          // Experiments grid
          _buildExperimentsGrid(context),
        ],
      ),
    );
  }

  /// Build empty state when no saved scenarios exist
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: AppTypography.iconSizeHuge,
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityFaint,
            ),
          ),
          SizedBox(height: AppTypography.spacingMedium),
          Text(
            l10n.noBodiesAdded, // Using existing localized string
            style: TextStyle(
              fontSize: AppTypography.fontSizeLarge,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
            ),
          ),
          SizedBox(height: AppTypography.spacingSmall),
          Text(
            l10n.addBodiesInSetupTab, // Using existing localized string
            style: TextStyle(
              fontSize: AppTypography.fontSizeSmall,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build the experiments grid with 2 columns
  Widget _buildExperimentsGrid(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppTypography.spacingMedium,
        mainAxisSpacing: AppTypography.spacingMedium,
      ),
      itemCount: ExperimentalScenarioConfig.experiments.length,
      itemBuilder: (context, index) {
        final experiment = ExperimentalScenarioConfig.experiments[index];
        final experimentName = experiment.name(l10n);
        return ExperimentalScenarioTile(
          experiment: experiment,
          isSelected: _selectedExperiment == experimentName,
          onTap: () => _selectExperiment(context, experiment),
        );
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

    // Open the scenario editor for this custom scenario
    _editCustomScenario(context, scenarioName);
  }

  void _selectExperiment(
    BuildContext context,
    ExperimentalScenarioConfig experiment,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final experimentName = experiment.name(l10n);

    // Log analytics for experimental scenario selection
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.customScenarioLoaded,
      element: UIElement.customScenariosTab,
      value: 'experiment:$experimentName',
    );

    setState(() {
      _selectedExperiment = experimentName;
    });

    // TODO: Implement experimental scenario loading or navigation to editor
    // For now, show a snackbar indicating the feature is coming
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.experimentComingSoon(experimentName)),
        backgroundColor: experiment.color,
      ),
    );
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
