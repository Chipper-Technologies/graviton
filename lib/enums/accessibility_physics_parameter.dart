/// Physics parameters that can be announced for accessibility
///
/// This enum provides type safety and consistency for physics parameter
/// identification in accessibility announcements.
enum AccessibilityPhysicsParameter {
  /// Simulation speed/time scale parameter
  speed('speed'),

  /// Gravity strength parameter
  gravity('gravity'),

  /// Collision detection sensitivity parameter
  collisionRadius('collisionradius');

  const AccessibilityPhysicsParameter(this.value);

  /// The string value used for parameter identification
  final String value;

  /// Create an AccessibilityPhysicsParameter from a string value
  ///
  /// Returns the matching enum value or defaults to [speed] if no match is found.
  static AccessibilityPhysicsParameter fromString(String value) {
    switch (value.toLowerCase()) {
      case 'speed':
        return AccessibilityPhysicsParameter.speed;
      case 'gravity':
        return AccessibilityPhysicsParameter.gravity;
      case 'collisionradius':
        return AccessibilityPhysicsParameter.collisionRadius;
      default:
        return AccessibilityPhysicsParameter.speed; // Default fallback
    }
  }
}
