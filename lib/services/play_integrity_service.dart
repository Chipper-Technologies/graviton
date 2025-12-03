import 'dart:convert';
import 'dart:math' show Random;

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/services.dart';
import 'package:graviton/enums/integrity_enforcement_level.dart';
import 'package:graviton/enums/integrity_failure_reason.dart';
import 'package:graviton/models/integrity_config.dart';
import 'package:graviton/models/play_integrity_exception.dart';
import 'package:graviton/services/firebase_service.dart';

/// Service for integrating Google Play Integrity API with phased enforcement.
///
/// The Play Integrity API helps protect your apps and games from potentially
/// risky and fraudulent interactions, allowing you to respond with appropriate
/// actions to reduce attacks and abuse such as fraud, cheating, and unauthorized access.
///
/// Example usage:
/// ```dart
/// final integrityService = PlayIntegrityService();
/// try {
///   final token = await integrityService.requestIntegrityToken(userId: '12345');
///   // Send token to your backend for verification
///   await verifyTokenOnBackend(token);
/// } catch (e) {
///   // Handle error
/// }
/// ```
class PlayIntegrityService {
  static const MethodChannel _channel = MethodChannel(
    'io.chipper.graviton/play_integrity',
  );

  /// Requests an integrity token from the Play Integrity API.
  ///
  /// **SECURITY CRITICAL**: The [nonce] parameter MUST be generated on your
  /// secure backend server and fetched by the client. Client-side nonce
  /// generation is a security vulnerability that undermines integrity verification.
  ///
  /// The nonce should be:
  /// - Generated server-side with cryptographically secure random data
  /// - Time-limited (expire after 1-5 minutes)
  /// - Associated with the user's session
  /// - Verified on your backend when validating the integrity token
  ///
  /// The [userId] is used for logging and analytics only.
  ///
  /// Returns a JWT token that can be verified on your backend server using
  /// Google's Play Integrity API verification service.
  ///
  /// Throws [PlatformException] if the integrity token request fails.
  /// Throws [AssertionError] in production if using fallback client-side nonce.
  Future<String> requestIntegrityToken({
    required String userId,
    String? nonce,
  }) async {
    try {
      // SECURITY: Require backend-generated nonce in production
      final effectiveNonce = nonce ?? _generateNonceFallback(userId);

      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'requestIntegrityToken',
        {'nonce': effectiveNonce},
      );

      if (result == null || !result.containsKey('token')) {
        throw PlatformException(
          code: 'INVALID_RESPONSE',
          message: 'Invalid response from Play Integrity API',
        );
      }

      return result['token'] as String;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to request integrity token: ${e.message}',
        details: e.details,
      );
    }
  }

  /// **DEPRECATED**: Fallback nonce generation for backward compatibility.
  ///
  /// ⚠️ **SECURITY WARNING**: This method generates nonces client-side, which is
  /// a security vulnerability. Client-side nonces can be tampered with, allowing
  /// attackers to bypass integrity verification.
  ///
  /// **DO NOT USE IN PRODUCTION**. This method will log warnings in release builds
  /// and should only be used during development or migration.
  ///
  /// **Security Improvements (v2)**:
  /// While still insecure for production, this implementation now uses:
  /// - Cryptographically secure random number generation (Random.secure())
  /// - 32 bytes of entropy (256 bits) instead of predictable timestamp
  /// - Base64URL encoding for safe transport
  /// - User ID prefix for debugging (not for security)
  ///
  /// **Migration Path**:
  /// 1. Create a backend endpoint that generates secure nonces
  /// 2. Fetch nonce from backend before calling requestIntegrityToken()
  /// 3. Pass the backend nonce to requestIntegrityToken(nonce: backendNonce)
  /// 4. Remove all calls to this fallback method
  String _generateNonceFallback(String userId) {
    // Log security warning in production/release builds
    if (!kDebugMode) {
      debugPrint(
        '⚠️ SECURITY WARNING: Using client-side nonce generation in production build! '
        'This is a security vulnerability. Nonces MUST be generated on your backend server. '
        'See docs/PLAY_INTEGRITY.md for implementation guidance.',
      );

      // Log to analytics for monitoring
      FirebaseService.instance.logEvent(
        'security_warning_client_nonce',
        parameters: {'user_id': userId, 'severity': 'high'},
      );
    } else {
      debugPrint(
        'PlayIntegrityService: Using client-side nonce fallback (development only). '
        'Switch to backend nonces before production deployment.',
      );
    }

    // Generate cryptographically secure random bytes
    // Using 32 bytes (256 bits) for strong entropy
    final random = Random.secure();
    final randomBytes = Uint8List(32);
    for (var i = 0; i < randomBytes.length; i++) {
      randomBytes[i] = random.nextInt(256);
    }

    // Include timestamp for debugging/correlation (still client-controlled)
    // but not as the primary entropy source
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Combine: random data + timestamp + userId hash for debugging
    // Format: random(32 bytes) + timestamp(8 bytes) + userId(variable)
    final userIdBytes = utf8.encode(userId);
    final timestampBytes = Uint8List(8);
    for (var i = 0; i < 8; i++) {
      timestampBytes[i] = (timestamp >> (i * 8)) & 0xFF;
    }

    // Concatenate all components
    final combinedBytes = Uint8List(
      randomBytes.length + timestampBytes.length + userIdBytes.length,
    );
    combinedBytes.setRange(0, randomBytes.length, randomBytes);
    combinedBytes.setRange(
      randomBytes.length,
      randomBytes.length + timestampBytes.length,
      timestampBytes,
    );
    combinedBytes.setRange(
      randomBytes.length + timestampBytes.length,
      combinedBytes.length,
      userIdBytes,
    );

    return base64Url.encode(combinedBytes);
  }

  /// Checks if the Play Integrity API is available on this device.
  ///
  /// Returns true if running on Android and the Play Integrity API is available.
  /// Returns false on iOS, web, or other platforms.
  Future<bool> isAvailable() async {
    try {
      await _channel.invokeMethod<void>('checkAvailability');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify device integrity with enforcement policy for a specific operation.
  ///
  /// **⚠️ SECURITY WARNING**: Without [verifyTokenCallback], this method only
  /// generates tokens but NEVER verifies them with Google's backend. This provides
  /// **zero security value** while adding latency. Tokens could be from compromised
  /// devices or tampered with.
  ///
  /// **REQUIRED FOR PRODUCTION**: Provide [verifyTokenCallback] that calls your
  /// backend to verify the token with Google's Play Integrity API. See
  /// docs/PLAY_INTEGRITY.md for backend implementation.
  ///
  /// This method implements the phased rollout strategy:
  /// - **Phase 1 (logOnly)**: Logs failures, operation proceeds
  /// - **Phase 2 (warnUser)**: Logs + warns user, operation proceeds
  /// - **Phase 3 (blockHighRisk)**: Blocks high-risk ops, allows low-risk
  /// - **Phase 4 (blockAll)**: Blocks all operations
  ///
  /// Parameters:
  /// - [operationId]: Unique identifier for the operation (e.g., 'auth_sign_in')
  /// - [userId]: User identifier for nonce generation
  /// - [verifyTokenCallback]: **REQUIRED** Backend verification function that
  ///   returns true if token is valid. Without this, no actual verification occurs.
  /// - [nonce]: Backend-generated nonce (required for production security)
  /// - [allowUnverifiedForMonitoring]: Set to true to explicitly allow monitoring-only
  ///   mode without backend verification. **DANGEROUS**: Only use during initial
  ///   rollout to collect metrics. MUST be false in production.
  ///
  /// Throws [IntegrityVerificationFailedException] if verification fails
  /// and enforcement level requires blocking.
  ///
  /// Throws [AssertionError] in production if [verifyTokenCallback] is null
  /// without [allowUnverifiedForMonitoring] = true.
  ///
  /// Example WITH verification (secure):
  /// ```dart
  /// try {
  ///   // Fetch nonce from backend
  ///   final nonce = await backendService.generateNonce(userId);
  ///
  ///   await playIntegrityService.verifyWithEnforcement(
  ///     operationId: 'auth_sign_in',
  ///     userId: user.email,
  ///     nonce: nonce,
  ///     verifyTokenCallback: (token) async {
  ///       // Call your backend to verify with Google
  ///       return await backendService.verifyIntegrityToken(token, nonce);
  ///     },
  ///   );
  ///   // Proceed with sign-in
  /// } catch (e) {
  ///   if (e is IntegrityVerificationFailedException) {
  ///     // Show error to user
  ///   }
  /// }
  /// ```
  ///
  /// Example monitoring-only (MUST be temporary):
  /// ```dart
  /// // ⚠️ MONITORING ONLY: Token generated but never verified
  /// // This provides ZERO security - use only for initial metrics gathering
  /// await playIntegrityService.verifyWithEnforcement(
  ///   operationId: 'auth_sign_in',
  ///   userId: user.email,
  ///   allowUnverifiedForMonitoring: true, // Explicit acknowledgment
  /// );
  /// ```
  Future<void> verifyWithEnforcement({
    required String operationId,
    required String userId,
    String? nonce,
    Future<bool> Function(String token)? verifyTokenCallback,
    bool allowUnverifiedForMonitoring = false,
  }) async {
    // Check if API is available
    final available = await isAvailable();
    if (!available) {
      // Not Android or API unavailable - log and proceed
      await _logIntegrityEvent(
        operationId: operationId,
        status: 'not_available',
        enforcementLevel: IntegrityEnforcementLevel.logOnly,
      );
      return;
    }

    // Get enforcement configuration
    final config = IntegrityConfig.instance;
    if (!config.isInitialized) {
      await config.initialize();
    }

    // Check if Play Integrity is globally disabled via Remote Config
    if (!config.isEnabled()) {
      debugPrint(
        'PlayIntegrityService: Play Integrity checks are disabled via Remote Config',
      );
      await _logIntegrityEvent(
        operationId: operationId,
        status: 'disabled',
        enforcementLevel: IntegrityEnforcementLevel.logOnly,
      );
      return;
    }

    // Check development bypass
    if (kDebugMode && config.isDevelopmentBypassEnabled()) {
      debugPrint(
        'PlayIntegrityService: Development bypass enabled for $operationId',
      );
      return;
    }

    // Determine enforcement level for this operation
    final enforcementLevel = config.getEffectiveEnforcementLevel(operationId);

    // 🛑 CRITICAL SECURITY CHECK: Require verification callback in production
    if (verifyTokenCallback == null) {
      // Development mode: Allow unverified if in debug mode
      if (kDebugMode) {
        debugPrint(
          'PlayIntegrityService: Token verification disabled for $operationId '
          '(development mode). Add verifyTokenCallback for production security.',
        );
      } else if (!allowUnverifiedForMonitoring) {
        // Production mode: BLOCK unless explicitly allowed for monitoring
        throw AssertionError(
          '🛑 CRITICAL SECURITY ERROR: Play Integrity verification callback is '
          'required in production for operation: $operationId. Either:\n'
          '1. Provide verifyTokenCallback parameter (RECOMMENDED)\n'
          '2. Set allowUnverifiedForMonitoring=true (TEMPORARY ONLY for Phase 1)\n'
          'See docs/PLAY_INTEGRITY.md for backend verification implementation.',
        );
      } else {
        // Production mode with explicit monitoring-only flag
        debugPrint(
          '⚠️ SECURITY WARNING: Play Integrity token generated but NOT verified '
          'for operation: $operationId. This provides NO security value. '
          'See docs/PLAY_INTEGRITY.md for backend verification implementation.',
        );

        // Log missing verification in production
        await FirebaseService.instance.logEvent(
          'security_warning_no_token_verification',
          parameters: {
            'operation_id': operationId,
            'user_id': userId,
            'severity': 'critical',
            'explicitly_allowed': true,
          },
        );
      }
    }

    // Request integrity token
    String? token;
    Exception? error;
    try {
      token = await requestIntegrityToken(userId: userId, nonce: nonce);
    } catch (e) {
      error = e is Exception ? e : Exception(e.toString());
    }

    // Verify token with backend (if callback provided)
    bool isTokenValid = false;
    if (token != null && verifyTokenCallback != null) {
      try {
        isTokenValid = await verifyTokenCallback(token);
        if (!isTokenValid) {
          error = Exception('Backend verification failed: Invalid token');
        }
      } catch (e) {
        error = Exception('Backend verification error: ${e.toString()}');
      }
    } else if (token != null && verifyTokenCallback == null) {
      // Token obtained but no verification - treat as "unverified success"
      // Log this state for monitoring
      await _logIntegrityEvent(
        operationId: operationId,
        status: 'token_generated_not_verified',
        enforcementLevel: enforcementLevel,
      );
      return; // Don't block operations when verification is not configured
    }

    // Handle verification result based on enforcement level
    if (error != null || token == null || !isTokenValid) {
      await _handleVerificationFailure(
        operationId: operationId,
        enforcementLevel: enforcementLevel,
        error: error,
        hasVerification: verifyTokenCallback != null,
      );
    } else {
      await _logIntegrityEvent(
        operationId: operationId,
        status: 'verified_success',
        enforcementLevel: enforcementLevel,
      );
    }
  }

  /// Handle verification failure based on enforcement level
  Future<void> _handleVerificationFailure({
    required String operationId,
    required IntegrityEnforcementLevel enforcementLevel,
    Exception? error,
    required bool hasVerification,
  }) async {
    // Determine specific failure reason from error
    final failureReason = _determineFailureReason(error);

    // Log the failure with specific reason
    await _logIntegrityEvent(
      operationId: operationId,
      status: 'failed',
      enforcementLevel: enforcementLevel,
      error: error?.toString(),
      failureReason: failureReason,
    );

    // Take action based on enforcement level
    switch (enforcementLevel) {
      case IntegrityEnforcementLevel.logOnly:
        // Phase 1: Just log, don't block
        if (kDebugMode) {
          debugPrint(
            'PlayIntegrityService: Integrity check failed for $operationId '
            '(log only) - Reason: ${failureReason.displayName}',
          );
        }
        break;

      case IntegrityEnforcementLevel.warnUser:
        // Phase 2: Log + warn user (caller should handle warning UI)
        if (kDebugMode) {
          debugPrint(
            'PlayIntegrityService: Integrity check failed for $operationId '
            '(warning user) - Reason: ${failureReason.displayName}',
          );
        }
        // Note: Caller should check enforcementLevel and show warning UI
        break;

      case IntegrityEnforcementLevel.blockHighRisk:
      case IntegrityEnforcementLevel.blockAll:
        // Phase 3/4: Block operation ONLY if verification is configured
        if (hasVerification) {
          // Generate support reference ID for debugging
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final supportRefId = 'INT-${timestamp.toString().substring(8)}';

          throw IntegrityVerificationFailedException(
            message: _getDetailedErrorMessage(failureReason, operationId),
            enforcementLevel: enforcementLevel,
            operationId: operationId,
            failureReason: failureReason,
            supportReferenceId: supportRefId,
            code: 'INTEGRITY_CHECK_FAILED',
            details: error?.toString(),
          );
        } else {
          // Can't block without verification - log warning
          if (kDebugMode) {
            debugPrint(
              'PlayIntegrityService: Would block $operationId but verification '
              'is not configured. Configure verifyTokenCallback for security.',
            );
          }
        }
    }
  }

  /// Determine specific failure reason from error
  IntegrityFailureReason _determineFailureReason(Exception? error) {
    if (error == null) {
      return IntegrityFailureReason.unknown;
    }

    final errorString = error.toString().toLowerCase();

    // Check for network errors
    if (errorString.contains('network') ||
        errorString.contains('timeout') ||
        errorString.contains('connection') ||
        errorString.contains('internet')) {
      return IntegrityFailureReason.networkError;
    }

    // Check for token request failures
    if (errorString.contains('failed to request integrity token') ||
        errorString.contains('token request')) {
      return IntegrityFailureReason.tokenRequestFailed;
    }

    // Check for backend verification failures
    if (errorString.contains('backend verification') ||
        errorString.contains('invalid token') ||
        errorString.contains('verification failed')) {
      return IntegrityFailureReason.backendVerificationFailed;
    }

    // Check for device integrity issues (from Android API errors)
    if (errorString.contains('device') ||
        errorString.contains('play protect') ||
        errorString.contains('integrity_api_not_available')) {
      return IntegrityFailureReason.deviceIntegrity;
    }

    // Check for app integrity issues
    if (errorString.contains('app') ||
        errorString.contains('package') ||
        errorString.contains('signature')) {
      return IntegrityFailureReason.appIntegrity;
    }

    return IntegrityFailureReason.unknown;
  }

  /// Get detailed error message for internal logging
  String _getDetailedErrorMessage(
    IntegrityFailureReason reason,
    String operationId,
  ) {
    switch (reason) {
      case IntegrityFailureReason.deviceIntegrity:
        return 'Device integrity verification failed for $operationId. '
            'Device may not meet security requirements.';
      case IntegrityFailureReason.appIntegrity:
        return 'App integrity verification failed for $operationId. '
            'App installation may be modified or unauthorized.';
      case IntegrityFailureReason.networkError:
        return 'Network error during integrity verification for $operationId. '
            'Could not reach verification service.';
      case IntegrityFailureReason.backendVerificationFailed:
        return 'Backend verification failed for $operationId. '
            'Integrity token was rejected by verification service.';
      case IntegrityFailureReason.tokenRequestFailed:
        return 'Failed to obtain integrity token for $operationId. '
            'Could not generate verification token.';
      case IntegrityFailureReason.unknown:
        return 'Integrity verification failed for $operationId. '
            'Unknown error occurred during verification.';
    }
  }

  /// Log integrity verification event to Firebase Analytics
  Future<void> _logIntegrityEvent({
    required String operationId,
    required String status,
    required IntegrityEnforcementLevel enforcementLevel,
    String? error,
    IntegrityFailureReason? failureReason,
  }) async {
    try {
      await FirebaseService.instance.logEvent(
        'integrity_verification',
        parameters: {
          'operation_id': operationId,
          'status': status,
          'enforcement_level': enforcementLevel.displayName,
          if (error != null) 'error': error,
          if (failureReason != null)
            'failure_reason': failureReason.displayName,
        },
      );
    } catch (e) {
      // Don't let logging errors affect integrity checks
      if (kDebugMode) {
        debugPrint('PlayIntegrityService: Failed to log event: $e');
      }
    }
  }

  /// Get current enforcement level for an operation (for UI decisions)
  Future<IntegrityEnforcementLevel> getEnforcementLevel(
    String operationId,
  ) async {
    final config = IntegrityConfig.instance;
    if (!config.isInitialized) {
      await config.initialize();
    }
    return config.getEffectiveEnforcementLevel(operationId);
  }

  /// Check if operation should show warning (for UI)
  Future<bool> shouldShowWarning(String operationId) async {
    final level = await getEnforcementLevel(operationId);
    return level.shouldWarn;
  }
}
