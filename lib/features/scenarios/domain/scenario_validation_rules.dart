/// Validation rules for custom scenario JSON schema
///
/// This class defines the business rules and constraints for validating
/// custom scenario JSON files in the Graviton physics simulation app.
/// It provides documentation for all validation requirements across
/// metadata, configuration, physics, and body definitions.
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
