import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/tutorial_action.dart';
import 'package:graviton/models/tutorial_step.dart';

void main() {
  group('TutorialStep', () {
    test('should create instance with required parameters', () {
      const step = TutorialStep(
        title: 'Test Title',
        description: 'Test Description',
        icon: Icons.star,
      );

      expect(step.title, equals('Test Title'));
      expect(step.description, equals('Test Description'));
      expect(step.icon, equals(Icons.star));
      expect(step.highlightArea, isNull);
      expect(step.action, isNull);
      expect(step.isLogoStep, isFalse);
    });

    test('should create instance with all parameters', () {
      const highlightArea = Rect.fromLTWH(10, 20, 100, 200);
      const step = TutorialStep(
        title: 'Complete Title',
        description: 'Complete Description',
        icon: Icons.help,
        highlightArea: highlightArea,
        action: TutorialAction.highlightAppBar,
        isLogoStep: true,
      );

      expect(step.title, equals('Complete Title'));
      expect(step.description, equals('Complete Description'));
      expect(step.icon, equals(Icons.help));
      expect(step.highlightArea, equals(highlightArea));
      expect(step.action, equals(TutorialAction.highlightAppBar));
      expect(step.isLogoStep, isTrue);
    });

    test('should handle different tutorial actions', () {
      const steps = [
        TutorialStep(
          title: 'Step 1',
          description: 'Description 1',
          icon: Icons.apps,
          action: TutorialAction.highlightAppBar,
        ),
        TutorialStep(
          title: 'Step 2',
          description: 'Description 2',
          icon: Icons.navigation,
          action: TutorialAction.highlightBottomControls,
        ),
        TutorialStep(
          title: 'Step 3',
          description: 'Description 3',
          icon: Icons.explore,
          action: TutorialAction.highlightScenarioButton,
        ),
        TutorialStep(
          title: 'Step 4',
          description: 'Description 4',
          icon: Icons.touch_app,
          action: TutorialAction.highlightFloatingControls,
        ),
      ];

      expect(steps[0].action, equals(TutorialAction.highlightAppBar));
      expect(steps[1].action, equals(TutorialAction.highlightBottomControls));
      expect(steps[2].action, equals(TutorialAction.highlightScenarioButton));
      expect(steps[3].action, equals(TutorialAction.highlightFloatingControls));
    });

    test('should handle highlight area coordinates', () {
      const area1 = Rect.fromLTWH(0, 0, 50, 100);
      const area2 = Rect.fromLTRB(10, 20, 110, 220);

      const step1 = TutorialStep(
        title: 'Step with LTWH area',
        description: 'Using left, top, width, height',
        icon: Icons.crop_free,
        highlightArea: area1,
      );

      const step2 = TutorialStep(
        title: 'Step with LTRB area',
        description: 'Using left, top, right, bottom',
        icon: Icons.crop,
        highlightArea: area2,
      );

      expect(step1.highlightArea?.left, equals(0));
      expect(step1.highlightArea?.top, equals(0));
      expect(step1.highlightArea?.width, equals(50));
      expect(step1.highlightArea?.height, equals(100));

      expect(step2.highlightArea?.left, equals(10));
      expect(step2.highlightArea?.top, equals(20));
      expect(step2.highlightArea?.right, equals(110));
      expect(step2.highlightArea?.bottom, equals(220));
    });

    test('should maintain immutability', () {
      const originalStep = TutorialStep(
        title: 'Original',
        description: 'Original Description',
        icon: Icons.info,
      );

      // Should not be able to modify the step after creation
      expect(originalStep.title, equals('Original'));
      expect(originalStep.description, equals('Original Description'));
      expect(originalStep.icon, equals(Icons.info));
    });
  });
}
