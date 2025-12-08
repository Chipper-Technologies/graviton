import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/scenario_type.dart';

/// Physics parameter settings for simulation scenarios
class PhysicsSettings {
  final double gravitationalConstant;
  final double softening;
  final double collisionRadiusMultiplier;
  final int maxTrailPoints;
  final double trailFadeRate;
  final double vibrationThrottleTime;
  final bool vibrationEnabled;

  // Relativistic effects settings
  final bool enableRelativisticEffects;
  final bool showRelativisticGlow;

  // Tidal forces settings
  final bool enableTidalForces;
  final bool showTidalVisualization;

  const PhysicsSettings({
    required this.gravitationalConstant,
    required this.softening,
    required this.collisionRadiusMultiplier,
    required this.maxTrailPoints,
    required this.trailFadeRate,
    required this.vibrationThrottleTime,
    required this.vibrationEnabled,
    this.enableRelativisticEffects = false,
    this.showRelativisticGlow = false,
    this.enableTidalForces = false,
    this.showTidalVisualization = false,
  });

  /// Create default physics settings from simulation constants
  factory PhysicsSettings.defaults() => PhysicsSettings(
    gravitationalConstant: SimulationConstants.gravitationalConstant,
    softening: SimulationConstants.softening,
    collisionRadiusMultiplier: SimulationConstants.collisionRadiusMultiplier,
    maxTrailPoints: SimulationConstants.maxTrailPoints,
    trailFadeRate: SimulationConstants.trailFadeRate,
    vibrationThrottleTime: SimulationConstants.vibrationThrottleTime,
    vibrationEnabled: true,
  );

  /// Create realistic physics for educational scenarios (like solar system)
  factory PhysicsSettings.realistic() => PhysicsSettings(
    gravitationalConstant: 1.2, // Base realistic value
    softening: 0.01, // Minimal softening for realism
    collisionRadiusMultiplier: 0.2, // Balanced collision detection
    maxTrailPoints: 300, // Moderate trail length
    trailFadeRate: 0.5, // Standard fade rate
    vibrationThrottleTime: 0.18, // Standard haptic timing
    vibrationEnabled: true,
    enableRelativisticEffects: false,
    showRelativisticGlow: false,
    enableTidalForces: false,
    showTidalVisualization: false,
  );

  /// Create experimental physics for sandbox scenarios
  factory PhysicsSettings.experimental() => PhysicsSettings(
    gravitationalConstant: SimulationConstants.gravitationalConstant,
    softening: SimulationConstants.softening,
    collisionRadiusMultiplier: SimulationConstants.collisionRadiusMultiplier,
    maxTrailPoints: SimulationConstants.maxTrailPoints,
    trailFadeRate: SimulationConstants.trailFadeRate,
    vibrationThrottleTime: SimulationConstants.vibrationThrottleTime,
    vibrationEnabled: true,
    enableRelativisticEffects: false,
    showRelativisticGlow: false,
    enableTidalForces: false,
    showTidalVisualization: false,
  );

  /// Get appropriate default settings for a scenario type
  factory PhysicsSettings.forScenario(ScenarioType scenario) {
    switch (scenario) {
      case ScenarioType.solarSystem:
      case ScenarioType.earthMoonSun:
        return PhysicsSettings.realistic();
      case ScenarioType.random:
      case ScenarioType.threeBodyClassic:
      case ScenarioType.binaryStars:
      case ScenarioType.asteroidBelt:
      case ScenarioType.galaxyFormation:
      case ScenarioType.collisionDemo:
      case ScenarioType.deepSpace:
      case ScenarioType.custom:
        return PhysicsSettings.experimental();
    }
  }

  /// Create a copy with modified parameters
  PhysicsSettings copyWith({
    double? gravitationalConstant,
    double? softening,
    double? collisionRadiusMultiplier,
    int? maxTrailPoints,
    double? trailFadeRate,
    double? vibrationThrottleTime,
    bool? vibrationEnabled,
    bool? enableRelativisticEffects,
    bool? showRelativisticGlow,
    bool? enableTidalForces,
    bool? showTidalVisualization,
  }) {
    return PhysicsSettings(
      gravitationalConstant:
          gravitationalConstant ?? this.gravitationalConstant,
      softening: softening ?? this.softening,
      collisionRadiusMultiplier:
          collisionRadiusMultiplier ?? this.collisionRadiusMultiplier,
      maxTrailPoints: maxTrailPoints ?? this.maxTrailPoints,
      trailFadeRate: trailFadeRate ?? this.trailFadeRate,
      vibrationThrottleTime:
          vibrationThrottleTime ?? this.vibrationThrottleTime,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      enableRelativisticEffects:
          enableRelativisticEffects ?? this.enableRelativisticEffects,
      showRelativisticGlow: showRelativisticGlow ?? this.showRelativisticGlow,
      enableTidalForces: enableTidalForces ?? this.enableTidalForces,
      showTidalVisualization:
          showTidalVisualization ?? this.showTidalVisualization,
    );
  }

  /// Check if settings differ from scenario defaults
  bool isDifferentFromDefaults(ScenarioType scenario) {
    final defaults = PhysicsSettings.forScenario(scenario);
    return gravitationalConstant != defaults.gravitationalConstant ||
        softening != defaults.softening ||
        collisionRadiusMultiplier != defaults.collisionRadiusMultiplier ||
        maxTrailPoints != defaults.maxTrailPoints ||
        trailFadeRate != defaults.trailFadeRate ||
        vibrationThrottleTime != defaults.vibrationThrottleTime ||
        vibrationEnabled != defaults.vibrationEnabled ||
        enableRelativisticEffects != defaults.enableRelativisticEffects ||
        showRelativisticGlow != defaults.showRelativisticGlow ||
        enableTidalForces != defaults.enableTidalForces ||
        showTidalVisualization != defaults.showTidalVisualization;
  }

  /// Convert to Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'gravitationalConstant': gravitationalConstant,
      'softening': softening,
      'collisionRadiusMultiplier': collisionRadiusMultiplier,
      'maxTrailPoints': maxTrailPoints,
      'trailFadeRate': trailFadeRate,
      'vibrationThrottleTime': vibrationThrottleTime,
      'vibrationEnabled': vibrationEnabled,
      'enableRelativisticEffects': enableRelativisticEffects,
      'showRelativisticGlow': showRelativisticGlow,
      'enableTidalForces': enableTidalForces,
      'showTidalVisualization': showTidalVisualization,
    };
  }

  /// Create from Map for deserialization
  factory PhysicsSettings.fromMap(Map<String, dynamic> map) {
    return PhysicsSettings(
      gravitationalConstant:
          map['gravitationalConstant']?.toDouble() ??
          SimulationConstants.gravitationalConstant,
      softening: map['softening']?.toDouble() ?? SimulationConstants.softening,
      collisionRadiusMultiplier:
          map['collisionRadiusMultiplier']?.toDouble() ??
          SimulationConstants.collisionRadiusMultiplier,
      maxTrailPoints:
          map['maxTrailPoints']?.toInt() ?? SimulationConstants.maxTrailPoints,
      trailFadeRate:
          map['trailFadeRate']?.toDouble() ?? SimulationConstants.trailFadeRate,
      vibrationThrottleTime:
          map['vibrationThrottleTime']?.toDouble() ??
          SimulationConstants.vibrationThrottleTime,
      vibrationEnabled: map['vibrationEnabled'] ?? true,
      enableRelativisticEffects: map['enableRelativisticEffects'] ?? false,
      showRelativisticGlow: map['showRelativisticGlow'] ?? false,
      enableTidalForces: map['enableTidalForces'] ?? false,
      showTidalVisualization: map['showTidalVisualization'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhysicsSettings &&
        other.gravitationalConstant == gravitationalConstant &&
        other.softening == softening &&
        other.collisionRadiusMultiplier == collisionRadiusMultiplier &&
        other.maxTrailPoints == maxTrailPoints &&
        other.trailFadeRate == trailFadeRate &&
        other.vibrationThrottleTime == vibrationThrottleTime &&
        other.vibrationEnabled == vibrationEnabled &&
        other.enableRelativisticEffects == enableRelativisticEffects &&
        other.showRelativisticGlow == showRelativisticGlow &&
        other.enableTidalForces == enableTidalForces &&
        other.showTidalVisualization == showTidalVisualization;
  }

  @override
  int get hashCode {
    // NOTE: Object.hash supports up to 20 arguments. Currently using 11.
    // If more properties are added (>20), switch to Object.hashAll for scalability.
    return Object.hash(
      gravitationalConstant,
      softening,
      collisionRadiusMultiplier,
      maxTrailPoints,
      trailFadeRate,
      vibrationThrottleTime,
      vibrationEnabled,
      enableRelativisticEffects,
      showRelativisticGlow,
      enableTidalForces,
      showTidalVisualization,
    );
  }

  @override
  String toString() {
    return 'PhysicsSettings(gravitationalConstant: $gravitationalConstant, softening: $softening, collisionRadiusMultiplier: $collisionRadiusMultiplier, maxTrailPoints: $maxTrailPoints, trailFadeRate: $trailFadeRate, vibrationThrottleTime: $vibrationThrottleTime, vibrationEnabled: $vibrationEnabled, enableRelativisticEffects: $enableRelativisticEffects, showRelativisticGlow: $showRelativisticGlow, enableTidalForces: $enableTidalForces, showTidalVisualization: $showTidalVisualization)';
  }
}
