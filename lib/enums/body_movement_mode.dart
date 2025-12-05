/// Enum representing the body movement mode state
enum BodyMovementMode {
  /// Movement mode is inactive - normal interaction
  inactive,

  /// Movement mode is active - dragging to reposition body
  active;

  /// Check if movement mode is active
  bool get isActive => this == BodyMovementMode.active;

  /// Check if movement mode is inactive
  bool get isInactive => this == BodyMovementMode.inactive;
}
