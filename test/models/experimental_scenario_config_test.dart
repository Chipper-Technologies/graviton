import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/experimental_scenario_config.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';

import '../test_utils.dart';

void main() {
  group('ExperimentalScenarioConfig Tests', () {
    group('Constructor and Properties', () {
      test('should create with all required properties', () {
        final config = ExperimentalScenarioConfig(
          nameBuilder: (l10n) => 'Test Name',
          descriptionBuilder: (l10n) => 'Test Description',
          icon: Icons.star,
          color: AppColors.stellarOType,
          tags: ['test', 'physics'],
          durationBuilder: (l10n) => '1 hour',
          difficultyBuilder: (l10n) => 'Advanced',
        );

        expect(config.icon, equals(Icons.star));
        expect(config.color, equals(AppColors.stellarOType));
        expect(config.tags, equals(['test', 'physics']));
      });

      test('should handle empty tags list', () {
        final config = ExperimentalScenarioConfig(
          nameBuilder: (l10n) => 'Test Name',
          descriptionBuilder: (l10n) => 'Test Description',
          icon: Icons.star,
          color: AppColors.stellarOType,
          tags: [],
          durationBuilder: (l10n) => '1 hour',
          difficultyBuilder: (l10n) => 'Advanced',
        );

        expect(config.tags, isEmpty);
      });
    });

    group('Localization Methods', () {
      testWidgets('name() should return localized name', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final config = ExperimentalScenarioConfig(
                  nameBuilder: (l10n) => 'Localized Name',
                  descriptionBuilder: (l10n) => 'Description',
                  icon: Icons.star,
                  color: AppColors.stellarOType,
                  tags: ['test'],
                  durationBuilder: (l10n) => '1 hour',
                  difficultyBuilder: (l10n) => 'Advanced',
                );

                expect(config.name(l10n), equals('Localized Name'));
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('description() should return localized description', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final config = ExperimentalScenarioConfig(
                  nameBuilder: (l10n) => 'Name',
                  descriptionBuilder: (l10n) => 'Localized Description',
                  icon: Icons.star,
                  color: AppColors.stellarOType,
                  tags: ['test'],
                  durationBuilder: (l10n) => '1 hour',
                  difficultyBuilder: (l10n) => 'Advanced',
                );

                expect(
                  config.description(l10n),
                  equals('Localized Description'),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('duration() should return localized duration', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final config = ExperimentalScenarioConfig(
                  nameBuilder: (l10n) => 'Name',
                  descriptionBuilder: (l10n) => 'Description',
                  icon: Icons.star,
                  color: AppColors.stellarOType,
                  tags: ['test'],
                  durationBuilder: (l10n) => 'Localized Duration',
                  difficultyBuilder: (l10n) => 'Advanced',
                );

                expect(config.duration(l10n), equals('Localized Duration'));
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('difficulty() should return localized difficulty', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final config = ExperimentalScenarioConfig(
                  nameBuilder: (l10n) => 'Name',
                  descriptionBuilder: (l10n) => 'Description',
                  icon: Icons.star,
                  color: AppColors.stellarOType,
                  tags: ['test'],
                  durationBuilder: (l10n) => '1 hour',
                  difficultyBuilder: (l10n) => 'Localized Difficulty',
                );

                expect(config.difficulty(l10n), equals('Localized Difficulty'));
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });

    group('All Experimental Scenarios', () {
      testWidgets('should have all predefined experiments', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final experiments = ExperimentalScenarioConfig.experiments;

                // Verify we have 6 experiments
                expect(experiments.length, equals(6));

                // Verify each experiment has required properties
                for (final experiment in experiments) {
                  expect(experiment.name(l10n), isNotEmpty);
                  expect(experiment.description(l10n), isNotEmpty);
                  expect(experiment.duration(l10n), isNotEmpty);
                  expect(experiment.difficulty(l10n), isNotEmpty);
                  expect(experiment.tags, isNotEmpty);
                  expect(experiment.color, isA<Color>());
                  expect(experiment.icon, isA<IconData>());
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Binary Pulsar experiment should use correct AppColors', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final binaryPulsar = ExperimentalScenarioConfig.experiments[0];

                expect(binaryPulsar.color, equals(AppColors.stellarOType));
                expect(
                  binaryPulsar.name(l10n),
                  equals(l10n.experimentBinaryPulsarName),
                );
                expect(binaryPulsar.icon, equals(Icons.blur_on));

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Trojan Asteroids experiment should use correct AppColors', (
        tester,
      ) async {
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
                expect(
                  trojanAsteroids.name(l10n),
                  equals(l10n.experimentTrojanAsteroidsName),
                );
                expect(trojanAsteroids.icon, equals(Icons.scatter_plot));

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Galactic Dance experiment should use correct AppColors', (
        tester,
      ) async {
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
                expect(
                  galacticDance.name(l10n),
                  equals(l10n.experimentGalacticDanceName),
                );
                expect(galacticDance.icon, equals(Icons.blur_circular));

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Ring Formation experiment should use correct AppColors', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final ringFormation = ExperimentalScenarioConfig.experiments[3];

                expect(ringFormation.color, equals(AppColors.stellarKType));
                expect(
                  ringFormation.name(l10n),
                  equals(l10n.experimentRingFormationName),
                );
                expect(ringFormation.icon, equals(Icons.panorama_fish_eye));

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Comet Trajectory experiment should use correct AppColors', (
        tester,
      ) async {
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
                expect(
                  cometTrajectory.name(l10n),
                  equals(l10n.experimentCometTrajectoryName),
                );
                expect(cometTrajectory.icon, equals(Icons.timeline));

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('Stellar Nursery experiment should use correct AppColors', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final stellarNursery =
                    ExperimentalScenarioConfig.experiments[5];

                expect(stellarNursery.color, equals(AppColors.stellarMType));
                expect(
                  stellarNursery.name(l10n),
                  equals(l10n.experimentStellarNurseryName),
                );
                expect(stellarNursery.icon, equals(Icons.star_border));

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });

    group('No Magic Numbers Validation', () {
      test('should use AppColors constants, not hardcoded Color values', () {
        final experiments = ExperimentalScenarioConfig.experiments;

        // Verify all colors come from AppColors constants
        final validColors = [
          AppColors.stellarOType,
          AppColors.habitabilityHabitable,
          AppColors.starMediumSlateBlue,
          AppColors.stellarKType,
          AppColors.iceGiantUranusLike,
          AppColors.stellarMType,
        ];

        for (final experiment in experiments) {
          expect(
            validColors.contains(experiment.color),
            isTrue,
            reason:
                'Experiment color must use AppColors constants, not hardcoded values',
          );
        }
      });
    });

    group('Localization Integration', () {
      testWidgets('should handle English locale properly', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final experiments = ExperimentalScenarioConfig.experiments;

                // Verify all experiments return non-empty localized strings
                for (final experiment in experiments) {
                  expect(experiment.name(l10n), isNotEmpty);
                  expect(experiment.description(l10n), isNotEmpty);
                  expect(experiment.duration(l10n), isNotEmpty);
                  expect(experiment.difficulty(l10n), isNotEmpty);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });
  });
}
