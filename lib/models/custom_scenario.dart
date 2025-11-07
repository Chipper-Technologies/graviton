import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';

/// Represents a complete custom scenario configuration
class CustomScenario {
  final String version;
  final ScenarioMetadata metadata;
  final ScenarioConfiguration configuration;
  final PhysicsSettings physics;
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
      physics: PhysicsSettings.fromJson(json['physics']),
      bodies: (json['bodies'] as List).map((body) => BodyData.fromJson(body)).toList(),
      particleSystems: ParticleSystemsConfig.fromJson(json['particleSystems']),
      objectives: json['objectives'] != null ? ObjectivesConfig.fromJson(json['objectives']) : null,
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

/// Metadata about the scenario
class ScenarioMetadata {
  final String name;
  final String description;
  final String? author;
  final DateTime? createdAt;
  final String educationalFocus;
  final List<String> tags;
  final String difficulty;

  const ScenarioMetadata({
    required this.name,
    required this.description,
    this.author,
    this.createdAt,
    required this.educationalFocus,
    required this.tags,
    required this.difficulty,
  });

  factory ScenarioMetadata.fromJson(Map<String, dynamic> json) {
    return ScenarioMetadata(
      name: json['name'] as String,
      description: json['description'] as String,
      author: json['author'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      educationalFocus: json['educationalFocus'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (author != null) 'author': author,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'educationalFocus': educationalFocus,
      'tags': tags,
      'difficulty': difficulty,
    };
  }
}

/// Camera and visualization configuration
class ScenarioConfiguration {
  final double? optimalCameraDistance;
  final double cameraDistanceMultiplier;
  final int expectedBodyCount;

  const ScenarioConfiguration({
    this.optimalCameraDistance,
    required this.cameraDistanceMultiplier,
    required this.expectedBodyCount,
  });

  factory ScenarioConfiguration.fromJson(Map<String, dynamic> json) {
    return ScenarioConfiguration(
      optimalCameraDistance: json['optimalCameraDistance'] as double?,
      cameraDistanceMultiplier: json['cameraDistanceMultiplier'] as double? ?? 1.2,
      expectedBodyCount: json['expectedBodyCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (optimalCameraDistance != null) 'optimalCameraDistance': optimalCameraDistance,
      'cameraDistanceMultiplier': cameraDistanceMultiplier,
      'expectedBodyCount': expectedBodyCount,
    };
  }
}

/// Physics simulation parameters
class PhysicsSettings {
  final double gravitationalConstant;
  final double softening;
  final double timeScale;
  final double collisionRadiusMultiplier;
  final int maxTrailPoints;
  final double trailFadeRate;

  const PhysicsSettings({
    required this.gravitationalConstant,
    required this.softening,
    required this.timeScale,
    required this.collisionRadiusMultiplier,
    required this.maxTrailPoints,
    required this.trailFadeRate,
  });

  factory PhysicsSettings.fromJson(Map<String, dynamic> json) {
    return PhysicsSettings(
      gravitationalConstant: json['gravitationalConstant'] as double,
      softening: json['softening'] as double,
      timeScale: json['timeScale'] as double,
      collisionRadiusMultiplier: json['collisionRadiusMultiplier'] as double,
      maxTrailPoints: json['maxTrailPoints'] as int,
      trailFadeRate: json['trailFadeRate'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gravitationalConstant': gravitationalConstant,
      'softening': softening,
      'timeScale': timeScale,
      'collisionRadiusMultiplier': collisionRadiusMultiplier,
      'maxTrailPoints': maxTrailPoints,
      'trailFadeRate': trailFadeRate,
    };
  }
}

/// Data for a single celestial body
class BodyData {
  final String name;
  final List<double> position; // [x, y, z]
  final List<double> velocity; // [vx, vy, vz]
  final double mass;
  final double radius;
  final String color; // hex color
  final String bodyType;
  final double stellarLuminosity;
  final double temperature;
  final bool showGravityWell;
  final bool isPlanet;
  final String habitabilityStatus;

  const BodyData({
    required this.name,
    required this.position,
    required this.velocity,
    required this.mass,
    required this.radius,
    required this.color,
    required this.bodyType,
    required this.stellarLuminosity,
    required this.temperature,
    required this.showGravityWell,
    required this.isPlanet,
    required this.habitabilityStatus,
  });

  factory BodyData.fromJson(Map<String, dynamic> json) {
    return BodyData(
      name: json['name'] as String,
      position: List<double>.from(json['position']),
      velocity: List<double>.from(json['velocity']),
      mass: json['mass'] as double,
      radius: json['radius'] as double,
      color: json['color'] as String,
      bodyType: json['bodyType'] as String,
      stellarLuminosity: json['stellarLuminosity'] as double,
      temperature: json['temperature'] as double,
      showGravityWell: json['showGravityWell'] as bool,
      isPlanet: json['isPlanet'] as bool,
      habitabilityStatus: json['habitabilityStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'velocity': velocity,
      'mass': mass,
      'radius': radius,
      'color': color,
      'bodyType': bodyType,
      'stellarLuminosity': stellarLuminosity,
      'temperature': temperature,
      'showGravityWell': showGravityWell,
      'isPlanet': isPlanet,
      'habitabilityStatus': habitabilityStatus,
    };
  }
}

/// Configuration for particle systems (asteroid belt, etc.)
class ParticleSystemsConfig {
  final ParticleSystemData? asteroidBelt;
  final ParticleSystemData? kuiperBelt;

  const ParticleSystemsConfig({this.asteroidBelt, this.kuiperBelt});

  factory ParticleSystemsConfig.fromJson(Map<String, dynamic> json) {
    return ParticleSystemsConfig(
      asteroidBelt: json['asteroidBelt'] != null ? ParticleSystemData.fromJson(json['asteroidBelt']) : null,
      kuiperBelt: json['kuiperBelt'] != null ? ParticleSystemData.fromJson(json['kuiperBelt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (asteroidBelt != null) 'asteroidBelt': asteroidBelt!.toJson(),
      if (kuiperBelt != null) 'kuiperBelt': kuiperBelt!.toJson(),
    };
  }
}

/// Data for a single particle system
class ParticleSystemData {
  final bool enabled;
  final double innerRadius;
  final double outerRadius;
  final int particleCount;
  final double centralMass;
  final double gravitationalConstant;
  final String baseColor;
  final double colorVariation;
  final bool useXZPlane;
  final double minSize;
  final double maxSize;

  const ParticleSystemData({
    required this.enabled,
    required this.innerRadius,
    required this.outerRadius,
    required this.particleCount,
    required this.centralMass,
    required this.gravitationalConstant,
    required this.baseColor,
    required this.colorVariation,
    required this.useXZPlane,
    required this.minSize,
    required this.maxSize,
  });

  factory ParticleSystemData.fromJson(Map<String, dynamic> json) {
    return ParticleSystemData(
      enabled: json['enabled'] as bool,
      innerRadius: json['innerRadius'] as double,
      outerRadius: json['outerRadius'] as double,
      particleCount: json['particleCount'] as int,
      centralMass: json['centralMass'] as double,
      gravitationalConstant: json['gravitationalConstant'] as double,
      baseColor: json['baseColor'] as String,
      colorVariation: json['colorVariation'] as double,
      useXZPlane: json['useXZPlane'] as bool,
      minSize: json['minSize'] as double,
      maxSize: json['maxSize'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'innerRadius': innerRadius,
      'outerRadius': outerRadius,
      'particleCount': particleCount,
      'centralMass': centralMass,
      'gravitationalConstant': gravitationalConstant,
      'baseColor': baseColor,
      'colorVariation': colorVariation,
      'useXZPlane': useXZPlane,
      'minSize': minSize,
      'maxSize': maxSize,
    };
  }
}

/// Optional objectives and challenge configuration
class ObjectivesConfig {
  final bool enabled;
  final String primary;
  final String? secondary;
  final int? timeLimit;
  final SuccessCriteria? successCriteria;
  final ChaosEvents? chaosEvents;

  const ObjectivesConfig({
    required this.enabled,
    required this.primary,
    this.secondary,
    this.timeLimit,
    this.successCriteria,
    this.chaosEvents,
  });

  factory ObjectivesConfig.fromJson(Map<String, dynamic> json) {
    return ObjectivesConfig(
      enabled: json['enabled'] as bool,
      primary: json['primary'] as String,
      secondary: json['secondary'] as String?,
      timeLimit: json['timeLimit'] as int?,
      successCriteria: json['successCriteria'] != null ? SuccessCriteria.fromJson(json['successCriteria']) : null,
      chaosEvents: json['chaosEvents'] != null ? ChaosEvents.fromJson(json['chaosEvents']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'primary': primary,
      if (secondary != null) 'secondary': secondary,
      if (timeLimit != null) 'timeLimit': timeLimit,
      if (successCriteria != null) 'successCriteria': successCriteria!.toJson(),
      if (chaosEvents != null) 'chaosEvents': chaosEvents!.toJson(),
    };
  }
}

/// Success criteria for objectives
class SuccessCriteria {
  final double stabilityThreshold;
  final int minimumTime;
  final int allowedCollisions;

  const SuccessCriteria({required this.stabilityThreshold, required this.minimumTime, required this.allowedCollisions});

  factory SuccessCriteria.fromJson(Map<String, dynamic> json) {
    return SuccessCriteria(
      stabilityThreshold: json['stabilityThreshold'] as double,
      minimumTime: json['minimumTime'] as int,
      allowedCollisions: json['allowedCollisions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stabilityThreshold': stabilityThreshold,
      'minimumTime': minimumTime,
      'allowedCollisions': allowedCollisions,
    };
  }
}

/// Chaos events configuration
class ChaosEvents {
  final bool enabled;
  final int frequency;
  final List<String> types;

  const ChaosEvents({required this.enabled, required this.frequency, required this.types});

  factory ChaosEvents.fromJson(Map<String, dynamic> json) {
    return ChaosEvents(
      enabled: json['enabled'] as bool,
      frequency: json['frequency'] as int,
      types: List<String>.from(json['types']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'frequency': frequency, 'types': types};
  }
}
