/// Represents the type of celestial body in the simulation
enum BodyType {
  /// A star that emits light and heat
  star,

  /// A planet that orbits a star
  planet,

  /// A moon that orbits a planet
  moon,

  /// A small rocky body (asteroid, comet, etc.)
  asteroid,
}

/// Extension methods for BodyType
extension BodyTypeExtension on BodyType {
  /// Whether this body type emits light and heat
  bool get isLuminous => this == BodyType.star;

  /// Whether this body type can be potentially habitable
  bool get canBeHabitable => this == BodyType.planet || this == BodyType.moon;

  /// Display name for the body type
  String get displayName {
    switch (this) {
      case BodyType.star:
        return 'Star';
      case BodyType.planet:
        return 'Planet';
      case BodyType.moon:
        return 'Moon';
      case BodyType.asteroid:
        return 'Asteroid';
    }
  }
}
