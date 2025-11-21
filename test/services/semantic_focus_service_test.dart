import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/semantic_focus_service.dart';

import '../test_utils.dart';

void main() {
  group('SemanticFocusService', () {
    late SemanticFocusService service;
    late dynamic mockL10n;

    setUp(() {
      mockL10n = TestUtils.createMockAppLocalizations();
      service = SemanticFocusService.instance;
      service.setEnabled(true);
    });

    group('Singleton pattern', () {
      test('should return the same instance', () {
        final instance1 = SemanticFocusService.instance;
        final instance2 = SemanticFocusService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Focus management', () {
      test('should have correct number of focus nodes', () {
        expect(service.currentFocusIndex, equals(0));
        expect(service.currentFocusNode, isA<FocusNode>());
      });

      test('should move focus to next element', () {
        final initialIndex = service.currentFocusIndex;
        service.focusNext();

        expect(service.currentFocusIndex, equals((initialIndex + 1) % 6));
      });

      test('should move focus to previous element', () {
        // Start at index 1
        service.focusAt(1);
        service.focusPrevious();

        expect(service.currentFocusIndex, equals(0));
      });

      test('should wrap around when moving next from last element', () {
        service.focusAt(5); // Last element
        service.focusNext();

        expect(service.currentFocusIndex, equals(0));
      });

      test('should wrap around when moving previous from first element', () {
        service.focusAt(0); // First element
        service.focusPrevious();

        expect(service.currentFocusIndex, equals(5));
      });

      test('should focus on specific elements by name', () {
        service.focusSimulation();
        expect(service.currentFocusIndex, equals(0));

        service.focusCameraControls();
        expect(service.currentFocusIndex, equals(1));

        service.focusSimulationControls();
        expect(service.currentFocusIndex, equals(2));

        service.focusBottomSheet();
        expect(service.currentFocusIndex, equals(3));

        service.focusScenarioSelector();
        expect(service.currentFocusIndex, equals(4));

        service.focusSettings();
        expect(service.currentFocusIndex, equals(5));
      });

      test('should handle invalid focus indices', () {
        service.focusAt(2); // Set to a known valid index first
        final originalIndex = service.currentFocusIndex;

        service.focusAt(-1);
        expect(
          service.currentFocusIndex,
          equals(originalIndex),
        ); // Should not change

        service.focusAt(10);
        expect(
          service.currentFocusIndex,
          equals(originalIndex),
        ); // Should not change
      });
    });

    group('Enable/Disable functionality', () {
      test('should not move focus when disabled', () {
        service.focusAt(2);
        final initialIndex = service.currentFocusIndex;

        service.setEnabled(false);
        service.focusNext();

        expect(service.currentFocusIndex, equals(initialIndex));

        service.focusPrevious();
        expect(service.currentFocusIndex, equals(initialIndex));
      });

      test('should resume focus movement when re-enabled', () {
        service.setEnabled(false);
        service.setEnabled(true);

        final initialIndex = service.currentFocusIndex;
        service.focusNext();

        expect(service.currentFocusIndex, equals((initialIndex + 1) % 6));
      });
    });

    group('Focus descriptions and actions', () {
      test('should provide focus descriptions for all elements', () {
        for (int i = 0; i < 6; i++) {
          service.focusAt(i);
          final description = service.getFocusDescription(mockL10n);

          expect(description, isNotEmpty);
          expect(description, contains('focused'));
        }
      });

      test('should provide available actions for all elements', () {
        for (int i = 0; i < 6; i++) {
          service.focusAt(i);
          final actions = service.getAvailableActions(mockL10n);

          expect(actions, isNotEmpty);
          expect(actions.first, isNotEmpty);
        }
      });

      test('should provide specific actions for simulation canvas', () {
        service.focusSimulation();
        final actions = service.getAvailableActions(mockL10n);

        expect(actions, contains(contains('Tap to interact')));
        expect(actions, contains(contains('keyboard shortcuts')));
      });

      test('should provide specific actions for camera controls', () {
        service.focusCameraControls();
        final actions = service.getAvailableActions(mockL10n);

        expect(actions, contains(contains('center camera')));
        expect(actions, contains(contains('zoom')));
      });
    });

    group('Widget creation', () {
      testWidgets('should create focus scope widget', (tester) async {
        final widget = service.createFocusScope(child: const Text('Test'));

        expect(widget, isA<FocusScope>());
      });

      testWidgets('should create semantic focus wrapper', (tester) async {
        final focusNode = FocusNode();
        final widget = service.createSemanticFocusWrapper(
          child: const Text('Test'),
          focusNode: focusNode,
          semanticLabel: 'Test Label',
          semanticHint: 'Test Hint',
        );

        expect(widget, isA<Focus>());
      });

      testWidgets('should create keyboard shortcuts widget', (tester) async {
        final widget = service.createFocusKeyboardShortcuts(
          child: const Text('Test'),
        );

        expect(widget, isA<Focus>());
      });
    });

    group('Focus state queries', () {
      test('should correctly report focus state', () {
        // Since we can't actually request focus in unit tests,
        // we'll test the structure and bounds checking
        expect(service.hasFocus(-1), isFalse);
        expect(service.hasFocus(10), isFalse);
        expect(() => service.hasFocus(0), returnsNormally);
        expect(() => service.hasFocus(5), returnsNormally);
      });

      test('should provide access to focus nodes', () {
        expect(service.simulationCanvasFocusNode, isA<FocusNode>());
        expect(service.cameraControlsFocusNode, isA<FocusNode>());
        expect(service.simulationControlsFocusNode, isA<FocusNode>());
        expect(service.bottomSheetFocusNode, isA<FocusNode>());
        expect(service.scenarioSelectorFocusNode, isA<FocusNode>());
        expect(service.settingsButtonFocusNode, isA<FocusNode>());
      });
    });

    group('Edge cases', () {
      test('should handle rapid focus changes', () {
        for (int i = 0; i < 100; i++) {
          service.focusNext();
        }

        // Should complete without errors
        expect(service.currentFocusIndex, isA<int>());
        expect(service.currentFocusIndex, greaterThanOrEqualTo(0));
        expect(service.currentFocusIndex, lessThan(6));
      });

      test('should handle focus changes when disabled', () {
        service.focusAt(2); // Set to a known valid index first
        final originalIndex = service.currentFocusIndex;

        service.setEnabled(false);

        for (int i = 0; i < 10; i++) {
          service.focusNext();
          service.focusPrevious();
        }

        // Focus should not have moved from original position
        expect(service.currentFocusIndex, equals(originalIndex));
      });
    });

    group('Performance', () {
      test('should handle focus operations efficiently', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          service.focusNext();
          service.getFocusDescription(mockL10n);
          service.getAvailableActions(mockL10n);
        }

        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('Cleanup', () {
      test('should dispose resources', () {
        expect(() => service.dispose(), returnsNormally);
      });
    });
  });
}
