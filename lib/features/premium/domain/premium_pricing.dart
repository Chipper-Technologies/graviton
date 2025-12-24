/// Model representing premium pricing configuration
///
/// Contains pricing for all subscription tiers, populated from
/// Remote Config with fallback defaults. Supports targeted discounts.
class PremiumPricing {
  /// Monthly subscription price in USD
  final double monthlyPriceUsd;

  /// Yearly subscription price in USD
  final double yearlyPriceUsd;

  /// Lifetime purchase price in USD
  final double lifetimePriceUsd;

  /// Optional discount percentage (0-100)
  final int? discountPercentage;

  /// Optional discount reason for display
  final String? discountReason;

  const PremiumPricing({
    required this.monthlyPriceUsd,
    required this.yearlyPriceUsd,
    required this.lifetimePriceUsd,
    this.discountPercentage,
    this.discountReason,
  });

  /// Default pricing when remote config is unavailable
  static const PremiumPricing defaults = PremiumPricing(
    monthlyPriceUsd: 2.99,
    yearlyPriceUsd: 19.99,
    lifetimePriceUsd: 39.99,
  );

  /// Whether a discount is active
  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;

  /// Calculate discounted monthly price
  double get discountedMonthlyPrice {
    if (!hasDiscount) return monthlyPriceUsd;
    return monthlyPriceUsd * (1 - discountPercentage! / 100);
  }

  /// Calculate discounted yearly price
  double get discountedYearlyPrice {
    if (!hasDiscount) return yearlyPriceUsd;
    return yearlyPriceUsd * (1 - discountPercentage! / 100);
  }

  /// Calculate discounted lifetime price
  double get discountedLifetimePrice {
    if (!hasDiscount) return lifetimePriceUsd;
    return lifetimePriceUsd * (1 - discountPercentage! / 100);
  }

  /// Calculate yearly savings compared to monthly
  double get yearlySavings {
    final monthlyTotal = discountedMonthlyPrice * 12;
    return monthlyTotal - discountedYearlyPrice;
  }

  /// Calculate yearly savings percentage
  int get yearlySavingsPercentage {
    final monthlyTotal = discountedMonthlyPrice * 12;
    return ((yearlySavings / monthlyTotal) * 100).round();
  }

  /// Create from JSON (Remote Config)
  factory PremiumPricing.fromJson(Map<String, dynamic> json) {
    return PremiumPricing(
      monthlyPriceUsd:
          (json['monthly_price'] as num?)?.toDouble() ??
          defaults.monthlyPriceUsd,
      yearlyPriceUsd:
          (json['yearly_price'] as num?)?.toDouble() ?? defaults.yearlyPriceUsd,
      lifetimePriceUsd:
          (json['lifetime_price'] as num?)?.toDouble() ??
          defaults.lifetimePriceUsd,
      discountPercentage: json['discount_percentage'] as int?,
      discountReason: json['discount_reason'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'monthly_price': monthlyPriceUsd,
      'yearly_price': yearlyPriceUsd,
      'lifetime_price': lifetimePriceUsd,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (discountReason != null) 'discount_reason': discountReason,
    };
  }

  /// Create a copy with modified values
  PremiumPricing copyWith({
    double? monthlyPriceUsd,
    double? yearlyPriceUsd,
    double? lifetimePriceUsd,
    int? discountPercentage,
    String? discountReason,
  }) {
    return PremiumPricing(
      monthlyPriceUsd: monthlyPriceUsd ?? this.monthlyPriceUsd,
      yearlyPriceUsd: yearlyPriceUsd ?? this.yearlyPriceUsd,
      lifetimePriceUsd: lifetimePriceUsd ?? this.lifetimePriceUsd,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountReason: discountReason ?? this.discountReason,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PremiumPricing &&
        other.monthlyPriceUsd == monthlyPriceUsd &&
        other.yearlyPriceUsd == yearlyPriceUsd &&
        other.lifetimePriceUsd == lifetimePriceUsd &&
        other.discountPercentage == discountPercentage &&
        other.discountReason == discountReason;
  }

  @override
  int get hashCode {
    return Object.hash(
      monthlyPriceUsd,
      yearlyPriceUsd,
      lifetimePriceUsd,
      discountPercentage,
      discountReason,
    );
  }

  @override
  String toString() {
    return 'PremiumPricing('
        'monthlyPriceUsd: $monthlyPriceUsd, '
        'yearlyPriceUsd: $yearlyPriceUsd, '
        'lifetimePriceUsd: $lifetimePriceUsd, '
        'discountPercentage: $discountPercentage, '
        'discountReason: $discountReason)';
  }
}
