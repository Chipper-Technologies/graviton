import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/common/haptic_gesture_detector.dart';
import 'package:graviton/services/haptic_feedback_service.dart';

void main() {
  group('HapticGestureDetector Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticGestureDetector child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticGestureDetector(
            onTap: () {},
            child: const Text('Test Widget'),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(HapticGestureDetector), findsOneWidget);
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticGestureDetector(
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
          child: HapticGestureDetector(
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
          child: HapticGestureDetector(
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
          child: HapticGestureDetector(
            onTap: null,
            child: const Text('Test Widget'),
          ),
        ),
      );

      // Should not throw when tapping with null callback
      await tester.tap(find.text('Test Widget'));
      await tester.pump();

      // No assertion needed - just checking it doesn't crash
    });

    testWidgets('should pass through all gesture properties', (tester) async {
      const behavior = HitTestBehavior.opaque;
      bool tapDown = false;
      bool tapUp = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticGestureDetector(
            onTap: () {},
            onTapDown: (details) => tapDown = true,
            onTapUp: (details) => tapUp = true,
            behavior: behavior,
            excludeFromSemantics: true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      final GestureDetector detector = tester.widget(
        find.byType(GestureDetector),
      );
      expect(detector.behavior, behavior);
      expect(detector.excludeFromSemantics, isTrue);

      // Test tap down and up
      await tester.tapAt(tester.getCenter(find.text('Test Widget')));
      await tester.pump();
      expect(tapDown, isTrue);
      expect(tapUp, isTrue);
    });

    testWidgets('should work when haptic feedback is disabled', (tester) async {
      HapticFeedbackService.instance.setEnabled(false);
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticGestureDetector(
            onTap: () => tapped = true,
            child: const Text('Test Widget'),
          ),
        ),
      );

      await tester.tap(find.text('Test Widget'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should handle multiple gesture types simultaneously', (
      tester,
    ) async {
      bool tapped = false;
      bool longPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticGestureDetector(
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
      expect(tapped, isFalse); // Should not trigger tap
    });

    testWidgets('should handle tap cancel correctly', (tester) async {
      bool tapCancelled = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticGestureDetector(
            onTap: () {},
            onTapCancel: () => tapCancelled = true,
            child: const SizedBox(
              width: 100,
              height: 100,
              child: Text('Test Widget'),
            ),
          ),
        ),
      );

      // Start a tap but don't complete it
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.text('Test Widget')),
      );
      await tester.pump();

      // Move the finger away to cancel the tap
      await gesture.moveTo(const Offset(200, 200));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(tapCancelled, isTrue);
    });
  });
}
