/// Physics and simulation constants for Graviton
class SimulationConstants {
  // Physics constants
  static const double gravitationalConstant = 1.2; // slightly increased to help bind the system
  static const double softening = 0.01; // collision softening parameter

  // Time conversion
  // Convert simulation time units to Earth years
  // Based on typical orbital periods in the simulation (rough approximation)
  static const double simulationTimeToEarthYears = 0.1; // 1 simulation unit ≈ 0.1 Earth years

  // Trail management
  static const int maxTrailPoints = 500;
  static const double trailFadeRate = 0.5;
  static const double trailAlphaThreshold = 0.01;
  static const double trailStrokeWidth = 1.2;
  static const double maxReasonableDistance = 50.0; // Trail discontinuity threshold

  // Body generation - Star configuration
  static const int numberOfStars = 3;
  static const double starMassMin = 8.0;
  static const double starMassMax = 12.0;
  static const double starRadiusMin = 1.0;
  static const double starRadiusMax = 1.4;
  static const double starDistanceMin = 15.0;
  static const double starDistanceMax = 25.0;
  static const double starHeightRange = 25.0; // ±25 units for Z axis
  static const double starOrbitalSpeedMin = 0.06;
  static const double starOrbitalSpeedMax = 0.10;
  static const double starZVelocityMin = 0.015;
  static const double starZVelocityMax = 0.15;
  static const double starVelocityRandomness = 0.08;
  static const double starAngleRandomness = 0.8;

  // Planet generation
  static const double planetDistanceMin = 8.0;
  static const double planetDistanceMax = 16.0;
  static const double planetHeightRange = 20.0; // ±20 units for Z axis
  static const double planetOrbitalSpeedMin = 0.08;
  static const double planetOrbitalSpeedMax = 0.12;
  static const double planetZVelocityMin = 0.015;
  static const double planetZVelocityMax = 0.125;
  static const double planetVelocityRandomness = 0.10;

  // Planet mass and size categories
  static const double smallPlanetProbability = 0.3;
  static const double earthLikePlanetProbability = 0.7; // cumulative (0.3-0.7 = 0.4)

  // Small rocky planets (Mercury to Mars size)
  static const double smallPlanetMassMin = 1.0;
  static const double smallPlanetMassMax = 2.0;
  static const double smallPlanetRadiusMin = 0.5;
  static const double smallPlanetRadiusMax = 0.8;

  // Earth-like planets
  static const double earthLikePlanetMassMin = 2.0;
  static const double earthLikePlanetMassMax = 4.0;
  static const double earthLikePlanetRadiusMin = 0.7;
  static const double earthLikePlanetRadiusMax = 1.1;

  // Super-Earth planets
  static const double superEarthMassMin = 4.0;
  static const double superEarthMassMax = 7.0;
  static const double superEarthRadiusMin = 1.0;
  static const double superEarthRadiusMax = 1.6;

  // Collision detection
  static const double collisionRadiusMultiplier = 0.05; // only 5% of visual radius

  // Emergency system regeneration
  static const double centralBodyMass = 50.0;
  static const double centralBodyRadius = 3.0;
  static const double companion1Mass = 0.5;
  static const double companion1Radius = 0.8;
  static const double companion1Distance = 8.0;
  static const double companion1OrbitalSpeed = 1.77;
  static const double companion2Mass = 0.3;
  static const double companion2Radius = 0.6;
  static const double companion2Distance = 12.0;
  static const double companion2OrbitalSpeed = 1.44;

  // Merge flashes
  static const double flashDuration = 0.3;
  static const double flashInitialAlpha = 0.9;
  static const double flashExpDecay = 8.0;
  static const double flashInitialRadius = 10.0;
  static const double flashMaxRadius = 60.0;

  // Vibration settings
  static const double vibrationThrottleTime = 0.18; // 180ms minimum between vibrations
  static const double vibrationIntensityLogDivisor = 6.0;
  static const double vibrationIntensityMin = 0.1;
  static const double vibrationIntensityMax = 1.0;
  static const int vibrationDurationMin = 20; // milliseconds
  static const int vibrationDurationMax = 100; // milliseconds
  static const int vibrationAmplitudeMin = 64;
  static const int vibrationAmplitudeMax = 255;

  // Habitable zone constants
  // Based on stellar luminosity and distance calculations
  static const double solarLuminosity = 1.0; // Reference luminosity (Sun = 1.0)

  // Habitable zone boundaries as a function of stellar luminosity
  // Based on optimistic estimates that include Mars in our solar system
  // Inner edge: just inside Venus orbit (too hot for runaway greenhouse)
  static const double habitableZoneInnerMultiplier = 0.84; // sqrt(L) * 0.84 AU

  // Outer edge: just outside Mars orbit (optimistic with greenhouse gases)
  static const double habitableZoneOuterMultiplier = 1.67; // sqrt(L) * 1.67 AU

  // Conversion factor from simulation distance units to AU
  // Based on solar system scenario: Earth at 50.0 units = 1.0 AU
  static const double simulationUnitsToAU = 0.02; // 1 simulation unit = 0.02 AU

  // Minimum stellar luminosity to have a meaningful habitable zone
  static const double minLuminosityForHabitableZone = 0.01;

  // Default stellar luminosity ranges for different star types
  static const double mainSequenceStarLuminosityMin = 0.5;
  static const double mainSequenceStarLuminosityMax = 2.0;
  static const double giantStarLuminosityMin = 2.0;
  static const double giantStarLuminosityMax = 10.0;

  // Temperature calculation constants
  // Kelvin to Celsius conversion offset - the freezing point of water
  // 0°C = 273.15K, used for temperature conversions and stellar physics
  static const double kelvinToCelsiusOffset = 273.15;

  // Base temperature representing cosmic microwave background radiation
  // This is the minimum temperature any object can have in deep space
  static const double cosmicMicrowaveBackgroundTemperature = 2.7; // Kelvin

  // Black hole proximity heating constants for galaxy formation
  // Stars closer to black holes experience tidal heating and high-energy radiation
  static const double blackHoleHeatingInnerRadius = 100.0; // Distance units - extreme heating zone
  static const double blackHoleHeatingOuterRadius = 150.0; // Distance units - moderate heating zone
  static const double blackHoleHeatingInnerFactor = 50.0; // Divisor for inner zone heating calculation
  static const double blackHoleHeatingOuterFactor = 200.0; // Divisor for outer zone heating calculation

  // Calibration constant for converting stellar radiation to temperature
  // This scales our simulation's arbitrary radiation units to realistic temperatures
  // Derived from Stefan-Boltzmann law: T = (L/(4πσr²))^(1/4)
  // Value calibrated to produce Earth-like temperatures (~288K) at Earth's distance
  static const double stellarRadiationToTemperatureConstant = 300.0;

  // Stellar physics constants
  // Reference values for stellar temperature calculations
  static const double sunMassReference = 10.0; // Sun mass in simulation units
  static const double sunTemperatureReference = 5778.0; // Sun surface temperature in Kelvin

  // Minimum temperature threshold to be considered a meaningful stellar temperature
  // Bodies below this threshold use calculated temperature from mass instead
  static const double meaningfulStellarTemperatureThreshold = 1000.0; // Kelvin

  // Galaxy formation constants
  static const int galaxyStarsPerArm = 10; // Stars per spiral arm
  static const int galaxySpiralArms = 3; // Number of spiral arms

  // Black hole classification constants
  // Mass threshold for distinguishing black holes from regular stars
  static const double blackHoleMassThreshold = 200.0; // Supermassive black holes
  static const double stellarBlackHoleMassThreshold = 100.0; // Stellar black holes

  // Spacetime curvature visualization threshold
  static const double spacetimeCurvatureMassThreshold = 10.0; // Mass threshold for showing spacetime grid

  // Gravity well visualization constants
  // Mass-based radius scaling for gravitational influence visualization
  static const double gravityWellMassScalingDivisor = 50.0; // Base mass for scaling calculation
  static const double gravityWellMassScalingExponent = 0.3; // Sublinear scaling for mass influence
  static const double gravityWellMassRadiusMultiplier = 10.0; // Converts mass scale to radius units

  // Black hole gravity well parameters - dramatic visual representation of extreme curvature
  static const double blackHoleRadiusMultiplier = 4.0; // Physical radius multiplier for black holes
  static const double blackHoleDepthMultiplier = 25.0; // Dramatic depth scaling for black holes (25x deeper)
  static const int blackHoleRingMultiplier = 3; // Triple ring count for black holes
  static const int blackHoleMinimumRings = 30; // Minimum rings for black holes regardless of distance

  // Normal body gravity well parameters - realistic but visible gravitational effects
  static const double normalBodyRadiusMultiplier = 2.5; // Physical radius multiplier for normal bodies
  static const double normalBodyMassInfluenceReduction = 0.7; // Reduced mass influence for normal bodies
  static const double normalBodyDepthMultiplier = 0.8; // Conservative depth scaling for normal bodies

  // Gravity well diameter scaling - enhanced visual impact
  static const double gravityWellDiameterExpansion = 1.4; // 40% larger diameter for better visibility
  static const double gravityWellMinimumRadiusMultiplier = 2.8; // Minimum well radius (2.8x body radius)
  static const double gravityWellMaximumRadiusMultiplier = 28.0; // Maximum well radius (28x body radius)

  // Depth calculation parameters - balances physics accuracy with visual clarity
  static const double gravityWellMassDepthExponent = 0.4; // Sublinear mass scaling for depth calculation

  // Gravity well detail level constants - adaptive LOD based on camera distance
  // Close view parameters (< 100 units) - high detail for scientific examination
  static const double gravityWellCloseViewThreshold = 100.0; // Distance threshold for close view
  static const int gravityWellCloseRingCount = 20; // High ring count for detailed curvature
  static const int gravityWellCloseSegments = 32; // High segment count for smooth circles
  static const int gravityWellCloseRadialLines = 24; // Many radial lines for detailed structure

  // Medium view parameters (100-400 units) - balanced detail for normal interaction
  static const double gravityWellMediumViewThreshold = 400.0; // Distance threshold for medium view
  static const int gravityWellMediumRingCount = 12; // Moderate ring count
  static const int gravityWellMediumSegments = 24; // Moderate segment count
  static const int gravityWellMediumRadialLines = 12; // Moderate radial lines

  // Far view parameters (> 400 units) - simplified geometry for performance
  static const int gravityWellFarRingCount = 8; // Low ring count for performance
  static const int gravityWellFarSegments = 16; // Low segment count
  static const int gravityWellFarRadialLines = 8; // Few radial lines

  // Central circle visualization parameters - the convergence point of gravity wells
  static const double centralCircleRadiusRatio = 0.015; // Central circle radius as 1.5% of max well radius
  static const double centralCircleDepthMultiplier = 1.03; // Central circle is 3% deeper for natural funnel effect
  static const int centralCircleSegments = 16; // Fewer segments since central circle is small

  // Cinematic camera constants
  // Predictive orbital simulation parameters
  static const double predictiveTimeFrame = 10.0; // Time frame for orbital prediction
  static const double predictiveTimeStep = 0.1; // Time step for orbital calculations
  static const double cameraSmoothing = 0.4; // Smoothing factor for camera movements

  // Solar system scenario durations (in seconds)
  static const double solarSystemWideViewDuration = 1.0; // Brief overview
  static const double solarSystemSunFocusDuration = 4.0; // AI explores the sun
  static const double solarSystemEarthFocusDuration = 4.0; // AI explores earth (moon visible but not targeted)
  static const double solarSystemWideReturnDuration = 2.0; // Return to wide view

  // Binary star scenario durations (in seconds)
  static const double binaryStarWideViewDuration = 1.0; // Very brief overview - start zooming in quickly
  static const double binaryStarZoomInDuration = 4.0; // Zoom in to binary stars
  static const double binaryStarPlanetTransitionDuration = 2.0; // Direct transition from binary to planets
  static const double binaryStarPlanetSurveyDuration = 3.0; // Survey any planets
  static const double binaryStarWideViewReturnDuration = 2.0; // Return to wide view before repeating

  // Planetary system scenario durations (in seconds)
  static const double planetarySystemWideViewDuration = 2.0; // Wide view to center star + inner planets
  static const double planetarySystemCentralStarDuration = 2.0; // AI control at central star
  static const double planetarySystemOuterTransitionDuration = 2.0; // Transition to outer planets
  static const double planetarySystemOuterPlanetDuration = 2.0; // AI control at outer planet
  static const double planetarySystemWideViewReturnDuration = 2.0; // Return to starting wide view

  // Galaxy formation scenario durations (in seconds)
  static const double galaxyWideViewDuration = 4.0; // Wide galaxy view with gentle movement
  static const double galaxyBlackHoleTransitionDuration = 12.0; // Much slower transition with orbital movement
  static const double galaxyBlackHoleDuration = 6.0; // Extended AI control at black hole
  static const double galaxyStarTransitionDuration = 6.0; // Slower transition to random star
  static const double galaxyStarDuration = 6.0; // Extended AI control at star
  static const double galaxyReturnDuration = 8.0; // Slower return with orbital movement

  // Camera distance constants
  static const double cameraInnerDistance = 20.0; // Distance to see center star + inner planets
  static const double cameraOuterDistance = 25.0; // Good distance to see the target body
  static const double cameraWideDistance = 600.0; // Much wider to see full galactic structure
  static const double cameraBlackHoleDistance = 40.0; // Distance for black hole viewing
  static const double cameraStarDistance = 30.0; // Good distance to see the star

  // Camera orientation constants
  static const double cameraTargetYaw = 0.0; // Default yaw angle
  static const double cameraTargetPitch = 0.25; // Default pitch angle
  static const double cameraTargetRoll = 0.0; // Default roll angle
}
