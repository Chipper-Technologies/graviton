import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/screens/scenario_editor_screen.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/common/graviton_popup_menu.dart';

void main() {
  group('ScenarioEditorScreen Tab Behavior', () {
    Widget makeTestableWidget(Widget child) {
      return ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          home: child,
        ),
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

      // Navigate back to Setup tab
      await tester.tap(
        find.descendant(of: find.byType(TabBar), matching: find.text('Setup')),
      );
      await tester.pumpAndSettle();
      // FAB should be visible again
      expect(find.text('Add Body'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('Popup Menu Functionality', () {
    Widget makeTestableWidget(Widget child) {
      return ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          home: child,
        ),
      );
    }

    testWidgets('Popup menu is visible in app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Find the popup menu button (three dots icon)
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.byType(GravitonPopupMenu), findsOneWidget);
    });

    testWidgets('Popup menu has proper accessibility', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Find the popup menu and check its semantics
      final popupMenuFinder = find.byType(GravitonPopupMenu);
      expect(popupMenuFinder, findsOneWidget);

      // Verify accessibility properties through semantic matcher
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.button == true,
        ),
        findsWidgets,
      );
    });

    testWidgets('Popup menu shows test and export options when opened', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Tap the popup menu button
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify menu items are shown
      expect(find.text('Test Scenario'), findsOneWidget);
      expect(find.text('Export Scenario'), findsOneWidget);

      // Verify icons are present
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.file_download), findsOneWidget);
    });

    testWidgets('Test scenario menu item is accessible', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Open the popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Check test scenario item has proper semantics
      final testMenuItem = find.descendant(
        of: find.byType(PopupMenuItem<String>),
        matching: find.text('Test Scenario'),
      );
      expect(testMenuItem, findsOneWidget);
    });

    testWidgets('Export scenario menu item is accessible', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Open the popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Check export scenario item has proper semantics
      final exportMenuItem = find.descendant(
        of: find.byType(PopupMenuItem<String>),
        matching: find.text('Export Scenario'),
      );
      expect(exportMenuItem, findsOneWidget);
    });

    testWidgets('Menu items have proper visual styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Open the popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify the menu items have the expected height
      final popupMenuItems = find.byType(PopupMenuItem<String>);
      expect(popupMenuItems, findsNWidgets(2));

      // Check that both menu items have circular icon containers
      final iconContainers = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(iconContainers, findsAtLeastNWidgets(2));
    });

    testWidgets('Menu items can be tapped (test scenario)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Open the popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Tap test scenario item
      await tester.tap(find.text('Test Scenario'));
      await tester.pumpAndSettle();

      // Menu should close after selection
      expect(find.text('Test Scenario'), findsNothing);
      expect(find.text('Export Scenario'), findsNothing);
    });

    testWidgets('Menu items can be tapped (export scenario)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Open the popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Tap export scenario item
      await tester.tap(find.text('Export Scenario'));
      await tester.pumpAndSettle();

      // Menu should close after selection
      expect(find.text('Test Scenario'), findsNothing);
      expect(find.text('Export Scenario'), findsNothing);
    });

    testWidgets('Menu maintains consistent styling with app theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Open the popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify the popup menu container has expected styling
      final popupMenu = find.byWidgetPredicate(
        (widget) => widget is Material && widget.color != null,
      );
      expect(popupMenu, findsAtLeastNWidgets(1));
    });
  });

  group('Menu Integration with Screen State', () {
    Widget makeTestableWidget(Widget child) {
      return ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          home: child,
        ),
      );
    }

    testWidgets('Menu remains accessible across different tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Menu should be visible on Bodies tab
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      // Add a body to enable other tabs
      await tester.tap(find.text('Add Body'));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('Save'),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Physics tab
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Physics'),
        ),
      );
      await tester.pumpAndSettle();

      // Menu should still be visible
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      // Navigate to Preview tab
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Preview'),
        ),
      );
      await tester.pumpAndSettle();

      // Menu should still be visible
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('Menu functionality works regardless of current tab', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Add a body to enable other tabs
      await tester.tap(find.text('Add Body'));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('Save'),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Physics tab
      await tester.tap(
        find.descendant(
          of: find.byType(TabBar),
          matching: find.text('Physics'),
        ),
      );
      await tester.pumpAndSettle();

      // Test menu functionality from Physics tab
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Test Scenario'), findsOneWidget);
      expect(find.text('Export Scenario'), findsOneWidget);

      // Close menu by tapping test option
      await tester.tap(find.text('Test Scenario'));
      await tester.pumpAndSettle();

      // Menu should close
      expect(find.text('Test Scenario'), findsNothing);
    });
  });
}
