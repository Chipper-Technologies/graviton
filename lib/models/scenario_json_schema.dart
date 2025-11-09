/// JSON schema definition for custom simulation scenarios
///
/// This defines the structure that custom scenarios will follow when
/// serialized to JSON for storage and sharing.
class CustomScenarioJsonSchema {
  /// Example JSON structure for a custom scenario
  static const String example = '''
{
  "version": "1.0.0",
  "metadata": {
    "name": "Custom Solar System",
    "description": "A modified solar system with extra planets",
    "author": "John Doe",
    "createdAt": "2025-11-07T10:30:00Z",
    "educationalFocus": "orbital mechanics",
    "tags": ["solar system", "planets", "education"],
    "difficulty": "intermediate"
  },
  "configuration": {
    "optimalCameraDistance": 1200.0,
    "cameraDistanceMultiplier": 1.2,
    "expectedBodyCount": 9
  },
  "physics": {
    "gravitationalConstant": 1.2,
    "softening": 0.1,
    "timeScale": 1.0,
    "collisionRadiusMultiplier": 1.0,
    "maxTrailPoints": 500,
    "trailFadeRate": 0.95
  },
  "bodies": [
    {
      "name": "Sun",
      "position": [0.0, 0.0, 0.0],
      "velocity": [0.0, 0.0, 0.0],
      "mass": 50.0,
      "radius": 4.8,
      "color": "#FFD700",
      "bodyType": "star",
      "stellarLuminosity": 1.0,
      "temperature": 5778.0,
      "showGravityWell": true,
      "isPlanet": false,
      "habitabilityStatus": "notApplicable"
    },
    {
      "name": "Earth",
      "position": [200.0, 0.0, 0.0],
      "velocity": [0.0, 10.95, 0.0],
      "mass": 0.30,
      "radius": 0.6,
      "color": "#4169E1",
      "bodyType": "planet",
      "stellarLuminosity": 0.0,
      "temperature": 288.0,
      "showGravityWell": false,
      "isPlanet": true,
      "habitabilityStatus": "habitable"
    }
  ],
  "particleSystems": {
    "asteroidBelt": {
      "enabled": false,
      "innerRadius": 110.0,
      "outerRadius": 200.0,
      "particleCount": 3000,
      "centralMass": 50.0,
      "gravitationalConstant": 1.2,
      "baseColor": "#8B4513",
      "colorVariation": 0.2,
      "useXZPlane": false,
      "minSize": 0.02,
      "maxSize": 0.08
    },
    "kuiperBelt": {
      "enabled": false,
      "innerRadius": 400.0,
      "outerRadius": 600.0,
      "particleCount": 1000,
      "centralMass": 50.0,
      "gravitationalConstant": 1.2,
      "baseColor": "#87CEEB",
      "colorVariation": 0.3,
      "useXZPlane": true,
      "minSize": 0.01,
      "maxSize": 0.05
    }
  },
  "objectives": {
    "enabled": false,
    "primary": "Maintain stable orbits",
    "secondary": "Observe planetary motion",
    "timeLimit": 300,
    "successCriteria": {
      "stabilityThreshold": 0.1,
      "minimumTime": 60,
      "allowedCollisions": 0
    },
    "chaosEvents": {
      "enabled": false,
      "frequency": 30,
      "types": ["asteroid", "gravity_wave", "solar_flare"]
    }
  }
}''';
}

/// Validation rules for JSON schema
class ScenarioValidationRules {
  /// Version must be valid semver string
  ///
  /// Metadata rules:
  /// - name: Required, 1-100 characters
  /// - author: Optional, max 50 characters
  /// - educationalFocus: Must be valid EducationalFocusKeys value
  /// - difficulty: "beginner", "intermediate", "advanced", "expert"
  ///
  /// Configuration rules:
  /// - optimalCameraDistance: Positive number, 10.0-5000.0
  /// - expectedBodyCount: Positive integer, 1-50
  ///
  /// Physics rules: All values must be positive numbers within simulation limits
  ///
  /// Bodies rules:
  /// - Array of 1-50 bodies
  /// - position: 3D array of finite numbers
  /// - velocity: 3D array of finite numbers
  /// - mass: Positive number, 0.001-1000.0
  /// - radius: Positive number, 0.1-50.0
  /// - color: Valid hex color string (#RRGGBB or #AARRGGBB)
  /// - bodyType: Valid BodyType enum value
  /// - temperature: Positive number, 0-50000 Kelvin
  ///
  /// Optional configurations:
  /// - particleSystems: Optional particle system configurations
  /// - objectives: Optional challenge/objective system
  static const String version = '1.0.0';
}
