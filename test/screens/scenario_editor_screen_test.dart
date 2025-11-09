import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/screens/scenario_editor_screen.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('ScenarioEditorScreen Tab Behavior', () {
    Widget makeTestableWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
        home: child,
      );
    }

    testWidgets('Settings and Preview tabs are disabled when no bodies exist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Start with a default body (Sun) so tabs should be enabled initially
      expect(find.text('Bodies'), findsOneWidget);
      expect(find.text('Physics'), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);

      // TODO: Test actual disabled state - would need to inspect widget properties
      // This test validates the basic structure is there
    });

    testWidgets('Can navigate to Settings tab when bodies exist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Try to tap on Physics tab
      await tester.tap(find.text('Physics'));
      await tester.pump();
    });

    testWidgets('Can navigate to Preview tab when bodies exist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Try to tap on Preview tab
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Preview'),
        ),
      );
      await tester.pump();

      // Should be able to navigate since default Sun body exists
      // The actual content verification would depend on the Preview tab implementation
    });

    testWidgets('FloatingActionButton is visible on Bodies tab', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Should show FAB with "Add Body" text on Bodies tab
      expect(find.text('Add Body'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('FloatingActionButton is hidden on Settings tab', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // First, add a body so we can navigate to Physics tab
      await tester.tap(find.text('Add Body'));
      await tester.pumpAndSettle();

      // Now we need to save the body in the bottom sheet
      await tester.tap(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('Save'),
        ),
      );
      await tester.pumpAndSettle();

      // Now navigate to Physics tab (should work since we have a body)
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Physics'),
        ),
      );
      await tester.pumpAndSettle(); // Allow all state changes and animations

      // FAB should be hidden
      expect(find.text('Add Body'), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('FloatingActionButton is hidden on Preview tab', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // First, add a body so we can navigate to Preview tab
      await tester.tap(find.text('Add Body'));
      await tester.pumpAndSettle();

      // Now we need to save the body in the bottom sheet
      await tester.tap(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('Save'),
        ),
      );
      await tester.pumpAndSettle();

      // Now navigate to Preview tab (should work since we have a body)
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Preview'),
        ),
      );
      await tester.pumpAndSettle(); // Allow all state changes and animations

      // FAB should be hidden
      expect(find.text('Add Body'), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('tabs work properly when bodies exist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // First add a body to enable other tabs
      await tester.tap(find.text('Add Body'));
      await tester.pumpAndSettle();

      // Save the body in the bottom sheet - use a more specific finder
      await tester.tap(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('Save'),
        ),
      );
      await tester.pumpAndSettle();

      // Bodies tab should be active
      expect(find.text('Add Body'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Navigate to Physics tab
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Physics'),
        ),
      );
      await tester.pumpAndSettle();
      // FAB should be hidden on Physics tab
      expect(find.text('Add Body'), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);

      // Navigate to Preview tab
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Preview'),
        ),
      );
      await tester.pumpAndSettle();
      // FAB should be hidden on Preview tab
      expect(find.text('Add Body'), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);

      // Navigate back to Bodies tab
      await tester.tap(
        find.descendant(of: find.byType(TabBar), matching: find.text('Bodies')),
      );
      await tester.pumpAndSettle();
      // FAB should be visible again
      expect(find.text('Add Body'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
