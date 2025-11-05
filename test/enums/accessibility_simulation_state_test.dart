import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/accessibility_simulation_state.dart';

void main() {
  group('AccessibilitySimulationState', () {
    group('localizationKey', () {
      test('should return correct localization key for started state', () {
        expect(
          AccessibilitySimulationState.started.localizationKey,
          equals('accessibilitySimulationStarted'),
        );
      });

      test('should return correct localization key for running state', () {
        expect(
          AccessibilitySimulationState.running.localizationKey,
          equals('accessibilitySimulationRunning'),
        );
      });

      test('should return correct localization key for paused state', () {
        expect(
          AccessibilitySimulationState.paused.localizationKey,
          equals('accessibilitySimulationPaused'),
        );
      });

      test('should return correct localization key for resumed state', () {
        expect(
          AccessibilitySimulationState.resumed.localizationKey,
          equals('accessibilitySimulationResumed'),
        );
      });

      test('should return correct localization key for stopped state', () {
        expect(
          AccessibilitySimulationState.stopped.localizationKey,
          equals('accessibilitySimulationStopped'),
        );
      });

      test('should return correct localization key for reset state', () {
        expect(
          AccessibilitySimulationState.reset.localizationKey,
          equals('accessibilitySimulationReset'),
        );
      });
    });

    group('contextLocalizationKey', () {
      test('should return correct context key for started state', () {
        expect(
          AccessibilitySimulationState.started.contextLocalizationKey,
          equals('accessibilitySimulationStartedContext'),
        );
      });

      test('should return correct context key for running state', () {
        expect(
          AccessibilitySimulationState.running.contextLocalizationKey,
          equals('accessibilitySimulationStartedContext'),
        );
      });

      test('should return correct context key for paused state', () {
        expect(
          AccessibilitySimulationState.paused.contextLocalizationKey,
          equals('accessibilitySimulationPausedContext'),
        );
      });

      test('should return correct context key for resumed state', () {
        expect(
          AccessibilitySimulationState.resumed.contextLocalizationKey,
          equals('accessibilitySimulationResumedContext'),
        );
      });

      test('should return correct context key for stopped state', () {
        expect(
          AccessibilitySimulationState.stopped.contextLocalizationKey,
          equals('accessibilitySimulationStoppedContext'),
        );
      });

      test('should return correct context key for reset state', () {
        expect(
          AccessibilitySimulationState.reset.contextLocalizationKey,
          equals('accessibilitySimulationResetContext'),
        );
      });
    });

    group('fromString', () {
      test('should return started for "started" string', () {
        expect(
          AccessibilitySimulationState.fromString('started'),
          equals(AccessibilitySimulationState.started),
        );
      });

      test('should return started for "running" string', () {
        expect(
          AccessibilitySimulationState.fromString('running'),
          equals(AccessibilitySimulationState.started),
        );
      });

      test('should return paused for "paused" string', () {
        expect(
          AccessibilitySimulationState.fromString('paused'),
          equals(AccessibilitySimulationState.paused),
        );
      });

      test('should return resumed for "resumed" string', () {
        expect(
          AccessibilitySimulationState.fromString('resumed'),
          equals(AccessibilitySimulationState.resumed),
        );
      });

      test('should return stopped for "stopped" string', () {
        expect(
          AccessibilitySimulationState.fromString('stopped'),
          equals(AccessibilitySimulationState.stopped),
        );
      });

      test('should return reset for "reset" string', () {
        expect(
          AccessibilitySimulationState.fromString('reset'),
          equals(AccessibilitySimulationState.reset),
        );
      });

      test('should return started for unknown string', () {
        expect(
          AccessibilitySimulationState.fromString('unknown'),
          equals(AccessibilitySimulationState.started),
        );
      });

      test('should return started for empty string', () {
        expect(
          AccessibilitySimulationState.fromString(''),
          equals(AccessibilitySimulationState.started),
        );
      });

      test('should handle case insensitive input', () {
        expect(
          AccessibilitySimulationState.fromString('PAUSED'),
          equals(AccessibilitySimulationState.paused),
        );

        expect(
          AccessibilitySimulationState.fromString('Started'),
          equals(AccessibilitySimulationState.started),
        );

        expect(
          AccessibilitySimulationState.fromString('RESET'),
          equals(AccessibilitySimulationState.reset),
        );
      });
    });

    group('enum values', () {
      test('should have all expected enum values', () {
        const expectedValues = [
          AccessibilitySimulationState.started,
          AccessibilitySimulationState.running,
          AccessibilitySimulationState.paused,
          AccessibilitySimulationState.resumed,
          AccessibilitySimulationState.stopped,
          AccessibilitySimulationState.reset,
        ];

        expect(AccessibilitySimulationState.values, equals(expectedValues));
      });

      test('should have correct number of enum values', () {
        expect(AccessibilitySimulationState.values.length, equals(6));
      });
    });

    group('enum string representation', () {
      test('should have correct string representation for each value', () {
        expect(
          AccessibilitySimulationState.started.toString(),
          equals('AccessibilitySimulationState.started'),
        );

        expect(
          AccessibilitySimulationState.running.toString(),
          equals('AccessibilitySimulationState.running'),
        );

        expect(
          AccessibilitySimulationState.paused.toString(),
          equals('AccessibilitySimulationState.paused'),
        );

        expect(
          AccessibilitySimulationState.resumed.toString(),
          equals('AccessibilitySimulationState.resumed'),
        );

        expect(
          AccessibilitySimulationState.stopped.toString(),
          equals('AccessibilitySimulationState.stopped'),
        );

        expect(
          AccessibilitySimulationState.reset.toString(),
          equals('AccessibilitySimulationState.reset'),
        );
      });
    });
  });
}
