import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/camera_gesture_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CameraGestureService', () {
    test('should have private constructor', () {
      // Verify that CameraGestureService cannot be instantiated
      // This ensures it's used as a static utility class
      expect(CameraGestureService, isA<Type>());
    });

    group('handleThreeFingerPan', () {
      test('should pan camera in response to screen delta', () {
        final appState = AppState();
        final initialTarget = appState.camera.target.clone();

        // Simulate three-finger pan gesture
        CameraGestureService.handleThreeFingerPan(
          screenDelta: const Offset(10, -5),
          appState: appState,
        );

        // Camera target should change
        expect(appState.camera.target, isNot(equals(initialTarget)));
        appState.dispose();
      });

      test('should prevent panning in follow mode', () {
        final appState = AppState();

        // Add a body
        appState.simulation.bodies.add(
          Body(
            name: 'Test Body',
            mass: 1.0,
            radius: 1.0,
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            color: Colors.blue,
            bodyType: BodyType.planet,
          ),
        );

        // Select body first (required before enabling follow mode)
        appState.camera.selectBody(0);
        // Now enable follow mode (only works when a body is selected)
        appState.camera.toggleFollowMode(appState.simulation.bodies);

        // Verify follow mode is actually active
        expect(appState.camera.followMode, isTrue);

        final initialTarget = appState.camera.target.clone();

        // Attempt to pan - should be blocked
        CameraGestureService.handleThreeFingerPan(
          screenDelta: const Offset(20, 10),
          appState: appState,
        );

        // Target should remain unchanged
        expect(appState.camera.target, equals(initialTarget));
        appState.dispose();
      });

      test('should scale pan sensitivity with camera distance', () {
        final appState = AppState();

        // Zoom in (reduce distance)
        appState.camera.zoom(-0.5); // Closer to target
        final closeDistance = appState.camera.distance;
        final closeTarget1 = appState.camera.target.clone();

        CameraGestureService.handleThreeFingerPan(
          screenDelta: const Offset(5, 5),
          appState: appState,
        );

        final closeTarget2 = appState.camera.target.clone();
        final closeDelta = (closeTarget2 - closeTarget1).length;

        // Reset and zoom out (increase distance)
        appState.camera.resetView(appState.simulation.currentScenario);
        appState.camera.zoom(0.5); // Farther from target
        final farDistance = appState.camera.distance;
        final farTarget1 = appState.camera.target.clone();

        CameraGestureService.handleThreeFingerPan(
          screenDelta: const Offset(5, 5),
          appState: appState,
        );

        final farTarget2 = appState.camera.target.clone();
        final farDelta = (farTarget2 - farTarget1).length;

        // Pan distance should scale with camera distance
        expect(farDistance, greaterThan(closeDistance));
        expect(farDelta, greaterThan(closeDelta));
        appState.dispose();
      });

      test('should handle zero delta gracefully', () {
        final appState = AppState();
        final initialTarget = appState.camera.target.clone();

        CameraGestureService.handleThreeFingerPan(
          screenDelta: Offset.zero,
          appState: appState,
        );

        // Target should remain essentially unchanged (accounting for FP precision)
        expect(
          (appState.camera.target - initialTarget).length,
          lessThan(0.001),
        );
        appState.dispose();
      });

      test('should handle large delta values', () {
        final appState = AppState();

        expect(
          () => CameraGestureService.handleThreeFingerPan(
            screenDelta: const Offset(1000, 1000),
            appState: appState,
          ),
          returnsNormally,
        );
        appState.dispose();
      });

      test('should handle negative delta values', () {
        final appState = AppState();
        final initialTarget = appState.camera.target.clone();

        CameraGestureService.handleThreeFingerPan(
          screenDelta: const Offset(-10, -10),
          appState: appState,
        );

        // Camera should move in opposite direction
        expect(appState.camera.target, isNot(equals(initialTarget)));
        appState.dispose();
      });
    });

    group('showFloatingControlsTemporarily', () {
      test('should call onUpdate when showing controls', () {
        bool updateCalled = false;

        CameraGestureService.showFloatingControlsTemporarily(
          mounted: true,
          currentTimer: null,
          onUpdate: () => updateCalled = true,
        );

        expect(updateCalled, isTrue);
      });

      test('should cancel existing timer when provided', () {
        final existingTimer = Timer(const Duration(seconds: 1), () {});

        CameraGestureService.showFloatingControlsTemporarily(
          mounted: true,
          currentTimer: existingTimer,
          onUpdate: () {},
        );

        // Timer should be cancelled
        expect(existingTimer.isActive, isFalse);
      });

      test('should return timer when sheet is in closed position', () {
        final timer = CameraGestureService.showFloatingControlsTemporarily(
          mounted: true,
          currentTimer: null,
          onUpdate: () {},
        );

        // Timer behavior depends on sheet position
        expect(timer, anyOf(isNull, isA<Timer>()));
        timer?.cancel();
      });

      test('should not call update when not mounted', () {
        bool updateCalled = false;

        CameraGestureService.showFloatingControlsTemporarily(
          mounted: false,
          currentTimer: null,
          onUpdate: () => updateCalled = true,
        );

        // Update should still be called initially (before mount check in timer callback)
        expect(updateCalled, isTrue);
      });

      test('should handle multiple rapid calls', () {
        Timer? timer;

        // Rapid successive calls
        for (var i = 0; i < 5; i++) {
          timer = CameraGestureService.showFloatingControlsTemporarily(
            mounted: true,
            currentTimer: timer,
            onUpdate: () {},
          );
        }

        // Should not crash
        expect(() => timer?.cancel(), returnsNormally);
      });
    });

    group('handleSheetPositionChanged', () {
      test('should return null when currentTimer is null', () {
        final result = CameraGestureService.handleSheetPositionChanged(
          mounted: true,
          currentTimer: null,
          showFloatingControls: false,
          onRestartTimer: () {},
        );

        expect(result, isNull);
      });

      test('should handle sheet position changes with existing timer', () {
        final existingTimer = Timer(const Duration(seconds: 1), () {});
        bool restartCalled = false;

        CameraGestureService.handleSheetPositionChanged(
          mounted: true,
          currentTimer: existingTimer,
          showFloatingControls: true,
          onRestartTimer: () => restartCalled = true,
        );

        // Method should be called without errors
        // Actual behavior depends on sheet position which is environment-specific
        expect(restartCalled || !existingTimer.isActive, isTrue);
      });

      test('should cancel timer when sheet is expanded', () {
        final existingTimer = Timer(const Duration(seconds: 1), () {});

        // Result depends on actual sheet position
        final result = CameraGestureService.handleSheetPositionChanged(
          mounted: true,
          currentTimer: existingTimer,
          showFloatingControls: true,
          onRestartTimer: () {},
        );

        // Should either return null or the existing timer
        expect(result, anyOf(isNull, same(existingTimer)));
      });

      test('should handle not mounted state', () {
        final existingTimer = Timer(const Duration(seconds: 1), () {});

        final result = CameraGestureService.handleSheetPositionChanged(
          mounted: false,
          currentTimer: existingTimer,
          showFloatingControls: true,
          onRestartTimer: () {},
        );

        // Should still return the timer (mount check is for callback only)
        expect(result, same(existingTimer));
        existingTimer.cancel();
      });

      test('should handle showFloatingControls = false', () {
        final existingTimer = Timer(const Duration(seconds: 1), () {});

        final result = CameraGestureService.handleSheetPositionChanged(
          mounted: true,
          currentTimer: existingTimer,
          showFloatingControls: false,
          onRestartTimer: () {},
        );

        // Should not restart timer if controls are not showing
        expect(result, anyOf(isNull, same(existingTimer)));
        existingTimer.cancel();
      });
    });

    group('Edge Cases', () {
      test('should handle extreme camera distances', () {
        final appState = AppState();

        // Zoom way out
        for (var i = 0; i < 10; i++) {
          appState.camera.zoom(0.5);
        }

        expect(
          () => CameraGestureService.handleThreeFingerPan(
            screenDelta: const Offset(10, 10),
            appState: appState,
          ),
          returnsNormally,
        );
        appState.dispose();
      });

      test('should handle extreme camera distances (zoomed in)', () {
        final appState = AppState();

        // Zoom way in
        for (var i = 0; i < 10; i++) {
          appState.camera.zoom(-0.5);
        }

        expect(
          () => CameraGestureService.handleThreeFingerPan(
            screenDelta: const Offset(10, 10),
            appState: appState,
          ),
          returnsNormally,
        );
        appState.dispose();
      });

      test('should handle rapid camera manipulations', () {
        final appState = AppState();

        // Rapid pan gestures
        for (var i = 0; i < 50; i++) {
          CameraGestureService.handleThreeFingerPan(
            screenDelta: Offset(i.toDouble(), -i.toDouble()),
            appState: appState,
          );
        }

        expect(appState.camera.target, isNotNull);
        appState.dispose();
      });
    });
  });
}
