import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/physics_settings.dart';
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
      expect(simulationState.timeScale, equals(4.0));
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
      expect(simulationState.timeScale, equals(4.0));
    });

    test('Start should set isRunning to true', () {
      simulationState.start();
      expect(simulationState.isRunning, isTrue);
      expect(simulationState.isPaused, isFalse);
    });

    test('Pause should toggle isPaused state', () {
      // First start the simulation so it can be paused
      simulationState.start();
      expect(simulationState.isRunning, isTrue);
      expect(simulationState.isPaused, isFalse);

      // Now pause it
      simulationState.pause();
      expect(simulationState.isPaused, isTrue);

      // Pause again to resume
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

    group('AutoPause functionality', () {
      test(
        'pauseSimulation should pause only if running and not already paused',
        () {
          // Test when simulation is not running - should not pause
          simulationState.pauseSimulation();
          expect(simulationState.isPaused, isFalse);

          // Start simulation and test pause
          simulationState.start();
          expect(simulationState.isRunning, isTrue);
          expect(simulationState.isPaused, isFalse);

          simulationState.pauseSimulation();
          expect(simulationState.isRunning, isFalse);
          expect(simulationState.isPaused, isTrue);

          // Calling pauseSimulation again should not change state
          simulationState.pauseSimulation();
          expect(simulationState.isRunning, isFalse);
          expect(simulationState.isPaused, isTrue);
        },
      );

      test('resumeSimulation should resume only if running and paused', () {
        // Test when simulation is not running - should not resume
        simulationState.resumeSimulation();
        expect(simulationState.isPaused, isFalse);

        // Start and pause simulation
        simulationState.start();
        simulationState.pauseSimulation();
        expect(simulationState.isRunning, isFalse);
        expect(simulationState.isPaused, isTrue);

        simulationState.resumeSimulation();
        expect(simulationState.isRunning, isTrue);
        expect(simulationState.isPaused, isFalse);

        // Calling resumeSimulation again should not change state
        simulationState.resumeSimulation();
        expect(simulationState.isRunning, isTrue);
        expect(simulationState.isPaused, isFalse);
      });

      test('pauseSimulation and resumeSimulation should work together', () {
        // Start simulation
        simulationState.start();

        // Pause using pauseSimulation
        simulationState.pauseSimulation();
        expect(simulationState.isRunning, isFalse);
        expect(simulationState.isPaused, isTrue);

        // Resume using resumeSimulation
        simulationState.resumeSimulation();
        expect(simulationState.isRunning, isTrue);
        expect(simulationState.isPaused, isFalse);

        // Test that regular pause() still works
        simulationState.pause();
        expect(simulationState.isPaused, isTrue);

        // resumeSimulation should work with regular pause too
        simulationState.resumeSimulation();
        expect(simulationState.isPaused, isFalse);
      });
    });

    group('Scenario Management', () {
      test('Should reset with specific scenario', () {
        simulationState.resetWithScenario(ScenarioType.solarSystem);
        expect(
          simulationState.currentScenario,
          equals(ScenarioType.solarSystem),
        );
      });

      test('Should handle scenario changes', () {
        var notificationCount = 0;
        simulationState.addListener(() => notificationCount++);

        simulationState.resetWithScenario(ScenarioType.binaryStars);
        expect(notificationCount, greaterThan(0));
      });
    });

    group('Physics Settings', () {
      test('Should apply physics settings', () {
        final settings = PhysicsSettings(
          gravitationalConstant: 2.0,
          softening: 0.5,
          collisionRadiusMultiplier: 0.15,
          maxTrailPoints: 200,
          trailFadeRate: 0.02,
          vibrationThrottleTime: 0.18,
          vibrationEnabled: true,
        );

        simulationState.applyPhysicsSettings(settings);

        expect(simulationState.simulation.gravitationalConstant, equals(2.0));
        expect(simulationState.simulation.softening, equals(0.5));
      });

      test('Should handle realistic colors setting', () {
        simulationState.setUseRealisticColors(true);
        expect(simulationState.simulation.useRealisticColors, isTrue);

        simulationState.setUseRealisticColors(false);
        expect(simulationState.simulation.useRealisticColors, isFalse);
      });

      test('Should handle vibration setting', () {
        simulationState.setVibrationEnabled(false);
        expect(simulationState.simulation.vibrationEnabled, isFalse);

        simulationState.setVibrationEnabled(true);
        expect(simulationState.simulation.vibrationEnabled, isTrue);
      });
    });

    group('Simulation Access', () {
      test('Should expose bodies list', () {
        expect(simulationState.bodies, isNotNull);
        expect(simulationState.bodies, isA<List>());
      });

      test('Should expose trails list', () {
        expect(simulationState.trails, isNotNull);
        expect(simulationState.trails, isA<List>());
      });

      test('Should expose merge flashes', () {
        expect(simulationState.mergeFlashes, isNotNull);
        expect(simulationState.mergeFlashes, isA<List>());
      });

      test('Should access simulation service', () {
        expect(simulationState.simulation, isNotNull);
      });
    });

    group('Body Properties Notification', () {
      test('Should notify when body properties change', () {
        var notificationCount = 0;
        simulationState.addListener(() => notificationCount++);

        simulationState.notifyBodyPropertiesChanged();
        expect(notificationCount, equals(1));
      });

      test('Should handle multiple property change notifications', () {
        var notificationCount = 0;
        simulationState.addListener(() => notificationCount++);

        for (int i = 0; i < 5; i++) {
          simulationState.notifyBodyPropertiesChanged();
        }

        expect(notificationCount, equals(5));
      });
    });

    group('Time Scale Edge Cases', () {
      test('Should handle very small time scales', () {
        simulationState.setTimeScale(0.1);
        expect(simulationState.timeScale, equals(0.1));
      });

      test('Should handle very large time scales', () {
        simulationState.setTimeScale(16.0);
        expect(simulationState.timeScale, equals(16.0));
      });

      test('Should clamp negative time scales', () {
        simulationState.setTimeScale(-1.0);
        expect(simulationState.timeScale, equals(0.1));
      });

      test('Should clamp excessively large time scales', () {
        simulationState.setTimeScale(100.0);
        expect(simulationState.timeScale, equals(16.0));
      });
    });

    group('State Persistence', () {
      test('Should maintain state across multiple operations', () {
        simulationState.start();
        simulationState.setTimeScale(2.5);
        simulationState.step(1 / 60.0);

        expect(simulationState.isRunning, isTrue);
        expect(simulationState.timeScale, equals(2.5));
        expect(simulationState.stepCount, greaterThan(0));

        simulationState.pause();
        expect(simulationState.isPaused, isTrue);
        expect(simulationState.timeScale, equals(2.5)); // Should persist
      });

      test('Should reset stepCount and totalTime on reset', () {
        simulationState.start();
        simulationState.step(1 / 60.0);

        expect(simulationState.stepCount, greaterThan(0));
        expect(simulationState.totalTime, greaterThan(0));

        simulationState.reset();

        expect(simulationState.stepCount, equals(0));
        expect(simulationState.totalTime, equals(0.0));
      });
    });

    group('Simulation Lifecycle', () {
      test('Should handle start-pause-resume-stop cycle', () {
        // Start
        simulationState.start();
        expect(simulationState.isRunning, isTrue);
        expect(simulationState.isPaused, isFalse);

        // Pause
        simulationState.pause();
        expect(simulationState.isPaused, isTrue);

        // Resume
        simulationState.pause();
        expect(simulationState.isPaused, isFalse);

        // Stop
        simulationState.stop();
        expect(simulationState.isRunning, isFalse);
        expect(simulationState.isPaused, isFalse);
      });

      test('Should handle rapid start-stop cycles', () {
        for (int i = 0; i < 10; i++) {
          simulationState.start();
          simulationState.stop();
        }

        expect(simulationState.isRunning, isFalse);
        expect(simulationState.isPaused, isFalse);
      });
    });
  });
}
