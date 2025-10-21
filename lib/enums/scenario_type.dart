/// Types of preset astronomical scenarios available in the simulation
enum ScenarioType {
  /// Randomly generated three-body system (original behavior)
  random,

  /// Earth-Moon-Sun system for educational purposes
  earthMoonSun,

  /// Binary star system with planets
  binaryStars,

  /// Asteroid belt around a central star
  asteroidBelt,

  /// Galaxy formation simulation with dispersed matter
  galaxyFormation,

  /// Solar system with inner and outer planets
  solarSystem,

  /// Classic three-body problem demonstration
  threeBodyClassic,

  /// Collision demonstration with orbital mechanics
  collisionDemo,

  /// Deep space exploration with distant objects
  deepSpace;

  /// Create a ScenarioType from a string value
  /// Used for backward compatibility with existing string-based code
  static ScenarioType fromString(String value) {
    switch (value) {
      case 'random':
        return ScenarioType.random;
      case 'earth_moon_sun':
        return ScenarioType.earthMoonSun;
      case 'binary_star':
        return ScenarioType.binaryStars;
      case 'asteroid_belt':
        return ScenarioType.asteroidBelt;
      case 'galaxy_formation':
        return ScenarioType.galaxyFormation;
      case 'solar_system':
        return ScenarioType.solarSystem;
      case 'three_body_classic':
        return ScenarioType.threeBodyClassic;
      case 'collision_demo':
        return ScenarioType.collisionDemo;
      case 'deep_space':
        return ScenarioType.deepSpace;
      default:
        throw ArgumentError('Unknown scenario type: $value');
    }
  }
}

/// Extension to provide localization keys for scenario types
extension ScenarioTypeExtension on ScenarioType {
  /// Get the localization key for the scenario name
  String get nameKey {
    switch (this) {
      case ScenarioType.random:
        return 'scenarioRandom';
      case ScenarioType.earthMoonSun:
        return 'scenarioEarthMoonSun';
      case ScenarioType.binaryStars:
        return 'scenarioBinaryStars';
      case ScenarioType.asteroidBelt:
        return 'scenarioAsteroidBelt';
      case ScenarioType.galaxyFormation:
        return 'scenarioGalaxyFormation';
      case ScenarioType.solarSystem:
        return 'scenarioSolarSystem';
      case ScenarioType.threeBodyClassic:
        return 'scenarioThreeBodyClassic';
      case ScenarioType.collisionDemo:
        return 'scenarioCollisionDemo';
      case ScenarioType.deepSpace:
        return 'scenarioDeepSpace';
    }
  }

  /// Get the localization key for the scenario description
  String get descriptionKey {
    switch (this) {
      case ScenarioType.random:
        return 'scenarioRandomDescription';
      case ScenarioType.earthMoonSun:
        return 'scenarioEarthMoonSunDescription';
      case ScenarioType.binaryStars:
        return 'scenarioBinaryStarsDescription';
      case ScenarioType.asteroidBelt:
        return 'scenarioAsteroidBeltDescription';
      case ScenarioType.galaxyFormation:
        return 'scenarioGalaxyFormationDescription';
      case ScenarioType.solarSystem:
        return 'scenarioSolarSystemDescription';
      case ScenarioType.threeBodyClassic:
        return 'scenarioThreeBodyClassicDescription';
      case ScenarioType.collisionDemo:
        return 'scenarioCollisionDemoDescription';
      case ScenarioType.deepSpace:
        return 'scenarioDeepSpaceDescription';
    }
  }

  /// Get the string value that corresponds to this enum value
  /// Used for backward compatibility with existing string-based code
  String get stringValue {
    switch (this) {
      case ScenarioType.random:
        return 'random';
      case ScenarioType.earthMoonSun:
        return 'earth_moon_sun';
      case ScenarioType.binaryStars:
        return 'binary_star';
      case ScenarioType.asteroidBelt:
        return 'asteroid_belt';
      case ScenarioType.galaxyFormation:
        return 'galaxy_formation';
      case ScenarioType.solarSystem:
        return 'solar_system';
      case ScenarioType.threeBodyClassic:
        return 'three_body_classic';
      case ScenarioType.collisionDemo:
        return 'collision_demo';
      case ScenarioType.deepSpace:
        return 'deep_space';
    }
  }
}
