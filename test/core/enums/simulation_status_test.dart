import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/simulation_status.dart';

void main() {
  group('SimulationStatus Enum', () {
    test('should have all expected status values', () {
      expect(SimulationStatus.values.length, equals(4));
      expect(SimulationStatus.values, contains(SimulationStatus.stopped));
      expect(SimulationStatus.values, contains(SimulationStatus.running));
      expect(SimulationStatus.values, contains(SimulationStatus.paused));
      expect(SimulationStatus.values, contains(SimulationStatus.error));
    });

    test('should correctly identify active states', () {
      expect(SimulationStatus.running.isActive, isTrue);
      expect(SimulationStatus.paused.isActive, isTrue);
      expect(SimulationStatus.stopped.isActive, isFalse);
      expect(SimulationStatus.error.isActive, isFalse);
    });

    test('should correctly identify advancing states', () {
      expect(SimulationStatus.running.isAdvancing, isTrue);
      expect(SimulationStatus.paused.isAdvancing, isFalse);
      expect(SimulationStatus.stopped.isAdvancing, isFalse);
      expect(SimulationStatus.error.isAdvancing, isFalse);
    });

    test('should correctly identify when simulation can be started', () {
      expect(SimulationStatus.stopped.canStart, isTrue);
      expect(SimulationStatus.error.canStart, isTrue);
      expect(SimulationStatus.running.canStart, isFalse);
      expect(SimulationStatus.paused.canStart, isFalse);
    });

    test('should correctly identify when simulation can be paused', () {
      expect(SimulationStatus.running.canPause, isTrue);
      expect(SimulationStatus.stopped.canPause, isFalse);
      expect(SimulationStatus.paused.canPause, isFalse);
      expect(SimulationStatus.error.canPause, isFalse);
    });

    test('should correctly identify when simulation can be resumed', () {
      expect(SimulationStatus.paused.canResume, isTrue);
      expect(SimulationStatus.stopped.canResume, isFalse);
      expect(SimulationStatus.running.canResume, isFalse);
      expect(SimulationStatus.error.canResume, isFalse);
    });

    test('should correctly identify when simulation can be stopped', () {
      expect(SimulationStatus.running.canStop, isTrue);
      expect(SimulationStatus.paused.canStop, isTrue);
      expect(SimulationStatus.stopped.canStop, isFalse);
      expect(SimulationStatus.error.canStop, isFalse);
    });

    test('should have correct localization keys', () {
      expect(SimulationStatus.stopped.localizationKey, equals('statusStopped'));
      expect(SimulationStatus.running.localizationKey, equals('statusRunning'));
      expect(SimulationStatus.paused.localizationKey, equals('statusPaused'));
      expect(SimulationStatus.error.localizationKey, equals('statusError'));
    });

    test('should have correct icon names', () {
      expect(SimulationStatus.stopped.iconName, equals('stop'));
      expect(SimulationStatus.running.iconName, equals('play'));
      expect(SimulationStatus.paused.iconName, equals('pause'));
      expect(SimulationStatus.error.iconName, equals('error'));
    });

    test('should have consistent boolean logic', () {
      // A status should not be able to be paused and resumed at the same time
      for (final status in SimulationStatus.values) {
        if (status.canPause) {
          expect(
            status.canResume,
            isFalse,
            reason: '$status cannot both be pausable and resumable',
          );
        }
        if (status.canResume) {
          expect(
            status.canPause,
            isFalse,
            reason: '$status cannot both be resumable and pausable',
          );
        }
      }
    });

    test('should have logical state transitions', () {
      // Running should be active and advancing
      expect(SimulationStatus.running.isActive, isTrue);
      expect(SimulationStatus.running.isAdvancing, isTrue);

      // Paused should be active but not advancing
      expect(SimulationStatus.paused.isActive, isTrue);
      expect(SimulationStatus.paused.isAdvancing, isFalse);

      // Stopped should be neither active nor advancing
      expect(SimulationStatus.stopped.isActive, isFalse);
      expect(SimulationStatus.stopped.isAdvancing, isFalse);

      // Error should be neither active nor advancing
      expect(SimulationStatus.error.isActive, isFalse);
      expect(SimulationStatus.error.isAdvancing, isFalse);
    });
  });
}
