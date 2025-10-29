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

  /// Base bonus multiplier for close encounters between bodies.
  /// Higher values make proximity more important in camera target selection.
  static const double dramaticScoringCloseEncounterBase = 50.0;

  /// Distance scaling factor for close encounter scoring.
  /// Controls how quickly the close encounter bonus falls off with distance.
  /// Lower values = slower falloff (more generous scoring), higher values = faster falloff.
  static const double dramaticScoringDistanceFalloff = 0.5;

  /// Multiplier for relative velocity between bodies.
  /// High speed interactions are considered more dramatic and cinematic.
  static const double dramaticScoringVelocityMultiplier = 5.0;

  /// Multiplier for combined mass of interacting bodies.
  /// Heavier bodies create more visually impressive interactions.
  static const double dramaticScoringMassMultiplier = 0.3;

  /// Multiplier for bodies approaching each other.
  /// Approaching bodies (potential collisions) get huge dramatic bonuses.
  static const double dramaticScoringApproachingMultiplier = 10.0;

  /// Distance threshold for imminent collision detection.
  /// Bodies closer than this distance get maximum dramatic priority.
  static const double dramaticScoringCollisionDistance = 5.0;

  /// Bonus score for imminent collisions.
  /// Bodies within collision distance get this massive bonus.
  static const double dramaticScoringCollisionBonus = 100.0;

  /// Multiplier for speed difference between bodies.
  /// Higher speed differences indicate chaotic, unstable motion.
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
