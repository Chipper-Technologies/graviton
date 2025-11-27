import 'package:flutter/material.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/services/auth_service.dart';
import 'package:graviton/services/user_data_sync_service.dart';

/// Manages authentication state using Provider pattern
///
/// This state manager handles user authentication, profile management,
/// and provides reactive updates when authentication state changes.
class AuthState extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated =>
      _currentUser != null && !_currentUser!.isAnonymous;
  bool get isAnonymous => _currentUser?.isAnonymous ?? false;

  /// Initialize auth state and listen to auth changes
  Future<void> initialize() async {
    // Listen to auth state changes
    AuthService.instance.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });

    // Get initial user state
    _currentUser = await AuthService.instance.getCurrentUserProfile();
    notifyListeners();
  }

  /// Sign in with email and password
  Future<bool> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await AuthService.instance.signInWithEmailPassword(
        email: email,
        password: password,
      );

      _currentUser = profile;

      // Initialize sync for authenticated user
      if (profile != null && !profile.isAnonymous) {
        try {
          await UserDataSyncService.instance.initialize();
        } catch (e) {
          debugPrint('Failed to initialize sync after sign-in: $e');
        }
      }

      _setLoading(false);
      return profile != null;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Create account with email and password
  Future<bool> createAccount({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await AuthService.instance.createAccountWithEmailPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      _currentUser = profile;

      // Migrate local data to cloud after successful account creation
      if (profile != null) {
        try {
          await UserDataSyncService.instance.migrateLocalDataToCloud();
          await UserDataSyncService.instance.initialize();
        } catch (e) {
          // Don't fail account creation if sync fails
          debugPrint('Failed to sync data after account creation: $e');
        }
      }

      _setLoading(false);
      return profile != null;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await AuthService.instance.signInWithGoogle();

      _currentUser = profile;

      // Initialize sync for authenticated user
      if (profile != null && !profile.isAnonymous) {
        try {
          await UserDataSyncService.instance.initialize();
        } catch (e) {
          debugPrint('Failed to initialize sync after Google sign-in: $e');
        }
      }

      _setLoading(false);
      return profile != null;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await AuthService.instance.signInWithApple();

      _currentUser = profile;

      // Initialize sync for authenticated user
      if (profile != null && !profile.isAnonymous) {
        try {
          await UserDataSyncService.instance.initialize();
        } catch (e) {
          debugPrint('Failed to initialize sync after Apple sign-in: $e');
        }
      }

      _setLoading(false);
      return profile != null;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with GitHub
  Future<bool> signInWithGitHub() async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await AuthService.instance.signInWithGitHub();

      _currentUser = profile;

      // Initialize sync for authenticated user
      if (profile != null && !profile.isAnonymous) {
        try {
          await UserDataSyncService.instance.initialize();
        } catch (e) {
          debugPrint('Failed to initialize sync after GitHub sign-in: $e');
        }
      }

      _setLoading(false);
      return profile != null;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Sign in anonymously
  Future<bool> signInAnonymously() async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await AuthService.instance.signInAnonymously();

      _currentUser = profile;
      _setLoading(false);
      return profile != null;
    } catch (e) {
      final errorMessage = _getErrorMessage(e);
      _setError(errorMessage);
      _setLoading(false);
      return false;
    }
  }

  /// Link anonymous account with email/password
  Future<bool> linkAnonymousAccountWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await AuthService.instance
          .linkAnonymousAccountWithEmailPassword(
            email: email,
            password: password,
          );

      _currentUser = profile;
      _setLoading(false);
      return profile != null;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await AuthService.instance.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Update display name
  Future<bool> updateDisplayName(String displayName) async {
    _setLoading(true);
    _clearError();

    try {
      await AuthService.instance.updateDisplayName(displayName);

      // Refresh current user profile
      _currentUser = await AuthService.instance.getCurrentUserProfile();

      // Sync profile to cloud (only if email verified)
      if (_currentUser != null && !_currentUser!.isAnonymous) {
        final isVerified = await AuthService.instance
            .requireEmailVerification();
        if (isVerified) {
          await UserDataSyncService.instance.syncProfile();
        }
      } else {
        await UserDataSyncService.instance.syncProfile();
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Set user avatar
  Future<bool> setAvatar(UserAvatar avatar) async {
    _setLoading(true);
    _clearError();

    try {
      await AuthService.instance.setUserAvatar(avatar);

      // Refresh current user profile
      _currentUser = await AuthService.instance.getCurrentUserProfile();

      // Sync profile to cloud
      await UserDataSyncService.instance.syncProfile();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Clear custom avatar (revert to profile photo if available)
  Future<bool> clearAvatar() async {
    _setLoading(true);
    _clearError();

    try {
      await AuthService.instance.clearUserAvatar();

      // Refresh current user profile
      _currentUser = await AuthService.instance.getCurrentUserProfile();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount({String? password}) async {
    _setLoading(true);
    _clearError();

    try {
      final userId = _currentUser?.uid;
      final provider = _currentUser?.authProvider;

      // Check email verification for non-anonymous users
      if (_currentUser != null && !_currentUser!.isAnonymous) {
        final isVerified = await AuthService.instance
            .requireEmailVerification();
        if (!isVerified) {
          _setError('error_email_verification_required');
          _setLoading(false);
          return false;
        }
      }

      // Re-authenticate based on provider type
      if (provider == AuthProviderType.emailPassword) {
        if (password != null && password.isNotEmpty) {
          await AuthService.instance.reauthenticateWithPassword(password);
        }
      } else if (provider == AuthProviderType.google) {
        await AuthService.instance.reauthenticateWithGoogle();
      } else if (provider == AuthProviderType.apple) {
        await AuthService.instance.reauthenticateWithApple();
      } else if (provider == AuthProviderType.github) {
        await AuthService.instance.reauthenticateWithGitHub();
      }

      // Delete cloud data BEFORE deleting account
      // This preserves local storage while removing cloud backup
      if (userId != null) {
        try {
          await UserDataSyncService.instance.deleteCloudData(userId);
          await UserDataSyncService.instance.stopSync();
        } catch (e) {
          debugPrint('Failed to delete cloud data: $e');
          // Continue with account deletion even if cloud cleanup fails
        }
      }

      await AuthService.instance.deleteAccount();

      _currentUser = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Sign out
  Future<bool> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      // Stop cloud sync before signing out
      await UserDataSyncService.instance.stopSync();

      await AuthService.instance.signOut();

      _currentUser = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      // Handle FirebaseAuthException through the auth service
      try {
        return AuthService.instance.getFriendlyErrorMessage(error as dynamic);
      } catch (e) {
        return error.toString().replaceAll('Exception: ', '');
      }
    }
    return error.toString();
  }

  /// Test-only method to set current user directly for widget testing
  ///
  /// **WARNING**: This method bypasses all authentication logic and should
  /// ONLY be used in test environments. It does not:
  /// - Validate the user with Firebase Authentication
  /// - Update SharedPreferences or any persistent storage
  /// - Trigger authentication-related side effects
  /// - Initialize user-specific services or configurations
  ///
  /// **When to use**:
  /// - Widget tests that need a pre-authenticated user state
  /// - Unit tests for UI components that depend on user data
  /// - Testing user-specific UI flows without full auth setup
  ///
  /// **Limitations**:
  /// - Does not persist across test runs
  /// - May leave state inconsistent if other auth methods are called
  /// - Avatar and other user properties must be set manually if needed
  ///
  /// For integration tests or when testing actual authentication flows,
  /// use the proper sign-in methods instead.
  @visibleForTesting
  void setCurrentUserForTest(UserProfile? user) {
    _currentUser = user;
    notifyListeners();
  }
}
