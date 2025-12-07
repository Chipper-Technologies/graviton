/// Constants for tidal force calculations and visualization in Graviton
///
/// These constants control tidal tensor calculations, Roche limit detection,
/// and visualization of tidal deformation effects.
class TidalConstants {
  // Private constructor to prevent instantiation
  TidalConstants._();

  /// Roche limit multiplier for rigid body approximation
  ///
  /// For rigid bodies: d = 2.456 * R_primary * (ρ_primary/ρ_secondary)^(1/3)
  /// For fluid bodies, this would be ~2.44
  static const double rocheLimitMultiplierRigid = 2.456;

  /// Roche limit multiplier for fluid body approximation
  ///
  /// For fluid bodies in synchronous rotation
  static const double rocheLimitMultiplierFluid = 2.44;

  /// Use rigid body approximation by default
  static const bool useRigidBodyApproximation = true;

  /// Threshold fraction of Roche limit for tidal disruption warning
  ///
  /// Show warning indicators when bodies are within this fraction
  /// of their Roche limit (0.8 = 80% of Roche limit)
  static const double tidalDisruptionThreshold = 0.8;

  /// Critical tidal stress threshold for visual effects
  ///
  /// Tidal stress above this value triggers warning colors and effects
  static const double criticalTidalStress = 1.0;

  /// Minimum tidal stress to display visualization
  ///
  /// Only show tidal ellipsoids when stress exceeds this threshold
  /// to avoid cluttering the display with negligible effects
  static const double minTidalStressDisplay = 0.01;

  /// Scale factor for tidal ellipsoid visualization
  ///
  /// Multiplies the tidal deformation magnitude for clearer visualization
  static const double tidalVisualizationScale = 10.0;

  /// Opacity for tidal force visualization overlay
  static const double tidalOverlayOpacity = 0.3;

  /// Minimum distance multiplier for tidal calculations
  ///
  /// Prevents numerical instabilities when bodies are extremely close
  /// Tidal forces only calculated when distance > radius * this multiplier
  static const double minDistanceMultiplier = 1.5;

  /// Maximum tidal tensor eigenvalue for stability
  ///
  /// Caps tidal tensor components to prevent numerical overflow
  /// in extreme close-approach scenarios
  static const double maxTidalEigenvalue = 100.0;

  /// Update frequency for tidal calculations (in seconds)
  ///
  /// Tidal forces are computationally expensive, so we throttle updates
  /// Lower values = more accurate but slower performance
  static const double tidalUpdateInterval = 0.1;

  /// Number of bodies to consider for tidal calculations
  ///
  /// Only the N nearest massive bodies contribute to tidal forces
  /// to balance accuracy with performance
  static const int maxTidalBodies = 5;

  /// Mass threshold for tidal force sources
  ///
  /// Only bodies with mass > this threshold are considered as
  /// significant tidal force sources (in simulation mass units)
  static const double minTidalSourceMass = 5.0;

  /// Tidal axis visualization length multiplier
  ///
  /// Controls how long the tidal axis lines are drawn relative to body radius
  static const double tidalAxisLengthMultiplier = 3.0;

  /// Tidal ellipsoid smoothness (number of vertices)
  ///
  /// Higher values = smoother ellipsoid rendering but more expensive
  static const int tidalEllipsoidVertices = 32;

  /// Enable tidal heating calculations
  ///
  /// If true, tidal stress contributes to body temperature
  /// (e.g., Io's volcanic activity from Jupiter's tidal forces)
  static const bool enableTidalHeating = false;

  /// Tidal heating efficiency factor
  ///
  /// Fraction of tidal energy that converts to heat
  static const double tidalHeatingEfficiency = 0.001;

  /// Roche limit safety margin for collision detection
  ///
  /// Collisions are triggered when bodies are within this fraction
  /// of their Roche limit (1.0 = exactly at Roche limit)
  static const double rocheLimitCollisionMargin = 0.95;
}
