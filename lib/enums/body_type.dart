/// Represents the type of celestial body
enum BodyType {
  /// A black hole - region of spacetime with extreme gravity
  blackHole,

  /// A neutron star - extremely dense stellar remnant
  neutronStar,

  /// A star - massive, luminous celestial body
  star,

  /// A planet - orbits a star, cleared its orbital path
  planet,

  /// A moon - natural satellite orbiting a planet
  moon,

  /// An asteroid - small rocky body orbiting the sun
  asteroid,
}

/// Extension methods for BodyType
extension BodyTypeExtension on BodyType {
  /// Whether this body type emits light and heat
  bool get isLuminous => this == BodyType.star || this == BodyType.neutronStar;

  /// Whether this body type can potentially be habitable
  bool get canBeHabitable => this == BodyType.planet || this == BodyType.moon;

  /// Localization key for the body type display name
  String get localizationKey {
    switch (this) {
      case BodyType.blackHole:
        return 'bodyTypeBlackHole';
      case BodyType.neutronStar:
        return 'bodyTypeNeutronStar';
      case BodyType.star:
        return 'bodyTypeStar';
      case BodyType.planet:
        return 'bodyTypePlanet';
      case BodyType.moon:
        return 'bodyTypeMoon';
      case BodyType.asteroid:
        return 'bodyTypeAsteroid';
    }
  }
}
