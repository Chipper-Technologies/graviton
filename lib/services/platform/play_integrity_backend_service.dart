import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/models/security/play_integrity_verification_result.dart';
import 'package:http/http.dart' as http;

/// Service for verifying Play Integrity tokens with the backend
///
/// This service manages token verification with caching to avoid unnecessary
/// backend calls. Tokens are cached with expiration based on the response.
class PlayIntegrityBackendService {
  static PlayIntegrityBackendService? _instance;
  static PlayIntegrityBackendService get instance =>
      _instance ??= PlayIntegrityBackendService._();

  PlayIntegrityBackendService._();

  /// Cached verification results keyed by token
  final Map<String, _CachedVerification> _cache = {};

  /// Default token validity duration (5 minutes)
  static const Duration _defaultTokenValidity = Duration(minutes: 5);

  /// Verify a Play Integrity token with the backend
  ///
  /// Returns true if the token is valid and meets security requirements.
  /// Uses cached result if available and not expired.
  ///
  /// [token] - The Play Integrity token to verify
  /// [packageName] - The Android package name (use AppConstants.packageNameProd or AppConstants.packageNameDev)
  /// [forceRefresh] - Skip cache and force new verification
  Future<bool> verifyToken({
    required String token,
    required String packageName,
    bool forceRefresh = false,
  }) async {
    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cached = _cache[token];
      if (cached != null && !cached.isExpired) {
        if (kDebugMode) {
          debugPrint(
            'PlayIntegrityBackendService: Using cached verification result',
          );
        }
        return cached.isValid;
      }
    }

    try {
      final result = await verifyTokenDetailed(
        token: token,
        packageName: packageName,
      );

      // Cache the result
      _cacheVerification(token, result.isValid);

      return result.isValid;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('PlayIntegrityBackendService: Verification failed: $e');
      }
      // Don't cache failures - they should be retried
      return false;
    }
  }

  /// Verify a Play Integrity token and get detailed results
  ///
  /// Returns a [PlayIntegrityVerificationResult] with full details about
  /// the verification including verdicts for device, app, and account integrity.
  Future<PlayIntegrityVerificationResult> verifyTokenDetailed({
    required String token,
    required String packageName,
  }) async {
    final url = Uri.parse(AppConfig.playIntegrityVerificationUrl);

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'token': token, 'packageName': packageName}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Verification request timed out'),
          );

      if (response.statusCode != 200) {
        throw Exception(
          'Verification failed with status ${response.statusCode}: ${response.body}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] != true) {
        throw Exception(
          'Verification failed: ${data['error'] ?? 'Unknown error'}',
        );
      }

      return PlayIntegrityVerificationResult.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('PlayIntegrityBackendService: Error verifying token: $e');
      }
      rethrow;
    }
  }

  /// Cache a verification result
  void _cacheVerification(String token, bool isValid) {
    _cache[token] = _CachedVerification(
      isValid: isValid,
      timestamp: DateTime.now(),
      expiresAt: DateTime.now().add(_defaultTokenValidity),
    );

    // Clean up old cache entries (keep last 10)
    if (_cache.length > 10) {
      final sortedEntries = _cache.entries.toList()
        ..sort((a, b) => b.value.timestamp.compareTo(a.value.timestamp));

      _cache.clear();
      for (final entry in sortedEntries.take(10)) {
        _cache[entry.key] = entry.value;
      }
    }
  }

  /// Clear all cached verifications
  void clearCache() {
    _cache.clear();
  }

  /// Get the number of cached verifications
  int get cacheSize => _cache.length;
}

/// Internal class for caching verification results
class _CachedVerification {
  final bool isValid;
  final DateTime timestamp;
  final DateTime expiresAt;

  _CachedVerification({
    required this.isValid,
    required this.timestamp,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
