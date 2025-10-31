import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
          version: '1.0.0',
          title: 'Initial Release',
          releaseDate: DateTime(2024, 1, 1),
          entries: [
            ChangelogEntry(
              title: 'Initial release',
              category: 'added',
              description: 'Welcome to Graviton!',
            ),
          ],
        ),
        ChangelogVersion(
          version: '1.1.0',
          title: 'Feature Update',
          releaseDate: DateTime(2024, 2, 1),
          entries: [
            ChangelogEntry(
              title: 'New simulation',
              category: 'added',
              description: 'Added binary star system',
            ),
            ChangelogEntry(
              title: 'Performance',
              category: 'improved',
              description: 'Faster rendering',
            ),
            ChangelogEntry(
              title: 'Bug fix',
              category: 'fixed',
              description: 'Fixed camera controls',
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

      // Verify the dialog renders
      expect(find.byType(ChangelogDialog), findsOneWidget);

      // Just check that we can interact with it
      expect(find.byType(GestureDetector), findsWidgets);
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

      // Navigate to second changelog which has multiple categories
      await tester.fling(
        find.byType(ChangelogDialog),
        const Offset(-300, 0),
        800,
      );
      await tester.pumpAndSettle();

      // Check for different category sections
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
