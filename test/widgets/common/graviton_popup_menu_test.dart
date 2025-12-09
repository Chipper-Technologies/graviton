import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/ui/graviton_menu_item_config.dart';
import 'package:graviton/widgets/common/graviton_popup_menu.dart';

void main() {
  group('GravitonPopupMenu Widget Tests', () {
    Widget makeTestableWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
        home: Scaffold(appBar: AppBar(actions: [child])),
      );
    }

    testWidgets('GravitonPopupMenu renders correctly', (
      WidgetTester tester,
    ) async {
      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Test Menu',
        accessibilityHint: 'Open menu with test options',
        analyticsElement: UIElement.scenarioEditor,
        menuItems: [
          GravitonMenuItemConfig(
            value: 'test',
            labelKey: 'testScenarioButton',
            hintKey: 'testScenarioHint',
            icon: Icons.play_arrow,
          ),
          GravitonMenuItemConfig(
            value: 'export',
            labelKey: 'exportScenarioButton',
            hintKey: 'exportScenarioHint',
            icon: Icons.file_download,
          ),
        ],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Verify the popup menu button is rendered
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.byType(GravitonPopupMenu), findsOneWidget);
    });

    testWidgets('GravitonPopupMenu shows menu items when tapped', (
      WidgetTester tester,
    ) async {
      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Test Menu',
        accessibilityHint: 'Open menu with test options',
        analyticsElement: UIElement.scenarioEditor,
        menuItems: [
          GravitonMenuItemConfig(
            value: 'test',
            labelKey: 'testScenarioButton',
            hintKey: 'testScenarioHint',
            icon: Icons.play_arrow,
            onTap: () {},
          ),
          GravitonMenuItemConfig(
            value: 'export',
            labelKey: 'exportScenarioButton',
            hintKey: 'exportScenarioHint',
            icon: Icons.file_download,
            onTap: () {},
          ),
        ],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Tap to open menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify menu items are shown
      expect(find.text('Test Scenario'), findsOneWidget);
      expect(find.text('Export Scenario'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.file_download), findsOneWidget);
    });

    testWidgets('GravitonPopupMenu menu items have proper styling', (
      WidgetTester tester,
    ) async {
      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Test Menu',
        accessibilityHint: 'Open menu with test options',
        analyticsElement: UIElement.scenarioEditor,
        menuItems: [
          GravitonMenuItemConfig(
            value: 'test',
            labelKey: 'testScenarioButton',
            hintKey: 'testScenarioHint',
            icon: Icons.play_arrow,
            onTap: () {},
          ),
        ],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Open menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify popup menu items have expected height
      final menuItems = find.byType(PopupMenuItem<String>);
      expect(menuItems, findsOneWidget);

      // Check for circular icon container
      final iconContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(iconContainer, findsOneWidget);
    });

    testWidgets('GravitonPopupMenu handles onTap callbacks correctly', (
      WidgetTester tester,
    ) async {
      bool testTapped = false;
      bool exportTapped = false;

      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Test Menu',
        accessibilityHint: 'Open menu with test options',
        analyticsElement: UIElement.scenarioEditor,
        menuItems: [
          GravitonMenuItemConfig(
            value: 'test',
            labelKey: 'testScenarioButton',
            hintKey: 'testScenarioHint',
            icon: Icons.play_arrow,
            onTap: () => testTapped = true,
          ),
          GravitonMenuItemConfig(
            value: 'export',
            labelKey: 'exportScenarioButton',
            hintKey: 'exportScenarioHint',
            icon: Icons.file_download,
            onTap: () => exportTapped = true,
          ),
        ],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Open menu and tap test item
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Scenario'));
      await tester.pumpAndSettle();

      // Verify callback was called
      expect(testTapped, isTrue);
      expect(exportTapped, isFalse);

      // Test export item
      testTapped = false;
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Export Scenario'));
      await tester.pumpAndSettle();

      expect(testTapped, isFalse);
      expect(exportTapped, isTrue);
    });

    testWidgets('GravitonPopupMenu handles custom colors correctly', (
      WidgetTester tester,
    ) async {
      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Test Menu',
        accessibilityHint: 'Open menu with test options',
        analyticsElement: UIElement.scenarioEditor,
        menuItems: [
          GravitonMenuItemConfig(
            value: 'delete',
            labelKey: 'deleteBodyTooltip',
            hintKey: 'deleteBodyAccessibility',
            icon: Icons.delete_outline,
            iconColor: AppColors.uiRed,
            borderColor: AppColors.uiRed.withValues(
              alpha: AppTypography.opacityMedium,
            ),
            onTap: () {},
          ),
        ],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Open menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify custom styling is applied
      final deleteIcon = find.byIcon(Icons.delete_outline);
      expect(deleteIcon, findsOneWidget);

      // Verify the icon has red color by checking the widget tree
      final iconWidget = tester.widget<Icon>(deleteIcon);
      expect(iconWidget.color, equals(AppColors.uiRed));
    });

    testWidgets('GravitonPopupMenu handles onSelected callback', (
      WidgetTester tester,
    ) async {
      String? selectedValue;

      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Test Menu',
        accessibilityHint: 'Open menu with test options',
        analyticsElement: UIElement.scenarioEditor,
        onSelected: (value) => selectedValue = value,
        menuItems: [
          GravitonMenuItemConfig(
            value: 'test',
            labelKey: 'testScenarioButton',
            hintKey: 'testScenarioHint',
            icon: Icons.play_arrow,
            onTap: () {},
          ),
        ],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Open menu and select item
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Scenario'));
      await tester.pumpAndSettle();

      // Verify onSelected was called with correct value
      expect(selectedValue, equals('test'));
    });

    testWidgets('GravitonPopupMenu has proper accessibility semantics', (
      WidgetTester tester,
    ) async {
      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Test Actions',
        accessibilityHint: 'Open menu with test and export actions',
        analyticsElement: UIElement.scenarioEditor,
        menuItems: [
          GravitonMenuItemConfig(
            value: 'test',
            labelKey: 'testScenarioButton',
            hintKey: 'testScenarioHint',
            icon: Icons.play_arrow,
            onTap: () {},
          ),
        ],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Verify accessibility semantics on the main button
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.button == true,
        ),
        findsAtLeastNWidgets(1),
      );

      // Open menu and verify menu item semantics
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Menu items should also have proper semantics
      expect(
        find.byWidgetPredicate((widget) => widget is Semantics),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('GravitonPopupMenu handles empty menu items list', (
      WidgetTester tester,
    ) async {
      final menu = GravitonPopupMenu(
        accessibilityLabel: 'Empty Menu',
        accessibilityHint: 'Empty menu for testing',
        analyticsElement: UIElement.scenarioEditor,
        menuItems: const [],
      );

      await tester.pumpWidget(makeTestableWidget(menu));
      await tester.pump();

      // Menu button should still render
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      // Opening menu should show no items
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem<String>), findsNothing);
    });
  });

  group('GravitonMenuItemConfig Tests', () {
    testWidgets('GravitonMenuItemConfig holds correct values', (
      WidgetTester tester,
    ) async {
      const config = GravitonMenuItemConfig(
        value: 'test',
        labelKey: 'testKey',
        hintKey: 'hintKey',
        icon: Icons.star,
        iconColor: AppColors.primaryColor,
        borderColor: AppColors.uiGreen,
      );

      expect(config.value, equals('test'));
      expect(config.labelKey, equals('testKey'));
      expect(config.hintKey, equals('hintKey'));
      expect(config.icon, equals(Icons.star));
      expect(config.iconColor, equals(AppColors.primaryColor));
      expect(config.borderColor, equals(AppColors.uiGreen));
    });

    testWidgets('GravitonMenuItemConfig with minimal properties', (
      WidgetTester tester,
    ) async {
      const config = GravitonMenuItemConfig(
        value: 'minimal',
        labelKey: 'label',
        hintKey: 'hint',
        icon: Icons.star,
      );

      expect(config.value, equals('minimal'));
      expect(config.labelKey, equals('label'));
      expect(config.hintKey, equals('hint'));
      expect(config.icon, equals(Icons.star));
      expect(config.iconColor, isNull);
      expect(config.borderColor, isNull);
      expect(config.onTap, isNull);
    });
  });
}
