/// Utility class for formatting numbers with proper decimal precision and units.
///
/// This class provides consistent number formatting across the Graviton app,
/// with special handling for astronomical values, physics quantities, and
/// user interface display needs.
class NumberUtils {
  // Private constructor to prevent instantiation
  NumberUtils._();

  /// Formats a decimal value with specified precision.
  ///
  /// Provides consistent decimal formatting for general use cases.
  ///
  /// Examples:
  /// - formatDecimal(123.456789, 2) → "123.46"
  /// - formatDecimal(0.0, 1) → "0.0"
  /// - formatDecimal(1000.5, 1) → "1,000.5"
  static String formatDecimal(double value, int decimals) {
    if (value == 0) return '0.${'0' * decimals}';

    final formatted = value.toStringAsFixed(decimals);
    final parts = formatted.split('.');

    // Add thousands separators to the integer part
    final integerPart = parts[0];
    final formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    if (parts.length > 1) {
      return '$formattedInteger.${parts[1]}';
    }

    return formattedInteger;
  }

  /// Formats mass values with appropriate units and precision.
  ///
  /// Uses scientific notation for very large or very small values,
  /// and standard decimal notation for moderate values.
  ///
  /// Examples:
  /// - 1.989e30 kg → "1.99×10³⁰ kg"
  /// - 5972000000000000000000000 kg → "5.97×10²⁴ kg"
  /// - 7.35e22 kg → "7.35×10²² kg"
  static String formatMass(double mass) {
    if (mass == 0) return '0 kg';

    final absValue = mass.abs();
    final sign = mass < 0 ? '-' : '';

    // For very large or very small values, use scientific notation
    if (absValue >= 1e9 || absValue < 1e-3) {
      return '$sign${_formatScientific(absValue)} kg';
    }

    // For moderate values, use decimal notation
    if (absValue >= 1000) {
      return '$sign${_formatLargeNumber(absValue)} kg';
    }

    return '$sign${_formatDecimal(absValue)} kg';
  }

  /// Formats distance values with appropriate units and precision.
  ///
  /// Automatically chooses between meters, kilometers, AU, or light-years
  /// based on the magnitude of the distance.
  ///
  /// Examples:
  /// - 149597870700 m → "1.00 AU"
  /// - 384400000 m → "384,400 km"
  /// - 9460730472580800 m → "1.00 ly"
  static String formatDistance(double distance) {
    if (distance == 0) return '0 m';

    final absValue = distance.abs();
    final sign = distance < 0 ? '-' : '';

    // Light-years (approximately 9.46e15 meters)
    if (absValue >= 9.46e15) {
      final lightYears = absValue / 9.46073047258e15;
      return '$sign${_formatDecimal(lightYears)} ly';
    }

    // Astronomical Units (149,597,870,700 meters)
    if (absValue >= 1.496e11 * 0.1) {
      // Start showing AU at 0.1 AU
      final au = absValue / 149597870700;
      return '$sign${_formatDecimal(au)} AU';
    }

    // Kilometers
    if (absValue >= 1000) {
      final km = absValue / 1000;
      if (km >= 1e9) {
        return '$sign${_formatScientific(km)} km';
      }
      return '$sign${_formatLargeNumber(km)} km';
    }

    // Meters
    return '$sign${_formatDecimal(absValue)} m';
  }

  /// Formats velocity values with appropriate precision.
  ///
  /// Uses km/s for space velocities and m/s for smaller velocities.
  ///
  /// Examples:
  /// - 29780 m/s → "29.78 km/s"
  /// - 340.29 m/s → "340.3 m/s"
  static String formatVelocity(double velocity) {
    if (velocity == 0) return '0 m/s';

    final absValue = velocity.abs();
    final sign = velocity < 0 ? '-' : '';

    // Convert to km/s for large velocities
    if (absValue >= 1000) {
      final kmPerS = absValue / 1000;
      return '$sign${_formatDecimal(kmPerS)} km/s';
    }

    return '$sign${_formatDecimal(absValue)} m/s';
  }

  /// Formats temperature values in Kelvin with appropriate precision.
  ///
  /// Shows whole numbers for temperatures above 100K,
  /// and decimal precision for lower temperatures.
  ///
  /// Examples:
  /// - 5778 K → "5,778 K"
  /// - 288.15 K → "288.2 K"
  /// - 2.7 K → "2.7 K"
  static String formatTemperature(double temperature) {
    if (temperature == 0) return '0 K';

    final absValue = temperature.abs();
    final sign = temperature < 0 ? '-' : '';

    if (absValue >= 100) {
      return '$sign${_formatLargeNumber(absValue)} K';
    }

    return '$sign${_formatDecimal(absValue)} K';
  }

  /// Formats luminosity values with appropriate units and precision.
  ///
  /// Uses solar luminosities (L☉) for stellar luminosities,
  /// and watts for smaller values.
  ///
  /// Examples:
  /// - 3.828e26 W → "1.00 L☉"
  /// - 1.51e25 W → "0.039 L☉"
  /// - 1000 W → "1,000 W"
  static String formatLuminosity(double luminosity) {
    if (luminosity == 0) return '0 W';

    final absValue = luminosity.abs();
    final sign = luminosity < 0 ? '-' : '';

    // Solar luminosity is approximately 3.828e26 W
    const solarLuminosity = 3.828e26;

    if (absValue >= solarLuminosity * 1e-6) {
      final solarLums = absValue / solarLuminosity;
      return '$sign${_formatDecimal(solarLums)} L☉';
    }

    // Use scientific notation for very large or small wattages
    if (absValue >= 1e21 || absValue < 1e-3) {
      return '$sign${_formatScientific(absValue)} W';
    }

    if (absValue >= 1000) {
      return '$sign${_formatLargeNumber(absValue)} W';
    }

    return '$sign${_formatDecimal(absValue)} W';
  }

  /// Formats a 2D vector with consistent precision.
  ///
  /// Example: Vector2(123.456, -789.012) → "(123.5, -789.0)"
  static String formatVector2(dynamic vector) {
    if (vector == null) return '(0, 0)';
    return '(${_formatDecimal(vector.x)}, ${_formatDecimal(vector.y)})';
  }

  /// Formats a 3D vector with consistent precision.
  ///
  /// Example: Vector3(123.456, -789.012, 456.789) → "(123.5, -789.0, 456.8)"
  static String formatVector3(dynamic vector) {
    if (vector == null) return '(0, 0, 0)';
    return '(${_formatDecimal(vector.x)}, ${_formatDecimal(vector.y)}, ${_formatDecimal(vector.z)})';
  }

  /// Formats a percentage value with appropriate precision.
  ///
  /// Examples:
  /// - 0.1234 → "12.3%"
  /// - 1.0 → "100%"
  /// - 0.001 → "0.1%"
  static String formatPercentage(double value) {
    final percentage = value * 100;
    if (percentage.abs() < 0.1) {
      return '${percentage.toStringAsFixed(2)}%';
    } else if (percentage.abs() < 1) {
      return '${percentage.toStringAsFixed(1)}%';
    } else {
      return '${percentage.round()}%';
    }
  }

  /// Formats a decimal number with appropriate precision.
  ///
  /// Uses up to 3 decimal places, removing trailing zeros.
  static String _formatDecimal(double value) {
    if (value == 0) return '0';
    if (!value.isFinite) return value.toString();

    final absValue = value.abs();
    final sign = value < 0 ? '-' : '';

    // For very small numbers, use more precision
    if (absValue < 0.001) {
      return '$sign${absValue.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}';
    }

    // For small numbers, use 3 decimal places
    if (absValue < 1) {
      return '$sign${absValue.toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}';
    }

    // For moderate numbers, use 1-2 decimal places
    if (absValue < 100) {
      return '$sign${absValue.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}';
    }

    if (absValue < 1000) {
      return '$sign${absValue.toStringAsFixed(1).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}';
    }

    // For larger numbers, typically no decimal places needed here
    return '$sign${absValue.round().toString()}';
  }

  /// Formats large numbers with thousand separators.
  ///
  /// Examples:
  /// - 1234567.89 → "1,234,568"
  /// - 1234.5 → "1,235"
  static String _formatLargeNumber(double value) {
    final rounded = value.round();
    if (rounded < 1000) {
      return rounded.toString();
    }
    final str = rounded.toString();
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(regex, (match) => '${match[1]},');
  }

  /// Formats numbers in scientific notation with proper Unicode symbols.
  ///
  /// Examples:
  /// - 1.23e45 → "1.23×10⁴⁵"
  /// - 5.67e-12 → "5.67×10⁻¹²"
  static String _formatScientific(double value) {
    if (value == 0) return '0';
    if (!value.isFinite) return value.toString();

    final absValue = value.abs();
    final sign = value < 0 ? '-' : '';

    // Use the string representation to get accurate scientific notation
    final scientificStr = absValue.toStringAsExponential();
    final parts = scientificStr.split('e');

    if (parts.length != 2) {
      // Fallback to regular string representation
      return value.toString();
    }

    final mantissaStr = double.parse(parts[0])
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    final exponent = int.parse(parts[1]);

    return '$sign$mantissaStr×10${_formatSuperscript(exponent)}';
  }

  /// Converts a number to Unicode superscript format for exponents.
  ///
  /// Examples:
  /// - 23 → "²³"
  /// - -12 → "⁻¹²"
  static String _formatSuperscript(int number) {
    const superscriptDigits = [
      '⁰',
      '¹',
      '²',
      '³',
      '⁴',
      '⁵',
      '⁶',
      '⁷',
      '⁸',
      '⁹',
    ];
    const superscriptMinus = '⁻';

    final str = number.abs().toString();
    final result = str
        .split('')
        .map((char) => superscriptDigits[int.parse(char)])
        .join();

    return number < 0 ? '$superscriptMinus$result' : result;
  }

  /// Formats radius values in solar radii (R☉) for astronomical contexts.
  ///
  /// Assumes that 1 sim unit ≈ 1 solar radius for stellar objects.
  /// This provides a more intuitive display for stellar and planetary radii.
  ///
  /// Examples:
  /// - 1.0 sim units → "1.0 R☉"
  /// - 0.5 sim units → "0.50 R☉"
  /// - 2.3 sim units → "2.3 R☉"
  static String formatRadiusInSolarRadii(double radiusInSimUnits) {
    if (radiusInSimUnits == 0) return '0 R☉';

    final absValue = radiusInSimUnits.abs();
    final sign = radiusInSimUnits < 0 ? '-' : '';

    // Use appropriate precision based on magnitude
    if (absValue >= 10) {
      return '$sign${formatDecimal(absValue, 1)} R☉';
    } else if (absValue >= 1) {
      return '$sign${formatDecimal(absValue, 2)} R☉';
    } else {
      return '$sign${formatDecimal(absValue, 3)} R☉';
    }
  }

  /// Formats mass values in solar masses (M☉) for astronomical contexts.
  ///
  /// Converts from simulation units to solar masses using the reference
  /// that 10 sim units = 1 solar mass (from SimulationConstants.sunMassReference).
  ///
  /// Examples:
  /// - 10.0 sim units → "1.00 M☉"
  /// - 5.0 sim units → "0.50 M☉"
  /// - 150.0 sim units → "15.0 M☉"
  static String formatMassInSolarMasses(double massInSimUnits) {
    if (massInSimUnits == 0) return '0 M☉';

    // Convert from sim units to solar masses (10 sim units = 1 solar mass)
    final solarMasses = massInSimUnits / 10.0;
    final absValue = solarMasses.abs();
    final sign = solarMasses < 0 ? '-' : '';

    // Use appropriate precision based on magnitude
    if (absValue >= 100) {
      return '$sign${formatDecimal(absValue, 0)} M☉';
    } else if (absValue >= 10) {
      return '$sign${formatDecimal(absValue, 1)} M☉';
    } else if (absValue >= 1) {
      return '$sign${formatDecimal(absValue, 2)} M☉';
    } else {
      return '$sign${formatDecimal(absValue, 3)} M☉';
    }
  }

  /// Safely converts a string to double, returning 0.0 if parsing fails.
  ///
  /// Useful for parsing user input in forms.
  static double parseDouble(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value) ?? 0.0;
  }

  /// Safely converts a string to int, returning 0 if parsing fails.
  ///
  /// Useful for parsing user input in forms.
  static int parseInt(String? value) {
    if (value == null || value.isEmpty) return 0;
    return int.tryParse(value) ?? 0;
  }
}
