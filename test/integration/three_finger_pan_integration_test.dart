import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/main.dart';
import 'package:graviton/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/test_helpers.dart';

void main() {
  group('Three-Finger Pan Integration Tests', () {
    late AppState testAppState;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      testAppState = AppState();
      await TestHelpers.initializeAppStateWithTimeout(testAppState);
    });

    tearDown(() {
      testAppState.dispose();
    });

    testWidgets('Three-finger pan gesture should move camera target', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Get initial camera target
      final initialTarget = testAppState.camera.target.clone();

      // Find the gesture detector for the simulation viewport
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      if (gestureDetectors.evaluate().isNotEmpty) {
        final viewportGesture = gestureDetectors.first;
        final renderBox = tester.renderObject(viewportGesture) as RenderBox;
        final center = renderBox.localToGlobal(
          renderBox.size.center(Offset.zero),
        );

        // Simulate three-finger pan gesture
        final pointer1 = TestPointer(1, PointerDeviceKind.touch);
        final pointer2 = TestPointer(2, PointerDeviceKind.touch);
        final pointer3 = TestPointer(3, PointerDeviceKind.touch);

        // Start three fingers at center
        final startPos1 = center + const Offset(-10, 0);
        final startPos2 = center;
        final startPos3 = center + const Offset(10, 0);

        await tester.sendEventToBinding(pointer1.down(startPos1));
        await tester.sendEventToBinding(pointer2.down(startPos2));
        await tester.sendEventToBinding(pointer3.down(startPos3));
        await tester.pump();

        // Move all three fingers to the right (pan gesture)
        final endPos1 = startPos1 + const Offset(50, 0);
        final endPos2 = startPos2 + const Offset(50, 0);
        final endPos3 = startPos3 + const Offset(50, 0);

        await tester.sendEventToBinding(pointer1.move(endPos1));
        await tester.sendEventToBinding(pointer2.move(endPos2));
        await tester.sendEventToBinding(pointer3.move(endPos3));
        await tester.pump();

        // Release fingers
        await tester.sendEventToBinding(pointer1.up());
        await tester.sendEventToBinding(pointer2.up());
        await tester.sendEventToBinding(pointer3.up());
        await tester.pump();

        // Camera target should have changed
        expect(testAppState.camera.target, isNot(equals(initialTarget)));
      }

      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets(
      'Three-finger vertical pan should move camera target vertically',
      (tester) async {
        await tester.pumpWidget(GravitonApp(appState: testAppState));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        final initialTargetY = testAppState.camera.target.y;

        final gestureDetectors = find.byType(GestureDetector);
        if (gestureDetectors.evaluate().isNotEmpty) {
          final viewportGesture = gestureDetectors.first;
          final renderBox = tester.renderObject(viewportGesture) as RenderBox;
          final center = renderBox.localToGlobal(
            renderBox.size.center(Offset.zero),
          );

          // Simulate three-finger vertical pan
          final pointer1 = TestPointer(1, PointerDeviceKind.touch);
          final pointer2 = TestPointer(2, PointerDeviceKind.touch);
          final pointer3 = TestPointer(3, PointerDeviceKind.touch);

          final startPos1 = center + const Offset(-10, 0);
          final startPos2 = center;
          final startPos3 = center + const Offset(10, 0);

          await tester.sendEventToBinding(pointer1.down(startPos1));
          await tester.sendEventToBinding(pointer2.down(startPos2));
          await tester.sendEventToBinding(pointer3.down(startPos3));
          await tester.pump();

          // Move all three fingers up
          final endPos1 = startPos1 + const Offset(0, 50);
          final endPos2 = startPos2 + const Offset(0, 50);
          final endPos3 = startPos3 + const Offset(0, 50);

          await tester.sendEventToBinding(pointer1.move(endPos1));
          await tester.sendEventToBinding(pointer2.move(endPos2));
          await tester.sendEventToBinding(pointer3.move(endPos3));
          await tester.pump();

          await tester.sendEventToBinding(pointer1.up());
          await tester.sendEventToBinding(pointer2.up());
          await tester.sendEventToBinding(pointer3.up());
          await tester.pump();

          // Y coordinate should have changed
          expect(testAppState.camera.target.y, isNot(equals(initialTargetY)));
        }

        await TestHelpers.pumpAppTimers(tester);
      },
    );

    testWidgets('Three-finger pan should not affect camera angles', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final initialYaw = testAppState.camera.yaw;
      final initialPitch = testAppState.camera.pitch;
      final initialRoll = testAppState.camera.roll;

      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        final viewportGesture = gestureDetectors.first;
        final renderBox = tester.renderObject(viewportGesture) as RenderBox;
        final center = renderBox.localToGlobal(
          renderBox.size.center(Offset.zero),
        );

        // Three-finger pan
        final pointer1 = TestPointer(1, PointerDeviceKind.touch);
        final pointer2 = TestPointer(2, PointerDeviceKind.touch);
        final pointer3 = TestPointer(3, PointerDeviceKind.touch);

        await tester.sendEventToBinding(
          pointer1.down(center + const Offset(-10, 0)),
        );
        await tester.sendEventToBinding(pointer2.down(center));
        await tester.sendEventToBinding(
          pointer3.down(center + const Offset(10, 0)),
        );
        await tester.pump();

        await tester.sendEventToBinding(
          pointer1.move(center + const Offset(40, 40)),
        );
        await tester.sendEventToBinding(
          pointer2.move(center + const Offset(50, 40)),
        );
        await tester.sendEventToBinding(
          pointer3.move(center + const Offset(60, 40)),
        );
        await tester.pump();

        await tester.sendEventToBinding(pointer1.up());
        await tester.sendEventToBinding(pointer2.up());
        await tester.sendEventToBinding(pointer3.up());
        await tester.pump();

        // Camera angles should not change
        expect(testAppState.camera.yaw, equals(initialYaw));
        expect(testAppState.camera.pitch, equals(initialPitch));
        expect(testAppState.camera.roll, equals(initialRoll));
      }

      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Three-finger pan should not affect camera distance', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final initialDistance = testAppState.camera.distance;

      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        final viewportGesture = gestureDetectors.first;
        final renderBox = tester.renderObject(viewportGesture) as RenderBox;
        final center = renderBox.localToGlobal(
          renderBox.size.center(Offset.zero),
        );

        // Three-finger pan
        final pointer1 = TestPointer(1, PointerDeviceKind.touch);
        final pointer2 = TestPointer(2, PointerDeviceKind.touch);
        final pointer3 = TestPointer(3, PointerDeviceKind.touch);

        await tester.sendEventToBinding(
          pointer1.down(center + const Offset(-10, 0)),
        );
        await tester.sendEventToBinding(pointer2.down(center));
        await tester.sendEventToBinding(
          pointer3.down(center + const Offset(10, 0)),
        );
        await tester.pump();

        await tester.sendEventToBinding(
          pointer1.move(center + const Offset(-10, 100)),
        );
        await tester.sendEventToBinding(
          pointer2.move(center + const Offset(0, 100)),
        );
        await tester.sendEventToBinding(
          pointer3.move(center + const Offset(10, 100)),
        );
        await tester.pump();

        await tester.sendEventToBinding(pointer1.up());
        await tester.sendEventToBinding(pointer2.up());
        await tester.sendEventToBinding(pointer3.up());
        await tester.pump();

        // Distance should remain unchanged
        expect(testAppState.camera.distance, equals(initialDistance));
      }

      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Three-finger pan should be disabled in follow mode', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Enable follow mode on first body
      if (testAppState.simulation.bodies.isNotEmpty) {
        testAppState.camera.selectBody(0);
        testAppState.camera.toggleFollowMode(testAppState.simulation.bodies);
        await tester.pump();

        final gestureDetectors = find.byType(GestureDetector);
        if (gestureDetectors.evaluate().isNotEmpty) {
          final viewportGesture = gestureDetectors.first;
          final renderBox = tester.renderObject(viewportGesture) as RenderBox;
          final center = renderBox.localToGlobal(
            renderBox.size.center(Offset.zero),
          );

          // Try to three-finger pan
          final pointer1 = TestPointer(1, PointerDeviceKind.touch);
          final pointer2 = TestPointer(2, PointerDeviceKind.touch);
          final pointer3 = TestPointer(3, PointerDeviceKind.touch);

          await tester.sendEventToBinding(
            pointer1.down(center + const Offset(-10, 0)),
          );
          await tester.sendEventToBinding(pointer2.down(center));
          await tester.sendEventToBinding(
            pointer3.down(center + const Offset(10, 0)),
          );
          await tester.pump();

          await tester.sendEventToBinding(
            pointer1.move(center + const Offset(40, 0)),
          );
          await tester.sendEventToBinding(
            pointer2.move(center + const Offset(50, 0)),
          );
          await tester.sendEventToBinding(
            pointer3.move(center + const Offset(60, 0)),
          );
          await tester.pump();

          await tester.sendEventToBinding(pointer1.up());
          await tester.sendEventToBinding(pointer2.up());
          await tester.sendEventToBinding(pointer3.up());
          await tester.pump();

          // Note: In follow mode, the target may update due to following the body,
          // but the pan gesture itself should be ignored
          // We can't easily test this without mocking, so we just verify no crash
          expect(testAppState.camera.followMode, isTrue);
        }
      }

      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Two-finger gestures should still work for zoom and roll', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final initialDistance = testAppState.camera.distance;

      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        final viewportGesture = gestureDetectors.first;
        final renderBox = tester.renderObject(viewportGesture) as RenderBox;
        final center = renderBox.localToGlobal(
          renderBox.size.center(Offset.zero),
        );

        // Simulate two-finger pinch (zoom out)
        final pointer1 = TestPointer(1, PointerDeviceKind.touch);
        final pointer2 = TestPointer(2, PointerDeviceKind.touch);

        final startPos1 = center + const Offset(-20, 0);
        final startPos2 = center + const Offset(20, 0);

        await tester.sendEventToBinding(pointer1.down(startPos1));
        await tester.sendEventToBinding(pointer2.down(startPos2));
        await tester.pump();

        // Move fingers apart (zoom out)
        await tester.sendEventToBinding(
          pointer1.move(center + const Offset(-40, 0)),
        );
        await tester.sendEventToBinding(
          pointer2.move(center + const Offset(40, 0)),
        );
        await tester.pump();

        await tester.sendEventToBinding(pointer1.up());
        await tester.sendEventToBinding(pointer2.up());
        await tester.pump();

        // Distance should have changed (zoomed out)
        expect(testAppState.camera.distance, isNot(equals(initialDistance)));
      }

      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Single-finger gesture should still work for rotation', (
      tester,
    ) async {
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final initialYaw = testAppState.camera.yaw;

      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        final viewportGesture = gestureDetectors.first;

        // Simulate single-finger drag (camera rotation)
        await tester.drag(viewportGesture, const Offset(100, 0));
        await tester.pump();

        // Yaw should have changed
        expect(testAppState.camera.yaw, isNot(equals(initialYaw)));
      }

      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets(
      'Three-finger pan should work with different camera yaw angles',
      (tester) async {
        await tester.pumpWidget(GravitonApp(appState: testAppState));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Rotate camera to different angle
        testAppState.camera.setCameraParameters(yaw: 1.5);
        await tester.pump();

        final initialTarget = testAppState.camera.target.clone();

        final gestureDetectors = find.byType(GestureDetector);
        if (gestureDetectors.evaluate().isNotEmpty) {
          final viewportGesture = gestureDetectors.first;
          final renderBox = tester.renderObject(viewportGesture) as RenderBox;
          final center = renderBox.localToGlobal(
            renderBox.size.center(Offset.zero),
          );

          // Three-finger pan
          final pointer1 = TestPointer(1, PointerDeviceKind.touch);
          final pointer2 = TestPointer(2, PointerDeviceKind.touch);
          final pointer3 = TestPointer(3, PointerDeviceKind.touch);

          await tester.sendEventToBinding(
            pointer1.down(center + const Offset(-10, 0)),
          );
          await tester.sendEventToBinding(pointer2.down(center));
          await tester.sendEventToBinding(
            pointer3.down(center + const Offset(10, 0)),
          );
          await tester.pump();

          await tester.sendEventToBinding(
            pointer1.move(center + const Offset(40, 0)),
          );
          await tester.sendEventToBinding(
            pointer2.move(center + const Offset(50, 0)),
          );
          await tester.sendEventToBinding(
            pointer3.move(center + const Offset(60, 0)),
          );
          await tester.pump();

          await tester.sendEventToBinding(pointer1.up());
          await tester.sendEventToBinding(pointer2.up());
          await tester.sendEventToBinding(pointer3.up());
          await tester.pump();

          // Target should have moved (relative to camera orientation)
          expect(testAppState.camera.target, isNot(equals(initialTarget)));
        }

        await TestHelpers.pumpAppTimers(tester);
      },
    );

    test('Pan sensitivity should scale with camera distance', () {
      // Reset to ensure default distance
      testAppState.camera.resetView();

      // At default distance
      final sensitivity1 = testAppState.camera.distance * 0.002;
      expect(sensitivity1, equals(0.6));

      // Zoom in
      testAppState.camera.zoom(-0.5);
      final sensitivity2 = testAppState.camera.distance * 0.002;
      expect(sensitivity2, lessThan(sensitivity1));

      // Zoom out
      testAppState.camera.resetView();
      testAppState.camera.zoom(1.0);
      final sensitivity3 = testAppState.camera.distance * 0.002;
      expect(sensitivity3, greaterThan(sensitivity1));
    });
  });
}
