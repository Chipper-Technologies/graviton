import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/custom_scenario_summary.dart';
import 'package:graviton/services/custom_scenario_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock SharedPreferences to avoid binding issues
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/shared_preferences'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getAll') {
              return <String, Object>{}; // Empty preferences
            }
            if (methodCall.method == 'remove') {
              return true;
            }
            if (methodCall.method == 'clear') {
              return true;
            }
            return null;
          },
        );
  });
  group('CustomScenarioManager Tests', () {
    late CustomScenarioManager manager;

    setUp(() {
      manager = CustomScenarioManager.instance;

      // Clear any existing state
      manager.clearCurrentCustomScenario();
    });

    tearDown(() {
      // Clean up after each test
      manager.clearCurrentCustomScenario();
    });

    group('Singleton Pattern', () {
      test('returns same instance', () {
        final instance1 = CustomScenarioManager.instance;
        final instance2 = CustomScenarioManager.instance;

        expect(instance1, same(instance2));
      });
    });

    group('State Management', () {
      test('initially has no custom scenario loaded', () {
        expect(manager.hasCustomScenario, isFalse);
        expect(manager.currentCustomScenario, isNull);
        expect(manager.currentCustomScenarioName, isNull);
      });

      test('clears custom scenario state correctly', () {
        // Manager starts with no scenario
        expect(manager.hasCustomScenario, isFalse);

        // Clear should work even when nothing is loaded
        manager.clearCurrentCustomScenario();

        expect(manager.hasCustomScenario, isFalse);
        expect(manager.currentCustomScenario, isNull);
        expect(manager.currentCustomScenarioName, isNull);
      });
    });

    group('Scenario Operations', () {
      test('getAvailableCustomScenarios returns list without errors', () async {
        // Should not throw even if no scenarios exist
        final scenarios = await manager.getAvailableCustomScenarios();

        expect(scenarios, isA<List<CustomScenarioSummary>>());
        // List can be empty if no scenarios exist yet
        expect(scenarios, isNotNull);
      });

      test(
        'scenarioExists handles non-existent scenarios gracefully',
        () async {
          const nonExistentScenario = 'definitely-does-not-exist-12345';

          final exists = await manager.scenarioExists(nonExistentScenario);

          expect(exists, isFalse);
        },
      );

      test(
        'exportScenarioToJson handles non-existent scenarios with error',
        () async {
          const nonExistentScenario = 'definitely-does-not-exist-12345';

          expect(
            () => manager.exportScenarioToJson(nonExistentScenario),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'duplicateScenario with unique name handles non-existent source',
        () async {
          const nonExistentSource = 'source-does-not-exist-12345';
          const newName = 'new-scenario-name';

          expect(
            () =>
                manager.duplicateScenario(nonExistentSource, newName: newName),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'loadCustomScenario handles non-existent scenario with error',
        () async {
          const nonExistentScenario = 'definitely-does-not-exist-12345';

          expect(
            () => manager.loadCustomScenario(nonExistentScenario),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deleteCustomScenario handles non-existent scenario gracefully',
        () async {
          const nonExistentScenario = 'definitely-does-not-exist-12345';

          // Should not throw even if scenario doesn't exist
          await manager.deleteCustomScenario(nonExistentScenario);

          // Verify it still doesn't exist
          final exists = await manager.scenarioExists(nonExistentScenario);
          expect(exists, isFalse);
        },
      );

      test(
        'previewCustomScenario handles non-existent scenario with error',
        () async {
          const nonExistentScenario = 'definitely-does-not-exist-12345';

          expect(
            () => manager.previewCustomScenario(nonExistentScenario),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('JSON Import/Export', () {
      test('importScenarioFromJson rejects invalid JSON', () async {
        const invalidJson = 'this is not valid json {[}';

        expect(
          () => manager.importScenarioFromJson(invalidJson),
          throwsA(isA<Exception>()),
        );
      });

      test('importScenarioFromJson rejects empty JSON', () async {
        const emptyJson = '{}';

        expect(
          () => manager.importScenarioFromJson(emptyJson),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('Performance and Edge Cases', () {
      test(
        'getAvailableCustomScenarios completes within reasonable time',
        () async {
          final stopwatch = Stopwatch()..start();

          await manager.getAvailableCustomScenarios();

          stopwatch.stop();

          // Should complete within 5 seconds even with many scenarios
          expect(
            stopwatch.elapsedMilliseconds,
            lessThan(5000),
            reason: 'getAvailableCustomScenarios should be reasonably fast',
          );
        },
      );

      test('handles multiple rapid operations gracefully', () async {
        const testScenario = 'rapid-test-scenario';

        // Perform multiple rapid operations
        final futures = <Future>[];

        for (int i = 0; i < 10; i++) {
          futures.add(manager.scenarioExists(testScenario));
        }

        // All should complete without errors
        final results = await Future.wait(futures);

        expect(results, hasLength(10));
        for (final result in results) {
          expect(result, isA<bool>());
        }
      });

      test('singleton state remains consistent across operations', () {
        final instance1 = CustomScenarioManager.instance;

        // Perform some state changes
        instance1.clearCurrentCustomScenario();

        final instance2 = CustomScenarioManager.instance;

        // State should be the same across instances
        expect(
          instance1.hasCustomScenario,
          equals(instance2.hasCustomScenario),
        );
        expect(
          instance1.currentCustomScenario,
          equals(instance2.currentCustomScenario),
        );
        expect(
          instance1.currentCustomScenarioName,
          equals(instance2.currentCustomScenarioName),
        );
      });
    });

    group('Error Handling and Validation', () {
      test('handles empty string scenario names appropriately', () async {
        // Empty string scenario name
        expect(() => manager.loadCustomScenario(''), throwsA(isA<Exception>()));

        final existsResult = await manager.scenarioExists('');
        expect(existsResult, isFalse);
      });

      test(
        'duplicate scenario with same source and target name should error',
        () async {
          const sameName = 'same-name-test';

          expect(
            () => manager.duplicateScenario(sameName, newName: sameName),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
