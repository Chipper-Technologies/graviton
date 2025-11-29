/// Specific reasons for Play Integrity verification failures.
///
/// These reasons help provide targeted guidance to users based on
/// the type of integrity failure encountered.
enum IntegrityFailureReason {
  /// Device integrity checks failed - device may be rooted, unlocked bootloader,
  /// or fails Play Protect checks.
  deviceIntegrity,

  /// App integrity checks failed - app may be modified, sideloaded,
  /// or not installed from Google Play.
  appIntegrity,

  /// Network error occurred during verification.
  networkError,

  /// Backend verification failed - token was invalid or expired.
  backendVerificationFailed,

  /// Token request failed - error generating integrity token.
  tokenRequestFailed,

  /// Unknown or generic failure.
  unknown,
}

/// Extension methods for IntegrityFailureReason
extension IntegrityFailureReasonExtension on IntegrityFailureReason {
  /// Get display name for analytics
  String get displayName {
    switch (this) {
      case IntegrityFailureReason.deviceIntegrity:
        return 'device_integrity';
      case IntegrityFailureReason.appIntegrity:
        return 'app_integrity';
      case IntegrityFailureReason.networkError:
        return 'network_error';
      case IntegrityFailureReason.backendVerificationFailed:
        return 'backend_verification_failed';
      case IntegrityFailureReason.tokenRequestFailed:
        return 'token_request_failed';
      case IntegrityFailureReason.unknown:
        return 'unknown';
    }
  }

  /// Get localization key for user-facing error message
  String get localizationKey {
    switch (this) {
      case IntegrityFailureReason.deviceIntegrity:
        return 'integrityErrorDeviceIntegrity';
      case IntegrityFailureReason.appIntegrity:
        return 'integrityErrorAppIntegrity';
      case IntegrityFailureReason.networkError:
        return 'integrityErrorNetwork';
      case IntegrityFailureReason.backendVerificationFailed:
        return 'integrityErrorBackendVerification';
      case IntegrityFailureReason.tokenRequestFailed:
        return 'integrityErrorTokenRequest';
      case IntegrityFailureReason.unknown:
        return 'integrityErrorUnknown';
    }
  }

  /// Get user-friendly title key for this failure reason
  String get titleKey {
    switch (this) {
      case IntegrityFailureReason.deviceIntegrity:
        return 'integrityErrorDeviceIntegrityTitle';
      case IntegrityFailureReason.appIntegrity:
        return 'integrityErrorAppIntegrityTitle';
      case IntegrityFailureReason.networkError:
        return 'integrityErrorNetworkTitle';
      case IntegrityFailureReason.backendVerificationFailed:
        return 'integrityErrorBackendVerificationTitle';
      case IntegrityFailureReason.tokenRequestFailed:
        return 'integrityErrorTokenRequestTitle';
      case IntegrityFailureReason.unknown:
        return 'integrityErrorUnknownTitle';
    }
  }

  /// Get user action guidance key for this failure reason
  String get guidanceKey {
    switch (this) {
      case IntegrityFailureReason.deviceIntegrity:
        return 'integrityGuidanceDeviceIntegrity';
      case IntegrityFailureReason.appIntegrity:
        return 'integrityGuidanceAppIntegrity';
      case IntegrityFailureReason.networkError:
        return 'integrityGuidanceNetwork';
      case IntegrityFailureReason.backendVerificationFailed:
        return 'integrityGuidanceBackendVerification';
      case IntegrityFailureReason.tokenRequestFailed:
        return 'integrityGuidanceTokenRequest';
      case IntegrityFailureReason.unknown:
        return 'integrityGuidanceUnknown';
    }
  }

  /// Parse failure reason from error code or message
  static IntegrityFailureReason fromError(String? code, String? message) {
    if (code == null && message == null) {
      return IntegrityFailureReason.unknown;
    }

    final errorText = '${code ?? ''} ${message ?? ''}'.toLowerCase();

    // Network-related errors
    if (errorText.contains('network') ||
        errorText.contains('timeout') ||
        errorText.contains('connection')) {
      return IntegrityFailureReason.networkError;
    }

    // Token request failures
    if (errorText.contains('token') && errorText.contains('request')) {
      return IntegrityFailureReason.tokenRequestFailed;
    }

    // Backend verification failures
    if (errorText.contains('backend') ||
        errorText.contains('verification') ||
        errorText.contains('invalid token')) {
      return IntegrityFailureReason.backendVerificationFailed;
    }

    // Device integrity issues
    if (errorText.contains('device') ||
        errorText.contains('rooted') ||
        errorText.contains('play protect')) {
      return IntegrityFailureReason.deviceIntegrity;
    }

    // App integrity issues
    if (errorText.contains('app') ||
        errorText.contains('sideload') ||
        errorText.contains('modified') ||
        errorText.contains('google play')) {
      return IntegrityFailureReason.appIntegrity;
    }

    return IntegrityFailureReason.unknown;
  }
}
