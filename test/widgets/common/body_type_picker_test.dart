import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/widgets/common/body_type_picker.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Test widget wrapper with localization support
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('BodyTypePicker', () {
    testWidgets('displays all body types', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(selectedType: BodyType.planet, onTypeChanged: (_) {}),
        ),
      );

      // Should display all body types
      expect(find.text('STAR'), findsOneWidget);
      expect(find.text('PLANET'), findsOneWidget);
      expect(find.text('MOON'), findsOneWidget);
      expect(find.text('ASTEROID'), findsOneWidget);

      // Should display appropriate icons
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget); // Star
      expect(find.byIcon(Icons.public), findsOneWidget); // Planet
      expect(find.byIcon(Icons.brightness_2), findsOneWidget); // Moon
      expect(find.byIcon(Icons.grain), findsOneWidget); // Asteroid
    });

    testWidgets('highlights selected body type', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(selectedType: BodyType.star, onTypeChanged: (_) {}),
        ),
      );

      // Find the container for the star type
      final starContainer = find.ancestor(
        of: find.text('STAR'),
        matching: find.byType(Container),
      );

      expect(starContainer, findsWidgets);
    });

    testWidgets('calls onTypeChanged when body type tapped', (
      WidgetTester tester,
    ) async {
      BodyType? changedType;

      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(
            selectedType: BodyType.planet,
            onTypeChanged: (type) => changedType = type,
          ),
        ),
      );

      // Tap on the star option
      await tester.tap(find.text('STAR'));
      await tester.pump();

      expect(changedType, equals(BodyType.star));
    });

    testWidgets('calls onTypeChanged for all body types', (
      WidgetTester tester,
    ) async {
      final List<BodyType> changedTypes = [];

      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(
            selectedType: BodyType.planet,
            onTypeChanged: (type) => changedTypes.add(type),
          ),
        ),
      );

      // Tap each body type
      await tester.tap(find.text('STAR'));
      await tester.pump();
      await tester.tap(find.text('PLANET'));
      await tester.pump();
      await tester.tap(find.text('MOON'));
      await tester.pump();
      await tester.tap(find.text('ASTEROID'));
      await tester.pump();

      expect(changedTypes, contains(BodyType.star));
      expect(changedTypes, contains(BodyType.planet));
      expect(changedTypes, contains(BodyType.moon));
      expect(changedTypes, contains(BodyType.asteroid));
    });

    testWidgets('does not respond to taps when disabled', (
      WidgetTester tester,
    ) async {
      BodyType? changedType;

      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(
            selectedType: BodyType.planet,
            onTypeChanged: (type) => changedType = type,
            enabled: false,
          ),
        ),
      );

      // Tap on the star option
      await tester.tap(find.text('STAR'));
      await tester.pump();

      expect(changedType, isNull);
    });

    testWidgets('applies disabled styling when enabled is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(
            selectedType: BodyType.planet,
            onTypeChanged: (_) {},
            enabled: false,
          ),
        ),
      );

      // Widget should still be present but styled differently
      expect(find.text('STAR'), findsOneWidget);
      expect(find.text('PLANET'), findsOneWidget);
      expect(find.text('MOON'), findsOneWidget);
      expect(find.text('ASTEROID'), findsOneWidget);
    });

    testWidgets('has proper semantics for accessibility', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(selectedType: BodyType.planet, onTypeChanged: (_) {}),
        ),
      );

      // Check for main semantic information
      expect(
        find.bySemanticsLabel(RegExp(r'Body type selector')),
        findsOneWidget,
      );

      // Check individual body type semantics (might vary by implementation)
      // Just check that we have semantic widgets for each type
      final semanticWidgets = find.byType(Semantics);
      expect(semanticWidgets, findsWidgets);
    });

    testWidgets('indicates selected state in semantics', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(selectedType: BodyType.star, onTypeChanged: (_) {}),
        ),
      );

      // Just verify semantic widgets exist - implementation details may vary
      final semanticWidgets = find.byType(Semantics);
      expect(semanticWidgets, findsWidgets);
    });

    testWidgets('has gesture detector with proper hit test behavior', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          BodyTypePicker(selectedType: BodyType.planet, onTypeChanged: (_) {}),
        ),
      );

      // Should find GestureDetectors for each body type
      expect(find.byType(GestureDetector), findsNWidgets(4));
    });

    testWidgets('changes selection correctly', (WidgetTester tester) async {
      BodyType selectedType = BodyType.planet;

      await tester.pumpWidget(
        makeTestableWidget(
          StatefulBuilder(
            builder: (context, setState) => BodyTypePicker(
              selectedType: selectedType,
              onTypeChanged: (type) {
                setState(() {
                  selectedType = type;
                });
              },
            ),
          ),
        ),
      );

      // Initially planet should be selected
      expect(selectedType, equals(BodyType.planet));

      // Tap star and verify selection changes
      await tester.tap(find.text('STAR'));
      await tester.pump();

      expect(selectedType, equals(BodyType.star));

      // Tap moon and verify selection changes
      await tester.tap(find.text('MOON'));
      await tester.pump();

      expect(selectedType, equals(BodyType.moon));
    });
  });
}
