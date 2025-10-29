import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/app_state.dart';

/// Test utilities for common test patterns
class TestHelpers {
  /// Initialize AppState with timeout to prevent hanging in tests
  static Future<void> initializeAppStateWithTimeout(AppState appState) async {
    await appState.initializeAsync().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('AppState initialization timed out, using defaults');
      },
    );
  }

  /// Pump timers that are commonly created by the app UI
  /// This prevents "pending timer" test failures
  static Future<void> pumpAppTimers(WidgetTester tester) async {
    // Pump timers in the order they typically fire:
    await tester.pump(const Duration(milliseconds: 500)); // Home screen timer
    await tester.pump(
      const Duration(seconds: 1),
    ); // First time user check timer
    await tester.pump(const Duration(seconds: 3)); // Auto-hide timer
  }

  /// Complete initialization and pump common timers
  static Future<void> setupAndPumpApp(
    WidgetTester tester,
    AppState appState,
    Widget app,
  ) async {
    await initializeAppStateWithTimeout(appState);
    await tester.pumpWidget(app);
    await tester.pump(const Duration(milliseconds: 100));
    await pumpAppTimers(tester);
  }
}
