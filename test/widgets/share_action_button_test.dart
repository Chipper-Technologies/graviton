import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/widgets/share_action_button.dart';

import '../test_utils.dart';

void main() {
  group('ShareActionButton', () {
    late SimulationState simulationState;
    final GlobalKey repaintBoundaryKey = GlobalKey();

    setUp(() {
      simulationState = SimulationState();
      // Initialize simulation with a scenario so we have bodies
      final localization = TestUtils.createMockAppLocalizations();
      simulationState.updateLocalization(localization);
      simulationState.resetWithScenario(ScenarioType.solarSystem);
    });

    tearDown(() {
      simulationState.dispose();
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ShareActionButton(
            simulationState: simulationState,
            repaintBoundaryKey: repaintBoundaryKey,
          ),
        ),
      );
    }

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ShareActionButton), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('shows share dialog when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap the share button
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Share Simulation'), findsOneWidget);
      expect(find.text('Share Image'), findsOneWidget);
      expect(find.text('Share State'), findsOneWidget);
    });

    testWidgets('displays correct share image description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(find.text('Capture and share the current view'), findsOneWidget);
    });

    testWidgets('displays correct share state description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(
        find.text('Export simulation data as importable file'),
        findsOneWidget,
      );
    });

    testWidgets('closes dialog when cancelled', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Open dialog
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap outside dialog to dismiss
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('dialog contains image icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('dialog contains code icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.code), findsOneWidget);
    });

    testWidgets('displays share icon correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final iconFinder = find.byIcon(Icons.share);
      expect(iconFinder, findsOneWidget);

      final Icon icon = tester.widget(iconFinder);
      expect(icon.icon, equals(Icons.share));
    });

    testWidgets('works without optional callbacks', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ShareActionButton(
              simulationState: simulationState,
              repaintBoundaryKey: repaintBoundaryKey,
            ),
          ),
        ),
      );

      // Should not crash without callbacks
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Dialog should still open
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('has correct button structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should have the button wrapped in appropriate widgets
      expect(find.byType(ShareActionButton), findsOneWidget);

      // Share icon should be present
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('dialog has correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Check dialog structure
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2)); // Two options
      expect(find.byType(Column), findsWidgets); // Dialog content
    });

    testWidgets('dialog title uses correct styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Find the title text
      final titleFinder = find.text('Share Simulation');
      expect(titleFinder, findsOneWidget);

      // Verify it's displayed
      final Text titleWidget = tester.widget(titleFinder);
      expect(titleWidget.data, equals('Share Simulation'));
    });

    testWidgets('list tiles have correct structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Find list tiles
      final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
      expect(listTiles.length, equals(2));

      // Both should have leading icons
      for (final tile in listTiles) {
        expect(tile.leading, isNotNull);
      }
    });

    testWidgets('can be created with minimal parameters', (
      WidgetTester tester,
    ) async {
      final widget = ShareActionButton(
        simulationState: simulationState,
        repaintBoundaryKey: repaintBoundaryKey,
      );

      expect(widget.simulationState, equals(simulationState));
      expect(widget.repaintBoundaryKey, equals(repaintBoundaryKey));
    });

    testWidgets('dialog options are tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Should be able to find and tap the options
      final shareImageFinder = find.text('Share Image');
      final shareStateFinder = find.text('Share State');

      expect(shareImageFinder, findsOneWidget);
      expect(shareStateFinder, findsOneWidget);

      // Verify they're in tappable widgets
      expect(
        find.ancestor(of: shareImageFinder, matching: find.byType(ListTile)),
        findsOneWidget,
      );

      expect(
        find.ancestor(of: shareStateFinder, matching: find.byType(ListTile)),
        findsOneWidget,
      );
    });

    testWidgets('maintains simulation state reference', (
      WidgetTester tester,
    ) async {
      final widget = ShareActionButton(
        simulationState: simulationState,
        repaintBoundaryKey: repaintBoundaryKey,
      );

      // Should maintain the same reference
      expect(identical(widget.simulationState, simulationState), isTrue);
    });

    testWidgets('showShareOptions can be called programmatically', (
      WidgetTester tester,
    ) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ShareActionButton(
              key: key,
              simulationState: simulationState,
              repaintBoundaryKey: repaintBoundaryKey,
            ),
          ),
        ),
      );

      // Get the context and call showShareOptions
      final context = key.currentContext!;
      final widget = key.currentWidget as ShareActionButton;

      // Call the method
      widget.showShareOptions(context);
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
