/// Constants for relativistic physics calculations in Graviton
///
/// These constants control when and how special relativity corrections
/// are applied to high-speed objects in the simulation.
class RelativisticConstants {
  // Private constructor to prevent instantiation
  RelativisticConstants._();

  /// Speed of light in simulation units
  ///
  /// This is scaled to work with the simulation's unit system where
  /// typical orbital velocities are around 1-5 simulation units.
  /// Setting c=15.0 means objects moving at ~1.5 units/time are at 0.1c
  static const double speedOfLight = 15.0;

  /// Velocity threshold for applying relativistic corrections (in simulation units)
  ///
  /// Objects moving faster than this threshold will have relativistic
  /// corrections applied. Set to ~0.1c (10% speed of light)
  static const double relativisticThreshold = 1.5;

  /// Minimum fraction of c before applying corrections
  ///
  /// Relativistic effects are only applied when v/c > this threshold
  /// to avoid unnecessary calculations for slow-moving objects
  static const double relativisticThresholdFraction = 0.1;

  /// Maximum allowed beta (v/c) to prevent exceeding speed of light
  ///
  /// Caps velocity at 95% of light speed to maintain numerical stability
  /// and physical correctness (nothing with mass can reach c)
  static const double maxBeta = 0.95;

  /// Minimum beta value for time dilation visualization
  ///
  /// Only show relativistic effects visually when v/c exceeds this
  static const double minVisualizationBeta = 0.05;

  /// Enable first-order Post-Newtonian (1PN) corrections
  ///
  /// Includes velocity-dependent corrections and gravitational time dilation
  /// Performance impact: ~30-40% overhead when enabled for high-speed objects
  static const bool enable1PNCorrection = true;

  /// Enable second-order Post-Newtonian (2PN) corrections
  ///
  /// More accurate but computationally expensive. Includes higher-order
  /// relativistic effects like frame dragging.
  /// Performance impact: ~60-80% overhead when enabled
  static const bool enable2PNCorrection = false;

  /// Enable velocity cap at maximum beta
  ///
  /// If true, velocities exceeding maxBeta * c will be clamped
  /// If false, velocities can theoretically exceed c (non-physical)
  static const bool enforceSpeedLimit = true;

  /// Time dilation color intensity factor
  ///
  /// Controls how strongly the color shifts for fast-moving objects
  /// Higher values = more dramatic blue/red shift visualization
  static const double timeDilationColorIntensity = 0.7;

  /// Lorentz factor threshold for visual effects
  ///
  /// Visual relativistic effects (glow, color shift) only appear
  /// when the Lorentz factor γ exceeds this value
  static const double lorentzFactorThreshold = 1.005;

  /// Reference time scale for proper time calculations
  ///
  /// Used to convert between coordinate time and proper time
  /// Measured in simulation time units
  static const double referenceTimeScale = 1.0;
}
