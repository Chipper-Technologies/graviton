import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/custom_scenario_manager.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/utils/physics_utils.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:provider/provider.dart';

/// Screen displaying detailed information about the current simulation scenario
/// and statistics about the celestial bodies within it
class SimulationInfoScreen extends StatelessWidget {
  const SimulationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.transparentColor,
      appBar: HapticAppBar(title: l10n.simulationInfoTitle),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityNearlyOpaque,
          ),
          child: Consumer<AppState>(
            builder: (context, appState, child) {
              final scenario = appState.simulation.currentScenario;
              final bodies = appState.simulation.bodies;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppTypography.spacingLarge),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: AppConstraints.contentMaxWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildScenarioSection(context, l10n, scenario),
                        const SizedBox(height: AppTypography.spacingLarge),
                        _buildBodyStatisticsSection(context, l10n, bodies),
                        const SizedBox(height: AppTypography.spacingLarge),
                        _buildEnergyDynamicsSection(context, l10n, bodies),
                        const SizedBox(height: AppTypography.spacingLarge),
                        _buildOrbitalMechanicsSection(
                          context,
                          l10n,
                          bodies,
                          appState,
                        ),
                        const SizedBox(height: AppTypography.spacingLarge),
                        _buildPhysicsSection(context, l10n, appState),
                        const SizedBox(height: AppTypography.spacingLarge),
                        _buildCelestialBodiesSection(
                          context,
                          l10n,
                          bodies,
                          appState,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build the scenario information section using the standard _buildInfoSection pattern
  Widget _buildScenarioSection(
    BuildContext context,
    AppLocalizations l10n,
    ScenarioType scenario,
  ) {
    return _buildInfoSection(
      context,
      icon: Icons.public,
      title: _getScenarioName(l10n, scenario),
      content: _getScenarioDescription(l10n, scenario),
    );
  }

  /// Build the body statistics section
  Widget _buildBodyStatisticsSection(
    BuildContext context,
    AppLocalizations l10n,
    List<Body> bodies,
  ) {
    final stats = _calculateBodyStatistics(bodies);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(l10n.bodyStatisticsTitle),
        const SizedBox(height: AppTypography.spacingLarge),

        // Total Bodies and Total Mass row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.scatter_plot,
                label: l10n.totalBodiesLabel,
                value: bodies.length.toString(),
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.fitness_center,
                label: l10n.totalMassLabel,
                value: _formatMass(stats['totalMass']!),
                color: AppColors.uiOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // Stars and Planets row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.wb_sunny,
                label: l10n.starsLabel,
                value: stats['stars']!.toInt().toString(),
                color: AppColors.uiYellow,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.language,
                label: l10n.planetsLabel,
                value: stats['planets']!.toInt().toString(),
                color: AppColors.uiCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // Asteroids & Moons row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.brightness_1,
                label: l10n.asteroidsLabel,
                value: stats['asteroids']!.toInt().toString(),
                color: AppColors.uiGreen,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            const Expanded(child: SizedBox()),
          ],
        ),

        // Optional row for special objects
        if (stats['blackHoles']! > 0 || stats['habitableWorlds']! > 0) ...[
          const SizedBox(height: AppTypography.spacingSmall),
          Row(
            children: [
              if (stats['blackHoles']! > 0)
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.brightness_2,
                    label: l10n.blackHolesLabel,
                    value: stats['blackHoles']!.toInt().toString(),
                    color: AppColors.uiRed,
                  ),
                )
              else
                const Expanded(child: SizedBox()),
              const SizedBox(width: AppTypography.spacingSmall),
              if (stats['habitableWorlds']! > 0)
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.eco,
                    label: l10n.habitableWorldsLabel,
                    value: stats['habitableWorlds']!.toInt().toString(),
                    color: AppColors.terrestrialEarthLike,
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }

  /// Build the physics information section
  Widget _buildPhysicsSection(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    final sim = appState.simulation.simulation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(l10n.physicsInfoTitle),
        const SizedBox(height: AppTypography.spacingLarge),

        // Time Scale and Simulation Steps row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.speed,
                label: l10n.timeScaleLabel,
                value: '${appState.simulation.timeScale.toStringAsFixed(1)}x',
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.timeline,
                label: l10n.simulationStepsLabel,
                value: NumberUtils.formatSimulationSteps(
                  appState.simulation.stepCount,
                ),
                color: AppColors.uiCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // Gravitational Constant row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.science,
                label: l10n.gravitationalConstantLabel,
                value: sim.gravitationalConstant.toStringAsExponential(1),
                color: AppColors.uiGreen,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            const Expanded(child: SizedBox()), // Empty space for symmetry
          ],
        ),
      ],
    );
  }

  /// Build colored stat card using body details pattern
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingMedium),
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
            padding: const EdgeInsets.all(AppTypography.spacingSmall),
            decoration: BoxDecoration(
              color: color.withValues(alpha: AppTypography.opacityVeryFaint),
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
            ),
            child: Icon(icon, color: color, size: AppTypography.iconSizeMedium),
          ),
          const SizedBox(width: AppTypography.spacingMedium),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build info section using body tile pattern from scenario editor
  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
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
          // Icon indicator
          Container(
            width: AppTypography.spacingXXXLarge,
            height: AppTypography.spacingXXXLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: AppTypography.iconSizeMedium,
              color: AppColors.uiWhite,
            ),
          ),
          SizedBox(width: AppTypography.spacingLarge),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTypography.spacingXSmall),
                Text(
                  content,
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    fontSize: AppTypography.fontSizeMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get localized scenario name
  String _getScenarioName(AppLocalizations l10n, ScenarioType scenario) {
    switch (scenario) {
      case ScenarioType.random:
        return l10n.scenarioRandom;
      case ScenarioType.earthMoonSun:
        return l10n.scenarioEarthMoonSun;
      case ScenarioType.binaryStars:
        return l10n.scenarioBinaryStars;
      case ScenarioType.asteroidBelt:
        return l10n.scenarioAsteroidBelt;
      case ScenarioType.galaxyFormation:
        return l10n.scenarioGalaxyFormation;
      case ScenarioType.solarSystem:
        return l10n.scenarioSolarSystem;
      case ScenarioType.threeBodyClassic:
        return l10n.scenarioThreeBodyClassic;
      case ScenarioType.collisionDemo:
        return l10n.scenarioCollisionDemo;
      case ScenarioType.deepSpace:
        return l10n.scenarioDeepSpace;
      case ScenarioType.custom:
        final customName =
            CustomScenarioManager.instance.currentCustomScenarioName;
        return customName ?? l10n.scenarioCustom;
    }
  }

  /// Get localized scenario description
  String _getScenarioDescription(AppLocalizations l10n, ScenarioType scenario) {
    switch (scenario) {
      case ScenarioType.random:
        return l10n.scenarioRandomDescription;
      case ScenarioType.earthMoonSun:
        return l10n.scenarioEarthMoonSunDescription;
      case ScenarioType.binaryStars:
        return l10n.scenarioBinaryStarsDescription;
      case ScenarioType.asteroidBelt:
        return l10n.scenarioAsteroidBeltDescription;
      case ScenarioType.galaxyFormation:
        return l10n.scenarioGalaxyFormationDescription;
      case ScenarioType.solarSystem:
        return l10n.scenarioSolarSystemDescription;
      case ScenarioType.threeBodyClassic:
        return l10n.scenarioThreeBodyClassicDescription;
      case ScenarioType.collisionDemo:
        return l10n.scenarioCollisionDemoDescription;
      case ScenarioType.deepSpace:
        return l10n.scenarioDeepSpaceDescription;
      case ScenarioType.custom:
        final customScenario =
            CustomScenarioManager.instance.currentCustomScenario;
        return customScenario?.metadata.description ??
            l10n.scenarioCustomDescription;
    }
  }

  /// Build the energy and dynamics section
  Widget _buildEnergyDynamicsSection(
    BuildContext context,
    AppLocalizations l10n,
    List<Body> bodies,
  ) {
    if (bodies.isEmpty) return const SizedBox.shrink();

    final energyStats = _calculateEnergyStatistics(bodies);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(l10n.energyDynamicsTitle),
        const SizedBox(height: AppTypography.spacingLarge),

        // Total Energy and Kinetic Energy row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.flash_on,
                label: l10n.systemEnergyLabel,
                value: _formatEnergy(energyStats['totalEnergy']!),
                color: AppColors.uiPurple,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.speed,
                label: l10n.kineticEnergyLabel,
                value: _formatEnergy(energyStats['kineticEnergy']!),
                color: AppColors.uiBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // Potential Energy and Angular Momentum row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.waves,
                label: l10n.potentialEnergyLabel,
                value: _formatEnergy(energyStats['potentialEnergy']!),
                color: AppColors.uiRed,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.rotate_right,
                label: l10n.angularMomentumLabel,
                value: _formatAngularMomentum(
                  energyStats['angularMomentumMagnitude']!,
                ),
                color: AppColors.uiOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // System Momentum and Center of Mass row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.arrow_forward,
                label: l10n.systemMomentumLabel,
                value: _formatMomentum(energyStats['systemMomentumMagnitude']!),
                color: AppColors.uiGreen,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.my_location,
                label: l10n.centerOfMassLabel,
                value: _formatPosition(energyStats['centerOfMassDistance']!),
                color: AppColors.uiCyan,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build the orbital mechanics section
  Widget _buildOrbitalMechanicsSection(
    BuildContext context,
    AppLocalizations l10n,
    List<Body> bodies,
    AppState appState,
  ) {
    if (bodies.isEmpty) return const SizedBox.shrink();

    final velocityStats = _calculateVelocityStatistics(bodies);
    final tempStats = _calculateTemperatureStatistics(bodies);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(l10n.orbitalMechanicsTitle),
        const SizedBox(height: AppTypography.spacingLarge),

        // Velocity Range row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.speed,
                label: l10n.velocityRangeLabel,
                value:
                    '${NumberUtils.formatVelocity(velocityStats['min']!)} - ${NumberUtils.formatVelocity(velocityStats['max']!)}',
                color: AppColors.uiTeal,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.timeline,
                label: l10n.averageVelocityLabel,
                value: NumberUtils.formatVelocity(velocityStats['average']!),
                color: AppColors.uiIndigo,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // Temperature Range row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.thermostat,
                label: l10n.temperatureRangeLabel,
                value:
                    '${NumberUtils.formatTemperatureWithUnit(tempStats['min']!, appState.ui.temperatureUnit)} - ${NumberUtils.formatTemperatureWithUnit(tempStats['max']!, appState.ui.temperatureUnit)}',
                color: AppColors.uiAmber,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            const Expanded(child: SizedBox()), // Empty space for symmetry
          ],
        ),
      ],
    );
  }

  /// Build the individual celestial bodies section
  Widget _buildCelestialBodiesSection(
    BuildContext context,
    AppLocalizations l10n,
    List<Body> bodies,
    AppState appState,
  ) {
    if (bodies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(l10n.celestialBodiesTitle),
        const SizedBox(height: AppTypography.spacingLarge),

        // Create cards for each body in original simulation order
        ...bodies.asMap().entries.map((entry) {
          final index = entry.key;
          final body = entry.value;
          return Column(
            children: [
              _buildBodyCard(context, l10n, body, appState),
              if (index < bodies.length - 1)
                const SizedBox(height: AppTypography.spacingMedium),
            ],
          );
        }),
      ],
    );
  }

  /// Build an individual body information card
  Widget _buildBodyCard(
    BuildContext context,
    AppLocalizations l10n,
    Body body,
    AppState appState,
  ) {
    final bodyStats = _calculateIndividualBodyStats(body, context, appState);

    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            body.color.withValues(alpha: AppTypography.opacityDisabled),
            body.color.withValues(alpha: AppTypography.opacityBarely),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(
          color: body.color.withValues(alpha: AppTypography.opacityFaint),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with body name and type
          Row(
            children: [
              Container(
                width: AppTypography.iconSizeXXLarge,
                height: AppTypography.iconSizeXXLarge,
                decoration: BoxDecoration(
                  color: body.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: body.color.withValues(
                        alpha: AppTypography.opacityMedium,
                      ),
                      blurRadius: AppTypography.spacingSmall,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  _getBodyTypeIcon(body.bodyType),
                  color: AppColors.uiWhite,
                  size: AppTypography.iconSizeMedium,
                ),
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      body.name,
                      style: AppTypography.titleText.copyWith(
                        color: AppColors.uiWhite,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getBodyTypeDisplayName(l10n, body.bodyType),
                      style: AppTypography.smallText.copyWith(
                        color: body.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTypography.spacingMedium),

          // Body statistics in a grid
          _buildBodyStatsGrid(l10n, bodyStats, body),
        ],
      ),
    );
  }

  /// Build a grid of body statistics
  Widget _buildBodyStatsGrid(
    AppLocalizations l10n,
    Map<String, dynamic> stats,
    Body body,
  ) {
    return Column(
      children: [
        // Row 1: Mass and Radius
        Row(
          children: [
            Expanded(
              child: _buildBodyStatItem(
                icon: Icons.fitness_center,
                label: l10n.bodyMassLabel,
                value: stats['massFormatted'],
                color: AppColors.uiOrange,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildBodyStatItem(
                icon: Icons.circle_outlined,
                label: l10n.bodyRadiusLabel,
                value: stats['radiusFormatted'],
                color: AppColors.uiCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // Row 2: Velocity and Temperature
        Row(
          children: [
            Expanded(
              child: _buildBodyStatItem(
                icon: Icons.speed,
                label: l10n.bodyVelocityLabel,
                value: stats['velocityFormatted'],
                color: AppColors.uiBlue,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildBodyStatItem(
                icon: Icons.thermostat,
                label: l10n.bodyTemperatureLabel,
                value: stats['temperatureFormatted'],
                color: AppColors.uiAmber,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTypography.spacingSmall),

        // Row 3: Energy and Escape Velocity
        Row(
          children: [
            Expanded(
              child: _buildBodyStatItem(
                icon: Icons.flash_on,
                label: l10n.bodyKineticEnergyLabel,
                value: stats['kineticEnergyFormatted'],
                color: AppColors.uiPurple,
              ),
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: _buildBodyStatItem(
                icon: Icons.launch,
                label: l10n.bodyEscapeVelocityLabel,
                value: stats['escapeVelocityFormatted'],
                color: AppColors.uiRed,
              ),
            ),
          ],
        ),

        // Conditional rows based on body type
        if (body.bodyType == BodyType.star) ...[
          const SizedBox(height: AppTypography.spacingSmall),
          // Luminosity for stars
          Row(
            children: [
              Expanded(
                child: _buildBodyStatItem(
                  icon: Icons.wb_sunny,
                  label: l10n.bodyLuminosityLabel,
                  value: stats['luminosityFormatted'],
                  color: AppColors.uiYellow,
                ),
              ),
              const SizedBox(width: AppTypography.spacingSmall),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],

        if (body.bodyType == BodyType.planet) ...[
          const SizedBox(height: AppTypography.spacingSmall),
          // Habitability for planets
          Row(
            children: [
              Expanded(
                child: _buildBodyStatItem(
                  icon: Icons.eco,
                  label: l10n.bodyHabitabilityLabel,
                  value: _getHabitabilityDisplayText(
                    l10n,
                    body.habitabilityStatus,
                  ),
                  color: _getHabitabilityColor(body.habitabilityStatus),
                ),
              ),
              const SizedBox(width: AppTypography.spacingSmall),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }

  /// Build a compact body statistic item
  Widget _buildBodyStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingSmall),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppTypography.opacityDisabled),
        borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
        border: Border.all(
          color: color.withValues(alpha: AppTypography.opacityFaint),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppTypography.iconSizeSmall),
          const SizedBox(width: AppTypography.spacingXSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.smallText.copyWith(
                    fontSize: AppTypography.fontSizeSmall * 0.9,
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityMediumHigh,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.uiWhite,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate body statistics from the list of bodies
  Map<String, double> _calculateBodyStatistics(List<Body> bodies) {
    final stats = {
      'stars': 0.0,
      'planets': 0.0,
      'asteroids': 0.0,
      'blackHoles': 0.0,
      'totalMass': 0.0,
      'habitableWorlds': 0.0,
    };

    for (final body in bodies) {
      stats['totalMass'] = stats['totalMass']! + body.mass;

      switch (body.bodyType) {
        case BodyType.star:
          stats['stars'] = stats['stars']! + 1;
          break;
        case BodyType.planet:
          stats['planets'] = stats['planets']! + 1;
          if (body.habitabilityStatus.isHabitable) {
            stats['habitableWorlds'] = stats['habitableWorlds']! + 1;
          }
          break;
        case BodyType.moon:
        case BodyType.asteroid:
          stats['asteroids'] = stats['asteroids']! + 1;
          break;
        case BodyType.blackHole:
        case BodyType.neutronStar:
          stats['blackHoles'] = stats['blackHoles']! + 1;
          break;
      }
    }

    return stats;
  }

  /// Format mass value for display
  String _formatMass(double mass) {
    if (mass >= 1e30) {
      return '${(mass / 1e30).toStringAsFixed(1)} × 10³⁰ kg';
    } else if (mass >= 1e24) {
      return '${(mass / 1e24).toStringAsFixed(1)} × 10²⁴ kg';
    } else if (mass >= 1e21) {
      return '${(mass / 1e21).toStringAsFixed(1)} × 10²¹ kg';
    } else if (mass >= 1e18) {
      return '${(mass / 1e18).toStringAsFixed(1)} × 10¹⁸ kg';
    } else {
      return mass.toStringAsExponential(1);
    }
  }

  /// Calculate energy statistics for the system
  Map<String, double> _calculateEnergyStatistics(List<Body> bodies) {
    if (bodies.isEmpty) {
      return {
        'totalEnergy': 0.0,
        'kineticEnergy': 0.0,
        'potentialEnergy': 0.0,
        'angularMomentumMagnitude': 0.0,
        'systemMomentumMagnitude': 0.0,
        'centerOfMassDistance': 0.0,
      };
    }

    final masses = bodies.map((b) => b.mass).toList();
    final positions = bodies.map((b) => b.position).toList();
    final velocities = bodies.map((b) => b.velocity).toList();

    final totalEnergy = PhysicsUtils.calculateSystemEnergy(
      masses,
      positions,
      velocities,
    );

    // Calculate kinetic energy
    double kineticEnergy = 0.0;
    for (int i = 0; i < bodies.length; i++) {
      kineticEnergy += PhysicsUtils.calculateKineticEnergy(
        masses[i],
        velocities[i],
      );
    }

    // Potential energy = total - kinetic
    final potentialEnergy = totalEnergy - kineticEnergy;

    // Calculate angular momentum magnitude
    final angularMomentum = PhysicsUtils.calculateSystemAngularMomentum(
      masses,
      positions,
      velocities,
    );
    final angularMomentumMagnitude = angularMomentum.length;

    // Calculate system momentum magnitude
    final systemMomentum = PhysicsUtils.calculateSystemMomentum(
      masses,
      velocities,
    );
    final systemMomentumMagnitude = systemMomentum.length;

    // Calculate center of mass distance from origin
    final centerOfMass = PhysicsUtils.calculateCenterOfMass(masses, positions);
    final centerOfMassDistance = centerOfMass.length;

    return {
      'totalEnergy': totalEnergy,
      'kineticEnergy': kineticEnergy,
      'potentialEnergy': potentialEnergy,
      'angularMomentumMagnitude': angularMomentumMagnitude,
      'systemMomentumMagnitude': systemMomentumMagnitude,
      'centerOfMassDistance': centerOfMassDistance,
    };
  }

  /// Calculate velocity statistics for the system
  Map<String, double> _calculateVelocityStatistics(List<Body> bodies) {
    final velocities = bodies.map((b) => b.velocity).toList();
    return PhysicsUtils.calculateVelocityStatistics(velocities);
  }

  /// Calculate temperature statistics for the system
  Map<String, double> _calculateTemperatureStatistics(List<Body> bodies) {
    final temperatures = bodies.map((b) => b.temperature).toList();
    return PhysicsUtils.calculateTemperatureStatistics(temperatures);
  }

  /// Format energy values for display
  String _formatEnergy(double energy) {
    if (energy.abs() < 1e-10) return '0 J';

    if (energy.abs() >= 1e30) {
      return '${(energy / 1e30).toStringAsFixed(1)}×10³⁰ J';
    } else if (energy.abs() >= 1e21) {
      return '${(energy / 1e21).toStringAsFixed(1)}×10²¹ J';
    } else if (energy.abs() >= 1e12) {
      return '${(energy / 1e12).toStringAsFixed(1)}×10¹² J';
    } else {
      return energy.toStringAsExponential(1);
    }
  }

  /// Format angular momentum values for display
  String _formatAngularMomentum(double momentum) {
    if (momentum.abs() < 1e-10) return '0 kg⋅m²/s';

    if (momentum.abs() >= 1e30) {
      return '${(momentum / 1e30).toStringAsFixed(1)}×10³⁰ kg⋅m²/s';
    } else if (momentum.abs() >= 1e21) {
      return '${(momentum / 1e21).toStringAsFixed(1)}×10²¹ kg⋅m²/s';
    } else {
      return momentum.toStringAsExponential(1);
    }
  }

  /// Format momentum values for display
  String _formatMomentum(double momentum) {
    if (momentum.abs() < 1e-10) return '0 kg⋅m/s';

    if (momentum.abs() >= 1e30) {
      return '${(momentum / 1e30).toStringAsFixed(1)}×10³⁰ kg⋅m/s';
    } else if (momentum.abs() >= 1e21) {
      return '${(momentum / 1e21).toStringAsFixed(1)}×10²¹ kg⋅m/s';
    } else {
      return momentum.toStringAsExponential(1);
    }
  }

  /// Format position values for display
  String _formatPosition(double distance) {
    return NumberUtils.formatDistance(distance);
  }

  /// Calculate individual body statistics
  Map<String, dynamic> _calculateIndividualBodyStats(
    Body body,
    BuildContext context,
    AppState appState,
  ) {
    final velocity = body.velocity.length;
    final kineticEnergy = PhysicsUtils.calculateKineticEnergy(
      body.mass,
      body.velocity,
    );
    final escapeVelocity = PhysicsUtils.calculateEscapeVelocity(
      body.mass,
      body.radius,
    );

    return {
      'massFormatted': NumberUtils.formatMassInSolarMasses(body.mass),
      'radiusFormatted': NumberUtils.formatRadiusInSolarRadii(body.radius),
      'velocityFormatted': NumberUtils.formatVelocity(velocity),
      'temperatureFormatted': NumberUtils.formatTemperatureWithUnit(
        body.temperature,
        appState.ui.temperatureUnit,
      ),
      'kineticEnergyFormatted': _formatEnergy(kineticEnergy),
      'escapeVelocityFormatted': NumberUtils.formatVelocity(escapeVelocity),
      'luminosityFormatted': NumberUtils.formatLuminosity(
        body.stellarLuminosity,
      ),
      'positionFormatted': NumberUtils.formatVector3(body.position),
    };
  }

  /// Get icon for body type
  IconData _getBodyTypeIcon(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return Icons.wb_sunny;
      case BodyType.planet:
        return Icons.public;
      case BodyType.moon:
        return Icons.brightness_3;
      case BodyType.asteroid:
        return Icons.scatter_plot;
      case BodyType.blackHole:
        return Icons.brightness_2;
      case BodyType.neutronStar:
        return Icons.stars;
    }
  }

  /// Get display name for body type
  String _getBodyTypeDisplayName(AppLocalizations l10n, BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return l10n.bodyTypeStar;
      case BodyType.planet:
        return l10n.bodyTypePlanet;
      case BodyType.moon:
        return l10n.bodyMoon;
      case BodyType.asteroid:
        return l10n.bodyTypeAsteroid;
      case BodyType.blackHole:
        return l10n.bodyBlackHole;
      case BodyType.neutronStar:
        return l10n.bodyTypeNeutronStar;
    }
  }

  /// Get habitability display text
  String _getHabitabilityDisplayText(
    AppLocalizations l10n,
    HabitabilityStatus status,
  ) {
    switch (status) {
      case HabitabilityStatus.habitable:
        return l10n.habitableStatus;
      case HabitabilityStatus.tooHot:
        return l10n.tooHotStatus;
      case HabitabilityStatus.tooCold:
        return l10n.tooColdStatus;
      case HabitabilityStatus.noAtmosphere:
        return l10n.noAtmosphereStatus;
      case HabitabilityStatus.gasGiant:
        return l10n.habitabilityGasGiant;
      case HabitabilityStatus.tooSmall:
        return l10n.habitabilityTooSmall;
      case HabitabilityStatus.toxicAtmosphere:
        return l10n.habitabilityToxicAtmosphere;
      case HabitabilityStatus.highRadiation:
        return l10n.habitabilityHighRadiation;
      case HabitabilityStatus.tidallyLocked:
        return l10n.habitabilityTidallyLocked;
      case HabitabilityStatus.extremeGravity:
        return l10n.habitabilityExtremeGravity;
      case HabitabilityStatus.unknown:
        return l10n.unknownHabitabilityStatus;
    }
  }

  /// Get color for habitability status
  Color _getHabitabilityColor(HabitabilityStatus status) {
    switch (status) {
      case HabitabilityStatus.habitable:
        return AppColors.uiGreen;
      case HabitabilityStatus.tooHot:
        return AppColors.uiRed;
      case HabitabilityStatus.tooCold:
        return AppColors.uiBlue;
      case HabitabilityStatus.noAtmosphere:
        return AppColors.uiYellow;
      case HabitabilityStatus.gasGiant:
        return AppColors.uiPurple;
      case HabitabilityStatus.tooSmall:
        return AppColors.uiOrange;
      case HabitabilityStatus.toxicAtmosphere:
        return AppColors.uiRed;
      case HabitabilityStatus.highRadiation:
        return AppColors.uiAmber;
      case HabitabilityStatus.tidallyLocked:
        return AppColors.uiIndigo;
      case HabitabilityStatus.extremeGravity:
        return AppColors.uiTeal;
      case HabitabilityStatus.unknown:
        return AppColors.uiWhite;
    }
  }
}
