import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/scenario_physics_settings.dart';

void main() {
  group('ScenarioPhysicsSettings', () {
    test('should create instance with required values', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 6.67430e-11,
        softening: 0.01,
        timeScale: 1.0,
        collisionRadiusMultiplier: 1.0,
        maxTrailPoints: 1000,
        trailFadeRate: 0.01,
      );

      expect(settings.gravitationalConstant, equals(6.67430e-11));
      expect(settings.softening, equals(0.01));
      expect(settings.timeScale, equals(1.0));
      expect(settings.collisionRadiusMultiplier, equals(1.0));
      expect(settings.maxTrailPoints, equals(1000));
      expect(settings.trailFadeRate, equals(0.01));
    });

    test('should create instance with custom values', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 1.0,
        softening: 0.05,
        timeScale: 2.5,
        collisionRadiusMultiplier: 1.5,
        maxTrailPoints: 500,
        trailFadeRate: 0.02,
      );

      expect(settings.gravitationalConstant, equals(1.0));
      expect(settings.softening, equals(0.05));
      expect(settings.timeScale, equals(2.5));
      expect(settings.collisionRadiusMultiplier, equals(1.5));
      expect(settings.maxTrailPoints, equals(500));
      expect(settings.trailFadeRate, equals(0.02));
    });

    test('should serialize to JSON correctly', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 6.67430e-11,
        softening: 0.01,
        timeScale: 1.0,
        collisionRadiusMultiplier: 1.0,
        maxTrailPoints: 1000,
        trailFadeRate: 0.01,
      );

      final json = settings.toJson();

      expect(json['gravitationalConstant'], equals(6.67430e-11));
      expect(json['softening'], equals(0.01));
      expect(json['timeScale'], equals(1.0));
      expect(json['collisionRadiusMultiplier'], equals(1.0));
      expect(json['maxTrailPoints'], equals(1000));
      expect(json['trailFadeRate'], equals(0.01));
    });

    test('should serialize to JSON correctly with custom values', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 2.0e-10,
        softening: 0.1,
        timeScale: 0.5,
        collisionRadiusMultiplier: 2.0,
        maxTrailPoints: 2000,
        trailFadeRate: 0.05,
      );

      final json = settings.toJson();

      expect(json['gravitationalConstant'], equals(2.0e-10));
      expect(json['softening'], equals(0.1));
      expect(json['timeScale'], equals(0.5));
      expect(json['collisionRadiusMultiplier'], equals(2.0));
      expect(json['maxTrailPoints'], equals(2000));
      expect(json['trailFadeRate'], equals(0.05));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'gravitationalConstant': 1.5e-10,
        'softening': 0.02,
        'timeScale': 3.0,
        'collisionRadiusMultiplier': 1.2,
        'maxTrailPoints': 750,
        'trailFadeRate': 0.03,
      };

      final settings = ScenarioPhysicsSettings.fromJson(json);

      expect(settings.gravitationalConstant, equals(1.5e-10));
      expect(settings.softening, equals(0.02));
      expect(settings.timeScale, equals(3.0));
      expect(settings.collisionRadiusMultiplier, equals(1.2));
      expect(settings.maxTrailPoints, equals(750));
      expect(settings.trailFadeRate, equals(0.03));
    });

    test('should handle round-trip serialization', () {
      final original = ScenarioPhysicsSettings(
        gravitationalConstant: 1.5,
        softening: 0.08,
        timeScale: 1.5,
        collisionRadiusMultiplier: 0.6,
        maxTrailPoints: 1500,
        trailFadeRate: 0.02,
      );

      final json = original.toJson();
      final deserialized = ScenarioPhysicsSettings.fromJson(json);

      expect(
        deserialized.gravitationalConstant,
        equals(original.gravitationalConstant),
      );
      expect(deserialized.softening, equals(original.softening));
      expect(deserialized.timeScale, equals(original.timeScale));
      expect(
        deserialized.collisionRadiusMultiplier,
        equals(original.collisionRadiusMultiplier),
      );
      expect(deserialized.maxTrailPoints, equals(original.maxTrailPoints));
      expect(deserialized.trailFadeRate, equals(original.trailFadeRate));
    });

    test('should handle extreme values', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 0.0,
        softening: 0.0,
        timeScale: 0.0,
        collisionRadiusMultiplier: 0.0,
        maxTrailPoints: 0,
        trailFadeRate: 0.0,
      );

      expect(settings.gravitationalConstant, equals(0.0));
      expect(settings.softening, equals(0.0));
      expect(settings.timeScale, equals(0.0));
      expect(settings.collisionRadiusMultiplier, equals(0.0));
      expect(settings.maxTrailPoints, equals(0));
      expect(settings.trailFadeRate, equals(0.0));

      // Test serialization with extreme values
      final json = settings.toJson();
      final deserialized = ScenarioPhysicsSettings.fromJson(json);

      expect(deserialized.gravitationalConstant, equals(0.0));
      expect(deserialized.softening, equals(0.0));
      expect(deserialized.timeScale, equals(0.0));
      expect(deserialized.collisionRadiusMultiplier, equals(0.0));
      expect(deserialized.maxTrailPoints, equals(0));
      expect(deserialized.trailFadeRate, equals(0.0));
    });

    test('should handle large values', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 1.0e10,
        softening: 100.0,
        timeScale: 1000.0,
        collisionRadiusMultiplier: 50.0,
        maxTrailPoints: 100000,
        trailFadeRate: 1.0,
      );

      expect(settings.gravitationalConstant, equals(1.0e10));
      expect(settings.softening, equals(100.0));
      expect(settings.timeScale, equals(1000.0));
      expect(settings.collisionRadiusMultiplier, equals(50.0));
      expect(settings.maxTrailPoints, equals(100000));
      expect(settings.trailFadeRate, equals(1.0));

      // Test serialization with large values
      final json = settings.toJson();
      final deserialized = ScenarioPhysicsSettings.fromJson(json);

      expect(deserialized.gravitationalConstant, equals(1.0e10));
      expect(deserialized.softening, equals(100.0));
      expect(deserialized.timeScale, equals(1000.0));
      expect(deserialized.collisionRadiusMultiplier, equals(50.0));
      expect(deserialized.maxTrailPoints, equals(100000));
      expect(deserialized.trailFadeRate, equals(1.0));
    });

    test('should handle very small positive values', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 1.0e-20,
        softening: 1.0e-10,
        timeScale: 0.001,
        collisionRadiusMultiplier: 0.001,
        maxTrailPoints: 1,
        trailFadeRate: 1.0e-5,
      );

      expect(settings.gravitationalConstant, equals(1.0e-20));
      expect(settings.softening, equals(1.0e-10));
      expect(settings.timeScale, equals(0.001));
      expect(settings.collisionRadiusMultiplier, equals(0.001));
      expect(settings.maxTrailPoints, equals(1));
      expect(settings.trailFadeRate, equals(1.0e-5));
    });

    test('should handle typical physics values', () {
      final settings = ScenarioPhysicsSettings(
        gravitationalConstant: 6.67430e-11, // Real gravitational constant
        softening: 0.1,
        timeScale: 86400.0, // 1 day in seconds
        collisionRadiusMultiplier: 1.5,
        maxTrailPoints: 2000,
        trailFadeRate: 0.001,
      );

      expect(settings.gravitationalConstant, equals(6.67430e-11));
      expect(settings.softening, equals(0.1));
      expect(settings.timeScale, equals(86400.0));
      expect(settings.collisionRadiusMultiplier, equals(1.5));
      expect(settings.maxTrailPoints, equals(2000));
      expect(settings.trailFadeRate, equals(0.001));

      // Test serialization with typical values
      final json = settings.toJson();
      final deserialized = ScenarioPhysicsSettings.fromJson(json);

      expect(deserialized.gravitationalConstant, equals(6.67430e-11));
      expect(deserialized.softening, equals(0.1));
      expect(deserialized.timeScale, equals(86400.0));
      expect(deserialized.collisionRadiusMultiplier, equals(1.5));
      expect(deserialized.maxTrailPoints, equals(2000));
      expect(deserialized.trailFadeRate, equals(0.001));
    });
  });
}
