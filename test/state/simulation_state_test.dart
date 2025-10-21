import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/simulation_state.dart';

void main() {
  group('SimulationState Tests', () {
    late SimulationState simulationState;

    setUp(() {
      simulationState = SimulationState();
    });

    test('Initial state should have correct defaults', () {
      expect(simulationState.isRunning, isFalse);
      expect(simulationState.isPaused, isFalse);
      expect(simulationState.timeScale, equals(1.0));
      expect(simulationState.stepCount, equals(0));
      expect(simulationState.totalTime, equals(0.0));
      expect(simulationState.totalTimeInEarthYears, equals(0.0));
      expect(simulationState.bodies, isNotNull);
      expect(simulationState.trails, isNotNull);
      expect(simulationState.mergeFlashes, isNotNull);
    });

    test('Initialize should load settings correctly', () async {
      // Should work even without SharedPreferences in tests
      await simulationState.initialize();
      expect(simulationState.timeScale, equals(1.0));
    });

    test('Start should set isRunning to true', () {
      simulationState.start();
      expect(simulationState.isRunning, isTrue);
      expect(simulationState.isPaused, isFalse);
    });

    test('Pause should toggle isPaused state', () {
      simulationState.pause();
      expect(simulationState.isPaused, isTrue);

      simulationState.pause();
      expect(simulationState.isPaused, isFalse);
    });

    test('Stop should reset running and paused state', () {
      simulationState.start();
      simulationState.pause();

      simulationState.stop();
      expect(simulationState.isRunning, isFalse);
      expect(simulationState.isPaused, isFalse);
    });

    test('Reset should clear simulation state', () {
      simulationState.start();
      // Simulate some steps
      simulationState.step(1 / 60.0);

      final initialStepCount = simulationState.stepCount;
      final initialTotalTime = simulationState.totalTime;

      simulationState.reset();
      expect(simulationState.stepCount, equals(0));
      expect(simulationState.totalTime, equals(0.0));
      expect(simulationState.isPaused, isFalse);
      expect(simulationState.stepCount, lessThan(initialStepCount));
      expect(simulationState.totalTime, lessThan(initialTotalTime));
    });

    test('SetTimeScale should update timeScale and clamp values', () {
      // Test normal value
      simulationState.setTimeScale(2.5);
      expect(simulationState.timeScale, equals(2.5));

      // Test upper bound clamping
      simulationState.setTimeScale(20.0);
      expect(simulationState.timeScale, equals(16.0));

      // Test lower bound clamping
      simulationState.setTimeScale(0.05);
      expect(simulationState.timeScale, equals(0.1));
    });

    test('Step should advance simulation when running and not paused', () {
      simulationState.start();

      final initialStepCount = simulationState.stepCount;
      final initialTotalTime = simulationState.totalTime;

      simulationState.step(1 / 60.0);

      expect(simulationState.stepCount, greaterThan(initialStepCount));
      expect(simulationState.totalTime, greaterThan(initialTotalTime));
    });

    test('Step should not advance when not running', () {
      // Don't start the simulation
      final initialStepCount = simulationState.stepCount;
      final initialTotalTime = simulationState.totalTime;

      simulationState.step(1 / 60.0);

      expect(simulationState.stepCount, equals(initialStepCount));
      expect(simulationState.totalTime, equals(initialTotalTime));
    });

    test('Step should not advance when paused', () {
      simulationState.start();
      simulationState.pause();

      final initialStepCount = simulationState.stepCount;
      final initialTotalTime = simulationState.totalTime;

      simulationState.step(1 / 60.0);

      expect(simulationState.stepCount, equals(initialStepCount));
      expect(simulationState.totalTime, equals(initialTotalTime));
    });

    test('TimeScale affects step count during simulation', () {
      simulationState.start();

      // Set slow timeScale
      simulationState.setTimeScale(0.5);
      simulationState.step(1 / 60.0);
      final slowSteps = simulationState.stepCount;

      simulationState.reset();
      simulationState.start();

      // Set fast timeScale
      simulationState.setTimeScale(4.0);
      simulationState.step(1 / 60.0);
      final fastSteps = simulationState.stepCount;

      expect(fastSteps, greaterThan(slowSteps));
    });

    test('TotalTimeInEarthYears should convert simulation time correctly', () {
      simulationState.start();
      simulationState.step(1 / 60.0);

      // Should convert using SimulationConstants.simulationTimeToEarthYears
      final earthYears = simulationState.totalTimeInEarthYears;
      expect(earthYears, isA<double>());
      expect(earthYears, greaterThanOrEqualTo(0));
    });

    test('State changes should notify listeners', () {
      int notificationCount = 0;
      simulationState.addListener(() => notificationCount++);

      simulationState.start();
      expect(notificationCount, equals(1));

      simulationState.pause();
      expect(notificationCount, equals(2));

      simulationState.setTimeScale(2.0);
      expect(notificationCount, equals(3));

      final countBeforeReset = notificationCount;
      simulationState.reset();
      // Reset calls stop(), notifyListeners(), then start() - so expect multiple notifications
      expect(notificationCount, greaterThan(countBeforeReset));
    });
  });
}
