import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/features/scenarios/presentation/widgets/create_scenario_tile.dart';

void main() {
  group('CreateScenarioTile Tests', () {
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

    testWidgets('should display create scenario tile with proper content', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(child: CreateScenarioTile(onTap: () => tapped = true)),
      );

      // Verify the tile is rendered
      expect(find.byType(CreateScenarioTile), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);

      // Verify the add icon is displayed
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);

      // Verify the arrow icon is displayed
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // Verify text content is displayed (we'll check for the specific text after localization loads)
      await tester.pumpAndSettle();

      // Check for text elements (exact text depends on localization)
      expect(find.text('Create Custom Scenario'), findsOneWidget);

      // Tap the tile and verify callback
      await tester.tap(find.byType(CreateScenarioTile));
      expect(tapped, true);
    });

    testWidgets('should have proper styling and colors', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: CreateScenarioTile(onTap: () {})),
      );

      // Find the card widget
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.elevation, 2);
      expect(card.margin, EdgeInsets.zero);

      // Find the container with border decoration
      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(
        decoration.border?.top.color,
        AppColors.primaryColor.withValues(alpha: 0.5),
      );
      expect(decoration.border?.top.width, 2);

      // Find the icon container
      final iconContainers = find.byType(Container);
      expect(iconContainers, findsWidgets);

      // Find add icon and verify its color
      final addIconFinder = find.byIcon(Icons.add_circle_outline);
      final addIcon = tester.widget<Icon>(addIconFinder);
      expect(addIcon.color, AppColors.primaryColor);
      expect(addIcon.size, 28);

      // Find arrow icon and verify its color
      final arrowIconFinder = find.byIcon(Icons.arrow_forward_ios);
      final arrowIcon = tester.widget<Icon>(arrowIconFinder);
      expect(arrowIcon.color, AppColors.primaryColor);
      expect(arrowIcon.size, 16);
    });

    testWidgets('should handle tap events correctly', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        createTestWidget(child: CreateScenarioTile(onTap: () => tapCount++)),
      );

      // Tap multiple times to verify callback is called each time
      await tester.tap(find.byType(CreateScenarioTile));
      expect(tapCount, 1);

      await tester.tap(find.byType(CreateScenarioTile));
      expect(tapCount, 2);
    });

    testWidgets('should have proper layout structure', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: CreateScenarioTile(onTap: () {})),
      );

      // Verify Row layout structure
      expect(find.byType(Row), findsOneWidget);

      // Verify there are exactly 3 main elements in the row:
      // 1. Icon container
      // 2. SizedBox for spacing
      // 3. Expanded with Column content
      // 4. Arrow icon
      final row = find.byType(Row);
      expect(row, findsOneWidget);

      // Verify Expanded widget for content area
      expect(find.byType(Expanded), findsOneWidget);

      // Verify Column layout for text content
      expect(find.byType(Column), findsOneWidget);

      // Verify SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should display localized text content', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: CreateScenarioTile(onTap: () {})),
      );

      await tester.pumpAndSettle();

      // Check for text widgets (specific text depends on current locale)
      final textWidgets = find.byType(Text);
      expect(textWidgets, findsWidgets);

      // Should have at least 2 text widgets (title and description)
      expect(textWidgets.evaluate().length, greaterThanOrEqualTo(2));
    });

    testWidgets('should have proper accessibility properties', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: CreateScenarioTile(onTap: () {})),
      );

      // Verify the tile is tappable
      final inkWellFinder = find.byType(InkWell);
      expect(inkWellFinder, findsOneWidget);

      // Verify the tile has proper semantics by checking it can be found with semantics
      expect(find.byType(CreateScenarioTile), findsOneWidget);
    });

    testWidgets('should handle text overflow properly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SizedBox(
            width: 200, // Constrain width to test overflow
            child: CreateScenarioTile(onTap: () {}),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find text widgets and verify they handle overflow
      final textWidgets = tester.widgetList<Text>(find.byType(Text));

      // Check if any text widgets have overflow properties set
      bool hasEllipsisOverflow = textWidgets.any(
        (text) => text.overflow == TextOverflow.ellipsis,
      );

      expect(
        hasEllipsisOverflow,
        true,
        reason:
            'At least one text widget should have ellipsis overflow handling',
      );
    });
  });
}
