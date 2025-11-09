import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/custom_scenario_manager.dart';
import 'package:graviton/screens/scenario_editor_screen.dart';

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.uiBlack.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          side: BorderSide(
            color: AppColors.celestialRed.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.celestialRed,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.deleteScenarioTitle,
              style: AppTypography.largeText.copyWith(
                color: AppColors.uiWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.deleteScenarioConfirmMessage(scenarioName),
          style: AppTypography.mediumText.copyWith(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityVeryHigh,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMediumHigh,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.celestialRed,
              backgroundColor: AppColors.celestialRed.withValues(alpha: 0.1),
            ),
            child: Text(AppLocalizations.of(context)!.deleteButton),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await CustomScenarioStorage.deleteScenario(scenarioName);
      await _loadCustomScenarios();
    }
  }
}

/// Widget for creating new custom scenarios
class CreateScenarioTile extends StatelessWidget {
  final VoidCallback onTap;

  const CreateScenarioTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: HapticInkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            border: Border.all(
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.createCustomScenarioButton,
                      style: AppTypography.largeText.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.createCustomScenarioDescription,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying custom scenarios with edit/delete actions
class CustomScenarioTile extends StatelessWidget {
  final String scenarioName;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomScenarioTile({
    super.key,
    required this.scenarioName,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customColor = AppColors.celestialPlumPlanet;

    return Card(
      margin: EdgeInsets.zero,
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? customColor.withValues(alpha: AppTypography.opacityDisabled)
          : null,
      child: HapticInkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Custom icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: customColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Icon(Icons.palette, color: customColor, size: 28),
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
                            scenarioName,
                            style: AppTypography.largeText.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected ? customColor : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: customColor,
                            size: 24,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.customScenarioDescription,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Action buttons
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: customColor.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.customLabel,
                          style: AppTypography.smallText.copyWith(
                            color: customColor.withValues(
                              alpha: AppTypography.opacityMediumHigh,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Edit button
                        GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityMediumHigh,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete button
                        GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: AppColors.celestialRed.withValues(
                                alpha: AppTypography.opacityMediumHigh,
                              ),
                            ),
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
}
