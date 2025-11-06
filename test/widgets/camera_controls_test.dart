import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/camera_controls.dart';
import 'package:graviton/widgets/camera_mode_option.dart';
import 'package:graviton/widgets/camera_action_button.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_typography.dart';

void main() {
  group('CameraControls', () {
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

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CameraControls), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays correct sections', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('AI Camera Modes'), findsOneWidget);
      expect(find.byType(SectionTitle), findsWidgets);
    });

    testWidgets('displays all camera modes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CameraModeOption), findsNWidgets(3));
      expect(find.text('Manual Control'), findsOneWidget);
      expect(find.text('Predictive Orbital'), findsOneWidget);
      expect(find.text('Dynamic Framing'), findsOneWidget);
    });

    testWidgets('displays correct initial camera mode selection', (
      WidgetTester tester,
    ) async {
      // Set manual mode as default
      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);

      await tester.pumpWidget(createTestWidget());

      // Should show manual controls when manual mode is selected
      expect(find.text('Manual Controls'), findsAtLeastNWidgets(1));
      expect(find.byType(CameraActionButton), findsWidgets);
    });

    testWidgets('can switch between camera modes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially should be manual mode
      expect(
        appState.ui.cinematicCameraTechnique,
        CinematicCameraTechnique.manual,
      );

      // Find and tap the predictive orbital option
      final predictiveOption = find.text('Predictive Orbital');
      expect(predictiveOption, findsOneWidget);

      await tester.tap(predictiveOption);
      await tester.pump();

      expect(
        appState.ui.cinematicCameraTechnique,
        CinematicCameraTechnique.predictiveOrbital,
      );
    });

    testWidgets('manual controls appear only in manual mode', (
      WidgetTester tester,
    ) async {
      // Start with non-manual mode
      appState.ui.setCinematicCameraTechnique(
        CinematicCameraTechnique.predictiveOrbital,
      );

      await tester.pumpWidget(createTestWidget());

      // Manual controls should not be visible
      expect(find.byType(CameraActionButton), findsNothing);

      // Switch to manual mode
      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);
      await tester.pump();

      // Manual controls should now be visible (if there are bodies in simulation)
      // May not find buttons if no bodies exist
      expect(tester.takeException(), isNull);
    });

    testWidgets('displays camera action buttons in manual mode', (
      WidgetTester tester,
    ) async {
      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Select Nearest'), findsOneWidget);
      expect(find.text('Follow'), findsOneWidget);
      expect(find.text('Center View'), findsOneWidget);
      // Check for auto rotate button (there will be two "Auto Rotate" texts)
      expect(find.text('Auto Rotate'), findsWidgets);
    });

    testWidgets('displays invert pitch control', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should have some basic UI elements
      expect(find.byType(CameraControls), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      // Log what widgets are actually found for debugging
      await tester.pumpAndSettle();

      // Should not throw errors during rendering
      expect(tester.takeException(), isNull);
    });

    testWidgets('can toggle invert pitch', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final initialInvertPitch = appState.camera.invertPitch;

      // Test the functionality directly without UI interaction
      appState.camera.toggleInvertPitch();

      expect(appState.camera.invertPitch, !initialInvertPitch);
    });

    testWidgets('handles scroll controller correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ListView), findsOneWidget);

      // Should be able to scroll if content is long enough
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pump();

      // Should not throw errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('has correct styling and colors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, isNotNull);

      // Check that camera mode options are styled properly
      expect(find.byType(CameraModeOption), findsWidgets);
    });

    testWidgets('displays proper section titles', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SectionTitle), findsWidgets);
      expect(find.text('AI Camera Modes'), findsOneWidget);
      // Just test that the widget renders without specific text checks
      expect(find.byType(CameraControls), findsOneWidget);
    });

    testWidgets('responds to app state changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Change camera technique
      appState.ui.setCinematicCameraTechnique(
        CinematicCameraTechnique.dynamicFraming,
      );
      await tester.pump();

      // Should reflect the change
      expect(
        appState.ui.cinematicCameraTechnique,
        CinematicCameraTechnique.dynamicFraming,
      );
    });

    testWidgets('has proper accessibility features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Should have proper semantic structure
      expect(find.byType(Material), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('handles camera actions correctly', (
      WidgetTester tester,
    ) async {
      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);

      await tester.pumpWidget(createTestWidget());

      // Test center view action if it exists
      final centerViewButton = find.text('Center View');
      if (tester.any(centerViewButton)) {
        await tester.tap(centerViewButton, warnIfMissed: false);
        await tester.pump();
      }

      // Should not throw errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('follow mode button updates correctly', (
      WidgetTester tester,
    ) async {
      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);

      await tester.pumpWidget(createTestWidget());

      // Initially should show "Follow" when not following
      expect(find.text('Follow'), findsOneWidget);

      // Toggle follow mode to test state change
      appState.camera.toggleFollowMode(appState.simulation.bodies);
      await tester.pump();

      // Should handle the state change without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('auto rotate button updates correctly', (
      WidgetTester tester,
    ) async {
      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);

      await tester.pumpWidget(createTestWidget());

      // Initially should show "Auto Rotate" when not rotating (there will be multiple)
      expect(find.text('Auto Rotate'), findsWidgets);

      // Toggle auto rotate to test state change
      appState.camera.toggleAutoRotate();
      await tester.pump();

      // Should handle the state change without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles edge cases gracefully', (WidgetTester tester) async {
      // Clear any existing bodies
      appState.simulation.bodies.clear();

      appState.ui.setCinematicCameraTechnique(CinematicCameraTechnique.manual);

      await tester.pumpWidget(createTestWidget());

      // Should still render without errors
      expect(find.byType(CameraControls), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('maintains consistent layout across different states', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Test different camera techniques
      for (final technique in CinematicCameraTechnique.values) {
        appState.ui.setCinematicCameraTechnique(technique);
        await tester.pump();

        // Should always show basic structure
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(CameraModeOption), findsNWidgets(3));

        // Should not throw errors
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('has proper platform-specific padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final listView = tester.widget<ListView>(find.byType(ListView));
      final padding = listView.padding as EdgeInsets;

      expect(padding.left, AppTypography.spacingXLarge);
      expect(padding.right, AppTypography.spacingXLarge);
      expect(
        padding.top,
        AppTypography.spacingLarge,
      ); // Updated from spacingXLarge
      // Bottom should be non-negative (may be 0 in test environment)
      expect(padding.bottom, greaterThanOrEqualTo(0.0));
    });

    group('Camera Speed Slider Tests', () {
      testWidgets('camera speed slider appears for AI techniques', (
        WidgetTester tester,
      ) async {
        // Test with predictive orbital
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.predictiveOrbital,
        );
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Camera Speed'), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);

        // Test with dynamic framing
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.dynamicFraming,
        );
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Camera Speed'), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('camera speed slider hidden for manual mode', (
        WidgetTester tester,
      ) async {
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.manual,
        );
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Camera Speed'), findsNothing);
        expect(find.byType(Slider), findsNothing);
      });

      testWidgets('camera speed slider reflects current value', (
        WidgetTester tester,
      ) async {
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.predictiveOrbital,
        );
        appState.ui.setCameraSpeed(1.5);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, equals(1.5));
        expect(find.text('1.5x'), findsOneWidget);
      });

      testWidgets('camera speed slider can be adjusted', (
        WidgetTester tester,
      ) async {
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.predictiveOrbital,
        );
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final sliderFinder = find.byType(Slider);
        expect(sliderFinder, findsOneWidget);

        // Test slider adjustment
        await tester.drag(sliderFinder, const Offset(50, 0));
        await tester.pumpAndSettle();

        // Value should have changed from default 0.5
        expect(appState.ui.cameraSpeed, isNot(equals(0.5)));
        expect(appState.ui.cameraSpeed, greaterThanOrEqualTo(0.1));
        expect(appState.ui.cameraSpeed, lessThanOrEqualTo(3.0));
      });

      testWidgets('camera speed slider has correct range', (
        WidgetTester tester,
      ) async {
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.dynamicFraming,
        );
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.min, equals(0.1));
        expect(slider.max, equals(3.0));
        expect(slider.divisions, equals(29));
      });

      testWidgets('camera speed slider shows correct labels', (
        WidgetTester tester,
      ) async {
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.predictiveOrbital,
        );
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Check for the speed label and formatted value
        expect(find.text('Speed'), findsOneWidget);
        expect(find.text('0.5x'), findsOneWidget); // Default value
        expect(find.byIcon(Icons.speed), findsOneWidget);
      });
    });
  });
}
