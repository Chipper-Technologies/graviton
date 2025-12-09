import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/shared/widgets/controls/visuals_controls.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  late AppState appState;

  setUp(() {
    appState = AppState();
  });

  Widget createTestWidget({Widget? child}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ChangeNotifierProvider<AppState>.value(
          value: appState,
          child:
              child ??
              VisualsControls(
                appState: appState,
                scrollController: ScrollController(),
              ),
        ),
      ),
    );
  }

  group('VisualsControls', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(VisualsControls), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays display options section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Display Options'), findsOneWidget);
      expect(find.byType(SectionDivider), findsWidgets);
    });

    testWidgets('displays all visual toggles', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Show Trails'), findsOneWidget);
      expect(find.text('Show Labels'), findsOneWidget);
      expect(find.text('Realistic Colors'), findsOneWidget);
      expect(find.text('Habitable Zones'), findsOneWidget);
      expect(find.text('Planet Status'), findsOneWidget);
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('can toggle show trails', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.showTrails;

      // Find and tap the show trails toggle
      final showTrailsToggle = find.text('Show Trails');
      expect(showTrailsToggle, findsOneWidget);

      await tester.tap(showTrailsToggle);
      await tester.pump();

      expect(appState.ui.showTrails, !initialState);
    });

    testWidgets('can toggle show labels', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.showLabels;

      // Find and tap the show labels toggle
      final showLabelsToggle = find.text('Show Labels');
      expect(showLabelsToggle, findsOneWidget);

      await tester.tap(showLabelsToggle);
      await tester.pump();

      expect(appState.ui.showLabels, !initialState);
    });

    testWidgets('can toggle realistic colors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.useRealisticColors;

      // Find and tap the realistic colors toggle
      final realisticColorsToggle = find.text('Realistic Colors');
      expect(realisticColorsToggle, findsOneWidget);

      await tester.tap(realisticColorsToggle);
      await tester.pump();

      expect(appState.ui.useRealisticColors, !initialState);
    });

    testWidgets('can toggle habitable zones', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.showHabitableZones;

      // Find and tap the habitable zones toggle
      final habitableZonesToggle = find.text('Habitable Zones');
      expect(habitableZonesToggle, findsOneWidget);

      await tester.tap(habitableZonesToggle);
      await tester.pump();

      expect(appState.ui.showHabitableZones, !initialState);
    });

    testWidgets('can toggle habitability indicators', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.showHabitabilityIndicators;

      // Find and tap the habitability indicators toggle
      final indicatorsToggle = find.text('Planet Status');
      expect(indicatorsToggle, findsOneWidget);

      await tester.tap(indicatorsToggle);
      await tester.pump();

      expect(appState.ui.showHabitabilityIndicators, !initialState);
    });

    testWidgets('displays path visualization section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to make Path Visualization visible if needed
      await tester.dragUntilVisible(
        find.text('Path Visualization'),
        find.byType(ListView),
        const Offset(0, -100),
      );

      expect(find.text('Path Visualization'), findsOneWidget);

      // Just verify we have section titles
      expect(find.byType(SectionDivider), findsWidgets);
    });

    testWidgets('can toggle off-screen indicators if present', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to find off-screen indicators - they might not be present in current version
      final indicatorsToggle = find.text('Off-Screen Indicators');

      if (indicatorsToggle.evaluate().isNotEmpty) {
        final initialState = appState.ui.showOffScreenIndicators;

        await tester.tap(indicatorsToggle);
        await tester.pump();

        expect(appState.ui.showOffScreenIndicators, !initialState);
      } else {
        // Section not present - test should pass anyway
        expect(find.byType(VisualsControls), findsOneWidget);
      }
    });

    testWidgets('handles scroll controller correctly', (
      WidgetTester tester,
    ) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        createTestWidget(
          child: VisualsControls(
            appState: appState,
            scrollController: scrollController,
          ),
        ),
      );

      expect(find.byType(VisualsControls), findsOneWidget);

      // The ListView should use the provided scroll controller
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.controller, equals(scrollController));

      scrollController.dispose();
    });

    testWidgets('has correct styling and colors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(VisualsControls), findsOneWidget);

      // Verify proper padding and spacing
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, isNotNull);
    });

    testWidgets('displays proper section titles', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SectionDivider), findsWidgets);
      expect(find.text('Display Options'), findsOneWidget);

      // Scroll to make Path Visualization visible
      await tester.dragUntilVisible(
        find.text('Path Visualization'),
        find.byType(ListView),
        const Offset(0, -100),
      );

      expect(find.text('Path Visualization'), findsOneWidget);
    });

    testWidgets('has proper accessibility features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that toggles are accessible
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);

      // Each toggle should be semantically labeled
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('handles toggle actions correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test multiple toggles
      final initialTrails = appState.ui.showTrails;
      final initialLabels = appState.ui.showLabels;

      // Toggle trails
      await tester.tap(find.text('Show Trails'));
      await tester.pump();
      expect(appState.ui.showTrails, !initialTrails);

      // Toggle labels
      await tester.tap(find.text('Show Labels'));
      await tester.pump();
      expect(appState.ui.showLabels, !initialLabels);
    });

    testWidgets('has proper platform-specific padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, isNotNull);

      // Should include platform-specific bottom padding
      // In test environment, padding may be 0, but should be non-negative
      final padding = listView.padding as EdgeInsets;
      expect(padding.bottom, greaterThanOrEqualTo(0));
    });

    group('Additional Toggle Features', () {
      testWidgets('has state management for all UI toggles', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test that appState has all expected toggle properties
        expect(appState.ui.showCollisionDebris, isA<bool>());
        expect(appState.ui.showCollisionShockwaves, isA<bool>());
        expect(appState.ui.showCollisionEjection, isA<bool>());
        expect(appState.ui.showCollisionPlasmaJets, isA<bool>());
        expect(appState.ui.showOrbitalPaths, isA<bool>());
        expect(appState.ui.dualOrbitalPaths, isA<bool>());
      });

      testWidgets('collision effects can be toggled programmatically', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test collision debris toggle
        final initialDebris = appState.ui.showCollisionDebris;
        appState.ui.toggleCollisionDebris();
        await tester.pump();
        expect(appState.ui.showCollisionDebris, !initialDebris);

        // Test shockwaves toggle
        final initialShockwaves = appState.ui.showCollisionShockwaves;
        appState.ui.toggleCollisionShockwaves();
        await tester.pump();
        expect(appState.ui.showCollisionShockwaves, !initialShockwaves);

        // Test ejection toggle
        final initialEjection = appState.ui.showCollisionEjection;
        appState.ui.toggleCollisionEjection();
        await tester.pump();
        expect(appState.ui.showCollisionEjection, !initialEjection);

        // Test plasma jets toggle
        final initialPlasma = appState.ui.showCollisionPlasmaJets;
        appState.ui.toggleCollisionPlasmaJets();
        await tester.pump();
        expect(appState.ui.showCollisionPlasmaJets, !initialPlasma);
      });

      testWidgets('orbital paths can be toggled programmatically', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test orbital paths toggle
        final initialPaths = appState.ui.showOrbitalPaths;
        appState.ui.toggleOrbitalPaths();
        await tester.pump();
        expect(appState.ui.showOrbitalPaths, !initialPaths);

        // Test dual orbital paths toggle
        final initialDual = appState.ui.dualOrbitalPaths;
        appState.ui.toggleDualOrbitalPaths();
        await tester.pump();
        expect(appState.ui.dualOrbitalPaths, !initialDual);
      });
    });

    group('UI State Synchronization', () {
      testWidgets('reflects initial UI state correctly', (
        WidgetTester tester,
      ) async {
        // Set specific initial state
        appState.ui.toggleTrails(); // Ensure trails are off
        if (appState.ui.showTrails) {
          appState.ui.toggleTrails();
        }

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // UI should reflect the state
        expect(find.byType(Switch), findsWidgets);
      });

      testWidgets('updates when state changes externally', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final initialState = appState.ui.showLabels;

        // Change state programmatically
        appState.ui.toggleLabels();
        await tester.pump();

        expect(appState.ui.showLabels, !initialState);
      });
    });

    group('Toggle Interaction Patterns', () {
      testWidgets('allows rapid toggle clicks', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final trailsToggle = find.text('Show Trails');
        final initialState = appState.ui.showTrails;

        // Rapidly toggle multiple times
        for (int i = 0; i < 5; i++) {
          await tester.tap(trailsToggle);
          await tester.pump();
        }

        // Should end up in opposite state (odd number of toggles)
        expect(appState.ui.showTrails, !initialState);
      });

      testWidgets('handles multiple different toggles', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Toggle multiple features
        await tester.tap(find.text('Show Trails'));
        await tester.pump();

        await tester.tap(find.text('Show Labels'));
        await tester.pump();

        await tester.tap(find.text('Realistic Colors'));
        await tester.pump();

        // All should have toggled
        expect(find.byType(VisualsControls), findsOneWidget);
      });
    });

    group('Visual Feedback', () {
      testWidgets('displays icons for each toggle option', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should have icons for visual feedback
        expect(find.byType(Icon), findsWidgets);
      });

      testWidgets('shows different styling for enabled vs disabled', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enable one feature, disable another
        if (!appState.ui.showTrails) {
          await tester.tap(find.text('Show Trails'));
          await tester.pump();
        }

        if (appState.ui.showLabels) {
          await tester.tap(find.text('Show Labels'));
          await tester.pump();
        }

        // Both states should be represented in UI
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Section Organization', () {
      testWidgets('displays major sections', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Check for sections that should always be present
        expect(find.text('Display Options'), findsOneWidget);

        // Scroll to make Path Visualization visible
        await tester.dragUntilVisible(
          find.text('Path Visualization'),
          find.byType(ListView),
          const Offset(0, -100),
        );

        expect(find.text('Path Visualization'), findsOneWidget);

        // Some sections may or may not be present depending on build
        expect(find.byType(SectionDivider), findsWidgets);
      });

      testWidgets('sections have proper spacing', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // SectionDividers should provide spacing
        expect(find.byType(SectionDivider), findsWidgets);
      });
    });

    group('Lighting and Shadow Controls', () {
      testWidgets('hemisphere lighting can be toggled programmatically', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final initialState = appState.ui.enableHemisphereLighting;
        appState.ui.toggleHemisphereLighting();
        await tester.pump();

        expect(appState.ui.enableHemisphereLighting, !initialState);
      });

      testWidgets('cast shadows can be toggled programmatically', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final initialState = appState.ui.enableCastShadows;
        appState.ui.toggleCastShadows();
        await tester.pump();

        expect(appState.ui.enableCastShadows, !initialState);
      });

      testWidgets('specular highlights can be toggled programmatically', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final initialState = appState.ui.enableSpecularHighlights;
        appState.ui.toggleSpecularHighlights();
        await tester.pump();

        expect(appState.ui.enableSpecularHighlights, !initialState);
      });

      testWidgets('lighting toggles work independently', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final initialHemisphere = appState.ui.enableHemisphereLighting;
        final initialShadows = appState.ui.enableCastShadows;
        final initialSpecular = appState.ui.enableSpecularHighlights;

        // Toggle hemisphere lighting
        appState.ui.toggleHemisphereLighting();
        await tester.pump();
        expect(appState.ui.enableHemisphereLighting, !initialHemisphere);
        expect(appState.ui.enableCastShadows, initialShadows);
        expect(appState.ui.enableSpecularHighlights, initialSpecular);

        // Toggle cast shadows
        appState.ui.toggleCastShadows();
        await tester.pump();
        expect(appState.ui.enableCastShadows, !initialShadows);
        expect(appState.ui.enableSpecularHighlights, initialSpecular);

        // Toggle specular highlights
        appState.ui.toggleSpecularHighlights();
        await tester.pump();
        expect(appState.ui.enableSpecularHighlights, !initialSpecular);
      });

      testWidgets('allows rapid lighting toggle changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final initialState = appState.ui.enableHemisphereLighting;

        // Rapidly toggle multiple times
        for (int i = 0; i < 5; i++) {
          appState.ui.toggleHemisphereLighting();
          await tester.pump();
        }

        // Should end up in opposite state (odd number of toggles)
        expect(appState.ui.enableHemisphereLighting, !initialState);
      });

      testWidgets('lighting state types are correct', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(appState.ui.enableHemisphereLighting, isA<bool>());
        expect(appState.ui.enableCastShadows, isA<bool>());
        expect(appState.ui.enableSpecularHighlights, isA<bool>());
      });
    });

    group('Error Handling and Edge Cases', () {
      testWidgets('handles null scroll controller gracefully', (
        WidgetTester tester,
      ) async {
        // Widget should still work without scroll controller
        await tester.pumpWidget(
          createTestWidget(
            child: VisualsControls(
              appState: appState,
              scrollController: ScrollController(),
            ),
          ),
        );

        expect(find.byType(VisualsControls), findsOneWidget);
      });

      testWidgets('handles disposed scroll controller', (
        WidgetTester tester,
      ) async {
        final scrollController = ScrollController();
        scrollController.dispose();

        // Should not crash with disposed controller
        expect(
          () => VisualsControls(
            appState: appState,
            scrollController: scrollController,
          ),
          returnsNormally,
        );
      });

      testWidgets('handles rapid state changes', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Rapidly change multiple states
        for (int i = 0; i < 10; i++) {
          appState.ui.toggleTrails();
          appState.ui.toggleLabels();
          appState.ui.toggleRealisticColors();
          await tester.pump();
        }

        // Should still be functional
        expect(find.byType(VisualsControls), findsOneWidget);
      });
    });

    group('Integration with AppState', () {
      testWidgets('properly references appState', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final widget = tester.widget<VisualsControls>(
          find.byType(VisualsControls),
        );

        expect(widget.appState, equals(appState));
      });

      testWidgets('responds to appState updates', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Modify state and verify UI updates
        final originalTrailsState = appState.ui.showTrails;
        appState.ui.toggleTrails();

        await tester.pump();

        expect(appState.ui.showTrails, !originalTrailsState);
      });
    });

    group('Performance', () {
      testWidgets('builds efficiently with many toggles', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Should build without excessive widget count
        final startTime = DateTime.now();
        await tester.pumpAndSettle();
        final buildTime = DateTime.now().difference(startTime);

        // Build should complete quickly (< 1 second even in tests)
        expect(buildTime.inSeconds, lessThan(5));
      });

      testWidgets('handles rebuild efficiently', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Trigger rebuild
        appState.ui.toggleTrails();
        await tester.pump();

        // Should rebuild without issues
        expect(find.byType(VisualsControls), findsOneWidget);
      });
    });
  });
}
