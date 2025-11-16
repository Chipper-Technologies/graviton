/// Camera parameters specific to different simulation scenarios
///
/// This model defines camera behavior parameters that are tuned for different
/// types of gravitational simulations to provide optimal viewing experiences
/// for each scenario type (solar system, binary stars, galaxy formation, etc.).
class ScenarioCameraParameters {
  final double safetyMargin;
  final double minDistance;
  final double maxDistance;
  final double pitchSensitivity;
  final int targetLockFrames;
  final double orbitSpeed;

  const ScenarioCameraParameters({
    required this.safetyMargin,
    required this.minDistance,
    required this.maxDistance,
    required this.pitchSensitivity,
    required this.targetLockFrames,
    required this.orbitSpeed,
  });
}
