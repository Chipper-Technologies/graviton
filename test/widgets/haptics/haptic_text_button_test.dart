import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:graviton/services/ui/haptic_feedback_service.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HapticTextButton Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticTextButton child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: () {},
            child: const Text('Test Button'),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(HapticTextButton), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: () => pressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should call onLongPress when long pressed', (tester) async {
      bool longPressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: () {},
            onLongPress: () => longPressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.longPress(find.byType(TextButton));
      await tester.pump();

      expect(longPressed, isTrue);
    });

    testWidgets('should handle disabled button correctly', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: null, // Disabled
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('should pass through all button properties', (tester) async {
      const style = ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.uiRed),
      );

      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: () {},
            style: style,
            autofocus: true,
            child: const Text('Test Button'),
          ),
        ),
      );

      final TextButton button = tester.widget(find.byType(TextButton));
      expect(button.style, style);
      expect(button.autofocus, isTrue);
    });

    testWidgets('should work when haptic feedback is disabled', (tester) async {
      HapticFeedbackService.instance.setEnabled(false);
      bool pressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: () => pressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should handle both onPressed and onLongPress', (tester) async {
      bool pressed = false;
      bool longPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: () => pressed = true,
            onLongPress: () => longPressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      // Test normal press
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      expect(pressed, isTrue);
      expect(longPressed, isFalse);

      // Reset and test long press
      pressed = false;
      await tester.longPress(find.byType(TextButton));
      await tester.pump();
      expect(pressed, isFalse);
      expect(longPressed, isTrue);
    });

    testWidgets('should handle child with icon and text', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticTextButton(
            onPressed: () => pressed = true,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.star), SizedBox(width: 8), Text('Star')],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(pressed, isTrue);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Star'), findsOneWidget);
    });
  });
}
