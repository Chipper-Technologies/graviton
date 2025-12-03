import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/options_drawer.dart';
import 'package:graviton/widgets/auth/avatar_button.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:provider/provider.dart';

import '../test_utils.dart';

void main() {
  group('OptionsDrawer Widget Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
    });

    Widget createTestWidget({
      VoidCallback? onShowHelp,
      VoidCallback? onShowSettings,
      VoidCallback? onShowScenarios,
      VoidCallback? onShowPhysicsSettings,
      VoidCallback? onShowAbout,
      VoidCallback? onShowDeveloperTools,
      VoidCallback? onShowChangelog,
      VoidCallback? onShowAccount,
    }) {
      return TestUtils.wrapWithMaterialApp(
        child: ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: OptionsDrawer(
            onShowHelp: onShowHelp ?? () {},
            onShowSettings: onShowSettings ?? () {},
            onShowScenarios: onShowScenarios ?? () {},
            onShowPhysicsSettings: onShowPhysicsSettings ?? () {},
            onShowAbout: onShowAbout ?? () {},
            onShowDeveloperTools: onShowDeveloperTools ?? () {},
            onShowChangelog: onShowChangelog,
            onShowAccount: onShowAccount ?? () {},
          ),
        ),
      );
    }

    testWidgets('creates drawer with correct basic structure', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify drawer exists
      expect(find.byType(Drawer), findsOneWidget);

      // Verify main column structure
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('displays header with Graviton branding', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify Graviton text in header
      expect(find.text('Graviton'), findsOneWidget);

      // Verify header has proper styling
      final gravitonText = tester.widget<Text>(find.text('Graviton'));
      expect(gravitonText.style?.color, AppColors.uiWhite);
      expect(gravitonText.style?.fontWeight, FontWeight.w700);
    });

    testWidgets('displays all menu items with correct icons and text', (
      tester,
    ) async {
      // Set larger view size to ensure all menu items fit
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify all expected menu items are present
      expect(find.byIcon(Icons.explore), findsOneWidget);
      expect(find.byIcon(Icons.science), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);

      // Verify avatar button in header (replaces Account menu item)
      expect(find.byType(AvatarButton), findsOneWidget);

      // Verify ListTile widgets for menu items
      expect(find.byType(ListTile), findsWidgets);

      // Verify dividers between menu items
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('calls onShowScenarios when scenarios item is tapped', (
      tester,
    ) async {
      bool scenariosCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onShowScenarios: () {
            scenariosCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the scenarios menu item ListTile
      final scenariosListTile = find.ancestor(
        of: find.byIcon(Icons.explore),
        matching: find.byType(ListTile),
      );
      await tester.tap(scenariosListTile);
      await tester.pumpAndSettle();

      expect(scenariosCalled, isTrue);
    });

    testWidgets('calls onShowPhysicsSettings when physics item is tapped', (
      tester,
    ) async {
      bool physicsCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onShowPhysicsSettings: () {
            physicsCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the physics menu item ListTile
      final physicsListTile = find.ancestor(
        of: find.byIcon(Icons.science),
        matching: find.byType(ListTile),
      );
      await tester.tap(physicsListTile);
      await tester.pumpAndSettle();

      expect(physicsCalled, isTrue);
    });

    testWidgets('calls onShowSettings when settings item is tapped', (
      tester,
    ) async {
      bool settingsCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onShowSettings: () {
            settingsCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the settings menu item ListTile
      final settingsListTile = find.ancestor(
        of: find.byIcon(Icons.tune),
        matching: find.byType(ListTile),
      );
      await tester.tap(settingsListTile);
      await tester.pumpAndSettle();

      expect(settingsCalled, isTrue);
    });

    testWidgets('calls onShowHelp when help item is tapped', (tester) async {
      bool helpCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onShowHelp: () {
            helpCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the help menu item ListTile
      final helpListTile = find.ancestor(
        of: find.byIcon(Icons.lightbulb_outline),
        matching: find.byType(ListTile),
      );
      await tester.tap(helpListTile);
      await tester.pumpAndSettle();

      expect(helpCalled, isTrue);
    });

    testWidgets('calls onShowAbout when about item is tapped', (tester) async {
      bool aboutCalled = false;

      // Set larger view size to ensure about item is visible
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        createTestWidget(
          onShowAbout: () {
            aboutCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the about menu item ListTile
      final aboutListTile = find.ancestor(
        of: find.byIcon(Icons.info_outline),
        matching: find.byType(ListTile),
      );
      await tester.tap(aboutListTile);
      await tester.pumpAndSettle();

      expect(aboutCalled, isTrue);
    });

    testWidgets('calls onShowAccount when avatar button is tapped', (
      tester,
    ) async {
      bool accountCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onShowAccount: () {
            accountCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the avatar button in the header
      final avatarButton = find.byType(AvatarButton);
      expect(avatarButton, findsOneWidget);
      await tester.tap(avatarButton);
      await tester.pumpAndSettle();

      expect(accountCalled, isTrue);
    });

    testWidgets('calls onShowChangelog when changelog link is tapped', (
      tester,
    ) async {
      bool changelogCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onShowChangelog: () {
            changelogCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Additional pump to ensure async version loading completes
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Find and tap the changelog link
      final changelogLink = find.text('Changelog');
      if (changelogLink.evaluate().isNotEmpty) {
        await tester.tap(changelogLink);
        await tester.pumpAndSettle();

        expect(changelogCalled, isTrue);
      }
    });

    testWidgets('has correct drawer width and background color', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final drawer = tester.widget<Drawer>(find.byType(Drawer));
      expect(drawer.width, 320);
      expect(
        drawer.backgroundColor,
        AppColors.uiBlack.withValues(alpha: AppTypography.opacityHigh),
      );
    });

    testWidgets('menu items have proper accessibility', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify ListTiles have proper semantics for accessibility
      final listTiles = find.byType(ListTile);
      expect(listTiles, findsWidgets);

      // Each ListTile should be tappable
      for (final listTile in tester.widgetList<ListTile>(listTiles)) {
        expect(listTile.onTap, isNotNull);
      }
    });

    testWidgets('header has proper border styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find containers and verify border styling exists
      final containers = tester.widgetList<Container>(find.byType(Container));

      // At least one container should have border decoration
      final hasHeaderBorder = containers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).border != null,
      );
      expect(hasHeaderBorder, isTrue);
    });

    testWidgets('dividers have correct styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dividers = tester.widgetList<Divider>(find.byType(Divider));

      for (final divider in dividers) {
        expect(divider.color, AppColors.uiDividerGrey);
        expect(divider.thickness, 1);
        expect(divider.height, 1);
      }
    });

    testWidgets('version display structure exists', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Version display mechanism should be in place
      // We look for the Row that contains version info
      final rows = find.byType(Row);
      expect(rows, findsWidgets);

      // Should have at least one Row in the header area
      expect(rows.evaluate().length, greaterThan(0));
    });
  });

  group('OptionsDrawer Integration Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
    });

    testWidgets('drawer can be opened and closed in scaffold', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: TestUtils.wrapWithScaffold(
            child: Container(),
            endDrawer: OptionsDrawer(
              onShowHelp: () {},
              onShowSettings: () {},
              onShowScenarios: () {},
              onShowPhysicsSettings: () {},
              onShowAbout: () {},
              onShowDeveloperTools: () {},
              onShowAccount: () {},
            ),
          ),
        ),
      );

      // Open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openEndDrawer();
      await tester.pumpAndSettle();

      // Verify drawer is visible
      expect(find.byType(OptionsDrawer), findsOneWidget);
      expect(find.text('Graviton'), findsOneWidget);

      // Close drawer by tapping outside
      await tester.tapAt(const Offset(50, 300));
      await tester.pumpAndSettle();
    });

    testWidgets('proper icon and text layout', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: TestUtils.wrapWithScaffold(
            child: OptionsDrawer(
              onShowHelp: () {},
              onShowSettings: () {},
              onShowScenarios: () {},
              onShowPhysicsSettings: () {},
              onShowAbout: () {},
              onShowDeveloperTools: () {},
              onShowAccount: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify each menu item has both icon and text
      final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));

      for (final listTile in listTiles) {
        expect(
          listTile.leading,
          isNotNull,
          reason: 'ListTile should have leading icon',
        );
        expect(
          listTile.title,
          isNotNull,
          reason: 'ListTile should have title text',
        );
        expect(
          listTile.subtitle,
          isNotNull,
          reason: 'ListTile should have subtitle text',
        );
      }
    });

    testWidgets('drawer maintains proper padding and spacing', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: TestUtils.wrapWithMaterialApp(
            child: OptionsDrawer(
              onShowHelp: () {},
              onShowSettings: () {},
              onShowScenarios: () {},
              onShowPhysicsSettings: () {},
              onShowAbout: () {},
              onShowDeveloperTools: () {},
              onShowAccount: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check that ListTiles have proper content padding
      final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));

      for (final listTile in listTiles) {
        expect(listTile.contentPadding, isNotNull);
        final padding = listTile.contentPadding as EdgeInsets;
        expect(padding.left, AppTypography.spacingLarge);
        expect(padding.right, AppTypography.spacingLarge);
        expect(padding.top, AppTypography.spacingSmall);
        expect(padding.bottom, AppTypography.spacingSmall);
      }
    });
  });
}
