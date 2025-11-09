/// Types of camera movements for cinematic effects
enum CameraMovementType {
  /// Linear interpolation between positions
  linear,

  /// Smooth ease-in-out curve
  easeInOut,

  /// Bezier curve for complex paths
  bezier,

  /// Banking turn (rolls into the turn)
  banking,
}
