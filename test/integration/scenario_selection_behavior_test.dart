import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/scenario_selection/custom_scenario_tile.dart';

import '../test_utils.dart';

void main() {
  group('Scenario Selection Behavior Tests', () {
    testWidgets('custom scenario tile supports tap and edit callbacks', (
      WidgetTester tester,
    ) async {
      bool mainTapped = false;
      bool editTapped = false;
      bool deleteTapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: CustomScenarioTile(
            scenarioName: 'Test Scenario',
            isSelected: false,
            onTap: () {
              mainTapped = true;
            },
            onView: () {},
            onExport: () {},
            onEdit: () {
              editTapped = true;
            },
            onDelete: () {
              deleteTapped = true;
            },
          ),
        ),
      );

      // Verify the tile rendered
      expect(find.byType(CustomScenarioTile), findsOneWidget);
      expect(find.text('Test Scenario'), findsOneWidget);

      // Test main tile tap
      await tester.tap(find.byType(CustomScenarioTile));
      await tester.pump();

      expect(mainTapped, isTrue);
      expect(editTapped, isFalse);
      expect(deleteTapped, isFalse);

      // Reset
      mainTapped = false;

      // Test edit button tap - first tap 3-dot menu, then edit option
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pump();

      expect(mainTapped, isFalse);
      expect(editTapped, isTrue);
      expect(deleteTapped, isFalse);
    });

    testWidgets('scenario callbacks can be configured independently', (
      WidgetTester tester,
    ) async {
      // Test with different callback configurations
      bool callback1Called = false;
      bool callback2Called = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Column(
            children: [
              CustomScenarioTile(
                scenarioName: 'Scenario 1',
                isSelected: false,
                onTap: () {
                  callback1Called = true;
                },
                onView: () {},
                onExport: () {},
                onEdit: () {},
                onDelete: () {},
              ),
              CustomScenarioTile(
                scenarioName: 'Scenario 2',
                isSelected: false,
                onTap: () {
                  callback2Called = true;
                },
                onView: () {},
                onExport: () {},
                onEdit: () {},
                onDelete: () {},
              ),
            ],
          ),
        ),
      );

      // Tap first tile
      await tester.tap(find.text('Scenario 1'));
      await tester.pump();

      expect(callback1Called, isTrue);
      expect(callback2Called, isFalse);

      // Reset and tap second tile
      callback1Called = false;
      await tester.tap(find.text('Scenario 2'));
      await tester.pump();

      expect(callback1Called, isFalse);
      expect(callback2Called, isTrue);
    });

    testWidgets('behavior change preserves edit functionality', (
      WidgetTester tester,
    ) async {
      // Verify that the updated behavior still allows edit operations
      int tapCount = 0;
      int editCount = 0;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: CustomScenarioTile(
            scenarioName: 'Editable Scenario',
            isSelected: false,
            onTap: () {
              tapCount++;
            },
            onView: () {},
            onExport: () {},
            onEdit: () {
              editCount++;
            },
            onDelete: () {},
          ),
        ),
      );

      // Multiple taps should work
      await tester.tap(find.byType(CustomScenarioTile));
      await tester.pump();
      await tester.tap(find.byType(CustomScenarioTile));
      await tester.pump();

      expect(tapCount, equals(2));
      expect(editCount, equals(0));

      // Edit button should work independently - first tap 3-dot menu, then edit option
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pump();

      expect(tapCount, equals(2)); // Unchanged
      expect(editCount, equals(1)); // Incremented
    });
  });
}
