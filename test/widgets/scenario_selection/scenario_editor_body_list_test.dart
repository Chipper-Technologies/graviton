import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_list.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('ScenarioEditorBodyList', () {
    late List<Body> testBodies;

    setUp(() {
      testBodies = [
        Body(
          name: 'Test Earth',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: Colors.blue,
          bodyType: BodyType.planet,
        ),
        Body(
          name: 'Test Sun',
          position: vm.Vector3(10.0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: 333000.0,
          radius: 109.0,
          color: Colors.yellow,
          bodyType: BodyType.star,
        ),
      ];
    });

    Widget makeTestableWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
        home: Scaffold(body: child),
      );
    }

    testWidgets('displays body list correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: testBodies,
            onBodiesChanged: (_) {},
            onAddBody: () {},
          ),
        ),
      );

      // Should display both bodies
      expect(find.text('Test Earth'), findsOneWidget);
      expect(find.text('Test Sun'), findsOneWidget);
    });

    testWidgets('displays empty state when no bodies', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: [],
            onBodiesChanged: (_) {},
            onAddBody: () {},
          ),
        ),
      );

      expect(find.text('No bodies yet'), findsOneWidget);
      expect(
        find.text('Add celestial bodies to create your custom scenario'),
        findsOneWidget,
      );
    });

    testWidgets('shows correct pluralization for single body', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: [testBodies.first],
            onBodiesChanged: (_) {},
            onAddBody: () {},
          ),
        ),
      );

      // Check header shows singular form
      expect(find.text('1 Body'), findsOneWidget);
      expect(find.text('Test Earth'), findsOneWidget);
    });

    testWidgets('opens bottom sheet when body tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: testBodies,
            onBodiesChanged: (_) {},
            onAddBody: () {},
          ),
        ),
      );

      // Tap on the first body
      await tester.tap(find.text('Test Earth'));
      await tester.pumpAndSettle();

      // Should show body details bottom sheet with tabs and sections
      expect(find.text('Details'), findsOneWidget); // Details tab
      expect(find.text('Edit'), findsOneWidget); // Edit tab
      expect(find.text('Properties'), findsOneWidget); // Section in Details tab
    });

    testWidgets('duplicates body when duplicate button tapped', (
      WidgetTester tester,
    ) async {
      List<Body> updatedBodies = [];

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: testBodies,
            onBodiesChanged: (bodies) => updatedBodies = bodies,
            onAddBody: () {},
          ),
        ),
      );

      // Find and tap duplicate button for first body
      final duplicateButtons = find.byIcon(Icons.content_copy);
      expect(duplicateButtons, findsAtLeastNWidgets(1));

      await tester.tap(duplicateButtons.first);
      await tester.pump();

      // Should have called onBodiesChanged with duplicated body
      expect(updatedBodies.length, equals(3));
      expect(updatedBodies.last.name, equals('Test Earth Copy'));
      expect(updatedBodies.last.mass, equals(testBodies.first.mass));
      expect(updatedBodies.last.color, equals(testBodies.first.color));
    });

    testWidgets('deletes body when delete button tapped', (
      WidgetTester tester,
    ) async {
      List<Body> updatedBodies = [];

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: testBodies,
            onBodiesChanged: (bodies) => updatedBodies = bodies,
            onAddBody: () {},
          ),
        ),
      );

      // Find and tap delete button for first body
      final deleteButtons = find.byIcon(Icons.delete_outline);
      expect(deleteButtons, findsAtLeastNWidgets(1));

      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Confirm deletion in dialog
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should have called onBodiesChanged with body removed
      expect(updatedBodies.length, equals(1));
      expect(updatedBodies.first.name, equals('Test Sun'));
    });

    testWidgets('hides delete button when only one body exists', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: [testBodies.first],
            onBodiesChanged: (_) {},
            onAddBody: () {},
          ),
        ),
      );

      // Should not show delete button
      expect(find.byIcon(Icons.delete_outline), findsNothing);

      // But should still show duplicate button
      expect(find.byIcon(Icons.content_copy), findsOneWidget);
    });

    testWidgets('displays body count in header', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: testBodies,
            onBodiesChanged: (_) {},
            onAddBody: () {},
          ),
        ),
      );

      // Check that the header displays the correct body count
      expect(find.text('2 Bodies'), findsOneWidget);
    });

    testWidgets('shows body properties correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyList(
            bodies: testBodies,
            onBodiesChanged: (_) {},
            onAddBody: () {},
          ),
        ),
      );

      // Check body type and mass are displayed
      expect(find.textContaining('planet • 0.100 M☉'), findsOneWidget);
      expect(find.textContaining('star • 33,300 M☉'), findsOneWidget);
    });
  });
}
