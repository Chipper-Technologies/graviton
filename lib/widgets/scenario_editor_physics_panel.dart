import 'package:flutter/material.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/section_title.dart';

/// Physics configuration panel for scenario editor
class ScenarioEditorPhysicsPanel extends StatelessWidget {
  final PhysicsSettings physics;
  final ParticleSystemsConfig particleSystems;
  final ValueChanged<PhysicsSettings> onPhysicsChanged;
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Physics Settings'),
          SizedBox(height: AppTypography.spacingMedium),

          Text(
            'Physics configuration will be implemented here',
            style: AppTypography.mediumText.copyWith(color: AppColors.uiWhite.withValues(alpha: 0.7)),
          ),

          SizedBox(height: AppTypography.spacingLarge),

          SectionTitle(title: 'Particle Systems'),
          SizedBox(height: AppTypography.spacingMedium),

          Text(
            'Asteroid belt and other particle systems will be configured here',
            style: AppTypography.mediumText.copyWith(color: AppColors.uiWhite.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}
