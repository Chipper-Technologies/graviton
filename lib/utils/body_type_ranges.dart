import 'package:graviton/core/enums/body_type.dart';

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
  /// - Stars: 5.0 to 300.0 (Regular stars to supergiants)
  /// - Planets: 0.5 to 15.0 (Small rocky to gas giants)
  /// - Moons: 0.05 to 2.0 (Tiny moons to large moons)
  /// - Asteroids: 0.01 to 0.5 (Dust to large asteroids)
  /// - Black Holes: 50.0 to 1000.0 (Stellar to supermassive black holes)
  /// - Neutron Stars: 8.0 to 20.0 (Typical neutron star range)
  static Map<String, double> getMassRange(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return {'min': 5.0, 'max': 300.0}; // Regular stars to supergiants
      case BodyType.planet:
        return {'min': 0.5, 'max': 15.0}; // Small rocky to gas giants
      case BodyType.moon:
        return {'min': 0.05, 'max': 2.0}; // Tiny moons to large moons
      case BodyType.asteroid:
        return {'min': 0.01, 'max': 0.5}; // Dust to large asteroids
      case BodyType.blackHole:
        return {
          'min': 50.0,
          'max': 1000.0,
        }; // Stellar to supermassive black holes
      case BodyType.neutronStar:
        return {'min': 8.0, 'max': 20.0}; // Typical neutron star range
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
  /// - Black Holes: 0.1 to 10.0 (Event horizon representation)
  /// - Neutron Stars: 0.5 to 1.5 (Very compact)
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
      case BodyType.blackHole:
        return {'min': 0.1, 'max': 10.0}; // Event horizon representation
      case BodyType.neutronStar:
        return {'min': 0.5, 'max': 1.5}; // Very compact
    }
  }

  /// Gets the realistic luminosity range for a given body type.
  ///
  /// Returns a Map with 'min' and 'max' keys containing double values.
  /// The ranges are based on typical values for each celestial body type:
  /// - Stars: 0.1 to 10.0 (Red dwarfs to blue giants)
  /// - Neutron Stars: 0.1 to 5.0 (Pulsar radiation)
  /// - Planets/Moons/Asteroids/Black Holes: 0.0 to 0.0 (Non-luminous bodies)
  static Map<String, double> getLuminosityRange(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return {'min': 0.1, 'max': 10.0}; // Red dwarfs to blue giants
      case BodyType.neutronStar:
        return {'min': 0.1, 'max': 5.0}; // Pulsar radiation
      case BodyType.planet:
      case BodyType.moon:
      case BodyType.asteroid:
      case BodyType.blackHole:
        return {'min': 0.0, 'max': 0.0}; // Non-luminous bodies
    }
  }

  /// Gets the realistic temperature range for a given body type.
  ///
  /// Returns a Map with 'min' and 'max' keys containing double values in Kelvin.
  /// The ranges are based on typical values for each celestial body type:
  /// - Stars: 2000K to 50000K (Red dwarfs to hot blue stars)
  /// - Neutron Stars: 100000K to 10000000K (Extremely hot surface)
  /// - Black Holes: 0K to 100K (Very cold, minimal temperature)
  /// - Planets: 50K to 800K (Frozen gas giants to hot Venus-like)
  /// - Moons: 50K to 400K (Frozen outer moons to tidally heated)
  /// - Asteroids: 100K to 400K (Outer belt to inner belt)
  static Map<String, double> getTemperatureRange(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return {'min': 2000.0, 'max': 50000.0}; // Red dwarfs to hot blue stars
      case BodyType.neutronStar:
        return {'min': 100000.0, 'max': 10000000.0}; // Extremely hot surface
      case BodyType.blackHole:
        return {
          'min': 0.01,
          'max': 100.0,
        }; // Very cold due to Hawking radiation
      case BodyType.planet:
        return {
          'min': 50.0,
          'max': 800.0,
        }; // Frozen gas giants to hot Venus-like
      case BodyType.moon:
        return {
          'min': 50.0,
          'max': 400.0,
        }; // Frozen outer moons to tidally heated
      case BodyType.asteroid:
        return {'min': 100.0, 'max': 400.0}; // Outer belt to inner belt
    }
  }

  /// Gets realistic default property values for a given body type.
  ///
  /// Returns a Map with 'mass', 'radius', 'luminosity', and 'temperature' keys.
  /// These values are positioned in the lower-middle range of each body type
  /// to provide sensible starting points for creation.
  static Map<String, double> getDefaultProperties(BodyType bodyType) {
    final massRange = getMassRange(bodyType);
    final radiusRange = getRadiusRange(bodyType);
    final luminosityRange = getLuminosityRange(bodyType);
    final temperatureRange = getTemperatureRange(bodyType);

    // Use values in the lower-middle portion of each range for defaults
    final massDefault =
        massRange['min']! + (massRange['max']! - massRange['min']!) * 0.3;
    final radiusDefault =
        radiusRange['min']! + (radiusRange['max']! - radiusRange['min']!) * 0.3;
    final luminosityDefault =
        luminosityRange['min']! +
        (luminosityRange['max']! - luminosityRange['min']!) * 0.3;
    final temperatureDefault =
        temperatureRange['min']! +
        (temperatureRange['max']! - temperatureRange['min']!) * 0.3;

    return {
      'mass': massDefault,
      'radius': radiusDefault,
      'luminosity': luminosityDefault,
      'temperature': temperatureDefault,
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
