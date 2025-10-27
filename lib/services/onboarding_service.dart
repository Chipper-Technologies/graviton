import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage first-time user experience and tutorial state
class OnboardingService {
  static const String _keyHasSeenTutorial = 'has_seen_tutorial';
  static const String _keyTutorialCompleted = 'tutorial_completed';

  /// Check if user has seen the tutorial before
  static Future<bool> hasSeenTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyHasSeenTutorial) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark tutorial as seen
  static Future<void> markTutorialSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyHasSeenTutorial, true);
    } catch (e) {
      // Ignore errors in test environment
    }
  }

  /// Check if tutorial was completed
  static Future<bool> hasTutorialCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyTutorialCompleted) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark tutorial as completed
  static Future<void> markTutorialCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyTutorialCompleted, true);
      await prefs.setBool(_keyHasSeenTutorial, true);
    } catch (e) {
      // Ignore errors in test environment
    }
  }

  /// Reset tutorial state (for testing or user preference)
  static Future<void> resetTutorialState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyHasSeenTutorial);
      await prefs.remove(_keyTutorialCompleted);
    } catch (e) {
      // Ignore errors in test environment
    }
  }
}
