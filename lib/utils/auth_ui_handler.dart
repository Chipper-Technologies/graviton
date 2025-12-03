import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/auth_service.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Utility class for handling authentication UI operations
///
/// This class provides testable, reusable authentication handlers that can be
/// used across different screens. It separates UI logic from the screen widget,
/// making the code more maintainable and easier to test.
class AuthUIHandler {
  static const int _maxRetries = 3;
  static const Duration _operationTimeout = Duration(seconds: 60);

  /// Execute an operation with retry logic for transient failures
  static Future<T?> executeWithRetry<T>({
    required Future<T> Function() operation,
    required BuildContext context,
    required AppLocalizations l10n,
    String? errorMessage,
  }) async {
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await operation().timeout(_operationTimeout);
      } on TimeoutException {
        if (attempt == _maxRetries) {
          if (context.mounted) {
            GravitonSnackBar.show(
              context: context,
              message: l10n.operationTimeout,
            );
          }
          return null;
        }
        // Wait before retry with exponential backoff
        await Future.delayed(Duration(seconds: 1 << attempt));
      } on SignInWithAppleAuthorizationException catch (e) {
        // Don't retry user cancellations - rethrow immediately
        if (e.code == AuthorizationErrorCode.canceled) {
          rethrow;
        }
        // Retry other Apple sign-in errors
        if (attempt == _maxRetries) {
          FirebaseService.instance.recordError(e, StackTrace.current);
          if (context.mounted) {
            GravitonSnackBar.show(
              context: context,
              message: errorMessage ?? l10n.operationFailed,
            );
          }
          return null;
        }
        // Wait before retry
        await Future.delayed(Duration(seconds: 1 << attempt));
      } catch (e) {
        if (attempt == _maxRetries) {
          FirebaseService.instance.recordError(e, StackTrace.current);
          if (context.mounted) {
            GravitonSnackBar.show(
              context: context,
              message: errorMessage ?? l10n.operationFailed,
            );
          }
          return null;
        }
        // Wait before retry
        await Future.delayed(Duration(seconds: 1 << attempt));
      }
    }
    return null;
  }

  /// Handle social sign-in (Google, Apple, GitHub)
  static Future<bool> handleSocialSignIn({
    required BuildContext context,
    required AuthState authState,
    required AppLocalizations l10n,
    required Future<bool> Function() signInMethod,
    required String errorMessage,
  }) async {
    try {
      final success =
          await executeWithRetry(
            operation: signInMethod,
            context: context,
            l10n: l10n,
            errorMessage: errorMessage,
          ) ??
          false;

      return success;
    } catch (e) {
      FirebaseService.instance.recordError(e, StackTrace.current);
      if (context.mounted) {
        GravitonSnackBar.show(context: context, message: errorMessage);
      }
      return false;
    }
  }

  /// Handle email/password authentication (sign-in or create account)
  static Future<bool> handleEmailPasswordAuth({
    required BuildContext context,
    required AuthState authState,
    required AppLocalizations l10n,
    required String email,
    required String password,
    required bool isCreatingAccount,
    String? displayName,
    bool acceptedTerms = false,
  }) async {
    try {
      final bool success =
          await executeWithRetry(
            operation: () async {
              if (isCreatingAccount) {
                final name = displayName?.trim().isEmpty ?? true
                    ? l10n.defaultUserName
                    : displayName!.trim();
                return await authState.createAccount(
                  email: email,
                  password: password,
                  displayName: name,
                );
              } else {
                return await authState.signInWithEmailPassword(
                  email: email,
                  password: password,
                );
              }
            },
            context: context,
            l10n: l10n,
          ) ??
          false;

      if (!context.mounted) return false;

      if (success) {
        // Save terms acceptance after successful account creation
        if (isCreatingAccount && acceptedTerms) {
          try {
            await AuthService.instance.saveTermsAcceptance();
          } catch (e) {
            FirebaseService.instance.recordError(e, StackTrace.current);
            debugPrint('Failed to save terms acceptance: $e');
          }
        }

        // Auto-send verification email for new accounts
        if (isCreatingAccount && context.mounted) {
          await sendEmailVerification(context: context, l10n: l10n);
        }

        return true;
      } else if (authState.error != null) {
        if (context.mounted) {
          GravitonSnackBar.show(
            context: context,
            message: getLocalizedErrorMessage(authState.error, l10n),
          );
        }
      }

      return false;
    } catch (e) {
      FirebaseService.instance.recordError(e, StackTrace.current);
      if (context.mounted) {
        GravitonSnackBar.show(context: context, message: l10n.operationFailed);
      }
      return false;
    }
  }

  /// Handle anonymous sign-in
  static Future<bool> handleAnonymousSignIn({
    required BuildContext context,
    required AuthState authState,
    required AppLocalizations l10n,
  }) async {
    try {
      final success = await authState.signInAnonymously();

      if (!context.mounted) return false;

      if (success) {
        GravitonSnackBar.show(
          context: context,
          message: l10n.signInAnonymousSuccess,
        );
        return true;
      } else {
        final errorMessage =
            authState.error ?? 'Authentication failed. Please try again.';
        GravitonSnackBar.show(context: context, message: errorMessage);
        return false;
      }
    } catch (e) {
      FirebaseService.instance.recordError(e, StackTrace.current);
      if (context.mounted) {
        GravitonSnackBar.show(context: context, message: l10n.operationFailed);
      }
      return false;
    }
  }

  /// Send email verification
  static Future<void> sendEmailVerification({
    required BuildContext context,
    required AppLocalizations l10n,
  }) async {
    try {
      final messageKey = await AuthService.instance.sendEmailVerification();

      if (context.mounted) {
        String message;
        switch (messageKey) {
          case 'emailVerificationSent':
            message = l10n.emailVerificationSent;
            break;
          case 'emailVerified':
            message = l10n.emailVerified;
            break;
          default:
            message = messageKey;
        }

        GravitonSnackBar.show(context: context, message: message);
      }
    } catch (e) {
      if (context.mounted) {
        GravitonSnackBar.show(
          context: context,
          message: getLocalizedErrorMessage(e.toString(), l10n),
        );
      }
    }
  }

  /// Translate error codes/messages to localized strings
  static String getLocalizedErrorMessage(String? error, AppLocalizations l10n) {
    if (error == null) return '';

    // Check if error starts with firebaseErrorDefault (has embedded message)
    if (error.startsWith('firebaseErrorDefault:')) {
      final message = error.substring('firebaseErrorDefault:'.length);
      return l10n.firebaseErrorDefault(message);
    }

    // Check if error is a localization key
    switch (error) {
      // Auth service exceptions
      case 'exceptionAuthNotInitialized':
        return 'Authentication service not initialized. Please restart the app.';
      case 'exceptionGoogleSignInNotInitialized':
        return l10n.exceptionGoogleSignInNotInitialized;
      case 'exceptionGoogleSignInTimeout':
        return l10n.exceptionGoogleSignInTimeout;
      case 'exceptionAppleSignInPlatform':
        return l10n.exceptionAppleSignInPlatform;
      case 'exceptionNoAnonymousUser':
        return l10n.exceptionNoAnonymousUser;
      case 'exceptionNoUserSignedIn':
        return l10n.exceptionNoUserSignedIn;

      // Email verification exceptions
      case 'exceptionEmailVerificationFailed':
        return l10n.exceptionEmailVerificationFailed;
      case 'exceptionEmailVerificationCooldown':
        return l10n.exceptionEmailVerificationCooldown;
      case 'exceptionTermsNotAccepted':
        return l10n.exceptionTermsNotAccepted;

      // Firebase auth errors
      case 'firebaseErrorUserNotFound':
        return l10n.firebaseErrorUserNotFound;
      case 'firebaseErrorWrongPassword':
        return l10n.firebaseErrorWrongPassword;
      case 'firebaseErrorInvalidEmail':
        return l10n.firebaseErrorInvalidEmail;
      case 'firebaseErrorUserDisabled':
        return l10n.firebaseErrorUserDisabled;
      case 'firebaseErrorEmailInUse':
        return l10n.firebaseErrorEmailInUse;
      case 'firebaseErrorWeakPassword':
        return l10n.firebaseErrorWeakPassword;
      case 'firebaseErrorOperationNotAllowed':
        return l10n.firebaseErrorOperationNotAllowed;
      case 'firebaseErrorRequiresRecentLogin':
        return l10n.firebaseErrorRequiresRecentLogin;
      case 'firebaseErrorNetworkFailed':
        return l10n.firebaseErrorNetworkFailed;
      case 'firebaseErrorAccountExistsWithDifferentCredential':
        return l10n.firebaseErrorAccountExistsWithDifferentCredential;

      default:
        // Return the error as-is if it's not a known key
        return error;
    }
  }

  /// Validate email format
  static String? validateEmail(String email, AppLocalizations l10n) {
    if (email.isEmpty) {
      return l10n.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return l10n.emailInvalid;
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(
    String password,
    AppLocalizations l10n, {
    bool isCreatingAccount = false,
  }) {
    if (password.isEmpty) {
      return l10n.passwordRequired;
    }

    if (isCreatingAccount) {
      // Minimum 8 characters
      if (password.length < 8) {
        return l10n.passwordTooShort;
      }

      // Require uppercase letter
      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        return l10n.passwordMissingUppercase;
      }

      // Require lowercase letter
      if (!RegExp(r'[a-z]').hasMatch(password)) {
        return l10n.passwordMissingLowercase;
      }

      // Require number
      if (!RegExp(r'[0-9]').hasMatch(password)) {
        return l10n.passwordMissingNumber;
      }

      // Require special character
      if (!RegExp(r'[!@#$%^&*(),.?\":{}|<>]').hasMatch(password)) {
        return l10n.passwordMissingSpecialChar;
      }
    }

    return null;
  }
}
