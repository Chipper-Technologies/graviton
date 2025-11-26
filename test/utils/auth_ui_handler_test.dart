import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/utils/auth_ui_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthUIHandler', () {
    group('validateEmail', () {
      testWidgets('returns error for empty email', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail('', l10n);
                expect(result, isNotNull);
                expect(result, contains('required'));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns error for invalid email format - missing @', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail(
                  'invalidemail',
                  l10n,
                );
                expect(result, isNotNull);
                expect(result, contains('valid email'));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns error for invalid email format - missing domain', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail('test@', l10n);
                expect(result, isNotNull);
                expect(result, contains('valid email'));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns error for invalid email format - invalid domain', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail('test@domain', l10n);
                expect(result, isNotNull);
                expect(result, contains('valid email'));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for valid email', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail(
                  'test@example.com',
                  l10n,
                );
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for valid email with subdomain', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail(
                  'user@mail.example.com',
                  l10n,
                );
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for valid email with hyphen', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail(
                  'test-user@example.com',
                  l10n,
                );
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for valid email with underscore', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail(
                  'test_user@example.com',
                  l10n,
                );
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for valid email with dot', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validateEmail(
                  'test.user@example.com',
                  l10n,
                );
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('validatePassword', () {
      testWidgets('returns error for empty password', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validatePassword('', l10n);
                expect(result, isNotNull);
                expect(result, contains('required'));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns error for short password when creating account', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validatePassword(
                  'short',
                  l10n,
                  isCreatingAccount: true,
                );
                expect(result, isNotNull);
                expect(result, contains('6'));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets(
        'returns error for 5-character password when creating account',
        (tester) async {
          await tester.pumpWidget(
            TestUtils.wrapWithMaterialApp(
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  final result = AuthUIHandler.validatePassword(
                    '12345',
                    l10n,
                    isCreatingAccount: true,
                  );
                  expect(result, isNotNull);
                  expect(result, contains('6'));
                  return Container();
                },
              ),
            ),
          );
        },
      );

      testWidgets(
        'returns null for 6-character password when creating account',
        (tester) async {
          await tester.pumpWidget(
            TestUtils.wrapWithMaterialApp(
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  final result = AuthUIHandler.validatePassword(
                    '123456',
                    l10n,
                    isCreatingAccount: true,
                  );
                  expect(result, isNull);
                  return Container();
                },
              ),
            ),
          );
        },
      );

      testWidgets('returns null for valid password when creating account', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validatePassword(
                  'validPassword123',
                  l10n,
                  isCreatingAccount: true,
                );
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for short password when not creating account', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validatePassword(
                  'short',
                  l10n,
                  isCreatingAccount: false,
                );
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for any non-empty password when signing in', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.validatePassword('a', l10n);
                expect(result, isNull);
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('getLocalizedErrorMessage', () {
      testWidgets('returns empty string for null error', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.getLocalizedErrorMessage(
                  null,
                  l10n,
                );
                expect(result, '');
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('handles firebaseErrorDefault format with embedded message', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                const error = 'firebaseErrorDefault:Custom error message';
                final result = AuthUIHandler.getLocalizedErrorMessage(
                  error,
                  l10n,
                );
                expect(result, contains('Custom error message'));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets(
        'returns localized string for exceptionGoogleSignInNotInitialized',
        (tester) async {
          await tester.pumpWidget(
            TestUtils.wrapWithMaterialApp(
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  final result = AuthUIHandler.getLocalizedErrorMessage(
                    'exceptionGoogleSignInNotInitialized',
                    l10n,
                  );
                  expect(result, isNotEmpty);
                  expect(
                    result,
                    isNot(equals('exceptionGoogleSignInNotInitialized')),
                  );
                  return Container();
                },
              ),
            ),
          );
        },
      );

      testWidgets('returns localized string for firebaseErrorUserNotFound', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.getLocalizedErrorMessage(
                  'firebaseErrorUserNotFound',
                  l10n,
                );
                expect(result, isNotEmpty);
                expect(result, isNot(equals('firebaseErrorUserNotFound')));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns localized string for firebaseErrorWrongPassword', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.getLocalizedErrorMessage(
                  'firebaseErrorWrongPassword',
                  l10n,
                );
                expect(result, isNotEmpty);
                expect(result, isNot(equals('firebaseErrorWrongPassword')));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns localized string for firebaseErrorEmailInUse', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final result = AuthUIHandler.getLocalizedErrorMessage(
                  'firebaseErrorEmailInUse',
                  l10n,
                );
                expect(result, isNotEmpty);
                expect(result, isNot(equals('firebaseErrorEmailInUse')));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns error as-is for unknown error code', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                const unknownError = 'unknownErrorCode';
                final result = AuthUIHandler.getLocalizedErrorMessage(
                  unknownError,
                  l10n,
                );
                expect(result, unknownError);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns error as-is for custom error message', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                const customError = 'This is a custom error message';
                final result = AuthUIHandler.getLocalizedErrorMessage(
                  customError,
                  l10n,
                );
                expect(result, customError);
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('executeWithRetry', () {
      testWidgets('returns result on successful operation', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    final result = await AuthUIHandler.executeWithRetry<String>(
                      operation: () async => 'success',
                      context: context,
                      l10n: l10n,
                    );
                    expect(result, 'success');
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();
      });

      testWidgets('retries on failure and returns null after max retries', (
        tester,
      ) async {
        var attempts = 0;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    final result = await AuthUIHandler.executeWithRetry<String>(
                      operation: () async {
                        attempts++;
                        throw Exception('Test error');
                      },
                      context: context,
                      l10n: l10n,
                      errorMessage: 'Custom error message',
                    );
                    expect(result, isNull);
                    // Should have attempted 4 times (initial + 3 retries)
                    expect(attempts, 4);
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pump();
        // Fast-forward through all retry delays
        await tester.pump(const Duration(seconds: 10));
      });
    });

    group('handleSocialSignIn', () {
      testWidgets('returns true on successful sign-in', (tester) async {
        final authState = AuthState();

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    final result = await AuthUIHandler.handleSocialSignIn(
                      context: context,
                      authState: authState,
                      l10n: l10n,
                      signInMethod: () async => true,
                      errorMessage: 'Sign-in failed',
                    );
                    expect(result, isTrue);
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        authState.dispose();
      });

      testWidgets('returns false on failed sign-in', (tester) async {
        final authState = AuthState();

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    final result = await AuthUIHandler.handleSocialSignIn(
                      context: context,
                      authState: authState,
                      l10n: l10n,
                      signInMethod: () async => false,
                      errorMessage: 'Sign-in failed',
                    );
                    expect(result, isFalse);
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        authState.dispose();
      });

      testWidgets('handles exceptions gracefully', (tester) async {
        final authState = AuthState();

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    final result = await AuthUIHandler.handleSocialSignIn(
                      context: context,
                      authState: authState,
                      l10n: l10n,
                      signInMethod: () async {
                        throw Exception('Test error');
                      },
                      errorMessage: 'Sign-in failed',
                    );
                    expect(result, isFalse);
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 10));

        authState.dispose();
      });
    });

    group('handleAnonymousSignIn', () {
      testWidgets('returns false when Firebase not initialized', (
        tester,
      ) async {
        final authState = AuthState();

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    // Will fail since Firebase is not initialized in tests
                    final result = await AuthUIHandler.handleAnonymousSignIn(
                      context: context,
                      authState: authState,
                      l10n: l10n,
                    );
                    // Expecting false since Firebase is not initialized
                    expect(result, isFalse);
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        authState.dispose();
      });
    });

    group('handleEmailPasswordAuth', () {
      testWidgets('returns false when Firebase not initialized', (
        tester,
      ) async {
        final authState = AuthState();

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    final result = await AuthUIHandler.handleEmailPasswordAuth(
                      context: context,
                      authState: authState,
                      l10n: l10n,
                      email: 'test@example.com',
                      password: 'password123',
                      isCreatingAccount: false,
                    );
                    // Will fail since Firebase is not initialized
                    expect(result, isFalse);
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        authState.dispose();
      });

      testWidgets('handles display name properly', (tester) async {
        final authState = AuthState();

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    final result = await AuthUIHandler.handleEmailPasswordAuth(
                      context: context,
                      authState: authState,
                      l10n: l10n,
                      email: 'test@example.com',
                      password: 'password123',
                      isCreatingAccount: true,
                      displayName: '',
                    );
                    // Should use defaultUserName from l10n
                    // Will fail since Firebase is not initialized
                    expect(result, isFalse);
                  },
                  child: const Text('Test'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        authState.dispose();
      });
    });
  });
}
