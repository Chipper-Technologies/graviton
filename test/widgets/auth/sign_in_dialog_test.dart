import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/widgets/auth/sign_in_dialog.dart';
import 'package:provider/provider.dart';

import '../../test_utils.dart';

void main() {
  group('SignInDialog Widget Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
    });

    Widget buildTestWidget({Widget? child}) {
      return TestUtils.wrapWithMaterialApp(
        child: ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: child ?? const SignInDialog(),
        ),
      );
    }

    testWidgets('displays email and password fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // Should have email field
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);

      // Should have password field
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    });

    testWidgets('displays sign in button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('can toggle between sign in and create account', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially shows "Sign In" button
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);

      // Find and tap the "Need an account? Create One" toggle
      await tester.tap(find.text('Need an account? Create One'));
      await tester.pumpAndSettle();

      // Now shows "Create Account" button
      expect(
        find.widgetWithText(ElevatedButton, 'Create Account'),
        findsOneWidget,
      );

      // Find and tap the "Sign In" toggle to go back
      await tester.tap(find.text('Already have an account? Sign In'));
      await tester.pumpAndSettle();

      // Back to "Sign In" button
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('can toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find the password visibility toggle button
      final visibilityButton = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(IconButton),
      );

      expect(visibilityButton, findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(visibilityButton);
      await tester.pump();

      // Icon should change (but still an IconButton)
      expect(visibilityButton, findsOneWidget);
    });

    testWidgets('displays social auth buttons', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Should have Google sign-in button
      expect(find.text('Continue with Google'), findsOneWidget);

      // Should have guest mode button
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('is a stateful widget', (WidgetTester tester) async {
      const dialog = SignInDialog();
      expect(dialog, isA<StatefulWidget>());
    });

    testWidgets('closes when close is tapped in dialog', (
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
                    child: const SignInDialog(),
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

      expect(find.byType(SignInDialog), findsOneWidget);

      // Find and tap close button
      final closeButton = find.ancestor(
        of: find.text('Close'),
        matching: find.byType(TextButton),
      );
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.byType(SignInDialog), findsNothing);
    });
  });
}
