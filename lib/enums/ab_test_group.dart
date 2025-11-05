/// Represents A/B test groups for remote configuration
enum ABTestGroup {
  /// Control group (default behavior)
  control,

  /// Experimental group (new features)
  experimental,

  /// Variant A group
  variantA,

  /// Variant B group
  variantB,
}

/// Extension methods for ABTestGroup
extension ABTestGroupExtension on ABTestGroup {
  /// Get string value for remote config storage
  String get configValue {
    switch (this) {
      case ABTestGroup.control:
        return 'control';
      case ABTestGroup.experimental:
        return 'experimental';
      case ABTestGroup.variantA:
        return 'variant_a';
      case ABTestGroup.variantB:
        return 'variant_b';
    }
  }

  /// Create from string value (for remote config parsing)
  static ABTestGroup fromString(String value) {
    switch (value.toLowerCase()) {
      case 'control':
        return ABTestGroup.control;
      case 'experimental':
        return ABTestGroup.experimental;
      case 'variant_a':
        return ABTestGroup.variantA;
      case 'variant_b':
        return ABTestGroup.variantB;
      default:
        return ABTestGroup.control; // Default fallback
    }
  }

  /// Whether this group should use experimental features
  bool get isExperimental =>
      this == ABTestGroup.experimental ||
      this == ABTestGroup.variantA ||
      this == ABTestGroup.variantB;

  /// Whether this is the control group
  bool get isControl => this == ABTestGroup.control;
}
