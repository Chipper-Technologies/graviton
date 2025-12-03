import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HapticElevatedButton Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticElevatedButton child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticElevatedButton(
            onPressed: () {},
            child: const Text('Test Button'),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(HapticElevatedButton), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticElevatedButton(
            onPressed: () => pressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should call onLongPress when long pressed', (tester) async {
      bool longPressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticElevatedButton(
            onPressed: () {},
            onLongPress: () => longPressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.longPress(find.byType(ElevatedButton));
      await tester.pump();

      expect(longPressed, isTrue);
    });

    testWidgets('should handle disabled button correctly', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticElevatedButton(
            onPressed: null, // Disabled
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('should pass through all button properties', (tester) async {
      const style = ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.uiRed),
      );

      await tester.pumpWidget(
        createTestWidget(
          child: HapticElevatedButton(
            onPressed: () {},
            style: style,
            autofocus: true,
            child: const Text('Test Button'),
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.style, style);
      expect(button.autofocus, isTrue);
    });

    testWidgets('should work when haptic feedback is disabled', (tester) async {
      HapticFeedbackService.instance.setEnabled(false);
      bool pressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticElevatedButton(
            onPressed: () => pressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should handle both onPressed and onLongPress', (tester) async {
      bool pressed = false;
      bool longPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticElevatedButton(
            onPressed: () => pressed = true,
            onLongPress: () => longPressed = true,
            child: const Text('Test Button'),
          ),
        ),
      );

      // Test normal press
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(pressed, isTrue);
      expect(longPressed, isFalse);

      // Reset and test long press
      pressed = false;
      await tester.longPress(find.byType(ElevatedButton));
      await tester.pump();
      expect(pressed, isFalse);
      expect(longPressed, isTrue);
    });
  });
}
