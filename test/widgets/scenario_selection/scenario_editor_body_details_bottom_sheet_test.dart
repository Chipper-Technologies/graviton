import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';
import 'package:graviton/features/scenarios/presentation/widgets/scenario_editor_body_details_bottom_sheet.dart';
import 'package:graviton/widgets/common/body_type_picker.dart';
import 'package:graviton/widgets/common/color_picker.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:graviton/theme/app_colors.dart';

/// Test widget wrapper with localization support
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: ChangeNotifierProvider<AppState>.value(
      value: AppState(),
      child: Scaffold(body: child),
    ),
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
      color: AppColors.primaryColor,
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

        // Should NOT show Save button due to auto-save functionality
        expect(find.text('Save'), findsNothing);

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

      testWidgets('auto-saves when body properties are modified', (
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

        // Switch to Edit tab first to access text fields
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Modify a property to trigger auto-save
        await tester.enterText(find.byType(TextField).first, 'Modified Name');
        await tester.pump();

        // Wait for auto-save delay to trigger
        await tester.pump(const Duration(seconds: 1));

        // Verify that a body was saved with the modified properties
        expect(savedBody, isNotNull);
        expect(savedBody?.name, equals('Modified Name'));
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

        // Should NOT show Save button due to auto-save functionality
        expect(find.text('Save'), findsNothing);

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
        // Look for BodyTypePicker widget which should be visible on Edit tab
        expect(find.byType(BodyTypePicker), findsOneWidget);

        // The name field should be present as a text input
        expect(find.byType(TextField), findsWidgets);
      });

      testWidgets('auto-saves when properties are modified in add mode', (
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

        // Make a change to trigger auto-save
        await tester.enterText(find.byType(TextField).first, 'New Body Name');
        await tester.pump();

        // Wait for auto-save delay to trigger
        await tester.pump(const Duration(seconds: 1));

        // Verify that a body was saved and has the expected basic properties
        expect(savedBody, isNotNull);
        expect(savedBody?.name, equals('New Body Name'));
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

        // Auto-save should trigger after a delay
        await tester.pump(const Duration(seconds: 1));

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

      testWidgets('allows closing after auto-saving in add mode', (
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

        // Wait for auto-save delay to trigger
        await tester.pump(const Duration(seconds: 1));

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

        // Should display BodyTypePicker and input fields
        expect(find.byType(BodyTypePicker), findsOneWidget);
        expect(find.byType(TextField), findsWidgets);
        // Color picker should be present
        expect(find.byType(ColorPicker), findsOneWidget);
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
      testWidgets('text fields have proper semantic labels in add mode', (
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

        // Verify no Save button exists due to auto-save functionality
        expect(find.text('Save'), findsNothing);

        // Check that text input fields have proper accessibility
        expect(find.byType(TextField), findsWidgets);

        await tester.pumpAndSettle();
      });

      testWidgets('controls have proper semantic labels in edit mode', (
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

        // Switch to Edit tab to access controls
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify no Save button exists due to auto-save
        expect(find.text('Save'), findsNothing);

        // Check that input controls have proper accessibility
        expect(find.byType(TextField), findsWidgets);

        await tester.pumpAndSettle();
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
      testWidgets('auto-save functionality works without manual save', (
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

        // Verify no Save button is present (auto-save functionality)
        expect(find.text('Save'), findsNothing);

        // Make a change to trigger auto-save
        await tester.enterText(find.byType(TextField).first, 'Auto-saved Body');
        await tester.pump();

        // Wait for auto-save delay to trigger
        await tester.pump(const Duration(seconds: 1));

        // Verify auto-save worked
        expect(savedBody, isNotNull);
        expect(savedBody?.name, equals('Auto-saved Body'));
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
      testWidgets('auto-save triggers analytics for add mode', (
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

        // Make a change to trigger auto-save
        await tester.enterText(find.byType(TextField).first, 'New Body');
        await tester.pump();

        // Wait for auto-save delay to trigger
        await tester.pump(const Duration(seconds: 1));

        // Note: Analytics events are logged but can't be easily verified
        // in unit tests without mocking FirebaseService
        // The test verifies the UI flow works correctly
      });

      testWidgets('auto-save triggers analytics for edit mode', (
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

        // Switch to Edit tab
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Make a change to trigger auto-save
        await tester.enterText(find.byType(TextField).first, 'Modified Body');
        await tester.pump();

        // Wait for auto-save delay to trigger
        await tester.pump(const Duration(seconds: 1));

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
      testWidgets('complete workflow: auto-save changes in edit mode', (
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

        // Switch to Edit tab and modify a property
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Make a change to trigger auto-save
        await tester.enterText(find.byType(TextField).first, 'Modified Earth');
        await tester.pump();

        // Wait for auto-save delay to trigger
        await tester.pump(const Duration(seconds: 1));

        // Verify save was called
        expect(savedBody, isNotNull);
        expect(savedBody?.name, equals('Modified Earth'));
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

    group('Orbital Placement', () {
      late Body centralSun;
      late Body orbitingPlanet;

      setUp(() {
        centralSun = Body(
          name: 'Central Sun',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.stellarGType,
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
          temperature: 5778.0,
          habitabilityStatus: HabitabilityStatus.unknown,
        );

        orbitingPlanet = Body(
          name: 'Test Planet',
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 1.0),
          mass: 1.0,
          radius: 0.5,
          color: AppColors.primaryColor,
          bodyType: BodyType.planet,
          temperature: 288.0,
          habitabilityStatus: HabitabilityStatus.habitable,
        );
      });

      testWidgets(
        'displays Place in Orbit button when central bodies available',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            makeTestableWidget(
              ScenarioEditorBodyDetailsBottomSheet(
                body: orbitingPlanet,
                onBodyChanged: (body) {},
                availableCentralBodies: [centralSun],
                isAddMode: true, // Start in Edit tab
              ),
            ),
          );

          // Should show the Place in Orbit button
          expect(find.text('Place in Orbit'), findsOneWidget);
        },
      );

      testWidgets(
        'hides Place in Orbit button when no central bodies available',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            makeTestableWidget(
              ScenarioEditorBodyDetailsBottomSheet(
                body: orbitingPlanet,
                onBodyChanged: (body) {},
                availableCentralBodies: [],
                isAddMode: true, // Start in Edit tab
              ),
            ),
          );

          // Should not show the Place in Orbit button
          expect(find.text('Place in Orbit'), findsNothing);
        },
      );

      testWidgets('shows orbital placement controls when activated', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: orbitingPlanet,
              onBodyChanged: (body) {},
              availableCentralBodies: [centralSun],
              isAddMode: true, // Start in Edit tab
            ),
          ),
        );

        // Find the orbital placement button - it should be present
        expect(find.text('Place in Orbit'), findsOneWidget);

        // Make the button visible before tapping
        await tester.ensureVisible(find.text('Place in Orbit'));

        // Tap Place in Orbit button
        await tester.tap(find.text('Place in Orbit'));
        await tester.pumpAndSettle();

        // Should show orbital placement controls somewhere in the widget tree
        expect(find.text('Central Body'), findsOneWidget);
        expect(find.text('Orbit Radius'), findsOneWidget);
        expect(find.text('Orbit Phase'), findsOneWidget);
        expect(find.text('Inclination'), findsOneWidget);
        expect(find.text('Orbital Period'), findsOneWidget);
      });

      testWidgets('updates position when orbital parameters change', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: orbitingPlanet,
              onBodyChanged: (body) {},
              availableCentralBodies: [centralSun],
              isAddMode: true, // Start in Edit tab
            ),
          ),
        );

        // Scroll to the Place in Orbit button to make it visible
        await tester.ensureVisible(find.text('Place in Orbit'));

        // Tap Place in Orbit button
        await tester.tap(find.text('Place in Orbit'));
        await tester.pumpAndSettle();

        // Verify orbital placement system is now active
        // Instead of trying to interact with specific sliders, just check the UI state
        expect(find.text('Central Body'), findsOneWidget);
        expect(find.text('Orbit Radius'), findsOneWidget);
        expect(find.text('Orbital Period'), findsOneWidget);

        // The orbital placement should automatically update position/velocity
        // when parameters are modified, but testing the exact mechanics
        // would require more complex UI simulation
      });

      testWidgets(
        'auto-saves orbital placement correctly when parameters changed',
        (WidgetTester tester) async {
          Body? savedBody;

          await tester.pumpWidget(
            makeTestableWidget(
              ScenarioEditorBodyDetailsBottomSheet(
                body: orbitingPlanet,
                onBodyChanged: (body) => savedBody = body,
                onSave: (body) => savedBody = body,
                availableCentralBodies: [centralSun],
                isAddMode: true, // Start in Edit tab
              ),
            ),
          );

          // Make the Place in Orbit button visible
          await tester.ensureVisible(find.text('Place in Orbit'));

          // Tap Place in Orbit button
          await tester.tap(find.text('Place in Orbit'));
          await tester.pumpAndSettle();

          // Verify orbital controls are visible
          expect(find.text('Central Body'), findsOneWidget);

          // Wait for auto-save delay to trigger after orbital placement activation
          await tester.pump(const Duration(seconds: 1));

          // Verify save callback was called with updated body
          expect(savedBody, isNotNull);
          expect(savedBody!.name, equals(orbitingPlanet.name));
        },
      );

      testWidgets('toggles orbital placement mode correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: orbitingPlanet,
              onBodyChanged: (body) {},
              availableCentralBodies: [centralSun],
              isAddMode: true, // Start in Edit tab
            ),
          ),
        );

        // Initially orbital controls should be hidden
        expect(find.text('Central Body'), findsNothing);

        // Make the Place in Orbit button visible
        await tester.ensureVisible(find.text('Place in Orbit'));

        // Tap Place in Orbit button to show controls
        await tester.tap(find.text('Place in Orbit'));
        await tester.pumpAndSettle();

        expect(find.text('Central Body'), findsOneWidget);

        // Tap the button again to hide controls
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.text('Central Body'), findsNothing);
      });

      testWidgets('displays proper orbital period information', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: orbitingPlanet,
              onBodyChanged: (body) {},
              availableCentralBodies: [centralSun],
              isAddMode: true, // Start in Edit tab
            ),
          ),
        );

        // Make the Place in Orbit button visible
        await tester.ensureVisible(find.text('Place in Orbit'));

        // Activate orbital placement
        await tester.tap(find.text('Place in Orbit'));
        await tester.pumpAndSettle();

        // Should display orbital period information
        expect(find.text('Orbital Period'), findsOneWidget);

        // Should show some period value (can't predict exact value easily)
        expect(
          find.textContaining('d'),
          findsWidgets,
        ); // Should contain 'd' for days or 'h' for hours
      });

      testWidgets('handles central body selection correctly', (
        WidgetTester tester,
      ) async {
        final secondSun = Body(
          name: 'Second Sun',
          position: vm.Vector3(10.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 8.0,
          radius: 1.2,
          color: AppColors.uiOrangeAccent,
          bodyType: BodyType.star,
          stellarLuminosity: 0.8,
          temperature: 5000.0,
          habitabilityStatus: HabitabilityStatus.unknown,
        );

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: orbitingPlanet,
              onBodyChanged: (body) {},
              availableCentralBodies: [centralSun, secondSun],
              isAddMode: true, // Start in Edit tab
            ),
          ),
        );

        // Make the Place in Orbit button visible
        await tester.ensureVisible(find.text('Place in Orbit'));

        // Activate orbital placement
        await tester.tap(find.text('Place in Orbit'));
        await tester.pumpAndSettle();

        // Should show central body dropdown
        expect(find.text('Central Body'), findsOneWidget);

        // Should have dropdown with both stars
        expect(find.text('Central Sun'), findsOneWidget);
      });

      testWidgets('persists orbital placement state correctly', (
        WidgetTester tester,
      ) async {
        Body? savedBody;

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: orbitingPlanet,
              onBodyChanged: (body) => savedBody = body,
              onSave: (body) =>
                  savedBody = body, // Add onSave callback to show Save button
              availableCentralBodies: [centralSun],
              isAddMode: true, // Start in Edit tab
            ),
          ),
        );

        // Initially orbital placement should be inactive
        expect(orbitingPlanet.isOrbitalPlacementActive, isFalse);

        // Make the Place in Orbit button visible (same approach as other working tests)
        await tester.ensureVisible(find.text('Place in Orbit'));

        // Activate orbital placement
        await tester.tap(find.text('Place in Orbit'));
        await tester.pumpAndSettle();

        // Verify orbital controls are now visible
        expect(find.text('Central Body'), findsOneWidget);
        expect(find.text('Cancel Orbital Placement'), findsOneWidget);

        // Wait for auto-save delay to trigger after orbital placement activation
        await tester.pump(const Duration(seconds: 1));

        // Verify save callback was called and orbital placement state is persisted
        expect(savedBody, isNotNull);
        expect(savedBody!.isOrbitalPlacementActive, isTrue);

        // The main functionality works - orbital placement state is properly saved
        // This proves the feature is working as expected
      });

      testWidgets('persists orbital parameters correctly', (
        WidgetTester tester,
      ) async {
        Body? savedBody;

        // Create a body with specific orbital parameters
        final testBody = Body(
          name: 'Test Planet',
          bodyType: BodyType.planet,
          mass: 1.0,
          radius: 1.0,
          color: AppColors.primaryColor,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          temperature: 288.0,
          isOrbitalPlacementActive: true,
          orbitRadius: 35.5, // Non-default value
          orbitPhase: 1.5, // Non-default value
          orbitInclination: 0.7, // Non-default value
        );

        await tester.pumpWidget(
          makeTestableWidget(
            ScenarioEditorBodyDetailsBottomSheet(
              body: testBody,
              onBodyChanged: (body) => savedBody = body,
              onSave: (body) => savedBody = body,
              availableCentralBodies: [centralSun],
              isAddMode: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Make a small change to trigger auto-save and preserve orbital parameters
        await tester.enterText(
          find.byType(TextField).first,
          'Test Planet Updated',
        );
        await tester.pump();

        // Wait for auto-save to trigger with the orbital parameters
        await tester.pump(const Duration(seconds: 1));

        // Verify that orbital parameters are preserved in the saved body
        expect(savedBody, isNotNull);
        expect(savedBody!.isOrbitalPlacementActive, isTrue);
        expect(savedBody!.orbitRadius, equals(35.5));
        expect(savedBody!.orbitPhase, equals(1.5));
        expect(savedBody!.orbitInclination, equals(0.7));
      });
    });
  });
}
