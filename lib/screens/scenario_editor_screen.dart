import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:graviton/widgets/haptics/haptic_floating_action_button.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/models/scenario_metadata.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/models/objectives_config.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/scenario_serialization_service.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart' as app_colors;
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/utils/body_type_ranges.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_list.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_details_bottom_sheet.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_physics_panel.dart';

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

class _ScenarioEditorScreenState extends State<ScenarioEditorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Body> _bodies;
  late ScenarioMetadata _metadata;
  late ScenarioPhysicsSettings _physics;
  late ParticleSystemsConfig _particleSystems;
  ObjectivesConfig? _objectives;

  bool _hasUnsavedChanges = false;
  bool _showFAB = true; // Show FAB by default on Setup tab (index 0)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers for metadata fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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

    // Track tab changes for UI updates (FAB visibility, etc.)
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && !_hasUnsavedChanges) {
        setState(() {
          _hasUnsavedChanges = true;
        });
      }

      // Log tab change analytics
      if (_tabController.indexIsChanging) {
        final tabNames = ['setup', 'physics', 'preview'];
        FirebaseService.instance.logUIEventWithEnums(
          UIAction.tabChanged,
          element: UIElement.scenarioEditor,
          value: tabNames[_tabController.index],
        );
      }

      // Update FAB visibility based on current tab - show only on Setup tab (index 0)
      final shouldShowFAB = _tabController.index == 0;
      if (_showFAB != shouldShowFAB) {
        setState(() {
          _showFAB = shouldShowFAB;
        });
      }
    });
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
    _tabController.dispose();
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
                'had_unsaved_changes': _hasUnsavedChanges,
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
              'had_unsaved_changes': false,
              'body_count': _bodies.length,
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          title: Text(
            widget.isEditing
                ? (l10n.editScenarioTitle)
                : (l10n.createScenarioTitle),
          ),
          backgroundColor: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityNearlyOpaque,
          ),
          foregroundColor: AppColors.uiWhite,
          elevation: 0,
          automaticallyImplyLeading: true,
          actions: [
            // Save button
            HapticTextButton(
              onPressed: _hasUnsavedChanges
                  ? () => _saveScenario(context, l10n)
                  : null,
              child: Text(
                l10n.saveButton,
                style: AppTypography.mediumText.copyWith(
                  color: _hasUnsavedChanges
                      ? AppColors.primaryColor
                      : AppColors.uiWhite.withValues(alpha: 0.5),
                ),
              ),
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
                  // Tab bar using Graviton design system
                  GravitonTabBar(
                    controller: _tabController,
                    disabledTabs: [
                      false,
                      _bodies.isEmpty,
                      _bodies.isEmpty,
                    ], // Disable Physics and Preview if no bodies
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
                  ),
                  // Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
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
                icon: const Icon(Icons.add),
                label: Text(
                  l10n.addBodyButton,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
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
          SectionTitle(title: l10n.previewEditortitle),
          SizedBox(height: AppTypography.spacingMedium),

          // Scenario overview
          _buildPreviewCard(
            title: _metadata.name,
            subtitle: _metadata.description,
            icon: Icons.public,
          ),

          SizedBox(height: AppTypography.spacingLarge),

          // Bodies summary
          SectionTitle(title: l10n.bodiesLabel),
          SizedBox(height: AppTypography.spacingMedium),
          ..._bodies.map((body) => _buildBodyPreviewTile(body)),

          SizedBox(height: AppTypography.spacingLarge),

          // Physics summary
          SectionTitle(title: l10n.physicsSection),
          SizedBox(height: AppTypography.spacingMedium),
          _buildPhysicsPreview(),

          SizedBox(height: AppTypography.spacingXLarge),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: HapticElevatedButton(
                  onPressed: () => _testScenario(context, l10n),
                  child: Text(l10n.testScenarioButton),
                ),
              ),
              SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: HapticElevatedButton(
                  onPressed: () => _exportScenario(context, l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.uiBlack.withValues(alpha: 0.3),
                  ),
                  child: Text(l10n.exportScenarioButton),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppTypography.iconSizeLarge,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: AppTypography.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleText),
                SizedBox(height: AppTypography.spacingSmall),
                Text(
                  subtitle,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPreviewTile(Body body) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: body.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppTypography.spacingMedium),
          Expanded(child: Text(body.name, style: AppTypography.mediumText)),
          Text(
            NumberUtils.formatMass(body.mass),
            style: AppTypography.smallText.copyWith(
              color: AppColors.uiWhite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicsPreview() {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
      ),
      child: Column(
        children: [
          _buildPhysicsRow(
            AppLocalizations.of(context)?.gravityEditor ?? 'Gravity',
            NumberUtils.formatDecimal(_physics.gravitationalConstant, 2),
          ),
          _buildPhysicsRow(
            AppLocalizations.of(context)?.softeningEditor ?? 'Softening',
            NumberUtils.formatDecimal(_physics.softening, 3),
          ),
          _buildPhysicsRow(
            AppLocalizations.of(context)?.trailPointsEditor ?? 'Trail Points',
            _physics.maxTrailPoints.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicsRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTypography.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.mediumText),
          Text(
            value,
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the Setup tab (Metadata + Bodies)
  Widget _buildSetupTab(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Metadata Section (Name & Description only) - Fixed height
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
                }),
              ),

              const SizedBox(height: 16),

              // Description field
              StyledTextField(
                controller: _descriptionController,
                icon: Icons.description,
                labelText: l10n.descriptionEditorLabel,
                hintText: l10n.describeWhatThisScenarioDemonstratesEditorHint,
                maxLines: 3,
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
                }),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Bodies Section Divider
          SectionDivider.labeled(l10n.bodiesLabel),

          const SizedBox(height: 24),

          // Bodies List - Give it remaining space
          Expanded(
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

    // If all bodies are removed and user is on Physics or Preview tab, switch to Setup tab
    if (_bodies.isEmpty &&
        (_tabController.index == 1 || _tabController.index == 2)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController.animateTo(0);
      });
    }
  }

  void _onPhysicsChanged(ScenarioPhysicsSettings newPhysics) {
    setState(() {
      _physics = newPhysics;
      _hasUnsavedChanges = true;
    });
  }

  void _onParticleSystemsChanged(ParticleSystemsConfig newParticleSystems) {
    setState(() {
      _particleSystems = newParticleSystems;
      _hasUnsavedChanges = true;
    });
  }

  void _addNewBody() {
    // Use defaults that work well for the starting body type (planet)
    final defaultProperties = BodyTypeRanges.getDefaultProperties(
      BodyType.planet,
    );

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

              // Switch to bodies tab if not already there
              if (_tabController.index != 0) {
                _tabController.animateTo(0);
              }
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

  Future<void> _saveScenario(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final scenario = _createCustomScenario();

      // Log analytics for scenario save attempt
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.scenarioSaved,
        element: UIElement.scenarioEditor,
        additionalParams: {
          'scenario_editing': widget.isEditing,
          'body_count': _bodies.length,
          'scenario_name': _metadata.name,
          'has_objectives': _objectives != null,
        },
      );

      // Save to local storage
      await CustomScenarioStorage.saveScenario(scenario);

      setState(() {
        _hasUnsavedChanges = false;
      });

      // Log successful completion
      FirebaseService.instance.logUIEventWithEnums(
        widget.isEditing
            ? UIAction.scenarioEditingCompleted
            : UIAction.scenarioCreationCompleted,
        element: UIElement.scenarioEditor,
        additionalParams: {
          'body_count': _bodies.length,
          'scenario_name': _metadata.name,
        },
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.scenarioSavedSuccessMessage),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      // Log error analytics
      FirebaseService.instance.logErrorEvent(
        'scenario_save_failed',
        errorMessage: e.toString(),
        context: 'scenario_editor',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.scenarioSaveFailedMessage(e.toString())),
            backgroundColor: AppColors.celestialRed,
          ),
        );
      }
    }
  }

  CustomScenario _createCustomScenario() {
    // Get current values from controllers
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    // Use defaults if fields are empty
    final finalName = name.isEmpty
        ? (AppLocalizations.of(context)?.newScenarioEditor ?? 'New Scenario')
        : name;
    final finalDescription = description.isEmpty
        ? (AppLocalizations.of(context)?.customGravitationalSimulationEditor ??
              'A custom gravitational simulation')
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
    // Log analytics for scenario test
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.scenarioTested,
      element: UIElement.scenarioEditorPreview,
      additionalParams: {
        'body_count': _bodies.length,
        'scenario_name': _metadata.name,
      },
    );

    // TODO: Implement test functionality - load scenario into simulation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.testScenarioNotImplementedMessage),
        backgroundColor: AppColors.celestialOrange,
      ),
    );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.exportScenarioNotImplementedMessage),
          backgroundColor: AppColors.celestialOrange,
        ),
      );
    } catch (e) {
      // Log error analytics
      FirebaseService.instance.logErrorEvent(
        'scenario_export_failed',
        errorMessage: e.toString(),
        context: 'scenario_editor',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportScenarioFailedMessage(e.toString())),
            backgroundColor: AppColors.celestialRed,
          ),
        );
      }
    }
  }

  Future<bool> _showUnsavedChangesDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.uiBlack.withValues(alpha: 0.9),
            title: Text(
              l10n.unsavedChangesTitle,
              style: AppTypography.titleText,
            ),
            content: Text(
              l10n.unsavedChangesMessage,
              style: AppTypography.mediumText,
            ),
            actions: [
              HapticTextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              HapticTextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  l10n.discardButton,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.celestialRed,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
