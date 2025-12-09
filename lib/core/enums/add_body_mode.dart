/// Mode state for adding bodies during simulation
enum AddBodyMode {
  /// Add body mode is inactive - normal simulation interaction
  inactive,

  /// Add body mode is active - tap to place new bodies
  active;

  /// Whether add body mode is currently active
  bool get isActive => this == AddBodyMode.active;

  /// Whether add body mode is currently inactive
  bool get isInactive => this == AddBodyMode.inactive;
}
