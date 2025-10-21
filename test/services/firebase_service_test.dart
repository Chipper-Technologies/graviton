import 'package:flutter_test/flutter_test.dart';
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
      expect(() => service.logEvent('test_event', parameters: {'key': 'value'}), returnsNormally);
    });

    test('Should handle recordError calls safely', () {
      final exception = Exception('Test exception');

      // Should not throw even when not initialized
      expect(() => service.recordError(exception, null), returnsNormally);
      expect(() => service.recordError(exception, StackTrace.current), returnsNormally);
    });

    test('Should handle setUserProperty calls safely', () {
      // Should not throw even when not initialized
      expect(() => service.setUserProperty('test_property', 'test_value'), returnsNormally);
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
      final parameters = {'string_param': 'test', 'int_param': 42, 'double_param': 3.14, 'bool_param': true};

      expect(() => service.logEvent('test_event', parameters: parameters), returnsNormally);
    });

    test('Should handle null and empty parameters', () {
      expect(() => service.logEvent('test_event', parameters: null), returnsNormally);
      expect(() => service.logEvent('test_event', parameters: {}), returnsNormally);
    });

    test('Should handle user property edge cases', () {
      expect(() => service.setUserProperty('', ''), returnsNormally);
      expect(() => service.setUserProperty('test', null), returnsNormally);
    });

    test('Should handle userId edge cases', () {
      expect(() => service.setUserId(''), returnsNormally);
      expect(() => service.setUserId(null), returnsNormally);
    });
  });
}
