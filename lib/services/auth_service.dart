import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, debugPrint;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/services/firebase_service.dart';
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

  // ============================================================================
  // Rate Limiting State
  // ============================================================================

  /// Track failed sign-in attempts for rate limiting
  final Map<String, List<DateTime>> _failedSignInAttempts = {};

  /// Maximum failed attempts before rate limiting kicks in
  static const int _maxFailedAttempts = 5;

  /// Rate limit duration in minutes
  static const int _rateLimitDurationMinutes = 15;

  // ============================================================================
  // SharedPreferences Keys
  // ============================================================================

  /// Preference key for storing selected avatar
  static const String _avatarPreferenceKey = 'user_selected_avatar';

  /// Preference key for storing anonymous user display name
  static const String _anonymousDisplayNameKey = 'anonymous_display_name';

  /// Preference key for storing terms acceptance timestamp
  static const String _termsAcceptanceKey = 'terms_acceptance_timestamp';

  /// Preference key for storing accepted terms version
  static const String _termsVersionKey = 'terms_version_accepted';

  /// Initialize authentication service
  Future<void> initialize() async {
    try {
      try {
        _auth = FirebaseAuth.instance;
      } catch (authError) {
        debugPrint(
          'AuthService: CRITICAL - Failed to get FirebaseAuth.instance: $authError',
        );
        _auth = null;
        rethrow;
      }

      // Initialize Google Sign-In (7.x API requires explicit initialization)
      try {
        _googleSignIn = GoogleSignIn.instance;
        await _googleSignIn!.initialize();
      } catch (googleInitError) {
        debugPrint(
          'AuthService: Google Sign-In initialization failed: $googleInitError',
        );
        _googleSignIn = null; // Clear the instance if initialization fails
      }

      _isInitialized = true;

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
      debugPrint('AuthService: CRITICAL ERROR during initialization: $e');
      debugPrint('AuthService: Stack trace: $stackTrace');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow; // Rethrow to propagate the error
    }
  }

  /// Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth?.currentUser;
    if (user == null) return null;

    // Load saved avatar preference
    final avatar = await _loadSavedAvatar();

    // Load anonymous display name if applicable
    String? displayNameOverride;
    if (user.isAnonymous) {
      final prefs = await SharedPreferences.getInstance();
      displayNameOverride = prefs.getString(_anonymousDisplayNameKey);
    }

    return UserProfile.fromFirebaseUser(
      user,
      avatar: avatar,
      displayNameOverride: displayNameOverride,
    );
  }

  /// Stream of authentication state changes
  Stream<UserProfile?> get authStateChanges {
    if (_auth == null) {
      return Stream.value(null);
    }

    return _auth!.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final avatar = await _loadSavedAvatar();

      // Load anonymous display name if applicable
      String? displayNameOverride;
      if (user.isAnonymous) {
        final prefs = await SharedPreferences.getInstance();
        displayNameOverride = prefs.getString(_anonymousDisplayNameKey);
      }

      return UserProfile.fromFirebaseUser(
        user,
        avatar: avatar,
        displayNameOverride: displayNameOverride,
      );
    });
  }

  /// Check if email/identifier is rate limited
  bool _isRateLimited(String identifier) {
    if (!_failedSignInAttempts.containsKey(identifier)) {
      return false;
    }

    final attempts = _failedSignInAttempts[identifier]!;
    final now = DateTime.now();

    // Remove attempts older than rate limit duration
    attempts.removeWhere(
      (time) => now.difference(time).inMinutes > _rateLimitDurationMinutes,
    );

    // Check if still rate limited
    if (attempts.length >= _maxFailedAttempts) {
      if (kDebugMode) {
        debugPrint(
          'AuthService: Rate limit active for identifier (${attempts.length} attempts)',
        );
      }
      return true;
    }

    return false;
  }

  /// Record a failed sign-in attempt
  void _recordFailedAttempt(String identifier) {
    if (!_failedSignInAttempts.containsKey(identifier)) {
      _failedSignInAttempts[identifier] = [];
    }
    _failedSignInAttempts[identifier]!.add(DateTime.now());
  }

  /// Clear failed attempts after successful sign-in
  void _clearFailedAttempts(String identifier) {
    _failedSignInAttempts.remove(identifier);
  }

  /// Check if user's email is verified before allowing sensitive operations
  Future<bool> requireEmailVerification() async {
    final user = _auth?.currentUser;
    if (user == null || user.isAnonymous) {
      return true; // Anonymous users don't need verification
    }

    // Check if email verification is required
    if (user.email != null && !user.emailVerified) {
      // Reload to get latest verification status
      await user.reload();
      final refreshedUser = _auth?.currentUser;
      return refreshedUser?.emailVerified ?? false;
    }

    return true;
  }

  /// Sign in with email and password
  Future<UserProfile?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Check rate limiting
    if (_isRateLimited(email.toLowerCase())) {
      if (kDebugMode) {
        debugPrint('AuthService: Sign-in rate limited');
      }
      throw FirebaseAuthException(
        code: 'too-many-requests',
        message: 'Too many failed attempts. Please try again later.',
      );
    }

    try {
      final credential = await _auth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential?.user == null) return null;

      // Clear failed attempts on successful sign-in
      _clearFailedAttempts(email.toLowerCase());

      await FirebaseService.instance.logEvent(
        'auth_sign_in_success',
        parameters: {'method': AuthProviderType.emailPassword.displayName},
      );

      final avatar = await _loadSavedAvatar();
      return UserProfile.fromFirebaseUser(credential!.user!, avatar: avatar);
    } on FirebaseAuthException catch (e, stackTrace) {
      // Record failed attempt for rate limiting
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        _recordFailedAttempt(email.toLowerCase());
      }

      if (kDebugMode) {
        debugPrint('AuthService: Sign in failed - ${e.code}');
      }
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
      }

      // Assign random avatar for new users
      final avatar = UserAvatar.random();
      await setUserAvatar(avatar);

      // Reload user to get updated profile data
      await credential!.user!.reload();
      final updatedUser = _auth?.currentUser;

      await FirebaseService.instance.logEvent(
        'auth_account_created',
        parameters: {'method': AuthProviderType.emailPassword.displayName},
      );

      return UserProfile.fromFirebaseUser(
        updatedUser ?? credential.user!,
        avatar: avatar,
      );
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
        throw Exception('exceptionGoogleSignInNotInitialized');
      }

      debugPrint('Starting Google sign-in flow...');

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn!.authenticate(
        scopeHint: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      if (kDebugMode) {
        debugPrint('AuthService: Google sign-in successful');
      }

      // Get the authentication tokens (idToken) from the account
      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        return null;
      }

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
        // Assign random avatar only if user doesn't have a profile photo from Google
        final hasProfilePhoto =
            userCredential.user!.photoURL != null &&
            userCredential.user!.photoURL!.isNotEmpty;
        if (!hasProfilePhoto) {
          final avatar = UserAvatar.random();
          await setUserAvatar(avatar);
        }

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
    } on PlatformException catch (e) {
      // Handle user cancellation or other platform errors
      if (e.code == 'sign_in_canceled' ||
          e.code == 'popup_closed_by_user' ||
          e.code == 'network_error') {
        debugPrint('Google sign-in canceled by user: ${e.code}');
        return null; // User cancellation is not an error
      }

      debugPrint('Google sign-in platform error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        StackTrace.current,
        reason: 'Google Sign-In Platform Error',
      );
      rethrow;
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
      debugPrint('Apple sign in: Opening authentication dialog...');

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: AppConfig.appleClientId,
          redirectUri: Uri.parse(AppConfig.appleRedirectUri),
        ),
      );

      debugPrint(
        'Apple sign in: Received credential, signing in to Firebase...',
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
        // Assign random avatar only if user doesn't have a profile photo from Apple
        final hasProfilePhoto =
            user.photoURL != null && user.photoURL!.isNotEmpty;
        if (!hasProfilePhoto) {
          final avatar = UserAvatar.random();
          await setUserAvatar(avatar);
        }

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
      // User canceled the sign-in flow (closed Custom Tab) - this is normal, not an error
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('Apple sign in canceled by user');
        return null; // Silently return null, don't log as error
      }

      // Log other Apple-specific errors to Crashlytics
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

  /// Sign in with GitHub
  Future<UserProfile?> signInWithGitHub() async {
    try {
      // Create GitHub OAuth provider
      final githubProvider = GithubAuthProvider();

      // Add scopes if needed
      githubProvider.addScope('user:email');

      // Sign in with popup or redirect depending on platform
      UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await _auth!.signInWithPopup(githubProvider);
      } else {
        userCredential = await _auth!.signInWithProvider(githubProvider);
      }

      if (userCredential.user == null) return null;

      // Check if this is a new user
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        // Assign random avatar only if user doesn't have a profile photo from GitHub
        final hasProfilePhoto =
            userCredential.user!.photoURL != null &&
            userCredential.user!.photoURL!.isNotEmpty;
        if (!hasProfilePhoto) {
          final avatar = UserAvatar.random();
          await setUserAvatar(avatar);
        }

        await FirebaseService.instance.logEvent(
          'auth_account_created',
          parameters: {'method': AuthProviderType.github.displayName},
        );
      } else {
        await FirebaseService.instance.logEvent(
          'auth_sign_in_success',
          parameters: {'method': AuthProviderType.github.displayName},
        );
      }

      final avatar = await _loadSavedAvatar();
      return UserProfile.fromFirebaseUser(userCredential.user!, avatar: avatar);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('GitHub sign in error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      await FirebaseService.instance.logEvent(
        'auth_sign_in_error',
        parameters: {
          'method': AuthProviderType.github.displayName,
          'error_code': e.code,
        },
      );
      rethrow;
    }
  }

  /// Sign in anonymously
  Future<UserProfile?> signInAnonymously() async {
    try {
      if (_auth == null) {
        debugPrint('Anonymous sign in failed: FirebaseAuth not initialized');
        throw Exception('exceptionAuthNotInitialized');
      }

      final credential = await _auth!.signInAnonymously();

      if (credential.user == null) {
        throw Exception('exceptionNoAnonymousUser');
      }

      // Assign random avatar for anonymous users
      final avatar = UserAvatar.random();
      await setUserAvatar(avatar);

      await FirebaseService.instance.logEvent(
        'auth_anonymous_sign_in',
        parameters: {'user_id': credential.user!.uid},
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
    } catch (e, stackTrace) {
      debugPrint('Unexpected anonymous sign in error: $e');
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
        throw Exception('exceptionNoAnonymousUser');
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

      if (user.isAnonymous) {
        // For anonymous users, store display name locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_anonymousDisplayNameKey, displayName);
      } else {
        // For authenticated users, update Firebase profile
        await user.updateDisplayName(displayName);
        await user.reload();
      }

      await FirebaseService.instance.logEvent(
        'auth_profile_updated',
        parameters: {'field': 'display_name', 'is_anonymous': user.isAnonymous},
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

  /// Clear custom avatar (allows profile photo to be shown again)
  Future<void> clearUserAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_avatarPreferenceKey);

      await FirebaseService.instance.logEvent('auth_avatar_cleared');
    } catch (e, stackTrace) {
      debugPrint('Error clearing avatar: $e');
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
        throw Exception('exceptionNoUserSignedIn');
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

  /// Re-authenticate with Google (required before sensitive operations)
  Future<void> reauthenticateWithGoogle() async {
    try {
      final user = _auth?.currentUser;
      if (user == null) {
        throw Exception('exceptionNoUserSignedIn');
      }

      // Use the event-based Google Sign-In API
      final eventCompleter = Completer<GoogleSignInAuthenticationEvent>();
      late StreamSubscription<GoogleSignInAuthenticationEvent> subscription;

      subscription = _googleSignIn!.authenticationEvents.listen(
        (event) {
          if (!eventCompleter.isCompleted) {
            eventCompleter.complete(event);
            subscription.cancel();
          }
        },
        onError: (error) {
          if (!eventCompleter.isCompleted) {
            eventCompleter.completeError(error);
            subscription.cancel();
          }
        },
      );

      // Trigger the authentication flow
      await _googleSignIn!.authenticate(
        scopeHint: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      // Wait for the authentication event
      final event = await eventCompleter.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          subscription.cancel();
          throw TimeoutException('exceptionGoogleSignInTimeout');
        },
      );

      GoogleSignInAccount googleUser;
      if (event is GoogleSignInAuthenticationEventSignIn) {
        googleUser = event.user;
      } else {
        throw Exception('exceptionGoogleSignInCancelled');
      }

      // Get the authentication tokens
      final googleAuth = googleUser.authentication;

      // Create credential with the ID token
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Google re-authentication error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Re-authenticate with Apple (required before sensitive operations)
  Future<void> reauthenticateWithApple() async {
    try {
      final user = _auth?.currentUser;
      if (user == null) {
        throw Exception('exceptionNoUserSignedIn');
      }

      // Sign in with Apple to get fresh credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: AppConfig.appleClientId,
          redirectUri: Uri.parse(AppConfig.appleRedirectUri),
        ),
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await user.reauthenticateWithCredential(oauthCredential);
    } on SignInWithAppleAuthorizationException catch (e, stackTrace) {
      // User canceled the re-authentication flow (closed Custom Tab) - this is normal, not an error
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('Apple re-authentication canceled by user');
        return; // Silently return, don't log as error
      }

      // Log other Apple-specific errors to Crashlytics
      debugPrint('Apple re-authentication error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Apple re-authentication error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  // ============================================================================
  // Email Verification Methods
  // ============================================================================

  /// Send email verification to the current user
  /// Returns a localization key for success/error messages
  Future<String> sendEmailVerification() async {
    try {
      final user = _auth?.currentUser;
      if (user == null) {
        throw Exception('exceptionNoUserSignedIn');
      }

      if (user.emailVerified) {
        return 'emailVerified';
      }

      await user.sendEmailVerification();

      await FirebaseService.instance.logEvent(
        'email_verification_sent',
        parameters: {'email': user.email ?? 'unknown'},
      );

      return 'emailVerificationSent';
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Email verification error: ${e.code} - ${e.message}');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      throw Exception('exceptionEmailVerificationFailed');
    } catch (e, stackTrace) {
      debugPrint('Email verification error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      throw Exception('exceptionEmailVerificationFailed');
    }
  }

  /// Check if the current user's email is verified
  /// Reloads user data from Firebase to get latest verification status
  Future<bool> checkEmailVerified() async {
    try {
      final user = _auth?.currentUser;
      if (user == null) {
        return false;
      }

      // Reload user to get latest email verification status
      await user.reload();
      final refreshedUser = _auth?.currentUser;

      final isVerified = refreshedUser?.emailVerified ?? false;

      await FirebaseService.instance.logEvent(
        'email_verification_checked',
        parameters: {
          'email': refreshedUser?.email ?? 'unknown',
          'verified': isVerified,
        },
      );

      return isVerified;
    } catch (e, stackTrace) {
      debugPrint('Check email verified error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      return false;
    }
  }

  /// Get current user's email verification status without reloading
  bool get isEmailVerified => _auth?.currentUser?.emailVerified ?? false;

  // ============================================================================
  // Terms & Privacy Acceptance Methods
  // ============================================================================

  /// Save that the user has accepted the terms and privacy policy
  /// [termsVersion] allows tracking which version of terms was accepted
  Future<void> saveTermsAcceptance({String termsVersion = '1.0'}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await prefs.setInt(_termsAcceptanceKey, timestamp);
      await prefs.setString(_termsVersionKey, termsVersion);

      await FirebaseService.instance.logEvent(
        'terms_accepted',
        parameters: {'version': termsVersion, 'timestamp': timestamp},
      );
    } catch (e, stackTrace) {
      debugPrint('Save terms acceptance error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      rethrow;
    }
  }

  /// Check if the user has accepted the terms and privacy policy
  Future<bool> hasAcceptedTerms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_termsAcceptanceKey);
    } catch (e, stackTrace) {
      debugPrint('Check terms acceptance error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      return false;
    }
  }

  /// Get the date when terms were accepted
  /// Returns null if terms have not been accepted
  Future<DateTime?> getTermsAcceptanceDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_termsAcceptanceKey);

      if (timestamp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e, stackTrace) {
      debugPrint('Get terms acceptance date error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      return null;
    }
  }

  /// Get the version of terms that was accepted
  /// Returns null if terms have not been accepted
  Future<String?> getAcceptedTermsVersion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_termsVersionKey);
    } catch (e, stackTrace) {
      debugPrint('Get accepted terms version error: $e');
      await FirebaseService.instance.crashlytics?.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      return null;
    }
  }

  /// Clear terms acceptance (useful for testing or policy updates)
  Future<void> clearTermsAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_termsAcceptanceKey);
      await prefs.remove(_termsVersionKey);

      await FirebaseService.instance.logEvent(
        'terms_acceptance_cleared',
        parameters: {},
      );
    } catch (e, stackTrace) {
      debugPrint('Clear terms acceptance error: $e');
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
        return 'firebaseErrorUserNotFound';
      case 'wrong-password':
        return 'firebaseErrorWrongPassword';
      case 'invalid-email':
        return 'firebaseErrorInvalidEmail';
      case 'user-disabled':
        return 'firebaseErrorUserDisabled';
      case 'email-already-in-use':
        return 'firebaseErrorEmailInUse';
      case 'weak-password':
        return 'firebaseErrorWeakPassword';
      case 'operation-not-allowed':
        return 'firebaseErrorOperationNotAllowed';
      case 'requires-recent-login':
        return 'firebaseErrorRequiresRecentLogin';
      case 'network-request-failed':
        return 'firebaseErrorNetworkFailed';
      case 'account-exists-with-different-credential':
        return 'firebaseErrorAccountExistsWithDifferentCredential';
      default:
        return 'firebaseErrorDefault:${exception.message}';
    }
  }
}
