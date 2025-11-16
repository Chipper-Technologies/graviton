import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/widgets/haptics/haptic_slider_option.dart';

/// Physics configuration panel for scenario editor
class ScenarioEditorPhysicsPanel extends StatelessWidget {
  final ScenarioPhysicsSettings physics;
  final ParticleSystemsConfig particleSystems;
  final ValueChanged<ScenarioPhysicsSettings> onPhysicsChanged;
  final ValueChanged<ParticleSystemsConfig> onParticleSystemsChanged;

  const ScenarioEditorPhysicsPanel({
    super.key,
    required this.physics,
    required this.particleSystems,
    required this.onPhysicsChanged,
    required this.onParticleSystemsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gravitational Constant
          HapticSliderOption.detailed(
            label: l10n.gravitationalConstant,
            value: physics.gravitationalConstant,
            min: 0.1,
            max: 5.0,
            divisions: 49,
            icon: Icons.public,
            onChanged: (value) {
              onPhysicsChanged(
                ScenarioPhysicsSettings(
                  gravitationalConstant: value,
                  softening: physics.softening,
                  timeScale: physics.timeScale,
                  collisionRadiusMultiplier: physics.collisionRadiusMultiplier,
                  maxTrailPoints: physics.maxTrailPoints,
                  trailFadeRate: physics.trailFadeRate,
                ),
              );
            },
            formatter: (value) => NumberUtils.formatDecimal(value, 2),
          ),

          // Softening Parameter
          HapticSliderOption.detailed(
            label: l10n.collisionSoftening,
            value: physics.softening,
            min: 0.001,
            max: 0.1,
            divisions: 99,
            icon: Icons.blur_circular,
            onChanged: (value) {
              onPhysicsChanged(
                ScenarioPhysicsSettings(
                  gravitationalConstant: physics.gravitationalConstant,
                  softening: value,
                  timeScale: physics.timeScale,
                  collisionRadiusMultiplier: physics.collisionRadiusMultiplier,
                  maxTrailPoints: physics.maxTrailPoints,
                  trailFadeRate: physics.trailFadeRate,
                ),
              );
            },
            formatter: (value) => NumberUtils.formatDecimal(value, 3),
          ),

          // Time Scale
          HapticSliderOption.detailed(
            label: l10n.timeScaleStatLabel,
            value: physics.timeScale,
            min: 0.1,
            max: 10.0,
            divisions: 99,
            icon: Icons.speed,
            onChanged: (value) {
              onPhysicsChanged(
                ScenarioPhysicsSettings(
                  gravitationalConstant: physics.gravitationalConstant,
                  softening: physics.softening,
                  timeScale: value,
                  collisionRadiusMultiplier: physics.collisionRadiusMultiplier,
                  maxTrailPoints: physics.maxTrailPoints,
                  trailFadeRate: physics.trailFadeRate,
                ),
              );
            },
            formatter: (value) => '${NumberUtils.formatDecimal(value, 1)}x',
          ),

          // Collision Radius Multiplier
          HapticSliderOption.detailed(
            label: l10n.collisionRadius,
            value: physics.collisionRadiusMultiplier,
            min: 0.01,
            max: 0.5,
            divisions: 49,
            icon: Icons.grain,
            onChanged: (value) {
              onPhysicsChanged(
                ScenarioPhysicsSettings(
                  gravitationalConstant: physics.gravitationalConstant,
                  softening: physics.softening,
                  timeScale: physics.timeScale,
                  collisionRadiusMultiplier: value,
                  maxTrailPoints: physics.maxTrailPoints,
                  trailFadeRate: physics.trailFadeRate,
                ),
              );
            },
            formatter: (value) => NumberUtils.formatDecimal(value, 3),
          ),

          // Max Trail Points
          HapticSliderOption.detailed(
            label: l10n.trailLength,
            value: physics.maxTrailPoints.toDouble(),
            min: 50,
            max: 1000,
            divisions: 95,
            icon: Icons.timeline,
            onChanged: (value) {
              onPhysicsChanged(
                ScenarioPhysicsSettings(
                  gravitationalConstant: physics.gravitationalConstant,
                  softening: physics.softening,
                  timeScale: physics.timeScale,
                  collisionRadiusMultiplier: physics.collisionRadiusMultiplier,
                  maxTrailPoints: value.round(),
                  trailFadeRate: physics.trailFadeRate,
                ),
              );
            },
            formatter: (value) => '${value.round()} pts',
          ),

          // Trail Fade Rate
          HapticSliderOption.detailed(
            label: l10n.trailFadeRate,
            value: physics.trailFadeRate,
            min: 0.1,
            max: 2.0,
            divisions: 19,
            icon: Icons.opacity,
            onChanged: (value) {
              onPhysicsChanged(
                ScenarioPhysicsSettings(
                  gravitationalConstant: physics.gravitationalConstant,
                  softening: physics.softening,
                  timeScale: physics.timeScale,
                  collisionRadiusMultiplier: physics.collisionRadiusMultiplier,
                  maxTrailPoints: physics.maxTrailPoints,
                  trailFadeRate: value,
                ),
              );
            },
            formatter: (value) => '${NumberUtils.formatDecimal(value, 1)}x',
          ),
        ],
      ),
    );
  }
}
