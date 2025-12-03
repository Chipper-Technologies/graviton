import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HapticInkWell Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticInkWell child}) {
      return MaterialApp(
        home: Scaffold(body: Material(child: child)),
      );
    }

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(onTap: () {}, child: const Text('Test Widget')),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(HapticInkWell), findsOneWidget);
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onTap: () => tapped = true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      await tester.tap(find.text('Test Widget'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should call onLongPress when long pressed', (tester) async {
      bool longPressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onLongPress: () => longPressed = true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      await tester.longPress(find.text('Test Widget'));
      await tester.pump();

      expect(longPressed, isTrue);
    });

    testWidgets('should call onDoubleTap when double tapped', (tester) async {
      bool doubleTapped = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onDoubleTap: () => doubleTapped = true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      await tester.tap(find.text('Test Widget'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Test Widget'));
      await tester.pumpAndSettle(); // Wait for all animations and timers

      expect(doubleTapped, isTrue);
    });

    testWidgets('should handle null callbacks gracefully', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(onTap: null, child: const Text('Test Widget')),
        ),
      );

      // Should not throw when tapping with null callback
      await tester.tap(find.text('Test Widget'));
      await tester.pump();

      // No assertion needed - just checking it doesn't crash
    });

    testWidgets('should pass through all InkWell properties', (tester) async {
      const splashColor = AppColors.uiRed;
      const highlightColor = AppColors.primaryColor;
      const borderRadius = BorderRadius.all(Radius.circular(8));

      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onTap: () {},
            splashColor: splashColor,
            highlightColor: highlightColor,
            borderRadius: borderRadius,
            autofocus: true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      final InkWell inkWell = tester.widget(find.byType(InkWell));
      expect(inkWell.splashColor, splashColor);
      expect(inkWell.highlightColor, highlightColor);
      expect(inkWell.borderRadius, borderRadius);
      expect(inkWell.autofocus, isTrue);
    });

    testWidgets('should work when haptic feedback is disabled', (tester) async {
      HapticFeedbackService.instance.setEnabled(false);
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onTap: () => tapped = true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      await tester.tap(find.text('Test Widget'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should handle multiple gesture types', (tester) async {
      bool tapped = false;
      bool longPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onTap: () => tapped = true,
            onLongPress: () => longPressed = true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      // Test tap
      await tester.tap(find.text('Test Widget'));
      await tester.pump();
      expect(tapped, isTrue);

      // Reset and test long press
      tapped = false;
      await tester.longPress(find.text('Test Widget'));
      await tester.pump();
      expect(longPressed, isTrue);
    });

    testWidgets('should handle ink effects correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onTap: () {},
            enableFeedback: false,
            excludeFromSemantics: true,
            child: const SizedBox(
              width: 100,
              height: 100,
              child: Text('Test Widget'),
            ),
          ),
        ),
      );

      final InkWell inkWell = tester.widget(find.byType(InkWell));
      expect(inkWell.enableFeedback, isFalse);
      expect(inkWell.excludeFromSemantics, isTrue);

      // Tap to trigger ink effect
      await tester.tap(find.text('Test Widget'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should handle mouse events', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onTap: () {},
            onHover: (hovering) {
              // Handler exists but we don't need to test actual hover behavior
              // in the test environment as it's platform-dependent
            },
            child: const Text('Test Widget'),
          ),
        ),
      );

      // Just verify the widget renders with hover callback without crashing
      expect(find.byType(InkWell), findsOneWidget);

      // Test that it still responds to tap
      await tester.tap(find.text('Test Widget'));
      await tester.pump();
    });

    testWidgets('should handle focus correctly', (tester) async {
      bool focusChanged = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticInkWell(
            onTap: () {},
            onFocusChange: (focused) => focusChanged = focused,
            canRequestFocus: true,
            autofocus: true, // Auto focus to trigger the callback
            child: const Text('Test Widget'),
          ),
        ),
      );

      final InkWell inkWell = tester.widget(find.byType(InkWell));
      expect(inkWell.canRequestFocus, isTrue);

      // Wait for autofocus to take effect
      await tester.pumpAndSettle();

      // The autofocus should have triggered the focus callback
      expect(focusChanged, isTrue);
    });
  });
}
