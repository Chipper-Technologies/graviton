import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/tutorial_action.dart';

void main() {
  group('TutorialAction', () {
    test('should have all expected enum values', () {
      const expectedValues = [
        TutorialAction.highlightAppBar,
        TutorialAction.highlightBottomControls,
        TutorialAction.highlightScenarioButton,
        TutorialAction.highlightFloatingControls,
      ];

      expect(TutorialAction.values, equals(expectedValues));
      expect(TutorialAction.values.length, equals(4));
    });

    test('should have correct enum value names', () {
      expect(TutorialAction.highlightAppBar.name, equals('highlightAppBar'));
      expect(
        TutorialAction.highlightBottomControls.name,
        equals('highlightBottomControls'),
      );
      expect(
        TutorialAction.highlightScenarioButton.name,
        equals('highlightScenarioButton'),
      );
      expect(
        TutorialAction.highlightFloatingControls.name,
        equals('highlightFloatingControls'),
      );
    });

    test('should maintain consistent enum indices', () {
      expect(TutorialAction.highlightAppBar.index, equals(0));
      expect(TutorialAction.highlightBottomControls.index, equals(1));
      expect(TutorialAction.highlightScenarioButton.index, equals(2));
      expect(TutorialAction.highlightFloatingControls.index, equals(3));
    });

    test('should support equality comparison', () {
      const action1 = TutorialAction.highlightAppBar;
      const action2 = TutorialAction.highlightAppBar;
      const action3 = TutorialAction.highlightBottomControls;

      expect(action1, equals(action2));
      expect(action1, isNot(equals(action3)));
    });

    test('should support switch statements', () {
      String getActionDescription(TutorialAction action) {
        switch (action) {
          case TutorialAction.highlightAppBar:
            return 'App Bar';
          case TutorialAction.highlightBottomControls:
            return 'Bottom Controls';
          case TutorialAction.highlightScenarioButton:
            return 'Scenario Button';
          case TutorialAction.highlightFloatingControls:
            return 'Floating Controls';
        }
      }

      expect(
        getActionDescription(TutorialAction.highlightAppBar),
        equals('App Bar'),
      );
      expect(
        getActionDescription(TutorialAction.highlightBottomControls),
        equals('Bottom Controls'),
      );
      expect(
        getActionDescription(TutorialAction.highlightScenarioButton),
        equals('Scenario Button'),
      );
      expect(
        getActionDescription(TutorialAction.highlightFloatingControls),
        equals('Floating Controls'),
      );
    });

    test('should support toString method', () {
      expect(
        TutorialAction.highlightAppBar.toString(),
        equals('TutorialAction.highlightAppBar'),
      );
      expect(
        TutorialAction.highlightBottomControls.toString(),
        equals('TutorialAction.highlightBottomControls'),
      );
      expect(
        TutorialAction.highlightScenarioButton.toString(),
        equals('TutorialAction.highlightScenarioButton'),
      );
      expect(
        TutorialAction.highlightFloatingControls.toString(),
        equals('TutorialAction.highlightFloatingControls'),
      );
    });

    test('should support collection operations', () {
      final actions = [
        TutorialAction.highlightAppBar,
        TutorialAction.highlightBottomControls,
        TutorialAction.highlightScenarioButton,
      ];

      expect(actions.contains(TutorialAction.highlightAppBar), isTrue);
      expect(
        actions.contains(TutorialAction.highlightFloatingControls),
        isFalse,
      );
      expect(actions.length, equals(3));
    });

    test('should be usable in Set operations', () {
      // Test creating a set with unique values
      final actionSet = {
        TutorialAction.highlightAppBar,
        TutorialAction.highlightBottomControls,
      };

      expect(actionSet.length, equals(2));
      expect(actionSet.contains(TutorialAction.highlightAppBar), isTrue);
      expect(
        actionSet.contains(TutorialAction.highlightBottomControls),
        isTrue,
      );
      expect(
        actionSet.contains(TutorialAction.highlightScenarioButton),
        isFalse,
      );

      // Test that adding duplicate values doesn't increase set size
      final actionSetWithDuplicate = <TutorialAction>{};
      actionSetWithDuplicate.add(TutorialAction.highlightAppBar);
      actionSetWithDuplicate.add(TutorialAction.highlightBottomControls);
      actionSetWithDuplicate.add(TutorialAction.highlightAppBar); // Duplicate

      expect(actionSetWithDuplicate.length, equals(2));
    });

    test('should support Map operations', () {
      final actionDescriptions = {
        TutorialAction.highlightAppBar: 'Highlights the top navigation bar',
        TutorialAction.highlightBottomControls:
            'Highlights the bottom control panel',
        TutorialAction.highlightScenarioButton:
            'Highlights the scenario selection button',
        TutorialAction.highlightFloatingControls:
            'Highlights the floating action controls',
      };

      expect(
        actionDescriptions[TutorialAction.highlightAppBar],
        equals('Highlights the top navigation bar'),
      );
      expect(
        actionDescriptions[TutorialAction.highlightBottomControls],
        equals('Highlights the bottom control panel'),
      );
      expect(
        actionDescriptions[TutorialAction.highlightScenarioButton],
        equals('Highlights the scenario selection button'),
      );
      expect(
        actionDescriptions[TutorialAction.highlightFloatingControls],
        equals('Highlights the floating action controls'),
      );
      expect(actionDescriptions.length, equals(4));
    });

    test('should support iteration', () {
      final actionNames = <String>[];

      for (final action in TutorialAction.values) {
        actionNames.add(action.name);
      }

      expect(
        actionNames,
        equals([
          'highlightAppBar',
          'highlightBottomControls',
          'highlightScenarioButton',
          'highlightFloatingControls',
        ]),
      );
    });

    test('should maintain enum value stability', () {
      // These tests ensure enum values don't change accidentally
      final appBarAction = TutorialAction.values[0];
      final bottomControlsAction = TutorialAction.values[1];
      final scenarioButtonAction = TutorialAction.values[2];
      final floatingControlsAction = TutorialAction.values[3];

      expect(appBarAction, equals(TutorialAction.highlightAppBar));
      expect(
        bottomControlsAction,
        equals(TutorialAction.highlightBottomControls),
      );
      expect(
        scenarioButtonAction,
        equals(TutorialAction.highlightScenarioButton),
      );
      expect(
        floatingControlsAction,
        equals(TutorialAction.highlightFloatingControls),
      );
    });

    test('should support pattern matching use cases', () {
      bool isHighlightAction(TutorialAction action) {
        return action == TutorialAction.highlightAppBar ||
            action == TutorialAction.highlightBottomControls ||
            action == TutorialAction.highlightScenarioButton ||
            action == TutorialAction.highlightFloatingControls;
      }

      // All actions should be highlight actions
      for (final action in TutorialAction.values) {
        expect(isHighlightAction(action), isTrue);
      }
    });
  });
}
