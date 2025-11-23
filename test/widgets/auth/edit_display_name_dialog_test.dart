import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/auth/edit_display_name_dialog.dart';
import 'package:provider/provider.dart';

import '../../test_utils.dart';

void main() {
  group('EditDisplayNameDialog Widget Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-user',
          displayName: 'Original Name',
          email: 'test@test.com',
          avatar: UserAvatar.galaxy,
          isAnonymous: false,
          authProvider: AuthProviderType.emailPassword,
          createdAt: DateTime.now(),
        ),
      );
    });

    Widget buildTestWidget({String? currentName}) {
      return TestUtils.wrapWithMaterialApp(
        child: ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: EditDisplayNameDialog(currentName: currentName),
        ),
      );
    }

    testWidgets('displays dialog with title', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Edit Display Name'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('displays text field with current name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(currentName: 'Test User'));

      // Should have a TextFormField
      expect(find.byType(TextFormField), findsOneWidget);

      // The field should contain the current name
      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller?.text, 'Test User');
    });

    testWidgets('displays save button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    });

    testWidgets('validates minimum name length', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter a name that's too short (1 character)
      await tester.enterText(find.byType(TextFormField), 'A');
      await tester.pump();

      // Try to save
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('validates empty name', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(currentName: 'Test'));

      // Clear the text
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Try to save
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter a display name'), findsOneWidget);
    });

    testWidgets('accepts valid name', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter a valid name
      await tester.enterText(find.byType(TextFormField), 'New Valid Name');
      await tester.pump();

      // Save button should be enabled
      final saveButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Save'),
      );
      expect(saveButton.onPressed, isNotNull);
    });

    testWidgets('closes dialog when cancel is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ChangeNotifierProvider<AuthState>.value(
            value: authState,
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ChangeNotifierProvider<AuthState>.value(
                      value: authState,
                      child: const EditDisplayNameDialog(currentName: 'Test'),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(EditDisplayNameDialog), findsOneWidget);

      // Close dialog with cancel
      final cancelButton = find.ancestor(
        of: find.text('Cancel'),
        matching: find.byType(TextButton),
      );
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(find.byType(EditDisplayNameDialog), findsNothing);
    });

    testWidgets('is a stateful widget', (WidgetTester tester) async {
      const dialog = EditDisplayNameDialog();
      expect(dialog, isA<StatefulWidget>());
    });

    testWidgets('handles null current name', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(currentName: null));

      // Should still display the text field
      expect(find.byType(TextFormField), findsOneWidget);

      // Field should be empty
      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller?.text, isEmpty);
    });
  });
}
