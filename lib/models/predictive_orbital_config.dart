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
