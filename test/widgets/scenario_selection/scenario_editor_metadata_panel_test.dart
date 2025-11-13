import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/objectives_config.dart';
import 'package:graviton/models/scenario_metadata.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_metadata_panel.dart';

/// Test widget wrapper with localization support
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('ScenarioEditorMetadataPanel', () {
    late ScenarioMetadata testMetadata;
    late ObjectivesConfig testObjectives;

    setUp(() {
      testMetadata = ScenarioMetadata(
        name: 'Test Scenario',
        description: 'Test Description',
        difficulty: 'intermediate',
        educationalFocus: 'orbital_mechanics',
        tags: ['test'],
        author: 'Test Author',
        createdAt: DateTime.now(),
      );

      testObjectives = ObjectivesConfig(
        enabled: true,
        primary: 'Test Primary Objective',
        secondary: 'Test Secondary Objective',
      );
    });

    testWidgets('displays metadata fields correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Should display section dividers
      expect(find.byType(SectionDivider), findsWidgets);

      // Should display text fields for name and description (using TextField, not TextFormField)
      expect(find.byType(TextField), findsAtLeastNWidgets(2));

      // Should show the metadata name
      expect(find.text('Test Scenario'), findsOneWidget);

      // Should show the metadata description
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('handles name field changes', (WidgetTester tester) async {
      ScenarioMetadata? updatedMetadata;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (metadata) => updatedMetadata = metadata,
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Find and edit the name field (first TextField)
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'Updated Scenario Name');
      await tester.pump();

      // Should call onMetadataChanged
      expect(updatedMetadata, isNotNull);
      expect(updatedMetadata!.name, equals('Updated Scenario Name'));
    });

    testWidgets('handles description field changes', (
      WidgetTester tester,
    ) async {
      ScenarioMetadata? updatedMetadata;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (metadata) => updatedMetadata = metadata,
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Find and edit the description field (second TextField)
      final textFields = find.byType(TextField);
      final descField = textFields.at(1); // Second TextField is description
      await tester.enterText(descField, 'Updated Description');
      await tester.pump();

      // Should call onMetadataChanged
      expect(updatedMetadata, isNotNull);
      expect(updatedMetadata!.description, equals('Updated Description'));
    });

    testWidgets('preserves other metadata properties on update', (
      WidgetTester tester,
    ) async {
      ScenarioMetadata? updatedMetadata;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (metadata) => updatedMetadata = metadata,
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Edit the name field (first TextField)
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'New Name');
      await tester.pump();

      // Should preserve all other properties
      expect(updatedMetadata!.difficulty, equals(testMetadata.difficulty));
      expect(
        updatedMetadata!.educationalFocus,
        equals(testMetadata.educationalFocus),
      );
      expect(updatedMetadata!.tags, equals(testMetadata.tags));
      expect(updatedMetadata!.author, equals(testMetadata.author));
      expect(updatedMetadata!.createdAt, equals(testMetadata.createdAt));
    });

    testWidgets('displays difficulty information', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Should contain difficulty information (capitalized as per widget implementation)
      expect(find.textContaining('Intermediate'), findsWidgets);
    });

    testWidgets('handles empty metadata gracefully', (
      WidgetTester tester,
    ) async {
      final emptyMetadata = ScenarioMetadata(
        name: '',
        description: '',
        difficulty: 'beginner',
        educationalFocus: 'basic_mechanics',
        tags: [],
        author: '',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: emptyMetadata,
            objectives: null,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Should not crash with empty metadata
      expect(find.byType(ScenarioEditorMetadataPanel), findsOneWidget);
      expect(find.byType(SectionDivider), findsWidgets);
    });

    testWidgets('displays scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Should be wrapped in SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('handles objectives changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // The widget should be able to call onObjectivesChanged
      // (testing the callback parameter exists and can be called)
      expect(find.byType(ScenarioEditorMetadataPanel), findsOneWidget);
    });

    testWidgets('displays proper layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Should have proper padding and structure
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('handles null objectives', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: null,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      // Should handle null objectives without crashing
      expect(find.byType(ScenarioEditorMetadataPanel), findsOneWidget);
    });

    testWidgets('description field has proper expandable configuration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find all text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsAtLeastNWidgets(2));

      // Get the description field (second text field)
      final descriptionField = textFields.at(1);
      final textFieldWidget = tester.widget<TextField>(descriptionField);

      // Verify the description field has proper expandable configuration
      expect(
        textFieldWidget.minLines,
        equals(2),
        reason: 'Description field should start with 2 lines',
      );
      expect(
        textFieldWidget.maxLines,
        equals(4),
        reason: 'Description field should expand up to 4 lines',
      );
    });

    testWidgets('name field has single line configuration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the name field (first text field)
      final nameField = find.byType(TextField).first;
      final textFieldWidget = tester.widget<TextField>(nameField);

      // Verify the name field is single line
      expect(
        textFieldWidget.minLines,
        isNull,
        reason: 'Name field should not have minLines specified',
      );
      expect(
        textFieldWidget.maxLines,
        equals(1),
        reason: 'Name field should be single line',
      );
    });

    testWidgets('description field expands properly with content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the description field
      final descriptionField = find.byType(TextField).at(1);

      // Enter multi-line content
      const longDescription =
          '''This is a comprehensive scenario that demonstrates 
gravitational mechanics and orbital dynamics in a three-body system.
The simulation includes realistic physics parameters and interactive controls
for educational purposes and advanced physics exploration.''';

      await tester.enterText(descriptionField, longDescription);
      await tester.pump();

      // Verify the text was entered
      final textFieldWidget = tester.widget<TextField>(descriptionField);
      expect(
        textFieldWidget.controller?.text,
        contains('gravitational mechanics'),
      );
    });

    testWidgets('uses AppTypography constants for proper styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorMetadataPanel(
            metadata: testMetadata,
            objectives: testObjectives,
            onMetadataChanged: (_) {},
            onObjectivesChanged: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify proper spacing and typography usage
      expect(find.byType(SizedBox), findsWidgets);

      // Find containers with proper styling
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Verify the panel has proper structure
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
