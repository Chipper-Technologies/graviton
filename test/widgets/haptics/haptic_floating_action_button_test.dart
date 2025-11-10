import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_floating_action_button.dart';
import 'package:graviton/services/haptic_feedback_service.dart';

void main() {
  group('HapticFloatingActionButton Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticFloatingActionButton child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    group('Standard FloatingActionButton', () {
      testWidgets('should render correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        );

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(HapticFloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('should call onPressed when tapped', (tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () => pressed = true,
              child: const Icon(Icons.add),
            ),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('should handle disabled button correctly', (tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: null, // Disabled
              child: const Icon(Icons.add),
            ),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(pressed, isFalse);
      });

      testWidgets('should pass through all FAB properties', (tester) async {
        const backgroundColor = Colors.red;
        const foregroundColor = Colors.white;
        const tooltip = 'Test tooltip';

        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              tooltip: tooltip,
              mini: true,
              elevation: 10.0,
              child: const Icon(Icons.add),
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.backgroundColor, backgroundColor);
        expect(fab.foregroundColor, foregroundColor);
        expect(fab.tooltip, tooltip);
        expect(fab.mini, isTrue);
        expect(fab.elevation, 10.0);
      });

      testWidgets('should work when haptic feedback is disabled', (
        tester,
      ) async {
        HapticFeedbackService.instance.setEnabled(false);
        bool pressed = false;

        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () => pressed = true,
              child: const Icon(Icons.add),
            ),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('should handle custom shape and clip behavior', (
        tester,
      ) async {
        const customShape = CircleBorder();
        const customClip = Clip.antiAlias;

        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              shape: customShape,
              clipBehavior: customClip,
              child: const Icon(Icons.add),
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.shape, customShape);
        expect(fab.clipBehavior, customClip);
      });

      testWidgets('should handle focus and hover properties', (tester) async {
        const focusColor = Colors.blue;
        const hoverColor = Colors.green;
        final focusNode = FocusNode();

        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              focusColor: focusColor,
              hoverColor: hoverColor,
              autofocus: true,
              focusNode: focusNode,
              child: const Icon(Icons.add),
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.focusColor, focusColor);
        expect(fab.hoverColor, hoverColor);
        expect(fab.autofocus, isTrue);
        expect(fab.focusNode, focusNode);

        focusNode.dispose();
      });
    });

    group('Extended FloatingActionButton', () {
      testWidgets('should render extended FAB correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ),
        );

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(HapticFloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Add Item'), findsOneWidget);
      });

      testWidgets('should render extended FAB without icon', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Add Item'),
            ),
          ),
        );

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('Add Item'), findsOneWidget);
        // Should not find icon when not provided
        expect(find.byIcon(Icons.add), findsNothing);
      });

      testWidgets('should call onPressed when tapped on extended FAB', (
        tester,
      ) async {
        bool pressed = false;
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton.extended(
              onPressed: () => pressed = true,
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('should handle disabled extended FAB correctly', (
        tester,
      ) async {
        bool pressed = false;
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton.extended(
              onPressed: null, // Disabled
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(pressed, isFalse);
      });

      testWidgets('should pass through extended FAB properties', (
        tester,
      ) async {
        const backgroundColor = Colors.purple;
        const foregroundColor = Colors.yellow;
        const tooltip = 'Extended tooltip';

        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              tooltip: tooltip,
              elevation: 8.0,
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.backgroundColor, backgroundColor);
        expect(fab.foregroundColor, foregroundColor);
        expect(fab.tooltip, tooltip);
        expect(fab.elevation, 8.0);
      });

      testWidgets('should create proper Row layout with icon and label', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ),
        );

        // Should find both icon and text (they should be in a Row widget inside the FAB)
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Add Item'), findsOneWidget);
        // Should find SizedBox for spacing between icon and label
        expect(find.byType(SizedBox), findsWidgets);

        // Verify the Row exists within the FloatingActionButton
        final fabFinder = find.byType(FloatingActionButton);
        expect(
          find.descendant(of: fabFinder, matching: find.byIcon(Icons.add)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: fabFinder, matching: find.text('Add Item')),
          findsOneWidget,
        );
      });

      testWidgets(
        'should work with extended FAB when haptic feedback is disabled',
        (tester) async {
          HapticFeedbackService.instance.setEnabled(false);
          bool pressed = false;

          await tester.pumpWidget(
            createTestWidget(
              child: HapticFloatingActionButton.extended(
                onPressed: () => pressed = true,
                label: const Text('Add Item'),
              ),
            ),
          );

          await tester.tap(find.byType(FloatingActionButton));
          await tester.pump();

          expect(pressed, isTrue);
        },
      );
    });

    group('MaterialTapTargetSize and Mouse Cursor', () {
      testWidgets('should handle MaterialTapTargetSize', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: const Icon(Icons.add),
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.materialTapTargetSize, MaterialTapTargetSize.shrinkWrap);
      });

      testWidgets('should handle custom mouse cursor', (tester) async {
        const customCursor = SystemMouseCursors.forbidden;

        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              mouseCursor: customCursor,
              child: const Icon(Icons.add),
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.mouseCursor, customCursor);
      });
    });

    group('Elevation Properties', () {
      testWidgets('should handle all elevation properties', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              elevation: 6.0,
              focusElevation: 8.0,
              hoverElevation: 10.0,
              highlightElevation: 12.0,
              disabledElevation: 0.0,
              child: const Icon(Icons.add),
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.elevation, 6.0);
        expect(fab.focusElevation, 8.0);
        expect(fab.hoverElevation, 10.0);
        expect(fab.highlightElevation, 12.0);
        expect(fab.disabledElevation, 0.0);
      });
    });

    group('Accessibility and Feedback', () {
      testWidgets('should handle enableFeedback property', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticFloatingActionButton(
              onPressed: () {},
              enableFeedback: false,
              child: const Icon(Icons.add),
            ),
          ),
        );

        final FloatingActionButton fab = tester.widget(
          find.byType(FloatingActionButton),
        );
        expect(fab.enableFeedback, false);
      });
    });
  });
}
