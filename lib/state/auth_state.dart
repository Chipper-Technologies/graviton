import 'package:flutter/material.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/services/auth_service.dart';

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
      _setError(_getErrorMessage(e));
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
      // Re-authenticate if password provided
      if (password != null && password.isNotEmpty) {
        await AuthService.instance.reauthenticateWithPassword(password);
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
  @visibleForTesting
  void setCurrentUserForTest(UserProfile? user) {
    _currentUser = user;
    notifyListeners();
  }
}
