/// Types of authentication providers supported by the app
///
/// This enum represents different authentication methods that users
/// can use to sign in to their account.
enum AuthProviderType {
  /// Email and password authentication
  emailPassword('password'),

  /// Google Sign-In
  google('google.com'),

  /// GitHub Sign-In
  github('github.com'),

  /// Apple Sign-In
  apple('apple.com'),

  /// Facebook authentication
  facebook('facebook.com'),

  /// Anonymous authentication (guest mode)
  anonymous('anonymous');

  const AuthProviderType(this.providerId);

  /// Firebase provider ID string
  final String providerId;

  /// Get provider type from Firebase provider ID
  static AuthProviderType? fromProviderId(String providerId) {
    try {
      return AuthProviderType.values.firstWhere(
        (type) => type.providerId == providerId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Human-readable display name for the provider
  String get displayName {
    switch (this) {
      case AuthProviderType.emailPassword:
        return 'Email';
      case AuthProviderType.google:
        return 'Google';
      case AuthProviderType.github:
        return 'GitHub';
      case AuthProviderType.apple:
        return 'Apple';
      case AuthProviderType.facebook:
        return 'Facebook';
      case AuthProviderType.anonymous:
        return 'Guest';
    }
  }
}
