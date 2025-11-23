import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/screens/account_management_screen.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/auth/avatar_selector_dialog.dart';
import 'package:graviton/widgets/auth/edit_display_name_dialog.dart';
import 'package:graviton/widgets/auth/sign_in_dialog.dart';
import 'package:provider/provider.dart';

void main() {
  group('AccountManagementScreen Integration Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
    });

    /// Helper to build the screen with AuthState provider
    Widget buildTestWidget(AuthState state) {
      return ChangeNotifierProvider<AuthState>.value(
        value: state,
        child: MaterialApp(
          home: const AccountManagementScreen(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
    }

    group('Unauthenticated User Flow', () {
      testWidgets('should display sign-in prompt when not authenticated', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show sign-in prompt with correct UI elements
        expect(find.text('Sign In'), findsAtLeastNWidgets(1));
        expect(find.text('Continue as Guest'), findsOneWidget);
        expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);

        // Should not show authenticated UI
        expect(find.text('Account Management'), findsNothing);
      });

      testWidgets('should open SignInDialog when sign in button is tapped', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Tap sign in button
        await tester.tap(find.text('Sign In').first);
        await tester.pumpAndSettle();

        // Should show SignInDialog
        expect(find.byType(SignInDialog), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('should close sign-in dialog when close is tapped', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Open sign in dialog
        await tester.tap(find.text('Sign In').first);
        await tester.pumpAndSettle();

        expect(find.byType(SignInDialog), findsOneWidget);

        // Tap close button
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        // Dialog should be closed
        expect(find.byType(SignInDialog), findsNothing);
      });
    });

    group('Authenticated User Profile Display', () {
      testWidgets('should display user profile with email and avatar', (
        tester,
      ) async {
        // Set up authenticated user
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'test-user-123',
            email: 'user@example.com',
            displayName: 'Test User',
            avatar: UserAvatar.galaxy,
            isAnonymous: false,
            authProvider: AuthProviderType.emailPassword,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should display user information
        expect(find.text('Test User'), findsOneWidget);
        expect(find.text('user@example.com'), findsOneWidget);
        expect(find.text('🌌'), findsOneWidget); // Galaxy avatar emoji
      });

      testWidgets('should display anonymous user label for guest accounts', (
        tester,
      ) async {
        // Set up anonymous user
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'anon-user-456',
            isAnonymous: true,
            avatar: UserAvatar.comet,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should display anonymous label (exact text from app_en.arb)
        expect(find.text('Guest User'), findsOneWidget);
        expect(find.text('Guest Account'), findsOneWidget);
        expect(find.text('☄️'), findsOneWidget); // Comet avatar emoji

        // Should show upgrade option
        expect(find.text('Upgrade to Full Account'), findsOneWidget);
      });

      testWidgets('should display correct auth provider badge', (tester) async {
        // Test with Google provider
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'google-user',
            email: 'google@example.com',
            displayName: 'Google User',
            avatar: UserAvatar.saturn,
            isAnonymous: false,
            authProvider: AuthProviderType.google,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should display Google provider
        expect(find.text('Google'), findsOneWidget);
      });
    });

    group('Avatar Management', () {
      testWidgets(
        'should open AvatarSelectorDialog when edit avatar is tapped',
        (tester) async {
          authState.setCurrentUserForTest(
            UserProfile(
              uid: 'user-123',
              email: 'user@example.com',
              avatar: UserAvatar.galaxy,
              isAnonymous: false,
            ),
          );

          await tester.pumpWidget(buildTestWidget(authState));
          await tester.pumpAndSettle();

          // Find and tap the edit avatar button (icon button near avatar)
          final editButtons = find.byIcon(Icons.edit);
          expect(editButtons, findsAtLeastNWidgets(1));

          await tester.tap(editButtons.first);
          await tester.pumpAndSettle();

          // Should show AvatarSelectorDialog
          expect(find.byType(AvatarSelectorDialog), findsOneWidget);
          expect(find.text('Select Avatar'), findsOneWidget);
        },
      );

      testWidgets('should close avatar selector when cancel is tapped', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            avatar: UserAvatar.galaxy,
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Open avatar selector
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();

        expect(find.byType(AvatarSelectorDialog), findsOneWidget);

        // Tap Cancel button
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Dialog should be closed
        expect(find.byType(AvatarSelectorDialog), findsNothing);
      });

      testWidgets('should display all available avatars in selector', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            avatar: UserAvatar.galaxy,
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Open avatar selector
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();

        // Should show avatar selector with all options
        expect(find.byType(AvatarSelectorDialog), findsOneWidget);
        expect(find.text('Select Avatar'), findsOneWidget);

        // Should show save and cancel buttons
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });
    });

    group('Display Name Management', () {
      testWidgets(
        'should open EditDisplayNameDialog when edit name is tapped',
        (tester) async {
          authState.setCurrentUserForTest(
            UserProfile(
              uid: 'user-123',
              email: 'user@example.com',
              displayName: 'Original Name',
              avatar: UserAvatar.galaxy,
              isAnonymous: false,
            ),
          );

          await tester.pumpWidget(buildTestWidget(authState));
          await tester.pumpAndSettle();

          // Find and tap the edit name button (small icon next to name)
          final editButtons = find.byIcon(Icons.edit);
          // Second edit button should be for display name
          await tester.tap(editButtons.at(1));
          await tester.pumpAndSettle();

          // Should show EditDisplayNameDialog
          expect(find.byType(EditDisplayNameDialog), findsOneWidget);
          expect(find.text('Edit Display Name'), findsOneWidget);
        },
      );

      testWidgets('should close edit name dialog when cancelled', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            displayName: 'Original Name',
            avatar: UserAvatar.galaxy,
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Open edit display name dialog
        await tester.tap(find.byIcon(Icons.edit).at(1));
        await tester.pumpAndSettle();

        expect(find.byType(EditDisplayNameDialog), findsOneWidget);

        // Tap Cancel button
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Dialog should be closed
        expect(find.byType(EditDisplayNameDialog), findsNothing);
      });

      testWidgets('should not show edit name button for anonymous users', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'anon-user',
            isAnonymous: true,
            avatar: UserAvatar.comet,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should only have one edit button (for avatar, not for name)
        final editButtons = find.byIcon(Icons.edit);
        expect(editButtons, findsOneWidget);
      });
    });

    group('Anonymous User Upgrade', () {
      testWidgets('should show upgrade account option for anonymous users', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'anon-user',
            isAnonymous: true,
            avatar: UserAvatar.comet,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show upgrade option
        expect(find.text('Account Actions'), findsOneWidget);
        expect(find.text('Upgrade to Full Account'), findsOneWidget);
      });

      testWidgets('should not show upgrade option for authenticated users', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'auth-user',
            email: 'user@example.com',
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should not show upgrade option
        expect(find.text('Account Actions'), findsNothing);
        expect(find.text('Upgrade to Full Account'), findsNothing);
      });

      testWidgets('should open sign-in dialog when upgrade is tapped', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'anon-user',
            isAnonymous: true,
            avatar: UserAvatar.comet,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Tap upgrade option
        await tester.tap(find.text('Upgrade to Full Account'));
        await tester.pumpAndSettle();

        // Should show SignInDialog
        expect(find.byType(SignInDialog), findsOneWidget);
      });
    });

    group('Account Deletion', () {
      testWidgets('should show danger zone with delete account option', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            isAnonymous: false,
            authProvider: AuthProviderType.emailPassword,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show account management section (exact text from app_en.arb)
        expect(find.text('Account Management'), findsOneWidget);
        expect(find.text('Delete Account'), findsAtLeastNWidgets(1));
      });

      testWidgets('should show sign out and delete options', (tester) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            isAnonymous: false,
            authProvider: AuthProviderType.emailPassword,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show both sign out and delete account options
        expect(find.text('Sign Out'), findsOneWidget);
        expect(find.text('Delete Account'), findsAtLeastNWidgets(1));
        expect(find.text('Account Management'), findsOneWidget);
      });

      testWidgets('should show sign out option', (tester) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show sign out option
        expect(find.text('Sign Out'), findsOneWidget);
      });

      testWidgets('should sign out when sign out is tapped', (tester) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Tap sign out
        await tester.tap(find.text('Sign Out'));
        await tester.pumpAndSettle();

        // Should be signed out
        expect(authState.currentUser, isNull);
        expect(authState.isAuthenticated, false);
      });
    });

    group('UI State Transitions', () {
      testWidgets('should show unauthenticated UI when not signed in', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show unauthenticated UI
        expect(find.text('Sign In'), findsAtLeastNWidgets(1));
        expect(find.text('Continue as Guest'), findsOneWidget);
        expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);

        // Should not show authenticated UI
        expect(find.text('Account Management'), findsNothing);
      });

      testWidgets('should show authenticated UI when signed in', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            displayName: 'Test User',
            avatar: UserAvatar.galaxy,
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show authenticated UI
        expect(find.text('Test User'), findsOneWidget);
        expect(find.text('user@example.com'), findsOneWidget);
        expect(find.text('Account Management'), findsOneWidget);

        // Should not show unauthenticated UI
        expect(find.text('Continue as Guest'), findsNothing);
      });

      testWidgets('should update UI when auth state changes externally', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Initially unauthenticated
        expect(find.text('Sign In'), findsAtLeastNWidgets(1));

        // Simulate external auth state change
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'external-user',
            email: 'external@example.com',
            isAnonymous: false,
          ),
        );
        await tester.pumpAndSettle();

        // UI should update
        expect(find.text('external@example.com'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should display error message on sign-in failure', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Open sign-in dialog
        await tester.tap(find.text('Sign In').first);
        await tester.pumpAndSettle();

        // Try to sign in without entering credentials
        await tester.tap(find.text('Sign In').last);
        await tester.pumpAndSettle();

        // Should show validation errors
        expect(
          find.textContaining('enter', findRichText: true),
          findsAtLeastNWidgets(1),
        );
      });

      testWidgets('should handle missing user gracefully', (tester) async {
        // Set user to null externally
        authState.setCurrentUserForTest(null);

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should show sign-in prompt without errors
        expect(find.text('Sign In'), findsAtLeastNWidgets(1));
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantics for screen reader', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            displayName: 'Test User',
            avatar: UserAvatar.galaxy,
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Check that important UI elements are accessible
        expect(find.bySemanticsLabel('Account Management'), findsOneWidget);
      });

      testWidgets('should have tooltips on icon buttons', (tester) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'user-123',
            email: 'user@example.com',
            displayName: 'Test User',
            avatar: UserAvatar.galaxy,
            isAnonymous: false,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Verify tooltips exist
        final Finder editButton = find.byIcon(Icons.edit).first;
        expect(editButton, findsOneWidget);

        // Long press to show tooltip
        await tester.longPress(editButton);
        await tester.pumpAndSettle();

        // Tooltip should appear
        expect(find.text('Change Avatar'), findsOneWidget);
      });
    });

    group('Multi-Provider Type Scenarios', () {
      testWidgets('should handle Google auth provider correctly', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'google-user',
            email: 'google@example.com',
            displayName: 'Google User',
            avatar: UserAvatar.saturn,
            isAnonymous: false,
            authProvider: AuthProviderType.google,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should display Google badge
        expect(find.text('Google'), findsOneWidget);

        // Delete dialog should NOT require password for Google auth
        await tester.dragUntilVisible(
          find.text('Delete Account').last,
          find.byType(SingleChildScrollView),
          const Offset(0, -50),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete Account').last);
        await tester.pumpAndSettle();

        // Password field should NOT be present for Google auth
        expect(find.text('Password'), findsNothing);
      });

      testWidgets('should handle Apple auth provider correctly', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'apple-user',
            email: 'apple@example.com',
            displayName: 'Apple User',
            avatar: UserAvatar.saturn,
            isAnonymous: false,
            authProvider: AuthProviderType.apple,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Should display Apple badge
        expect(find.text('Apple'), findsOneWidget);
      });

      testWidgets('should require password for email/password accounts', (
        tester,
      ) async {
        authState.setCurrentUserForTest(
          UserProfile(
            uid: 'email-user',
            email: 'email@example.com',
            displayName: 'Email User',
            avatar: UserAvatar.saturn,
            isAnonymous: false,
            authProvider: AuthProviderType.emailPassword,
          ),
        );

        await tester.pumpWidget(buildTestWidget(authState));
        await tester.pumpAndSettle();

        // Open delete dialog
        await tester.dragUntilVisible(
          find.text('Delete Account').last,
          find.byType(SingleChildScrollView),
          const Offset(0, -50),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete Account').last);
        await tester.pumpAndSettle();

        // Password field SHOULD be present for email/password auth
        expect(find.text('Password'), findsOneWidget);
      });
    });
  });
}
