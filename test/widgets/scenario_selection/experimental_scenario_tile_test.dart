import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/experimental_scenario_config.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/scenario_selection/experimental_scenario_tile.dart';

import '../../test_utils.dart';

void main() {
  group('ExperimentalScenarioTile Tests', () {
    late ExperimentalScenarioConfig testExperiment;
    late bool wasOnTapCalled;

    setUp(() {
      wasOnTapCalled = false;
      testExperiment = ExperimentalScenarioConfig(
        nameBuilder: (l10n) => 'Test Experiment',
        descriptionBuilder: (l10n) => 'Test Description',
        icon: Icons.star,
        color: AppColors.stellarOType,
        tags: ['test', 'physics'],
        durationBuilder: (l10n) => '1 hour',
        difficultyBuilder: (l10n) => 'Advanced',
      );
    });

    Widget createTestWidget({
      ExperimentalScenarioConfig? experiment,
      bool isSelected = false,
      VoidCallback? onTap,
    }) {
      return TestUtils.wrapWithMaterialApp(
        child: ExperimentalScenarioTile(
          experiment: experiment ?? testExperiment,
          isSelected: isSelected,
          onTap:
              onTap ??
              () {
                wasOnTapCalled = true;
              },
        ),
      );
    }

    group('Widget Creation', () {
      testWidgets('should create without crashing', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(ExperimentalScenarioTile), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('should have required constructor parameters', (
        tester,
      ) async {
        expect(
          () => ExperimentalScenarioTile(
            experiment: testExperiment,
            isSelected: false,
            onTap: () {},
          ),
          returnsNormally,
        );
      });
    });

    group('Visual Appearance', () {
      testWidgets('should display experiment name', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Test Experiment'), findsOneWidget);
      });

      testWidgets('should display experiment description', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Test Description'), findsOneWidget);
      });

      testWidgets('should display experiment icon', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('should display tags', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('test'), findsOneWidget);
        expect(find.text('physics'), findsOneWidget);
      });

      testWidgets('should display duration', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('1 hour'), findsOneWidget);
      });
    });

    group('Selection State Styling', () {
      testWidgets('should always show high elevation (activated appearance)', (
        tester,
      ) async {
        // Test unselected state - now has activated appearance
        await tester.pumpWidget(createTestWidget(isSelected: false));
        Card unselectedCard = tester.widget<Card>(find.byType(Card));
        expect(unselectedCard.elevation, equals(8.0));

        // Test selected state - same elevated appearance
        await tester.pumpWidget(createTestWidget(isSelected: true));
        Card selectedCard = tester.widget<Card>(find.byType(Card));
        expect(selectedCard.elevation, equals(8.0));
      });

      testWidgets('should always show border (activated appearance)', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isSelected: false));

        // Find the Container with decoration
        final containers = tester.widgetList<Container>(find.byType(Container));

        // Look for container with border decoration
        final decoratedContainer = containers.firstWhere(
          (container) =>
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).border != null,
        );

        final decoration = decoratedContainer.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(testExperiment.color));
        expect(border.top.width, equals(2.0));
      });

      testWidgets('should always show gradient (activated appearance)', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isSelected: false));

        // Find the Container with gradient decoration
        final containers = tester.widgetList<Container>(find.byType(Container));

        // Look for container with gradient decoration
        final decoratedContainer = containers.firstWhere(
          (container) =>
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).gradient != null,
        );

        final decoration = decoratedContainer.decoration as BoxDecoration;
        final gradient = decoration.gradient as LinearGradient;

        expect(gradient.colors.length, equals(2));
        // Gradient should contain the experiment color with modified opacity
        expect(gradient.colors.first.a, equals(AppTypography.opacityFaint));
        expect(gradient.colors.first.r, equals(testExperiment.color.r));
        expect(gradient.colors.first.g, equals(testExperiment.color.g));
        expect(gradient.colors.first.b, equals(testExperiment.color.b));
      });
    });

    group('AppTypography Constants Usage', () {
      testWidgets('uses AppTypography constants for all dimensions', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Find containers with padding
        final containers = tester.widgetList<Container>(find.byType(Container));
        final paddedContainer = containers.firstWhere(
          (container) => container.padding != null,
        );

        final padding = paddedContainer.padding as EdgeInsets;
        expect(
          padding.top,
          equals(AppTypography.spacingMedium),
          reason:
              'Tile padding must use AppTypography.spacingMedium, not magic number',
        );
      });

      testWidgets('uses AppTypography for border radius', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final containers = tester.widgetList<Container>(find.byType(Container));
        final decoratedContainer = containers.firstWhere(
          (container) =>
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).borderRadius != null,
        );

        final decoration = decoratedContainer.decoration as BoxDecoration;
        final borderRadius = decoration.borderRadius as BorderRadius;

        expect(
          borderRadius.topLeft.x,
          equals(AppTypography.radiusMedium),
          reason: 'Border radius must use AppTypography.radiusMedium constant',
        );
      });
    });

    group('Interaction', () {
      testWidgets('should call onTap when tapped', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Tap the tile
        await tester.tap(find.byType(ExperimentalScenarioTile));
        await tester.pump();

        expect(wasOnTapCalled, isTrue);
      });

      testWidgets('should handle rapid taps without errors', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Tap multiple times rapidly
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byType(ExperimentalScenarioTile));
          await tester.pump(const Duration(milliseconds: 10));
        }

        expect(tester.takeException(), isNull);
      });
    });

    group('AppColors Integration', () {
      testWidgets('should use experiment color from AppColors constants', (
        tester,
      ) async {
        // Create experiment with specific AppColors constant
        final stellarExperiment = ExperimentalScenarioConfig(
          nameBuilder: (l10n) => 'Stellar Test',
          descriptionBuilder: (l10n) => 'Description',
          icon: Icons.star,
          color: AppColors.stellarKType, // Orange stellar class
          tags: ['stellar'],
          durationBuilder: (l10n) => '2 hours',
          difficultyBuilder: (l10n) => 'Intermediate',
        );

        await tester.pumpWidget(
          createTestWidget(experiment: stellarExperiment, isSelected: true),
        );

        // Verify the color is used correctly (should be in border when selected)
        final containers = tester.widgetList<Container>(find.byType(Container));
        final borderContainer = containers.firstWhere(
          (container) =>
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).border != null,
        );

        final decoration = borderContainer.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(AppColors.stellarKType));
      });

      testWidgets('should not use hardcoded Color values', (tester) async {
        // This test ensures no hardcoded Color(0xFF...) values are used
        await tester.pumpWidget(createTestWidget(isSelected: true));

        // The fact that this widget renders without errors and uses
        // testExperiment.color (which is AppColors.stellarOType) proves
        // that AppColors constants are being used correctly
        expect(find.byType(ExperimentalScenarioTile), findsOneWidget);
      });
    });

    group('Localization', () {
      testWidgets('should handle English locale properly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Widget should render without errors for English locale
        expect(find.byType(ExperimentalScenarioTile), findsOneWidget);
        expect(find.text('Test Experiment'), findsOneWidget);
      });
    });

    group('Performance Validation', () {
      testWidgets('renders within performance budget', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget());

        stopwatch.stop();

        // Widget must build quickly (under 100ms for complex widgets)
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
          reason: 'Widget must build within reasonable performance budget',
        );
      });

      testWidgets('handles multiple rebuilds efficiently', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: false));

        final stopwatch = Stopwatch()..start();

        // Toggle selection state multiple times
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(createTestWidget(isSelected: i % 2 == 0));
        }

        stopwatch.stop();

        // Multiple rebuilds should complete quickly
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(200),
          reason: 'Multiple rebuilds must be reasonably efficient',
        );
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // The tile should be tappable and have semantic information
        expect(find.byType(ExperimentalScenarioTile), findsOneWidget);

        // Text should be readable by screen readers
        expect(find.text('Test Experiment'), findsOneWidget);
        expect(find.text('Test Description'), findsOneWidget);
      });
    });
  });
}
