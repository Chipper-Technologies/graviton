import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/physics_bottom_sheet.dart';
import 'package:graviton/widgets/bottom_sheet_handle.dart';
import 'package:graviton/widgets/bottom_sheet_header.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';

void main() {
  group('PhysicsBottomSheet', () {
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
          body: PhysicsBottomSheet(
            appState: appState,
            scrollController: scrollController,
          ),
        ),
      );
    }

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(PhysicsBottomSheet), findsOneWidget);
      expect(find.byType(BottomSheetHandle), findsOneWidget);
      expect(find.byType(BottomSheetHeader), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays correct header', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.science), findsOneWidget);
      expect(find.text('Physics'), findsOneWidget);
    });

    testWidgets('displays physics visualization section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Physics Visualization'), findsOneWidget);
      expect(find.text('Gravity Fields'), findsOneWidget);
      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });

    testWidgets('displays debug statistics section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Debug & Statistics'), findsOneWidget);
      expect(find.text('Show Statistics'), findsOneWidget);
    });

    testWidgets('can toggle gravity fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final initialGravityFields = appState.ui.globalGravityFields;

      // Find and tap the gravity fields switch
      final gravityFieldsSwitch = find.byType(Switch).first;
      await tester.tap(gravityFieldsSwitch);
      await tester.pump();

      expect(appState.ui.globalGravityFields, !initialGravityFields);
    });

    testWidgets('shows gravity field options when gravity fields enabled', (
      WidgetTester tester,
    ) async {
      // Enable gravity fields
      appState.ui.toggleGlobalGravityFields();

      await tester.pumpWidget(createTestWidget());

      // Should show additional gravity field options
      expect(find.text('Equipotential Surfaces'), findsOneWidget);
      expect(find.text('Field Strength Indicators'), findsOneWidget);
      expect(find.text('Gravity Field Colors'), findsOneWidget);
    });

    testWidgets('hides gravity field options when gravity fields disabled', (
      WidgetTester tester,
    ) async {
      // Ensure gravity fields are disabled
      if (appState.ui.globalGravityFields) {
        appState.ui.toggleGlobalGravityFields();
      }

      await tester.pumpWidget(createTestWidget());

      // Should not show additional gravity field options
      expect(find.text('Equipotential Surfaces'), findsNothing);
      expect(find.text('Field Strength Indicators'), findsNothing);
      expect(find.text('Gravity Field Colors'), findsNothing);
    });

    testWidgets('displays color scheme options when gravity fields enabled', (
      WidgetTester tester,
    ) async {
      // Enable gravity fields
      appState.ui.toggleGlobalGravityFields();

      await tester.pumpWidget(createTestWidget());

      // Should show color scheme options
      expect(find.text('Classic'), findsOneWidget);
      expect(find.text('Spectral'), findsOneWidget);
      expect(find.text('Monochrome'), findsOneWidget);
      expect(find.text('Neon'), findsOneWidget);
      expect(find.text('Emerald'), findsOneWidget);
    });

    testWidgets('can select different color schemes', (
      WidgetTester tester,
    ) async {
      // Enable gravity fields
      appState.ui.toggleGlobalGravityFields();

      await tester.pumpWidget(createTestWidget());

      // Tap on spectral color scheme
      final spectralOption = find.text('Spectral');
      expect(spectralOption, findsOneWidget);

      await tester.tap(spectralOption);
      await tester.pump();

      expect(
        appState.ui.gravityFieldColorScheme,
        GravityFieldColorScheme.spectral,
      );
    });

    testWidgets('can toggle statistics display', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final initialShowStats = appState.ui.showStats;

      // Find the statistics switch
      final switches = find.byType(Switch);
      final statsSwitch = switches.last; // Statistics switch should be last

      await tester.tap(statsSwitch);
      await tester.pump();

      expect(appState.ui.showStats, !initialShowStats);
    });

    testWidgets('shows current statistics when stats enabled', (
      WidgetTester tester,
    ) async {
      // Enable statistics
      appState.ui.toggleStats();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Ensure all animations complete

      // Scroll to make sure the statistics section is visible
      await tester.drag(find.byType(PhysicsBottomSheet), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Should show current statistics section
      expect(find.text('Current Statistics'), findsOneWidget);
      expect(find.text('Bodies'), findsOneWidget);
      expect(find.text('Time Scale'), findsOneWidget);
    });

    testWidgets('hides current statistics when stats disabled', (
      WidgetTester tester,
    ) async {
      // Ensure statistics are disabled
      if (appState.ui.showStats) {
        appState.ui.toggleStats();
      }

      await tester.pumpWidget(createTestWidget());

      // Should not show current statistics section
      expect(find.text('Current Statistics'), findsNothing);
    });

    testWidgets('displays correct statistics values', (
      WidgetTester tester,
    ) async {
      // Enable statistics
      appState.ui.toggleStats();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Ensure all animations complete

      // Scroll to make sure the statistics section is visible
      await tester.drag(find.byType(PhysicsBottomSheet), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Should show body count (use findsAny to be more flexible)
      final bodyCount = appState.simulation.bodies.length;
      expect(find.textContaining('$bodyCount'), findsAtLeastNWidgets(1));

      // Should show time scale (be more flexible with format)
      final timeScale = appState.simulation.timeScale.toStringAsFixed(1);
      expect(find.textContaining(timeScale), findsAtLeastNWidgets(1));
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

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(
        decoration.color,
        AppColors.uiBlack.withValues(alpha: AppTypography.opacityMediumHigh),
      );
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('displays proper section titles', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SectionTitle), findsWidgets);
      expect(find.text('Physics Visualization'), findsOneWidget);
      expect(find.text('Debug & Statistics'), findsOneWidget);
    });

    testWidgets('responds to app state changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Change gravity fields state
      appState.ui.toggleGlobalGravityFields();
      await tester.pump();

      // Should reflect the change
      expect(appState.ui.globalGravityFields, isTrue);
    });

    testWidgets('has proper accessibility features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Should have proper semantic structure
      expect(find.byType(Material), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('can toggle equipotential surfaces', (
      WidgetTester tester,
    ) async {
      // Enable gravity fields first
      appState.ui.toggleGlobalGravityFields();

      await tester.pumpWidget(createTestWidget());

      final initialEquipotential = appState.ui.showEquipotentialSurfaces;

      // Find and tap the equipotential surfaces option
      final equipotentialText = find.text('Equipotential Surfaces');
      expect(equipotentialText, findsOneWidget);

      await tester.tap(equipotentialText);
      await tester.pump();

      expect(appState.ui.showEquipotentialSurfaces, !initialEquipotential);
    });

    testWidgets('can toggle gravity field indicators', (
      WidgetTester tester,
    ) async {
      // Enable gravity fields first
      appState.ui.toggleGlobalGravityFields();

      await tester.pumpWidget(createTestWidget());

      final initialIndicators = appState.ui.showGravityFieldIndicators;

      // Find and tap the gravity field indicators option
      final indicatorsText = find.text('Field Strength Indicators');
      expect(indicatorsText, findsOneWidget);

      await tester.tap(indicatorsText);
      await tester.pump();

      expect(appState.ui.showGravityFieldIndicators, !initialIndicators);
    });

    testWidgets('maintains consistent layout across different states', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Test with different gravity field states
      appState.ui.toggleGlobalGravityFields();
      await tester.pump();

      // Should always show basic structure
      expect(find.byType(BottomSheetHandle), findsOneWidget);
      expect(find.byType(BottomSheetHeader), findsOneWidget);

      // Test with statistics enabled/disabled
      appState.ui.toggleStats();
      await tester.pump();

      // Should not throw errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('has proper platform-specific padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final listView = tester.widget<ListView>(find.byType(ListView));
      final padding = listView.padding as EdgeInsets;

      expect(padding.left, AppTypography.spacingXLarge);
      expect(padding.right, AppTypography.spacingXLarge);
      expect(padding.top, AppTypography.spacingXLarge);
      // Bottom should be at least the base spacing
      expect(padding.bottom, greaterThanOrEqualTo(AppTypography.spacingXLarge));
    });

    testWidgets('handles edge cases with selected body', (
      WidgetTester tester,
    ) async {
      // Enable statistics and select a body
      appState.ui.toggleStats();
      appState.camera.selectBody(0);

      await tester.pumpWidget(createTestWidget());

      // Should handle selected body display without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('color scheme selection visual feedback', (
      WidgetTester tester,
    ) async {
      // Enable gravity fields
      appState.ui.toggleGlobalGravityFields();

      await tester.pumpWidget(createTestWidget());

      // Should show radio button icons for selection
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      ); // One should be selected
      expect(
        find.byIcon(Icons.radio_button_unchecked),
        findsWidgets,
      ); // Others should be unselected
    });

    testWidgets('handles multiple simultaneous option changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Toggle multiple options
      appState.ui.toggleGlobalGravityFields();
      appState.ui.toggleStats();
      await tester.pump();

      appState.ui.toggleEquipotentialSurfaces();
      appState.ui.toggleGravityFieldIndicators();
      await tester.pump();

      // Should handle all changes without errors
      expect(tester.takeException(), isNull);
      expect(find.byType(PhysicsBottomSheet), findsOneWidget);
    });
  });
}
