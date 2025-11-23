import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/camera_controls.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'integration_test_utils.dart';

/// Integration tests for the camera rotate speed slider feature.
/// Tests the complete user workflow of enabling auto-rotate and adjusting the rotation speed.
void main() {
  group('Camera Rotate Speed Integration Tests', () {
    late AppState testAppState;
    late ScrollController scrollController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      testAppState = AppState();
      scrollController = ScrollController();

      // Set manual camera mode so auto-rotate controls are visible
      testAppState.ui.setCinematicCameraTechnique(
        CinematicCameraTechnique.manual,
      );
    });

    tearDown(() {
      scrollController.dispose();
      testAppState.dispose();
    });

    // Helper to scroll down and make rotate speed slider visible
    Future<void> scrollToRotateSpeedSlider(WidgetTester tester) async {
      await IntegrationTestUtils.scrollDown(tester, offset: -500);
    }

    Widget createTestApp() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 2000, // Tall enough to show all controls
            child: ListenableBuilder(
              listenable: Listenable.merge([
                testAppState.camera,
                testAppState.ui,
              ]),
              builder: (context, child) {
                return CameraControls(
                  appState: testAppState,
                  scrollController: scrollController,
                );
              },
            ),
          ),
        ),
      );
    }

    testWidgets('Complete user flow: enable auto-rotate and adjust speed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verify rotate speed slider is not visible initially
      expect(find.text('Rotate Speed'), findsNothing);

      // Enable auto-rotate
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();

      // Verify auto-rotate is now enabled
      expect(testAppState.camera.autoRotate, isTrue);

      // Scroll down to make the rotate speed slider visible
      await scrollToRotateSpeedSlider(tester);

      // Verify rotate speed slider is now visible
      expect(find.text('Rotate Speed'), findsOneWidget);

      // Verify initial rotate speed value is displayed
      final initialSpeed = testAppState.camera.autoRotateSpeed;
      expect(
        find.textContaining('${initialSpeed.toStringAsFixed(1)}x'),
        findsAtLeastNWidgets(1),
      );

      // Find and interact with the rotate speed slider
      final rotateSpeedSlider = find.byWidgetPredicate(
        (widget) =>
            widget is Slider &&
            widget.value == testAppState.camera.autoRotateSpeed &&
            widget.min == SimulationConstants.cameraAutoRotateSpeedMin &&
            widget.max == SimulationConstants.cameraAutoRotateSpeedMax,
      );

      expect(rotateSpeedSlider, findsOneWidget);

      // Change the rotate speed value
      testAppState.camera.setAutoRotateSpeed(2.0);
      await tester.pumpAndSettle();

      // Verify the new value is displayed
      expect(find.text('2.0x'), findsAtLeastNWidgets(1));
      expect(testAppState.camera.autoRotateSpeed, equals(2.0));

      // Toggle auto-rotate off
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();

      // Verify auto-rotate is disabled
      expect(testAppState.camera.autoRotate, isFalse);

      // Verify rotate speed slider is hidden
      expect(find.text('Rotate Speed'), findsNothing);

      // Toggle auto-rotate back on
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();

      // Verify rotate speed slider reappears
      expect(find.text('Rotate Speed'), findsOneWidget);

      // Verify the speed value persisted
      expect(testAppState.camera.autoRotateSpeed, equals(2.0));
      expect(find.text('2.0x'), findsAtLeastNWidgets(1));
    });

    testWidgets('Rotate speed slider respects min and max constraints', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      // Test minimum value
      testAppState.camera.setAutoRotateSpeed(
        SimulationConstants.cameraAutoRotateSpeedMin,
      );
      await tester.pumpAndSettle();

      expect(
        testAppState.camera.autoRotateSpeed,
        equals(SimulationConstants.cameraAutoRotateSpeedMin),
      );
      expect(
        find.text(
          '${SimulationConstants.cameraAutoRotateSpeedMin.toStringAsFixed(1)}x',
        ),
        findsAtLeastNWidgets(1),
      );

      // Test maximum value
      testAppState.camera.setAutoRotateSpeed(
        SimulationConstants.cameraAutoRotateSpeedMax,
      );
      await tester.pumpAndSettle();

      expect(
        testAppState.camera.autoRotateSpeed,
        equals(SimulationConstants.cameraAutoRotateSpeedMax),
      );
      expect(
        find.text(
          '${SimulationConstants.cameraAutoRotateSpeedMax.toStringAsFixed(1)}x',
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('Rotate speed slider interaction with slider drag', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate
      testAppState.camera.toggleAutoRotate();
      testAppState.camera.setAutoRotateSpeed(1.0);
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      // Find the rotate speed slider
      final rotateSpeedSlider = find.byWidgetPredicate(
        (widget) =>
            widget is Slider &&
            widget.value == testAppState.camera.autoRotateSpeed,
      );

      expect(rotateSpeedSlider, findsOneWidget);

      final initialValue = testAppState.camera.autoRotateSpeed;

      // Drag the slider to change the value
      await tester.drag(rotateSpeedSlider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Verify the value changed
      expect(testAppState.camera.autoRotateSpeed, isNot(equals(initialValue)));
      expect(
        testAppState.camera.autoRotateSpeed,
        greaterThanOrEqualTo(SimulationConstants.cameraAutoRotateSpeedMin),
      );
      expect(
        testAppState.camera.autoRotateSpeed,
        lessThanOrEqualTo(SimulationConstants.cameraAutoRotateSpeedMax),
      );
    });

    testWidgets('Rotate speed changes affect camera rotation behavior', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate with different speeds and verify state changes
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);
      expect(testAppState.camera.autoRotate, isTrue);

      // Test slow speed
      testAppState.camera.setAutoRotateSpeed(0.5);
      await tester.pumpAndSettle();
      expect(testAppState.camera.autoRotateSpeed, equals(0.5));

      // Test fast speed
      testAppState.camera.setAutoRotateSpeed(2.5);
      await tester.pumpAndSettle();
      expect(testAppState.camera.autoRotateSpeed, equals(2.5));
      expect(find.text('2.5x'), findsAtLeastNWidgets(1));
    });

    testWidgets('Rotate speed slider works with camera controls in ListView', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      // Verify the camera controls ListView is present
      expect(find.byType(CameraControls), findsOneWidget);
      expect(find.byType(ListView), findsWidgets);

      // Verify slider is visible
      expect(find.text('Rotate Speed'), findsOneWidget);
    });

    testWidgets('Rotate speed slider displays correct formatted values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      // Test various speed values and their formatting
      final testValues = [0.1, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0];

      for (final value in testValues) {
        testAppState.camera.setAutoRotateSpeed(value);
        await tester.pumpAndSettle();

        expect(
          find.text('${value.toStringAsFixed(1)}x'),
          findsAtLeastNWidgets(1),
        );
        expect(testAppState.camera.autoRotateSpeed, equals(value));
      }
    });

    testWidgets('Rotate speed slider persists value across rebuilds', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate and set speed
      testAppState.camera.toggleAutoRotate();
      testAppState.camera.setAutoRotateSpeed(1.8);
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      expect(find.text('Rotate Speed'), findsOneWidget);
      expect(find.text('1.8x'), findsAtLeastNWidgets(1));

      // Rebuild the widget
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verify rotate speed slider is still visible with correct value
      expect(find.text('Rotate Speed'), findsOneWidget);
      expect(find.text('1.8x'), findsAtLeastNWidgets(1));
      expect(testAppState.camera.autoRotateSpeed, equals(1.8));
    });

    testWidgets('Rotate speed slider respects divisions in slider', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      // Find the rotate speed slider
      final rotateSpeedSlider = find.byWidgetPredicate(
        (widget) =>
            widget is Slider &&
            widget.value == testAppState.camera.autoRotateSpeed &&
            widget.min == SimulationConstants.cameraAutoRotateSpeedMin &&
            widget.max == SimulationConstants.cameraAutoRotateSpeedMax,
      );

      expect(rotateSpeedSlider, findsOneWidget);

      // Verify divisions
      final slider = tester.widget<Slider>(rotateSpeedSlider);
      expect(
        slider.divisions,
        equals(SimulationConstants.cameraAutoRotateSpeedDivisions),
      );
    });

    testWidgets('Rotate speed icon is displayed correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Enable auto-rotate
      testAppState.camera.toggleAutoRotate();
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      // Verify the speed icon is present
      expect(find.byIcon(Icons.speed), findsAtLeastNWidgets(1));
    });

    testWidgets('Rotate speed slider not visible without auto-rotate', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verify auto-rotate is disabled
      expect(testAppState.camera.autoRotate, isFalse);

      // Verify rotate speed slider is not visible
      expect(find.text('Rotate Speed'), findsNothing);
    });

    testWidgets(
      'Auto-rotate toggle affects rotate speed slider visibility in real-time',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Initially, rotate speed should not be visible
        expect(find.text('Rotate Speed'), findsNothing);

        // Toggle auto-rotate on
        testAppState.camera.toggleAutoRotate();
        await tester.pumpAndSettle();
        await scrollToRotateSpeedSlider(tester);

        // Rotate speed should now be visible
        expect(find.text('Rotate Speed'), findsOneWidget);

        // Toggle off again
        testAppState.camera.toggleAutoRotate();
        await tester.pumpAndSettle();

        // Rotate speed should be hidden again
        expect(find.text('Rotate Speed'), findsNothing);
      },
    );

    testWidgets('Rotate speed value persists through state changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Set a specific rotate speed
      testAppState.camera.toggleAutoRotate();
      testAppState.camera.setAutoRotateSpeed(2.3);
      await tester.pumpAndSettle();
      await scrollToRotateSpeedSlider(tester);

      expect(testAppState.camera.autoRotateSpeed, equals(2.3));
      expect(find.text('2.3x'), findsAtLeastNWidgets(1));

      // Perform various state changes
      testAppState.camera.toggleInvertPitch();
      await tester.pumpAndSettle();

      testAppState.camera.setFieldOfView(90);
      await tester.pumpAndSettle();

      // Verify rotate speed persisted
      expect(testAppState.camera.autoRotateSpeed, equals(2.3));
      expect(find.text('2.3x'), findsAtLeastNWidgets(1));
    });
  });
}
