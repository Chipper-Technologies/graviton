import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/shared/widgets/layouts/sliding_panel_bottom_sheet.dart';
import 'package:graviton/widgets/common/graviton_tabbed_view.dart';
import 'package:graviton/widgets/common/graviton_tab.dart';
import 'package:graviton/widgets/common/graviton_tab_bar.dart';
import 'package:provider/provider.dart';

void main() {
  group('Tab Expansion on Tap Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    tearDown(() {
      appState.dispose();
    });

    testWidgets('GravitonTabBar should call onTabTap when tab is tapped', (
      WidgetTester tester,
    ) async {
      bool tapCallbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  final controller = DefaultTabController.of(context);
                  return GravitonTabBar(
                    controller: controller,
                    tabs: const [
                      GravitonTab(icon: Icons.camera, label: 'Camera'),
                      GravitonTab(icon: Icons.visibility, label: 'Visuals'),
                    ],
                    onTabTap: () {
                      tapCallbackTriggered = true;
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the second tab
      await tester.tap(find.text('Visuals'));
      await tester.pump();

      // Verify callback was triggered
      expect(tapCallbackTriggered, true);
    });

    testWidgets('GravitonTabbedView should pass onTabTap to GravitonTabBar', (
      WidgetTester tester,
    ) async {
      bool tapCallbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GravitonTabbedView(
              tabs: const [
                GravitonTab(icon: Icons.camera, label: 'Camera'),
                GravitonTab(icon: Icons.visibility, label: 'Visuals'),
              ],
              children: const [
                Center(child: Text('Camera Content')),
                Center(child: Text('Visuals Content')),
              ],
              onTabTap: () {
                tapCallbackTriggered = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a tab
      await tester.tap(find.text('Visuals'));
      await tester.pump();

      // Verify callback was triggered
      expect(tapCallbackTriggered, true);
    });

    testWidgets(
      'SlidingPanelBottomSheet tabs should expand panel when tapped in closed position',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ChangeNotifierProvider<AppState>.value(
              value: appState,
              child: const Scaffold(body: SlidingPanelBottomSheet()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Get initial panel position (should be closed - 0.15)
        final initialPosition = SlidingPanelBottomSheet.sheetPosition.value;
        expect(initialPosition, lessThanOrEqualTo(0.15));

        // Tap on a tab (e.g., Visuals tab)
        await tester.tap(find.text('Visuals'));
        await tester.pumpAndSettle();

        // Panel should now be expanded to at least medium height
        final newPosition = SlidingPanelBottomSheet.sheetPosition.value;
        expect(newPosition, greaterThan(0.15));
      },
    );

    testWidgets('Tab tap should work independently of tab switching', (
      WidgetTester tester,
    ) async {
      int tapCount = 0;
      int tabChangeCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GravitonTabbedView(
              tabs: const [
                GravitonTab(icon: Icons.camera, label: 'Camera'),
                GravitonTab(icon: Icons.visibility, label: 'Visuals'),
              ],
              children: const [
                Center(child: Text('Camera Content')),
                Center(child: Text('Visuals Content')),
              ],
              onTabTap: () {
                tapCount++;
              },
              onTabChanged: (index) {
                tabChangeCount++;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the same tab (Camera - already selected)
      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();

      // onTabTap should trigger even when tapping the same tab
      expect(tapCount, greaterThan(0));

      // Now tap a different tab
      await tester.tap(find.text('Visuals'));
      await tester.pumpAndSettle();

      // Both callbacks should have been triggered
      expect(tapCount, greaterThan(1));
      expect(tabChangeCount, greaterThan(0));
    });

    testWidgets('onTabTap should be optional', (WidgetTester tester) async {
      // Should not throw when onTabTap is not provided
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GravitonTabbedView(
              tabs: const [
                GravitonTab(icon: Icons.camera, label: 'Camera'),
                GravitonTab(icon: Icons.visibility, label: 'Visuals'),
              ],
              children: const [
                Center(child: Text('Camera Content')),
                Center(child: Text('Visuals Content')),
              ],
              // No onTabTap provided
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should work without throwing
      await tester.tap(find.text('Visuals'));
      await tester.pumpAndSettle();

      expect(find.text('Visuals Content'), findsOneWidget);
    });
  });
}
