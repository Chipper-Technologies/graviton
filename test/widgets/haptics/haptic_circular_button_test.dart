import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/haptic_feedback_type.dart';
import 'package:graviton/widgets/haptics/haptic_circular_button.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HapticCircularButton Widget Tests', () {
    testWidgets('renders with default styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton(icon: Icons.star, onTap: () {}),
          ),
        ),
      );

      // Verify button is rendered
      expect(find.byType(HapticCircularButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);

      // Verify default styling is applied
      final containerFinder = find.descendant(
        of: find.byType(HapticCircularButton),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('handles tap events and calls callback', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton(
              icon: Icons.star,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(HapticCircularButton));
      await tester.pump();

      // Verify callback was called
      expect(tapped, isTrue);
    });

    testWidgets('applies custom styling correctly', (
      WidgetTester tester,
    ) async {
      const customSize = 100.0;
      const customIconSize = 50.0;
      const customColor = AppColors.uiRed;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton(
              icon: Icons.star,
              onTap: () {},
              size: customSize,
              iconSize: customIconSize,
              iconColor: customColor,
              backgroundColor: AppColors.primaryColor,
              borderColor: AppColors.uiGreen,
            ),
          ),
        ),
      );

      // Verify custom styling is applied
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(HapticCircularButton),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints!.maxWidth, equals(customSize));
      expect(container.constraints!.maxHeight, equals(customSize));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
    });

    testWidgets(
      'factory constructor creates edit button with correct styling',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: HapticCircularButton.edit(onTap: () {})),
          ),
        );

        // Verify edit icon is present
        expect(find.byIcon(Icons.edit), findsOneWidget);

        // Verify button is rendered
        expect(find.byType(HapticCircularButton), findsOneWidget);
      },
    );

    testWidgets(
      'factory constructor creates delete button with correct styling',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: HapticCircularButton.delete(onTap: () {})),
          ),
        );

        // Verify delete icon is present
        expect(find.byIcon(Icons.delete_outline), findsOneWidget);

        // Verify button is rendered
        expect(find.byType(HapticCircularButton), findsOneWidget);
      },
    );

    testWidgets('applies semantic accessibility properties', (
      WidgetTester tester,
    ) async {
      const semanticsLabel = 'Test button';
      const semanticsHint = 'This is a test button';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton(
              icon: Icons.star,
              onTap: () {},
              semanticsLabel: semanticsLabel,
              semanticsHint: semanticsHint,
            ),
          ),
        ),
      );

      // Verify semantics are applied (checking through the semantics widget)
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.button == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders tooltip when provided', (WidgetTester tester) async {
      const tooltipText = 'Test tooltip';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton(
              icon: Icons.star,
              onTap: () {},
              tooltip: tooltipText,
            ),
          ),
        ),
      );

      // Verify tooltip widget is present
      expect(find.byType(Tooltip), findsOneWidget);

      // Get the tooltip widget and verify its message
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, equals(tooltipText));
    });

    testWidgets('handles different haptic feedback types', (
      WidgetTester tester,
    ) async {
      // This test verifies that the widget accepts different haptic feedback types
      // without throwing errors. Testing actual haptic feedback would require
      // platform-specific testing or mocking.

      for (final hapticType in HapticFeedbackType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HapticCircularButton(
                icon: Icons.star,
                onTap: () {},
                hapticFeedbackType: hapticType,
              ),
            ),
          ),
        );

        // Verify the widget renders without error
        expect(find.byType(HapticCircularButton), findsOneWidget);

        // Clear the widget before next iteration
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });

    testWidgets('works without optional parameters', (
      WidgetTester tester,
    ) async {
      // Test minimal configuration
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton(icon: Icons.star, onTap: () {}),
          ),
        ),
      );

      // Verify it renders without optional parameters
      expect(find.byType(HapticCircularButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('multiple buttons work independently', (
      WidgetTester tester,
    ) async {
      bool button1Tapped = false;
      bool button2Tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                HapticCircularButton(
                  icon: Icons.edit,
                  onTap: () => button1Tapped = true,
                ),
                HapticCircularButton(
                  icon: Icons.delete,
                  onTap: () => button2Tapped = true,
                ),
              ],
            ),
          ),
        ),
      );

      // Verify both buttons are rendered
      expect(find.byType(HapticCircularButton), findsNWidgets(2));
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // Tap first button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(button1Tapped, isTrue);
      expect(button2Tapped, isFalse);

      // Tap second button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(button1Tapped, isTrue);
      expect(button2Tapped, isTrue);
    });
  });

  group('HapticCircularButton Factory Constructor Tests', () {
    testWidgets('edit factory creates button with edit styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton.edit(
              onTap: () {},
              semanticsLabel: 'Edit item',
              semanticsHint: 'Edit this item',
              tooltip: 'Edit',
            ),
          ),
        ),
      );

      // Verify edit-specific properties
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byType(Tooltip), findsOneWidget);

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, equals('Edit'));
    });

    testWidgets('delete factory creates button with delete styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton.delete(
              onTap: () {},
              semanticsLabel: 'Delete item',
              semanticsHint: 'Delete this item',
              tooltip: 'Delete',
            ),
          ),
        ),
      );

      // Verify delete-specific properties
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.byType(Tooltip), findsOneWidget);

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, equals('Delete'));
    });

    testWidgets('factory constructors work without optional parameters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                HapticCircularButton.edit(onTap: () {}),
                HapticCircularButton.delete(onTap: () {}),
              ],
            ),
          ),
        ),
      );

      // Verify both buttons render correctly
      expect(find.byType(HapticCircularButton), findsNWidgets(2));
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });
  });

  group('HapticCircularButton Integration Tests', () {
    testWidgets('integrates well with existing UI components', (
      WidgetTester tester,
    ) async {
      // Test integration with common UI patterns
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Test'),
              actions: [
                HapticCircularButton(icon: Icons.settings, onTap: () {}),
              ],
            ),
            body: ListView(
              children: [
                ListTile(
                  title: const Text('Item 1'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HapticCircularButton.edit(onTap: () {}),
                      const SizedBox(width: 8),
                      HapticCircularButton.delete(onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify all buttons are rendered correctly
      expect(find.byType(HapticCircularButton), findsNWidgets(3));
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('maintains functionality in scrollable lists', (
      WidgetTester tester,
    ) async {
      final tappedItems = <int>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                  trailing: HapticCircularButton.delete(
                    onTap: () => tappedItems.add(index),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Tap a few buttons
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline).at(2));
      await tester.pump();

      // Verify callbacks were called with correct indices
      expect(tappedItems, equals([0, 2]));
    });

    testWidgets('HapticCircularButton.play factory creates play button', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton.play(
              onTap: () => tapped = true,
              tooltip: 'Play',
              semanticsLabel: 'Play simulation',
            ),
          ),
        ),
      );

      // Verify play icon is rendered
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      // Verify tooltip is set
      expect(find.byTooltip('Play'), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(HapticCircularButton));
      await tester.pump();

      // Verify callback was called
      expect(tapped, isTrue);
    });

    testWidgets('HapticCircularButton.pause factory creates pause button', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton.pause(
              onTap: () => tapped = true,
              tooltip: 'Pause',
              semanticsLabel: 'Pause simulation',
            ),
          ),
        ),
      );

      // Verify pause icon is rendered
      expect(find.byIcon(Icons.pause), findsOneWidget);

      // Verify tooltip is set
      expect(find.byTooltip('Pause'), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(HapticCircularButton));
      await tester.pump();

      // Verify callback was called
      expect(tapped, isTrue);
    });

    testWidgets('HapticCircularButton.reset factory creates reset button', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticCircularButton.reset(
              onTap: () => tapped = true,
              tooltip: 'Reset',
              semanticsLabel: 'Reset simulation',
            ),
          ),
        ),
      );

      // Verify refresh icon is rendered
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Verify tooltip is set
      expect(find.byTooltip('Reset'), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(HapticCircularButton));
      await tester.pump();

      // Verify callback was called
      expect(tapped, isTrue);
    });
  });
}
