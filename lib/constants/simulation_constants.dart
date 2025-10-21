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
  static const double smallPlanetMassMin = 0.8;
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
}
