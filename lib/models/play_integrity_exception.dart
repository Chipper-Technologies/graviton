import 'package:graviton/enums/integrity_enforcement_level.dart';

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
class IntegrityVerificationFailedException extends PlayIntegrityException {
  final IntegrityEnforcementLevel enforcementLevel;
  final String operationId;

  IntegrityVerificationFailedException({
    required String message,
    required this.enforcementLevel,
    required this.operationId,
    String? code,
    dynamic details,
  }) : super(message, code: code, details: details);

  @override
  String toString() {
    return 'IntegrityVerificationFailedException: '
        '[${enforcementLevel.displayName}] '
        'Operation: $operationId - $message';
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
