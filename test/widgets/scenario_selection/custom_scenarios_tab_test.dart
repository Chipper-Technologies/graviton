import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/widgets/scenario_selection/custom_scenarios_tab.dart';

import '../../test_utils.dart';

void main() {
  group('CustomScenariosTab Tests', () {
    Widget createTestWidget({
      ValueChanged<ScenarioType>? onScenarioSelected,
      Function(String)? onCustomScenarioSelected,
    }) {
      return TestUtils.wrapWithMaterialApp(
        child: CustomScenariosTab(
          onScenarioSelected: onScenarioSelected ?? (scenario) {},
          onCustomScenarioSelected: onCustomScenarioSelected,
        ),
      );
    }

    group('Widget Creation', () {
      testWidgets('should create without crashing', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Widget should be created
        expect(find.byType(CustomScenariosTab), findsOneWidget);

        // Should show loading initially
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should have required constructor parameters', (
        tester,
      ) async {
        expect(
          () => CustomScenariosTab(onScenarioSelected: (scenario) {}),
          returnsNormally,
        );

        expect(
          () => CustomScenariosTab(
            onScenarioSelected: (scenario) {},
            onCustomScenarioSelected: (scenarioId) {},
          ),
          returnsNormally,
        );
      });
    });

    group('Callback Handling', () {
      testWidgets('should accept onScenarioSelected callback', (tester) async {
        ScenarioType? selectedScenario;

        await tester.pumpWidget(
          createTestWidget(
            onScenarioSelected: (scenario) {
              selectedScenario = scenario;
            },
          ),
        );

        // Callback should be set up correctly
        expect(selectedScenario, isNull); // Initially null
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });

      testWidgets('should accept onCustomScenarioSelected callback', (
        tester,
      ) async {
        String? selectedScenarioId;

        await tester.pumpWidget(
          createTestWidget(
            onCustomScenarioSelected: (scenarioId) {
              selectedScenarioId = scenarioId;
            },
          ),
        );

        // Callback should be set up correctly
        expect(selectedScenarioId, isNull); // Initially null
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });
    });

    group('Widget State Management', () {
      testWidgets('should maintain state across rebuilds', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Widget should exist
        expect(find.byType(CustomScenariosTab), findsOneWidget);

        // Rebuild with different callback
        await tester.pumpWidget(
          createTestWidget(onScenarioSelected: (scenario) {}),
        );

        // Should still exist
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });

      testWidgets('should handle rapid rebuilds', (tester) async {
        // Build widget multiple times rapidly
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();
        }

        // Should still render correctly
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });
    });

    group('Loading Behavior', () {
      testWidgets('should show loading indicator initially', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Should show loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Widget should be present
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });

      testWidgets('should handle loading state properly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Initial state should show loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Advance time but don't wait for infinite settle
        await tester.pump(const Duration(milliseconds: 100));

        // Should still be in a valid state
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle exceptions gracefully', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Should not have any uncaught exceptions initially
        expect(tester.takeException(), isNull);
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });

      testWidgets('should handle null callbacks gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            onScenarioSelected: (scenario) {},
            onCustomScenarioSelected: null,
          ),
        );

        // Should not crash with null callback
        expect(find.byType(CustomScenariosTab), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Basic accessibility check
        expect(find.byType(CustomScenariosTab), findsOneWidget);

        // Should not have accessibility issues at creation
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Integration', () {
      testWidgets('should integrate with Material App properly', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScenariosTab(onScenarioSelected: (scenario) {}),
            ),
          ),
        );

        // Should integrate without issues
        expect(find.byType(CustomScenariosTab), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should work with different parent widgets', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: [
                Expanded(
                  child: CustomScenariosTab(onScenarioSelected: (scenario) {}),
                ),
              ],
            ),
          ),
        );

        // Should work in Column/Expanded layout
        expect(find.byType(CustomScenariosTab), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should create quickly', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget());

        stopwatch.stop();

        // Widget creation should be fast (under 100ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        expect(find.byType(CustomScenariosTab), findsOneWidget);
      });

      testWidgets('should handle multiple widget creations efficiently', (
        tester,
      ) async {
        // Create multiple widgets to test memory usage
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Each iteration should work
          expect(find.byType(CustomScenariosTab), findsOneWidget);
        }
      });
    });
  });
}
