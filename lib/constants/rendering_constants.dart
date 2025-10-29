/// Rendering and visual constants for Graviton
class RenderingConstants {
  // 3D Projection and rendering
  static const double projectionClipZThreshold = 1e-6;
  static const double clipZFallback = 1e9;
  static const double ndcTransformOffset = 0.5;
  static const double distanceClampMin = 0.1;
  static const double distanceClampMax = 1e9;

  // Body rendering
  static const double bodySizeMultiplier =
      175.0; // Much larger multiplier for gas giants
  static const double bodyMinSize = 2.0;
  static const double bodyMaxSize =
      875.0; // Much larger max size for gas giants
  static const double bodyGlowMultiplier = 2.6;
  static const double bodyAlpha = 0.8;
  static const double bodyGlowAlpha = 0.0; // for gradient end

  // Ring texture rendering thresholds to prevent visual artifacts

  /// Minimum distance (in screen pixels) from camera before drawing detailed ring texture.
  /// Below this threshold, ring texture lines would appear too large and create visual artifacts.
  /// Value chosen based on typical viewing distances where texture detail becomes beneficial.
  static const double ringTextureMinDistance = 150.0;

  /// Maximum planet radius (in screen pixels) before suppressing ring texture.
  /// Above this threshold, the planet is too large on screen and texture lines would be too prominent.
  /// Value chosen to maintain visual quality across different zoom levels.
  static const double ringTextureMaxRadius = 200.0;

  // Star field rendering
  static const double starSize = 0.7;
  static const double starDefaultRadius = 3000.0;
  static const int starAlpha = 0x88;

  // Solar surface features
  /// Consistent seed for sunspot and solar flare generation to ensure stable visual patterns
  static const int sunspotSeed = 42;

  /// Minimum number of sunspots to generate on the sun's surface
  static const int minSunspots = 3;

  /// Maximum additional sunspots beyond the minimum (total range: 3-9 sunspots)
  static const int maxAdditionalSunspots = 6;

  // Spherical gradient background constants
  static const int sphericalGradientSourceCount = 20;
  static const double sphericalGradientSourceRadius = 2500.0;
  static const double sphericalGradientAnimationScale = 0.05;
  static const double sphericalGradientBaseRadius = 800.0;
  static const double sphericalGradientRadiusVariation = 200.0;
  static const double sphericalGradientMinVisibility = 0.3;
  static const double sphericalGradientMaxVisibility = 0.7;
  static const double sphericalGradientBaseIntensity = 0.2;
  static const double sphericalGradientIntensityVariation = 0.1;
  static const double sphericalGradientPrimaryAlpha = 0.6;
  static const double sphericalGradientSecondaryAlpha = 0.3;
  static const double sphericalGradientTertiaryAlpha = 0.1;

  // Default UI settings
  static const double defaultUIOpacity = 0.8;
  static const double uiOpacityMin = 0.0;
  static const double uiOpacityMax = 1.0;

  // Cinematic Camera - Dramatic Scoring Constants
  // These constants control how the camera scoring algorithm weighs different dramatic factors
  //
  // SCORING SCALE OVERVIEW:
  // - Baseline score: 0-10 (calm, stable orbital motion)
  // - Moderate drama: 10-50 (interesting interactions, medium speed)
  // - High drama: 50-150 (close encounters, high velocity, approaching bodies)
  // - Critical drama: 150+ (imminent collisions, extreme instability)
  //
  // The scoring algorithm combines multiple factors:
  // Score = closeEncounter + velocity + mass + approach + collision + instability
  //
  // Typical use cases:
  // - Score < 10: Ignore for camera targeting (boring)
  // - Score 10-30: Background interest, secondary targets
  // - Score 30-80: Primary camera targets for normal scenes
  // - Score 80-150: Priority targets, dramatic moments
  // - Score 150+: Emergency override, must-capture events
  //
  // When tuning these constants:
  // - Increase multipliers to make that factor more important
  // - Decrease to reduce impact on final score
  // - Consider relative importance: collision > approach > velocity > proximity > mass

  /// Base bonus multiplier for close encounters between bodies.
  /// Higher values make proximity more important in camera target selection.
  ///
  /// Units: Score points per proximity calculation
  /// Range: 0-100+ (50.0 chosen for moderate proximity influence)
  /// Context: Applied when bodies are within a few body radii of each other.
  /// Typical contribution: 5-50 points depending on distance
  static const double dramaticScoringCloseEncounterBase = 50.0;

  /// Distance scaling factor for close encounter scoring.
  /// Controls how quickly the close encounter bonus falls off with distance.
  /// Lower values = slower falloff (more generous scoring), higher values = faster falloff.
  ///
  /// Units: Dimensionless exponent for distance decay calculation
  /// Range: 0.1-2.0 (0.5 chosen for moderate falloff curve)
  /// Context: Used in formula: score *= pow(distance, -falloff)
  /// Effect: 0.5 gives square-root decay, 1.0 gives linear decay, 2.0 gives quadratic decay
  static const double dramaticScoringDistanceFalloff = 0.5;

  /// Multiplier for relative velocity between bodies.
  /// High speed interactions are considered more dramatic and cinematic.
  ///
  /// Units: Score points per velocity unit
  /// Range: 0-20+ (5.0 chosen for balanced velocity influence)
  /// Context: Applied to the magnitude of relative velocity between body pairs
  /// Typical contribution: 0-25 points for normal speeds, 50+ for extreme speeds
  static const double dramaticScoringVelocityMultiplier = 5.0;

  /// Multiplier for combined mass of interacting bodies.
  /// Heavier bodies create more visually impressive interactions.
  ///
  /// Units: Score points per mass unit
  /// Range: 0-1.0+ (0.3 chosen for subtle mass influence)
  /// Context: Applied to the sum of masses of interacting bodies
  /// Typical contribution: 1-10 points (mass effect is intentionally subtle)
  static const double dramaticScoringMassMultiplier = 0.3;

  /// Multiplier for bodies approaching each other.
  /// Approaching bodies (potential collisions) get huge dramatic bonuses.
  ///
  /// Units: Score points multiplier when bodies are approaching
  /// Range: 1-50+ (10.0 chosen for strong approach emphasis)
  /// Context: Applied when dot product of velocities indicates approach
  /// Typical contribution: 10x multiplier to base proximity score
  static const double dramaticScoringApproachingMultiplier = 10.0;

  /// Distance threshold for imminent collision detection.
  /// Bodies closer than this distance get maximum dramatic priority.
  ///
  /// Units: Simulation distance units (same as body positions)
  /// Range: 1-20+ (5.0 chosen based on typical body sizes)
  /// Context: Bodies within this distance are considered about to collide
  /// Usage: If distance < threshold, apply collision bonus
  static const double dramaticScoringCollisionDistance = 5.0;

  /// Bonus score for imminent collisions.
  /// Bodies within collision distance get this massive bonus.
  ///
  /// Units: Score points added for collision scenarios
  /// Range: 50-500+ (100.0 chosen to ensure collision priority)
  /// Context: Added directly to score when collision is imminent
  /// Purpose: Guarantees collision events get highest camera priority
  static const double dramaticScoringCollisionBonus = 100.0;

  /// Multiplier for speed difference between bodies.
  /// Higher speed differences indicate chaotic, unstable motion.
  ///
  /// Units: Score points per velocity difference unit
  /// Range: 0-10+ (2.0 chosen for moderate instability influence)
  /// Context: Applied to variance in velocities indicating system instability
  /// Typical contribution: 2-20 points for chaotic multi-body systems
  static const double dramaticScoringInstabilityMultiplier = 2.0;

  // Body Pair Matching - Velocity-Aware Position Tolerance
  // These constants control how body pairs are identified as the same across frames
  // during dynamic scenarios where object references may change due to mergers or updates.
  // All distance values are in simulation units (same as body.position coordinates).

  /// Base position tolerance for identifying same bodies when they are slow/stationary.
  ///
  /// Units: simulation distance units
  /// Context: Represents the maximum position difference allowed between frames for
  /// slow-moving bodies (velocity ≈ 0). This accounts for numerical precision errors
  /// and minor simulation instabilities.
  ///
  /// Value rationale: 5.0 units chosen based on typical body sizes (radius 1-10 units)
  /// and simulation precision. Large enough to handle floating-point drift, small
  /// enough to distinguish between different nearby bodies.
  static const double bodyMatchingBaseTolerance = 5.0;

  /// Velocity scaling factor for adaptive tolerance calculation.
  ///
  /// Units: dimensionless multiplier (tolerance units per velocity unit)
  /// Context: Controls how much additional tolerance is granted based on body velocity.
  /// Formula: extraTolerance = bodyVelocity * velocityScaling
  ///
  /// Value rationale: 0.5 chosen through testing with various orbital scenarios.
  /// Allows bodies moving at 10 units/frame to have 5 additional units of tolerance,
  /// accounting for natural position changes during high-speed motion.
  static const double bodyMatchingVelocityScaling = 0.5;

  /// Maximum position tolerance to prevent excessive values for very fast bodies.
  ///
  /// Units: simulation distance units
  /// Context: Upper bound on total tolerance (base + velocity-derived) to prevent
  /// false matches between distant bodies during extreme scenarios like slingshots.
  ///
  /// Value rationale: 25.0 units chosen as 5x the base tolerance. Accommodates
  /// very fast motion (50+ units/frame) while preventing mismatches between
  /// bodies separated by large distances (>25 units).
  /// Caps the adaptive tolerance to maintain reasonable matching precision.
  static const double bodyMatchingMaxTolerance = 25.0;
}
