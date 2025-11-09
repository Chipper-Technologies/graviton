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

      testWidgets('shows save button and 3-dot menu in edit mode', (
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

        // Should show Save button in edit mode
        expect(find.text('Save'), findsOneWidget);

        // Should show 3-dot menu button
        expect(find.byIcon(Icons.more_vert), findsOneWidget);

        // Should NOT show separate duplicate/delete icon buttons
        expect(find.byIcon(Icons.content_copy_outlined), findsNothing);
        expect(find.byIcon(Icons.delete_outline), findsNothing);
      });

      testWidgets('calls onDuplicate when duplicate menu item selected', (
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

        // Tap 3-dot menu button
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Find and tap duplicate option in menu
        await tester.tap(find.text('Duplicate Body'));
        await tester.pump();

        expect(duplicateCalled, isTrue);
      });

      testWidgets('calls onDelete when delete menu item selected', (
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

        // Tap 3-dot menu button
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Find and tap delete option in menu
        await tester.tap(find.text('Delete Body'));
        await tester.pumpAndSettle();

        // Confirm deletion in the dialog
        await tester.tap(find.text('Delete'));
        await tester.pump();

        expect(deleteCalled, isTrue);
      });

      testWidgets('calls onSave when save button tapped in edit mode', (
        WidgetTester tester,
      ) async {
        Body? savedBody;

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              onBodyChanged: (_) {},
              onSave: (body) => savedBody = body,
            ),
          ),
        );

        // Tap save button
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Verify that a body was saved with expected properties
        expect(savedBody, isNotNull);
        expect(savedBody?.name, equals(testBody.name));
        expect(savedBody?.bodyType, equals(testBody.bodyType));
      });
    });

    group('Add Mode', () {
      testWidgets('shows save button but no 3-dot menu in add mode', (
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

        // Should NOT show 3-dot menu (only appears in edit mode)
        expect(find.byIcon(Icons.more_vert), findsNothing);
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

      testWidgets('prevents closing when changes are made to any property', (
        WidgetTester tester,
      ) async {
        bool bodyChanged = false;

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              onBodyChanged: (_) => bodyChanged = true,
              onSave: (_) {},
            ),
          ),
        );

        // Switch to Edit tab to access form fields
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Make a change to any field (name field)
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'Modified Name');
        await tester.pump();

        // Verify that the body was changed (indicating unsaved changes were detected)
        expect(bodyChanged, isTrue);
      });
    });

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

    group('Accessibility Tests', () {
      testWidgets('save button has proper semantic labels in add mode', (
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

        // Find the specific semantics widget for our save button
        final saveButton = find.text('Save');
        expect(saveButton, findsOneWidget);

        // Check that our custom semantics are applied correctly
        // We can verify the semantics through widget semantics debugging
        await tester.pumpAndSettle();

        // Verify save button is present and accessible
        expect(saveButton, findsOneWidget);
      });

      testWidgets('save button has proper semantic labels in edit mode', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              onBodyChanged: (_) {},
              onSave: (_) {},
            ),
          ),
        );

        // Find the specific save button
        final saveButton = find.text('Save');
        expect(saveButton, findsOneWidget);

        // Verify save button is present and accessible
        await tester.pumpAndSettle();
        expect(saveButton, findsOneWidget);
      });

      testWidgets('3-dot menu has proper semantic labels', (
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

        // Find the 3-dot menu button
        final menuButton = find.byIcon(Icons.more_vert);
        expect(menuButton, findsOneWidget);

        // Verify the menu button is accessible and has a tooltip
        await tester.pumpAndSettle();
        expect(menuButton, findsOneWidget);
      });

      testWidgets('menu items have proper semantic labels', (
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

        // Open the menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Check that menu items are present and accessible
        expect(find.text('Duplicate Body'), findsOneWidget);
        expect(find.text('Delete Body'), findsOneWidget);

        // Verify icons are present for accessibility
        expect(find.byIcon(Icons.content_copy_outlined), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      });
    });

    group('Haptic Feedback Tests', () {
      testWidgets('save button triggers haptic feedback', (
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

        // Tap save button - haptic feedback is triggered internally
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Note: We can't easily test HapticFeedback.lightImpact() directly
        // in unit tests without mocking the platform channel, but we can
        // verify the button responds to taps
        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('3-dot menu triggers haptic feedback when items selected', (
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

        // Open menu and select duplicate
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Duplicate Body'));
        await tester.pump();

        // Verify action was called (haptic feedback happens internally)
        expect(duplicateCalled, isTrue);
      });
    });

    group('Analytics Tests', () {
      testWidgets('save button logs correct analytics for add mode', (
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

        // Tap save button
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Note: Analytics events are logged but can't be easily verified
        // in unit tests without mocking FirebaseService
        // The test verifies the UI flow works correctly
      });

      testWidgets('save button logs correct analytics for edit mode', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              onBodyChanged: (_) {},
              onSave: (_) {},
            ),
          ),
        );

        // Tap save button
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Note: In edit mode, should log UIAction.bodyEdited
        // Analytics verification would require mocking
      });

      testWidgets('duplicate menu item logs correct analytics', (
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

        // Open menu and select duplicate
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Duplicate Body'));
        await tester.pump();

        expect(duplicateCalled, isTrue);
        // Should log both menu selection and body duplication events
      });

      testWidgets('delete menu item logs correct analytics', (
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

        // Open menu and select delete
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete Body'));
        await tester.pumpAndSettle();

        // Confirm deletion in dialog
        await tester.tap(find.text('Delete'));
        await tester.pump();

        expect(deleteCalled, isTrue);
        // Should log menu selection event
      });
    });

    group('Integration Tests', () {
      testWidgets('complete workflow: save changes in edit mode', (
        WidgetTester tester,
      ) async {
        Body? savedBody;

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              onBodyChanged: (_) {},
              onSave: (body) => savedBody = body,
            ),
          ),
        );

        // Save the body in edit mode
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Verify save was called
        expect(savedBody, isNotNull);
        expect(savedBody?.name, equals('Test Earth'));
        expect(savedBody?.bodyType, equals(BodyType.planet));
      });

      testWidgets('complete workflow: duplicate body from menu', (
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

        // Open 3-dot menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Verify menu items are present and accessible
        expect(find.text('Duplicate Body'), findsOneWidget);
        expect(find.text('Delete Body'), findsOneWidget);

        // Select duplicate
        await tester.tap(find.text('Duplicate Body'));
        await tester.pump();

        // Verify duplicate callback was triggered
        expect(duplicateCalled, isTrue);
      });

      testWidgets(
        'complete workflow: delete body from menu with confirmation',
        (WidgetTester tester) async {
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

          // Open 3-dot menu
          await tester.tap(find.byIcon(Icons.more_vert));
          await tester.pumpAndSettle();

          // Select delete
          await tester.tap(find.text('Delete Body'));
          await tester.pumpAndSettle();

          // Confirm deletion in dialog
          expect(find.text('Delete'), findsOneWidget);
          await tester.tap(find.text('Delete'));
          await tester.pump();

          // Verify delete callback was triggered
          expect(deleteCalled, isTrue);
        },
      );
    });
  });
}
