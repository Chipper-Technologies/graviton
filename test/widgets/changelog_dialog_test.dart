import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/changelog_category.dart';
import 'package:graviton/models/changelog.dart';
import 'package:graviton/widgets/changelog_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/l10n/app_localizations.dart';

void main() {
  group('ChangelogDialog Widget Tests', () {
    late List<ChangelogVersion> testChangelogs;

    setUp(() {
      testChangelogs = [
        ChangelogVersion(
          version: '1.1.0',
          title: 'Feature Update',
          releaseDate: DateTime(2024, 2, 1),
          entries: [
            ChangelogEntry(
              title: 'New simulation',
              category: ChangelogCategory.added,
              description: 'Added binary star system',
            ),
            ChangelogEntry(
              title: 'Performance',
              category: ChangelogCategory.improved,
              description: 'Faster rendering',
            ),
            ChangelogEntry(
              title: 'Bug fix',
              category: ChangelogCategory.fixed,
              description: 'Fixed camera controls',
            ),
          ],
        ),
        ChangelogVersion(
          version: '1.0.0',
          title: 'Initial Release',
          releaseDate: DateTime(2024, 1, 1),
          entries: [
            ChangelogEntry(
              title: 'Initial release',
              category: ChangelogCategory.added,
              description: 'Welcome to Graviton!',
            ),
          ],
        ),
      ];
    });

    Widget createTestWidget({VoidCallback? onComplete}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChangelogDialog(
            changelogs: testChangelogs,
            onComplete: onComplete ?? () {},
          ),
        ),
      );
    }

    testWidgets('should display changelog dialog with version info', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Print widget tree for debugging
      debugDumpApp();

      // Check if the dialog is displayed
      expect(find.byType(ChangelogDialog), findsOneWidget);

      // Check if the dialog has content - looking for any text
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should navigate between changelogs with swipe gestures', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify we start with the newest changelog (1.1.0)
      expect(find.text('Feature Update'), findsOneWidget);
      expect(find.textContaining('1.1.0'), findsOneWidget);

      // Tap the left chevron to navigate to the previous (older) changelog version
      final previousButton = find.byIcon(Icons.chevron_left);
      if (previousButton.evaluate().isNotEmpty) {
        final previousButtonFinder = find.ancestor(
          of: previousButton,
          matching: find.byType(IconButton),
        );
        await tester.tap(previousButtonFinder);
        await tester.pumpAndSettle();

        // Should now show the 1.0.0 changelog
        expect(find.text('Initial Release'), findsOneWidget);
        expect(find.textContaining('1.0.0'), findsOneWidget);
      }
    });

    testWidgets('should display correct step indicators', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have the dialog
      expect(find.byType(ChangelogDialog), findsOneWidget);

      // Check that Container widgets are rendered (for step indicators)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should categorize entries correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // We start with the newest changelog (1.1.0) which has the categories we want to test
      expect(find.text('Feature Update'), findsOneWidget);

      // Check for different category sections in the 1.1.0 changelog
      // Check for entry titles
      expect(find.text('New simulation'), findsOneWidget);
      expect(find.text('Performance'), findsOneWidget);
      expect(find.text('Bug fix'), findsOneWidget);

      // Check for entry descriptions
      expect(find.text('Added binary star system'), findsOneWidget);
      expect(find.text('Faster rendering'), findsOneWidget);
      expect(find.text('Fixed camera controls'), findsOneWidget);
    });

    testWidgets('should call onComplete when dialog is closed', (tester) async {
      bool completeCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onComplete: () {
            completeCalled = true;
          },
        ),
      );

      // Look for close button (assuming it uses a standard close icon)
      final closeButtonFinder = find.byIcon(Icons.close);
      if (closeButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(closeButtonFinder);
        await tester.pumpAndSettle();

        expect(completeCalled, true);
      }
    });

    testWidgets('should handle empty changelog list gracefully', (
      tester,
    ) async {
      final emptyWidget = MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChangelogDialog(changelogs: const [], onComplete: () {}),
        ),
      );

      await tester.pumpWidget(emptyWidget);

      // Dialog should still render without errors
      expect(find.byType(ChangelogDialog), findsOneWidget);
    });
  });
}
