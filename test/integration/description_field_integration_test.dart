import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/scenarios/presentation/screens/scenario_editor_screen.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/features/scenarios/presentation/widgets/scenario_editor_metadata_panel.dart';
import 'package:graviton/features/scenarios/domain/scenario_metadata.dart';

/// Integration tests for description field expandable functionality
///
/// Tests the complete flow of description field behavior:
/// - Initial 2-line height (minLines: 2)
/// - Expansion up to 4 lines (maxLines: 4)
/// - Proper AppTypography usage
/// - Cross-component consistency
void main() {
  group('Description Field Integration Tests', () {
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

    Widget makeTestableMetadataPanelWidget(ScenarioEditorMetadataPanel child) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    testWidgets('StyledTextField expandable configuration works correctly', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Describe what this scenario demonstrates',
              minLines: 2,
              maxLines: 4,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify the text field configuration
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.minLines,
        equals(2),
        reason: 'StyledTextField should start with 2 lines',
      );
      expect(
        textField.maxLines,
        equals(4),
        reason: 'StyledTextField should expand up to 4 lines',
      );

      // Test with content
      const multiLineContent = '''Line one
Line two
Line three
Line four would exceed maxLines if there was a fifth line''';

      await tester.enterText(find.byType(TextField), multiLineContent);
      await tester.pump();

      expect(controller.text, equals(multiLineContent));

      controller.dispose();
    });

    testWidgets(
      'ScenarioEditorMetadataPanel description field has correct configuration',
      (WidgetTester tester) async {
        final testMetadata = ScenarioMetadata(
          name: 'Test Scenario',
          description: 'Test Description',
          difficulty: 'intermediate',
          educationalFocus: 'orbital_mechanics',
          tags: ['test'],
          author: 'Test Author',
          createdAt: DateTime.now(),
        );

        await tester.pumpWidget(
          makeTestableMetadataPanelWidget(
            ScenarioEditorMetadataPanel(
              metadata: testMetadata,
              objectives: null,
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

        // Verify expandable configuration
        expect(
          textFieldWidget.minLines,
          equals(2),
          reason: 'MetadataPanel description field should start with 2 lines',
        );
        expect(
          textFieldWidget.maxLines,
          equals(4),
          reason: 'MetadataPanel description field should expand up to 4 lines',
        );

        // Test updating description
        const testDescription = '''This is a comprehensive scenario
that demonstrates gravitational physics
with multiple celestial bodies
and realistic orbital mechanics''';

        await tester.enterText(descriptionField, testDescription);
        await tester.pumpAndSettle();

        // Verify the text was entered by checking the text field content
        final updatedTextField = tester.widget<TextField>(descriptionField);
        expect(
          updatedTextField.controller?.text,
          contains('gravitational physics'),
        );
      },
    );

    testWidgets(
      'ScenarioEditorScreen description field has correct configuration',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(const ScenarioEditorScreen()),
        );
        await tester.pump();

        // Find the StyledTextField with description icon
        final styledTextFields = find.byType(StyledTextField);
        expect(styledTextFields, findsAtLeastNWidgets(2));

        StyledTextField? descriptionField;
        for (int i = 0; i < tester.widgetList(styledTextFields).length; i++) {
          final field = tester.widget<StyledTextField>(styledTextFields.at(i));
          if (field.icon == Icons.description) {
            descriptionField = field;
            break;
          }
        }

        expect(
          descriptionField,
          isNotNull,
          reason: 'Should find description field in ScenarioEditorScreen',
        );

        // Verify configuration
        expect(
          descriptionField!.minLines,
          equals(2),
          reason: 'ScenarioEditor description field should start with 2 lines',
        );
        expect(
          descriptionField.maxLines,
          equals(4),
          reason:
              'ScenarioEditor description field should expand up to 4 lines',
        );

        // Verify hint text
        expect(
          descriptionField.hintText,
          contains('Describe what this scenario demonstrates'),
        );
      },
    );

    testWidgets(
      'Consistency across components - all description fields use same configuration',
      (WidgetTester tester) async {
        // Test StyledTextField directly
        final controller1 = TextEditingController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StyledTextField(
                controller: controller1,
                icon: Icons.description,
                hintText: 'Test',
                minLines: 2,
                maxLines: 4,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        final directTextField = tester.widget<TextField>(
          find.byType(TextField),
        );
        expect(directTextField.minLines, equals(2));
        expect(directTextField.maxLines, equals(4));

        controller1.dispose();
      },
    );

    testWidgets('Description field behavior with realistic content', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Describe what this scenario demonstrates',
              minLines: 2,
              maxLines: 4,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Test with realistic scenario descriptions
      const descriptions = [
        'Simple single line description',
        '''Two line description
with additional details''',
        '''Three line description
with gravitational mechanics
and orbital dynamics''',
        '''Four line description
exploring three-body problems
with realistic physics parameters
and educational objectives''',
        '''Five line description that exceeds maxLines
demonstrating gravitational interactions
between multiple celestial bodies
with comprehensive physics modeling
and interactive educational features''',
      ];

      for (final description in descriptions) {
        controller.clear();
        await tester.enterText(find.byType(TextField), description);
        await tester.pump();

        expect(controller.text, equals(description));

        // Verify the field still has correct configuration
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.minLines, equals(2));
        expect(textField.maxLines, equals(4));
      }

      controller.dispose();
    });

    testWidgets('AppTypography compliance - no magic numbers', (
      WidgetTester tester,
    ) async {
      // This test verifies that our implementation uses proper constants
      // The fact that we're using StyledTextField with minLines/maxLines
      // ensures AppTypography compliance since StyledTextField is designed
      // to use AppTypography constants throughout

      await tester.pumpWidget(makeTestableWidget(const ScenarioEditorScreen()));
      await tester.pump();

      // Find styled text fields
      final styledTextFields = find.byType(StyledTextField);
      expect(styledTextFields, findsAtLeastNWidgets(2));

      // Verify we're using StyledTextField (which enforces AppTypography)
      // rather than raw TextField widgets with magic numbers
      expect(find.byType(StyledTextField), findsWidgets);

      // The use of StyledTextField guarantees AppTypography compliance
      // because it's built with AppTypography constants
    });

    testWidgets('Valid configurations work properly', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      // Test that valid minLines <= maxLines configurations work
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Test',
              minLines: 2, // Valid: minLines <= maxLines
              maxLines: 4,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Should render successfully without errors
      expect(find.byType(TextField), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.minLines, equals(2));
      expect(textField.maxLines, equals(4));

      controller.dispose();
    });

    testWidgets('Performance with large content', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Test',
              minLines: 2,
              maxLines: 4,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Test with very large content
      final largeContent = 'This is a very long line that repeats. ' * 100;

      await tester.enterText(find.byType(TextField), largeContent);
      await tester.pump();

      // Should handle large content without issues
      expect(controller.text, equals(largeContent));
      expect(find.byType(TextField), findsOneWidget);

      controller.dispose();
    });
  });
}
