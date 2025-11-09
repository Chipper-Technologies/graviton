import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/section_title.dart';

/// Metadata configuration panel for scenario editor
class ScenarioEditorMetadataPanel extends StatefulWidget {
  final ScenarioMetadata metadata;
  final ObjectivesConfig? objectives;
  final ValueChanged<ScenarioMetadata> onMetadataChanged;
  final ValueChanged<ObjectivesConfig?> onObjectivesChanged;

  const ScenarioEditorMetadataPanel({
    super.key,
    required this.metadata,
    required this.objectives,
    required this.onMetadataChanged,
    required this.onObjectivesChanged,
  });

  @override
  State<ScenarioEditorMetadataPanel> createState() =>
      _ScenarioEditorMetadataPanelState();
}

class _ScenarioEditorMetadataPanelState
    extends State<ScenarioEditorMetadataPanel> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.metadata.name);
    _descriptionController = TextEditingController(
      text: widget.metadata.description,
    );
    _selectedDifficulty = widget.metadata.difficulty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateMetadata() {
    final updatedMetadata = ScenarioMetadata(
      name: _nameController.text,
      description: _descriptionController.text,
      difficulty: _selectedDifficulty,
      educationalFocus: widget.metadata.educationalFocus,
      tags: widget.metadata.tags,
      author: widget.metadata.author,
      createdAt: widget.metadata.createdAt,
    );
    widget.onMetadataChanged(updatedMetadata);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: l10n.scenarioInformationEditortitle),
          SizedBox(height: AppTypography.spacingMedium),

          // Name field
          _buildTextField(
            controller: _nameController,
            label: AppLocalizations.of(context)?.bodyPropertiesName ?? 'Name',
            hint:
                AppLocalizations.of(context)?.enterScenarioNameEditorHint ??
                'Enter scenario name',
            onChanged: (_) => _updateMetadata(),
          ),

          SizedBox(height: AppTypography.spacingMedium),

          // Description field
          _buildTextField(
            controller: _descriptionController,
            label:
                AppLocalizations.of(context)?.descriptionEditorLabel ??
                'Description',
            hint:
                AppLocalizations.of(
                  context,
                )?.describeWhatThisScenarioDemonstratesEditorHint ??
                'Describe what this scenario demonstrates',
            maxLines: 3,
            onChanged: (_) => _updateMetadata(),
          ),

          SizedBox(height: AppTypography.spacingMedium),

          // Difficulty dropdown
          _buildDifficultyDropdown(),

          SizedBox(height: AppTypography.spacingLarge),

          SectionTitle(title: l10n.educationalObjectivesEditortitle),
          SizedBox(height: AppTypography.spacingMedium),

          Container(
            padding: EdgeInsets.all(AppTypography.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: Border.all(
                color: AppColors.uiWhite.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                        context,
                      )?.educationalObjectivesFutureMessage ??
                      'Educational objectives and challenges can be configured here in future versions.',
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: AppTypography.spacingSmall),
                Text(
                  AppLocalizations.of(
                        context,
                      )?.educationalObjectivesListMessage ??
                      'This will include:\n• Learning goals\n• Success criteria\n• Guided challenges\n• Assessment rubrics',
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.uiWhite.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.mediumText.copyWith(
            color: AppColors.uiWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppTypography.spacingSmall),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          style: AppTypography.mediumText.copyWith(color: AppColors.uiWhite),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.uiWhite.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              borderSide: BorderSide(
                color: AppColors.uiWhite.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              borderSide: BorderSide(
                color: AppColors.uiWhite.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
              vertical: AppTypography.spacingSmall,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyDropdown() {
    const difficulties = ['beginner', 'intermediate', 'advanced'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.difficultyEditorLabel ?? 'Difficulty',
          style: AppTypography.mediumText.copyWith(
            color: AppColors.uiWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppTypography.spacingSmall),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppTypography.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.uiWhite.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
            border: Border.all(color: AppColors.uiWhite.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDifficulty,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedDifficulty = newValue;
                  });
                  _updateMetadata();
                }
              },
              dropdownColor: AppColors.uiBlack,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.uiWhite.withValues(alpha: 0.7),
              ),
              items: difficulties.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.substring(0, 1).toUpperCase() + value.substring(1),
                    style: AppTypography.mediumText.copyWith(
                      color: AppColors.uiWhite,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
