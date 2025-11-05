import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/common/action_option.dart';

void main() {
  group('ActionOption', () {
    testWidgets('renders correctly with all properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Test Action',
              description: 'This is a test action',
              icon: Icons.star,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the title is displayed
      expect(find.text('Test Action'), findsOneWidget);

      // Verify the description is displayed
      expect(find.text('This is a test action'), findsOneWidget);

      // Verify the icon is displayed
      expect(find.byIcon(Icons.star), findsOneWidget);

      // Verify the arrow indicator is displayed
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // Verify the InkWell exists
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('handles tap correctly', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Tap Test',
              description: 'Test description',
              icon: Icons.touch_app,
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Tap the action option
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(buttonPressed, isTrue);
    });

    testWidgets('renders primary variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Primary Action',
              description: 'Primary action description',
              icon: Icons.priority_high,
              isPrimary: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the content is rendered
      expect(find.text('Primary Action'), findsOneWidget);
      expect(find.text('Primary action description'), findsOneWidget);
      expect(find.byIcon(Icons.priority_high), findsOneWidget);
    });

    testWidgets('renders secondary variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Secondary Action',
              description: 'Secondary action description',
              icon: Icons.low_priority,
              isPrimary: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the content is rendered
      expect(find.text('Secondary Action'), findsOneWidget);
      expect(find.text('Secondary action description'), findsOneWidget);
      expect(find.byIcon(Icons.low_priority), findsOneWidget);
    });

    testWidgets('displays icon with correct styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Icon Test',
              description: 'Testing icon display',
              icon: Icons.settings,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the icon container
      final iconContainerFinder = find
          .descendant(
            of: find.byType(ActionOption),
            matching: find.byType(Container),
          )
          .first;

      expect(iconContainerFinder, findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('has correct layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Layout Test',
              description: 'Testing layout structure',
              icon: Icons.view_list,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the main container structure
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('handles rapid taps correctly', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Rapid Tap Test',
              description: 'Testing rapid taps',
              icon: Icons.speed,
              onPressed: () {
                tapCount++;
              },
            ),
          ),
        ),
      );

      // Rapidly tap multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(InkWell));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Verify all taps were registered
      expect(tapCount, equals(5));
    });

    testWidgets('maintains consistency across rebuilds', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Consistency Test',
              description: 'Testing consistency',
              icon: Icons.sync,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Consistency Test'), findsOneWidget);
      expect(find.text('Testing consistency'), findsOneWidget);

      // Rebuild with same properties
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Consistency Test',
              description: 'Testing consistency',
              icon: Icons.sync,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify state is still consistent
      expect(find.text('Consistency Test'), findsOneWidget);
      expect(find.text('Testing consistency'), findsOneWidget);
    });

    testWidgets('displays arrow indicator correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionOption(
              title: 'Arrow Test',
              description: 'Testing arrow indicator',
              icon: Icons.arrow_back,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the arrow indicator exists
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // Verify there are exactly two icons (the main icon and the arrow)
      expect(find.byType(Icon), findsNWidgets(2));
    });

    testWidgets('handles different icon types', (WidgetTester tester) async {
      final List<IconData> testIcons = [
        Icons.home,
        Icons.settings,
        Icons.person,
        Icons.favorite,
        Icons.star,
      ];

      for (final icon in testIcons) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ActionOption(
                title: 'Icon Test',
                description: 'Testing different icons',
                icon: icon,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Verify the specific icon is displayed
        expect(find.byIcon(icon), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('handles long text correctly', (WidgetTester tester) async {
      const longTitle =
          'This is a very long title that might wrap to multiple lines';
      const longDescription =
          'This is a very long description that definitely should wrap to multiple lines and test the layout behavior of the ActionOption widget when dealing with extended text content.';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // Constrain width to force wrapping
              child: ActionOption(
                title: longTitle,
                description: longDescription,
                icon: Icons.text_fields,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify the text is displayed (even if wrapped)
      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longDescription), findsOneWidget);
    });
  });
}
