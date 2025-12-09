import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/shared/widgets/controls/rainbow_border_button.dart';

void main() {
  group('RainbowBorderButton', () {
    testWidgets('should render with icon', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RainbowBorderButton(
              icon: Icons.star,
              label: 'Test Button',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byType(RainbowBorderButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isTrue);
    });

    testWidgets('should render with SVG asset path', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RainbowBorderButton(
              assetPath: 'assets/images/google-logo.svg',
              label: 'Google Button',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byType(RainbowBorderButton), findsOneWidget);
      expect(find.text('Google Button'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isTrue);
    });

    testWidgets('should have CustomPaint with GradientBorderPainter', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RainbowBorderButton(
              icon: Icons.account_circle,
              label: 'Test',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('should be full width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RainbowBorderButton(
              icon: Icons.login,
              label: 'Sign In',
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(RainbowBorderButton),
              matching: find.byType(SizedBox),
            )
            .first,
      );

      expect(sizedBox.width, equals(double.infinity));
    });

    test('should assert when neither icon nor assetPath is provided', () {
      expect(
        () => RainbowBorderButton(label: 'Test', onPressed: () {}),
        throwsAssertionError,
      );
    });
  });
}
