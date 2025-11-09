import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/widgets/scenario_editor_body_details_bottom_sheet.dart';
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
  late Body testBody;

  setUp(() {
    testBody = Body(
      name: 'Test Earth',
      position: vm.Vector3(0, 0, 0),
      velocity: vm.Vector3(1, 0, 0),
      mass: 5.972e24,
      radius: 6.371e6,
      color: Colors.blue,
      bodyType: BodyType.planet,
      isPlanet: true,
      temperature: 288.0,
      stellarLuminosity: 0.0,
      habitabilityStatus: HabitabilityStatus.habitable,
    );
  });

  group('ScenarioEditorBodyDetailsBottomSheet', () {
    testWidgets('displays body details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testBody,
            onBodyChanged: (_) {},
            onDuplicate: () {},
            onDelete: () {},
          ),
        ),
      );

      // Should display the body name as the title
      expect(find.text('Test Earth'), findsOneWidget);

      // Should show tabs
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);

      // Should display basic sections on Details tab (default)
      expect(find.text('Properties'), findsOneWidget);
      expect(find.text('Position & Motion'), findsOneWidget);
      expect(find.text('Stellar Properties'), findsOneWidget);
    });

    testWidgets('shows action buttons for duplicate and delete', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testBody,
            onBodyChanged: (_) {},
            onDuplicate: () {},
            onDelete: () {},
          ),
        ),
      );

      // Should show action buttons
      expect(find.byIcon(Icons.content_copy_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('calls onDuplicate when duplicate button tapped', (
      WidgetTester tester,
    ) async {
      bool duplicateCalled = false;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testBody,
            onBodyChanged: (_) {},
            onDuplicate: () => duplicateCalled = true,
            onDelete: () {},
          ),
        ),
      );

      // Tap duplicate button
      await tester.tap(find.byIcon(Icons.content_copy_outlined));
      await tester.pump();

      expect(duplicateCalled, isTrue);
    });

    testWidgets('calls onDelete when delete button tapped', (
      WidgetTester tester,
    ) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testBody,
            onBodyChanged: (_) {},
            onDuplicate: () {},
            onDelete: () => deleteCalled = true,
          ),
        ),
      );

      // Tap delete button to open confirmation dialog
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Confirm deletion in the dialog
      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('updates body name when text field changed', (
      WidgetTester tester,
    ) async {
      Body? updatedBody;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testBody,
            onBodyChanged: (body) => updatedBody = body,
            onDuplicate: () {},
            onDelete: () {},
          ),
        ),
      );

      // Switch to Edit tab to access text fields
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Find the name text field (should be the first one) and update it
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Updated Earth');
      await tester.pump();

      expect(updatedBody?.name, equals('Updated Earth'));
    });

    testWidgets('displays physics properties correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testBody,
            onBodyChanged: (_) {},
            onDuplicate: () {},
            onDelete: () {},
          ),
        ),
      );

      // Switch to Edit tab to see the input fields
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Should display section headers
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Body Type'), findsOneWidget);
      expect(find.text('Color'), findsOneWidget);
      expect(find.text('Position (m)'), findsOneWidget);
    });

    testWidgets('displays stellar properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testBody,
            onBodyChanged: (_) {},
            onDuplicate: () {},
            onDelete: () {},
          ),
        ),
      );

      // Should display stellar properties section
      expect(find.text('Stellar Properties'), findsOneWidget);
      expect(find.text('Temperature'), findsOneWidget);
    });
  });
}
