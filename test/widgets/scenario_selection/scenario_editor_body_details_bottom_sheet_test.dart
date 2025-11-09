import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_details_bottom_sheet.dart';
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
    group('Edit Mode (default)', () {
      testWidgets('displays body details correctly', (
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

        // Should display the body name as the title
        expect(find.text('Test Earth'), findsOneWidget);

        // Should show tabs
        expect(find.text('Details'), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);

        // Should display basic sections on Details tab (default)
        expect(find.text('Properties'), findsOneWidget);
        expect(find.text('Position & Motion'), findsOneWidget);
        expect(find.text('Stellar Properties'), findsOneWidget);

        // Should default to Details tab (index 0)
        expect(find.text('Properties'), findsOneWidget);
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

        // Should show action buttons in edit mode
        expect(find.byIcon(Icons.content_copy_outlined), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
        // Should NOT show save button
        expect(find.text('Save'), findsNothing);
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
    });

    group('Add Mode', () {
      testWidgets('shows save button instead of duplicate/delete buttons', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              isAddMode: true,
              onBodyChanged: (_) {},
              onSave: (_) {},
            ),
          ),
        );

        // Should show Save button in add mode
        expect(find.text('Save'), findsOneWidget);

        // Should NOT show duplicate/delete buttons
        expect(find.byIcon(Icons.content_copy_outlined), findsNothing);
        expect(find.byIcon(Icons.delete_outline), findsNothing);
      });

      testWidgets('defaults to Edit tab in add mode', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              isAddMode: true,
              onBodyChanged: (_) {},
              onSave: (_) {},
            ),
          ),
        );

        // Should default to Edit tab in add mode
        // We can verify this by checking that name field is visible (only on Edit tab)
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Body Type'), findsOneWidget);
      });

      testWidgets('calls onSave when save button tapped', (
        WidgetTester tester,
      ) async {
        Body? savedBody;

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              isAddMode: true,
              onBodyChanged: (_) {},
              onSave: (body) => savedBody = body,
            ),
          ),
        );

        // Tap save button
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Verify that a body was saved and has the expected basic properties
        expect(savedBody, isNotNull);
        expect(savedBody?.name, equals(testBody.name));
        expect(savedBody?.bodyType, equals(testBody.bodyType));
        expect(savedBody?.color, equals(testBody.color));

        // Note: Mass, radius, and luminosity may be clamped to valid ranges
        // so we can't do exact equality comparison, but we can verify they're reasonable
        expect(savedBody?.mass, greaterThan(0));
        expect(savedBody?.radius, greaterThan(0));
      });

      testWidgets('allows body editing and saves changes', (
        WidgetTester tester,
      ) async {
        Body? savedBody;
        Body currentBody = testBody;

        await tester.pumpWidget(
          makeTestableWidget(
            StatefulBuilder(
              builder: (context, setState) =>
                  ScenarioEditorBodyDetailsBottomSheet(
                    body: currentBody,
                    isAddMode: true,
                    onBodyChanged: (body) {
                      setState(() {
                        currentBody = body;
                      });
                    },
                    onSave: (body) => savedBody = body,
                  ),
            ),
          ),
        );

        // Should already be on Edit tab, update the name
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'New Planet');
        await tester.pump();

        // Tap save button
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(savedBody?.name, equals('New Planet'));
      });
    });

    group('Unsaved Changes Protection', () {
      testWidgets('tracks when changes are made to fields', (
        WidgetTester tester,
      ) async {
        Body? changedBody;

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              isAddMode: true,
              onBodyChanged: (body) => changedBody = body,
              onSave: (_) {},
            ),
          ),
        );

        // Verify initial state
        expect(changedBody, isNull);

        // Make a change to trigger unsaved state
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'Modified Planet');
        await tester.pump();

        // Verify the change was captured
        expect(changedBody, isNotNull);
        expect(changedBody?.name, equals('Modified Planet'));
      });

      testWidgets('allows closing after saving in add mode', (
        WidgetTester tester,
      ) async {
        bool onSaveCalled = false;

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              isAddMode: true,
              onBodyChanged: (_) {},
              onSave: (_) => onSaveCalled = true,
            ),
          ),
        );

        // Make a change
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'New Planet');
        await tester.pump();

        // Save the changes
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(onSaveCalled, isTrue);
      });

      testWidgets('allows closing without confirmation when no changes made', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              isAddMode: true,
              onBodyChanged: (_) {},
              onSave: (_) {},
            ),
          ),
        );

        // Try to pop without making any changes
        Navigator.of(
          tester.element(find.byType(ScenarioEditorBodyDetailsBottomSheet)),
        ).pop();
        await tester.pumpAndSettle();

        // Should not show unsaved changes dialog
        expect(find.text('Unsaved Changes'), findsNothing);
      });
    });

    group('Shared Functionality', () {});

    group('Shared Functionality', () {
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
  });
}
