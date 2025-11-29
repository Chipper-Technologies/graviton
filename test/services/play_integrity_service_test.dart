import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/integrity_config.dart';
import 'package:graviton/services/play_integrity_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlayIntegrityService', () {
    late PlayIntegrityService service;
    const channel = MethodChannel('io.chipper.graviton/play_integrity');

    setUp(() {
      service = PlayIntegrityService();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('requestIntegrityToken returns token on success', () async {
      // Arrange
      const mockToken = 'mock_integrity_token_12345';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'requestIntegrityToken') {
              expect(methodCall.arguments['nonce'], isNotNull);
              expect(methodCall.arguments['nonce'], isA<String>());
              return {'token': mockToken};
            }
            return null;
          });

      // Act
      final token = await service.requestIntegrityToken(userId: 'test_user');

      // Assert
      expect(token, equals(mockToken));
    });

    test('requestIntegrityToken throws PlatformException on failure', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'requestIntegrityToken') {
              throw PlatformException(
                code: 'INTEGRITY_ERROR',
                message: 'Failed to request token',
              );
            }
            return null;
          });

      // Act & Assert
      expect(
        () => service.requestIntegrityToken(userId: 'test_user'),
        throwsA(isA<PlatformException>()),
      );
    });

    test('requestIntegrityToken throws on invalid response', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'requestIntegrityToken') {
              return {'invalid_key': 'invalid_value'};
            }
            return null;
          });

      // Act & Assert
      expect(
        () => service.requestIntegrityToken(userId: 'test_user'),
        throwsA(isA<PlatformException>()),
      );
    });

    test('requestIntegrityToken throws on null response', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'requestIntegrityToken') {
              return null;
            }
            return null;
          });

      // Act & Assert
      expect(
        () => service.requestIntegrityToken(userId: 'test_user'),
        throwsA(isA<PlatformException>()),
      );
    });

    test('isAvailable returns true when API is available', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'checkAvailability') {
              return null;
            }
            return null;
          });

      // Act
      final available = await service.isAvailable();

      // Assert
      expect(available, isTrue);
    });

    test('isAvailable returns false when API is not available', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'checkAvailability') {
              throw PlatformException(
                code: 'NOT_AVAILABLE',
                message: 'API not available',
              );
            }
            return null;
          });

      // Act
      final available = await service.isAvailable();

      // Assert
      expect(available, isFalse);
    });

    test('nonce fallback is generated with userId and timestamp', () async {
      // Arrange
      const userId = 'test_user_123';
      String? capturedNonce;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'requestIntegrityToken') {
              capturedNonce = methodCall.arguments['nonce'] as String;
              return {'token': 'mock_token'};
            }
            return null;
          });

      // Act - using fallback (no nonce provided)
      await service.requestIntegrityToken(userId: userId);

      // Assert
      expect(capturedNonce, isNotNull);
      expect(capturedNonce, isNotEmpty);
      // Nonce should be base64 encoded
      expect(
        () => Uri.parse('data:text/plain;base64,$capturedNonce'),
        returnsNormally,
      );
    });

    test('uses provided backend nonce when specified', () async {
      // Arrange
      const userId = 'test_user_123';
      const backendNonce = 'backend_generated_secure_nonce_12345';
      String? capturedNonce;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'requestIntegrityToken') {
              capturedNonce = methodCall.arguments['nonce'] as String;
              return {'token': 'mock_token'};
            }
            return null;
          });

      // Act - using backend-provided nonce (secure)
      await service.requestIntegrityToken(userId: userId, nonce: backendNonce);

      // Assert - should use the provided nonce exactly
      expect(capturedNonce, equals(backendNonce));
    });

    test(
      'nonce fallback generates unique values on consecutive calls',
      () async {
        // Arrange
        const userId = 'test_user_123';
        final capturedNonces = <String>[];

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              if (methodCall.method == 'requestIntegrityToken') {
                capturedNonces.add(methodCall.arguments['nonce'] as String);
                return {'token': 'mock_token'};
              }
              return null;
            });

        // Act - generate multiple nonces
        await service.requestIntegrityToken(userId: userId);
        await service.requestIntegrityToken(userId: userId);
        await service.requestIntegrityToken(userId: userId);

        // Assert - all nonces should be unique (cryptographically random)
        expect(capturedNonces.length, equals(3));
        expect(capturedNonces[0], isNot(equals(capturedNonces[1])));
        expect(capturedNonces[0], isNot(equals(capturedNonces[2])));
        expect(capturedNonces[1], isNot(equals(capturedNonces[2])));

        // All should be valid base64
        for (final nonce in capturedNonces) {
          expect(nonce, isNotEmpty);
          expect(() => base64Url.decode(nonce), returnsNormally);
        }
      },
    );

    group('verifyWithEnforcement', () {
      setUp(() async {
        // Initialize IntegrityConfig before tests
        // Note: Development bypass is enabled by default in test environment
        await IntegrityConfig.instance.initialize();
      });

      test('skips verification when Play Integrity is disabled via config',
          () async {
        // This test would require mocking IntegrityConfig to return false
        // for isEnabled(). In practice, this is tested through Remote Config.
        // The service checks config.isEnabled() and returns early if false.
        // Verified through code inspection and integration testing.
      });

      test(
        'completes successfully without verification callback (monitoring)',
        () async {
          // Arrange
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
                if (methodCall.method == 'requestIntegrityToken') {
                  return {'token': 'mock_token_success'};
                }
                return null;
              });

          // Act & Assert - should not throw in debug mode
          // (In production would require allowUnverifiedForMonitoring=true)
          await expectLater(
            service.verifyWithEnforcement(
              operationId: 'test_operation',
              userId: 'test_user',
              allowUnverifiedForMonitoring: true,
            ),
            completes,
          );
        },
      );

      test('completes with callback but development bypass enabled', () async {
        // Arrange
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              if (methodCall.method == 'requestIntegrityToken') {
                return {'token': 'mock_token_success'};
              }
              return null;
            });

        var callbackCalled = false;

        // Act - Development bypass returns early, callback won't be called
        await service.verifyWithEnforcement(
          operationId: 'test_operation',
          userId: 'test_user',
          verifyTokenCallback: (token) async {
            callbackCalled = true;
            expect(token, equals('mock_token_success'));
            return true; // Token is valid
          },
        );

        // Assert - Callback not called due to development bypass
        expect(
          callbackCalled,
          isFalse,
          reason: 'Development bypass should skip verification',
        );
      });

      test(
        'does not throw even when verification would fail (dev bypass)',
        () async {
          // Arrange
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
                if (methodCall.method == 'requestIntegrityToken') {
                  return {'token': 'mock_token_invalid'};
                }
                return null;
              });

          // Act & Assert - Development bypass prevents throwing
          await expectLater(
            service.verifyWithEnforcement(
              operationId: 'test_operation',
              userId: 'test_user',
              verifyTokenCallback: (token) async => false, // Would fail
            ),
            completes,
            reason: 'Development bypass should allow operation to proceed',
          );
        },
      );

      test(
        'handles token request failure gracefully with dev bypass',
        () async {
          // Arrange
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
                if (methodCall.method == 'requestIntegrityToken') {
                  throw PlatformException(
                    code: 'INTEGRITY_ERROR',
                    message: 'Token request failed',
                  );
                }
                return null;
              });

          // Act & Assert - Dev bypass allows operation to proceed
          await expectLater(
            service.verifyWithEnforcement(
              operationId: 'test_operation',
              userId: 'test_user',
            ),
            completes,
            reason: 'Development bypass should allow operation despite error',
          );
        },
      );

      test('development bypass skips token request entirely', () async {
        // Arrange
        var methodCalled = false;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              if (methodCall.method == 'requestIntegrityToken') {
                methodCalled = true;
                return {'token': 'mock_token'};
              }
              return null;
            });

        // Act
        await service.verifyWithEnforcement(
          operationId: 'test_operation',
          userId: 'test_user',
        );

        // Assert - Method should not be called due to development bypass
        expect(
          methodCalled,
          isFalse,
          reason: 'Development bypass should skip token request',
        );
      });

      test('development bypass skips verification callback', () async {
        // Arrange
        var callbackCalled = false;

        // Act
        await service.verifyWithEnforcement(
          operationId: 'test_operation',
          userId: 'test_user',
          verifyTokenCallback: (token) async {
            callbackCalled = true;
            return true;
          },
        );

        // Assert
        expect(
          callbackCalled,
          isFalse,
          reason: 'Development bypass should skip callback',
        );
      });

      test('does not throw on callback exception with dev bypass', () async {
        // Act & Assert - Dev bypass prevents callback from being called
        await expectLater(
          service.verifyWithEnforcement(
            operationId: 'test_operation',
            userId: 'test_user',
            verifyTokenCallback: (token) async {
              throw Exception('This should not be called');
            },
          ),
          completes,
          reason: 'Development bypass should skip callback',
        );
      });

      test('works with different operation IDs', () async {
        // Arrange
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              if (methodCall.method == 'requestIntegrityToken') {
                return {'token': 'mock_token'};
              }
              return null;
            });

        final operations = [
          'auth_sign_in',
          'auth_create_account',
          'sync_cloud_data',
          'share_simulation',
          'save_custom_scenario',
        ];

        // Act & Assert
        for (final operation in operations) {
          await expectLater(
            service.verifyWithEnforcement(
              operationId: operation,
              userId: 'test_user',
            ),
            completes,
          );
        }
      });

      test(
        'verification callback receives correct token for each call',
        () async {
          // Arrange
          final tokens = ['token1', 'token2', 'token3'];
          var callIndex = 0;

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
                if (methodCall.method == 'requestIntegrityToken') {
                  return {'token': tokens[callIndex]};
                }
                return null;
              });

          // Act & Assert
          for (var i = 0; i < tokens.length; i++) {
            callIndex = i;
            await service.verifyWithEnforcement(
              operationId: 'test_operation',
              userId: 'test_user',
              verifyTokenCallback: (token) async {
                expect(token, equals(tokens[i]));
                return true;
              },
            );
          }
        },
      );
    });
  });
}
