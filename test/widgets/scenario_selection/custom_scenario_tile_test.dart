import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/features/scenarios/presentation/widgets/custom_scenario_tile.dart';

void main() {
  group('CustomScenarioTile Tests', () {
    const String testScenarioName = 'Test Scenario';

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    testWidgets(
      'should display scenario tile with proper content when not selected',
      (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CustomScenarioTile(
              scenarioName: testScenarioName,
              isSelected: false,
              onTap: () {},
              onView: () {},
              onExport: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        );

        // Verify the tile is rendered
        expect(find.byType(CustomScenarioTile), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);

        // Verify the scenario name is displayed
        expect(find.text(testScenarioName), findsOneWidget);

        // Verify the palette icon is displayed
        expect(find.byIcon(Icons.palette), findsOneWidget);

        // Verify 3-dot menu button is displayed
        expect(find.byIcon(Icons.more_vert), findsOneWidget);

        // Verify palette icon is displayed
        expect(find.byIcon(Icons.palette), findsOneWidget);

        // Verify check circle is NOT displayed when not selected
        expect(find.byIcon(Icons.check_circle), findsNothing);
      },
    );

    testWidgets('should display check circle icon when selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: true,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      // Verify the check circle is displayed when selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Verify the selected styling
      final checkIcon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
      expect(checkIcon.color, AppColors.celestialPlumPlanet);
      expect(checkIcon.size, 24);
    });

    testWidgets('should handle tap events correctly', (tester) async {
      bool tapped = false;
      bool edited = false;
      bool deleted = false;

      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: false,
            onTap: () => tapped = true,
            onView: () {},
            onExport: () {},
            onEdit: () => edited = true,
            onDelete: () => deleted = true,
          ),
        ),
      );

      // Test main tile tap
      await tester.tap(find.byType(CustomScenarioTile), warnIfMissed: false);
      expect(tapped, true);

      // Test edit button tap through 3-dot menu
      await tester.tap(find.byIcon(Icons.more_vert), warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(edited, true);

      // Open menu again for delete test
      await tester.tap(find.byIcon(Icons.more_vert), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Test delete button tap
      await tester.tap(find.byIcon(Icons.delete_outline), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(deleted, true);
    });

    testWidgets('should have proper styling when not selected', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      // Find the card widget
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.elevation, 2);
      expect(card.margin, EdgeInsets.zero);
      expect(card.color, null); // Should be null when not selected

      // Verify palette icon color
      final paletteIcon = tester.widget<Icon>(find.byIcon(Icons.palette));
      expect(paletteIcon.color, AppColors.celestialPlumPlanet);
      expect(paletteIcon.size, 28);
    });

    testWidgets('should have proper styling when selected', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: true,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      // Find the card widget
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.elevation, 8); // Higher elevation when selected
      expect(card.margin, EdgeInsets.zero);

      // Card should have custom color when selected
      final expectedColor = AppColors.celestialPlumPlanet.withValues(
        alpha: 0.1,
      );
      expect(card.color, expectedColor);
    });

    testWidgets('should display proper text styling based on selection state', (
      tester,
    ) async {
      // Test not selected state
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      final textWidgets = tester.widgetList<Text>(find.text(testScenarioName));
      expect(textWidgets.length, 1);

      final titleText = textWidgets.first;
      expect(titleText.style?.fontWeight, FontWeight.w500);

      // Test selected state
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: true,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      final selectedTextWidgets = tester.widgetList<Text>(
        find.text(testScenarioName),
      );
      expect(selectedTextWidgets.length, 1);

      final selectedTitleText = selectedTextWidgets.first;
      expect(selectedTitleText.style?.fontWeight, FontWeight.bold);
      expect(selectedTitleText.style?.color, AppColors.celestialPlumPlanet);
    });

    testWidgets('should have proper layout structure', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      // Verify main Row layout structure
      expect(find.byType(Row), findsWidgets); // Multiple rows in the layout

      // Verify Expanded widget for content area
      expect(find.byType(Expanded), findsWidgets);

      // Verify Column layout for text content
      expect(find.byType(Column), findsOneWidget);

      // Verify SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsWidgets);

      // Verify GestureDetector for action buttons
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should handle action button interactions independently', (
      tester,
    ) async {
      int editCount = 0;
      int deleteCount = 0;
      int tapCount = 0;

      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: false,
            onTap: () => tapCount++,
            onView: () {},
            onExport: () {},
            onEdit: () => editCount++,
            onDelete: () => deleteCount++,
          ),
        ),
      );

      // Test edit button multiple times through 3-dot menu
      await tester.tap(find.byIcon(Icons.more_vert), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined), warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(editCount, 2);
      expect(deleteCount, 0);
      expect(tapCount, 0);

      // Test delete button through menu
      await tester.tap(find.byIcon(Icons.more_vert), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete_outline), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(deleteCount, 1);
      expect(editCount, 2);
      expect(tapCount, 0);

      // Test main tile tap (avoiding action buttons)
      await tester.tap(find.text(testScenarioName), warnIfMissed: false);
      expect(tapCount, 1);
      expect(editCount, 2);
      expect(deleteCount, 1);
    });

    testWidgets('should display menu items with proper styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      // Open the 3-dot menu
      await tester.tap(find.byIcon(Icons.more_vert), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify menu items are present
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('should have proper accessibility properties', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      // Verify the tile is tappable
      final inkWellFinder = find.byType(InkWell);
      expect(inkWellFinder, findsWidgets);

      // Verify the tile has proper semantics
      expect(find.byType(CustomScenarioTile), findsOneWidget);
    });

    testWidgets('should handle empty scenario name gracefully', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: '',
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      // Verify the tile still renders
      expect(find.byType(CustomScenarioTile), findsOneWidget);

      // Empty string should still create a text widget
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should handle long scenario names with proper overflow', (
      tester,
    ) async {
      const longName =
          'This is a very long scenario name that should be handled properly with overflow';

      await tester.pumpWidget(
        createTestWidget(
          child: SizedBox(
            width: 300, // Constrain width to test overflow
            child: CustomScenarioTile(
              scenarioName: longName,
              isSelected: false,
              onTap: () {},
              onView: () {},
              onExport: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the tile renders without overflow errors
      expect(find.byType(CustomScenarioTile), findsOneWidget);
      expect(find.textContaining('This is a very long'), findsOneWidget);
    });

    testWidgets('should display custom description when provided', (
      tester,
    ) async {
      const customDescription =
          'This is a custom scenario description that should be displayed instead of the generic text';

      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            scenarioDescription: customDescription,
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify custom description is displayed
      expect(find.text(customDescription), findsOneWidget);

      // Verify generic text is not displayed
      expect(find.text('Custom gravitational scenario'), findsNothing);
    });

    testWidgets('should truncate long descriptions with ellipsis', (
      tester,
    ) async {
      const longDescription =
          'This is an extremely long description that should be truncated with ellipsis when it exceeds the maximum number of lines allowed for the description text in the custom scenario tile widget which is limited to two lines maximum to maintain proper layout and readability';

      await tester.pumpWidget(
        createTestWidget(
          child: SizedBox(
            width: 300, // Constrain width to force truncation
            child: CustomScenarioTile(
              scenarioName: testScenarioName,
              scenarioDescription: longDescription,
              isSelected: false,
              onTap: () {},
              onView: () {},
              onExport: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the description text widget
      final descriptionTextFinder = find.textContaining(
        'This is an extremely long description',
      );
      expect(descriptionTextFinder, findsOneWidget);

      // Verify it has overflow set to ellipsis
      final textWidget = tester.widget<Text>(descriptionTextFinder);
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
      expect(textWidget.maxLines, equals(2));
    });

    testWidgets('should fallback to generic text when description is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            scenarioDescription: '', // Empty description
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should fallback to generic description
      expect(find.text('Custom gravitational scenario'), findsOneWidget);
    });

    testWidgets('should fallback to generic text when description is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CustomScenarioTile(
            scenarioName: testScenarioName,
            scenarioDescription: null, // Null description
            isSelected: false,
            onTap: () {},
            onView: () {},
            onExport: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should fallback to generic description
      expect(find.text('Custom gravitational scenario'), findsOneWidget);
    });
  });
}
