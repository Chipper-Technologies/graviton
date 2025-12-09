/// Enum representing different temperature unit options
enum TemperatureUnit {
  /// Celsius (°C)
  celsius,

  /// Fahrenheit (°F)
  fahrenheit,

  /// Kelvin (K)
  kelvin;

  /// Get the unit symbol for display
  String get symbol {
    switch (this) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.kelvin:
        return 'K';
    }
  }

  /// Get the localization key for this temperature unit name
  String get nameLocalizationKey {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'temperatureUnitCelsiusName';
      case TemperatureUnit.fahrenheit:
        return 'temperatureUnitFahrenheitName';
      case TemperatureUnit.kelvin:
        return 'temperatureUnitKelvinName';
    }
  }

  /// Get the localization key for this temperature unit symbol
  String get symbolLocalizationKey {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'temperatureUnitCelsius';
      case TemperatureUnit.fahrenheit:
        return 'temperatureUnitFahrenheit';
      case TemperatureUnit.kelvin:
        return 'temperatureUnitKelvin';
    }
  }

  /// Convert from a string value (for persistence)
  static TemperatureUnit fromString(String value) {
    switch (value.toLowerCase()) {
      case 'celsius':
        return TemperatureUnit.celsius;
      case 'fahrenheit':
        return TemperatureUnit.fahrenheit;
      case 'kelvin':
        return TemperatureUnit.kelvin;
      default:
        return TemperatureUnit.celsius; // Default to Celsius
    }
  }
}
