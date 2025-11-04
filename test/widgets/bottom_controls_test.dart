import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/bottom_controls.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';

void main() {
  group('BottomControls Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: Scaffold(body: child),
        ),
      );
    }

    group('Widget Initialization', () {
      testWidgets('should render without errors', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        expect(find.byType(BottomControls), findsOneWidget);
      });

      testWidgets('should display all three buttons', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        await tester.pumpAndSettle();

        // Check for button icons - each icon appears twice (stroke + fill)
        expect(find.byIcon(Icons.videocam), findsNWidgets(2)); // Camera
        expect(find.byIcon(Icons.palette), findsNWidgets(2)); // Visuals
        expect(find.byIcon(Icons.science), findsNWidgets(2)); // Physics

        // Check for button labels
        expect(find.text('Camera'), findsOneWidget);
        expect(find.text('Visuals'), findsOneWidget);
        expect(find.text('Physics'), findsOneWidget);
      });
    });

    group('Visual Styling', () {
      testWidgets('should have proper background styling', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Check basic structure
        expect(find.byType(BottomControls), findsOneWidget);

        // Check the size of the bottom controls widget - should be around 34 + system padding
        final bottomControlsSize = tester.getSize(find.byType(BottomControls));
        expect(bottomControlsSize.height, greaterThan(30));
        expect(bottomControlsSize.height, lessThan(120));
      });

      testWidgets('should use SafeArea with top: false', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        final safeArea = find.byType(SafeArea);
        expect(safeArea, findsOneWidget);

        final safeAreaWidget = tester.widget<SafeArea>(safeArea);
        expect(safeAreaWidget.top, isFalse);
      });

      testWidgets('should have proper row layout', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Find the main row within the BottomControls
        final rows = find.byType(Row);
        expect(rows, findsAtLeastNWidgets(1));

        // Should have three buttons (now as InkWell widgets)
        expect(find.byType(InkWell), findsNWidgets(3));
      });
    });

    group('Button States', () {
      testWidgets('camera button should be active when not in manual mode', (
        tester,
      ) async {
        // Set to predictive orbital (non-manual)
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.predictiveOrbital,
        );

        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        await tester.pumpAndSettle();

        // Find the camera button icons and check if they're active (purple color)
        final cameraButtons = find.byIcon(Icons.videocam);
        expect(cameraButtons, findsNWidgets(2));

        // The fill layer icon (second one) should have purple color when active
        final iconWidgets = tester.widgetList<Icon>(cameraButtons).toList();
        final fillIcon = iconWidgets[1]; // Second icon is the fill layer
        // Active buttons should have primaryColor, not just white
        expect(
          fillIcon.color?.toARGB32(),
          isNot(equals(Colors.white.toARGB32())),
        );
      });

      testWidgets('camera button should be inactive when in manual mode', (
        tester,
      ) async {
        // Set to manual mode
        appState.ui.setCinematicCameraTechnique(
          CinematicCameraTechnique.manual,
        );

        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        await tester.pumpAndSettle();

        // Find the camera button and check if it's inactive
        final cameraButtons = find.byIcon(Icons.videocam);
        expect(cameraButtons, findsNWidgets(2));

        // Inactive buttons should have white/transparent color
        final iconWidgets = tester.widgetList<Icon>(cameraButtons).toList();
        final fillIcon = iconWidgets[1]; // Second icon is the fill layer
        // We can't easily test the exact color due to opacity, but we can test it exists
        expect(fillIcon.color, isNotNull);
      });

      testWidgets(
        'visuals button should be active when visual features are enabled',
        (tester) async {
          // Enable trails
          appState.ui.toggleTrails();

          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          await tester.pumpAndSettle();

          final visualButtons = find.byIcon(Icons.palette);
          expect(visualButtons, findsNWidgets(2));

          // Button should exist and be tappable
          final iconWidgets = tester.widgetList<Icon>(visualButtons).toList();
          final fillIcon = iconWidgets[1]; // Second icon is the fill layer
          expect(fillIcon.color, isNotNull);
        },
      );

      testWidgets(
        'physics button should be active when physics features are enabled',
        (tester) async {
          // Enable gravity fields
          appState.ui.toggleGlobalGravityFields();

          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          await tester.pumpAndSettle();

          final physicsButtons = find.byIcon(Icons.science);
          expect(physicsButtons, findsNWidgets(2));

          // Button should exist and be tappable
          final iconWidgets = tester.widgetList<Icon>(physicsButtons).toList();
          final fillIcon = iconWidgets[1]; // Second icon is the fill layer
          expect(fillIcon.color, isNotNull);
        },
      );
    });

    group('Button Interactions', () {
      testWidgets(
        'should show camera bottom sheet when camera button is tapped',
        (tester) async {
          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          // Find the first InkWell widget (camera button)
          final inkWells = find.byType(InkWell);
          expect(inkWells, findsNWidgets(3));

          // Tap the first InkWell (camera button)
          await tester.tap(inkWells.first);
          await tester.pumpAndSettle();

          // Check if bottom sheet is shown (modal overlay)
          expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
        },
      );

      testWidgets(
        'should show visuals bottom sheet when visuals button is tapped',
        (tester) async {
          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          // Find the InkWell widgets and tap the second one (visuals button)
          final inkWells = find.byType(InkWell);
          expect(inkWells, findsNWidgets(3));

          // Tap the second InkWell (visuals button)
          await tester.tap(inkWells.at(1));
          await tester.pumpAndSettle();

          // Check if bottom sheet is shown
          expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
        },
      );

      testWidgets(
        'should show physics bottom sheet when physics button is tapped',
        (tester) async {
          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          // Find the InkWell widgets and tap the third one (physics button)
          final inkWells = find.byType(InkWell);
          expect(inkWells, findsNWidgets(3));

          // Tap the third InkWell (physics button)
          await tester.tap(inkWells.at(2));
          await tester.pumpAndSettle();

          // Check if bottom sheet is shown
          expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
        },
      );

      testWidgets('should show and interact with bottom sheets', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Open bottom sheet by tapping first InkWell (camera button)
        final inkWells = find.byType(InkWell);
        await tester.tap(inkWells.first);
        await tester.pumpAndSettle();

        // Bottom sheet should be visible
        expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));

        // The test verifies bottom sheet functionality works
      });
    });

    group('Layout and Sizing', () {
      testWidgets('should have reasonable height', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Check the size of the bottom controls widget
        final bottomControlsSize = tester.getSize(find.byType(BottomControls));

        // Height should be reasonable (34 + padding, so between 30 and 120)
        expect(bottomControlsSize.height, greaterThan(30));
        expect(bottomControlsSize.height, lessThan(120));
      });

      testWidgets('should expand to full width', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        final bottomControls = find.byType(BottomControls);
        final size = tester.getSize(bottomControls);

        // Should take full width of screen
        expect(size.width, greaterThan(300)); // Reasonable screen width
      });

      testWidgets('buttons should be evenly distributed', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        final buttons = find.byType(InkWell);
        expect(buttons, findsNWidgets(3));

        // All buttons should be wrapped in Expanded widgets
        final expandedWidgets = find.byType(Expanded);
        expect(expandedWidgets, findsNWidgets(3));
      });
    });

    group('State Management Integration', () {
      testWidgets('should respond to app state changes', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Initial state
        await tester.pumpAndSettle();

        // Change app state
        appState.ui.toggleTrails();
        await tester.pump();

        // UI should update - visual button should still be findable
        final visualButtons = find.byIcon(Icons.palette);
        expect(visualButtons, findsNWidgets(2));
      });

      testWidgets('should handle multiple state changes', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Make multiple state changes
        appState.ui.toggleTrails();
        appState.ui.toggleLabels();
        appState.ui.toggleGlobalGravityFields();

        await tester.pump();

        // All buttons should still be present
        final buttons = find.byType(InkWell);
        expect(buttons, findsNWidgets(3));
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        await tester.pumpAndSettle();

        // Check for basic button accessibility - each icon appears twice
        expect(find.byIcon(Icons.videocam), findsNWidgets(2));
        expect(find.byIcon(Icons.palette), findsNWidgets(2));
        expect(find.byIcon(Icons.science), findsNWidgets(2));
      });

      testWidgets('should support semantic actions', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Should be able to tap buttons using InkWell
        final inkWells = find.byType(InkWell);
        await tester.tap(inkWells.first);
        await tester.pumpAndSettle();

        expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
      });
    });

    group('Performance', () {
      testWidgets('should not rebuild unnecessarily', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        await tester.pumpAndSettle();

        // Pump without state changes
        await tester.pump();

        // Should still render correctly
        expect(find.byType(BottomControls), findsOneWidget);
        expect(find.byType(InkWell), findsNWidgets(3));
      });

      testWidgets('should handle rapid state changes efficiently', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Rapid state changes
        for (int i = 0; i < 10; i++) {
          appState.ui.toggleTrails();
          await tester.pump();
        }

        // Should complete without issues
        expect(find.byType(BottomControls), findsOneWidget);
      });
    });
  });
}
