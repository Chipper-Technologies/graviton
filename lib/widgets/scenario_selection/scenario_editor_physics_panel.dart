import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/section_title.dart';

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
          SectionTitle(title: l10n.physicsSettingsTitle),
          SizedBox(height: AppTypography.spacingMedium),

          Text(
            l10n.physicsConfigurationWillBeImplementedHereEditor,
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
          ),

          SizedBox(height: AppTypography.spacingLarge),

          SectionTitle(title: l10n.particleSystemsEditortitle),
          SizedBox(height: AppTypography.spacingMedium),

          Text(
            l10n.asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor,
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
