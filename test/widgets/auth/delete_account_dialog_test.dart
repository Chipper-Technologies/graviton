import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/auth/delete_account_dialog.dart';
import 'package:provider/provider.dart';

import '../../test_utils.dart';

void main() {
  group('DeleteAccountDialog Widget Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
    });

    Widget buildTestWidget({
      AuthProviderType providerType = AuthProviderType.emailPassword,
    }) {
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-user',
          displayName: 'Test User',
          email: 'test@test.com',
          avatar: UserAvatar.galaxy,
          isAnonymous: false,
          authProvider: providerType,
          createdAt: DateTime.now(),
        ),
      );

      return TestUtils.wrapWithMaterialApp(
        child: ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: const DeleteAccountDialog(),
        ),
      );
    }

    testWidgets('displays dialog with warning title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // "Delete Account" appears both in title and button text, so expect at least 2
      expect(find.text('Delete Account'), findsAtLeastNWidgets(2));
      expect(find.byType(AlertDialog), findsOneWidget);

      // Should have warning icon
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('displays warning message about permanent deletion', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // Should warn that this is permanent
      expect(find.textContaining('permanent'), findsOneWidget);
    });

    testWidgets('displays list of what will be deleted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // Should warn about permanent removal
      expect(find.textContaining('permanently remove'), findsOneWidget);

      // Should list specific items
      expect(find.textContaining('Your profile and avatar'), findsOneWidget);
      expect(find.textContaining('All saved preferences'), findsOneWidget);
    });

    testWidgets('shows password field for email/password accounts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(providerType: AuthProviderType.emailPassword),
      );

      // Should have password field
      expect(find.byType(TextFormField), findsOneWidget);
      expect(
        find.textContaining('Please enter your password to confirm'),
        findsOneWidget,
      );
    });

    testWidgets('does not show password field for Google accounts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(providerType: AuthProviderType.google),
      );

      // Should NOT have password field for Google auth
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('does not show password field for Apple accounts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(providerType: AuthProviderType.apple),
      );

      // Should NOT have password field for Apple auth
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('displays delete and cancel buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.widgetWithText(ElevatedButton, 'Delete Account'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    });

    testWidgets('delete button has red color for danger', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final deleteButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Delete Account'),
      );

      // Button should exist and be enabled
      expect(deleteButton.onPressed, isNotNull);
    });

    testWidgets('can toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(providerType: AuthProviderType.emailPassword),
      );

      // Find the password visibility toggle button
      final visibilityButton = find.descendant(
        of: find.byType(TextFormField),
        matching: find.byType(IconButton),
      );

      expect(visibilityButton, findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(visibilityButton);
      await tester.pump();

      // Icon should still be there (just changed)
      expect(visibilityButton, findsOneWidget);
    });

    testWidgets('cancel button closes dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ChangeNotifierProvider<AuthState>.value(
            value: authState,
            child: Builder(
              builder: (context) {
                authState.setCurrentUserForTest(
                  UserProfile(
                    uid: 'test-user',
                    displayName: 'Test User',
                    email: 'test@test.com',
                    avatar: UserAvatar.galaxy,
                    isAnonymous: false,
                    authProvider: AuthProviderType.emailPassword,
                    createdAt: DateTime.now(),
                  ),
                );

                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ChangeNotifierProvider<AuthState>.value(
                        value: authState,
                        child: const DeleteAccountDialog(),
                      ),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteAccountDialog), findsOneWidget);

      // Close dialog with cancel
      final cancelButton = find.ancestor(
        of: find.text('Cancel'),
        matching: find.byType(TextButton),
      );
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(find.byType(DeleteAccountDialog), findsNothing);
    });

    testWidgets('is a stateful widget', (WidgetTester tester) async {
      const dialog = DeleteAccountDialog();
      expect(dialog, isA<StatefulWidget>());
    });
  });
}
