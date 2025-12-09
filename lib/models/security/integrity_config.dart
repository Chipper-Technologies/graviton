import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:graviton/core/enums/integrity_enforcement_level.dart';

/// Configuration for Play Integrity API enforcement.
///
/// This class manages enforcement levels and operation-specific risk
/// classifications using Firebase Remote Config for dynamic updates.
///
/// ## Global Enable/Disable
/// The [isEnabled] method checks the `integrity_enabled` Remote Config
/// parameter to provide an emergency kill-switch for all Play Integrity checks.
/// This defaults to `true` for security but can be toggled via Firebase Console
/// for quick rollback if issues arise in production without requiring an app update.
class IntegrityConfig {
  static IntegrityConfig? _instance;
  static IntegrityConfig get instance => _instance ??= IntegrityConfig._();

  IntegrityConfig._();

  FirebaseRemoteConfig? _remoteConfig;
  bool _isInitialized = false;

  // ============================================================================
  // Default Configuration (Safe Defaults)
  // ============================================================================

  /// Default enforcement level (log only for safety)
  static const IntegrityEnforcementLevel _defaultEnforcementLevel =
      IntegrityEnforcementLevel.logOnly;

  /// Default high-risk operations (all critical operations)
  static const Set<String> _defaultHighRiskOperations = {
    'auth_create_account',
    'auth_sign_in',
    'sync_cloud_data',
    'share_simulation',
    'save_custom_scenario',
    'delete_account',
    'export_user_data',
  };

  // ============================================================================
  // Remote Config Keys
  // ============================================================================

  static const String _keyEnforcementLevel = 'integrity_enforcement_level';
  static const String _keyHighRiskOperations = 'integrity_high_risk_operations';
  static const String _keyBypassForDevelopment = 'integrity_bypass_development';
  static const String _keyEnabled = 'integrity_enabled';

  // ============================================================================
  // Initialization
  // ============================================================================

  /// Initialize integrity configuration from Firebase Remote Config
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Set defaults using constant values
      await _remoteConfig!.setDefaults({
        _keyEnforcementLevel: _defaultEnforcementLevel.displayName,
        _keyHighRiskOperations: _defaultHighRiskOperations.join(','),
        _keyBypassForDevelopment: 'true',
        _keyEnabled: 'true', // Enabled by default
      });

      // Configure settings for frequent updates during rollout
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 5),
        ),
      );

      // Fetch and activate
      await _remoteConfig!.fetchAndActivate();

      _isInitialized = true;

      debugPrint(
        'IntegrityConfig: Initialized with enforcement level: ${getEnforcementLevel().displayName}',
      );
    } catch (e) {
      debugPrint('IntegrityConfig: Initialization failed: $e');
      _isInitialized = false;
      // Continue with defaults if Remote Config fails
    }
  }

  /// Check if configuration is initialized
  bool get isInitialized => _isInitialized;

  // ============================================================================
  // Configuration Getters
  // ============================================================================

  /// Get current enforcement level
  IntegrityEnforcementLevel getEnforcementLevel() {
    if (_remoteConfig == null) return _defaultEnforcementLevel;

    try {
      final value = _remoteConfig!.getString(_keyEnforcementLevel);
      return IntegrityEnforcementLevelExtension.fromString(value);
    } catch (e) {
      debugPrint('IntegrityConfig: Error reading enforcement level: $e');
      return _defaultEnforcementLevel;
    }
  }

  /// Get set of high-risk operations
  Set<String> getHighRiskOperations() {
    if (_remoteConfig == null) return _defaultHighRiskOperations;

    try {
      final value = _remoteConfig!.getString(_keyHighRiskOperations);
      if (value.isEmpty) return _defaultHighRiskOperations;

      return value.split(',').map((s) => s.trim()).toSet();
    } catch (e) {
      debugPrint('IntegrityConfig: Error reading high-risk operations: $e');
      return _defaultHighRiskOperations;
    }
  }

  /// Check if development bypass is enabled
  bool isDevelopmentBypassEnabled() {
    if (_remoteConfig == null) return true; // Safe default for development

    try {
      return _remoteConfig!.getBool(_keyBypassForDevelopment);
    } catch (e) {
      debugPrint('IntegrityConfig: Error reading development bypass: $e');
      return true; // Safe default
    }
  }

  /// Check if Play Integrity checks are globally enabled
  ///
  /// This allows disabling all Play Integrity checks via Remote Config.
  /// Enabled by default for security.
  bool isEnabled() {
    if (_remoteConfig == null) return true; // Enabled by default

    try {
      return _remoteConfig!.getBool(_keyEnabled);
    } catch (e) {
      debugPrint('IntegrityConfig: Error reading enabled flag: $e');
      return true; // Safe default (enabled)
    }
  }

  // ============================================================================
  // Risk Assessment
  // ============================================================================

  /// Check if an operation is considered high-risk
  bool isHighRiskOperation(String operationId) {
    return getHighRiskOperations().contains(operationId);
  }

  /// Determine effective enforcement level for an operation
  IntegrityEnforcementLevel getEffectiveEnforcementLevel(String operationId) {
    final globalLevel = getEnforcementLevel();

    // If global level is blockAll, apply to all operations
    if (globalLevel == IntegrityEnforcementLevel.blockAll) {
      return IntegrityEnforcementLevel.blockAll;
    }

    // If global level is blockHighRisk, check operation risk
    if (globalLevel == IntegrityEnforcementLevel.blockHighRisk) {
      return isHighRiskOperation(operationId)
          ? IntegrityEnforcementLevel.blockHighRisk
          : IntegrityEnforcementLevel.warnUser; // Warn for low-risk
    }

    // Otherwise use global level
    return globalLevel;
  }

  /// Check if operation should be blocked
  bool shouldBlockOperation(String operationId) {
    final level = getEffectiveEnforcementLevel(operationId);
    return level.shouldBlock;
  }

  /// Check if operation should show warning
  bool shouldWarnForOperation(String operationId) {
    final level = getEffectiveEnforcementLevel(operationId);
    return level.shouldWarn;
  }

  // ============================================================================
  // Manual Refresh
  // ============================================================================

  /// Manually refresh configuration from Remote Config
  Future<void> refresh() async {
    if (_remoteConfig == null) return;

    try {
      await _remoteConfig!.fetchAndActivate();
      debugPrint(
        'IntegrityConfig: Refreshed - enforcement level: ${getEnforcementLevel().displayName}',
      );
    } catch (e) {
      debugPrint('IntegrityConfig: Refresh failed: $e');
    }
  }
}
