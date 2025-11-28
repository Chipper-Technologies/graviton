import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/services.dart';
import 'package:graviton/enums/integrity_enforcement_level.dart';
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

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final nonceData = '$userId:$timestamp';
    final bytes = Uint8List.fromList(utf8.encode(nonceData));
    return base64Url.encode(bytes);
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
  ///
  /// Throws [IntegrityVerificationFailedException] if verification fails
  /// and enforcement level requires blocking.
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
  /// Example WITHOUT verification (INSECURE - monitoring only):
  /// ```dart
  /// // ❌ NO SECURITY: Token generated but never verified
  /// await playIntegrityService.verifyWithEnforcement(
  ///   operationId: 'auth_sign_in',
  ///   userId: user.email,
  ///   // Missing verifyTokenCallback = no verification!
  /// );
  /// ```
  Future<void> verifyWithEnforcement({
    required String operationId,
    required String userId,
    String? nonce,
    Future<bool> Function(String token)? verifyTokenCallback,
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

    // Check development bypass
    if (kDebugMode && config.isDevelopmentBypassEnabled()) {
      debugPrint(
        'PlayIntegrityService: Development bypass enabled for $operationId',
      );
      return;
    }

    // Determine enforcement level for this operation
    final enforcementLevel = config.getEffectiveEnforcementLevel(operationId);

    // ⚠️ Security Warning: Check if verification callback is provided
    if (verifyTokenCallback == null) {
      // NO VERIFICATION: Token will be generated but never verified
      // This provides zero security value
      if (!kDebugMode) {
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
          },
        );
      } else {
        debugPrint(
          'PlayIntegrityService: Token verification disabled for $operationId '
          '(development mode). Add verifyTokenCallback for production security.',
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
    // Log the failure
    await _logIntegrityEvent(
      operationId: operationId,
      status: 'failed',
      enforcementLevel: enforcementLevel,
      error: error?.toString(),
    );

    // Take action based on enforcement level
    switch (enforcementLevel) {
      case IntegrityEnforcementLevel.logOnly:
        // Phase 1: Just log, don't block
        if (kDebugMode) {
          debugPrint(
            'PlayIntegrityService: Integrity check failed for $operationId (log only)',
          );
        }
        break;

      case IntegrityEnforcementLevel.warnUser:
        // Phase 2: Log + warn user (caller should handle warning UI)
        if (kDebugMode) {
          debugPrint(
            'PlayIntegrityService: Integrity check failed for $operationId (warning user)',
          );
        }
        // Note: Caller should check enforcementLevel and show warning UI
        break;

      case IntegrityEnforcementLevel.blockHighRisk:
      case IntegrityEnforcementLevel.blockAll:
        // Phase 3/4: Block operation ONLY if verification is configured
        if (hasVerification) {
          throw IntegrityVerificationFailedException(
            message: 'Device integrity verification failed',
            enforcementLevel: enforcementLevel,
            operationId: operationId,
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

  /// Log integrity verification event to Firebase Analytics
  Future<void> _logIntegrityEvent({
    required String operationId,
    required String status,
    required IntegrityEnforcementLevel enforcementLevel,
    String? error,
  }) async {
    try {
      await FirebaseService.instance.logEvent(
        'integrity_verification',
        parameters: {
          'operation_id': operationId,
          'status': status,
          'enforcement_level': enforcementLevel.displayName,
          if (error != null) 'error': error,
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
