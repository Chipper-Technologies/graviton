import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/utils/localization_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('LocalizationUtils Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: child),
      );
    }

    group('getLocalizedBodyName', () {
      testWidgets('should return localized name for known celestial bodies', (
        WidgetTester tester,
      ) async {
        late String result;

        await tester.pumpWidget(
          createTestWidget(
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                result = LocalizationUtils.getLocalizedBodyName('Earth', l10n);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotEmpty);
      });

      testWidgets('should handle numbered bodies correctly', (
        WidgetTester tester,
      ) async {
        late String result;

        await tester.pumpWidget(
          createTestWidget(
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                result = LocalizationUtils.getLocalizedBodyName(
                  'Asteroid 5',
                  l10n,
                );
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, contains('5'));
      });

      test('should return original name for unknown bodies', () {
        const storedName = 'Unknown Planet X';
        final result = LocalizationUtils.getLocalizedBodyName(storedName, null);
        expect(result, equals(storedName));
      });

      test('should handle null localizations gracefully', () {
        const storedName = 'Earth';
        final result = LocalizationUtils.getLocalizedBodyName(storedName, null);
        expect(result, equals(storedName));
      });
    });

    group('getLocalizedScenarioName', () {
      testWidgets(
        'should return correct scenario names for all supported scenarios',
        (WidgetTester tester) async {
          final Map<ScenarioType, String> results = {};

          await tester.pumpWidget(
            createTestWidget(
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;

                  results[ScenarioType.random] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.random,
                      );
                  results[ScenarioType.earthMoonSun] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.earthMoonSun,
                      );
                  results[ScenarioType.binaryStars] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.binaryStars,
                      );
                  results[ScenarioType.asteroidBelt] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.asteroidBelt,
                      );
                  results[ScenarioType.galaxyFormation] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.galaxyFormation,
                      );
                  results[ScenarioType.solarSystem] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.solarSystem,
                      );

                  return const SizedBox();
                },
              ),
            ),
          );

          // All results should be non-empty strings
          for (final result in results.values) {
            expect(result, isNotEmpty);
          }
        },
      );

      testWidgets(
        'should return special scenario name for screenshot scenarios',
        (WidgetTester tester) async {
          final Map<ScenarioType, String> results = {};

          await tester.pumpWidget(
            createTestWidget(
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;

                  results[ScenarioType.threeBodyClassic] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.threeBodyClassic,
                      );
                  results[ScenarioType.collisionDemo] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.collisionDemo,
                      );
                  results[ScenarioType.deepSpace] =
                      LocalizationUtils.getLocalizedScenarioName(
                        l10n,
                        ScenarioType.deepSpace,
                      );

                  return const SizedBox();
                },
              ),
            ),
          );

          // All special scenarios should return the same special name
          final specialNames = results.values.toSet();
          expect(specialNames.length, equals(1)); // All should be the same
          expect(specialNames.first, isNotEmpty);
        },
      );
    });

    group('getLocalizedHabitabilityStatus', () {
      testWidgets('should return correct status for all habitability values', (
        WidgetTester tester,
      ) async {
        final Map<HabitabilityStatus, String> results = {};

        await tester.pumpWidget(
          createTestWidget(
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;

                for (final status in HabitabilityStatus.values) {
                  results[status] =
                      LocalizationUtils.getLocalizedHabitabilityStatus(
                        l10n,
                        status,
                      );
                }

                return const SizedBox();
              },
            ),
          ),
        );

        // All results should be non-empty strings
        for (final result in results.values) {
          expect(result, isNotEmpty);
        }
      });
    });
  });
}
