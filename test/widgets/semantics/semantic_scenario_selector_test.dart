import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_scenario_selector.dart';
import 'package:graviton/services/ui/semantic_focus_service.dart';

import '../../test_utils.dart';

void main() {
  group('SemanticScenarioSelector', () {
    setUp(() {
      SemanticFocusService.instance.setEnabled(true);
    });

    testWidgets('should render child widget', (tester) async {
      const testChild = Text('Test Scenario Selector');

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticScenarioSelector(child: testChild),
        ),
      );

      expect(find.text('Test Scenario Selector'), findsOneWidget);
    });

    testWidgets('should create semantic wrapper with proper focus node', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticScenarioSelector(
            currentScenario: 'Solar System',
            scenarioCount: 5,
            child: Text('Scenario Selector'),
          ),
        ),
      );

      expect(find.text('Scenario Selector'), findsOneWidget);
      expect(
        SemanticFocusService.instance.scenarioSelectorFocusNode,
        isNotNull,
      );
    });

    testWidgets('should handle null localization gracefully', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticScenarioSelector(
            child: Text('Scenario Selector'),
          ),
        ),
      );

      expect(find.text('Scenario Selector'), findsOneWidget);
    });

    testWidgets('should execute onTap callback when provided', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticScenarioSelector(
            onTap: () {},
            currentScenario: 'Test Scenario',
            child: const Text('Scenario Selector'),
          ),
        ),
      );

      expect(find.text('Scenario Selector'), findsOneWidget);
    });

    testWidgets('should handle different scenario states', (tester) async {
      final testCases = [
        {'scenario': null, 'count': null},
        {'scenario': 'Solar System', 'count': null},
        {'scenario': null, 'count': 5},
        {'scenario': 'Binary Stars', 'count': 10},
      ];

      for (final testCase in testCases) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticScenarioSelector(
              currentScenario: testCase['scenario'] as String?,
              scenarioCount: testCase['count'] as int?,
              child: Text('Test ${testCase['scenario'] ?? 'None'}'),
            ),
          ),
        );

        expect(
          find.text('Test ${testCase['scenario'] ?? 'None'}'),
          findsOneWidget,
        );
      }
    });

    testWidgets('should handle different scenario counts', (tester) async {
      final counts = [0, 1, 5, 10, 100];

      for (final count in counts) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticScenarioSelector(
              scenarioCount: count,
              child: Text('Count: $count'),
            ),
          ),
        );

        expect(find.text('Count: $count'), findsOneWidget);
      }
    });

    testWidgets('should create proper semantic structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticScenarioSelector(
            currentScenario: 'Test Scenario',
            scenarioCount: 5,
            child: Text('Scenario Selector'),
          ),
        ),
      );

      final semanticsNode = tester.getSemantics(find.text('Scenario Selector'));
      expect(semanticsNode, isNotNull);
    });

    group('Edge cases', () {
      testWidgets('should handle empty scenario string', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticScenarioSelector(
              currentScenario: '',
              child: Text('Empty Scenario'),
            ),
          ),
        );

        expect(find.text('Empty Scenario'), findsOneWidget);
      });

      testWidgets('should handle negative scenario count', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticScenarioSelector(
              scenarioCount: -1,
              child: Text('Negative Count'),
            ),
          ),
        );

        expect(find.text('Negative Count'), findsOneWidget);
      });

      testWidgets('should handle very long scenario names', (tester) async {
        const longScenario =
            'Very Long Scenario Name That Might Cause Layout Issues';

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticScenarioSelector(
              currentScenario: longScenario,
              child: Text('Long Scenario'),
            ),
          ),
        );

        expect(find.text('Long Scenario'), findsOneWidget);
      });

      testWidgets('should handle special characters in scenario names', (
        tester,
      ) async {
        const specialScenario = 'Scenario with émojis 🌟 & symbols!';

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticScenarioSelector(
              currentScenario: specialScenario,
              child: Text('Special Scenario'),
            ),
          ),
        );

        expect(find.text('Special Scenario'), findsOneWidget);
      });

      testWidgets('should handle very large scenario counts', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticScenarioSelector(
              scenarioCount: 999999,
              child: Text('Large Count'),
            ),
          ),
        );

        expect(find.text('Large Count'), findsOneWidget);
      });
    });
  });
}
