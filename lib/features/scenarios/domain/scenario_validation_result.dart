/// Result of scenario validation
class ScenarioValidationResult {
  final bool isValid;
  final List<String> errors;

  const ScenarioValidationResult({required this.isValid, required this.errors});

  /// Create a successful validation result with no errors
  const ScenarioValidationResult.valid()
    : this(isValid: true, errors: const []);

  /// Create a failed validation result with the given errors
  ScenarioValidationResult.invalid(List<String> errors)
    : this(isValid: false, errors: errors);

  /// Create a failed validation result with a single error
  ScenarioValidationResult.singleError(String error)
    : this(isValid: false, errors: [error]);

  /// Check if the validation has any errors
  bool get hasErrors => errors.isNotEmpty;

  /// Get the number of errors
  int get errorCount => errors.length;

  /// Get a formatted string of all errors
  String get formattedErrors => errors.join(', ');

  /// Copy this result with additional errors
  ScenarioValidationResult copyWithAdditionalErrors(List<String> newErrors) {
    return ScenarioValidationResult(
      isValid: false, // Adding errors makes it invalid
      errors: [...errors, ...newErrors],
    );
  }

  /// Merge this result with another validation result
  ScenarioValidationResult merge(ScenarioValidationResult other) {
    return ScenarioValidationResult(
      isValid: isValid && other.isValid,
      errors: [...errors, ...other.errors],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScenarioValidationResult &&
        other.isValid == isValid &&
        _listEquals(other.errors, errors);
  }

  @override
  int get hashCode => isValid.hashCode ^ errors.hashCode;

  @override
  String toString() {
    return 'ScenarioValidationResult(isValid: $isValid, errors: $errors)';
  }

  /// Helper method for list equality check
  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
