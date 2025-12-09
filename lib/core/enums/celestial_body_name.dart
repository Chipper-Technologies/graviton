/// Enum representing all celestial body names used throughout the Graviton app
///
/// This enum centralizes all hardcoded celestial body names to improve maintainability
/// and provide type safety when referencing specific bodies.
enum CelestialBodyName {
  // Solar System bodies
  sun('Sun'),
  mercury('Mercury'),
  venus('Venus'),
  earth('Earth'),
  moon('Moon'),
  mars('Mars'),
  jupiter('Jupiter'),
  saturn('Saturn'),
  uranus('Uranus'),
  neptune('Neptune'),
  pluto('Pluto'),

  // Earth-Moon-Sun specific variant
  moonM('Moon M'),

  // Three-body system bodies
  alpha('Alpha'),
  beta('Beta'),
  gamma('Gamma'),

  // Binary star system bodies
  starA('Star A'),
  starB('Star B'),
  planetP('Planet P'),

  // Black hole and galactic center bodies
  blackHole('Black Hole'),
  supermassiveBlackHole('Supermassive Black Hole'),

  // Asteroid belt system bodies
  centralStar('Central Star'),

  // Generic planet types
  rockyPlanet('Rocky Planet'),
  ringedPlanet('Ringed Planet'),

  // Generic numbered bodies (for dynamic names)
  asteroid('Asteroid'),
  star('Star'),
  ring('Ring'),
  fragment('Fragment'),
  planetoid('Planetoid');

  const CelestialBodyName(this.value);

  /// The string value used for body names
  final String value;

  /// Get the localized name for this celestial body
  ///
  /// This method provides the appropriate localized string from AppLocalizations
  /// for display in the UI.
  String getLocalizedName(dynamic l10n) {
    if (l10n == null) return value;

    switch (this) {
      case CelestialBodyName.sun:
        return l10n.bodySun ?? value;
      case CelestialBodyName.mercury:
        return l10n.bodyMercury ?? value;
      case CelestialBodyName.venus:
        return l10n.bodyVenus ?? value;
      case CelestialBodyName.earth:
        return l10n.bodyEarth ?? value;
      case CelestialBodyName.moon:
        return l10n.bodyMoon ?? value;
      case CelestialBodyName.mars:
        return l10n.bodyMars ?? value;
      case CelestialBodyName.jupiter:
        return l10n.bodyJupiter ?? value;
      case CelestialBodyName.saturn:
        return l10n.bodySaturn ?? value;
      case CelestialBodyName.uranus:
        return l10n.bodyUranus ?? value;
      case CelestialBodyName.neptune:
        return l10n.bodyNeptune ?? value;
      case CelestialBodyName.pluto:
        return l10n.bodyPluto ?? value;
      case CelestialBodyName.moonM:
        return l10n.bodyMoonM ?? value;
      case CelestialBodyName.alpha:
        return l10n.bodyAlpha ?? value;
      case CelestialBodyName.beta:
        return l10n.bodyBeta ?? value;
      case CelestialBodyName.gamma:
        return l10n.bodyGamma ?? value;
      case CelestialBodyName.starA:
        return l10n.bodyStarA ?? value;
      case CelestialBodyName.starB:
        return l10n.bodyStarB ?? value;
      case CelestialBodyName.planetP:
        return l10n.bodyPlanetP ?? value;
      case CelestialBodyName.blackHole:
        return l10n.bodyBlackHole ?? value;
      case CelestialBodyName.supermassiveBlackHole:
        return l10n.bodyBlackHole ?? value; // Use same localization key
      case CelestialBodyName.centralStar:
        return l10n.bodyCentralStar ?? value;
      case CelestialBodyName.rockyPlanet:
        return l10n.bodyRockyPlanet ?? value;
      case CelestialBodyName.ringedPlanet:
        return l10n.bodyRingedPlanet ?? value;
      case CelestialBodyName.asteroid:
      case CelestialBodyName.star:
      case CelestialBodyName.ring:
      case CelestialBodyName.fragment:
      case CelestialBodyName.planetoid:
        return value; // These are used for dynamic names with numbers
    }
  }

  /// Get the localized name for numbered bodies like "Asteroid 1"
  ///
  /// Used for dynamically generated body names with numbers
  String getNumberedLocalizedName(dynamic l10n, int number) {
    if (l10n == null) return '$value $number';

    try {
      switch (this) {
        case CelestialBodyName.asteroid:
          return l10n.bodyAsteroid(number) ?? '$value $number';
        case CelestialBodyName.star:
          return l10n.bodyStarNumber(number) ?? '$value $number';
        case CelestialBodyName.ring:
          return l10n.bodyRing(number) ?? '$value $number';
        case CelestialBodyName.fragment:
          return l10n.bodyFragment != null
              ? l10n.bodyFragment(number)
              : '$value $number';
        case CelestialBodyName.planetoid:
          return l10n.bodyPlanetoid != null
              ? l10n.bodyPlanetoid(number)
              : '$value $number';
        default:
          return '$value $number';
      }
    } catch (e) {
      // Fallback in case localization method doesn't exist
      return '$value $number';
    }
  }

  /// Parse a string body name to the corresponding enum value
  ///
  /// Returns null if no matching enum value is found
  static CelestialBodyName? fromString(String bodyName) {
    // Direct match
    for (final bodyEnum in CelestialBodyName.values) {
      if (bodyEnum.value == bodyName) {
        return bodyEnum;
      }
    }

    // Handle numbered bodies like "Asteroid 1", "Star 2", etc.
    final RegExp numberedPattern = RegExp(r'^(\w+(?:\s+\w+)*)\s+\d+$');
    final match = numberedPattern.firstMatch(bodyName);
    if (match != null) {
      final baseName = match.group(1);
      for (final bodyEnum in CelestialBodyName.values) {
        if (bodyEnum.value == baseName) {
          return bodyEnum;
        }
      }
    }

    return null;
  }

  /// Check if this body name matches a given string
  ///
  /// Supports both exact matches and numbered variations
  bool matches(String bodyName) {
    if (value == bodyName) return true;

    // Check for numbered variations
    final pattern = RegExp('^$value\\s+\\d+\$');
    return pattern.hasMatch(bodyName);
  }

  /// Get all solar system planet names
  static List<CelestialBodyName> get solarSystemPlanets => [
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,
  ];

  /// Get all three-body system names
  static List<CelestialBodyName> get threeBodySystem => [alpha, beta, gamma];

  /// Get all binary star system names
  static List<CelestialBodyName> get binaryStarSystem => [
    starA,
    starB,
    planetP,
  ];

  /// Check if this is a planet in the solar system
  bool get isSolarSystemPlanet => solarSystemPlanets.contains(this);

  /// Check if this is a star
  bool get isStar =>
      [sun, starA, starB, centralStar, alpha, beta, gamma, star].contains(this);

  /// Check if this is a black hole
  bool get isBlackHole => [blackHole, supermassiveBlackHole].contains(this);

  /// Check if this is a moon
  bool get isMoon => [moon, moonM].contains(this);
}
