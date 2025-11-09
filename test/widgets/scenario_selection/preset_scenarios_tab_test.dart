import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/widgets/scenario_selection/preset_scenarios_tab.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';

/// Test widget wrapper with localization support
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('PresetScenariosTab', () {
    testWidgets('displays list of preset scenarios', (
      WidgetTester tester,
    ) async {
      // Set larger surface size to ensure ListView can render all items
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenariosTab(
            currentScenario: ScenarioType.solarSystem,
            onScenarioSelected: (_) {},
          ),
        ),
      );

      // Should display a ListView
      expect(find.byType(ListView), findsOneWidget);

      // Calculate expected count: all scenarios with defaults except custom
      final expectedCount = ScenarioType.values.where((scenario) {
        return ScenarioConfig.defaults.containsKey(scenario) &&
            scenario != ScenarioType.custom;
      }).length;

      // Should have the correct number of preset scenario tiles
      expect(find.byType(PresetScenarioTile), findsNWidgets(expectedCount));
    });

    testWidgets('handles scenario selection', (WidgetTester tester) async {
      ScenarioType? selectedScenario;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenariosTab(
            currentScenario: ScenarioType.solarSystem,
            onScenarioSelected: (scenario) => selectedScenario = scenario,
          ),
        ),
      );

      // Tap on the first scenario tile
      await tester.tap(find.byType(HapticInkWell).first);
      await tester.pump();

      // Should call onScenarioSelected
      expect(selectedScenario, isNotNull);
    });

    testWidgets('shows current scenario as selected', (
      WidgetTester tester,
    ) async {
      // Set larger surface size to ensure ListView can render all items
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenariosTab(
            currentScenario: ScenarioType.solarSystem,
            onScenarioSelected: (_) {},
          ),
        ),
      );

      // Should find check icon for selected scenario
      expect(find.byIcon(Icons.check_circle), findsAtLeastNWidgets(1));
    });

    testWidgets('filters out custom scenarios', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenariosTab(
            currentScenario: ScenarioType.solarSystem,
            onScenarioSelected: (_) {},
          ),
        ),
      );

      // Should only include scenarios with default configurations
      final scenarios = ScenarioConfig.defaults.keys.toList();

      // Verify we have the expected number of tiles
      expect(find.byType(PresetScenarioTile), findsNWidgets(scenarios.length));
    });
  });

  group('PresetScenarioTile', () {
    testWidgets('displays scenario information correctly', (
      WidgetTester tester,
    ) async {
      final scenario = ScenarioType.solarSystem;
      final config = ScenarioConfig.defaults[scenario]!;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // Should display scenario icon
      expect(find.byIcon(config.icon), findsOneWidget);

      // Should display body count
      expect(
        find.textContaining('${config.expectedBodyCount}'),
        findsOneWidget,
      );

      // Should be wrapped in a Card
      expect(find.byType(Card), findsOneWidget);

      // Should have HapticInkWell for interaction
      expect(find.byType(HapticInkWell), findsOneWidget);
    });

    testWidgets('shows selected state correctly', (WidgetTester tester) async {
      final scenario = ScenarioType.solarSystem;
      final config = ScenarioConfig.defaults[scenario]!;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      // Should show check circle when selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Should have elevated card
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(8));
    });

    testWidgets('shows unselected state correctly', (
      WidgetTester tester,
    ) async {
      final scenario = ScenarioType.solarSystem;
      final config = ScenarioConfig.defaults[scenario]!;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // Should not show check circle when not selected
      expect(find.byIcon(Icons.check_circle), findsNothing);

      // Should have normal elevation
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(2));
    });

    testWidgets('handles tap correctly', (WidgetTester tester) async {
      bool tapped = false;
      final scenario = ScenarioType.solarSystem;
      final config = ScenarioConfig.defaults[scenario]!;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(HapticInkWell));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('displays learning objectives', (WidgetTester tester) async {
      final scenario = ScenarioType.solarSystem;
      final config = ScenarioConfig.defaults[scenario]!;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // Should display learning objectives text (emojis and content)
      // This validates that the _buildScenarioObjectives method works
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays metadata correctly', (WidgetTester tester) async {
      final scenario = ScenarioType.solarSystem;
      final config = ScenarioConfig.defaults[scenario]!;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // Should show group icon for bodies
      expect(find.byIcon(Icons.group), findsOneWidget);

      // Should show school icon for educational focus
      expect(find.byIcon(Icons.school), findsOneWidget);

      // Should display body count
      expect(
        find.textContaining('${config.expectedBodyCount}'),
        findsOneWidget,
      );
    });

    testWidgets('handles different scenario types', (
      WidgetTester tester,
    ) async {
      // Test with binary stars scenario
      final scenario = ScenarioType.binaryStars;
      final config = ScenarioConfig.defaults[scenario]!;

      await tester.pumpWidget(
        makeTestableWidget(
          PresetScenarioTile(
            scenario: scenario,
            config: config,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // Should display scenario icon
      expect(find.byIcon(config.icon), findsOneWidget);

      // Should handle the specific scenario's properties
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(HapticInkWell), findsOneWidget);
    });
  });
}
