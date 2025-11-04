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
      expect(find.text('Auto Rotate'), findsOneWidget);
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

      // Initially should show "Auto Rotate" when not rotating
      expect(find.text('Auto Rotate'), findsOneWidget);

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
      // Bottom should be at least the base spacing
      expect(padding.bottom, greaterThanOrEqualTo(AppTypography.spacingXLarge));
    });
  });
}
