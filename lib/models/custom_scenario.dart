import 'package:graviton/models/scenario_metadata.dart';
import 'package:graviton/models/scenario_configuration.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/models/body_data.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/models/objectives_config.dart';

/// Represents a complete custom scenario configuration
class CustomScenario {
  final String version;
  final ScenarioMetadata metadata;
  final ScenarioConfiguration configuration;
  final ScenarioPhysicsSettings physics;
  final List<BodyData> bodies;
  final ParticleSystemsConfig particleSystems;
  final ObjectivesConfig? objectives;

  const CustomScenario({
    required this.version,
    required this.metadata,
    required this.configuration,
    required this.physics,
    required this.bodies,
    required this.particleSystems,
    this.objectives,
  });

  /// Create from JSON map
  factory CustomScenario.fromJson(Map<String, dynamic> json) {
    return CustomScenario(
      version: json['version'] as String,
      metadata: ScenarioMetadata.fromJson(json['metadata']),
      configuration: ScenarioConfiguration.fromJson(json['configuration']),
      physics: ScenarioPhysicsSettings.fromJson(json['physics']),
      bodies: (json['bodies'] as List)
          .map((body) => BodyData.fromJson(body))
          .toList(),
      particleSystems: ParticleSystemsConfig.fromJson(json['particleSystems']),
      objectives: json['objectives'] != null
          ? ObjectivesConfig.fromJson(json['objectives'])
          : null,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'metadata': metadata.toJson(),
      'configuration': configuration.toJson(),
      'physics': physics.toJson(),
      'bodies': bodies.map((body) => body.toJson()).toList(),
      'particleSystems': particleSystems.toJson(),
      if (objectives != null) 'objectives': objectives!.toJson(),
    };
  }
}
