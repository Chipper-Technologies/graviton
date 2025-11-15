import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/models/dialog_action.dart';
import 'package:graviton/models/graviton_menu_item_config.dart';
import 'package:graviton/models/objectives_config.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/models/scenario_metadata.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/services/custom_scenario_manager.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/scenario_serialization_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart' as app_colors;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/body_type_ranges.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/widgets/common/base_confirmation_dialog.dart';
import 'package:graviton/widgets/common/graviton_popup_menu.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/common/graviton_tab.dart';
import 'package:graviton/widgets/common/graviton_tabbed_view.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_button.dart';
import 'package:graviton/widgets/haptics/haptic_floating_action_button.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_details_bottom_sheet.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_list.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_physics_panel.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Screen for creating and editing custom gravitational simulation scenarios
class ScenarioEditorScreen extends StatefulWidget {
  final CustomScenario? initialScenario;
  final bool isEditing;

  const ScenarioEditorScreen({
    super.key,
    this.initialScenario,
    this.isEditing = false,
  });

  @override
  State<ScenarioEditorScreen> createState() => _ScenarioEditorScreenState();
}

class _ScenarioEditorScreenState extends State<ScenarioEditorScreen> {
  late List<Body> _bodies;
  late ScenarioMetadata _metadata;
  late ScenarioPhysicsSettings _physics;
  late ParticleSystemsConfig _particleSystems;
  ObjectivesConfig? _objectives;

  bool _hasUnsavedChanges = false;
  bool _showFAB = true; // Show FAB by default on Setup tab (index 0)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Auto-save mechanism
  Timer? _autoSaveTimer;
  static const Duration _autoSaveDelay = Duration(seconds: 2);

  // Text controllers for metadata fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  // Scroll controller for setup tab
  late ScrollController _setupTabScrollController;

  @override
  void initState() {
    super.initState();
    _setupTabScrollController = ScrollController();

    // Initialize text controllers before scenario initialization
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    _initializeScenario();

    // Log analytics for scenario editor opened
    FirebaseService.instance.logUIEventWithEnums(
      widget.isEditing
          ? UIAction.scenarioEditingStarted
          : UIAction.scenarioCreationStarted,
      element: UIElement.scenarioEditor,
      additionalParams: {
        'has_initial_scenario': widget.initialScenario != null,
        'initial_body_count': widget.initialScenario?.metadata.name != null
            ? ScenarioSerializationService.toBodies(
                widget.initialScenario!,
              ).length
            : 0,
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // For new scenarios, keep metadata with empty strings for text fields
    // The hint text will show the localized placeholder text
  }

  void _initializeScenario() {
    if (widget.initialScenario != null) {
      // Load existing scenario
      final scenario = widget.initialScenario!;
      _bodies = ScenarioSerializationService.toBodies(scenario);
      _metadata = scenario.metadata;
      _physics = scenario.physics;
      _particleSystems = scenario.particleSystems;
      _objectives = scenario.objectives;
    } else {
      // Create new scenario with empty bodies list
      _bodies = <Body>[];
      _metadata = _createDefaultMetadataWithoutContext();
      _physics = _createDefaultPhysics();
      _particleSystems = const ParticleSystemsConfig();
      _objectives = null;
    }

    // Set controller values - only if we have an existing scenario
    if (widget.initialScenario != null) {
      _nameController.text = _metadata.name;
      _descriptionController.text = _metadata.description;
    }
    // For new scenarios, leave controllers empty (they're already initialized as empty)
  }

  ScenarioMetadata _createDefaultMetadataWithoutContext() {
    return ScenarioMetadata(
      name: '', // Empty string so text field shows placeholder
      description: '', // Empty string so text field shows placeholder
      author: null,
      createdAt: DateTime.now(),
      educationalFocus: 'gravitational forces',
      tags: ['custom'],
      difficulty: 'beginner',
    );
  }

  ScenarioPhysicsSettings _createDefaultPhysics() {
    return const ScenarioPhysicsSettings(
      gravitationalConstant: 1.2,
      softening: 0.1,
      timeScale: 1.0,
      collisionRadiusMultiplier: 1.0,
      maxTrailPoints: 500,
      trailFadeRate: 0.95,
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _setupTabScrollController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _showUnsavedChangesDialog(context, l10n);
          if (shouldPop && context.mounted) {
            // Log analytics for scenario creation/editing cancellation
            FirebaseService.instance.logUIEventWithEnums(
              widget.isEditing
                  ? UIAction.scenarioEditingCanceled
                  : UIAction.scenarioCreationCanceled,
              element: UIElement.scenarioEditor,
              additionalParams: {
                'had_unsaved_changes': _hasUnsavedChanges.toString(),
                'body_count': _bodies.length,
              },
            );
            Navigator.of(context).pop();
          }
        } else if (didPop) {
          // Log normal exit (no unsaved changes)
          FirebaseService.instance.logUIEventWithEnums(
            widget.isEditing
                ? UIAction.scenarioEditingCanceled
                : UIAction.scenarioCreationCanceled,
            element: UIElement.scenarioEditor,
            additionalParams: {
              'had_unsaved_changes': 'false',
              'body_count': _bodies.length,
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        extendBodyBehindAppBar: true,
        appBar: HapticAppBar(
          title: widget.isEditing
              ? l10n.editScenarioTitle
              : l10n.createScenarioTitle,
          actions: [
            GravitonPopupMenu(
              accessibilityLabel: l10n.moreActionsAccessibility,
              accessibilityHint: l10n.scenarioEditorMenuHint,
              analyticsElement: UIElement.scenarioEditor,
              menuItems: [
                // Test Scenario - always available
                GravitonMenuItemConfig(
                  value: 'test',
                  labelKey: 'testScenarioButton',
                  hintKey: 'testScenarioHint',
                  icon: Icons.play_arrow,
                  onTap: () => _testScenario(context, l10n),
                ),
                // Export Scenario - only available when editing
                if (widget.isEditing)
                  GravitonMenuItemConfig(
                    value: 'export',
                    labelKey: 'exportScenarioButton',
                    hintKey: 'exportScenarioHint',
                    icon: Icons.file_download,
                    iconColor: AppColors.uiWhite,
                    borderColor: AppColors.uiWhite.withValues(
                      alpha: AppColors.alphaMediumVisible,
                    ),
                    onTap: () => _exportScenario(context, l10n),
                  ),
              ],
            ),
            const SizedBox(width: AppTypography.spacingMedium),
          ],
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.uiBlack.withValues(
                alpha: AppTypography.opacityNearlyOpaque,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Tabbed view using Graviton design system with disabled tab swiping
                  Expanded(
                    child: GravitonTabbedView(
                      tabs: [
                        GravitonTab(
                          icon: Icons.settings,
                          label: l10n.setupEditorTitle,
                        ),
                        GravitonTab(
                          icon: Icons.science,
                          label: l10n.physicsSection,
                          isEnabled: _bodies.isNotEmpty,
                        ),
                        GravitonTab(
                          icon: Icons.visibility,
                          label: l10n.previewEditortitle,
                          isEnabled: _bodies.isNotEmpty,
                        ),
                      ],
                      disabledTabs: [
                        false,
                        _bodies.isEmpty,
                        _bodies.isEmpty,
                      ], // Disable Physics and Preview if no bodies
                      onTabChanged: (index) {
                        // Update FAB visibility based on current tab - show only on Setup tab (index 0)
                        final shouldShowFAB = index == 0;
                        if (_showFAB != shouldShowFAB) {
                          setState(() {
                            _showFAB = shouldShowFAB;
                          });
                        }

                        // Mark as changed if not already
                        if (!_hasUnsavedChanges) {
                          _markAsChanged();
                        }

                        // Log tab change analytics
                        final tabNames = ['setup', 'physics', 'preview'];
                        FirebaseService.instance.logUIEventWithEnums(
                          UIAction.tabChanged,
                          element: UIElement.scenarioEditor,
                          value: tabNames[index],
                        );
                      },
                      children: [
                        // Setup Tab (Metadata + Bodies)
                        _buildSetupTab(context, l10n),
                        // Physics Tab (Physics Settings only)
                        _buildPhysicsTab(context, l10n),
                        // Preview Tab
                        _buildPreviewTab(context, l10n),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _showFAB
            ? HapticFloatingActionButton.extended(
                onPressed: _addNewBody,
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.uiWhite,
                elevation: 8,
                icon: const Icon(Icons.add),
                label: Text(
                  l10n.addBodyButton,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                scrollController: _setupTabScrollController,
                hideOnScroll: true,
              )
            : null,
      ),
    );
  }

  Widget _buildPreviewTab(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scenario info container (body tile style)
          _buildScenarioInfoTile(l10n),

          SizedBox(height: AppTypography.spacingSmall),

          // Bodies section divider
          SectionDivider.labeled(l10n.bodiesLabel),

          SizedBox(height: AppTypography.spacingLarge),

          // Bodies list using common widget
          if (_bodies.isEmpty)
            _buildEmptyState(
              icon: Icons.add_circle_outline,
              message: l10n.noBodiesAdded,
              submessage: l10n.addBodiesInSetupTab,
            )
          else
            _buildBodiesGrid(),

          SizedBox(height: AppTypography.spacingLarge),

          // Physics section divider
          SectionDivider.labeled(l10n.physicsSection),

          SizedBox(height: AppTypography.spacingLarge),

          // Physics summary (simplified)
          _buildSimplePhysicsPreview(l10n),

          SizedBox(height: AppTypography.spacingXLarge),

          // Actions section divider
          SectionDivider.plain(),

          SizedBox(height: AppTypography.spacingLarge),

          // Test button only
          SizedBox(
            width: double.infinity,
            child: HapticButton.primary(
              text: l10n.testScenarioButton,
              onPressed: () => _testScenario(context, l10n),
              icon: Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioInfoTile(AppLocalizations l10n) {
    final name = _metadata.name.isNotEmpty
        ? _metadata.name
        : l10n.untitledScenario;
    final description = _metadata.description.isNotEmpty
        ? _metadata.description
        : l10n.noDescriptionProvided;

    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      child: Material(
        color: AppColors.transparentColor,
        child: InkWell(
          onTap: () {
            // Could open an edit dialog in the future
          },
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityBarely,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: Row(
              children: [
                // Scenario icon indicator - matching body tile style
                Container(
                  width: AppTypography.spacingXXXLarge,
                  height: AppTypography.spacingXXXLarge,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.science,
                    size: AppTypography.iconSizeMedium,
                    color: AppColors.uiWhite,
                  ),
                ),
                SizedBox(width: AppTypography.spacingLarge),
                // Scenario name and description - matching body tile style
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: AppColors.uiWhite,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodiesGrid() {
    return Column(
      children: [
        // Build grid rows with 2 bodies each
        for (int i = 0; i < _bodies.length; i += 2) ...[
          Row(
            children: [
              Expanded(child: _buildBodyGridTile(_bodies[i])),
              if (i + 1 < _bodies.length) ...[
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(child: _buildBodyGridTile(_bodies[i + 1])),
              ] else
                Expanded(child: SizedBox()), // Empty space for odd numbers
            ],
          ),
          if (i + 2 < _bodies.length) // Don't add spacing after the last row
            SizedBox(height: AppTypography.spacingSmall),
        ],
      ],
    );
  }

  Widget _buildBodyGridTile(Body body) {
    return Container(
      margin: EdgeInsets
          .zero, // Remove bottom margin since we handle spacing in grid
      child: Material(
        color: AppColors.transparentColor,
        child: InkWell(
          onTap: null, // No tap action in preview
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityBarely,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: Row(
              children: [
                // Body color indicator with icon - matching bodies tab style
                Container(
                  width: AppTypography.spacingXXXLarge,
                  height: AppTypography.spacingXXXLarge,
                  decoration: BoxDecoration(
                    color: body.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _getIconForBodyType(body.bodyType),
                    size: AppTypography.iconSizeMedium,
                    color: AppColors.uiWhite,
                  ),
                ),
                SizedBox(
                  width: AppTypography.spacingMedium,
                ), // Smaller spacing in grid
                // Body name and info - matching bodies tab style
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body.name,
                        style: TextStyle(
                          color: AppColors.uiWhite,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        '${body.bodyType.name} • ${NumberUtils.formatMassInSolarMasses(body.mass)}',
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get the appropriate icon for each body type
  IconData _getIconForBodyType(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return Icons.wb_sunny; // Sun icon for stars
      case BodyType.planet:
        return Icons.public; // Globe icon for planets
      case BodyType.moon:
        return Icons.brightness_3; // Crescent moon icon for moons
      case BodyType.asteroid:
        return Icons.scatter_plot; // Scatter plot icon for asteroids
      case BodyType.blackHole:
        return Icons.donut_large; // Black hole representation
      case BodyType.neutronStar:
        return Icons.flash_on; // High-energy neutron star
    }
  }

  Widget _buildSimplePhysicsPreview(AppLocalizations l10n) {
    return Column(
      children: [
        // First row
        Row(
          children: [
            Expanded(
              child: _buildPhysicsCard(
                icon: Icons.public,
                label: l10n.gravityEditor,
                value: NumberUtils.formatDecimal(
                  _physics.gravitationalConstant,
                  2,
                ),
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildPhysicsCard(
                icon: Icons.blur_on,
                label: l10n.softeningEditor,
                value: NumberUtils.formatDecimal(_physics.softening, 3),
                color: AppColors.uiCyan,
              ),
            ),
          ],
        ),
        SizedBox(height: AppTypography.spacingSmall),
        // Second row
        Row(
          children: [
            Expanded(
              child: _buildPhysicsCard(
                icon: Icons.speed,
                label: l10n.timeScaleStatLabel,
                value: NumberUtils.formatDecimal(_physics.timeScale, 2),
                color: AppColors.uiGreen,
              ),
            ),
            SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildPhysicsCard(
                icon: Icons.timeline,
                label: l10n.trailPointsEditor,
                value: _physics.maxTrailPoints.toString(),
                color: AppColors.uiOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhysicsCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: AppTypography.opacityDisabled),
            color.withValues(alpha: AppTypography.opacityBarely),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(
          color: color.withValues(alpha: AppTypography.opacityFaint),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppTypography.spacingSmall),
            decoration: BoxDecoration(
              color: color.withValues(alpha: AppTypography.opacityVeryFaint),
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
            ),
            child: Icon(icon, color: color, size: AppTypography.iconSizeMedium),
          ),
          SizedBox(width: AppTypography.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String submessage,
  }) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingXLarge),
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityVeryFaint,
        ),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: AppTypography.iconSizeXXLarge,
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityFaint,
            ),
          ),
          SizedBox(height: AppTypography.spacingMedium),
          Text(
            message,
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppTypography.spacingSmall),
          Text(
            submessage,
            style: AppTypography.smallText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the Setup tab (Metadata + Bodies)
  Widget _buildSetupTab(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      controller: _setupTabScrollController,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metadata Section (Name & Description only)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              StyledTextField(
                controller: _nameController,
                icon: Icons.title,
                labelText: l10n.bodyPropertiesName,
                hintText: l10n.enterScenarioNameEditorHint,
                onChanged: (name) => setState(() {
                  _metadata = ScenarioMetadata(
                    name: name,
                    description: _metadata.description,
                    author: _metadata.author,
                    createdAt: _metadata.createdAt,
                    educationalFocus: _metadata.educationalFocus,
                    tags: _metadata.tags,
                    difficulty: _metadata.difficulty,
                  );
                  _hasUnsavedChanges = true;
                  _triggerAutoSave();
                }),
              ),

              const SizedBox(height: AppTypography.spacingLarge),

              // Description field
              StyledTextField(
                controller: _descriptionController,
                icon: Icons.description,
                labelText: l10n.descriptionEditorLabel,
                hintText: l10n.describeWhatThisScenarioDemonstratesEditorHint,
                minLines: 2,
                maxLines: 4,
                onChanged: (description) => setState(() {
                  _metadata = ScenarioMetadata(
                    name: _metadata.name,
                    description: description,
                    author: _metadata.author,
                    createdAt: _metadata.createdAt,
                    educationalFocus: _metadata.educationalFocus,
                    tags: _metadata.tags,
                    difficulty: _metadata.difficulty,
                  );
                  _hasUnsavedChanges = true;
                  _triggerAutoSave();
                }),
              ),
            ],
          ),

          const SizedBox(height: AppTypography.spacingMedium),

          // System Setup Tools Section
          // Bodies Section Divider
          SectionDivider.labeled(l10n.bodiesLabel),

          // Bodies List - Give it a minimum height that can grow with content
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height *
                  0.3, // At least 30% of screen height
              maxHeight:
                  MediaQuery.of(context).size.height *
                  0.6, // At most 60% of screen height
            ),
            child: ScenarioEditorBodyList(
              bodies: _bodies,
              onBodiesChanged: _onBodiesChanged,
              onAddBody: _addNewBody,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the Physics tab (Physics Settings only)
  Widget _buildPhysicsTab(BuildContext context, AppLocalizations l10n) {
    return ScenarioEditorPhysicsPanel(
      physics: _physics,
      particleSystems: _particleSystems,
      onPhysicsChanged: _onPhysicsChanged,
      onParticleSystemsChanged: _onParticleSystemsChanged,
    );
  }

  void _onBodiesChanged(List<Body> newBodies) {
    setState(() {
      _bodies = newBodies;
      _hasUnsavedChanges = true;
    });
    _triggerAutoSave();

    // Note: Tab switching is now handled automatically by GravitonTabbedView
    // when tabs are disabled based on _bodies.isEmpty
  }

  void _onPhysicsChanged(ScenarioPhysicsSettings newPhysics) {
    setState(() {
      _physics = newPhysics;
      _hasUnsavedChanges = true;
    });
    _triggerAutoSave();
  }

  void _onParticleSystemsChanged(ParticleSystemsConfig newParticleSystems) {
    setState(() {
      _particleSystems = newParticleSystems;
      _hasUnsavedChanges = true;
    });
    _triggerAutoSave();
  }

  void _addNewBody() {
    // Use defaults that work well for the starting body type (planet)
    final defaultProperties = BodyTypeRanges.getDefaultProperties(
      BodyType.planet,
    );

    // Get the global gravity fields setting to use as default for new bodies
    final appState = Provider.of<AppState>(context, listen: false);
    final shouldShowGravityWell = appState.ui.globalGravityFields;

    final newBody = Body(
      name: '', // Start with empty name so user sees placeholder text
      position: vm.Vector3(20.0 * _bodies.length, 0, 0), // Spread them out
      velocity: vm.Vector3(0, 5.0, 0), // Give some orbital velocity
      mass: defaultProperties['mass']!, // Use realistic default for planets
      radius: defaultProperties['radius']!, // Use realistic default for planets
      color: _getNextBodyColor(),
      bodyType: BodyType.planet, // Start with planet as default
      stellarLuminosity: defaultProperties['luminosity']!, // 0.0 for planets
      temperature: 288.0,
      showGravityWell: shouldShowGravityWell, // Use global setting as default
    );

    // Show bottom sheet for editing the new body
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ScenarioEditorBodyDetailsBottomSheet(
            body: newBody,
            isAddMode: true,
            availableCentralBodies:
                _bodies, // Pass existing bodies as potential central bodies
            onBodyChanged: (updatedBody) {
              // Update the local body reference
              setSheetState(() {});
            },
            onSave: (finalBody) {
              // Log analytics for body addition
              FirebaseService.instance.logUIEventWithEnums(
                UIAction.bodyAdded,
                element: UIElement.scenarioEditorBodies,
                additionalParams: {
                  'total_bodies': _bodies.length + 1,
                  'scenario_editing': widget.isEditing,
                },
              );

              // Actually add the body to the list
              final updatedBodies = List<Body>.from(_bodies)..add(finalBody);
              _onBodiesChanged(updatedBodies);

              // Note: Tab switching is now handled automatically by GravitonTabbedView
              // The Setup tab will become available and user can navigate there manually
            },
          ),
        ),
      ),
    );
  }

  Color _getNextBodyColor() {
    const colors = [
      app_colors.AppColors.celestialBlue,
      app_colors.AppColors.celestialRed,
      app_colors.AppColors.celestialTeal,
      app_colors.AppColors.celestialAmber,
      app_colors.AppColors.celestialPink,
      app_colors.AppColors.celestialLightBlue,
    ];
    return colors[_bodies.length % colors.length];
  }

  /// Triggers auto-save with a debounce delay
  void _triggerAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, () {
      if (mounted && _hasUnsavedChanges) {
        _autoSaveScenario();
      }
    });
  }

  /// Mark scenario as having unsaved changes and trigger auto-save
  void _markAsChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
    _triggerAutoSave();
  }

  /// Auto-save the scenario without user interaction
  Future<void> _autoSaveScenario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final scenario = _createCustomScenario();

      // Log analytics for auto-save
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.scenarioSaved,
        element: UIElement.scenarioEditor,
        additionalParams: {
          'scenario_editing': widget.isEditing,
          'body_count': _bodies.length,
          'scenario_name': _metadata.name,
          'has_objectives': _objectives != null,
          'save_type': 'auto',
        },
      );

      // Save to local storage
      await CustomScenarioStorage.saveScenario(scenario);

      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
        });
      }

      // Log successful completion
      FirebaseService.instance.logUIEventWithEnums(
        widget.isEditing
            ? UIAction.scenarioEditingCompleted
            : UIAction.scenarioCreationCompleted,
        element: UIElement.scenarioEditor,
        additionalParams: {
          'body_count': _bodies.length,
          'scenario_name': _metadata.name,
          'save_type': 'auto',
        },
      );
    } catch (e) {
      // Log error analytics but don't show user error for auto-save
      FirebaseService.instance.logErrorEvent(
        'scenario_auto_save_failed',
        errorMessage: e.toString(),
        context: 'scenario_editor',
      );
    }
  }

  CustomScenario _createCustomScenario() {
    // Get current values from controllers
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    // Use defaults if fields are empty
    final finalName = name.isEmpty
        ? AppLocalizations.of(context)!.newScenarioEditor
        : name;
    final finalDescription = description.isEmpty
        ? AppLocalizations.of(context)!.customGravitationalSimulationEditor
        : description;

    // Create updated metadata with current values
    final updatedMetadata = ScenarioMetadata(
      name: finalName,
      description: finalDescription,
      author: _metadata.author,
      createdAt: _metadata.createdAt,
      educationalFocus: _metadata.educationalFocus,
      tags: _metadata.tags,
      difficulty: _metadata.difficulty,
    );

    return ScenarioSerializationService.fromBodies(
      bodies: _bodies,
      metadata: updatedMetadata,
      physics: _physics,
      particleSystems: _particleSystems,
      objectives: _objectives,
    );
  }

  Future<void> _testScenario(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    // Cancel auto-save timer to prevent race condition with test scenario
    _autoSaveTimer?.cancel();

    // Log analytics for scenario test
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.scenarioTested,
      element: UIElement.scenarioEditorPreview,
      additionalParams: {
        'body_count': _bodies.length,
        'scenario_name': _metadata.name,
      },
    );

    // Validate scenario first
    if (_bodies.isEmpty) {
      GravitonSnackBar.warning(
        context: context,
        message: l10n.addCelestialBodiesToCreateYourCustomScenarioEditor,
      );
      return;
    }

    // Save the scenario if it has unsaved changes or doesn't exist yet
    // This ensures new scenarios get saved when user first tests them
    if (_hasUnsavedChanges || !widget.isEditing) {
      try {
        await _autoSaveScenario();
      } catch (e) {
        debugPrint('Failed to save scenario before testing: $e');
        // Continue with testing even if save fails
      }
    }

    // Check if still mounted after async save
    if (!mounted || !context.mounted) return;

    // Create scenario data after save completes
    final scenario = _createCustomScenario();
    final testScenarioName = CustomScenarioStorage.generateTestScenarioName();
    final testMetadata = ScenarioMetadata(
      name: testScenarioName,
      description: 'Temporary test scenario - will be deleted automatically',
      author: 'System',
      createdAt: scenario.metadata.createdAt,
      educationalFocus: scenario.metadata.educationalFocus,
      tags: [...scenario.metadata.tags, 'temporary', 'test'],
      difficulty: scenario.metadata.difficulty,
    );

    final testScenario = CustomScenario(
      version: scenario.version,
      metadata: testMetadata,
      configuration: scenario.configuration,
      physics: scenario.physics,
      bodies: scenario.bodies,
      particleSystems: scenario.particleSystems,
      objectives: scenario.objectives,
    );

    // Save test scenario before navigation
    try {
      await CustomScenarioStorage.saveScenario(testScenario);
    } catch (e) {
      debugPrint('Failed to save test scenario: $e');
      if (mounted && context.mounted) {
        GravitonSnackBar.error(
          context: context,
          message: l10n.failedToSwitchScenarioError(e.toString()),
        );
      }
      return;
    }

    // Check if still mounted after async save
    if (!mounted || !context.mounted) return;

    // Navigate and schedule loading in post-frame callback
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Use post-frame callback to ensure navigation completes before loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Double-check mounted state after navigation
      if (mounted) {
        _loadTestScenarioAsync(testScenarioName);
      }
    });
  }

  Future<void> _loadTestScenarioAsync(String testScenarioName) async {
    // Wait for next frame to ensure navigation is complete
    await WidgetsBinding.instance.endOfFrame;

    // Early exit if widget was disposed during frame delay
    if (!mounted) return;

    final currentContext = context;
    if (!currentContext.mounted) return;

    final localizedL10n = AppLocalizations.of(currentContext)!;
    final appState = Provider.of<AppState>(currentContext, listen: false);

    try {
      // Load the test scenario into the custom manager
      final customManager = CustomScenarioManager.instance;
      await customManager.loadCustomScenario(testScenarioName);

      // Verify the scenario was loaded correctly
      if (!customManager.hasCustomScenario) {
        throw Exception('Test scenario failed to load into manager');
      }

      // Small delay to ensure everything is ready
      await Future.delayed(const Duration(milliseconds: 100));

      // Check mounted state after async gap
      if (!mounted || !currentContext.mounted) return;

      // Reset with custom scenario type
      appState.simulation.resetWithScenario(
        ScenarioType.custom,
        l10n: localizedL10n,
      );

      // Another small delay for the simulation to process
      await Future.delayed(const Duration(milliseconds: 100));

      // Check mounted state after async gap
      if (!mounted || !currentContext.mounted) return;

      // Verify that the bodies were loaded correctly
      final bodyCount = appState.simulation.bodies.length;

      if (bodyCount == 0) {
        throw Exception(
          'Test scenario loaded but no bodies found in simulation',
        );
      }

      // Show test message first
      if (currentContext.mounted) {
        GravitonSnackBar.success(
          context: currentContext,
          message: localizedL10n.accessibilityNewScenarioLoaded,
          duration: const Duration(seconds: 3),
        );
      }

      // Schedule cleanup after a longer delay to ensure everything has loaded
      // and give the user time to see the simulation working
      // Handle cleanup explicitly with proper error logging
      Future.delayed(const Duration(seconds: 3))
          .then((_) async {
            // Check if still mounted before cleanup
            if (!mounted) return;

            try {
              // Clean up the temporary test scenario
              await _cleanupTestScenario(testScenarioName);
            } catch (e, stackTrace) {
              // Log cleanup failures for debugging even though not shown to user
              debugPrint('Failed to cleanup test scenario: $e');
              debugPrint('Stack trace: $stackTrace');
            }
          })
          .catchError((error, stackTrace) {
            // Catch any unexpected errors in the delayed future itself
            debugPrint('Unexpected error during cleanup scheduling: $error');
            debugPrint('Stack trace: $stackTrace');
          });
    } catch (e) {
      // Check mounted state before showing error
      if (mounted && currentContext.mounted) {
        GravitonSnackBar.error(
          context: currentContext,
          message: localizedL10n.failedToSwitchScenarioError(e.toString()),
        );
      }
    }
  }

  Future<void> _exportScenario(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    try {
      final scenario = _createCustomScenario();
      final jsonString = ScenarioSerializationService.toJsonString(scenario);

      // Log analytics for scenario export
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.scenarioExported,
        element: UIElement.scenarioEditorPreview,
        additionalParams: {
          'body_count': _bodies.length,
          'scenario_name': _metadata.name,
          'export_size_bytes': jsonString.length,
        },
      );

      // TODO: Implement file export functionality
      debugPrint('Exported JSON:\n$jsonString'); // For development

      GravitonSnackBar.warning(
        context: context,
        message: l10n.exportScenarioNotImplementedMessage,
      );
    } catch (e) {
      // Log error analytics
      FirebaseService.instance.logErrorEvent(
        'scenario_export_failed',
        errorMessage: e.toString(),
        context: 'scenario_editor',
      );

      if (mounted) {
        GravitonSnackBar.error(
          context: context,
          message: l10n.exportScenarioFailedMessage(e.toString()),
        );
      }
    }
  }

  Future<bool> _showUnsavedChangesDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    return await BaseConfirmationDialog.show<bool>(
          context: context,
          title: l10n.unsavedChangesTitle,
          message: l10n.unsavedChangesMessage,
          actions: [
            DialogAction(
              text: l10n.cancel,
              onPressed: () => Navigator.of(context).pop(false),
              textColor: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
            DialogAction(
              text: l10n.discardButton,
              onPressed: () => Navigator.of(context).pop(true),
              textColor: AppColors.celestialRed,
              fontWeight: FontWeight.w600,
              isDestructive: true,
            ),
          ],
        ) ??
        false;
  }

  /// Clean up a test scenario with better error handling and verification
  Future<bool> _cleanupTestScenario(String testScenarioName) async {
    try {
      // First check if the scenario still exists
      final exists = await CustomScenarioStorage.scenarioExists(
        testScenarioName,
      );
      if (!exists) {
        return false; // Already cleaned up
      }

      // Delete the scenario
      await CustomScenarioStorage.deleteScenario(testScenarioName);

      // Verify deletion
      final stillExists = await CustomScenarioStorage.scenarioExists(
        testScenarioName,
      );
      return !stillExists;
    } catch (e) {
      return false;
    }
  }
}
