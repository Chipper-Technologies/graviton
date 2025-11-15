import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/color_utils.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
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
  List<CustomScenario> _customScenarios = [];
  bool _isLoading = true;
  String? _selectedExperiment;

  @override
  void initState() {
    super.initState();
    _loadCustomScenarios();
    _cleanupOldTestScenarios(); // Clean up any leftover test scenarios
  }

  Future<void> _cleanupOldTestScenarios() async {
    try {
      final allScenarios = await CustomScenarioStorage.getAllScenarios();

      // Find test scenarios that are older than 1 minute (stale)
      final now = DateTime.now();
      final staleTestScenarios = allScenarios.where((scenario) {
        final isTestScenario = scenario.metadata.name.startsWith(
          '__test_scenario_',
        );
        if (!isTestScenario) return false;

        // Extract timestamp from name (format: __test_scenario_<milliseconds>)
        final nameParts = scenario.metadata.name.split('_');
        if (nameParts.length < 4) return true; // Invalid format, remove it

        try {
          final timestamp = int.parse(nameParts[3]);
          final scenarioTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          return now.difference(scenarioTime).inMinutes > 1;
        } catch (e) {
          return true; // Invalid timestamp, remove it
        }
      }).toList();

      // Remove stale test scenarios
      for (final scenario in staleTestScenarios) {
        try {
          await CustomScenarioStorage.deleteScenario(scenario.metadata.name);
        } catch (e) {
          // Silent cleanup - don't spam logs
        }
      }
    } catch (e) {
      // Silent cleanup failure
    }
  }

  Future<void> _loadCustomScenarios() async {
    try {
      final allScenarios = await CustomScenarioStorage.getAllScenarios();

      // Filter out temporary test scenarios to prevent them from showing in UI
      final visibleScenarios = allScenarios
          .where(
            (scenario) =>
                !scenario.metadata.name.startsWith('__test_scenario_'),
          )
          .toList();

      if (mounted) {
        setState(() {
          _customScenarios = visibleScenarios;
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

          // Scenarios count header (only show if there are scenarios)
          if (_customScenarios.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTypography.spacingLarge,
              ),
              child: Text(
                l10n.scenariosHeaderPlural(_customScenarios.length),
                style: AppTypography.titleText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                ),
              ),
            ),
          if (_customScenarios.isNotEmpty)
            SizedBox(height: AppTypography.spacingMedium),

          // Saved scenarios list
          if (_customScenarios.isEmpty)
            _buildEmptyState(l10n)
          else
            ..._customScenarios.map((scenario) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppTypography.spacingSmall),
                child: CustomScenarioTile(
                  scenarioName: scenario.metadata.name,
                  scenarioDescription: scenario.metadata.description,
                  isSelected: false,
                  onTap: () =>
                      _editCustomScenario(context, scenario.metadata.name),
                  onView: () =>
                      _viewCustomScenario(context, scenario.metadata.name),
                  onExport: () =>
                      _exportCustomScenario(context, scenario.metadata.name),
                  onEdit: () =>
                      _editCustomScenario(context, scenario.metadata.name),
                  onDelete: () =>
                      _deleteCustomScenario(context, scenario.metadata.name),
                ),
              );
            }),

          // Experiments section
          SectionDivider.labeled(
            l10n.experimentsTitle,
            topSpacing: AppTypography.spacingSmall,
            bottomSpacing: AppTypography.spacingMedium,
          ),

          // Experiments count header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingLarge,
            ),
            child: Text(
              l10n.experimentsHeaderPlural(
                ExperimentalScenarioConfig.experiments.length,
              ),
              style: AppTypography.titleText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
              ),
            ),
          ),
          SizedBox(height: AppTypography.spacingMedium),

          // Experiments grid
          _buildExperimentsGrid(context),
        ],
      ),
    );
  }

  /// Build empty state when no saved scenarios exist
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              textAlign: TextAlign.center,
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
    } else if (experimentName == l10n.experimentDoubleStarEclipseName) {
      _openDoubleStarEclipseEditor(context, experiment);
    } else if (experimentName == l10n.experimentRoguePlanetName) {
      _openRoguePlanetEditor(context, experiment);
    } else {
      // For other experiments, show "coming soon" message
      GravitonSnackBar.info(
        context: context,
        message: l10n.experimentComingSoon(experimentName),
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

  /// Create and open Double Star Eclipse scenario in editor
  Future<void> _openDoubleStarEclipseEditor(
    BuildContext context,
    ExperimentalScenarioConfig experiment,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // Create Double Star Eclipse scenario with pre-populated data
    final doubleStarEclipseScenario = _createDoubleStarEclipseScenario(
      l10n,
      experiment,
    );

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioEditorScreen(
          isEditing: false,
          initialScenario: doubleStarEclipseScenario,
        ),
      ),
    );

    if (result == true) {
      // Reload custom scenarios if the Double Star Eclipse was saved
      await _loadCustomScenarios();
    }
  }

  /// Create and open Rogue Planet scenario in editor
  Future<void> _openRoguePlanetEditor(
    BuildContext context,
    ExperimentalScenarioConfig experiment,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // Create Rogue Planet scenario with pre-populated data
    final roguePlanetScenario = _createRoguePlanetScenario(l10n, experiment);

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioEditorScreen(
          isEditing: false,
          initialScenario: roguePlanetScenario,
        ),
      ),
    );

    if (result == true) {
      // Reload custom scenarios if the Rogue Planet was saved
      await _loadCustomScenarios();
    }
  }

  /// Create a pre-configured Binary Pulsar scenario
  CustomScenario _createBinaryPulsarScenario(
    AppLocalizations l10n,
    ExperimentalScenarioConfig experiment,
  ) {
    // Get the global gravity fields setting
    final appState = Provider.of<AppState>(context, listen: false);
    final shouldShowGravityWells = appState.ui.globalGravityFields;

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
        bodyType: BodyType.neutronStar, // Now using proper neutron star type
        stellarLuminosity: 8.0, // High luminosity from magnetic field radiation
        temperature: 1000000.0, // Extremely hot neutron star surface
        showGravityWell: shouldShowGravityWells,
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
        bodyType: BodyType.neutronStar, // Now using proper neutron star type
        stellarLuminosity: 6.0, // Lower luminosity companion
        temperature: 800000.0, // Hot but slightly cooler
        showGravityWell: shouldShowGravityWells,
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
        showGravityWell: bodyData.showGravityWell,
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
    // Get the global gravity fields setting
    final appState = Provider.of<AppState>(context, listen: false);
    final shouldShowGravityWells = appState.ui.globalGravityFields;

    // Trojan Asteroids: Jupiter with asteroids at L4 and L5 Lagrange points
    // Demonstrates stable orbital mechanics and three-body dynamics

    final bodies = <BodyData>[];

    // Jupiter-Sun system properties with realistic mass scaling
    const sunMass =
        50.0; // Solar masses (consistent with solar system scenario)
    const jupiterMass =
        1.6; // Earth masses (scaled appropriately for stability)
    const jupiterOrbitRadius = 35.0;
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
        showGravityWell: shouldShowGravityWells,
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
        showGravityWell: shouldShowGravityWells,
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

    // Add several L4 Trojan asteroids - MUCH closer to exact Lagrange point
    for (int i = 0; i < 3; i++) {
      final offset =
          (i - 1.0) * 0.8; // Much smaller perturbations (±0.8 instead of ±3.75)
      final perturbX = offset * math.cos(l4Angle + math.pi / 2);
      final perturbY = offset * math.sin(l4Angle + math.pi / 2);

      bodies.add(
        BodyData(
          name: l10n.trojanAsteroidsL4Name(i + 1),
          position: [l4X + perturbX, l4Y + perturbY, 0.0],
          velocity: [l4VelX, l4VelY, 0.0],
          mass:
              0.00001, // Even smaller mass - 10x reduction for near-zero gravity
          radius: 0.10, // Smaller radius for asteroids
          color: ColorUtils.colorToHexRGB(
            AppColors.asteroidRockyBrown,
          ), // Brown - rocky asteroid color
          bodyType: BodyType.asteroid, // Correct asteroid body type
          stellarLuminosity: 0.0,
          temperature: 150.0,
          showGravityWell: shouldShowGravityWells,
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

    // Add several L5 Trojan asteroids - MUCH closer to exact Lagrange point
    for (int i = 0; i < 3; i++) {
      final offset =
          (i - 1.0) * 0.8; // Much smaller perturbations (±0.8 instead of ±3.75)
      final perturbX = offset * math.cos(l5Angle + math.pi / 2);
      final perturbY = offset * math.sin(l5Angle + math.pi / 2);

      bodies.add(
        BodyData(
          name: l10n.trojanAsteroidsL5Name(i + 1),
          position: [l5X + perturbX, l5Y + perturbY, 0.0],
          velocity: [l5VelX, l5VelY, 0.0],
          mass:
              0.00001, // Even smaller mass - 10x reduction for near-zero gravity
          radius: 0.10, // Smaller radius for asteroids
          color: ColorUtils.colorToHexRGB(
            AppColors.asteroidSienna,
          ), // Sienna - varied asteroid color
          bodyType: BodyType.asteroid, // Correct asteroid body type
          stellarLuminosity: 0.0,
          temperature: 150.0,
          showGravityWell: shouldShowGravityWells,
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
        showGravityWell: bodyData.showGravityWell,
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
      softening: 0.15, // Higher softening for asteroid stability (was 0.08)
      timeScale:
          0.9, // Slightly slower time scale for stable integration (was 1.0)
      collisionRadiusMultiplier:
          2.5, // Higher collision detection to prevent close encounters (was 2.0)
      maxTrailPoints:
          400, // Fewer trail points for better performance (was 600)
      trailFadeRate: 0.94, // Faster fade rate (was 0.95)
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
          GravitonSnackBar.success(
            context: context,
            message: l10n.deleteScenarioSuccessMessage(scenarioName),
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
          GravitonSnackBar.error(
            context: context,
            message: l10n.deleteScenarioFailedMessage(e.toString()),
          );
        }
      }
    }
  }

  Future<void> _viewCustomScenario(
    BuildContext context,
    String scenarioName,
  ) async {
    // Log analytics for scenario viewing
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.customScenarioLoaded,
      element: UIElement.customScenariosTab,
      value: scenarioName,
    );

    // Load the scenario into the simulation
    widget.onCustomScenarioSelected?.call(scenarioName);
  }

  Future<void> _exportCustomScenario(
    BuildContext context,
    String scenarioName,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final customScenario = await CustomScenarioStorage.loadScenario(
        scenarioName,
      );
      if (customScenario == null) return;

      final jsonString = ScenarioSerializationService.toJsonString(
        customScenario,
      );

      // Log analytics for scenario export
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.scenarioExported,
        element: UIElement.customScenariosTab,
        additionalParams: {
          'body_count': customScenario.bodies.length,
          'scenario_name': scenarioName,
          'export_size_bytes': jsonString.length,
        },
      );

      // TODO: Implement file export functionality
      debugPrint(
        'Exported JSON for $scenarioName:\n$jsonString',
      ); // For development

      if (context.mounted) {
        GravitonSnackBar.warning(
          context: context,
          message: l10n.exportScenarioNotImplementedMessage,
        );
      }
    } catch (e) {
      // Log error analytics
      FirebaseService.instance.logErrorEvent(
        'scenario_export_failed',
        errorMessage: e.toString(),
        context: 'custom_scenarios_tab',
      );

      if (context.mounted) {
        GravitonSnackBar.error(
          context: context,
          message: l10n.exportScenarioFailedMessage(e.toString()),
        );
      }
    }
  }

  /// Create a pre-configured Double Star Eclipse scenario
  CustomScenario _createDoubleStarEclipseScenario(
    AppLocalizations l10n,
    ExperimentalScenarioConfig experiment,
  ) {
    // Get the global gravity fields setting
    final appState = Provider.of<AppState>(context, listen: false);
    final shouldShowGravityWells = appState.ui.globalGravityFields;

    // Double Star Eclipse: A binary star system where one star regularly eclipses the other
    // Educational focus on eclipsing binary systems and stellar photometry

    final bodies = <BodyData>[];

    // Binary star system properties
    const primaryStarMass = 25.0; // Primary star (larger, brighter)
    const secondaryStarMass = 15.0; // Secondary star (smaller, dimmer)
    const orbitalSeparation = 18.0; // Distance between stars
    const primaryStarRadius = 3.2; // Larger primary star
    const secondaryStarRadius = 2.1; // Smaller secondary star

    // Calculate orbital velocities for circular orbit
    const gravitationalConstant = 1.2;
    final totalMass = primaryStarMass + secondaryStarMass;
    final orbitalSpeed = math.sqrt(
      gravitationalConstant * totalMass / orbitalSeparation,
    );

    // Primary star (larger, stationary at center for simplicity)
    bodies.add(
      BodyData(
        name: l10n.bodyPrimaryStar,
        position: [-orbitalSeparation * 0.4, 0.0, 0.0],
        velocity: [0.0, -orbitalSpeed * 0.3, 0.0],
        mass: primaryStarMass,
        radius: primaryStarRadius,
        color: ColorUtils.colorToHexRGB(
          AppColors.stellarOType,
        ).substring(1), // Blue-white primary star
        bodyType: BodyType.star,
        stellarLuminosity: 12.0, // High luminosity
        temperature: 15000.0, // Hot O-type star
        showGravityWell: shouldShowGravityWells,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.tooHot,
      ),
    );

    // Secondary star (smaller, orbiting)
    bodies.add(
      BodyData(
        name: l10n.bodySecondaryStar,
        position: [orbitalSeparation * 0.6, 0.0, 0.0],
        velocity: [0.0, orbitalSpeed * 0.7, 0.0],
        mass: secondaryStarMass,
        radius: secondaryStarRadius,
        color: ColorUtils.colorToHexRGB(
          AppColors.stellarKType,
        ).substring(1), // Orange secondary star
        bodyType: BodyType.star,
        stellarLuminosity: 6.0, // Lower luminosity
        temperature: 4500.0, // K-type star
        showGravityWell: shouldShowGravityWells,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.tooHot,
      ),
    );

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
        showGravityWell: bodyData.showGravityWell,
      );
    }).toList();

    // Create scenario metadata
    final metadata = ScenarioMetadata(
      name: experiment.name(l10n),
      description:
          '${experiment.description(l10n)}\n\n${l10n.doubleStarEclipseScenarioDescription}',
      author: l10n.authorGravitonPhysicsTeam,
      createdAt: DateTime.now(),
      educationalFocus: l10n.doubleStarEclipseEducationalFocus,
      tags: experiment.tags,
      difficulty: experiment.difficulty(l10n),
    );

    // Physics settings optimized for binary star system
    final physics = ScenarioPhysicsSettings(
      gravitationalConstant: 1.2,
      softening: 0.1, // Low softening for precise orbital mechanics
      timeScale: 1.2, // Slightly faster time for observable eclipses
      collisionRadiusMultiplier: 1.0, // Standard collision detection
      maxTrailPoints: 400, // Medium trail length for orbital paths
      trailFadeRate: 0.96, // Moderate fade rate
    );

    return ScenarioSerializationService.fromBodies(
      bodies: bodyObjects,
      metadata: metadata,
      physics: physics,
      particleSystems: const ParticleSystemsConfig(),
      objectives: null,
    );
  }

  /// Create a pre-configured Rogue Planet scenario
  CustomScenario _createRoguePlanetScenario(
    AppLocalizations l10n,
    ExperimentalScenarioConfig experiment,
  ) {
    // Get the global gravity fields setting
    final appState = Provider.of<AppState>(context, listen: false);
    final shouldShowGravityWells = appState.ui.globalGravityFields;

    // Rogue Planet: A planet ejected from its original system encounters a new solar system
    // Demonstrates gravitational slingshot effects and chaotic dynamics

    final bodies = <BodyData>[];
    final random = math.Random();

    // Central star of the target solar system (much higher mass for stability)
    const starMass = 120.0; // Doubled mass for strong gravitational dominance
    const starRadius = 3.5;

    bodies.add(
      BodyData(
        name: l10n.bodyCentralStar,
        position: [0.0, 0.0, 0.0],
        velocity: [0.0, 0.0, 0.0],
        mass: starMass,
        radius: starRadius,
        color: ColorUtils.colorToHexRGB(
          AppColors.stellarGType,
        ).substring(1), // Sun-like G-type star
        bodyType: BodyType.star,
        stellarLuminosity: 10.0,
        temperature: 5800.0, // Sun-like temperature
        showGravityWell: shouldShowGravityWells,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.tooHot,
      ),
    );

    // Inner rocky planet (Mercury-like) - randomize starting position
    const innerPlanetOrbitRadius = 40.0; // Much more separation
    final innerPlanetOrbitalSpeed = math.sqrt(
      1.2 * starMass / innerPlanetOrbitRadius,
    );
    final innerPlanetAngle =
        random.nextDouble() * 2 * math.pi; // Random angle 0-360 degrees

    bodies.add(
      BodyData(
        name: l10n.bodyInnerRockyPlanet,
        position: [
          innerPlanetOrbitRadius * math.cos(innerPlanetAngle),
          innerPlanetOrbitRadius * math.sin(innerPlanetAngle),
          0.0,
        ],
        velocity: [
          -innerPlanetOrbitalSpeed * math.sin(innerPlanetAngle),
          innerPlanetOrbitalSpeed * math.cos(innerPlanetAngle),
          0.0,
        ],
        mass: 0.8, // Much smaller mass for minimal interference
        radius: 0.7,
        color: ColorUtils.colorToHexRGB(
          AppColors.terrestrialRockyMercury,
        ).substring(1), // Mercury-like rocky planet
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 450.0, // Hot inner planet
        showGravityWell: shouldShowGravityWells,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.tooHot,
      ),
    );

    // Habitable zone planet (Earth-like) - randomize starting position
    const habitablePlanetOrbitRadius = 80.0; // Much better spacing
    final habitablePlanetOrbitalSpeed = math.sqrt(
      1.2 * starMass / habitablePlanetOrbitRadius,
    );
    final habitablePlanetAngle =
        random.nextDouble() * 2 * math.pi; // Random angle 0-360 degrees

    bodies.add(
      BodyData(
        name: l10n.bodyHabitablePlanet,
        position: [
          habitablePlanetOrbitRadius * math.cos(habitablePlanetAngle),
          habitablePlanetOrbitRadius * math.sin(habitablePlanetAngle),
          0.0,
        ],
        velocity: [
          -habitablePlanetOrbitalSpeed * math.sin(habitablePlanetAngle),
          habitablePlanetOrbitalSpeed * math.cos(habitablePlanetAngle),
          0.0,
        ],
        mass: 3.0, // Much smaller mass for stability
        radius: 1.5,
        color: ColorUtils.colorToHexRGB(
          AppColors.terrestrialEarthLike,
        ).substring(1), // Earth-like terrestrial planet
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 288.0, // Earth-like temperature
        showGravityWell: shouldShowGravityWells,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.habitable,
      ),
    );

    // Outer gas giant (Jupiter-like) - randomize starting position
    const gasGiantOrbitRadius = 160.0; // Much more separation
    final gasGiantOrbitalSpeed = math.sqrt(
      1.2 * starMass / gasGiantOrbitRadius,
    );
    final gasGiantAngle =
        random.nextDouble() * 2 * math.pi; // Random angle 0-360 degrees

    bodies.add(
      BodyData(
        name: l10n.bodyGasGiant,
        position: [
          gasGiantOrbitRadius * math.cos(gasGiantAngle),
          gasGiantOrbitRadius * math.sin(gasGiantAngle),
          0.0,
        ],
        velocity: [
          -gasGiantOrbitalSpeed * math.sin(gasGiantAngle),
          gasGiantOrbitalSpeed * math.cos(gasGiantAngle),
          0.0,
        ],
        mass: 6.0, // Much smaller mass to minimize perturbations
        radius: 2.2,
        color: ColorUtils.colorToHexRGB(
          AppColors.gasGiantJupiterLike,
        ).substring(1), // Jupiter-like gas giant
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 120.0, // Cold outer planet
        showGravityWell: shouldShowGravityWells,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.gasGiant,
      ),
    );

    // Ice giant in outer system - randomize starting position
    const iceGiantOrbitRadius = 240.0; // Much more separation
    final iceGiantOrbitalSpeed = math.sqrt(
      1.2 * starMass / iceGiantOrbitRadius,
    );
    final iceGiantAngle =
        random.nextDouble() * 2 * math.pi; // Random angle 0-360 degrees

    bodies.add(
      BodyData(
        name: l10n.bodyIceGiant,
        position: [
          iceGiantOrbitRadius * math.cos(iceGiantAngle),
          iceGiantOrbitRadius * math.sin(iceGiantAngle),
          0.0,
        ],
        velocity: [
          -iceGiantOrbitalSpeed * math.sin(iceGiantAngle),
          iceGiantOrbitalSpeed * math.cos(iceGiantAngle),
          0.0,
        ],
        mass: 4.0, // Much smaller mass for stability
        radius: 1.8,
        color: ColorUtils.colorToHexRGB(
          AppColors.iceGiantNeptuneLike,
        ).substring(1), // Neptune-like ice giant
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 60.0, // Very cold outer planet
        showGravityWell: shouldShowGravityWells,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.tooCold,
      ),
    );

    // Rogue planet approaching at random angle and trajectory for gravitational encounters
    // Randomize approach direction, distance, and 3D trajectory
    const roguePlanetMass = 18.0; // Massive rogue planet

    // Randomize approach distance and angle
    final rogueApproachDistance =
        300.0 + (random.nextDouble() * 100.0); // 300-400 units
    final rogueApproachAngle =
        random.nextDouble() * 2 * math.pi; // Random approach direction
    final rogueApproachSpeed =
        1.8 + (random.nextDouble() * 0.8); // 1.8-2.6 speed variation

    // Add 3D component - rogue planet can approach from above or below the system plane
    final rogueZOffset =
        (random.nextDouble() - 0.5) * 100.0; // ±50 units above/below plane
    final rogueZVelocity =
        (random.nextDouble() - 0.5) * 0.4; // Small vertical velocity component

    // Calculate randomized approach vector
    final rogueStartX = rogueApproachDistance * math.cos(rogueApproachAngle);
    final rogueStartY = rogueApproachDistance * math.sin(rogueApproachAngle);

    // Velocity vector aims roughly toward system center with some randomization
    final targetAngle =
        rogueApproachAngle +
        math.pi +
        (random.nextDouble() - 0.5) * 0.6; // ±17 degrees variation
    final rogueVelX = rogueApproachSpeed * math.cos(targetAngle);
    final rogueVelY = rogueApproachSpeed * math.sin(targetAngle);

    bodies.add(
      BodyData(
        name: l10n.bodyRoguePlanet,
        position: [
          rogueStartX,
          rogueStartY,
          rogueZOffset,
        ], // Randomized 3D approach position
        velocity: [
          rogueVelX,
          rogueVelY,
          rogueZVelocity,
        ], // Randomized 3D trajectory toward system
        mass: roguePlanetMass,
        radius: 2.8,
        color: ColorUtils.colorToHexRGB(
          AppColors.temperatureCold,
        ).substring(1), // Dark cold coloring for the wandering planet
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 30.0, // Extremely cold from interstellar space
        showGravityWell: shouldShowGravityWells,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.tooCold,
      ),
    );

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
        showGravityWell: bodyData.showGravityWell,
      );
    }).toList();

    // Create scenario metadata
    final metadata = ScenarioMetadata(
      name: experiment.name(l10n),
      description:
          '${experiment.description(l10n)}\n\n${l10n.roguePlanetScenarioDescription}',
      author: l10n.authorGravitonPhysicsTeam,
      createdAt: DateTime.now(),
      educationalFocus: l10n.roguePlanetEducationalFocus,
      tags: experiment.tags,
      difficulty: experiment.difficulty(l10n),
    );

    // Physics settings optimized for maximum stability
    final physics = ScenarioPhysicsSettings(
      gravitationalConstant: 1.2,
      softening: 1.0, // Much higher softening for maximum stability
      timeScale: 0.8, // Slower time scale for stable integration
      collisionRadiusMultiplier: 0.8, // Reduced collision detection
      maxTrailPoints: 300, // Fewer trails for better performance
      trailFadeRate: 0.96, // Standard fade rate
    );

    return ScenarioSerializationService.fromBodies(
      bodies: bodyObjects,
      metadata: metadata,
      physics: physics,
      particleSystems: const ParticleSystemsConfig(),
      objectives: null,
    );
  }
}
