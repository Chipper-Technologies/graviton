import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HapticIconButton Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticIconButton child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: () {},
            icon: const Icon(Icons.star),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byType(HapticIconButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: () => pressed = true,
            icon: const Icon(Icons.star),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should handle disabled button correctly', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: null, // Disabled
            icon: const Icon(Icons.star),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('should pass through all button properties', (tester) async {
      const iconSize = 32.0;
      const color = AppColors.uiRed;
      const tooltip = 'Test Tooltip';

      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: () {},
            icon: const Icon(Icons.star),
            iconSize: iconSize,
            color: color,
            tooltip: tooltip,
            autofocus: true,
          ),
        ),
      );

      final IconButton button = tester.widget(find.byType(IconButton));
      expect(button.iconSize, iconSize);
      expect(button.color, color);
      expect(button.tooltip, tooltip);
      expect(button.autofocus, isTrue);
    });

    testWidgets('should work when haptic feedback is disabled', (tester) async {
      HapticFeedbackService.instance.setEnabled(false);
      bool pressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: () => pressed = true,
            icon: const Icon(Icons.star),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should handle different icon types', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: () => pressed = true,
            icon: const Icon(Icons.favorite),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(pressed, isTrue);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should handle constraints and padding', (tester) async {
      const constraints = BoxConstraints(minWidth: 48, minHeight: 48);
      const padding = EdgeInsets.all(8.0);

      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: () {},
            icon: const Icon(Icons.star),
            constraints: constraints,
            padding: padding,
          ),
        ),
      );

      final IconButton button = tester.widget(find.byType(IconButton));
      expect(button.constraints, constraints);
      expect(button.padding, padding);
    });

    testWidgets('should handle alignment and splash radius', (tester) async {
      const alignment = Alignment.topLeft;
      const splashRadius = 20.0;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticIconButton(
            onPressed: () {},
            icon: const Icon(Icons.star),
            alignment: alignment,
            splashRadius: splashRadius,
          ),
        ),
      );

      final IconButton button = tester.widget(find.byType(IconButton));
      expect(button.alignment, alignment);
      expect(button.splashRadius, splashRadius);
    });
  });
}
