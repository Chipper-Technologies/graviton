import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/custom_scenario_summary.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('CustomScenarioSummary', () {
    test('should create instance with all required fields', () {
      final summary = CustomScenarioSummary(
        name: 'Test Scenario',
        description: 'A test scenario for validation',
        bodyCount: 3,
        difficulty: 'intermediate',
        educationalFocus: 'orbital mechanics',
        tags: ['test', 'validation'],
        createdAt: DateTime(2024, 1, 15),
      );

      expect(summary.name, equals('Test Scenario'));
      expect(summary.description, equals('A test scenario for validation'));
      expect(summary.bodyCount, equals(3));
      expect(summary.difficulty, equals('intermediate'));
      expect(summary.educationalFocus, equals('orbital mechanics'));
      expect(summary.tags, equals(['test', 'validation']));
      expect(summary.createdAt, equals(DateTime(2024, 1, 15)));
    });

    test('should create instance without optional createdAt field', () {
      final summary = CustomScenarioSummary(
        name: 'Minimal Scenario',
        description: 'A minimal test scenario',
        bodyCount: 2,
        difficulty: 'beginner',
        educationalFocus: 'basic physics',
        tags: ['minimal'],
      );

      expect(summary.name, equals('Minimal Scenario'));
      expect(summary.description, equals('A minimal test scenario'));
      expect(summary.bodyCount, equals(2));
      expect(summary.difficulty, equals('beginner'));
      expect(summary.educationalFocus, equals('basic physics'));
      expect(summary.tags, equals(['minimal']));
      expect(summary.createdAt, isNull);
    });

    test('should format difficulty display with proper capitalization', () {
      final beginnerSummary = CustomScenarioSummary(
        name: 'Easy Test',
        description: 'Easy scenario',
        bodyCount: 2,
        difficulty: 'beginner',
        educationalFocus: 'basics',
        tags: [],
      );

      final intermediateSummary = CustomScenarioSummary(
        name: 'Medium Test',
        description: 'Medium scenario',
        bodyCount: 5,
        difficulty: 'intermediate',
        educationalFocus: 'orbits',
        tags: [],
      );

      final advancedSummary = CustomScenarioSummary(
        name: 'Hard Test',
        description: 'Hard scenario',
        bodyCount: 10,
        difficulty: 'advanced',
        educationalFocus: 'chaos',
        tags: [],
      );

      expect(beginnerSummary.difficultyDisplay, equals('Beginner'));
      expect(intermediateSummary.difficultyDisplay, equals('Intermediate'));
      expect(advancedSummary.difficultyDisplay, equals('Advanced'));
    });

    test('should return correct colors for difficulty levels', () {
      final beginnerSummary = CustomScenarioSummary(
        name: 'Test',
        description: 'Test',
        bodyCount: 2,
        difficulty: 'beginner',
        educationalFocus: 'test',
        tags: [],
      );

      final intermediateSummary = CustomScenarioSummary(
        name: 'Test',
        description: 'Test',
        bodyCount: 2,
        difficulty: 'intermediate',
        educationalFocus: 'test',
        tags: [],
      );

      final advancedSummary = CustomScenarioSummary(
        name: 'Test',
        description: 'Test',
        bodyCount: 2,
        difficulty: 'advanced',
        educationalFocus: 'test',
        tags: [],
      );

      final unknownSummary = CustomScenarioSummary(
        name: 'Test',
        description: 'Test',
        bodyCount: 2,
        difficulty: 'unknown',
        educationalFocus: 'test',
        tags: [],
      );

      expect(beginnerSummary.difficultyColor, equals(AppColors.uiGreen));
      expect(intermediateSummary.difficultyColor, equals(AppColors.uiOrange));
      expect(advancedSummary.difficultyColor, equals(AppColors.uiRed));
      expect(unknownSummary.difficultyColor, equals(AppColors.primaryColor));
    });

    test('should handle case-insensitive difficulty colors', () {
      final upperCaseSummary = CustomScenarioSummary(
        name: 'Test',
        description: 'Test',
        bodyCount: 2,
        difficulty: 'BEGINNER',
        educationalFocus: 'test',
        tags: [],
      );

      final mixedCaseSummary = CustomScenarioSummary(
        name: 'Test',
        description: 'Test',
        bodyCount: 2,
        difficulty: 'InTeRmEdIaTe',
        educationalFocus: 'test',
        tags: [],
      );

      expect(upperCaseSummary.difficultyColor, equals(AppColors.uiGreen));
      expect(mixedCaseSummary.difficultyColor, equals(AppColors.uiOrange));
    });

    testWidgets('bodyCountDisplay returns correct localized string', (
      tester,
    ) async {
      // Build a widget to get context with localization
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final summary = CustomScenarioSummary(
                name: 'Test Scenario',
                description: 'A test scenario',
                bodyCount: 5,
                difficulty: 'Medium',
                educationalFocus: 'Orbital mechanics',
                tags: ['test'],
                createdAt: DateTime.now(),
              );

              expect(summary.bodyCountDisplay(context), '5 bodies');
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('should format creation date display correctly', (
      tester,
    ) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final threeDaysAgo = today.subtract(const Duration(days: 3));
      final twoWeeksAgo = today.subtract(const Duration(days: 14));
      final twoMonthsAgo = today.subtract(const Duration(days: 60));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final todaySummary = CustomScenarioSummary(
                name: 'Today Test',
                description: 'Today scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: today,
              );

              final yesterdaySummary = CustomScenarioSummary(
                name: 'Yesterday Test',
                description: 'Yesterday scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: yesterday,
              );

              final threeDaysSummary = CustomScenarioSummary(
                name: 'Three Days Test',
                description: 'Three days scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: threeDaysAgo,
              );

              final twoWeeksSummary = CustomScenarioSummary(
                name: 'Two Weeks Test',
                description: 'Two weeks scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: twoWeeksAgo,
              );

              final twoMonthsSummary = CustomScenarioSummary(
                name: 'Two Months Test',
                description: 'Two months scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: twoMonthsAgo,
              );

              final nullDateSummary = CustomScenarioSummary(
                name: 'Null Date Test',
                description: 'Null date scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: null,
              );

              expect(todaySummary.createdAtDisplay(context), equals('Today'));
              expect(
                yesterdaySummary.createdAtDisplay(context),
                equals('Yesterday'),
              );
              expect(
                threeDaysSummary.createdAtDisplay(context),
                equals('3 days ago'),
              );
              expect(
                twoWeeksSummary.createdAtDisplay(context),
                equals('2 weeks ago'),
              );
              expect(
                twoMonthsSummary.createdAtDisplay(context),
                equals('2 months ago'),
              );
              expect(
                nullDateSummary.createdAtDisplay(context),
                equals('Unknown'),
              );

              return const Scaffold();
            },
          ),
        ),
      );
    });

    testWidgets('should handle edge cases for date formatting', (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final oneWeekAgo = today.subtract(const Duration(days: 7));
      final oneMonthAgo = today.subtract(const Duration(days: 30));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final oneWeekSummary = CustomScenarioSummary(
                name: 'One Week Test',
                description: 'One week scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: oneWeekAgo,
              );

              final oneMonthSummary = CustomScenarioSummary(
                name: 'One Month Test',
                description: 'One month scenario',
                bodyCount: 2,
                difficulty: 'beginner',
                educationalFocus: 'test',
                tags: [],
                createdAt: oneMonthAgo,
              );

              expect(
                oneWeekSummary.createdAtDisplay(context),
                equals('1 week ago'),
              );
              expect(
                oneMonthSummary.createdAtDisplay(context),
                equals('1 month ago'),
              );

              return const Scaffold();
            },
          ),
        ),
      );
    });

    test('should handle empty tags list', () {
      final summary = CustomScenarioSummary(
        name: 'No Tags Test',
        description: 'Scenario with no tags',
        bodyCount: 3,
        difficulty: 'intermediate',
        educationalFocus: 'physics',
        tags: [],
      );

      expect(summary.tags, isEmpty);
    });

    test('should handle large body count', () {
      final summary = CustomScenarioSummary(
        name: 'Large Scenario',
        description: 'Scenario with many bodies',
        bodyCount: 1000,
        difficulty: 'advanced',
        educationalFocus: 'n-body simulation',
        tags: ['stress-test', 'performance'],
      );

      expect(summary.bodyCount, equals(1000));
      expect(summary.tags.length, equals(2));
    });

    test('should handle very old creation dates', () {
      final oldDate = DateTime(2020, 1, 1);

      final summary = CustomScenarioSummary(
        name: 'Old Scenario',
        description: 'Very old scenario',
        bodyCount: 3,
        difficulty: 'beginner',
        educationalFocus: 'historical',
        tags: ['old'],
        createdAt: oldDate,
      );

      expect(summary.createdAt, equals(oldDate));
    });

    test('should handle future creation dates', () {
      final futureDate = DateTime.now().add(const Duration(days: 30));

      final summary = CustomScenarioSummary(
        name: 'Future Scenario',
        description: 'Scenario from the future',
        bodyCount: 5,
        difficulty: 'advanced',
        educationalFocus: 'time travel',
        tags: ['future'],
        createdAt: futureDate,
      );

      expect(summary.createdAt, equals(futureDate));
    });
  });
}
