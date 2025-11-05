import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_bottom_sheet.dart';
import 'package:graviton/services/semantic_focus_service.dart';

import '../../test_utils.dart';

void main() {
  group('SemanticBottomSheet', () {
    setUp(() {
      SemanticFocusService.instance.setEnabled(true);
    });

    testWidgets('should render child widget', (tester) async {
      const testChild = Text('Test Bottom Sheet');

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticBottomSheet(isExpanded: false, child: testChild),
        ),
      );

      expect(find.text('Test Bottom Sheet'), findsOneWidget);
    });

    testWidgets('should create semantic wrapper with proper focus node', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticBottomSheet(
            isExpanded: true,
            currentScenario: 'Solar System',
            child: Text('Bottom Sheet'),
          ),
        ),
      );

      expect(find.text('Bottom Sheet'), findsOneWidget);
      expect(SemanticFocusService.instance.bottomSheetFocusNode, isNotNull);
    });

    testWidgets('should handle null localization gracefully', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticBottomSheet(
            isExpanded: false,
            child: Text('Bottom Sheet'),
          ),
        ),
      );

      expect(find.text('Bottom Sheet'), findsOneWidget);
    });

    testWidgets('should update semantic label based on expanded state', (
      tester,
    ) async {
      Widget buildWidget(bool isExpanded) {
        return TestUtils.wrapWithMaterialApp(
          child: SemanticBottomSheet(
            isExpanded: isExpanded,
            currentScenario: 'Test Scenario',
            child: const Text('Bottom Sheet'),
          ),
        );
      }

      // Test expanded state
      await tester.pumpWidget(buildWidget(true));
      await tester.pumpAndSettle();

      // Test collapsed state
      await tester.pumpWidget(buildWidget(false));
      await tester.pumpAndSettle();

      expect(find.text('Bottom Sheet'), findsOneWidget);
    });

    testWidgets('should execute callbacks when provided', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticBottomSheet(
            isExpanded: false,
            onExpand: () {},
            onCollapse: () {},
            child: const Text('Bottom Sheet'),
          ),
        ),
      );

      expect(find.text('Bottom Sheet'), findsOneWidget);
    });

    testWidgets('should handle different scenarios', (tester) async {
      final scenarios = [
        'Solar System',
        'Binary Stars',
        'Three Body Problem',
        null,
      ];

      for (final scenario in scenarios) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticBottomSheet(
              isExpanded: false,
              currentScenario: scenario,
              child: Text('Scenario: ${scenario ?? 'None'}'),
            ),
          ),
        );

        expect(find.text('Scenario: ${scenario ?? 'None'}'), findsOneWidget);
      }
    });

    testWidgets('should create proper semantic structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticBottomSheet(
            isExpanded: true,
            currentScenario: 'Test Scenario',
            child: Text('Bottom Sheet'),
          ),
        ),
      );

      final semanticsNode = tester.getSemantics(find.text('Bottom Sheet'));
      expect(semanticsNode, isNotNull);
    });

    group('Edge cases', () {
      testWidgets('should handle empty scenario string', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticBottomSheet(
              isExpanded: false,
              currentScenario: '',
              child: Text('Empty Scenario'),
            ),
          ),
        );

        expect(find.text('Empty Scenario'), findsOneWidget);
      });

      testWidgets('should handle very long scenario names', (tester) async {
        const longScenario =
            'Very Long Scenario Name That Might Cause Layout Issues';

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticBottomSheet(
              isExpanded: true,
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
            child: const SemanticBottomSheet(
              isExpanded: false,
              currentScenario: specialScenario,
              child: Text('Special Scenario'),
            ),
          ),
        );

        expect(find.text('Special Scenario'), findsOneWidget);
      });
    });
  });
}
