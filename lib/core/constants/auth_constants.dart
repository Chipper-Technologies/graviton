/// Authentication and security constants for the application.
class AuthConstants {
  /// Private constructor to prevent instantiation.
  AuthConstants._();

  // ============================================================================
  // Rate Limiting Configuration
  // ============================================================================

  /// Maximum failed sign-in attempts before rate limiting kicks in
  static const int maxFailedAttempts = 5;

  /// Rate limit duration in minutes
  static const int rateLimitDurationMinutes = 15;
}
