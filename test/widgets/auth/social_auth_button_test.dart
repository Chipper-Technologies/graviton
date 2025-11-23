import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/auth/social_auth_button.dart';

void main() {
  group('SocialAuthButton Widget Tests', () {
    testWidgets('should render with icon and label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.g_mobiledata,
              label: 'Continue with Google',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Should find the icon
      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);

      // Should find the label text
      expect(find.text('Continue with Google'), findsOneWidget);

      // Should find the OutlinedButton
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.apple,
              label: 'Continue with Apple',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(SocialAuthButton));
      await tester.pumpAndSettle();

      // Verify callback was called
      expect(wasPressed, true);
    });

    testWidgets('should display correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.person_outline,
              label: 'Continue as Guest',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the button
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));

      // Verify button styling
      final buttonStyle = button.style!;
      expect(buttonStyle.foregroundColor?.resolve({}), AppColors.uiWhite);

      // Button should have proper styling applied
      expect(buttonStyle, isNotNull);
    });

    testWidgets('should have icon before label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.g_mobiledata,
              label: 'Test Label',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the Row widget
      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(SocialAuthButton),
          matching: find.byType(Row),
        ),
      );

      // Verify children order: Icon, SizedBox, Text
      expect(row.children.length, 3);
      expect(row.children[0], isA<Icon>());
      expect(row.children[1], isA<SizedBox>());
      expect(row.children[2], isA<Text>());

      // Verify Row alignment
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should apply correct icon size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.apple,
              label: 'Apple Sign In',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the icon
      final icon = tester.widget<Icon>(find.byIcon(Icons.apple));

      // Verify icon size
      expect(icon.size, AppTypography.iconSizeMedium);
    });

    testWidgets('should apply correct text font size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.g_mobiledata,
              label: 'Google Sign In',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the Text widget
      final text = tester.widget<Text>(find.text('Google Sign In'));

      // Verify text style
      expect(text.style?.fontSize, AppTypography.fontSizeMedium);
    });

    testWidgets('should have correct spacing between icon and label', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.person_outline,
              label: 'Guest',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find all SizedBox widgets in the Row
      final sizedBoxes = find.descendant(
        of: find.byType(Row),
        matching: find.byType(SizedBox),
      );

      // Should have at least one SizedBox for spacing
      expect(sizedBoxes, findsAtLeastNWidgets(1));
    });

    testWidgets('should work with different icons', (tester) async {
      final icons = [
        Icons.g_mobiledata,
        Icons.apple,
        Icons.person_outline,
        Icons.facebook,
        Icons.email,
      ];

      for (final icon in icons) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SocialAuthButton(
                icon: icon,
                label: 'Test Button',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(icon), findsOneWidget);

        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should handle long label text', (tester) async {
      const longLabel =
          'Continue with a Very Long Authentication Provider Name';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.login,
              label: longLabel,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Should still find the text
      expect(find.text(longLabel), findsOneWidget);

      // Button should render without overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be tappable across entire button area', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: SocialAuthButton(
                  icon: Icons.g_mobiledata,
                  label: 'Test',
                  onPressed: () {
                    tapCount++;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap on different parts of the button
      await tester.tap(find.byIcon(Icons.g_mobiledata));
      await tester.pumpAndSettle();
      expect(tapCount, 1);

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();
      expect(tapCount, 2);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      expect(tapCount, 3);
    });

    testWidgets('should render correctly with MaterialApp theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SocialAuthButton(
              icon: Icons.apple,
              label: 'Apple',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Button should render without errors
      expect(find.byType(SocialAuthButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should have consistent appearance across multiple instances', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SocialAuthButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google',
                  onPressed: () {},
                ),
                SocialAuthButton(
                  icon: Icons.apple,
                  label: 'Apple',
                  onPressed: () {},
                ),
                SocialAuthButton(
                  icon: Icons.person_outline,
                  label: 'Guest',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // All three buttons should render
      expect(find.byType(SocialAuthButton), findsNWidgets(3));
      expect(find.byType(OutlinedButton), findsNWidgets(3));

      // Each should have their respective icons and labels
      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
      expect(find.byIcon(Icons.apple), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Guest'), findsOneWidget);
    });
  });
}
