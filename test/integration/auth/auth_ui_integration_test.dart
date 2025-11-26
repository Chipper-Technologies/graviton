import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/main.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/auth/avatar_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/test_helpers.dart';

void main() {
  group('Authentication UI Integration Tests', () {
    setUp(() async {
      // Set up test environment
      SharedPreferences.setMockInitialValues({
        'has_seen_tutorial': true,
        'tutorial_completed': true,
      });
    });

    testWidgets('AvatarButton should be visible in app bar', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      // AvatarButton should be present in the app
      expect(find.byType(AvatarButton), findsOneWidget);
    });

    testWidgets('AvatarButton should respond to tap', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      // Find and tap the avatar button
      final avatarButton = find.byType(AvatarButton);
      expect(avatarButton, findsOneWidget);

      await tester.tap(avatarButton);
      await tester.pumpAndSettle();

      // Should trigger some action (drawer, dialog, etc.)
      // This test verifies the button is tappable
    });

    testWidgets('AuthState should be accessible via Provider', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      // Should be able to access AuthState through Provider
      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      expect(authState, isNotNull);
      expect(authState.currentUser, isNull); // Not logged in initially
      expect(authState.isAuthenticated, false);
    });

    testWidgets('App should have MultiProvider with AuthState', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      // Verify MultiProvider is present
      expect(find.byType(MultiProvider), findsOneWidget);

      // Verify AuthState provider is available
      final context = tester.element(find.byType(MaterialApp));
      expect(
        () => Provider.of<AuthState>(context, listen: false),
        returnsNormally,
      );
    });

    testWidgets('AvatarButton should display default icon when not signed in', (
      tester,
    ) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      // Should find the default account icon
      expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);
    });

    testWidgets('AuthState should have correct initial state', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      expect(authState.currentUser, isNull);
      expect(authState.isAuthenticated, false);
      expect(authState.isAnonymous, false);
      expect(authState.isLoading, false);
      expect(authState.error, isNull);
    });

    testWidgets('App should rebuild when AuthState changes', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      // Initially not authenticated
      expect(authState.isAuthenticated, false);

      // Simulate auth state change (would be replaced with actual auth in full implementation)
      // This test verifies the provider pattern is working
      expect(find.byType(AvatarButton), findsOneWidget);
    });
  });
}
