/// Model representing premium usage limits
///
/// Contains all configurable limits for free and premium tiers,
/// populated from Remote Config with fallback defaults.
class PremiumLimits {
  /// Maximum session duration in minutes for free tier
  final int freeSessionDurationMinutes;

  /// Maximum viewers per session for free tier
  final int freeMaxViewers;

  /// Maximum sessions per day for free tier
  final int freeSessionsPerDay;

  /// Maximum viewers per session for premium tier
  final int premiumMaxViewers;

  /// Whether camera sync requires premium
  final bool cameraSyncRequiresPremium;

  /// Whether password protection requires premium
  final bool passwordRequiresPremium;

  const PremiumLimits({
    required this.freeSessionDurationMinutes,
    required this.freeMaxViewers,
    required this.freeSessionsPerDay,
    required this.premiumMaxViewers,
    required this.cameraSyncRequiresPremium,
    required this.passwordRequiresPremium,
  });

  /// Default limits when remote config is unavailable
  static const PremiumLimits defaults = PremiumLimits(
    freeSessionDurationMinutes: 15,
    freeMaxViewers: 3,
    freeSessionsPerDay: 2,
    premiumMaxViewers: 25,
    cameraSyncRequiresPremium: true,
    passwordRequiresPremium: true,
  );

  /// Create a copy with modified values
  PremiumLimits copyWith({
    int? freeSessionDurationMinutes,
    int? freeMaxViewers,
    int? freeSessionsPerDay,
    int? premiumMaxViewers,
    bool? cameraSyncRequiresPremium,
    bool? passwordRequiresPremium,
  }) {
    return PremiumLimits(
      freeSessionDurationMinutes:
          freeSessionDurationMinutes ?? this.freeSessionDurationMinutes,
      freeMaxViewers: freeMaxViewers ?? this.freeMaxViewers,
      freeSessionsPerDay: freeSessionsPerDay ?? this.freeSessionsPerDay,
      premiumMaxViewers: premiumMaxViewers ?? this.premiumMaxViewers,
      cameraSyncRequiresPremium:
          cameraSyncRequiresPremium ?? this.cameraSyncRequiresPremium,
      passwordRequiresPremium:
          passwordRequiresPremium ?? this.passwordRequiresPremium,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PremiumLimits &&
        other.freeSessionDurationMinutes == freeSessionDurationMinutes &&
        other.freeMaxViewers == freeMaxViewers &&
        other.freeSessionsPerDay == freeSessionsPerDay &&
        other.premiumMaxViewers == premiumMaxViewers &&
        other.cameraSyncRequiresPremium == cameraSyncRequiresPremium &&
        other.passwordRequiresPremium == passwordRequiresPremium;
  }

  @override
  int get hashCode {
    return Object.hash(
      freeSessionDurationMinutes,
      freeMaxViewers,
      freeSessionsPerDay,
      premiumMaxViewers,
      cameraSyncRequiresPremium,
      passwordRequiresPremium,
    );
  }

  @override
  String toString() {
    return 'PremiumLimits('
        'freeSessionDurationMinutes: $freeSessionDurationMinutes, '
        'freeMaxViewers: $freeMaxViewers, '
        'freeSessionsPerDay: $freeSessionsPerDay, '
        'premiumMaxViewers: $premiumMaxViewers, '
        'cameraSyncRequiresPremium: $cameraSyncRequiresPremium, '
        'passwordRequiresPremium: $passwordRequiresPremium)';
  }
}
