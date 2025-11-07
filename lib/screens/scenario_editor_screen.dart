import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/haptic_elevated_button.dart';
import 'package:graviton/widgets/common/haptic_text_button.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/scenario_serialization_service.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart' as app_colors;
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/widgets/scenario_editor_body_list.dart';
import 'package:graviton/widgets/scenario_editor_physics_panel.dart';
import 'package:graviton/widgets/scenario_editor_metadata_panel.dart';

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
  late PhysicsSettings _physics;
  late ParticleSystemsConfig _particleSystems;
  ObjectivesConfig? _objectives;

  bool _hasUnsavedChanges = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeScenario();

    // Mark as changed when tab switches to track user activity
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && !_hasUnsavedChanges) {
        setState(() {
          _hasUnsavedChanges = true;
        });
      }
    });
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
      // Create new scenario with defaults
      _bodies = [_createDefaultSun()];
      _metadata = _createDefaultMetadata();
      _physics = _createDefaultPhysics();
      _particleSystems = const ParticleSystemsConfig();
      _objectives = null;
    }
  }

  Body _createDefaultSun() {
    return Body(
      name: 'Sun',
      position: vm.Vector3.zero(),
      velocity: vm.Vector3.zero(),
      mass: 50.0,
      radius: 4.8,
      color: app_colors.AppColors.celestialGold,
      bodyType: BodyType.star,
      stellarLuminosity: 1.0,
      temperature: 5778.0,
      showGravityWell: true,
      isPlanet: false,
    );
  }

  ScenarioMetadata _createDefaultMetadata() {
    return ScenarioMetadata(
      name: 'New Scenario',
      description: 'A custom gravitational simulation',
      author: null,
      createdAt: DateTime.now(),
      educationalFocus: 'gravitational forces',
      tags: ['custom'],
      difficulty: 'beginner',
    );
  }

  PhysicsSettings _createDefaultPhysics() {
    return const PhysicsSettings(
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
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.isEditing 
                ? 'Edit Scenario'
                : 'Create Scenario',
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
              onPressed: _hasUnsavedChanges ? () => _saveScenario(context, l10n) : null,
              child: Text(
                'Save',
                style: AppTypography.mediumText.copyWith(
                  color: _hasUnsavedChanges 
                      ? AppColors.primaryColor 
                      : AppColors.uiWhite.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: AppTypography.spacingMedium),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Bodies'),
              Tab(text: 'Physics'),
              Tab(text: 'Metadata'),
              Tab(text: 'Preview'),
            ],
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.uiWhite,
            unselectedLabelColor: AppColors.uiWhite.withValues(alpha: 0.7),
          ),
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Bodies Tab
                  ScenarioEditorBodyList(
                    bodies: _bodies,
                    onBodiesChanged: _onBodiesChanged,
                    onAddBody: _addNewBody,
                  ),
                  // Physics Tab
                  ScenarioEditorPhysicsPanel(
                    physics: _physics,
                    particleSystems: _particleSystems,
                    onPhysicsChanged: _onPhysicsChanged,
                    onParticleSystemsChanged: _onParticleSystemsChanged,
                  ),
                  // Metadata Tab
                  ScenarioEditorMetadataPanel(
                    metadata: _metadata,
                    objectives: _objectives,
                    onMetadataChanged: _onMetadataChanged,
                    onObjectivesChanged: _onObjectivesChanged,
                  ),
                  // Preview Tab
                  _buildPreviewTab(context, l10n),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton(
                onPressed: _addNewBody,
                backgroundColor: AppColors.primaryColor,
                child: const Icon(Icons.add, color: AppColors.uiWhite),
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
          SectionTitle(title: 'Preview'),
          SizedBox(height: AppTypography.spacingMedium),

          // Scenario overview
          _buildPreviewCard(
            title: _metadata.name,
            subtitle: _metadata.description,
            icon: Icons.public,
          ),

          SizedBox(height: AppTypography.spacingLarge),

          // Bodies summary
          SectionTitle(title: 'Bodies'),
          SizedBox(height: AppTypography.spacingMedium),
          ..._bodies.map((body) => _buildBodyPreviewTile(body)),

          SizedBox(height: AppTypography.spacingLarge),

          // Physics summary
          SectionTitle(title: 'Physics'),
          SizedBox(height: AppTypography.spacingMedium),
          _buildPhysicsPreview(),

          SizedBox(height: AppTypography.spacingXLarge),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: HapticElevatedButton(
                  onPressed: () => _testScenario(context, l10n),
                  child: Text('Test Scenario'),
                ),
              ),
              SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: HapticElevatedButton(
                  onPressed: () => _exportScenario(context, l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.uiBlack.withValues(alpha: 0.3),
                  ),
                  child: Text('Export Scenario'),
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
                Text(
                  title,
                  style: AppTypography.titleText,
                ),
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
          Expanded(
            child: Text(
              body.name,
              style: AppTypography.mediumText,
            ),
          ),
          Text(
            '${body.mass.toStringAsFixed(1)} M',
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
          _buildPhysicsRow('Gravity', _physics.gravitationalConstant.toStringAsFixed(2)),
          _buildPhysicsRow('Softening', _physics.softening.toStringAsFixed(3)),
          _buildPhysicsRow('Trail Points', _physics.maxTrailPoints.toString()),
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
          Text(
            label,
            style: AppTypography.mediumText,
          ),
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

  void _onBodiesChanged(List<Body> newBodies) {
    setState(() {
      _bodies = newBodies;
      _hasUnsavedChanges = true;
    });
  }

  void _onPhysicsChanged(PhysicsSettings newPhysics) {
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

  void _onMetadataChanged(ScenarioMetadata newMetadata) {
    setState(() {
      _metadata = newMetadata;
      _hasUnsavedChanges = true;
    });
  }

  void _onObjectivesChanged(ObjectivesConfig? newObjectives) {
    setState(() {
      _objectives = newObjectives;
      _hasUnsavedChanges = true;
    });
  }

  void _addNewBody() {
    final newBody = Body(
      name: 'Body ${_bodies.length + 1}',
      position: vm.Vector3(20.0 * _bodies.length, 0, 0), // Spread them out
      velocity: vm.Vector3(0, 5.0, 0), // Give some orbital velocity
      mass: 1.0,
      radius: 1.0,
      color: _getNextBodyColor(),
      bodyType: BodyType.planet,
      stellarLuminosity: 0.0,
      temperature: 288.0,
    );

    setState(() {
      _bodies.add(newBody);
      _hasUnsavedChanges = true;
    });

    // Switch to bodies tab if not already there
    if (_tabController.index != 0) {
      _tabController.animateTo(0);
    }
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

  Future<void> _saveScenario(BuildContext context, AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final scenario = _createCustomScenario();
      
      // Save to local storage
      await CustomScenarioStorage.saveScenario(scenario);

      setState(() {
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scenario saved successfully'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save scenario: $e'),
            backgroundColor: AppColors.celestialRed,
          ),
        );
      }
    }
  }

  CustomScenario _createCustomScenario() {
    return ScenarioSerializationService.fromBodies(
      bodies: _bodies,
      metadata: _metadata,
      physics: _physics,
      particleSystems: _particleSystems,
      objectives: _objectives,
    );
  }

  Future<void> _testScenario(BuildContext context, AppLocalizations l10n) async {
    // TODO: Implement test functionality - load scenario into simulation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test scenario functionality not implemented yet'),
        backgroundColor: AppColors.celestialOrange,
      ),
    );
  }

  Future<void> _exportScenario(BuildContext context, AppLocalizations l10n) async {
    try {
      final scenario = _createCustomScenario();
      final jsonString = ScenarioSerializationService.toJsonString(scenario);
      
      // TODO: Implement file export functionality
      print('Exported JSON:\n$jsonString'); // For development

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export scenario functionality not implemented yet'),
          backgroundColor: AppColors.celestialOrange,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export scenario: $e'),
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
          'Unsaved Changes',
          style: AppTypography.titleText,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
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
              'Discard',
              style: AppTypography.mediumText.copyWith(
                color: AppColors.celestialRed,
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }
}