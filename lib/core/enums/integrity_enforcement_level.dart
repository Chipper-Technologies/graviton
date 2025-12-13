/// Enforcement levels for Play Integrity API verification.
///
/// Defines the action taken when device integrity verification fails.
/// This allows for a phased rollout strategy from monitoring to full enforcement.
enum IntegrityEnforcementLevel {
  /// Log failures only - no user impact (Phase 1: Monitoring)
  ///
  /// Use this during initial rollout to:
  /// - Gather baseline metrics
  /// - Identify false positive rates
  /// - Monitor integration health
  /// - Build confidence in verification accuracy
  ///
  /// Action: Log failure to analytics, proceed with operation
  logOnly,

  /// Show warning to user but allow operation (Phase 2: Soft Warning)
  ///
  /// Use this to:
  /// - Alert users about potential security issues
  /// - Educate users on app integrity requirements
  /// - Test user-facing warning UI
  /// - Gather user feedback on warning messaging
  ///
  /// Action: Log failure, show warning dialog, proceed with operation
  warnUser,

  /// Block high-risk operations only (Phase 3: Selective Enforcement)
  ///
  /// Use this to:
  /// - Protect critical operations (money, data exports)
  /// - Allow basic functionality to continue
  /// - Minimize impact on legitimate users
  /// - Test enforcement mechanisms gradually
  ///
  /// Action: Block high-risk operations, allow low-risk operations
  blockHighRisk,

  /// Block all operations (Phase 4: Full Enforcement)
  ///
  /// Use this after:
  /// - Successful monitoring period (Phase 1)
  /// - Low false positive rate confirmed
  /// - User warning period completed (Phase 2)
  /// - High-risk enforcement validated (Phase 3)
  ///
  /// Action: Block all operations requiring integrity verification
  blockAll,
}

/// Extension methods for IntegrityEnforcementLevel
extension IntegrityEnforcementLevelExtension on IntegrityEnforcementLevel {
  /// Display name for analytics and logging
  String get displayName {
    switch (this) {
      case IntegrityEnforcementLevel.logOnly:
        return 'log_only';
      case IntegrityEnforcementLevel.warnUser:
        return 'warn_user';
      case IntegrityEnforcementLevel.blockHighRisk:
        return 'block_high_risk';
      case IntegrityEnforcementLevel.blockAll:
        return 'block_all';
    }
  }

  /// Whether this level should block the operation
  bool get shouldBlock {
    return this == IntegrityEnforcementLevel.blockHighRisk ||
        this == IntegrityEnforcementLevel.blockAll;
  }

  /// Whether this level should show warning to user
  bool get shouldWarn {
    return this == IntegrityEnforcementLevel.warnUser ||
        this == IntegrityEnforcementLevel.blockHighRisk ||
        this == IntegrityEnforcementLevel.blockAll;
  }

  /// Parse enforcement level from string (for Remote Config)
  static IntegrityEnforcementLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'log_only':
      case 'logonly':
        return IntegrityEnforcementLevel.logOnly;
      case 'warn_user':
      case 'warnuser':
        return IntegrityEnforcementLevel.warnUser;
      case 'block_high_risk':
      case 'blockhighrisk':
        return IntegrityEnforcementLevel.blockHighRisk;
      case 'block_all':
      case 'blockall':
        return IntegrityEnforcementLevel.blockAll;
      default:
        return IntegrityEnforcementLevel.logOnly; // Safe default
    }
  }
}
