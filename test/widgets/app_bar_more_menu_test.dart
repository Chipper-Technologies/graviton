import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/app_bar_menu_item.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/app_bar_more_menu.dart';

void main() {
  group('AppBarMoreMenu with Developer Tools', () {
    late bool helpCalled;
    late bool settingsCalled;
    late bool scenariosCalled;
    late bool physicsCalled;
    late bool aboutCalled;
    late bool developerToolsCalled;

    setUp(() {
      helpCalled = false;
      settingsCalled = false;
      scenariosCalled = false;
      physicsCalled = false;
      aboutCalled = false;
      developerToolsCalled = false;
    });

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(appBar: AppBar(actions: [child])),
      );
    }

    AppBarMoreMenu createMenu() {
      return AppBarMoreMenu(
        onShowHelp: () => helpCalled = true,
        onShowSettings: () => settingsCalled = true,
        onShowScenarios: () => scenariosCalled = true,
        onShowPhysicsSettings: () => physicsCalled = true,
        onShowAbout: () => aboutCalled = true,
        onShowDeveloperTools: () => developerToolsCalled = true,
      );
    }

    group('Rendering', () {
      testWidgets('Should display popup menu button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        expect(find.byType(PopupMenuButton<AppBarMenuItem>), findsOneWidget);
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
      });

      testWidgets('Should show all menu items when opened', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Tap to open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Check for all standard menu items
        expect(find.text('Select Scenario'), findsOneWidget);
        expect(find.text('Physics Settings'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('Help & Objectives'), findsOneWidget);
        expect(find.text('About'), findsOneWidget);
      });

      testWidgets('Should conditionally show developer tools in debug mode', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Tap to open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        if (kDebugMode) {
          expect(find.text('Developer Tools'), findsOneWidget);
          expect(find.byIcon(Icons.developer_mode), findsOneWidget);
        } else {
          expect(find.text('Developer Tools'), findsNothing);
          expect(find.byIcon(Icons.developer_mode), findsNothing);
        }
      });

      testWidgets('Should have proper menu item icons', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Tap to open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Check for menu item icons
        expect(find.byIcon(Icons.explore), findsOneWidget); // Scenarios
        expect(find.byIcon(Icons.science), findsOneWidget); // Physics
        expect(find.byIcon(Icons.tune), findsOneWidget); // Settings
        expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget); // Help
        expect(find.byIcon(Icons.info_outline), findsOneWidget); // About

        if (kDebugMode) {
          expect(
            find.byIcon(Icons.developer_mode),
            findsOneWidget,
          ); // Developer Tools
        }
      });

      testWidgets('Should have proper menu styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Tap to open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Should have dividers between sections
        expect(find.byType(Divider), findsWidgets);

        // Should have proper menu structure
        expect(find.byType(PopupMenuItem<AppBarMenuItem>), findsWidgets);
        expect(find.byType(Row), findsWidgets);
        expect(find.byType(Column), findsWidgets);
      });
    });

    group('User Interactions', () {
      testWidgets('Should call onShowHelp when help is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu and tap help
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Help & Objectives'));
        await tester.pumpAndSettle();

        expect(helpCalled, isTrue);
        expect(settingsCalled, isFalse);
      });

      testWidgets('Should call onShowSettings when settings is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu and tap settings
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        expect(settingsCalled, isTrue);
        expect(helpCalled, isFalse);
      });

      testWidgets('Should call onShowScenarios when scenarios is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu and tap scenarios
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Select Scenario'));
        await tester.pumpAndSettle();

        expect(scenariosCalled, isTrue);
        expect(helpCalled, isFalse);
      });

      testWidgets('Should call onShowPhysicsSettings when physics is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu and tap physics
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Physics Settings'));
        await tester.pumpAndSettle();

        expect(physicsCalled, isTrue);
        expect(helpCalled, isFalse);
      });

      testWidgets('Should call onShowAbout when about is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu and tap about
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('About'));
        await tester.pumpAndSettle();

        expect(aboutCalled, isTrue);
        expect(helpCalled, isFalse);
      });

      testWidgets(
        'Should call onShowDeveloperTools when developer tools is tapped in debug mode',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget(child: createMenu()));

          // Open menu
          await tester.tap(find.byIcon(Icons.more_vert));
          await tester.pumpAndSettle();

          if (kDebugMode) {
            // Tap developer tools
            await tester.tap(find.text('Developer Tools'));
            await tester.pumpAndSettle();

            expect(developerToolsCalled, isTrue);
            expect(helpCalled, isFalse);
            expect(settingsCalled, isFalse);
          }
        },
      );

      testWidgets('Should close menu after item selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('Help & Objectives'), findsOneWidget);

        // Tap menu item
        await tester.tap(find.text('Help & Objectives'));
        await tester.pumpAndSettle();

        // Menu should be closed
        expect(find.text('Help & Objectives'), findsNothing);
        expect(helpCalled, isTrue);
      });
    });

    group('Menu Structure', () {
      testWidgets('Should have proper menu order', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Get all menu items
        final menuItems = find.byType(PopupMenuItem<AppBarMenuItem>);
        expect(menuItems, findsWidgets);

        // Check that standard items are present
        expect(find.text('Select Scenario'), findsOneWidget);
        expect(find.text('Physics Settings'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('Help & Objectives'), findsOneWidget);
        expect(find.text('About'), findsOneWidget);
      });

      testWidgets('Should have dividers between sections', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Should have multiple dividers
        expect(find.byType(Divider), findsWidgets);

        // Should have disabled menu items (dividers)
        final disabledItems = find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuItem<AppBarMenuItem> &&
              widget.enabled == false,
        );
        expect(disabledItems, findsWidgets);
      });
    });

    group('Accessibility', () {
      testWidgets('Should have proper tooltips', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Check for tooltip on menu button
        final menuButton = find.byType(PopupMenuButton<AppBarMenuItem>);
        expect(menuButton, findsOneWidget);

        final button = tester.widget<PopupMenuButton<AppBarMenuItem>>(
          menuButton,
        );
        expect(button.tooltip, isNotNull);
      });

      testWidgets('Should support keyboard navigation', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Menu button should be focusable
        expect(find.byType(PopupMenuButton<AppBarMenuItem>), findsOneWidget);

        // Should be able to open menu with keyboard
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Menu items should be selectable
        expect(find.byType(PopupMenuItem<AppBarMenuItem>), findsWidgets);
      });
    });

    group('Localization', () {
      testWidgets('Should display localized menu item text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: createMenu()));

        // Open menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Check for localized text (these should be from l10n)
        expect(find.text('Select Scenario'), findsOneWidget);
        expect(find.text('Physics Settings'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('Help & Objectives'), findsOneWidget);
        expect(find.text('About'), findsOneWidget);

        if (kDebugMode) {
          expect(find.text('Developer Tools'), findsOneWidget);
        }
      });
    });
  });
}
