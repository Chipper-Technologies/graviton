import 'package:graviton/enums/integrity_enforcement_level.dart';
import 'package:graviton/enums/integrity_failure_reason.dart';

/// Base exception for Play Integrity API failures.
class PlayIntegrityException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  PlayIntegrityException(this.message, {this.code, this.details});

  @override
  String toString() {
    if (code != null) {
      return 'PlayIntegrityException: [$code] $message';
    }
    return 'PlayIntegrityException: $message';
  }
}

/// Exception thrown when integrity verification fails and enforcement is enabled.
///
/// This exception indicates that the device or app failed integrity checks
/// and the current enforcement level requires blocking the operation.
///
/// The exception includes:
/// - Specific failure reason for targeted user guidance
/// - Operation ID for support debugging
/// - Enforcement level that triggered the block
/// - Optional support reference ID for backend correlation
class IntegrityVerificationFailedException extends PlayIntegrityException {
  final IntegrityEnforcementLevel enforcementLevel;
  final String operationId;
  final IntegrityFailureReason failureReason;
  final String? supportReferenceId;

  IntegrityVerificationFailedException({
    required String message,
    required this.enforcementLevel,
    required this.operationId,
    IntegrityFailureReason? failureReason,
    this.supportReferenceId,
    String? code,
    dynamic details,
  }) : failureReason =
           failureReason ??
           IntegrityFailureReasonExtension.fromError(code, message),
       super(message, code: code, details: details);

  /// Get user-friendly error title localization key
  String get titleKey => failureReason.titleKey;

  /// Get user-friendly error message localization key
  String get messageKey => failureReason.localizationKey;

  /// Get user action guidance localization key
  String get guidanceKey => failureReason.guidanceKey;

  /// Get support reference for debugging (includes operation ID)
  String get supportReference =>
      supportReferenceId ?? 'OP-${operationId.toUpperCase()}';

  /// Check if this is a high-risk operation that was blocked
  bool get isHighRiskOperation =>
      enforcementLevel == IntegrityEnforcementLevel.blockHighRisk ||
      enforcementLevel == IntegrityEnforcementLevel.blockAll;

  @override
  String toString() {
    return 'IntegrityVerificationFailedException: '
        '[${enforcementLevel.displayName}] '
        'Operation: $operationId '
        'Reason: ${failureReason.displayName} '
        'Reference: $supportReference - '
        '$message';
  }
}

/// Exception thrown when Play Integrity API is not available.
class IntegrityNotAvailableException extends PlayIntegrityException {
  IntegrityNotAvailableException({
    String? message,
    String? code,
    dynamic details,
  }) : super(
         message ?? 'Play Integrity API is not available on this platform',
         code: code,
         details: details,
       );
}

/// Exception thrown when integrity token request fails.
class IntegrityTokenRequestException extends PlayIntegrityException {
  IntegrityTokenRequestException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message, code: code, details: details);
}
