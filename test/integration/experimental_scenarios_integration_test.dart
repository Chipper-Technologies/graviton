import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/experimental_scenario_config.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../test_utils.dart';

/// Integration tests for all experimental scenarios
///
/// This test suite verifies that all experimental scenarios:
/// - Use AppColors constants (zero tolerance for hardcoded Color values)
/// - Have proper localization in all supported languages
/// - Are properly configured with required properties
/// - Follow Graviton's cosmic theme standards
void main() {
  group('Experimental Scenarios Integration Tests', () {
    group('Critical AppColors Compliance', () {
      test(
        'all experiments must use AppColors constants, not hardcoded values',
        () {
          final experiments = ExperimentalScenarioConfig.experiments;

          // Define all valid AppColors that should be used for experiments
          final validExperimentColors = [
            AppColors.stellarOType, // Blue for high-energy phenomena
            AppColors.stellarBType, // Blue-white for hot stars
            AppColors.stellarAType, // White for main sequence
            AppColors.stellarFType, // Yellow-white for solar-like
            AppColors.stellarGType, // Yellow for sun-like stars
            AppColors.stellarKType, // Orange for cooler stars
            AppColors.stellarMType, // Red for dwarfs
            AppColors.habitabilityHabitable, // Green for stable systems
            AppColors.starMediumSlateBlue, // Purple for cosmic phenomena
            AppColors.iceGiantUranusLike, // Cyan for icy bodies
            // Add other thematically appropriate AppColors
          ];

          for (int i = 0; i < experiments.length; i++) {
            final experiment = experiments[i];

            expect(
              validExperimentColors.contains(experiment.color),
              isTrue,
              reason:
                  'Experiment $i "${experiment.nameBuilder}" uses color '
                  '${experiment.color} which is not a valid AppColors constant. '
                  'ALL colors must use AppColors constants, never hardcoded Color(0xFF...) values.',
            );
          }
        },
      );

      test('should have exactly 6 experimental scenarios', () {
        final experiments = ExperimentalScenarioConfig.experiments;

        expect(
          experiments.length,
          equals(6),
          reason: 'Expected 6 experimental scenarios to be configured',
        );
      });
    });

    group('Comprehensive Localization Validation', () {
      testWidgets('all experiments must have non-empty localized content', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final experiments = ExperimentalScenarioConfig.experiments;

                for (int i = 0; i < experiments.length; i++) {
                  final experiment = experiments[i];

                  // Verify all localized strings are non-empty
                  final name = experiment.name(l10n);
                  final description = experiment.description(l10n);
                  final duration = experiment.duration(l10n);
                  final difficulty = experiment.difficulty(l10n);

                  expect(
                    name,
                    isNotEmpty,
                    reason:
                        'Experiment $i name must be non-empty in localization',
                  );
                  expect(
                    description,
                    isNotEmpty,
                    reason:
                        'Experiment $i description must be non-empty in localization',
                  );
                  expect(
                    duration,
                    isNotEmpty,
                    reason:
                        'Experiment $i duration must be non-empty in localization',
                  );
                  expect(
                    difficulty,
                    isNotEmpty,
                    reason:
                        'Experiment $i difficulty must be non-empty in localization',
                  );

                  // Verify tags are present and non-empty
                  expect(
                    experiment.tags,
                    isNotEmpty,
                    reason: 'Experiment $i must have at least one tag',
                  );

                  // Verify icon is set
                  expect(
                    experiment.icon,
                    isA<IconData>(),
                    reason: 'Experiment $i must have a valid icon',
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });

    group('Specific Experiment Validation', () {
      testWidgets('Binary Pulsar experiment configuration', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final binaryPulsar = ExperimentalScenarioConfig.experiments[0];

                expect(binaryPulsar.color, equals(AppColors.stellarOType));
                expect(binaryPulsar.icon, equals(Icons.blur_on));
                expect(binaryPulsar.tags, contains('neutron stars'));
                expect(binaryPulsar.tags, contains('relativity'));
                expect(binaryPulsar.tags, contains('waves'));
                expect(binaryPulsar.name(l10n), isNotEmpty);

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Trojan Asteroids experiment configuration', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final trojanAsteroids =
                    ExperimentalScenarioConfig.experiments[1];

                expect(
                  trojanAsteroids.color,
                  equals(AppColors.habitabilityHabitable),
                );
                expect(trojanAsteroids.icon, equals(Icons.scatter_plot));
                expect(trojanAsteroids.tags, contains('asteroids'));
                expect(trojanAsteroids.tags, contains('lagrange'));
                expect(trojanAsteroids.tags, contains('stability'));
                expect(trojanAsteroids.name(l10n), isNotEmpty);

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Galactic Dance experiment configuration', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final galacticDance = ExperimentalScenarioConfig.experiments[2];

                expect(
                  galacticDance.color,
                  equals(AppColors.starMediumSlateBlue),
                );
                expect(galacticDance.icon, equals(Icons.blur_circular));
                expect(galacticDance.tags, contains('galaxies'));
                expect(galacticDance.tags, contains('collision'));
                expect(galacticDance.tags, contains('evolution'));
                expect(galacticDance.name(l10n), isNotEmpty);

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Ring Formation experiment configuration', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final ringFormation = ExperimentalScenarioConfig.experiments[3];

                expect(ringFormation.color, equals(AppColors.stellarKType));
                expect(ringFormation.icon, equals(Icons.panorama_fish_eye));
                expect(ringFormation.tags, contains('rings'));
                expect(ringFormation.tags, contains('tidal forces'));
                expect(ringFormation.tags, contains('disruption'));
                expect(ringFormation.name(l10n), isNotEmpty);

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Comet Trajectory experiment configuration', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final cometTrajectory =
                    ExperimentalScenarioConfig.experiments[4];

                expect(
                  cometTrajectory.color,
                  equals(AppColors.iceGiantUranusLike),
                );
                expect(cometTrajectory.icon, equals(Icons.timeline));
                expect(cometTrajectory.tags, contains('comet'));
                expect(cometTrajectory.tags, contains('ellipse'));
                expect(cometTrajectory.tags, contains('conservation'));
                expect(cometTrajectory.name(l10n), isNotEmpty);

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Stellar Nursery experiment configuration', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final stellarNursery =
                    ExperimentalScenarioConfig.experiments[5];

                expect(stellarNursery.color, equals(AppColors.stellarMType));
                expect(stellarNursery.icon, equals(Icons.star_border));
                expect(stellarNursery.tags, contains('formation'));
                expect(stellarNursery.tags, contains('gas'));
                expect(stellarNursery.tags, contains('collapse'));
                expect(stellarNursery.name(l10n), isNotEmpty);

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });

    group('Cosmic Theme Consistency', () {
      test('experiment colors should follow stellar classification theme', () {
        final experiments = ExperimentalScenarioConfig.experiments;

        // Map experiments to their expected theme categories
        final Map<int, String> experimentThemes = {
          0: 'high-energy stellar phenomena (neutron stars)',
          1: 'stable orbital mechanics (green for stability)',
          2: 'cosmic/galactic phenomena (purple)',
          3: 'dynamic stellar processes (orange)',
          4: 'icy body interactions (cyan)',
          5: 'stellar formation (red-orange)',
        };

        final Map<int, Color> expectedColors = {
          0: AppColors.stellarOType, // Blue for neutron stars
          1: AppColors.habitabilityHabitable, // Green for stability
          2: AppColors.starMediumSlateBlue, // Purple for cosmic
          3: AppColors.stellarKType, // Orange for dynamics
          4: AppColors.iceGiantUranusLike, // Cyan for ice
          5: AppColors.stellarMType, // Red-orange for formation
        };

        for (int i = 0; i < experiments.length; i++) {
          final experiment = experiments[i];
          final expectedColor = expectedColors[i]!;
          final theme = experimentThemes[i]!;

          expect(
            experiment.color,
            equals(expectedColor),
            reason: 'Experiment $i should use $expectedColor for $theme theme',
          );
        }
      });

      test('no duplicate colors across experiments', () {
        final experiments = ExperimentalScenarioConfig.experiments;
        final Set<Color> usedColors = {};

        for (int i = 0; i < experiments.length; i++) {
          final color = experiments[i].color;

          expect(
            usedColors.contains(color),
            isFalse,
            reason:
                'Experiment $i color $color is duplicated. Each experiment should have a unique color.',
          );

          usedColors.add(color);
        }
      });
    });

    group('Educational Content Quality', () {
      testWidgets('all experiments should have educational physics tags', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final experiments = ExperimentalScenarioConfig.experiments;

                // Define expected physics concepts that should appear in tags
                final Set<String> validPhysicsConcepts = {
                  'neutron stars', 'relativity', 'waves', // Binary Pulsar
                  'asteroids', 'lagrange', 'stability', // Trojan Asteroids
                  'galaxies', 'collision', 'evolution', // Galactic Dance
                  'rings', 'tidal forces', 'disruption', // Ring Formation
                  'comet', 'ellipse', 'conservation', // Comet Trajectory
                  'formation', 'gas', 'collapse', // Stellar Nursery
                };

                for (int i = 0; i < experiments.length; i++) {
                  final experiment = experiments[i];

                  expect(
                    experiment.tags.length,
                    greaterThanOrEqualTo(2),
                    reason:
                        'Experiment $i should have at least 2 physics concept tags',
                  );

                  // Verify at least one tag is a recognized physics concept
                  final hasValidPhysicsConcept = experiment.tags.any(
                    (tag) => validPhysicsConcepts.contains(tag),
                  );

                  expect(
                    hasValidPhysicsConcept,
                    isTrue,
                    reason:
                        'Experiment $i tags ${experiment.tags} should contain recognized physics concepts',
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });

    group('Performance and Memory', () {
      test('experiments list should be created efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Access experiments multiple times to test caching
        for (int i = 0; i < 100; i++) {
          final experiments = ExperimentalScenarioConfig.experiments;
          expect(experiments.length, equals(6));
        }

        stopwatch.stop();

        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(10),
          reason: 'Experiments list access should be very fast (likely cached)',
        );
      });
    });
  });
}
