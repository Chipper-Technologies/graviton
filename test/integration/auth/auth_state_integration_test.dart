import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/main.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/auth/avatar_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/test_helpers.dart';

void main() {
  group('Authentication State Integration Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'has_seen_tutorial': true,
        'tutorial_completed': true,
      });
    });

    testWidgets('App should update UI when user signs in', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      // Initially should show default icon
      expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);

      // Simulate sign in
      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          isAnonymous: false,
          avatar: UserAvatar.earth,
          authProvider: AuthProviderType.emailPassword,
        ),
      );

      await tester.pump();

      // Should now show avatar emoji
      expect(find.text(UserAvatar.earth.emoji), findsOneWidget);
      expect(find.byIcon(Icons.account_circle_outlined), findsNothing);
    });

    testWidgets('App should update UI when user signs out', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      // Sign in first
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          isAnonymous: false,
          avatar: UserAvatar.mars,
          authProvider: AuthProviderType.google,
        ),
      );

      await tester.pump();
      expect(find.text(UserAvatar.mars.emoji), findsOneWidget);

      // Sign out
      authState.setCurrentUserForTest(null);
      await tester.pump();

      // Should return to default icon
      expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);
      expect(find.text(UserAvatar.mars.emoji), findsNothing);
    });

    testWidgets('Multiple widgets should update when auth state changes', (
      tester,
    ) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      // Verify AvatarButton is present
      expect(find.byType(AvatarButton), findsOneWidget);

      // Sign in
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          isAnonymous: false,
          avatar: UserAvatar.jupiter,
          authProvider: AuthProviderType.google,
        ),
      );

      await tester.pump();

      // AvatarButton should update
      expect(find.text(UserAvatar.jupiter.emoji), findsOneWidget);
    });

    testWidgets('Auth state should persist across rebuilds', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      // Sign in
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          isAnonymous: false,
          avatar: UserAvatar.saturn,
          authProvider: AuthProviderType.emailPassword,
        ),
      );

      await tester.pump();
      expect(find.text(UserAvatar.saturn.emoji), findsOneWidget);

      // Trigger a rebuild
      await tester.pump();

      // Auth state should still be present
      expect(find.text(UserAvatar.saturn.emoji), findsOneWidget);
      expect(authState.currentUser, isNotNull);
      expect(authState.currentUser!.displayName, 'Test User');
    });

    testWidgets('Anonymous user should be distinguishable', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      // Create anonymous user
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'anon-uid',
          email: null,
          displayName: null,
          isAnonymous: true,
          authProvider: AuthProviderType.anonymous,
        ),
      );

      await tester.pump();

      // Check auth state flags
      expect(authState.currentUser, isNotNull);
      expect(authState.isAnonymous, true);
      expect(authState.isAuthenticated, false);
    });

    testWidgets('Authenticated user should be distinguishable from anonymous', (
      tester,
    ) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      // Create authenticated user
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'user-uid',
          email: 'user@example.com',
          displayName: 'Real User',
          isAnonymous: false,
          authProvider: AuthProviderType.emailPassword,
        ),
      );

      await tester.pump();

      // Check auth state flags
      expect(authState.currentUser, isNotNull);
      expect(authState.isAnonymous, false);
      expect(authState.isAuthenticated, true);
    });

    testWidgets('Custom avatar should take precedence over photo URL', (
      tester,
    ) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      final context = tester.element(find.byType(MaterialApp));
      final authState = Provider.of<AuthState>(context, listen: false);

      // Create user with both photo and avatar
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'user-with-photo',
          email: 'photo@example.com',
          displayName: 'Photo User',
          photoUrl: 'https://example.com/photo.jpg',
          avatar: UserAvatar.venus,
          isAnonymous: false,
          authProvider: AuthProviderType.google,
        ),
      );

      await tester.pump();

      // Custom avatar takes precedence over photoUrl
      // Should show emoji
      expect(find.text(UserAvatar.venus.emoji), findsOneWidget);

      // Should not show network photo in avatar button
      // (Note: App logo may be present, so we check for NetworkImage specifically)
      final images = find.byType(Image).evaluate();
      final hasNetworkImage = images.any((element) {
        final widget = element.widget as Image;
        final provider = widget.image;
        // Check if it's a NetworkImage or ResizeImage wrapping NetworkImage
        if (provider is ResizeImage) {
          return provider.imageProvider is NetworkImage;
        }
        return provider is NetworkImage;
      });
      expect(hasNetworkImage, false);
    });
  });
}
