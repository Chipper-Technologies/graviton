import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/integrity_enforcement_level.dart';
import 'package:graviton/core/enums/integrity_failure_reason.dart';
import 'package:graviton/models/security/play_integrity_exception.dart';

void main() {
  group('PlayIntegrityException', () {
    test('toString includes message', () {
      final exception = PlayIntegrityException('Test error');
      expect(exception.toString(), contains('Test error'));
    });

    test('toString includes code when provided', () {
      final exception = PlayIntegrityException('Test error', code: 'TEST_CODE');
      expect(exception.toString(), contains('TEST_CODE'));
      expect(exception.toString(), contains('Test error'));
    });

    test('includes details', () {
      final exception = PlayIntegrityException(
        'Test error',
        details: {'key': 'value'},
      );
      expect(exception.details, equals({'key': 'value'}));
    });
  });

  group('IntegrityVerificationFailedException', () {
    test('toString includes enforcement level', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Verification failed',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'test_operation',
      );
      expect(exception.toString(), contains('block_all'));
    });

    test('toString includes operation ID', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Verification failed',
        enforcementLevel: IntegrityEnforcementLevel.blockHighRisk,
        operationId: 'auth_sign_in',
      );
      expect(exception.toString(), contains('auth_sign_in'));
    });

    test('includes all properties', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.warnUser,
        operationId: 'test_op',
        code: 'FAIL_CODE',
        details: 'Extra details',
      );
      expect(exception.message, equals('Test failure'));
      expect(
        exception.enforcementLevel,
        equals(IntegrityEnforcementLevel.warnUser),
      );
      expect(exception.operationId, equals('test_op'));
      expect(exception.code, equals('FAIL_CODE'));
      expect(exception.details, equals('Extra details'));
    });

    test('auto-detects failure reason from error message', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Network connection failed',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'test_op',
      );
      expect(
        exception.failureReason,
        equals(IntegrityFailureReason.networkError),
      );
    });

    test('uses explicit failure reason when provided', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'test_op',
        failureReason: IntegrityFailureReason.deviceIntegrity,
      );
      expect(
        exception.failureReason,
        equals(IntegrityFailureReason.deviceIntegrity),
      );
    });

    test('provides localization keys for user-facing messages', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'test_op',
        failureReason: IntegrityFailureReason.appIntegrity,
      );
      expect(exception.titleKey, equals('integrityErrorAppIntegrityTitle'));
      expect(exception.messageKey, equals('integrityErrorAppIntegrity'));
      expect(exception.guidanceKey, equals('integrityGuidanceAppIntegrity'));
    });

    test('generates support reference from operation ID', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'auth_sign_in',
      );
      expect(exception.supportReference, equals('OP-AUTH_SIGN_IN'));
    });

    test('uses custom support reference when provided', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'test_op',
        supportReferenceId: 'INT-12345',
      );
      expect(exception.supportReference, equals('INT-12345'));
    });

    test('identifies high-risk operations correctly', () {
      final highRiskException = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.blockHighRisk,
        operationId: 'test_op',
      );
      expect(highRiskException.isHighRiskOperation, isTrue);

      final blockAllException = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'test_op',
      );
      expect(blockAllException.isHighRiskOperation, isTrue);

      final warnException = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.warnUser,
        operationId: 'test_op',
      );
      expect(warnException.isHighRiskOperation, isFalse);
    });

    test('toString includes failure reason and support reference', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Device security check failed',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'auth_sign_in',
        failureReason: IntegrityFailureReason.deviceIntegrity,
        supportReferenceId: 'INT-54321',
      );
      final exceptionString = exception.toString();
      expect(exceptionString, contains('device_integrity'));
      expect(exceptionString, contains('INT-54321'));
      expect(exceptionString, contains('auth_sign_in'));
    });
  });

  group('IntegrityNotAvailableException', () {
    test('has default message', () {
      final exception = IntegrityNotAvailableException();
      expect(
        exception.message,
        equals('Play Integrity API is not available on this platform'),
      );
    });

    test('can override message', () {
      final exception = IntegrityNotAvailableException(
        message: 'Custom unavailable message',
      );
      expect(exception.message, equals('Custom unavailable message'));
    });

    test('includes code and details', () {
      final exception = IntegrityNotAvailableException(
        code: 'NOT_AVAILABLE',
        details: 'iOS platform',
      );
      expect(exception.code, equals('NOT_AVAILABLE'));
      expect(exception.details, equals('iOS platform'));
    });
  });

  group('IntegrityTokenRequestException', () {
    test('includes message', () {
      final exception = IntegrityTokenRequestException(
        message: 'Token request failed',
      );
      expect(exception.message, equals('Token request failed'));
    });

    test('includes code and details', () {
      final exception = IntegrityTokenRequestException(
        message: 'Request error',
        code: 'NETWORK_ERROR',
        details: 'Connection timeout',
      );
      expect(exception.code, equals('NETWORK_ERROR'));
      expect(exception.details, equals('Connection timeout'));
    });
  });
}
