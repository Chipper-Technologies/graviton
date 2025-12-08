import 'package:vector_math/vector_math_64.dart' as vm;

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

  // Celestial body specific rendering
  static const double blackHoleAccretionDiskMultiplier = 5.0;
  static const double blackHoleRingBaseAlpha = 0.6;
  static const double blackHoleRingAlphaDecrement = 0.1;
  static const double blackHoleEventHorizonStrokeWidth = 1.0;
  static const double blackHoleDistortionStrokeWidth = 0.5;
  static const double sunCoronaMultiplier = 3.0;
  static const double sunFlareAlphaCenter = 0.95;
  static const double sunFlareAlphaMid = 0.75;
  static const double sunFlareAlphaEdge = 0.45;
  static const double sunFlareBaseAlpha = 0.9;
  static const double sunFlareRingAlpha = 0.15;
  static const double sunspotUmbraMultiplier = 0.4;
  static const double sunspotSizePercentMin = 0.03; // 3% of sun radius
  static const double sunspotSizePercentMax = 0.08; // 8% of sun radius
  static const double sunspotSizeProbabilityThreshold = 0.6;
  static const double sunspotSizeProbabilityMedium = 0.9;
  static const double sunspotSizeRangeSmall = 0.05; // 3-8% range
  static const double sunspotSizeRangeMedium = 0.07; // 8-15% range
  static const double sunspotSizeRangeLarge = 0.08; // 12-20% range
  static const double sunspotSizeMediumMin = 0.08; // 8% of sun radius
  static const double sunspotSizeLargeMin = 0.12; // 12% of sun radius
  static const double sunspotMaxDistanceMultiplier = 0.9; // 90% of sun radius
  static const double sunspotPositionLimitMultiplier =
      0.7; // 70% of base radius

  // Ring texture rendering thresholds to prevent visual artifacts

  /// Minimum distance (in screen pixels) from camera before drawing detailed ring texture.
  /// Below this threshold, ring texture lines would appear too large and create visual artifacts.
  /// Value chosen based on typical viewing distances where texture detail becomes beneficial.
  static const double ringTextureMinDistance = 150.0;

  /// Maximum planet radius (in screen pixels) before suppressing ring texture.
  /// Above this threshold, the planet is too large on screen and texture lines would be too prominent.
  /// Value chosen to maintain visual quality across different zoom levels.
  static const double ringTextureMaxRadius = 200.0;

  // Ring texture rendering constants
  static const double ringTextureStrokeWidth = 0.5;
  static const double ringTextureAlpha = 0.3;
  static const double ringGlowAlpha = 0.2;

  // Gravity field rendering constants
  static const double gravityFieldAlphaMultiplier = 0.4;
  static const double gravityFieldMinAlpha = 0.02;
  static const double gravityFieldMaxAlpha = 0.3;

  // Gravity well rendering constants
  static const double gravityWellSurfaceRingAlphaMultiplier = 1.5;

  // Star field rendering
  static const double starSize = 0.7;
  static const double starDefaultRadius = 3000.0;
  static const int starAlpha = 0x88;

  // Solar surface features
  /// Consistent seed for sunspot and solar flare generation to ensure stable visual patterns
  static const int sunspotSeed = 42;

  /// Offset multiplier for flare index in random seed calculation
  /// Used to ensure each flare has a unique but stable seed during its lifetime
  static const int flareIndexSeedOffset = 123;

  /// Multiplier for flare progress in random seed calculation
  /// Converts flare progress (0.0-1.0) to integer range for seed variation
  static const int flareProgressSeedMultiplier = 1000;

  /// Multiplier for day-of-year in hourly seed calculation
  /// Used to create unique seeds that change hourly: dayOfYear * 100 + hour
  static const int seedDayMultiplier = 100;

  // Atmospheric effects
  /// Default intensity for atmospheric haze effects on planets (0.0-1.0)
  /// Controls opacity and extent of atmospheric halos
  static const double atmosphericHazeDefaultIntensity = 0.3;

  /// Gradient stops for atmospheric haze radial gradient
  /// Controls how the haze fades from planet surface to transparent edge
  /// Values concentrate the effect near the planet for realistic appearance
  static const List<double> atmosphericHazeStops = [0.7, 0.85, 0.95, 1.0];

  /// Base extent multiplier for atmospheric haze (1.0 = planet radius)
  /// The haze extends this far beyond the planet's surface before intensity scaling
  static const double atmosphericHazeBaseExtent = 1.0;

  /// Multiplier for haze intensity in extent calculation
  /// Converts intensity (0.0-1.0) to additional radius extension
  /// Final extent: baseExtent + (intensity * intensityMultiplier) = 1.0x to 1.5x radius
  static const double atmosphericHazeIntensityMultiplier = 0.5;

  /// Minimum number of sunspots to generate on the sun's surface
  static const int minSunspots = 3;

  /// Maximum additional sunspots beyond the minimum (total range: 3-9 sunspots)
  static const int maxAdditionalSunspots = 6;

  // Lighting and shadow effects
  /// Intensity shift for hemisphere lighting on the lit side (0.0-1.0)
  /// Controls how much brighter the lit hemisphere appears
  static const double hemisphereLightingIntensity = 0.3;

  /// Shadow side darkening multiplier for hemisphere lighting (0.0-1.0)
  /// Reduces intensity on shadowed hemisphere relative to lit side
  /// Applied as: intensity * hemisphereLightingShadowIntensityRatio
  static const double hemisphereLightingShadowIntensityRatio = 0.5;

  /// Gradient center offset toward light source for hemisphere effect
  /// Higher values create more pronounced day/night division
  static const double hemisphereLightingGradientOffset = 0.3;

  /// Start position of hemisphere lighting gradient (lit side)
  static const double hemisphereLightingGradientStart = 0.0;

  /// Middle position of hemisphere lighting gradient (terminator)
  static const double hemisphereLightingGradientMid = 0.5;

  /// End position of hemisphere lighting gradient (shadow side)
  static const double hemisphereLightingGradientEnd = 1.0;

  /// Shadow darkness multiplier for cast shadows (0.0-1.0)
  /// 1.0 = completely black umbra, lower values create softer shadows
  static const double castShadowUmbraAlpha = 0.8;

  /// Penumbra fade distance as ratio of shadow radius
  /// Controls how gradually shadows fade from umbra to light
  static const double castShadowPenumbraRatio = 0.3;

  /// Start position for umbra gradient transition (0.0-1.0)
  /// Controls where the shadow begins to fade from full intensity
  static const double castShadowUmbraGradientStart = 0.7;

  /// End position for umbra gradient transition (0.0-1.0)
  /// Controls where the shadow fades to transparent
  static const double castShadowUmbraGradientEnd = 1.0;

  /// Penumbra darkness as ratio of umbra darkness (0.0-1.0)
  /// Controls how dark the partial shadow is relative to full shadow
  static const double castShadowPenumbraIntensityRatio = 0.3;

  /// Alignment threshold for shadow occlusion detection (0.0-1.0)
  /// Cosine of angle between star-caster and star-receiver vectors
  /// 0.95 ≈ cos(18°), requiring bodies to be roughly aligned for shadows
  static const double castShadowAlignmentThreshold = 0.95;

  /// Shadow center offset as ratio of receiver body radius (0.0-1.0)
  /// Controls how far shadow is displaced from body center toward light source
  static const double castShadowCenterOffsetRatio = 0.3;

  /// Minimum distance clamp for shadow size calculation (simulation units)
  /// Prevents division by very small distances that would create oversized shadows
  static const double castShadowMinDistance = 1.0;

  /// Maximum umbra size as ratio of receiver body radius (0.0-1.0)
  /// Prevents shadows from covering more than this fraction of the body
  static const double castShadowMaxUmbraRatio = 0.6;

  /// Specular highlight intensity on icy/water surfaces (0.0-1.0)
  /// Controls brightness of reflective highlights
  static const double specularHighlightIntensity = 0.6;

  /// Specular highlight size as ratio of body radius
  /// Smaller values create tighter, more concentrated highlights
  static const double specularHighlightSize = 0.15;

  /// Specular highlight shininess factor
  /// Higher values create sharper, more mirror-like reflections
  static const double specularHighlightShininess = 32.0;

  /// View direction vector X component for specular highlights
  /// Camera viewing direction in 3D space (assumes camera looking down -Z)
  static const double specularViewDirectionX = 0.0;

  /// View direction vector Y component for specular highlights
  /// Camera viewing direction in 3D space (assumes camera looking down -Z)
  static const double specularViewDirectionY = 0.0;

  /// View direction vector Z component for specular highlights
  /// Camera viewing direction in 3D space (assumes camera looking down -Z)
  static const double specularViewDirectionZ = 1.0;

  /// Minimum dot product between reflection and view vectors (0.0-1.0)
  /// Specular highlights only render when reflection aligns with view above this threshold
  static const double specularMinReflectionDot = 0.3;

  /// Minimum visible specular highlight intensity (0.0-1.0)
  /// Filters out highlights dimmer than this threshold for performance
  static const double specularMinIntensity = 0.01;

  /// Intensity multiplier for gradient falloff at midpoint (0.0-1.0)
  /// Controls how quickly the highlight fades from center to edge
  static const double specularHighlightGradientFalloff = 0.5;

  /// Position of gradient midpoint in radial gradient (0.0-1.0)
  /// Defines where the falloff begins in the highlight gradient
  static const double specularHighlightGradientMidpoint = 0.5;

  /// Starting position of specular highlight gradient (0.0-1.0)
  /// Full intensity at center of highlight
  static const double specularHighlightGradientStart = 0.0;

  /// Ending position of specular highlight gradient (0.0-1.0)
  /// Fully transparent at edge of highlight
  static const double specularHighlightGradientEnd = 1.0;

  // Multiple light source blending
  /// Maximum number of light sources to blend for lighting calculations
  /// Higher values are more accurate but more expensive
  static const int maxLightSourcesForBlending = 3;

  /// Distance threshold for light source contribution (in simulation units)
  /// Light sources beyond this distance have minimal effect
  static const double lightSourceMaxDistance = 50.0;

  /// Minimum light contribution to include in blending (0.0-1.0)
  /// Filters out negligible light sources for performance
  static const double lightSourceMinContribution = 0.05;

  /// Maximum distance for shadow calculations (in simulation units)
  /// Stars beyond this distance don't cast shadows for performance
  static const double castShadowMaxDistance = 1000.0;

  /// Minimum radius for a body to cast shadows (in simulation units)
  /// Bodies smaller than this don't cast visible shadows for performance
  static const double castShadowMinCasterRadius = 0.5;

  // Atmospheric scattering on lit side
  /// Intensity multiplier for atmospheric glow on sunlit side (0.0-1.0)
  /// Creates sunrise/sunset effect around terminator
  static const double atmosphericScatteringIntensity = 0.4;

  /// Width of atmospheric scattering glow as ratio of body radius
  /// Controls how far the glow extends beyond planet limb
  static const double atmosphericScatteringWidth = 0.25;

  /// Concentration factor for scattering effect
  /// Higher values create tighter glow near terminator
  static const double atmosphericScatteringConcentration = 3.0;

  /// Minimum light intensity for visible atmospheric scattering (0.0-1.0)
  /// Scattering only renders when light intensity exceeds this threshold
  static const double atmosphericScatteringMinIntensity = 0.1;

  /// Scattering ring offset as ratio of body radius (0.0-1.0)
  /// Controls how far inset the scattering appears from body edge
  static const double atmosphericScatteringOffsetRatio = 0.7;

  /// Inner scattering color blend ratio (0.0-1.0)
  /// Controls how much to blend body color with scattering color
  static const double atmosphericScatteringInnerColorBlend = 0.3;

  /// Inner scattering alpha multiplier (0.0-1.0)
  /// Controls opacity at innermost edge of scattering gradient
  static const double atmosphericScatteringInnerAlpha = 0.3;

  /// Mid scattering alpha multiplier (0.0-1.0)
  /// Controls opacity at middle of scattering gradient (orange)
  static const double atmosphericScatteringMidAlpha = 0.6;

  /// Outer scattering alpha multiplier (0.0-1.0)
  /// Controls opacity at outer edge of scattering gradient (red glow)
  static const double atmosphericScatteringOuterAlpha = 0.4;

  /// Starting position of atmospheric scattering gradient (0.0-1.0)
  /// Inner edge where body color blends with scattering
  static const double atmosphericScatteringGradientStart = 0.0;

  /// First mid position of atmospheric scattering gradient (0.0-1.0)
  /// Where orange scattering appears
  static const double atmosphericScatteringGradientMid1 = 0.4;

  /// Second mid position of atmospheric scattering gradient (0.0-1.0)
  /// Where red/orange glow appears
  static const double atmosphericScatteringGradientMid2 = 0.7;

  /// Ending position of atmospheric scattering gradient (0.0-1.0)
  /// Outer edge fading to transparent
  static const double atmosphericScatteringGradientEnd = 1.0;

  /// Focal point position multiplier for scattering gradient (0.0-1.0)
  /// Controls how far toward terminator the scattering concentrates
  static const double atmosphericScatteringFocalRatio = 0.5;

  // Relativistic effects visualization
  /// Minimum glow intensity threshold for relativistic effects (0.0-1.0)
  /// Below this threshold, relativistic glow is not rendered for performance
  /// Based on time dilation factor: intensity = 1.0 - γ (Lorentz factor)
  static const double minimumRelativisticGlowThreshold = 0.05;

  /// Outer glow layer base radius multiplier for relativistic effects
  /// Controls the base size of the outer glow layer before intensity scaling
  static const double relativisticOuterGlowRadiusBase = 2.0;

  /// Outer glow layer intensity multiplier for relativistic effects
  /// Scales the additional radius based on glow intensity (0.0-1.0)
  static const double relativisticOuterGlowRadiusIntensityScale = 1.5;

  /// Blue-shift color blend ratio for relativistic glow (0.0-1.0)
  /// Controls how much to blend toward white from blue at maximum intensity
  static const double relativisticColorBlendRatio = 0.7;

  // Tidal forces visualization
  /// Minimum tidal stress threshold for visualization (0.0-1.0)
  /// Below this threshold, tidal visualization is not rendered for performance
  static const double minimumTidalStressThreshold = 0.01;

  /// Tidal stress normalization factor for intensity calculation
  /// Divides raw tidal stress to normalize to 0.0-1.0 range for visualization
  static const double tidalStressNormalizationFactor = 10.0;

  /// Tidal stress color blend ratio for medium stress (0.0-1.0)
  /// Controls how much to blend body color with orange at medium stress levels
  static const double tidalStressMediumBlendRatio = 0.5;

  /// Tidal stress color blend ratio for high stress (0.0-1.0)
  /// Controls how much to blend medium stress color with red at high stress levels
  static const double tidalStressHighBlendRatio = 0.5;

  /// Focal radius multiplier for scattering gradient tightness
  /// Multiplied by concentration factor to control gradient spread
  static const double atmosphericScatteringFocalRadiusMultiplier = 0.1;

  /// Draw width ratio for atmospheric scattering effect (0.0-1.0)
  /// Controls how much of the scattering width is actually rendered
  static const double atmosphericScatteringDrawWidthRatio = 0.8;

  /// Default light direction when no light sources are found
  /// Points directly at viewer (positive Z axis)
  static const double defaultLightDirectionX = 0.0;
  static const double defaultLightDirectionY = 0.0;
  static const double defaultLightDirectionZ = 1.0;

  /// Intensity normalization factor for light calculations
  /// Converts raw intensity (mass/distance²) to normalized range (0.0-1.0)
  /// Empirically derived to balance visual appearance across typical scenarios
  static const double lightIntensityNormalizationFactor = 10.0;

  // Body albedo system (surface reflectivity)
  /// Ice/snow surface albedo - highly reflective
  static const double albedoIce = 0.9;

  /// Ocean/water surface albedo - moderately reflective
  static const double albedoWater = 0.06;

  /// Rocky/terrestrial surface albedo - low reflectivity
  static const double albedoRock = 0.15;

  /// Desert surface albedo - moderate reflectivity
  static const double albedoDesert = 0.35;

  /// Vegetation surface albedo - low reflectivity
  static const double albedoVegetation = 0.12;

  /// Gas giant atmosphere albedo - high reflectivity
  static const double albedoGasGiant = 0.52;

  /// Dark/volcanic surface albedo - very low reflectivity
  static const double albedoDark = 0.08;

  /// Default albedo for unknown body types
  static const double albedoDefault = 0.2;

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

  // Bottom sheet UI constants
  static const double bottomSheetSystemBarPadding =
      50.0; // Extra padding for Android system bar clearance
  static const double bottomSheetMaxWidth =
      800.0; // Maximum width for bottom sheets on wide screens
  static const double tutorialOverlayMaxWidth =
      700.0; // Maximum width for tutorial overlay on wide screens

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

  // Collision particle effects rendering
  static const double particleGlowBlurMultiplier = 0.5;
  static const double particleGlowRadiusMultiplier = 1.5;
  static const double cloudParticleSizeMultiplier = 1.5;

  /// Maximum number of debris particles to maintain for performance
  static const int maxDebrisParticles = 500;

  /// Maximum number of debris cloud particles for performance
  static const int maxCloudParticles = 200;

  /// Maximum number of plasma jet particles for performance
  static const int maxJetParticles = 100;

  // Common 3D vectors

  /// World-space up vector (Y-axis up).
  ///
  /// Standard convention for 3D coordinate systems where Y points upward.
  /// Reused across camera calculations, painter rendering, and 3D transformations
  /// to avoid creating new vector instances repeatedly.
  static final vm.Vector3 worldUp = vm.Vector3(0, 1, 0);
}
