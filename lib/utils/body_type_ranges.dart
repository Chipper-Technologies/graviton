import '../enums/body_type.dart';

/// Utility class for calculating realistic property ranges based on celestial body types.
///
/// This class provides dynamic min/max ranges for mass, radius, and luminosity
/// based on the type of celestial body being created or edited. The ranges are
/// designed to provide intuitive slider control while maintaining physical realism.
class BodyTypeRanges {
  /// Private constructor to prevent instantiation of utility class
  BodyTypeRanges._();

  /// Gets the realistic mass range for a given body type.
  ///
  /// Returns a Map with 'min' and 'max' keys containing double values.
  /// The ranges are based on typical values for each celestial body type:
  /// - Stars: 5.0 to 300.0 (Regular stars to supermassive black holes)
  /// - Planets: 0.5 to 15.0 (Small rocky to gas giants)
  /// - Moons: 0.05 to 2.0 (Tiny moons to large moons)
  /// - Asteroids: 0.01 to 0.5 (Dust to large asteroids)
  static Map<String, double> getMassRange(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return {
          'min': 5.0,
          'max': 300.0,
        }; // Regular stars to supermassive black holes
      case BodyType.planet:
        return {'min': 0.5, 'max': 15.0}; // Small rocky to gas giants
      case BodyType.moon:
        return {'min': 0.05, 'max': 2.0}; // Tiny moons to large moons
      case BodyType.asteroid:
        return {'min': 0.01, 'max': 0.5}; // Dust to large asteroids
    }
  }

  /// Gets the realistic radius range for a given body type.
  ///
  /// Returns a Map with 'min' and 'max' keys containing double values.
  /// The ranges are based on typical values for each celestial body type:
  /// - Stars: 0.8 to 8.0 (Compact stars to red giants)
  /// - Planets: 0.3 to 4.0 (Small rocky to gas giants)
  /// - Moons: 0.1 to 1.2 (Tiny to large moons)
  /// - Asteroids: 0.05 to 0.8 (Dust to large asteroids)
  static Map<String, double> getRadiusRange(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return {'min': 0.8, 'max': 8.0}; // Compact stars to red giants
      case BodyType.planet:
        return {'min': 0.3, 'max': 4.0}; // Small rocky to gas giants
      case BodyType.moon:
        return {'min': 0.1, 'max': 1.2}; // Tiny to large moons
      case BodyType.asteroid:
        return {'min': 0.05, 'max': 0.8}; // Dust to large asteroids
    }
  }

  /// Gets the realistic luminosity range for a given body type.
  ///
  /// Returns a Map with 'min' and 'max' keys containing double values.
  /// The ranges are based on typical values for each celestial body type:
  /// - Stars: 0.1 to 10.0 (Red dwarfs to blue giants)
  /// - Planets/Moons/Asteroids: 0.0 to 0.0 (Non-luminous bodies)
  static Map<String, double> getLuminosityRange(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return {'min': 0.1, 'max': 10.0}; // Red dwarfs to blue giants
      case BodyType.planet:
      case BodyType.moon:
      case BodyType.asteroid:
        return {'min': 0.0, 'max': 0.0}; // Non-luminous bodies
    }
  }

  /// Gets realistic default property values for a given body type.
  ///
  /// Returns a Map with 'mass', 'radius', and 'luminosity' keys.
  /// These values are positioned in the lower-middle range of each body type
  /// to provide sensible starting points for creation.
  static Map<String, double> getDefaultProperties(BodyType bodyType) {
    final massRange = getMassRange(bodyType);
    final radiusRange = getRadiusRange(bodyType);
    final luminosityRange = getLuminosityRange(bodyType);

    // Use values in the lower-middle portion of each range for defaults
    final massDefault =
        massRange['min']! + (massRange['max']! - massRange['min']!) * 0.3;
    final radiusDefault =
        radiusRange['min']! + (radiusRange['max']! - radiusRange['min']!) * 0.3;
    final luminosityDefault =
        luminosityRange['min']! +
        (luminosityRange['max']! - luminosityRange['min']!) * 0.3;

    return {
      'mass': massDefault,
      'radius': radiusDefault,
      'luminosity': luminosityDefault,
    };
  }

  /// Validates that a property value is within the acceptable range for a body type.
  ///
  /// Returns true if the value is within range, false otherwise.
  /// This is useful for form validation and data integrity checks.
  static bool isValidMass(BodyType bodyType, double mass) {
    final range = getMassRange(bodyType);
    return mass >= range['min']! && mass <= range['max']!;
  }

  /// Validates that a radius value is within the acceptable range for a body type.
  static bool isValidRadius(BodyType bodyType, double radius) {
    final range = getRadiusRange(bodyType);
    return radius >= range['min']! && radius <= range['max']!;
  }

  /// Validates that a luminosity value is within the acceptable range for a body type.
  static bool isValidLuminosity(BodyType bodyType, double luminosity) {
    final range = getLuminosityRange(bodyType);
    return luminosity >= range['min']! && luminosity <= range['max']!;
  }
}
