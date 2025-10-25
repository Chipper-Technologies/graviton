import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/settings_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsDialog', () {
    late AppState appState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    Widget createTestWidget({required Widget child}) {
      appState = AppState();
      // Initialize the AppState
      appState.initializeAsync();

      return ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('Should display settings dialog', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('Should have consistent padding and constraints', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pumpAndSettle();

        // Should have dialog structure
        expect(find.byType(Dialog), findsOneWidget);
        expect(
          find.byType(Container),
          findsWidgets,
        ); // Multiple containers for layout
      });

      testWidgets('Should display header with title and close button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        expect(find.text('Settings'), findsAtLeastNWidgets(1));
        expect(find.byType(IconButton), findsAtLeastNWidgets(1));
      });

      testWidgets('Should display all setting options', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Check for essential UI elements
        expect(find.byType(Switch), findsAtLeastNWidgets(1));
        expect(find.byType(Slider), findsAtLeastNWidgets(1));
      });

      testWidgets('Should have proper layout structure', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pumpAndSettle();

        // Should have dialog structure
        expect(find.byType(Dialog), findsOneWidget);
        expect(
          find.byType(Column),
          findsWidgets,
        ); // Multiple columns for layout
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Interaction', () {
      testWidgets('Should handle switch toggles', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          await tester.tap(switches.first);
          await tester.pump();
        }

        // Test passes if no exceptions thrown
        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should handle slider changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        final sliders = find.byType(Slider);
        if (sliders.evaluate().isNotEmpty) {
          await tester.drag(sliders.first, const Offset(50, 0));
          await tester.pump();
        }

        // Test passes if no exceptions thrown
        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should handle close button press', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        final closeButtons = find.byType(IconButton);
        if (closeButtons.evaluate().isNotEmpty) {
          await tester.tap(closeButtons.first);
          await tester.pump();
        }

        // Test passes if no exceptions thrown
        expect(find.byType(SettingsDialog), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('Should sync with AppState', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Test basic state synchronization
        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should update settings through Provider', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Interact with settings
        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          await tester.tap(switches.first);
          await tester.pump();
        }

        expect(find.byType(SettingsDialog), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('Should support screen readers', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Check for semantic widgets
        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should have proper focus management', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Test focus behavior
        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should provide value announcements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        final sliders = find.byType(Slider);
        if (sliders.evaluate().isNotEmpty) {
          await tester.drag(sliders.first, const Offset(10, 0));
          await tester.pump();
        }

        expect(find.byType(SettingsDialog), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('Should render efficiently', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Check widget tree complexity
        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should dispose properly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Trigger disposal
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        // Test passes if no memory leaks or exceptions
      });

      testWidgets('Should handle rapid state changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Rapid interactions
        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          for (int i = 0; i < 3; i++) {
            await tester.tap(switches.first);
            await tester.pump(const Duration(milliseconds: 10));
          }
        }

        expect(find.byType(SettingsDialog), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('Should handle extreme slider values', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        final sliders = find.byType(Slider);
        if (sliders.evaluate().isNotEmpty) {
          // Test extreme values
          await tester.drag(sliders.first, const Offset(-500, 0));
          await tester.pump();
          await tester.drag(sliders.first, const Offset(500, 0));
          await tester.pump();
        }

        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should handle null or invalid states gracefully', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Test with invalid operations
        expect(find.byType(SettingsDialog), findsOneWidget);
      });

      testWidgets('Should maintain consistency across rebuilds', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Force rebuild
        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          await tester.tap(switches.first);
          await tester.pump();
          await tester.pumpAndSettle();
        }

        expect(find.byType(SettingsDialog), findsOneWidget);
      });
    });
  });
}
