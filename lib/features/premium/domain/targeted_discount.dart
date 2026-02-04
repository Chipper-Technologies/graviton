/// Model representing a targeted discount for specific users
///
/// Allows configuration of user-specific pricing discounts via
/// Remote Config for promotional campaigns or special offers.
class TargetedDiscount {
  /// User ID to target (Firebase UID)
  final String userId;

  /// Discount percentage (0-100)
  final int discountPercentage;

  /// Reason for the discount (displayed to user)
  final String reason;

  /// Expiry date for the discount (ISO 8601 format)
  final DateTime? expiresAt;

  /// Whether discount applies to monthly subscription
  final bool appliesToMonthly;

  /// Whether discount applies to yearly subscription
  final bool appliesToYearly;

  /// Whether discount applies to lifetime purchase
  final bool appliesToLifetime;

  const TargetedDiscount({
    required this.userId,
    required this.discountPercentage,
    required this.reason,
    this.expiresAt,
    this.appliesToMonthly = true,
    this.appliesToYearly = true,
    this.appliesToLifetime = true,
  });

  /// Whether the discount is still valid (not expired)
  bool get isValid {
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }

  /// Create from JSON
  factory TargetedDiscount.fromJson(Map<String, dynamic> json) {
    return TargetedDiscount(
      userId: json['user_id'] as String,
      discountPercentage: json['discount_percentage'] as int? ?? 0,
      reason: json['reason'] as String? ?? '',
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
      appliesToMonthly: json['applies_to_monthly'] as bool? ?? true,
      appliesToYearly: json['applies_to_yearly'] as bool? ?? true,
      appliesToLifetime: json['applies_to_lifetime'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'discount_percentage': discountPercentage,
      'reason': reason,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      'applies_to_monthly': appliesToMonthly,
      'applies_to_yearly': appliesToYearly,
      'applies_to_lifetime': appliesToLifetime,
    };
  }

  /// Parse a list of targeted discounts from JSON array
  static List<TargetedDiscount> parseList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => TargetedDiscount.fromJson(json as Map<String, dynamic>))
        .where((discount) => discount.isValid)
        .toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TargetedDiscount &&
        other.userId == userId &&
        other.discountPercentage == discountPercentage &&
        other.reason == reason &&
        other.expiresAt == expiresAt &&
        other.appliesToMonthly == appliesToMonthly &&
        other.appliesToYearly == appliesToYearly &&
        other.appliesToLifetime == appliesToLifetime;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      discountPercentage,
      reason,
      expiresAt,
      appliesToMonthly,
      appliesToYearly,
      appliesToLifetime,
    );
  }

  @override
  String toString() {
    return 'TargetedDiscount('
        'userId: $userId, '
        'discountPercentage: $discountPercentage, '
        'reason: $reason, '
        'expiresAt: $expiresAt)';
  }
}
