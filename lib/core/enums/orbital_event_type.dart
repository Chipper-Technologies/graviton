/// Types of orbital events that can be predicted and cinematically captured
enum OrbitalEventType {
  /// Two or more bodies approaching each other closely
  closeApproach,

  /// A body reaching the closest point in its orbit (periapsis)
  periapsis,

  /// A body reaching the farthest point in its orbit (apoapsis)
  apoapsis,

  /// A gravity assist maneuver or slingshot effect
  slingshot,

  /// Bodies on a potential collision course
  potentialCollision,

  /// A body spiraling inward due to orbital decay
  orbitalDecay,

  /// Bodies entering orbital resonance
  resonance,
}
