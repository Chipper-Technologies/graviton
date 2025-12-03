import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/firebase_event.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/services/firebase_service.dart';

void main() {
  group('FirebaseService Tests', () {
    late FirebaseService service;

    setUp(() {
      service = FirebaseService.instance;
    });

    test('Should be singleton', () {
      final service1 = FirebaseService.instance;
      final service2 = FirebaseService.instance;
      expect(identical(service1, service2), isTrue);
    });

    test('Should initialize with default values', () {
      expect(service.isInitialized, isFalse);
      expect(service.analytics, isNull);
      expect(service.crashlytics, isNull);
      expect(service.remoteConfig, isNull);
    });

    test('Should handle initialization gracefully', () async {
      // This test assumes Firebase is not actually initialized in test environment
      await service.initialize();
      // Should not throw exceptions even if Firebase is not available
      expect(service.initialize, returnsNormally);
    });

    test('Should handle logEvent calls safely', () {
      // Should not throw even when not initialized
      expect(() => service.logEvent('test_event'), returnsNormally);
      expect(
        () => service.logEvent('test_event', parameters: {'key': 'value'}),
        returnsNormally,
      );
    });

    test('Should handle recordError calls safely', () {
      final exception = Exception('Test exception');

      // Should not throw even when not initialized
      expect(() => service.recordError(exception, null), returnsNormally);
      expect(
        () => service.recordError(exception, StackTrace.current),
        returnsNormally,
      );
    });

    test('Should handle setUserProperty calls safely', () {
      // Should not throw even when not initialized
      expect(
        () => service.setUserProperty('test_property', 'test_value'),
        returnsNormally,
      );
    });

    test('Should handle setUserId calls safely', () {
      // Should not throw even when not initialized
      expect(() => service.setUserId('test_user_id'), returnsNormally);
    });

    test('Should validate event names', () {
      // Test various event name formats
      const validEvents = [
        'app_start',
        'simulation_started',
        'scenario_changed',
        'settings_opened',
        'language_changed',
      ];

      for (final event in validEvents) {
        expect(() => service.logEvent(event), returnsNormally);
      }
    });

    test('Should handle parameters correctly', () {
      final parameters = {
        'string_param': 'test',
        'int_param': 42,
        'double_param': 3.14,
        'bool_param': true,
      };

      expect(
        () => service.logEvent('test_event', parameters: parameters),
        returnsNormally,
      );
    });

    test('Should handle null and empty parameters', () {
      expect(
        () => service.logEvent('test_event', parameters: null),
        returnsNormally,
      );
      expect(
        () => service.logEvent('test_event', parameters: {}),
        returnsNormally,
      );
    });

    test('Should handle user property edge cases', () {
      expect(() => service.setUserProperty('', ''), returnsNormally);
      expect(() => service.setUserProperty('test', null), returnsNormally);
    });

    test('Should handle userId edge cases', () {
      expect(() => service.setUserId(''), returnsNormally);
      expect(() => service.setUserId(null), returnsNormally);
    });

    test('Should handle logEventWithEnum calls safely', () {
      // Should not throw even when not initialized
      expect(
        () => service.logEventWithEnum(FirebaseEvent.appStart),
        returnsNormally,
      );
      expect(
        () => service.logEventWithEnum(
          FirebaseEvent.appInitialized,
          parameters: {'key': 'value'},
        ),
        returnsNormally,
      );
    });

    test('Should handle logUIEventWithEnums calls safely', () {
      // Should not throw even when not initialized
      expect(() => service.logUIEventWithEnums(UIAction.tap), returnsNormally);
      expect(
        () => service.logUIEventWithEnums(
          UIAction.buttonPressed,
          element: UIElement.simulationControl,
          value: 'play',
        ),
        returnsNormally,
      );
    });

    test('Should validate Firebase event enum values', () {
      // Test all Firebase event enum values
      const firebaseEvents = [
        FirebaseEvent.appInitialized,
        FirebaseEvent.appStart,
        FirebaseEvent.appError,
        FirebaseEvent.simulationStarted,
        FirebaseEvent.simulationPaused,
        FirebaseEvent.simulationResumed,
        FirebaseEvent.simulationStopped,
        FirebaseEvent.simulationReset,
        FirebaseEvent.settingsChanged,
        FirebaseEvent.performanceMetric,
      ];

      for (final event in firebaseEvents) {
        expect(() => service.logEventWithEnum(event), returnsNormally);
      }
    });

    test('Should validate UI action enum values', () {
      // Test all UI action enum values
      const uiActions = [
        UIAction.tap,
        UIAction.dialogOpened,
        UIAction.scenarioSelected,
        UIAction.buttonPressed,
        UIAction.gestureStart,
        UIAction.bodySelected,
        UIAction.cameraFocus,
        UIAction.followModeEnabled,
        UIAction.followModeDisabled,
        UIAction.cameraReset,
        UIAction.cameraAutoZoom,
        UIAction.autoRotateToggle,
        UIAction.invertPitchToggle,
        UIAction.galacticPlaneModeToggle,
        UIAction.cameraCenter,
        UIAction.followToggle,
      ];

      for (final action in uiActions) {
        expect(() => service.logUIEventWithEnums(action), returnsNormally);
      }
    });

    test('Should validate UI element enum values', () {
      // Test all UI element enum values
      const uiElements = [
        UIElement.simulationViewport,
        UIElement.scenarioSelection,
        UIElement.scenarioDialog,
        UIElement.settings,
        UIElement.simulationControl,
        UIElement.cameraControls,
        UIElement.camera,
        UIElement.body,
        UIElement.scenario,
      ];

      for (final element in uiElements) {
        expect(
          () => service.logUIEventWithEnums(UIAction.tap, element: element),
          returnsNormally,
        );
      }
    });

    test('Should handle enum parameters correctly', () {
      final parameters = {
        'string_param': 'test',
        'int_param': 42,
        'double_param': 3.14,
        'bool_param': true,
      };

      expect(
        () => service.logEventWithEnum(
          FirebaseEvent.performanceMetric,
          parameters: parameters,
        ),
        returnsNormally,
      );

      expect(
        () => service.logUIEventWithEnums(
          UIAction.scenarioSelected,
          element: UIElement.scenarioDialog,
          value: 'solar_system',
          additionalParams: parameters,
        ),
        returnsNormally,
      );
    });

    test('Should handle null enum parameters', () {
      expect(
        () =>
            service.logEventWithEnum(FirebaseEvent.appStart, parameters: null),
        returnsNormally,
      );

      expect(
        () => service.logUIEventWithEnums(
          UIAction.tap,
          element: null,
          value: null,
          additionalParams: null,
        ),
        returnsNormally,
      );
    });

    // New comprehensive tests for improved coverage:

    group('Remote Config Methods', () {
      test('Should handle getRemoteConfigBool with defaults', () {
        // Test with known default values
        expect(
          service.getRemoteConfigBool('feature_enhanced_graphics'),
          isFalse,
        );
        expect(
          service.getRemoteConfigBool('feature_advanced_controls'),
          isTrue,
        );
        expect(service.getRemoteConfigBool('enable_vibration'), isTrue);
        expect(service.getRemoteConfigBool('show_debug_info'), kDebugMode);
        expect(service.getRemoteConfigBool('maintenance_mode'), isFalse);
      });

      test('Should handle getRemoteConfigBool with unknown keys', () {
        // Should return false for unknown keys
        expect(service.getRemoteConfigBool('unknown_key'), isFalse);
        expect(service.getRemoteConfigBool(''), isFalse);
      });

      test('Should handle getRemoteConfigDouble with defaults', () {
        // Test with known default values
        expect(service.getRemoteConfigDouble('max_simulation_speed'), 16.0);
        expect(service.getRemoteConfigDouble('min_simulation_speed'), 0.1);
        expect(service.getRemoteConfigDouble('default_time_scale'), 8.0);
      });

      test('Should handle getRemoteConfigDouble with unknown keys', () {
        // Should return 0.0 for unknown keys
        expect(service.getRemoteConfigDouble('unknown_key'), 0.0);
        expect(service.getRemoteConfigDouble(''), 0.0);
      });

      test('Should handle getRemoteConfigString with defaults', () {
        // Test with known default values
        expect(
          service.getRemoteConfigString('maintenance_message'),
          'The app is currently under maintenance. Please try again later.',
        );
        expect(service.getRemoteConfigString('force_update_version'), '0.0.0');
        expect(
          service.getRemoteConfigString('update_message'),
          'A new version is available. Please update to continue.',
        );
      });

      test('Should handle getRemoteConfigString with unknown keys', () {
        // Should return empty string for unknown keys
        expect(service.getRemoteConfigString('unknown_key'), '');
        expect(service.getRemoteConfigString(''), '');
      });

      test('Should handle refreshRemoteConfig safely', () async {
        // Should not throw even when not initialized
        final result = await service.refreshRemoteConfig();
        expect(result, isFalse); // Should return false when not initialized
      });
    });

    group('Crashlytics Methods', () {
      test('Should handle recordError with various parameters', () async {
        final exception = Exception('Test exception');
        final stackTrace = StackTrace.current;

        // Test with all parameters
        await expectLater(
          () => service.recordError(
            exception,
            stackTrace,
            reason: 'Test reason',
            fatal: true,
          ),
          returnsNormally,
        );

        // Test with minimal parameters
        await expectLater(
          () => service.recordError(exception, null),
          returnsNormally,
        );

        // Test with different exception types
        await expectLater(
          () => service.recordError('String error', stackTrace),
          returnsNormally,
        );

        await expectLater(
          () => service.recordError(42, stackTrace),
          returnsNormally,
        );
      });

      test('Should handle setCrashKey safely', () async {
        // Test with various key-value types
        await expectLater(
          () => service.setCrashKey('string_key', 'string_value'),
          returnsNormally,
        );

        await expectLater(
          () => service.setCrashKey('int_key', 42),
          returnsNormally,
        );

        await expectLater(
          () => service.setCrashKey('double_key', 3.14),
          returnsNormally,
        );

        await expectLater(
          () => service.setCrashKey('bool_key', true),
          returnsNormally,
        );

        // Test with empty key
        await expectLater(
          () => service.setCrashKey('', 'value'),
          returnsNormally,
        );
      });
    });

    group('Screen View Logging', () {
      test('Should handle logScreenView safely', () async {
        // Test with various screen names
        await expectLater(
          () => service.logScreenView('home_screen'),
          returnsNormally,
        );

        await expectLater(
          () => service.logScreenView('settings_screen'),
          returnsNormally,
        );

        await expectLater(() => service.logScreenView(''), returnsNormally);
      });
    });

    group('Simulation Analytics', () {
      test('Should handle logSimulationEvent with all parameters', () async {
        await expectLater(
          () => service.logSimulationEvent(
            'started',
            scenario: 'solar_system',
            timeScale: 2.0,
            stepCount: 100,
            additionalParams: {'custom_param': 'value'},
          ),
          returnsNormally,
        );
      });

      test(
        'Should handle logSimulationEvent with minimal parameters',
        () async {
          await expectLater(
            () => service.logSimulationEvent('paused'),
            returnsNormally,
          );
        },
      );

      test(
        'Should handle logSimulationEvent with partial parameters',
        () async {
          await expectLater(
            () => service.logSimulationEvent('reset', scenario: 'three_body'),
            returnsNormally,
          );

          await expectLater(
            () => service.logSimulationEvent(
              'step',
              timeScale: 5.0,
              stepCount: 50,
            ),
            returnsNormally,
          );
        },
      );
    });

    group('UI Analytics', () {
      test('Should handle logUIEvent with all parameters', () async {
        await expectLater(
          () => service.logUIEvent(
            'button_pressed',
            element: 'play_button',
            value: 'start_simulation',
            additionalParams: {'screen': 'main'},
          ),
          returnsNormally,
        );
      });

      test('Should handle logUIEvent with minimal parameters', () async {
        await expectLater(() => service.logUIEvent('tap'), returnsNormally);
      });

      test('Should handle logUIEvent with partial parameters', () async {
        await expectLater(
          () => service.logUIEvent('swipe', element: 'simulation_canvas'),
          returnsNormally,
        );

        await expectLater(
          () => service.logUIEvent('input', value: 'user_text'),
          returnsNormally,
        );
      });

      test('Should handle logUIEventWithEnums with all parameters', () async {
        await expectLater(
          () => service.logUIEventWithEnums(
            UIAction.buttonPressed,
            element: UIElement.simulationControl,
            value: 'play',
            additionalParams: {'context': 'main_screen'},
          ),
          returnsNormally,
        );
      });

      test(
        'Should handle logUIEventWithEnums with partial parameters',
        () async {
          await expectLater(
            () => service.logUIEventWithEnums(
              UIAction.tap,
              element: UIElement.settings,
            ),
            returnsNormally,
          );

          await expectLater(
            () => service.logUIEventWithEnums(
              UIAction.gestureStart,
              value: 'zoom_in',
            ),
            returnsNormally,
          );
        },
      );
    });

    group('Settings Analytics', () {
      test(
        'Should handle logSettingsChange with various value types',
        () async {
          await expectLater(
            () => service.logSettingsChange('show_trails', true),
            returnsNormally,
          );

          await expectLater(
            () => service.logSettingsChange('time_scale', 2.5),
            returnsNormally,
          );

          await expectLater(
            () => service.logSettingsChange('language', 'en'),
            returnsNormally,
          );

          await expectLater(
            () => service.logSettingsChange('max_bodies', 100),
            returnsNormally,
          );
        },
      );
    });

    group('Performance Analytics', () {
      test('Should handle logPerformanceEvent with all parameters', () async {
        await expectLater(
          () => service.logPerformanceEvent(
            'frame_rate',
            value: 60.0,
            unit: 'fps',
            additionalParams: {'scenario': 'solar_system'},
          ),
          returnsNormally,
        );
      });

      test(
        'Should handle logPerformanceEvent with minimal parameters',
        () async {
          await expectLater(
            () => service.logPerformanceEvent('app_launch'),
            returnsNormally,
          );
        },
      );

      test(
        'Should handle logPerformanceEvent with partial parameters',
        () async {
          await expectLater(
            () => service.logPerformanceEvent(
              'memory_usage',
              value: 256.0,
              unit: 'MB',
            ),
            returnsNormally,
          );

          await expectLater(
            () => service.logPerformanceEvent(
              'simulation_step_time',
              value: 16.7,
            ),
            returnsNormally,
          );
        },
      );
    });

    group('Error Analytics', () {
      test('Should handle logErrorEvent with all parameters', () async {
        await expectLater(
          () => service.logErrorEvent(
            'network_error',
            errorMessage: 'Connection timeout',
            context: 'remote_config_fetch',
            additionalParams: {'retry_count': 3},
          ),
          returnsNormally,
        );
      });

      test('Should handle logErrorEvent with minimal parameters', () async {
        await expectLater(
          () => service.logErrorEvent('unknown_error'),
          returnsNormally,
        );
      });

      test('Should handle logErrorEvent with partial parameters', () async {
        await expectLater(
          () => service.logErrorEvent(
            'validation_error',
            errorMessage: 'Invalid input format',
          ),
          returnsNormally,
        );

        await expectLater(
          () => service.logErrorEvent(
            'initialization_error',
            context: 'app_startup',
          ),
          returnsNormally,
        );
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Should handle very long parameter values', () async {
        final longString = 'a' * 1000;

        await expectLater(
          () => service.logEvent(
            'test_event',
            parameters: {'long_string': longString},
          ),
          returnsNormally,
        );

        await expectLater(
          () => service.logUIEvent(
            'test_action',
            element: longString,
            value: longString,
          ),
          returnsNormally,
        );
      });

      test('Should handle special characters in parameters', () async {
        final specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?`~';

        await expectLater(
          () => service.logEvent(
            'test_event',
            parameters: {'special_chars': specialChars},
          ),
          returnsNormally,
        );

        await expectLater(
          () => service.setUserProperty('test_prop', specialChars),
          returnsNormally,
        );
      });

      test('Should handle unicode characters', () async {
        const unicode = '🚀🌟🌍🌙⭐';

        await expectLater(
          () =>
              service.logEvent('test_event', parameters: {'unicode': unicode}),
          returnsNormally,
        );

        await expectLater(
          () => service.logUIEvent('test_action', value: unicode),
          returnsNormally,
        );
      });

      test('Should handle large parameter maps', () async {
        final largeParams = <String, Object>{};
        for (int i = 0; i < 100; i++) {
          largeParams['param_$i'] = 'value_$i';
        }

        await expectLater(
          () => service.logEvent('test_event', parameters: largeParams),
          returnsNormally,
        );
      });

      test('Should handle mixed parameter types', () async {
        final mixedParams = <String, Object>{
          'string': 'text',
          'int': 42,
          'double': 3.14159,
          'bool': true,
          'list': [1, 2, 3],
          'map': {'nested': 'value'},
        };

        await expectLater(
          () => service.logEvent('test_event', parameters: mixedParams),
          returnsNormally,
        );
      });
    });

    group('Performance Monitoring', () {
      test(
        'Should handle startTrace calls safely when not initialized',
        () async {
          final trace = await service.startTrace('test_trace');
          // Should return null when not initialized
          expect(trace, isNull);
        },
      );

      test('Should handle startTrace with various trace names', () async {
        const traceNames = [
          'simulation_step',
          'physics_calculation',
          'render_frame',
          'collision_detection',
          'screen_transition',
        ];

        for (final name in traceNames) {
          expect(() => service.startTrace(name), returnsNormally);
        }
      });

      test('Should handle newHttpMetric calls safely when not initialized', () {
        final metric = service.newHttpMetric(
          'https://api.example.com/data',
          HttpMethod.Get,
        );
        // Should return null when not initialized
        expect(metric, isNull);
      });

      test('Should handle newHttpMetric with various HTTP methods', () {
        const url = 'https://api.example.com/data';
        final methods = [
          HttpMethod.Get,
          HttpMethod.Post,
          HttpMethod.Put,
          HttpMethod.Delete,
          HttpMethod.Patch,
        ];

        for (final method in methods) {
          expect(() => service.newHttpMetric(url, method), returnsNormally);
        }
      });

      test('Should handle newHttpMetric with edge case URLs', () {
        const urls = [
          '',
          'invalid-url',
          'http://localhost:8080',
          'https://example.com',
          'https://api.example.com/path/to/resource?query=value',
        ];

        for (final url in urls) {
          expect(
            () => service.newHttpMetric(url, HttpMethod.Get),
            returnsNormally,
          );
        }
      });

      test('Should have performance getter', () {
        // Initially null before initialization
        expect(service.performance, isNull);
      });

      test(
        'Should handle performance monitoring when Firebase is not available',
        () async {
          // These should all handle gracefully when Firebase is not initialized
          await expectLater(
            service.startTrace('test_trace'),
            completion(isNull),
          );

          expect(
            service.newHttpMetric('https://api.test.com', HttpMethod.Get),
            isNull,
          );
        },
      );
    });
  });
}
