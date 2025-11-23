import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing Firebase Authentication
///
/// Provides methods for user authentication including email/password,
/// Google Sign-In, Apple Sign-In, Facebook, and anonymous authentication.
/// Also manages user profile data and avatar selection.
class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  bool _isInitialized = false;

  FirebaseAuth? get auth => _auth;
  bool get isInitialized => _isInitialized;

  /// Preference key for storing selected avatar
  static const String _avatarPreferenceKey = 'user_selected_avatar';

  /// Initialize authentication service
  Future<void> initialize() async {
    try {
      _auth = FirebaseAuth.instance;

      // Initialize Google Sign-In (7.x API requires explicit initialization)
      _googleSignIn = GoogleSignIn.instance;
      await _googleSignIn!.initialize();

      _isInitialized = true;
      debugPrint('Auth service initialized successfully');

      // Log authentication state
      final user = _auth?.currentUser;
      if (user != null) {
        await FirebaseService.instance.logEvent(
          'auth_state_restored',
          parameters: {
            'user_id': user.uid,
            'is_anonymous': user.isAnonymous.toString(),
          },
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error initializing auth service: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
    }
  }

  /// Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth?.currentUser;
    if (user == null) return null;

    // Load saved avatar preference
    final avatar = await _loadSavedAvatar();

    return UserProfile.fromFirebaseUser(user, avatar: avatar);
  }

  /// Stream of authentication state changes
  Stream<UserProfile?> get authStateChanges {
    if (_auth == null) {
      return Stream.value(null);
    }

    return _auth!.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final avatar = await _loadSavedAvatar();
      return UserProfile.fromFirebaseUser(user, avatar: avatar);
    });
  }

  /// Sign in with email and password
  Future<UserProfile?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential?.user == null) return null;

      await FirebaseService.instance.logEvent(
        'auth_sign_in_success',
        parameters: {'method': AuthProviderType.emailPassword.displayName},
      );

      final avatar = await _loadSavedAvatar();
      return UserProfile.fromFirebaseUser(credential!.user!, avatar: avatar);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Sign in error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      await FirebaseService.instance.logEvent(
        'auth_sign_in_error',
        parameters: {
          'method': AuthProviderType.emailPassword.displayName,
          'error_code': e.code,
        },
      );
      rethrow;
    }
  }

  /// Create account with email and password
  Future<UserProfile?> createAccountWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth?.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential?.user == null) return null;

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await credential!.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }

      // Assign random avatar for new users
      final avatar = UserAvatar.random();
      await setUserAvatar(avatar);

      await FirebaseService.instance.logEvent(
        'auth_account_created',
        parameters: {'method': AuthProviderType.emailPassword.displayName},
      );

      return UserProfile.fromFirebaseUser(credential!.user!, avatar: avatar);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Create account error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      await FirebaseService.instance.logEvent(
        'auth_account_creation_error',
        parameters: {
          'method': AuthProviderType.emailPassword.displayName,
          'error_code': e.code,
        },
      );
      rethrow;
    }
  }

  /// Sign in with Google
  Future<UserProfile?> signInWithGoogle() async {
    try {
      if (_googleSignIn == null) {
        throw Exception('Google Sign-In not initialized');
      }

      // Trigger the authentication flow using 7.x API
      // First authenticate (sign in) the user with scope hint for email and profile
      await _googleSignIn!.authenticate(
        scopeHint: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      // Listen for the authentication event to get the authenticated user
      GoogleSignInAccount? googleUser;
      await for (final event in _googleSignIn!.authenticationEvents.take(1)) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          googleUser = event.user;
          break;
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          // User canceled the sign-in
          return null;
        }
      }

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Get the authentication tokens (idToken) from the account
      final googleAuth = googleUser.authentication;

      // Create a new credential with the ID token
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth?.signInWithCredential(credential);

      if (userCredential?.user == null) return null;

      // Check if this is a new user
      final isNewUser = userCredential!.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        // Assign random avatar for new users
        final avatar = UserAvatar.random();
        await setUserAvatar(avatar);

        await FirebaseService.instance.logEvent(
          'auth_account_created',
          parameters: {'method': AuthProviderType.google.displayName},
        );
      } else {
        await FirebaseService.instance.logEvent(
          'auth_sign_in_success',
          parameters: {'method': AuthProviderType.google.displayName},
        );
      }

      final avatar = await _loadSavedAvatar();
      return UserProfile.fromFirebaseUser(userCredential.user!, avatar: avatar);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Google sign in error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      await FirebaseService.instance.logEvent(
        'auth_sign_in_error',
        parameters: {
          'method': AuthProviderType.google.displayName,
          'error_code': e.code,
        },
      );
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Google sign in error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<UserProfile?> signInWithApple() async {
    try {
      // Check if Apple Sign In is available on this platform
      if (!PlatformUtils.isApple) {
        throw Exception('Apple Sign-In is only available on Apple platforms');
      }

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential from the credential returned by Apple
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _auth?.signInWithCredential(oauthCredential);

      if (userCredential?.user == null) return null;

      // Update display name if provided by Apple and not already set
      final user = userCredential!.user!;
      if (user.displayName == null &&
          appleCredential.givenName != null &&
          appleCredential.familyName != null) {
        final displayName =
            '${appleCredential.givenName} ${appleCredential.familyName}';
        await user.updateDisplayName(displayName);
        await user.reload();
      }

      // Check if this is a new user
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        // Assign random avatar for new users
        final avatar = UserAvatar.random();
        await setUserAvatar(avatar);

        await FirebaseService.instance.logEvent(
          'auth_account_created',
          parameters: {'method': AuthProviderType.apple.displayName},
        );
      } else {
        await FirebaseService.instance.logEvent(
          'auth_sign_in_success',
          parameters: {'method': AuthProviderType.apple.displayName},
        );
      }

      final avatar = await _loadSavedAvatar();
      return UserProfile.fromFirebaseUser(user, avatar: avatar);
    } on SignInWithAppleAuthorizationException catch (e, stackTrace) {
      debugPrint('Apple sign in error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      await FirebaseService.instance.logEvent(
        'auth_sign_in_error',
        parameters: {
          'method': AuthProviderType.apple.displayName,
          'error_code': e.code.toString(),
        },
      );
      rethrow;
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Apple sign in error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      await FirebaseService.instance.logEvent(
        'auth_sign_in_error',
        parameters: {
          'method': AuthProviderType.apple.displayName,
          'error_code': e.code,
        },
      );
      rethrow;
    }
  }

  /// Sign in anonymously
  Future<UserProfile?> signInAnonymously() async {
    try {
      final credential = await _auth?.signInAnonymously();

      if (credential?.user == null) return null;

      // Assign random avatar for anonymous users
      final avatar = UserAvatar.random();
      await setUserAvatar(avatar);

      await FirebaseService.instance.logEvent(
        'auth_anonymous_sign_in',
        parameters: {'user_id': credential!.user!.uid},
      );

      return UserProfile.fromFirebaseUser(credential.user!, avatar: avatar);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Anonymous sign in error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Link anonymous account with email/password
  Future<UserProfile?> linkAnonymousAccountWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth?.currentUser;
      if (user == null || !user.isAnonymous) {
        throw Exception('No anonymous user to link');
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      final userCredential = await user.linkWithCredential(credential);

      await FirebaseService.instance.logEvent(
        'auth_anonymous_account_linked',
        parameters: {'method': AuthProviderType.emailPassword.displayName},
      );

      final avatar = await _loadSavedAvatar();
      return UserProfile.fromFirebaseUser(userCredential.user!, avatar: avatar);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Link account error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth?.sendPasswordResetEmail(email: email);

      await FirebaseService.instance.logEvent(
        'auth_password_reset_requested',
        parameters: {'email': email},
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = _auth?.currentUser;
      if (user == null) return;

      await user.updateDisplayName(displayName);
      await user.reload();

      await FirebaseService.instance.logEvent(
        'auth_profile_updated',
        parameters: {'field': 'display_name'},
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Update display name error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Set user avatar
  Future<void> setUserAvatar(UserAvatar avatar) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_avatarPreferenceKey, avatar.id);

      await FirebaseService.instance.logEvent(
        'auth_avatar_changed',
        parameters: {'avatar': avatar.id},
      );
    } catch (e, stackTrace) {
      debugPrint('Error saving avatar: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
    }
  }

  /// Load saved avatar from preferences
  Future<UserAvatar?> _loadSavedAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final avatarId = prefs.getString(_avatarPreferenceKey);
      if (avatarId == null) return null;

      return UserAvatar.fromId(avatarId);
    } catch (e) {
      debugPrint('Error loading saved avatar: $e');
      return null;
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth?.currentUser;
      if (user == null) return;

      final uid = user.uid;

      // Clear saved avatar
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_avatarPreferenceKey);

      // Delete the user account
      await user.delete();

      await FirebaseService.instance.logEvent(
        'auth_account_deleted',
        parameters: {'user_id': uid},
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Delete account error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );

      // If requires recent login, throw specific error
      if (e.code == 'requires-recent-login') {
        rethrow;
      }
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Google if signed in
      try {
        await _googleSignIn?.signOut();
      } catch (e) {
        // Ignore sign out errors
      }

      await _auth?.signOut();

      await FirebaseService.instance.logEvent('auth_sign_out', parameters: {});
    } catch (e, stackTrace) {
      debugPrint('Sign out error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Re-authenticate user (required before sensitive operations like account deletion)
  Future<void> reauthenticateWithPassword(String password) async {
    try {
      final user = _auth?.currentUser;
      if (user == null || user.email == null) {
        throw Exception('No user signed in');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Re-authentication error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Get friendly error message for FirebaseAuthException
  String getFriendlyErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An error occurred: ${exception.message}';
    }
  }
}
