import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graviton/core/constants/premium_constants.dart';
import 'package:graviton/features/premium/domain/usage_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for tracking user's premium usage
///
/// Tracks session counts and durations to enforce free tier limits.
/// Data is persisted locally and resets daily at midnight UTC.
class UsageTrackingService {
  static UsageTrackingService? _instance;
  static UsageTrackingService get instance =>
      _instance ??= UsageTrackingService._();

  UsageTrackingService._();

  SharedPreferences? _prefs;
  UsageData _usageData = UsageData.empty;
  bool _initialized = false;

  /// Current usage data
  UsageData get usageData => _usageData;

  /// Whether the service is initialized
  bool get isInitialized => _initialized;

  /// Initialize the usage tracking service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadUsageData();
      _initialized = true;
    } catch (e) {
      debugPrint('UsageTrackingService initialization failed: $e');
      _usageData = UsageData.empty;
      _initialized = true;
    }
  }

  /// Load usage data from SharedPreferences
  Future<void> _loadUsageData() async {
    final json = _prefs?.getString(PremiumConstants.dailySessionCountKey);
    if (json == null) {
      _usageData = UsageData.empty;
      return;
    }

    try {
      final data = UsageData.fromJson(jsonDecode(json) as Map<String, dynamic>);

      // Reset if not today's data
      if (!data.isToday) {
        _usageData = UsageData.empty;
        await _saveUsageData();
      } else {
        _usageData = data;
      }
    } catch (e) {
      debugPrint('Failed to load usage data: $e');
      _usageData = UsageData.empty;
    }
  }

  /// Save usage data to SharedPreferences
  Future<void> _saveUsageData() async {
    try {
      await _prefs?.setString(
        PremiumConstants.dailySessionCountKey,
        jsonEncode(_usageData.toJson()),
      );
    } catch (e) {
      debugPrint('Failed to save usage data: $e');
    }
  }

  /// Start a new session
  Future<void> startSession() async {
    if (!_initialized) await initialize();

    // Check if we need to reset (new day)
    if (!_usageData.isToday) {
      _usageData = UsageData.empty;
    }

    _usageData = _usageData.copyWith(
      sessionsHostedToday: _usageData.sessionsHostedToday + 1,
      currentSessionStart: DateTime.now(),
    );

    await _saveUsageData();
  }

  /// End the current session
  Future<void> endSession() async {
    if (!_initialized) await initialize();

    if (!_usageData.isInSession) return;

    final sessionDuration = _usageData.currentSessionDurationSeconds;
    _usageData = _usageData.copyWith(
      totalSessionTimeSeconds:
          _usageData.totalSessionTimeSeconds + sessionDuration,
      clearCurrentSession: true,
    );

    await _saveUsageData();
  }

  /// Check if user can start a new session (within daily limit)
  bool canStartSession(int dailyLimit) {
    if (!_usageData.isToday) return true;
    return _usageData.sessionsHostedToday < dailyLimit;
  }

  /// Get remaining sessions for today
  int getRemainingSessionsToday(int dailyLimit) {
    if (!_usageData.isToday) return dailyLimit;
    return (dailyLimit - _usageData.sessionsHostedToday).clamp(0, dailyLimit);
  }

  /// Get current session duration in seconds
  int getCurrentSessionDuration() {
    return _usageData.currentSessionDurationSeconds;
  }

  /// Check if current session has exceeded duration limit
  bool hasExceededDurationLimit(int limitMinutes) {
    final limitSeconds = limitMinutes * 60;
    return getCurrentSessionDuration() >= limitSeconds;
  }

  /// Get remaining time in current session (in seconds)
  int getRemainingSessionTime(int limitMinutes) {
    final limitSeconds = limitMinutes * 60;
    final remaining = limitSeconds - getCurrentSessionDuration();
    return remaining.clamp(0, limitSeconds);
  }

  /// Reset all usage data (for testing or premium upgrade)
  Future<void> resetUsage() async {
    _usageData = UsageData.empty;
    await _saveUsageData();
  }

  /// Reset for testing purposes
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
  }

  /// Set instance for testing
  @visibleForTesting
  static void setInstance(UsageTrackingService service) {
    _instance = service;
  }
}
