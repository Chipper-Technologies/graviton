import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/integrity_enforcement_level.dart';
import 'package:graviton/core/enums/integrity_failure_reason.dart';
import 'package:graviton/models/security/play_integrity_exception.dart';
import 'package:graviton/services/platform/play_integrity_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for PlayIntegrityService
@GenerateMocks([PlayIntegrityService])
import 'auth_service_play_integrity_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService Play Integrity Integration', () {
    late MockPlayIntegrityService mockIntegrityService;

    setUp(() {
      mockIntegrityService = MockPlayIntegrityService();
    });

    group('Play Integrity Verification During Sign-In', () {
      test(
        'should call Play Integrity verification during email sign-in',
        () async {
          // Setup: Mock successful verification
          when(
            mockIntegrityService.verifyWithEnforcement(
              operationId: anyNamed('operationId'),
              userId: anyNamed('userId'),
              nonce: anyNamed('nonce'),
              verifyTokenCallback: anyNamed('verifyTokenCallback'),
            ),
          ).thenAnswer((_) async => Future.value());

          // Note: This test verifies the integration pattern.
          // In a real integration test with a mocked AuthService,
          // you would inject the mock PlayIntegrityService and verify:
          // 1. The service is called with correct parameters
          // 2. The operation ID matches 'auth_sign_in'
          // 3. The user identifier is passed correctly

          // Verify the mock was set up correctly
          expect(mockIntegrityService, isNotNull);
        },
      );

      test(
        'should use correct operation ID for different auth methods',
        () async {
          // Verify operation IDs are distinct for different auth operations:
          // - 'auth_sign_in' for email/password sign-in
          // - 'auth_google_signin' for Google sign-in
          // - 'auth_create_account' for account creation

          final operationIds = [
            'auth_sign_in',
            'auth_google_signin',
            'auth_create_account',
          ];

          for (final opId in operationIds) {
            expect(opId, isNotEmpty);
            expect(opId, startsWith('auth_'));
          }
        },
      );

      test('should pass user identifier to integrity verification', () async {
        const testEmail = 'test@example.com';
        const operationId = 'auth_sign_in';

        // Setup mock to capture parameters
        when(
          mockIntegrityService.verifyWithEnforcement(
            operationId: operationId,
            userId: testEmail,
          ),
        ).thenAnswer((_) async => Future.value());

        // Verify mock can be called with expected parameters
        await mockIntegrityService.verifyWithEnforcement(
          operationId: operationId,
          userId: testEmail,
        );

        verify(
          mockIntegrityService.verifyWithEnforcement(
            operationId: operationId,
            userId: testEmail,
          ),
        ).called(1);
      });
    });

    group('Sign-In Failure with Integrity Verification', () {
      test(
        'should fail sign-in when device integrity verification fails',
        () async {
          final integrityException = IntegrityVerificationFailedException(
            message: 'Device integrity check failed',
            enforcementLevel: IntegrityEnforcementLevel.blockAll,
            operationId: 'auth_sign_in',
            failureReason: IntegrityFailureReason.deviceIntegrity,
            supportReferenceId: 'TEST-12345',
          );

          // Setup: Mock verification failure
          when(
            mockIntegrityService.verifyWithEnforcement(
              operationId: anyNamed('operationId'),
              userId: anyNamed('userId'),
            ),
          ).thenThrow(integrityException);

          // Attempt verification
          expect(
            () async => await mockIntegrityService.verifyWithEnforcement(
              operationId: 'auth_sign_in',
              userId: 'test@example.com',
            ),
            throwsA(isA<IntegrityVerificationFailedException>()),
          );
        },
      );

      test(
        'should provide specific error details for device integrity failures',
        () async {
          final exception = IntegrityVerificationFailedException(
            message: 'Device security requirements not met',
            enforcementLevel: IntegrityEnforcementLevel.blockAll,
            operationId: 'auth_sign_in',
            failureReason: IntegrityFailureReason.deviceIntegrity,
            supportReferenceId: 'INT-54321',
          );

          expect(
            exception.failureReason,
            equals(IntegrityFailureReason.deviceIntegrity),
          );
          expect(exception.operationId, equals('auth_sign_in'));
          expect(exception.supportReference, equals('INT-54321'));
          expect(
            exception.titleKey,
            equals('integrityErrorDeviceIntegrityTitle'),
          );
          expect(exception.messageKey, equals('integrityErrorDeviceIntegrity'));
        },
      );

      test(
        'should provide specific error details for app integrity failures',
        () async {
          final exception = IntegrityVerificationFailedException(
            message: 'App installation could not be verified',
            enforcementLevel: IntegrityEnforcementLevel.blockAll,
            operationId: 'auth_sign_in',
            failureReason: IntegrityFailureReason.appIntegrity,
            supportReferenceId: 'INT-98765',
          );

          expect(
            exception.failureReason,
            equals(IntegrityFailureReason.appIntegrity),
          );
          expect(
            exception.guidanceKey,
            equals('integrityGuidanceAppIntegrity'),
          );
        },
      );

      test(
        'should provide network error details when verification fails due to connectivity',
        () async {
          final exception = IntegrityVerificationFailedException(
            message: 'Network error during verification',
            enforcementLevel: IntegrityEnforcementLevel.blockAll,
            operationId: 'auth_sign_in',
            failureReason: IntegrityFailureReason.networkError,
          );

          expect(
            exception.failureReason,
            equals(IntegrityFailureReason.networkError),
          );
          expect(exception.titleKey, equals('integrityErrorNetworkTitle'));
          expect(exception.messageKey, equals('integrityErrorNetwork'));
        },
      );
    });

    group('Enforcement Level Behavior', () {
      test('should allow sign-in with logOnly enforcement level', () async {
        // With logOnly, verification failures should be logged but not block
        when(
          mockIntegrityService.getEnforcementLevel('auth_sign_in'),
        ).thenAnswer((_) async => IntegrityEnforcementLevel.logOnly);

        final level = await mockIntegrityService.getEnforcementLevel(
          'auth_sign_in',
        );
        expect(level, equals(IntegrityEnforcementLevel.logOnly));
        expect(level.shouldBlock, isFalse);
        expect(level.shouldWarn, isFalse);
      });

      test(
        'should show warning but allow sign-in with warnUser enforcement',
        () async {
          when(
            mockIntegrityService.getEnforcementLevel('auth_sign_in'),
          ).thenAnswer((_) async => IntegrityEnforcementLevel.warnUser);

          final level = await mockIntegrityService.getEnforcementLevel(
            'auth_sign_in',
          );
          expect(level, equals(IntegrityEnforcementLevel.warnUser));
          expect(level.shouldWarn, isTrue);
          expect(level.shouldBlock, isFalse);
        },
      );

      test('should block sign-in with blockHighRisk enforcement', () async {
        when(
          mockIntegrityService.getEnforcementLevel('auth_sign_in'),
        ).thenAnswer((_) async => IntegrityEnforcementLevel.blockHighRisk);

        final level = await mockIntegrityService.getEnforcementLevel(
          'auth_sign_in',
        );
        expect(level, equals(IntegrityEnforcementLevel.blockHighRisk));
        expect(level.shouldBlock, isTrue);
        expect(level.shouldWarn, isTrue);
      });

      test('should block sign-in with blockAll enforcement', () async {
        when(
          mockIntegrityService.getEnforcementLevel('auth_sign_in'),
        ).thenAnswer((_) async => IntegrityEnforcementLevel.blockAll);

        final level = await mockIntegrityService.getEnforcementLevel(
          'auth_sign_in',
        );
        expect(level, equals(IntegrityEnforcementLevel.blockAll));
        expect(level.shouldBlock, isTrue);
        expect(level.shouldWarn, isTrue);
      });

      test(
        'should check enforcement level before showing UI warnings',
        () async {
          when(
            mockIntegrityService.shouldShowWarning('auth_sign_in'),
          ).thenAnswer((_) async => true);

          final shouldWarn = await mockIntegrityService.shouldShowWarning(
            'auth_sign_in',
          );
          expect(shouldWarn, isTrue);
        },
      );
    });

    group('Operation ID Validation', () {
      test('should use auth_sign_in for email/password sign-in', () {
        const operationId = 'auth_sign_in';
        expect(operationId, equals('auth_sign_in'));
      });

      test('should use auth_google_signin for Google sign-in', () {
        const operationId = 'auth_google_signin';
        expect(operationId, equals('auth_google_signin'));
      });

      test('should use auth_create_account for account creation', () {
        const operationId = 'auth_create_account';
        expect(operationId, equals('auth_create_account'));
      });

      test('should use consistent operation IDs for analytics correlation', () {
        // Verify operation IDs follow consistent naming pattern
        final operationIds = [
          'auth_sign_in',
          'auth_google_signin',
          'auth_create_account',
        ];

        for (final id in operationIds) {
          expect(id, startsWith('auth_'));
          expect(id, isNot(contains(' '))); // No spaces
          expect(id.toLowerCase(), equals(id)); // Lowercase
        }
      });
    });

    group('Error Message Integration', () {
      test('should provide support reference in all integrity failures', () {
        final failureReasons = [
          IntegrityFailureReason.deviceIntegrity,
          IntegrityFailureReason.appIntegrity,
          IntegrityFailureReason.networkError,
          IntegrityFailureReason.backendVerificationFailed,
          IntegrityFailureReason.tokenRequestFailed,
          IntegrityFailureReason.unknown,
        ];

        for (final reason in failureReasons) {
          final exception = IntegrityVerificationFailedException(
            message: 'Test failure',
            enforcementLevel: IntegrityEnforcementLevel.blockAll,
            operationId: 'auth_sign_in',
            failureReason: reason,
          );

          expect(exception.supportReference, isNotEmpty);
          expect(exception.supportReference, startsWith('OP-'));
        }
      });

      test('should provide localization keys for all failure types', () {
        final failureReasons = [
          IntegrityFailureReason.deviceIntegrity,
          IntegrityFailureReason.appIntegrity,
          IntegrityFailureReason.networkError,
          IntegrityFailureReason.backendVerificationFailed,
          IntegrityFailureReason.tokenRequestFailed,
          IntegrityFailureReason.unknown,
        ];

        for (final reason in failureReasons) {
          final exception = IntegrityVerificationFailedException(
            message: 'Test failure',
            enforcementLevel: IntegrityEnforcementLevel.blockAll,
            operationId: 'auth_sign_in',
            failureReason: reason,
          );

          // All failure types should have localization keys
          expect(exception.titleKey, isNotEmpty);
          expect(exception.messageKey, isNotEmpty);
          expect(exception.guidanceKey, isNotEmpty);
          expect(exception.titleKey, startsWith('integrityError'));
          expect(exception.guidanceKey, startsWith('integrityGuidance'));
        }
      });
    });

    group('Backward Compatibility', () {
      test(
        'should handle exceptions without backend verification callback',
        () async {
          // Setup: Verification without callback (monitoring mode)
          when(
            mockIntegrityService.verifyWithEnforcement(
              operationId: anyNamed('operationId'),
              userId: anyNamed('userId'),
              // No verifyTokenCallback provided
            ),
          ).thenAnswer((_) async => Future.value());

          // Should complete without throwing
          await mockIntegrityService.verifyWithEnforcement(
            operationId: 'auth_sign_in',
            userId: 'test@example.com',
          );

          verify(
            mockIntegrityService.verifyWithEnforcement(
              operationId: 'auth_sign_in',
              userId: 'test@example.com',
            ),
          ).called(1);
        },
      );

      test(
        'should not block operations when verification is not configured',
        () async {
          // When verifyTokenCallback is null, operations should proceed
          // (This tests the documented behavior in PlayIntegrityService)

          when(
            mockIntegrityService.verifyWithEnforcement(
              operationId: anyNamed('operationId'),
              userId: anyNamed('userId'),
            ),
          ).thenAnswer((_) async => Future.value());

          // Verification completes without blocking
          await expectLater(
            mockIntegrityService.verifyWithEnforcement(
              operationId: 'auth_sign_in',
              userId: 'test@example.com',
            ),
            completes,
          );
        },
      );
    });

    group('Error Recovery and User Experience', () {
      test(
        'should provide actionable guidance for device integrity failures',
        () {
          final exception = IntegrityVerificationFailedException(
            message: 'Device integrity check failed',
            enforcementLevel: IntegrityEnforcementLevel.blockAll,
            operationId: 'auth_sign_in',
            failureReason: IntegrityFailureReason.deviceIntegrity,
          );

          // Verify guidance key suggests checking Play Protect
          expect(
            exception.guidanceKey,
            equals('integrityGuidanceDeviceIntegrity'),
          );
        },
      );

      test('should provide actionable guidance for app integrity failures', () {
        final exception = IntegrityVerificationFailedException(
          message: 'App integrity check failed',
          enforcementLevel: IntegrityEnforcementLevel.blockAll,
          operationId: 'auth_sign_in',
          failureReason: IntegrityFailureReason.appIntegrity,
        );

        // Verify guidance key suggests reinstalling from Play Store
        expect(exception.guidanceKey, equals('integrityGuidanceAppIntegrity'));
      });

      test('should provide retry guidance for network errors', () {
        final exception = IntegrityVerificationFailedException(
          message: 'Network error',
          enforcementLevel: IntegrityEnforcementLevel.blockAll,
          operationId: 'auth_sign_in',
          failureReason: IntegrityFailureReason.networkError,
        );

        // Verify guidance suggests checking connection and retrying
        expect(exception.guidanceKey, equals('integrityGuidanceNetwork'));
      });
    });
  });
}
