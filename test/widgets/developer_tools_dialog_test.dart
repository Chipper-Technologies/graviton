import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/widgets/developer_tools_dialog.dart';
import 'package:graviton/widgets/screenshot_mode_widget.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DeveloperToolsDialog', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
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
        home: Scaffold(body: child),
      );
    }

    group('Rendering', () {
      testWidgets('Should display developer tools dialog', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('Should have consistent styling with bottom menu format', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pumpAndSettle();

        // Should have proper dialog structure with styling
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(Container), findsWidgets);

        // Should have gradient header
        final gradientContainers = find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration is BoxDecoration,
        );
        expect(gradientContainers, findsWidgets);
      });

      testWidgets('Should display header with developer tools icon and title', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        expect(find.text('Developer Tools'), findsOneWidget);
        expect(find.byIcon(Icons.developer_mode), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('Should display all sections with proper icons', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Check for section titles
        expect(find.byType(SectionTitle), findsWidgets);

        // Check for Help & Objectives section
        expect(find.text('Help & Objectives'), findsOneWidget);
        expect(find.byIcon(Icons.help_outline), findsAtLeastNWidgets(1));

        // Check for Changelog section
        expect(find.text('Changelog (Debug)'), findsOneWidget);
        expect(find.byIcon(Icons.assignment), findsAtLeastNWidgets(1));
      });

      testWidgets('Should conditionally display screenshot mode section', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Screenshot mode section should only appear if service is available
        if (ScreenshotModeService().isAvailable) {
          expect(find.text('Marketing'), findsOneWidget);
          expect(find.byType(ScreenshotModeWidget), findsOneWidget);
          expect(find.byIcon(Icons.camera_alt), findsAtLeastNWidgets(1));
        } else {
          expect(find.text('Marketing'), findsNothing);
          expect(find.byType(ScreenshotModeWidget), findsNothing);
        }
      });

      testWidgets('Should have proper layout structure with sections', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pumpAndSettle();

        // Should have dialog structure
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // Should have sections with proper containers
        final sectionContainers = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.padding != null &&
              widget.decoration is BoxDecoration,
        );
        expect(sectionContainers, findsWidgets);
      });
    });

    group('Debug Mode Behavior', () {
      testWidgets('Should show reset tutorial button only in debug mode', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        if (kDebugMode) {
          expect(find.text('Reset'), findsOneWidget);
          // Look for Material buttons instead of specific button types
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Material && widget.type == MaterialType.button,
            ),
            findsAtLeastNWidgets(2),
          ); // At least Tutorial and Show Changelog buttons
        } else {
          expect(find.text('Reset'), findsNothing);
        }
      });

      testWidgets('Should be debug-only dialog', (WidgetTester tester) async {
        // This test ensures the dialog is intended for debug use
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Developer tools should always be accessible when instantiated
        expect(find.byType(DeveloperToolsDialog), findsOneWidget);
        expect(find.text('Developer Tools'), findsOneWidget);
      });
    });

    group('User Interactions', () {
      testWidgets('Should close dialog when close button is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const DeveloperToolsDialog(),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Open dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(DeveloperToolsDialog), findsOneWidget);

        // Close dialog
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
        expect(find.byType(DeveloperToolsDialog), findsNothing);
      });

      testWidgets('Should handle tutorial button tap', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Find tutorial text and button
        expect(find.text('Tutorial'), findsOneWidget);
        final tutorialButton = find.ancestor(
          of: find.text('Tutorial'),
          matching: find.byWidgetPredicate((widget) => widget is InkWell),
        );
        expect(tutorialButton, findsOneWidget);

        await tester.tap(tutorialButton);
        await tester.pump();

        // Button should be interactive (no assertion errors)
      });

      testWidgets('Should handle changelog button tap', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Find changelog text and button
        expect(find.text('Show Changelog'), findsOneWidget);
        final changelogButton = find.ancestor(
          of: find.text('Show Changelog'),
          matching: find.byWidgetPredicate((widget) => widget is InkWell),
        );
        expect(changelogButton, findsOneWidget);

        await tester.tap(changelogButton);
        await tester.pump();

        // Button should be interactive (no assertion errors)
      });

      testWidgets('Should handle reset tutorial button tap in debug mode', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        if (kDebugMode) {
          // Find reset tutorial text and button
          expect(find.text('Reset'), findsOneWidget);
          final resetButton = find.ancestor(
            of: find.text('Reset'),
            matching: find.byWidgetPredicate((widget) => widget is InkWell),
          );
          expect(resetButton, findsOneWidget);

          await tester.tap(resetButton);
          await tester.pump();

          // Button should be interactive (no assertion errors)
        }
      });
    });

    group('Button Styling', () {
      testWidgets('Should have primary and secondary button styles', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Should have Material buttons (Tutorial, Changelog)
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Material && widget.type == MaterialType.button,
          ),
          findsAtLeast(2),
        );

        // Should have text content for buttons
        expect(find.text('Tutorial'), findsOneWidget);
        expect(find.text('Show Changelog'), findsOneWidget);

        // In debug mode, should also have reset button
        if (kDebugMode) {
          expect(find.text('Reset'), findsOneWidget);
        }
      });

      testWidgets('Should have consistent button layout', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Should have multiple interactive elements with consistent layout
        expect(find.byType(InkWell), findsAtLeast(2));

        // All interactive elements should be within the dialog
        expect(find.byType(DeveloperToolsDialog), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('Should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Dialog should be accessible
        expect(find.byType(Dialog), findsOneWidget);

        // Buttons should have text labels
        expect(find.text('Tutorial'), findsOneWidget);
        expect(find.text('Show Changelog'), findsOneWidget);

        if (kDebugMode) {
          expect(find.text('Reset'), findsOneWidget);
        }
      });

      testWidgets('Should have proper focus handling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Dialog should handle focus properly
        final dialog = find.byType(Dialog);
        expect(dialog, findsOneWidget);

        // Should be able to tab through interactive elements
        expect(
          find.byType(IconButton),
          findsAtLeastNWidgets(1),
        ); // Close button
        expect(find.byType(InkWell), findsAtLeastNWidgets(2)); // Action buttons
      });
    });

    group('Localization', () {
      testWidgets('Should display localized text', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsDialog()),
        );
        await tester.pump();

        // Check for localized strings
        expect(find.text('Developer Tools'), findsOneWidget);
        expect(find.text('Help & Objectives'), findsOneWidget);
        expect(find.text('Changelog (Debug)'), findsOneWidget);
        expect(find.text('Tutorial'), findsOneWidget);
        expect(find.text('Show Changelog'), findsOneWidget);

        if (kDebugMode) {
          expect(find.text('Reset'), findsOneWidget);
        }
      });
    });
  });
}
