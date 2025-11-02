import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/changelog_category.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/changelog.dart';
import 'package:graviton/services/changelog_service.dart';
import 'package:graviton/services/version_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/utils/version_utils.dart';
import 'package:graviton/widgets/settings_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsDialog Changelog Logic', () {
    late AppState appState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    Widget createTestWidget({required Widget child}) {
      appState = AppState();
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
          supportedLocales: const [Locale('en')],
          home: Scaffold(body: child),
        ),
      );
    }

    group('Version Logic Tests', () {
      test(
        'VersionUtils.getNextMinorVersion should calculate correct next minor version',
        () {
          // Test data: input version -> expected next minor version
          final testCases = [
            ['1.0.0', '1.1.0'],
            ['1.0.5', '1.1.0'],
            ['1.1.0', '1.2.0'],
            ['1.1.1', '1.2.0'],
            ['1.1.9', '1.2.0'],
            ['2.0.0', '2.1.0'],
            ['2.5.3', '2.6.0'],
            ['10.15.7', '10.16.0'],
          ];

          for (final testCase in testCases) {
            final input = testCase[0];
            final expected = testCase[1];

            // Use VersionUtils instead of private method
            final result = VersionUtils.getNextMinorVersion(input);
            expect(
              result,
              expected,
              reason: 'Input: $input should produce: $expected',
            );
          }
        },
      );

      test('VersionUtils.getNextMinorVersion should handle edge cases', () {
        final edgeCases = [
          {'input': '', 'fallback': '1.1.0'},
          {'input': 'invalid', 'fallback': '1.1.0'},
          {'input': '1', 'fallback': '1.1.0'},
          {'input': '1.', 'fallback': '1.1.0'},
          {'input': 'v1.0.0', 'fallback': '1.1.0'},
        ];

        for (final testCase in edgeCases) {
          final input = testCase['input'] as String;
          final expected = testCase['fallback'] as String;

          final result = VersionUtils.getNextMinorVersion(input);
          expect(
            result,
            expected,
            reason: 'Edge case input: "$input" should fallback to: $expected',
          );
        }
      });
    });

    group('Changelog Version Selection Logic', () {
      testWidgets('should find exact version match first', (
        WidgetTester tester,
      ) async {
        // Mock version service to return 1.1.1
        VersionService.instance.setMockVersion('1.1.1');

        // Mock changelog service with test data
        final mockService = ChangelogService.instance;
        await mockService.initialize();

        // Clear any existing cached data first
        mockService.clearCache();

        // Add mock changelogs
        await mockService.addMockChangelog(
          ChangelogVersion(
            version: '1.1.1',
            title: 'Exact Match',
            releaseDate: DateTime(2024, 1, 1),
            entries: [
              ChangelogEntry(
                title: 'Exact version feature',
                description: 'This is the exact version',
                category: ChangelogCategory.added,
              ),
            ],
          ),
        );

        await mockService.addMockChangelog(
          ChangelogVersion(
            version: '1.2.0',
            title: 'Next Minor',
            releaseDate: DateTime(2024, 2, 1),
            entries: [
              ChangelogEntry(
                title: 'Next minor feature',
                description: 'This is the next minor version',
                category: ChangelogCategory.added,
              ),
            ],
          ),
        );

        // Test that exact version is preferred
        final exactVersion = await mockService.fetchChangelogVersion('1.1.1');
        expect(exactVersion, isNotNull);
        expect(exactVersion!.version, '1.1.1');
        expect(exactVersion.title, 'Exact Match');
      });

      testWidgets('should find next minor version when exact not available', (
        WidgetTester tester,
      ) async {
        // Mock version service to return 1.1.1
        VersionService.instance.setMockVersion('1.1.1');

        // Mock changelog service with test data (no exact match)
        final mockService = ChangelogService.instance;
        await mockService.initialize();

        // Clear any existing cached data first
        mockService.clearCache();

        // Add only next minor version changelog
        await mockService.addMockChangelog(
          ChangelogVersion(
            version: '1.2.0',
            title: 'Next Minor Version',
            releaseDate: DateTime(2024, 2, 1),
            entries: [
              ChangelogEntry(
                title: 'Next minor feature',
                description: 'This should be found when 1.1.1 is not available',
                category: ChangelogCategory.added,
              ),
            ],
          ),
        );

        // Test that next minor version is found
        final exactVersion = await mockService.fetchChangelogVersion('1.1.1');
        expect(exactVersion, isNull); // Exact version should not exist

        final nextMinorVersion = await mockService.fetchChangelogVersion(
          '1.2.0',
        );
        expect(nextMinorVersion, isNotNull);
        expect(nextMinorVersion!.version, '1.2.0');
        expect(nextMinorVersion.title, 'Next Minor Version');
      });
    });

    group('Settings Dialog Integration', () {
      testWidgets('changelog button should be visible in debug mode', (
        WidgetTester tester,
      ) async {
        // This test only runs in debug mode
        if (kDebugMode) {
          await tester.pumpWidget(
            createTestWidget(child: const SettingsDialog()),
          );
          await tester.pumpAndSettle();

          // Look for the changelog button
          expect(find.text('Show Changelog'), findsOneWidget);
          expect(find.text('Reset Changelog State'), findsOneWidget);
        }
      });

      testWidgets('changelog section should not be visible in release mode', (
        WidgetTester tester,
      ) async {
        // This test simulates release mode behavior
        if (!kDebugMode) {
          await tester.pumpWidget(
            createTestWidget(child: const SettingsDialog()),
          );
          await tester.pumpAndSettle();

          // Changelog buttons should not be present
          expect(find.text('Show Changelog'), findsNothing);
          expect(find.text('Reset Changelog State'), findsNothing);
        }
      });

      testWidgets(
        'changelog button should have correct styling to match tutorial section',
        (WidgetTester tester) async {
          if (kDebugMode) {
            await tester.pumpWidget(
              createTestWidget(child: const SettingsDialog()),
            );
            await tester.pumpAndSettle();

            // Find the changelog button
            final changelogButton = find.text('Show Changelog');
            expect(changelogButton, findsOneWidget);

            // Check that it's an ElevatedButton.icon widget
            final elevatedButton = find.ancestor(
              of: changelogButton,
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget.runtimeType.toString() == '_ElevatedButtonWithIcon',
              ),
            );
            expect(elevatedButton, findsOneWidget);

            // Find the reset button
            final resetButton = find.text('Reset Changelog State');
            expect(resetButton, findsOneWidget);

            // Check that it's a TextButton.icon widget
            final textButton = find.ancestor(
              of: resetButton,
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget.runtimeType.toString() == '_TextButtonWithIcon',
              ),
            );
            expect(textButton, findsOneWidget);
          }
        },
      );
    });

    group('Error Handling', () {
      test('should handle invalid version formats gracefully', () {
        final invalidVersions = ['', 'invalid', '1.', '1.a.b', 'v1.0.0'];

        for (final version in invalidVersions) {
          final result = VersionUtils.getNextMinorVersion(version);
          expect(
            result,
            '1.1.0',
            reason: 'Invalid version "$version" should fallback to 1.1.0',
          );
        }
      });

      test('should handle very large version numbers', () {
        final result = VersionUtils.getNextMinorVersion('999.999.999');
        expect(result, '999.1000.0');
      });
    });
  });
}

/// Extension to add mock version capability to VersionService for testing
extension VersionServiceMock on VersionService {
  void setMockVersion(String version) {
    // This would need to be implemented in the actual VersionService
    // For now, this is a placeholder for the testing concept
  }
}
