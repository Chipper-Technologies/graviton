import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents a predicted orbital event that the camera can focus on
class OrbitalEvent {
  final DateTime timestamp;
  final OrbitalEventType type;
  final List<int> involvedBodies;
  final vm.Vector3 eventPosition;
  final vm.Vector3 optimalCameraPosition;
  final double dramaticScore;
  final String description;

  const OrbitalEvent({
    required this.timestamp,
    required this.type,
    required this.involvedBodies,
    required this.eventPosition,
    required this.optimalCameraPosition,
    required this.dramaticScore,
    required this.description,
  });

  @override
  String toString() =>
      'OrbitalEvent($type, score: ${dramaticScore.toStringAsFixed(2)}, bodies: $involvedBodies)';
}

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

/// Camera movement instructions for smooth transitions
class CameraMovement {
  final vm.Vector3 startPosition;
  final vm.Vector3 endPosition;
  final vm.Vector3 startTarget;
  final vm.Vector3 endTarget;
  final double duration;
  final CameraMovementType type;

  const CameraMovement({
    required this.startPosition,
    required this.endPosition,
    required this.startTarget,
    required this.endTarget,
    required this.duration,
    required this.type,
  });
}

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

/// Configuration for predictive orbital camera behavior
class PredictiveOrbitalConfig {
  /// How far into the future to predict (seconds)
  final double predictionTimeframe;

  /// Minimum dramatic score to consider an event
  final double minDramaticScore;

  /// Maximum number of events to track simultaneously
  final int maxTrackedEvents;

  /// Camera movement speed multiplier
  final double movementSpeed;

  /// Whether to use banking turns
  final bool useBanking;

  /// Drama level (0.0 = educational, 1.0 = action movie)
  final double dramaLevel;

  const PredictiveOrbitalConfig({
    this.predictionTimeframe = 15.0,
    this.minDramaticScore = 0.3,
    this.maxTrackedEvents = 3,
    this.movementSpeed = 1.0,
    this.useBanking = true,
    this.dramaLevel = 0.7,
  });

  /// Create config optimized for different scenarios
  factory PredictiveOrbitalConfig.forScenario(String scenarioType) {
    switch (scenarioType.toLowerCase()) {
      case 'solarsystem':
        return const PredictiveOrbitalConfig(
          predictionTimeframe: 30.0, // Longer for slower movements
          minDramaticScore: 0.2,
          dramaLevel: 0.5, // More educational
        );
      case 'threebody':
        return const PredictiveOrbitalConfig(
          predictionTimeframe: 8.0, // Shorter for chaotic behavior
          minDramaticScore: 0.4,
          dramaLevel: 0.8, // More dramatic
        );
      case 'galaxy':
        return const PredictiveOrbitalConfig(
          predictionTimeframe: 5.0, // Very short for fast chaos
          minDramaticScore: 0.5,
          dramaLevel: 0.9, // Most dramatic
        );
      default:
        return const PredictiveOrbitalConfig();
    }
  }
}
