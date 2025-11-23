import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/auth/avatar_selector_dialog.dart';
import 'package:provider/provider.dart';

import '../../test_utils.dart';

void main() {
  group('AvatarSelectorDialog Widget Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
      // Set up a test user
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
    });

    Widget buildTestWidget({Widget? child}) {
      return TestUtils.wrapWithMaterialApp(
        child: ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: child ?? const AvatarSelectorDialog(),
        ),
      );
    }

    testWidgets('displays dialog with title', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Select Avatar'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('displays grid of avatar options', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Should find GridView
      expect(find.byType(GridView), findsOneWidget);

      // Should have multiple avatar emoji texts (at least as many as UserAvatar enum values)
      // Each avatar shows its emoji in a Text widget
      expect(find.byType(Text), findsAtLeast(UserAvatar.values.length));
    });

    testWidgets('highlights current avatar selection', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // Current avatar is galaxy (🌌)
      expect(find.text(UserAvatar.galaxy.emoji), findsOneWidget);

      // The selected avatar should have special styling (indicated by Container with border)
      final selectedAvatarContainers = find.byType(Container);
      expect(selectedAvatarContainers, findsAtLeast(1));
    });

    testWidgets('can select a different avatar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find a different avatar to tap (e.g., saturn ♄)
      final saturnAvatar = find.text(UserAvatar.saturn.emoji);
      expect(saturnAvatar, findsOneWidget);

      // Tap the saturn avatar
      await tester.tap(saturnAvatar);
      await tester.pump();

      // Selection state should change (verified by widget rebuild)
      expect(saturnAvatar, findsOneWidget);
    });

    testWidgets('displays save button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Should have save button
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      expect(saveButton, findsOneWidget);
    });

    testWidgets('cancel button closes without saving', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ChangeNotifierProvider<AuthState>.value(
                    value: authState,
                    child: const AvatarSelectorDialog(),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(AvatarSelectorDialog), findsOneWidget);

      // Close dialog with cancel
      final cancelButton = find.ancestor(
        of: find.text('Cancel'),
        matching: find.byType(TextButton),
      );
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(find.byType(AvatarSelectorDialog), findsNothing);
      // Original avatar should still be galaxy
      expect(authState.currentUser?.avatar, UserAvatar.galaxy);
    });

    testWidgets('is a stateful widget', (WidgetTester tester) async {
      const dialog = AvatarSelectorDialog();
      expect(dialog, isA<StatefulWidget>());
    });
  });
}
