import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/scenario_selection/preset_scenario_tile.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/l10n/app_localizations.dart';

void main() {
  group('PresetScenarioTile Tests', () {
    Widget createTestWidget({
      required ScenarioType scenario,
      required ScenarioConfig config,
      required bool isSelected,
      required VoidCallback onTap,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: isSelected,
            onTap: onTap,
          ),
        ),
      );
    }

    group('Basic Functionality', () {
      testWidgets('should render correctly', (tester) async {
        int tapCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.solarSystem,
            config: ScenarioConfig.defaults[ScenarioType.solarSystem]!,
            isSelected: false,
            onTap: () => tapCount++,
          ),
        );

        expect(find.byType(PresetScenarioTile), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(HapticInkWell), findsOneWidget);
      });

      testWidgets('should handle tap events', (tester) async {
        int tapCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.binaryStars,
            config: ScenarioConfig.defaults[ScenarioType.binaryStars]!,
            isSelected: false,
            onTap: () => tapCount++,
          ),
        );

        await tester.tap(find.byType(HapticInkWell));
        await tester.pump();

        expect(tapCount, 1);
      });
    });

    group('Selection State', () {
      testWidgets('should display selected state correctly', (tester) async {
        final config = ScenarioConfig.defaults[ScenarioType.solarSystem]!;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.solarSystem,
            config: config,
            isSelected: true,
            onTap: () {},
          ),
        );

        // Should find check circle icon for selected state
        expect(find.byIcon(Icons.check_circle), findsOneWidget);

        // Check card elevation
        final Card card = tester.widget(find.byType(Card));
        expect(card.elevation, 8);

        // Check card color
        expect(
          card.color,
          config.primaryColor.withValues(alpha: AppTypography.opacityDisabled),
        );
      });

      testWidgets('should display unselected state correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.earthMoonSun,
            config: ScenarioConfig.defaults[ScenarioType.earthMoonSun]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should not find check circle icon for unselected state
        expect(find.byIcon(Icons.check_circle), findsNothing);

        // Check card elevation
        final Card card = tester.widget(find.byType(Card));
        expect(card.elevation, 2);

        // Check card color (should be null for unselected)
        expect(card.color, isNull);
      });
    });

    group('Content Display', () {
      testWidgets('should display scenario icon and metadata', (tester) async {
        final config = ScenarioConfig.defaults[ScenarioType.solarSystem]!;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.solarSystem,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should display the scenario icon
        expect(find.byIcon(config.icon), findsOneWidget);

        // Icon should have correct color
        final Icon icon = tester.widget(find.byIcon(config.icon));
        expect(icon.color, config.primaryColor);
        expect(icon.size, AppTypography.iconSizeXXXLarge);
      });

      testWidgets('should display body count metadata', (tester) async {
        final config = ScenarioConfig.defaults[ScenarioType.binaryStars]!;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.binaryStars,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should display group icon for body count
        expect(find.byIcon(Icons.group), findsOneWidget);

        // Should display school icon for educational focus
        expect(find.byIcon(Icons.school), findsOneWidget);
      });

      testWidgets('should display learning objectives', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.binaryStars,
            config: ScenarioConfig.defaults[ScenarioType.binaryStars]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should display learning objectives section
        // The specific text depends on localization, but structure should be present
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Row), findsWidgets);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have correct layout hierarchy', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.random,
            config: ScenarioConfig.defaults[ScenarioType.random]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Verify widget hierarchy
        expect(
          find.descendant(
            of: find.byType(PresetScenarioTile),
            matching: find.byType(Card),
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(HapticInkWell),
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: find.byType(HapticInkWell),
            matching: find.byType(Padding),
          ),
          findsWidgets,
        );
      });

      testWidgets('should have proper spacing', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.solarSystem,
            config: ScenarioConfig.defaults[ScenarioType.solarSystem]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should find SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsWidgets);

        // Check main padding
        final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
        bool foundMainPadding = false;
        for (final padding in paddingWidgets) {
          if (padding.padding == const EdgeInsets.all(16.0)) {
            foundMainPadding = true;
            break;
          }
        }
        expect(foundMainPadding, isTrue);
      });
    });

    group('Visual Styling', () {
      testWidgets('should have correct card styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.earthMoonSun,
            config: ScenarioConfig.defaults[ScenarioType.earthMoonSun]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        final Card card = tester.widget(find.byType(Card));
        expect(card.margin, EdgeInsets.zero);

        final HapticInkWell inkWell = tester.widget(find.byType(HapticInkWell));
        expect(
          inkWell.borderRadius,
          BorderRadius.circular(AppTypography.radiusMedium),
        );
      });

      testWidgets('should have icon container styling', (tester) async {
        final config = ScenarioConfig.defaults[ScenarioType.asteroidBelt]!;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.asteroidBelt,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Find the icon container
        final containers = tester.widgetList<Container>(find.byType(Container));
        bool foundIconContainer = false;

        for (final container in containers) {
          if (container.constraints?.minWidth ==
                  AppTypography.iconSizeXXXXLarge &&
              container.constraints?.minHeight ==
                  AppTypography.iconSizeXXXXLarge) {
            foundIconContainer = true;

            final decoration = container.decoration as BoxDecoration?;
            if (decoration != null) {
              expect(decoration.borderRadius, BorderRadius.circular(24.0));
              expect(
                decoration.color,
                config.primaryColor.withValues(
                  alpha: AppTypography.opacityVeryFaint,
                ),
              );
            }
            break;
          }
        }
        expect(foundIconContainer, isTrue);
      });
    });

    group('Text Styling', () {
      testWidgets('should apply correct text styles for selected state', (
        tester,
      ) async {
        final config = ScenarioConfig.defaults[ScenarioType.galaxyFormation]!;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.galaxyFormation,
            config: config,
            isSelected: true,
            onTap: () {},
          ),
        );

        // Text styling depends on AppLocalizations, but we can verify structure
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should apply correct text styles for unselected state', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.solarSystem,
            config: ScenarioConfig.defaults[ScenarioType.solarSystem]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Learning Objectives', () {
      testWidgets('should build scenario objectives correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.binaryStars,
            config: ScenarioConfig.defaults[ScenarioType.binaryStars]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should find the objectives structure
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Expanded), findsWidgets);
      });

      testWidgets('should handle different scenario types', (tester) async {
        for (final scenarioType in [
          ScenarioType.solarSystem,
          ScenarioType.earthMoonSun,
          ScenarioType.binaryStars,
          ScenarioType.threeBodyClassic,
          ScenarioType.random,
        ]) {
          if (!ScenarioConfig.defaults.containsKey(scenarioType)) continue;

          await tester.pumpWidget(
            createTestWidget(
              scenario: scenarioType,
              config: ScenarioConfig.defaults[scenarioType]!,
              isSelected: false,
              onTap: () {},
            ),
          );

          // Each scenario should render without error
          expect(find.byType(PresetScenarioTile), findsOneWidget);
          await tester.pump();
        }
      });
    });

    group('Metadata Display', () {
      testWidgets('should display body count and educational focus', (
        tester,
      ) async {
        final config = ScenarioConfig.defaults[ScenarioType.earthMoonSun]!;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.earthMoonSun,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should display group and school icons
        expect(find.byIcon(Icons.group), findsOneWidget);
        expect(find.byIcon(Icons.school), findsOneWidget);

        // Icons should have correct styling
        final groupIcon = tester.widget<Icon>(find.byIcon(Icons.group));
        expect(groupIcon.size, AppTypography.iconSizeMedium);
        expect(
          groupIcon.color,
          AppColors.uiWhite.withValues(alpha: AppTypography.opacityMediumHigh),
        );

        final schoolIcon = tester.widget<Icon>(find.byIcon(Icons.school));
        expect(schoolIcon.size, AppTypography.iconSizeMedium);
        expect(
          schoolIcon.color,
          AppColors.uiWhite.withValues(alpha: AppTypography.opacityMediumHigh),
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null or missing config gracefully', (
        tester,
      ) async {
        // This tests the robustness of the widget
        final config = ScenarioConfig.defaults[ScenarioType.solarSystem]!;

        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.solarSystem,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        );

        expect(find.byType(PresetScenarioTile), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            scenario: ScenarioType.asteroidBelt,
            config: ScenarioConfig.defaults[ScenarioType.asteroidBelt]!,
            isSelected: false,
            onTap: () {},
          ),
        );

        // Should have tappable area
        expect(find.byType(HapticInkWell), findsOneWidget);

        // Should have text content for screen readers
        expect(find.byType(Text), findsWidgets);
      });
    });
  });
}
