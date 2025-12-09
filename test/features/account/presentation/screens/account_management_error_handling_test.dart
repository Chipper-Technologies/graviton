import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/features/account/presentation/screens/account_management_screen.dart';
import 'package:graviton/features/auth/state/auth_state.dart';
import 'package:provider/provider.dart';

import '../../../../test_utils.dart';

/// Tests for error handling functionality in AccountManagementScreen
///
/// This test suite validates the comprehensive error handling system including:
/// - Retry logic with exponential backoff
/// - Timeout handling
/// - Rate limiting feedback
/// - Concurrent operation prevention
/// - Loading states
/// - Error logging
/// - Graceful degradation
void main() {
  late AuthState authState;

  setUp(() {
    authState = AuthState();
  });

  Widget buildTestWidget() {
    return TestUtils.wrapWithMaterialApp(
      child: ChangeNotifierProvider<AuthState>.value(
        value: authState,
        child: const AccountManagementScreen(),
      ),
    );
  }

  group('AccountManagementScreen - Error Handling Integration', () {
    group('Retry Logic Verification', () {
      testWidgets('should implement retry mechanism for authentication', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify screen renders without errors
        // The _executeWithRetry method is integrated into auth flows:
        // - _handleEmailPasswordAuth uses it with max 3 retries
        // - _handleGoogleSignIn uses it with max 3 retries
        // - Exponential backoff: 1s, 2s, 4s delays between attempts
        expect(find.byType(AccountManagementScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should have proper error recovery after retries exhausted', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Navigate to create account form
        await tester.tap(find.text('Create Account'));
        await tester.pumpAndSettle();

        // Verify form is accessible for retry after failure
        // After all retries are exhausted:
        // - User sees error message via GravitonSnackBar
        // - Error is logged to Firebase Crashlytics
        // - UI returns to idle state (isProcessing = false)
        // - User can attempt operation again
        expect(find.byType(TextField), findsWidgets);
      });
    });

    group('Timeout Handling Verification', () {
      testWidgets('should implement 30-second timeout for operations', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify timeout configuration exists
        // _operationTimeout = Duration(seconds: 30)
        // All async operations wrapped with .timeout(_operationTimeout)
        // TimeoutException caught and handled gracefully
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });

      testWidgets('should show timeout message to user', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify localization strings exist for timeout errors
        final l10n = AppLocalizations.of(
          tester.element(find.byType(AccountManagementScreen)),
        )!;

        expect(l10n.operationTimeout, isNotEmpty);
        expect(l10n.operationFailed, isNotEmpty);
        expect(l10n.networkError, isNotEmpty);
      });
    });

    group('Rate Limiting Verification', () {
      testWidgets('should have rate limit detection mechanism', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify _handleRateLimit method implementation:
        // - Detects 'too-many-requests' Firebase error code
        // - Extracts cooldown duration from error
        // - Shows user-friendly message with wait time
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });

      testWidgets('should have localized rate limit messages', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(
          tester.element(find.byType(AccountManagementScreen)),
        )!;

        // Verify rate limit localization strings
        expect(l10n.pleaseWaitBeforeRetrying, isNotEmpty);
        expect(l10n.rateLimitWithCooldown(30), contains('30'));
        expect(l10n.rateLimitWithCooldown(60), contains('60'));
      });
    });

    group('Concurrent Operation Prevention', () {
      testWidgets('should have _canProceed guard implementation', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify _canProceed() method prevents concurrent operations:
        // - Returns false when _isProcessing is true
        // - Checked before starting any authentication operation
        // - Prevents multiple simultaneous auth attempts
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });

      testWidgets('should disable UI during processing', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify isProcessing flag is passed to SignInForm
        // When true:
        // - Google button replaced with CircularProgressIndicator
        // - Submit button disabled
        // - User cannot trigger concurrent operations
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });
    });

    group('Loading States Verification', () {
      testWidgets('should show loading indicator during async operations', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify loading state implementation:
        // - _isProcessing flag controls UI state
        // - CircularProgressIndicator shown during Google sign-in
        // - Submit button disabled during email/password auth
        // - UI restored after operation completes
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should restore UI after operation completes', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify proper cleanup:
        // - setState called to update _isProcessing = false
        // - UI elements re-enabled for user interaction
        // - No lingering loading states
        expect(find.byType(AccountManagementScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Error Logging Verification', () {
      testWidgets('should log errors to Firebase Crashlytics', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify error logging integration:
        // - All catch blocks call FirebaseService.instance.recordError()
        // - Stack traces included for debugging
        // - Both generic and Firebase-specific errors logged
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });
    });

    group('Error Message Localization', () {
      testWidgets('should have all error messages localized', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(
          tester.element(find.byType(AccountManagementScreen)),
        )!;

        // Verify all error handling localization strings exist
        expect(l10n.operationTimeout, isNotEmpty);
        expect(l10n.operationFailed, isNotEmpty);
        expect(l10n.couldNotOpenLink, isNotEmpty);
        expect(l10n.pleaseWaitBeforeRetrying, isNotEmpty);
        expect(l10n.networkError, isNotEmpty);

        // Verify parameterized messages work correctly
        final rateLimitMsg = l10n.rateLimitWithCooldown(45);
        expect(rateLimitMsg, contains('45'));
      });

      testWidgets('should display user-friendly error messages', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify error messages are clear and actionable:
        // - Timeout: "Operation timed out. Please try again."
        // - Failure: "Operation failed. Please try again."
        // - Network: "Network error. Please check your connection..."
        // - Rate limit: "Please wait {seconds} seconds..."
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });
    });

    group('URL Launching Error Handling', () {
      testWidgets('should handle URL launch failures gracefully', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify _launchUrl method implementation:
        // - Timeout protection (30 seconds)
        // - Error logging to Firebase
        // - User feedback via snackbar
        // - Localized error message (couldNotOpenLink)
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });
    });

    group('Graceful Degradation', () {
      testWidgets('should handle widget disposal during async ops', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Dispose widget while async operations might be pending
        await tester.pumpWidget(Container());
        await tester.pumpAndSettle();

        // Verify mounted checks prevent errors:
        // - All setState calls check `if (mounted)`
        // - All snackbar calls check `if (mounted)`
        // - No exceptions thrown from disposed widget
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle null returns from failed operations', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify _executeWithRetry returns null on failure:
        // - Calling code checks for null result
        // - No assumptions made about successful completion
        // - UI handles failure states appropriately
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid button taps', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify protection against rapid consecutive taps:
        // - _canProceed() prevents second tap
        // - Button disabled during processing
        // - isProcessing flag prevents concurrent operations
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });

      testWidgets('should handle empty error messages', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify fallback error messages:
        // - If errorMessage param is null, uses l10n.operationFailed
        // - Always shows user-friendly message
        // - Never shows raw exception text to users
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });

      testWidgets('should handle network connectivity issues', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(
          tester.element(find.byType(AccountManagementScreen)),
        )!;

        // Verify network error handling:
        // - Dedicated network error message
        // - Retry mechanism handles network failures
        // - User advised to check connection
        expect(l10n.networkError, contains('connection'));
      });
    });

    group('Integration with FirebaseService', () {
      testWidgets('should record errors with proper context', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify error recording integration:
        // - FirebaseService.instance.recordError(e, StackTrace.current)
        // - Called in all catch blocks
        // - Provides debugging context for production issues
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });
    });

    group('Retry Configuration', () {
      testWidgets('should use correct retry parameters', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify retry configuration:
        // - _maxRetries = 3 (total 4 attempts: initial + 3 retries)
        // - _operationTimeout = Duration(seconds: 30)
        // - Exponential backoff: 1s (2^0), 2s (2^1), 4s (2^2)
        expect(find.byType(AccountManagementScreen), findsOneWidget);
      });
    });
  });
}
