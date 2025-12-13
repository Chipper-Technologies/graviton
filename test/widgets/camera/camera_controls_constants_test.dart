import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/shared/widgets/controls/camera_controls.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/core/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';

void main() {
  group('CameraControls Constants Integration Tests', () {
    late AppState appState;
    late ScrollController scrollController;

    setUp(() {
      appState = AppState();
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
      appState.dispose();
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CameraControls(
            appState: appState,
            scrollController: scrollController,
          ),
        ),
      );
    }

    testWidgets('FOV slider should use correct range from constants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Pump a frame to let the widget settle
      await tester.pump();

      // Verify the default FOV value matches our constant
      expect(
        appState.camera.fieldOfView,
        equals(SimulationConstants.cameraFovDefault),
      );

      // Test that the slider respects the min/max bounds
      appState.camera.setFieldOfView(SimulationConstants.cameraFovMin - 10);
      expect(
        appState.camera.fieldOfView,
        equals(SimulationConstants.cameraFovMin),
      );

      appState.camera.setFieldOfView(SimulationConstants.cameraFovMax + 10);
      expect(
        appState.camera.fieldOfView,
        equals(SimulationConstants.cameraFovMax),
      );
    });

    testWidgets('camera speed slider should use correct range from constants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Set manual camera mode to show speed controls
      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);

      await tester.pump();

      // Test that the speed slider respects the min/max bounds
      appState.ui.setCameraSpeed(SimulationConstants.cameraSpeedMin - 0.1);
      expect(
        appState.ui.cameraSpeed,
        greaterThanOrEqualTo(SimulationConstants.cameraSpeedMin),
      );

      appState.ui.setCameraSpeed(SimulationConstants.cameraSpeedMax + 1.0);
      expect(
        appState.ui.cameraSpeed,
        lessThanOrEqualTo(SimulationConstants.cameraSpeedMax),
      );
    });

    testWidgets('FOV bounds validation matches constants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Test edge cases around the boundaries
      final testValues = [
        SimulationConstants.cameraFovMin - 0.1,
        SimulationConstants.cameraFovMin,
        SimulationConstants.cameraFovMin + 0.1,
        SimulationConstants.cameraFovDefault,
        SimulationConstants.cameraFovMax - 0.1,
        SimulationConstants.cameraFovMax,
        SimulationConstants.cameraFovMax + 0.1,
      ];

      for (final testValue in testValues) {
        appState.camera.setFieldOfView(testValue);
        final actualValue = appState.camera.fieldOfView;

        expect(
          actualValue,
          greaterThanOrEqualTo(SimulationConstants.cameraFovMin),
        );
        expect(
          actualValue,
          lessThanOrEqualTo(SimulationConstants.cameraFovMax),
        );

        if (testValue >= SimulationConstants.cameraFovMin &&
            testValue <= SimulationConstants.cameraFovMax) {
          expect(actualValue, equals(testValue));
        }
      }
    });

    testWidgets('camera speed bounds validation matches constants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Test edge cases around the speed boundaries
      final testValues = [
        SimulationConstants.cameraSpeedMin - 0.1,
        SimulationConstants.cameraSpeedMin,
        SimulationConstants.cameraSpeedMin + 0.1,
        1.0, // middle value
        SimulationConstants.cameraSpeedMax - 0.1,
        SimulationConstants.cameraSpeedMax,
        SimulationConstants.cameraSpeedMax + 0.1,
      ];

      for (final testValue in testValues) {
        appState.ui.setCameraSpeed(testValue);
        final actualValue = appState.ui.cameraSpeed;

        expect(
          actualValue,
          greaterThanOrEqualTo(SimulationConstants.cameraSpeedMin),
        );
        expect(
          actualValue,
          lessThanOrEqualTo(SimulationConstants.cameraSpeedMax),
        );

        if (testValue >= SimulationConstants.cameraSpeedMin &&
            testValue <= SimulationConstants.cameraSpeedMax) {
          expect(actualValue, equals(testValue));
        }
      }
    });
  });
}
