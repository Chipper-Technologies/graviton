import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/shared/widgets/controls/physics_controls.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/common/toggle_option.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Test scroll offset constants for PhysicsControls ListView navigation
/// These offsets scroll to specific sections of the controls panel
const kScrollToSimulationSpeedOffset = Offset(0, -400);
const kScrollToSimulationSpeedSectionOffset = Offset(0, -600);
const kScrollToSpeedPresetsOffset = Offset(0, -700);
const kScrollToDebugStatisticsOffset = Offset(0, -800);
const kScrollToStatisticsTableOffset = Offset(0, -1200);

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
              PhysicsControls(
                appState: appState,
                scrollController: ScrollController(),
              ),
        ),
      ),
    );
  }

  group('PhysicsControls', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(PhysicsControls), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays physics visualization section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Physics Visualization'), findsOneWidget);
      expect(find.byType(SectionDivider), findsWidgets);
    });

    testWidgets('displays physics toggle options', (WidgetTester tester) async {
      // Ensure gravity fields are enabled to show all options
      if (!appState.ui.globalGravityFields) {
        appState.ui.toggleGlobalGravityFields();
      }

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Gravity Fields'), findsOneWidget);
      expect(find.text('Equipotential Surfaces'), findsOneWidget);
      expect(find.text('Field Strength Indicators'), findsOneWidget);
      expect(find.byType(ToggleOption), findsWidgets);
    });

    testWidgets('can toggle global gravity fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.globalGravityFields;

      // Find and tap the global gravity fields toggle
      final gravityFieldsToggle = find.text('Gravity Fields');
      expect(gravityFieldsToggle, findsOneWidget);

      await tester.tap(gravityFieldsToggle);
      await tester.pump();

      expect(appState.ui.globalGravityFields, !initialState);
    });

    testWidgets('can toggle equipotential surfaces', (
      WidgetTester tester,
    ) async {
      // Ensure gravity fields are enabled to show equipotential surfaces option
      if (!appState.ui.globalGravityFields) {
        appState.ui.toggleGlobalGravityFields();
      }

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.showEquipotentialSurfaces;

      // Find and tap the equipotential surfaces toggle
      final equipotentialToggle = find.text('Equipotential Surfaces');
      expect(equipotentialToggle, findsOneWidget);

      await tester.tap(equipotentialToggle);
      await tester.pump();

      expect(appState.ui.showEquipotentialSurfaces, !initialState);
    });

    testWidgets('can toggle gravity field indicators', (
      WidgetTester tester,
    ) async {
      // Ensure gravity fields are enabled to show field indicators option
      if (!appState.ui.globalGravityFields) {
        appState.ui.toggleGlobalGravityFields();
      }

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final initialState = appState.ui.showGravityFieldIndicators;

      // Find and tap the gravity field indicators toggle
      final indicatorsToggle = find.text('Field Strength Indicators');
      expect(indicatorsToggle, findsOneWidget);

      await tester.tap(indicatorsToggle);
      await tester.pump();

      expect(appState.ui.showGravityFieldIndicators, !initialState);
    });

    testWidgets('displays statistics section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll down much further to see the debug & statistics section
      await tester.drag(find.byType(ListView), kScrollToDebugStatisticsOffset);
      await tester.pumpAndSettle();

      expect(find.text('Debug & Statistics'), findsOneWidget);
      expect(find.text('Show Statistics'), findsOneWidget);
    });

    testWidgets('can toggle statistics display', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll down much further to see the debug & statistics section
      await tester.drag(find.byType(ListView), kScrollToDebugStatisticsOffset);
      await tester.pumpAndSettle();

      final initialState = appState.ui.showStats;

      // Find and tap the statistics toggle
      final statsToggle = find.text('Show Statistics');
      expect(statsToggle, findsOneWidget);

      await tester.tap(statsToggle);
      await tester.pump();

      expect(appState.ui.showStats, !initialState);
    });

    testWidgets('displays simulation speed section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll down to see the simulation speed section
      await tester.drag(
        find.byType(ListView),
        kScrollToSimulationSpeedSectionOffset,
      );
      await tester.pumpAndSettle();

      expect(find.text('Simulation Speed'), findsOneWidget);
      expect(find.text('Speed'), findsOneWidget);
    });

    testWidgets('displays speed slider', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll down to see the simulation speed section
      await tester.drag(
        find.byType(ListView),
        kScrollToSimulationSpeedSectionOffset,
      );
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, 0.1);
      expect(slider.max, 16.0);
    });

    testWidgets('handles scroll controller correctly', (
      WidgetTester tester,
    ) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        createTestWidget(
          child: PhysicsControls(
            appState: appState,
            scrollController: scrollController,
          ),
        ),
      );

      expect(find.byType(PhysicsControls), findsOneWidget);

      // The ListView should use the provided scroll controller
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.controller, equals(scrollController));

      scrollController.dispose();
    });

    testWidgets('has correct styling and colors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PhysicsControls), findsOneWidget);

      // Verify proper padding and spacing
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, isNotNull);
    });

    testWidgets('displays proper section titles', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SectionDivider), findsWidgets);
      expect(find.text('Physics Visualization'), findsOneWidget);

      // Scroll down to see the other section titles
      await tester.drag(find.byType(ListView), kScrollToSimulationSpeedOffset);
      await tester.pumpAndSettle();

      expect(find.text('Simulation Speed'), findsOneWidget);

      // Scroll further to see debug & statistics
      await tester.drag(find.byType(ListView), kScrollToSimulationSpeedOffset);
      await tester.pumpAndSettle();

      expect(find.text('Debug & Statistics'), findsOneWidget);
    });

    testWidgets('has proper accessibility features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that toggles are accessible
      expect(find.byType(ToggleOption), findsWidgets);

      // Each toggle should be semantically labeled
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('handles toggle actions correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test multiple toggles
      final initialGravity = appState.ui.globalGravityFields;
      final initialStats = appState.ui.showStats;

      // Toggle gravity fields
      await tester.tap(find.text('Gravity Fields'));
      await tester.pump();
      expect(appState.ui.globalGravityFields, !initialGravity);

      // Scroll down to find statistics toggle
      await tester.drag(find.byType(ListView), kScrollToDebugStatisticsOffset);
      await tester.pumpAndSettle();

      // Toggle statistics
      await tester.tap(find.text('Show Statistics'));
      await tester.pump();
      expect(appState.ui.showStats, !initialStats);
    });

    testWidgets('displays gravity field color scheme selector', (
      WidgetTester tester,
    ) async {
      // Ensure gravity fields are enabled to show color scheme options
      if (!appState.ui.globalGravityFields) {
        appState.ui.toggleGlobalGravityFields();
      }

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show gravity field color scheme options when gravity fields are enabled
      expect(find.text('Gravity Field Colors'), findsOneWidget);
    });

    testWidgets('displays statistics table when enabled', (
      WidgetTester tester,
    ) async {
      // Ensure statistics are enabled
      if (!appState.ui.showStats) {
        appState.ui.toggleStats();
      }

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll down to see the statistics section
      await tester.drag(find.byType(ListView), kScrollToDebugStatisticsOffset);
      await tester.pumpAndSettle();

      // Then scroll further to see the actual statistics table when stats are enabled
      await tester.drag(find.byType(ListView), kScrollToSimulationSpeedOffset);
      await tester.pumpAndSettle();

      // If stats are enabled, should show various statistics
      if (appState.ui.showStats) {
        expect(find.text('Current Statistics'), findsOneWidget);
        expect(find.text('Bodies'), findsOneWidget);
        expect(find.text('Time Scale'), findsOneWidget);
      }
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

    testWidgets('maintains consistent layout across different states', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PhysicsControls), findsOneWidget);

      // Toggle some options and ensure layout remains consistent
      await tester.tap(find.text('Gravity Fields'));
      await tester.pump();

      expect(find.byType(PhysicsControls), findsOneWidget);
      // Layout should remain consistent
    });

    testWidgets('displays speed preset buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll down to see the speed preset buttons - need more scroll to reach them
      await tester.drag(find.byType(ListView), kScrollToSpeedPresetsOffset);
      await tester.pumpAndSettle();

      // Should have speed preset buttons
      expect(find.text('Half Speed'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Double'), findsOneWidget);
      expect(find.text('Very Fast'), findsOneWidget);
      expect(find.text('Maximum'), findsOneWidget);
    });

    testWidgets('responds to external state changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change state externally and verify UI updates
      final initialState = appState.ui.globalGravityFields;
      appState.ui.toggleGlobalGravityFields();

      await tester.pump();

      expect(appState.ui.globalGravityFields, !initialState);
      expect(find.byType(PhysicsControls), findsOneWidget);
    });
  });
}
