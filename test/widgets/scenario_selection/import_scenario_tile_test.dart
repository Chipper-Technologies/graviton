import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/scenario_selection/import_scenario_tile.dart';

void main() {
  group('ImportScenarioTile Tests', () {
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

    testWidgets('should display import scenario tile with proper content', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () => tapped = true)),
      );

      // Verify the tile is rendered
      expect(find.byType(ImportScenarioTile), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);

      // Verify the file upload icon is displayed
      expect(find.byIcon(Icons.file_upload_outlined), findsOneWidget);

      // Verify the arrow icon is displayed
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // Verify text content is displayed (we'll check for the specific text after localization loads)
      await tester.pumpAndSettle();

      // Check for text elements (exact text depends on localization)
      expect(find.text('Import Scenario'), findsOneWidget);

      // Tap the tile and verify callback
      await tester.tap(find.byType(ImportScenarioTile));
      expect(tapped, true);
    });

    testWidgets('should have proper styling and colors', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () {})),
      );

      // Find the card widget
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.elevation, 2);
      expect(card.margin, EdgeInsets.zero);

      // Find the container with border decoration
      final containerFinder = find
          .descendant(of: find.byType(Card), matching: find.byType(Container))
          .first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(
        decoration.border?.top.color,
        AppColors.uiCyanAccent.withValues(alpha: AppTypography.opacityMedium),
      );
      expect(decoration.border?.top.width, AppTypography.borderThick);

      // Find file upload icon and verify its color
      final uploadIconFinder = find.byIcon(Icons.file_upload_outlined);
      final uploadIcon = tester.widget<Icon>(uploadIconFinder);
      expect(uploadIcon.color, AppColors.uiCyanAccent);
      expect(uploadIcon.size, AppTypography.iconSizeXXXLarge);

      // Find arrow icon and verify its color
      final arrowIconFinder = find.byIcon(Icons.arrow_forward_ios);
      final arrowIcon = tester.widget<Icon>(arrowIconFinder);
      expect(arrowIcon.color, AppColors.uiCyanAccent);
      expect(arrowIcon.size, AppTypography.iconSizeMedium);
    });

    testWidgets('should handle tap events correctly', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () => tapCount++)),
      );

      // Initial state
      expect(tapCount, 0);

      // Tap the tile
      await tester.tap(find.byType(ImportScenarioTile));
      await tester.pumpAndSettle();
      expect(tapCount, 1);

      // Tap again
      await tester.tap(find.byType(ImportScenarioTile));
      await tester.pumpAndSettle();
      expect(tapCount, 2);
    });

    testWidgets('should display localized text', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () {})),
      );
      await tester.pumpAndSettle();

      // Verify English localized strings are displayed
      expect(find.text('Import Scenario'), findsOneWidget);
      expect(find.text('Load a scenario from a JSON file'), findsOneWidget);
    });

    testWidgets('should use AppTypography constants for spacing', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () {})),
      );

      // Find the main container
      final containerFinder = find
          .descendant(of: find.byType(Card), matching: find.byType(Container))
          .first;
      final container = tester.widget<Container>(containerFinder);

      // Verify padding uses AppTypography constant
      expect(container.padding, EdgeInsets.all(AppTypography.spacingLarge));
    });

    testWidgets('should have proper border radius', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () {})),
      );

      // Find the container with decoration
      final containerFinder = find
          .descendant(of: find.byType(Card), matching: find.byType(Container))
          .first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Verify border radius uses AppTypography constant
      expect(
        decoration.borderRadius,
        BorderRadius.circular(AppTypography.radiusMedium),
      );
    });

    testWidgets('should render text with proper overflow handling', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () {})),
      );
      await tester.pumpAndSettle();

      // Find the description text widget
      final descriptionTextFinder = find.text(
        'Load a scenario from a JSON file',
      );
      expect(descriptionTextFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(descriptionTextFinder);
      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should have consistent cyan theme throughout', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: ImportScenarioTile(onTap: () {})),
      );

      // Find all icons
      final uploadIcon = tester.widget<Icon>(
        find.byIcon(Icons.file_upload_outlined),
      );
      final arrowIcon = tester.widget<Icon>(
        find.byIcon(Icons.arrow_forward_ios),
      );

      // Both icons should use cyan accent color
      expect(uploadIcon.color, AppColors.uiCyanAccent);
      expect(arrowIcon.color, AppColors.uiCyanAccent);

      // Find the title text
      final titleTextFinder = find.text('Import Scenario');
      final titleText = tester.widget<Text>(titleTextFinder);

      // Title should use cyan accent color
      expect(titleText.style?.color, AppColors.uiCyanAccent);
    });
  });
}
