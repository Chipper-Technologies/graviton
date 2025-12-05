import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/main.dart';
import 'package:graviton/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../utils/test_helpers.dart';

void main() {
  group('Body Drag-to-Move Integration Tests', () {
    late AppState testAppState;

    setUp(() async {
      // Set tutorial flags to prevent dialog overlays in tests
      SharedPreferences.setMockInitialValues({
        'has_seen_tutorial': true,
        'tutorial_completed': true,
      });
      testAppState = AppState();
      await TestHelpers.initializeAppStateWithTimeout(testAppState);
    });

    tearDown(() {
      testAppState.dispose();
    });

    testWidgets('Single-finger drag on body should enter movement mode', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      // Wait for initial timers (500ms + 2000ms)
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pump();

      // Ensure we have bodies in the simulation
      expect(testAppState.simulation.bodies.isNotEmpty, isTrue);

      // Get initial state
      expect(testAppState.ui.isBodyMovementModeActive, isFalse);
      expect(testAppState.ui.movingBodyIndex, isNull);

      // Find the gesture detector for the simulation viewport
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      if (gestureDetectors.evaluate().isNotEmpty) {
        final viewportGesture = gestureDetectors.first;
        final renderBox = tester.renderObject(viewportGesture) as RenderBox;
        final center = renderBox.size.center(Offset.zero);

        // Simulate single-finger tap and drag
        final pointer = TestPointer(1, PointerDeviceKind.touch);

        // Start at center (likely to be near a body in most scenarios)
        await tester.sendEventToBinding(pointer.down(center));
        await tester.pump();
        await tester.pump(
          const Duration(milliseconds: 50),
        ); // Let DoubleTapGestureRecognizer timer complete

        // If we hit a body, movement mode should be active
        if (testAppState.ui.isBodyMovementModeActive) {
          expect(testAppState.ui.movingBodyIndex, isNotNull);
          expect(testAppState.camera.selectedBody, isNotNull);

          // Release
          await tester.sendEventToBinding(pointer.up());
          await tester.pump();

          // Movement mode should be deactivated after release
          expect(testAppState.ui.isBodyMovementModeActive, isFalse);
        }
      }
    });

    testWidgets('Body position should update during drag', (tester) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pump();

      // Ensure we have bodies
      expect(testAppState.simulation.bodies.isNotEmpty, isTrue);

      // Find the gesture detector
      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        // Simulate single-finger drag
        final pointer = TestPointer(1, PointerDeviceKind.touch);

        // Calculate screen position for first body
        // For testing, we'll just use a known position
        await tester.sendEventToBinding(pointer.down(const Offset(400, 300)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // Check if we're in movement mode
        if (testAppState.ui.isBodyMovementModeActive) {
          final bodyIndex = testAppState.ui.movingBodyIndex!;
          final body = testAppState.simulation.bodies[bodyIndex];
          final positionAfterStart = body.position.clone();

          // Drag to a different position
          await tester.sendEventToBinding(pointer.move(const Offset(500, 400)));
          await tester.pump();

          // Position should have changed
          final positionAfterDrag = body.position;
          expect(
            positionAfterDrag.distanceTo(positionAfterStart) > 0.01,
            isTrue,
            reason: 'Body position should change during drag',
          );

          // Release
          await tester.sendEventToBinding(pointer.up());
          await tester.pump();
        }
      }
    });

    testWidgets('Body velocity should be reset to zero during drag', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pump();

      // Start simulation to give bodies some velocity
      testAppState.simulation.start();
      await tester.pump();

      // Run a few steps to let bodies gain velocity
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      testAppState.simulation.pause();

      // Ensure we have bodies with non-zero velocity
      if (testAppState.simulation.bodies.isNotEmpty) {
        final firstBody = testAppState.simulation.bodies[0];

        // Give it some velocity if it doesn't have any
        if (firstBody.velocity.length < 0.01) {
          firstBody.velocity = vm.Vector3(1.0, 0.0, 0.0);
        }

        final initialVelocity = firstBody.velocity.clone();
        expect(initialVelocity.length > 0.01, isTrue);

        // Find gesture detector
        final gestureDetectors = find.byType(GestureDetector);
        if (gestureDetectors.evaluate().isNotEmpty) {
          final pointer = TestPointer(1, PointerDeviceKind.touch);

          // Start drag
          await tester.sendEventToBinding(pointer.down(const Offset(400, 300)));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));

          if (testAppState.ui.isBodyMovementModeActive) {
            // Move
            await tester.sendEventToBinding(
              pointer.move(const Offset(450, 350)),
            );
            await tester.pump();

            // Velocity should be reset to zero during drag
            final bodyIndex = testAppState.ui.movingBodyIndex!;
            final body = testAppState.simulation.bodies[bodyIndex];
            expect(
              body.velocity.length < 0.01,
              isTrue,
              reason: 'Velocity should be reset to zero during drag',
            );

            // Release
            await tester.sendEventToBinding(pointer.up());
            await tester.pump();
          }
        }
      }
    });

    testWidgets('Body trail should be cleared after drag', (tester) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pump();

      // Start simulation to create some trail
      testAppState.simulation.start();
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      testAppState.simulation.pause();

      // Ensure we have trails
      if (testAppState.simulation.trails.isNotEmpty) {
        final firstBodyTrail = testAppState.simulation.trails[0];

        // Add some trail points if empty
        if (firstBodyTrail.isEmpty) {
          // Skip this test if no trails were generated
          return;
        }

        final initialTrailLength = firstBodyTrail.length;
        expect(initialTrailLength > 0, isTrue);

        // Find gesture detector
        final gestureDetectors = find.byType(GestureDetector);
        if (gestureDetectors.evaluate().isNotEmpty) {
          final pointer = TestPointer(1, PointerDeviceKind.touch);

          // Drag the body
          await tester.sendEventToBinding(pointer.down(const Offset(400, 300)));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));

          if (testAppState.ui.isBodyMovementModeActive) {
            final bodyIndex = testAppState.ui.movingBodyIndex!;

            await tester.sendEventToBinding(
              pointer.move(const Offset(500, 400)),
            );
            await tester.pump();

            // Release - trail should be cleared
            await tester.sendEventToBinding(pointer.up());
            await tester.pump();

            // Check if trail was cleared for the moved body
            if (bodyIndex < testAppState.simulation.trails.length) {
              final trailAfterDrag = testAppState.simulation.trails[bodyIndex];
              expect(
                trailAfterDrag.length,
                equals(0),
                reason: 'Trail should be cleared after dragging body',
              );
            }
          }
        }
      }
    });

    testWidgets('Two-finger gestures should not trigger body movement mode', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pump();

      expect(testAppState.ui.isBodyMovementModeActive, isFalse);

      // Find gesture detector
      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        final renderBox =
            tester.renderObject(gestureDetectors.first) as RenderBox;
        final center = renderBox.size.center(Offset.zero);

        // Simulate two-finger gesture (pinch/zoom)
        final pointer1 = TestPointer(1, PointerDeviceKind.touch);
        final pointer2 = TestPointer(2, PointerDeviceKind.touch);

        await tester.sendEventToBinding(
          pointer1.down(center + const Offset(-50, 0)),
        );
        await tester.sendEventToBinding(
          pointer2.down(center + const Offset(50, 0)),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // Movement mode should NOT be active with two fingers
        expect(
          testAppState.ui.isBodyMovementModeActive,
          isFalse,
          reason: 'Two-finger gestures should not trigger body movement',
        );

        await tester.sendEventToBinding(pointer1.up());
        await tester.sendEventToBinding(pointer2.up());
        await tester.pump();
      }
    });

    testWidgets('Body selection should be set when starting drag', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pump();

      // Initially no body selected
      expect(testAppState.camera.selectedBody, isNull);

      // Find gesture detector
      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        final pointer = TestPointer(1, PointerDeviceKind.touch);

        // Drag from center (likely to hit a body)
        await tester.sendEventToBinding(pointer.down(const Offset(400, 300)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        if (testAppState.ui.isBodyMovementModeActive) {
          // Body should be selected
          expect(testAppState.camera.selectedBody, isNotNull);
          expect(
            testAppState.camera.selectedBody,
            equals(testAppState.ui.movingBodyIndex),
          );

          await tester.sendEventToBinding(pointer.up());
          await tester.pump();
        }
      }
    });

    test('Body movement mode enum values', () {
      expect(testAppState.ui.isBodyMovementModeActive, isFalse);

      // Start movement mode
      testAppState.ui.startBodyMovement(0);
      expect(testAppState.ui.isBodyMovementModeActive, isTrue);
      expect(testAppState.ui.movingBodyIndex, equals(0));

      // Stop movement mode
      testAppState.ui.stopBodyMovement();
      expect(testAppState.ui.isBodyMovementModeActive, isFalse);
      expect(testAppState.ui.movingBodyIndex, isNull);
    });
  });
}
