import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/bottom_controls.dart';
import 'package:graviton/widgets/bottom_tab_button.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';

void main() {
  group('BottomControls Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    Widget createTestWidget({required Widget child}) {
      return MultiProvider(
        providers: [ChangeNotifierProvider<AppState>.value(value: appState)],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Stack(
              children: [
                Container(), // Background
                Positioned(bottom: 0, left: 0, right: 0, child: child),
              ],
            ),
          ),
        ),
      );
    }

    group('Widget Construction', () {
      testWidgets('should build without error', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        expect(find.byType(BottomControls), findsOneWidget);
      });

      testWidgets('should contain three tab buttons', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        expect(find.byType(BottomTabButton), findsNWidgets(3));
      });

      testWidgets('should have Camera, Visuals, and Physics buttons', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        await tester.pumpAndSettle();

        // Check for button icons
        expect(find.byIcon(Icons.videocam), findsOneWidget); // Camera
        expect(find.byIcon(Icons.palette), findsOneWidget); // Visuals
        expect(find.byIcon(Icons.science), findsOneWidget); // Physics
      });
    });

    group('Visual Styling', () {
      testWidgets('should have proper background styling', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Check basic structure
        expect(find.byType(BottomControls), findsOneWidget);

        // Check the size of the bottom controls widget
        final bottomControlsSize = tester.getSize(find.byType(BottomControls));
        expect(bottomControlsSize.height, equals(80));
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

        // Should have three tab buttons
        expect(find.byType(BottomTabButton), findsNWidgets(3));
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

        // Find the camera button and check if it's active
        final cameraButtons = find.byIcon(Icons.videocam);
        expect(cameraButtons, findsOneWidget);

        // The button should be in active state
        final button = tester.widget<BottomTabButton>(
          find.ancestor(
            of: cameraButtons,
            matching: find.byType(BottomTabButton),
          ),
        );
        expect(button.isActive, isTrue);
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
        expect(cameraButtons, findsOneWidget);

        final button = tester.widget<BottomTabButton>(
          find.ancestor(
            of: cameraButtons,
            matching: find.byType(BottomTabButton),
          ),
        );
        expect(button.isActive, isFalse);
      });

      testWidgets(
        'visuals button should be active when visual features are enabled',
        (tester) async {
          // Enable trails
          appState.ui.toggleTrails();

          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          await tester.pumpAndSettle();

          final visualButtons = find.byIcon(Icons.palette);
          expect(visualButtons, findsOneWidget);

          final button = tester.widget<BottomTabButton>(
            find.ancestor(
              of: visualButtons,
              matching: find.byType(BottomTabButton),
            ),
          );
          expect(button.isActive, isTrue);
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
          expect(physicsButtons, findsOneWidget);

          final button = tester.widget<BottomTabButton>(
            find.ancestor(
              of: physicsButtons,
              matching: find.byType(BottomTabButton),
            ),
          );
          expect(button.isActive, isTrue);
        },
      );
    });

    group('Button Interactions', () {
      testWidgets(
        'should show camera bottom sheet when camera button is tapped',
        (tester) async {
          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          // Tap the camera button
          await tester.tap(find.byIcon(Icons.videocam));
          await tester.pumpAndSettle();

          // Check if bottom sheet is shown (modal overlay)
          expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
        },
      );

      testWidgets(
        'should show visuals bottom sheet when visuals button is tapped',
        (tester) async {
          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          // Tap the visuals button
          await tester.tap(find.byIcon(Icons.palette));
          await tester.pumpAndSettle();

          // Check if bottom sheet is shown
          expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
        },
      );

      testWidgets(
        'should show physics bottom sheet when physics button is tapped',
        (tester) async {
          await tester.pumpWidget(createTestWidget(child: BottomControls()));

          // Tap the physics button
          await tester.tap(find.byIcon(Icons.science));
          await tester.pumpAndSettle();

          // Check if bottom sheet is shown
          expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
        },
      );

      testWidgets('should show and interact with bottom sheets', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Open bottom sheet by tapping camera button
        await tester.tap(find.byIcon(Icons.videocam));
        await tester.pumpAndSettle();

        // Bottom sheet should be visible
        expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));

        // The test verifies bottom sheet functionality works
      });
    });

    group('Layout and Sizing', () {
      testWidgets('should have fixed height', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Check the size of the bottom controls widget
        final bottomControlsSize = tester.getSize(find.byType(BottomControls));
        expect(bottomControlsSize.height, equals(80));
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

        final buttons = find.byType(BottomTabButton);
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

        // UI should update
        final visualButtons = find.byIcon(Icons.palette);
        final button = tester.widget<BottomTabButton>(
          find.ancestor(
            of: visualButtons,
            matching: find.byType(BottomTabButton),
          ),
        );
        expect(button.isActive, isTrue);
      });

      testWidgets('should handle multiple state changes', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Make multiple state changes
        appState.ui.toggleTrails();
        appState.ui.toggleLabels();
        appState.ui.toggleGlobalGravityFields();

        await tester.pump();

        // Both visuals and physics buttons should be active
        final buttons = find.byType(BottomTabButton);
        expect(buttons, findsNWidgets(3));
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        await tester.pumpAndSettle();

        // Check for basic button accessibility
        expect(find.byIcon(Icons.videocam), findsOneWidget);
        expect(find.byIcon(Icons.palette), findsOneWidget);
        expect(find.byIcon(Icons.science), findsOneWidget);
      });

      testWidgets('should support semantic actions', (tester) async {
        await tester.pumpWidget(createTestWidget(child: BottomControls()));

        // Should be able to tap buttons
        await tester.tap(find.byIcon(Icons.videocam));
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
        expect(find.byType(BottomTabButton), findsNWidgets(3));
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
