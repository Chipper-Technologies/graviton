import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/body_data.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/models/experimental_scenario_config.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/models/scenario_metadata.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/screens/scenario_editor_screen.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/scenario_serialization_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/color_utils.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/scenario_selection/create_scenario_tile.dart';
import 'package:graviton/widgets/scenario_selection/custom_scenario_tile.dart';
import 'package:graviton/widgets/scenario_selection/experimental_scenario_tile.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

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

    // Check which experiment was selected and route accordingly
    if (experimentName == l10n.experimentBinaryPulsarName) {
      _openBinaryPulsarEditor(context, experiment);
    } else if (experimentName == l10n.experimentTrojanAsteroidsName) {
      _openTrojanAsteroidsEditor(context, experiment);
    } else {
      // For other experiments, show "coming soon" message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.experimentComingSoon(experimentName)),
          backgroundColor: experiment.color,
        ),
      );
    }
  }

  /// Create and open Binary Pulsar scenario in editor
  Future<void> _openBinaryPulsarEditor(
    BuildContext context,
    ExperimentalScenarioConfig experiment,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // Create Binary Pulsar scenario with pre-populated data
    final binaryPulsarScenario = _createBinaryPulsarScenario(l10n, experiment);

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioEditorScreen(
          isEditing: false,
          initialScenario: binaryPulsarScenario,
        ),
      ),
    );

    if (result == true) {
      // Reload custom scenarios if the Binary Pulsar was saved
      await _loadCustomScenarios();
    }
  }

  /// Create and open Trojan Asteroids scenario in editor
  Future<void> _openTrojanAsteroidsEditor(
    BuildContext context,
    ExperimentalScenarioConfig experiment,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // Create Trojan Asteroids scenario with pre-populated data
    final trojanAsteroidsScenario = _createTrojanAsteroidsScenario(
      l10n,
      experiment,
    );

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioEditorScreen(
          isEditing: false,
          initialScenario: trojanAsteroidsScenario,
        ),
      ),
    );

    if (result == true) {
      // Reload custom scenarios if the Trojan Asteroids was saved
      await _loadCustomScenarios();
    }
  }

  /// Create a pre-configured Binary Pulsar scenario
  CustomScenario _createBinaryPulsarScenario(
    AppLocalizations l10n,
    ExperimentalScenarioConfig experiment,
  ) {
    // Binary Pulsar: Two neutron stars spiraling inward due to gravitational waves
    // Based on the famous Hulse-Taylor binary pulsar PSR B1913+16

    final bodies = <BodyData>[];

    // Neutron star properties (extremely dense, small radius, high mass)
    const neutronStarMass = 15.0; // High mass for strong gravitational effects
    const neutronStarRadius =
        0.8; // Small radius (neutron stars are very compact)
    const orbitalSeparation =
        8.0; // Close orbit for strong relativistic effects

    // Calculate orbital velocity for a circular orbit
    const gravitationalConstant = 1.2;
    final orbitalSpeed =
        math.sqrt(gravitationalConstant * neutronStarMass / orbitalSeparation) *
        0.6;

    // Neutron Star A (Pulsar)
    bodies.add(
      BodyData(
        name: l10n.binaryPulsarPulsarA,
        position: [-orbitalSeparation / 2, 0.0, 0.0],
        velocity: [0.0, orbitalSpeed, 0.0],
        mass: neutronStarMass,
        radius: neutronStarRadius,
        color: ColorUtils.colorToHexRGB(
          AppColors.pulsarCyan,
        ), // Cyan - high energy pulsar radiation
        bodyType: BodyType.star,
        stellarLuminosity: 8.0, // High luminosity from magnetic field radiation
        temperature: 1000000.0, // Extremely hot neutron star surface
        showGravityWell: true,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.tooHot,
      ),
    );

    // Neutron Star B (Companion)
    bodies.add(
      BodyData(
        name: l10n.binaryPulsarNeutronStarB,
        position: [orbitalSeparation / 2, 0.0, 0.0],
        velocity: [0.0, -orbitalSpeed, 0.0],
        mass: neutronStarMass * 0.9, // Slightly less massive companion
        radius: neutronStarRadius,
        color: ColorUtils.colorToHexRGB(
          AppColors.habitabilityHighRadiation,
        ), // Pink - companion neutron star
        bodyType: BodyType.star,
        stellarLuminosity: 6.0, // Lower luminosity companion
        temperature: 800000.0, // Hot but slightly cooler
        showGravityWell: true,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.tooHot,
      ),
    );

    // Convert BodyData to Body objects for ScenarioSerializationService
    final bodyObjects = bodies.map((bodyData) {
      return Body(
        name: bodyData.name,
        position: vm.Vector3(
          bodyData.position[0],
          bodyData.position[1],
          bodyData.position[2],
        ),
        velocity: vm.Vector3(
          bodyData.velocity[0],
          bodyData.velocity[1],
          bodyData.velocity[2],
        ),
        mass: bodyData.mass,
        radius: bodyData.radius,
        color: ColorUtils.parseHexColor(bodyData.color),
        bodyType: bodyData.bodyType,
        stellarLuminosity: bodyData.stellarLuminosity,
      );
    }).toList();

    // Create scenario metadata with experiment information
    final metadata = ScenarioMetadata(
      name: experiment.name(l10n),
      description:
          '${experiment.description(l10n)}\n\n${l10n.binaryPulsarScenarioDescription}',
      author: l10n.binaryPulsarAuthor,
      createdAt: DateTime.now(),
      educationalFocus: l10n.binaryPulsarEducationalFocus,
      tags: experiment.tags,
      difficulty: experiment.difficulty(l10n),
    );

    // Physics settings optimized for Binary Pulsar
    final physics = ScenarioPhysicsSettings(
      gravitationalConstant: 1.2, // Standard gravitational constant
      softening: 0.05, // Lower softening for precise close interactions
      timeScale: 0.8, // Slightly slower time for observation
      collisionRadiusMultiplier: 1.5, // Slightly larger collision detection
      maxTrailPoints: 800, // More trail points to show orbital decay
      trailFadeRate: 0.98, // Slower fade to show historical path
    );

    return ScenarioSerializationService.fromBodies(
      bodies: bodyObjects,
      metadata: metadata,
      physics: physics,
      particleSystems: const ParticleSystemsConfig(),
      objectives: null,
    );
  }

  /// Create a pre-configured Trojan Asteroids scenario
  CustomScenario _createTrojanAsteroidsScenario(
    AppLocalizations l10n,
    ExperimentalScenarioConfig experiment,
  ) {
    // Trojan Asteroids: Jupiter with asteroids at L4 and L5 Lagrange points
    // Demonstrates stable orbital mechanics and three-body dynamics

    final bodies = <BodyData>[];

    // Jupiter-Sun system properties with realistic mass scaling
    const sunMass =
        50.0; // Solar masses (consistent with solar system scenario)
    const jupiterMass =
        1.6; // Earth masses (scaled appropriately for stability)
    const jupiterOrbitRadius = 35.0; // Increased for more stable dynamics
    const sunRadius = 3.0;
    const jupiterRadius = 2.2;

    // Calculate Jupiter's orbital velocity for circular orbit - NO REDUCTION FACTOR
    const gravitationalConstant = 1.2;
    final jupiterOrbitalSpeed = math.sqrt(
      gravitationalConstant * sunMass / jupiterOrbitRadius,
    );

    // Sun at center
    bodies.add(
      BodyData(
        name: l10n.trojanAsteroidsSun,
        position: [0.0, 0.0, 0.0],
        velocity: [0.0, 0.0, 0.0],
        mass: sunMass,
        radius: sunRadius,
        color: ColorUtils.colorToHexRGB(
          AppColors.celestialGold,
        ), // Gold - classic sun color
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
        temperature: 5778.0, // Sun's surface temperature
        showGravityWell: true,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.tooHot,
      ),
    );

    // Jupiter
    bodies.add(
      BodyData(
        name: l10n.trojanAsteroidsJupiter,
        position: [jupiterOrbitRadius, 0.0, 0.0],
        velocity: [0.0, jupiterOrbitalSpeed, 0.0],
        mass: jupiterMass,
        radius: jupiterRadius,
        color: ColorUtils.colorToHexRGB(
          AppColors.temperatureHot,
        ), // Orange - Jupiter's color
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 165.0, // Jupiter's temperature
        showGravityWell: true,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.gasGiant,
      ),
    );

    // Trojan asteroids at L4 point (60 degrees ahead of Jupiter)
    final l4Angle = math.pi / 3; // 60 degrees in radians
    final l4X = jupiterOrbitRadius * math.cos(l4Angle);
    final l4Y = jupiterOrbitRadius * math.sin(l4Angle);
    final l4VelX = -jupiterOrbitalSpeed * math.sin(l4Angle);
    final l4VelY = jupiterOrbitalSpeed * math.cos(l4Angle);

    // Add several L4 Trojan asteroids
    for (int i = 0; i < 4; i++) {
      final offset = (i - 1.5) * 2.5; // Increased spacing to prevent merging
      final perturbX = offset * math.cos(l4Angle + math.pi / 2);
      final perturbY = offset * math.sin(l4Angle + math.pi / 2);

      bodies.add(
        BodyData(
          name: l10n.trojanAsteroidsL4Name(i + 1),
          position: [l4X + perturbX, l4Y + perturbY, 0.0],
          velocity: [l4VelX, l4VelY, 0.0],
          mass: 0.008, // Reduced mass to minimize gravitational interactions
          radius: 0.25, // Increased radius for better collision detection
          color: ColorUtils.colorToHexRGB(
            AppColors.asteroidRockyBrown,
          ), // Brown - rocky asteroid color
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
          temperature: 150.0,
          showGravityWell: false,
          isPlanet: false,
          habitabilityStatus: HabitabilityStatus.tooSmall,
        ),
      );
    }

    // Trojan asteroids at L5 point (60 degrees behind Jupiter)
    final l5Angle = -math.pi / 3; // -60 degrees in radians
    final l5X = jupiterOrbitRadius * math.cos(l5Angle);
    final l5Y = jupiterOrbitRadius * math.sin(l5Angle);
    final l5VelX = -jupiterOrbitalSpeed * math.sin(l5Angle);
    final l5VelY = jupiterOrbitalSpeed * math.cos(l5Angle);

    // Add several L5 Trojan asteroids
    for (int i = 0; i < 4; i++) {
      final offset = (i - 1.5) * 2.5; // Increased spacing to prevent merging
      final perturbX = offset * math.cos(l5Angle + math.pi / 2);
      final perturbY = offset * math.sin(l5Angle + math.pi / 2);

      bodies.add(
        BodyData(
          name: l10n.trojanAsteroidsL5Name(i + 1),
          position: [l5X + perturbX, l5Y + perturbY, 0.0],
          velocity: [l5VelX, l5VelY, 0.0],
          mass: 0.008, // Reduced mass to minimize gravitational interactions
          radius: 0.25, // Increased radius for better collision detection
          color: ColorUtils.colorToHexRGB(
            AppColors.asteroidSienna,
          ), // Sienna - varied asteroid color
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
          temperature: 150.0,
          showGravityWell: false,
          isPlanet: false,
          habitabilityStatus: HabitabilityStatus.tooSmall,
        ),
      );
    }

    // Convert BodyData to Body objects
    final bodyObjects = bodies.map((bodyData) {
      return Body(
        name: bodyData.name,
        position: vm.Vector3(
          bodyData.position[0],
          bodyData.position[1],
          bodyData.position[2],
        ),
        velocity: vm.Vector3(
          bodyData.velocity[0],
          bodyData.velocity[1],
          bodyData.velocity[2],
        ),
        mass: bodyData.mass,
        radius: bodyData.radius,
        color: ColorUtils.parseHexColor(bodyData.color),
        bodyType: bodyData.bodyType,
        stellarLuminosity: bodyData.stellarLuminosity,
      );
    }).toList();

    // Create scenario metadata
    final metadata = ScenarioMetadata(
      name: experiment.name(l10n),
      description:
          '${experiment.description(l10n)}\n\n${l10n.trojanAsteroidsScenarioDescription}',
      author: l10n.binaryPulsarAuthor, // Same author for physics experiments
      createdAt: DateTime.now(),
      educationalFocus: l10n.trojanAsteroidsEducationalFocus,
      tags: experiment.tags,
      difficulty: experiment.difficulty(l10n),
    );

    // Physics settings optimized for stable Lagrange point dynamics
    final physics = ScenarioPhysicsSettings(
      gravitationalConstant: 1.2, // Standard gravitational constant
      softening: 0.08, // Increased softening to prevent close encounters
      timeScale: 1.0, // Normal time scale for stable integration
      collisionRadiusMultiplier:
          2.0, // Enhanced collision detection to prevent merging
      maxTrailPoints: 600, // Medium trail length for orbit visualization
      trailFadeRate: 0.95, // Standard fade rate
    );

    return ScenarioSerializationService.fromBodies(
      bodies: bodyObjects,
      metadata: metadata,
      physics: physics,
      particleSystems: const ParticleSystemsConfig(),
      objectives: null,
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
