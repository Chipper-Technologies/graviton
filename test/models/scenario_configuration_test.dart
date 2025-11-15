import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/scenario_configuration.dart';

void main() {
  group('ScenarioConfiguration', () {
    test('should create instance with required fields only', () {
      final config = ScenarioConfiguration(
        cameraDistanceMultiplier: 1.5,
        expectedBodyCount: 5,
      );

      expect(config.optimalCameraDistance, isNull);
      expect(config.cameraDistanceMultiplier, equals(1.5));
      expect(config.expectedBodyCount, equals(5));
    });

    test('should create instance with all fields', () {
      final config = ScenarioConfiguration(
        optimalCameraDistance: 100.0,
        cameraDistanceMultiplier: 2.0,
        expectedBodyCount: 8,
      );

      expect(config.optimalCameraDistance, equals(100.0));
      expect(config.cameraDistanceMultiplier, equals(2.0));
      expect(config.expectedBodyCount, equals(8));
    });

    test('should serialize to JSON correctly with all fields', () {
      final config = ScenarioConfiguration(
        optimalCameraDistance: 150.0,
        cameraDistanceMultiplier: 1.8,
        expectedBodyCount: 3,
      );

      final json = config.toJson();

      expect(json['optimalCameraDistance'], equals(150.0));
      expect(json['cameraDistanceMultiplier'], equals(1.8));
      expect(json['expectedBodyCount'], equals(3));
    });

    test('should serialize to JSON correctly without optional fields', () {
      final config = ScenarioConfiguration(
        cameraDistanceMultiplier: 1.2,
        expectedBodyCount: 4,
      );

      final json = config.toJson();

      expect(json.containsKey('optimalCameraDistance'), isFalse);
      expect(json['cameraDistanceMultiplier'], equals(1.2));
      expect(json['expectedBodyCount'], equals(4));
    });

    test('should deserialize from JSON correctly with all fields', () {
      final json = {
        'optimalCameraDistance': 200.0,
        'cameraDistanceMultiplier': 2.5,
        'expectedBodyCount': 6,
      };

      final config = ScenarioConfiguration.fromJson(json);

      expect(config.optimalCameraDistance, equals(200.0));
      expect(config.cameraDistanceMultiplier, equals(2.5));
      expect(config.expectedBodyCount, equals(6));
    });

    test(
      'should deserialize from JSON correctly with null optional fields',
      () {
        final json = {
          'optimalCameraDistance': null,
          'cameraDistanceMultiplier': 1.3,
          'expectedBodyCount': 7,
        };

        final config = ScenarioConfiguration.fromJson(json);

        expect(config.optimalCameraDistance, isNull);
        expect(config.cameraDistanceMultiplier, equals(1.3));
        expect(config.expectedBodyCount, equals(7));
      },
    );

    test('should deserialize from JSON correctly without optional fields', () {
      final json = {'cameraDistanceMultiplier': 1.6, 'expectedBodyCount': 9};

      final config = ScenarioConfiguration.fromJson(json);

      expect(config.optimalCameraDistance, isNull);
      expect(config.cameraDistanceMultiplier, equals(1.6));
      expect(config.expectedBodyCount, equals(9));
    });

    test('should handle round-trip serialization', () {
      final original = ScenarioConfiguration(
        optimalCameraDistance: 75.0,
        cameraDistanceMultiplier: 1.4,
        expectedBodyCount: 10,
      );

      final json = original.toJson();
      final deserialized = ScenarioConfiguration.fromJson(json);

      expect(
        deserialized.optimalCameraDistance,
        equals(original.optimalCameraDistance),
      );
      expect(
        deserialized.cameraDistanceMultiplier,
        equals(original.cameraDistanceMultiplier),
      );
      expect(
        deserialized.expectedBodyCount,
        equals(original.expectedBodyCount),
      );
    });

    test('should handle round-trip serialization without optional fields', () {
      final original = ScenarioConfiguration(
        cameraDistanceMultiplier: 1.1,
        expectedBodyCount: 2,
      );

      final json = original.toJson();
      final deserialized = ScenarioConfiguration.fromJson(json);

      expect(
        deserialized.optimalCameraDistance,
        equals(original.optimalCameraDistance),
      );
      expect(
        deserialized.cameraDistanceMultiplier,
        equals(original.cameraDistanceMultiplier),
      );
      expect(
        deserialized.expectedBodyCount,
        equals(original.expectedBodyCount),
      );
    });

    test('should handle edge case values', () {
      final config = ScenarioConfiguration(
        optimalCameraDistance: 0.0,
        cameraDistanceMultiplier: 0.1,
        expectedBodyCount: 1,
      );

      expect(config.optimalCameraDistance, equals(0.0));
      expect(config.cameraDistanceMultiplier, equals(0.1));
      expect(config.expectedBodyCount, equals(1));

      // Test serialization with edge values
      final json = config.toJson();
      final deserialized = ScenarioConfiguration.fromJson(json);

      expect(deserialized.optimalCameraDistance, equals(0.0));
      expect(deserialized.cameraDistanceMultiplier, equals(0.1));
      expect(deserialized.expectedBodyCount, equals(1));
    });

    test('should handle large values', () {
      final config = ScenarioConfiguration(
        optimalCameraDistance: 999999.99,
        cameraDistanceMultiplier: 100.0,
        expectedBodyCount: 1000,
      );

      expect(config.optimalCameraDistance, equals(999999.99));
      expect(config.cameraDistanceMultiplier, equals(100.0));
      expect(config.expectedBodyCount, equals(1000));
    });
  });
}
