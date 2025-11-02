import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/orbital_event.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('OrbitalEvent Model Tests', () {
    test('OrbitalEvent constructor should initialize with correct values', () {
      final eventPosition = vm.Vector3(10.0, 20.0, 30.0);
      final optimalCameraPosition = vm.Vector3(50.0, 60.0, 70.0);
      final timestamp = DateTime.now().add(const Duration(seconds: 5));
      const involvedBodies = [0, 1];
      const dramaticScore = 0.85;
      const description = 'Test close approach event';

      final event = OrbitalEvent(
        type: OrbitalEventType.closeApproach,
        timestamp: timestamp,
        eventPosition: eventPosition,
        optimalCameraPosition: optimalCameraPosition,
        involvedBodies: involvedBodies,
        dramaticScore: dramaticScore,
        description: description,
      );

      expect(event.type, equals(OrbitalEventType.closeApproach));
      expect(event.timestamp, equals(timestamp));
      expect(event.eventPosition, equals(eventPosition));
      expect(event.optimalCameraPosition, equals(optimalCameraPosition));
      expect(event.involvedBodies, equals(involvedBodies));
      expect(event.dramaticScore, equals(dramaticScore));
      expect(event.description, equals(description));
    });

    test('OrbitalEvent dramatic score should be within reasonable range', () {
      final eventPosition = vm.Vector3.zero();
      final optimalCameraPosition = vm.Vector3.zero();
      final timestamp = DateTime.now();

      // Test with high dramatic score
      final event1 = OrbitalEvent(
        type: OrbitalEventType.periapsis,
        timestamp: timestamp,
        eventPosition: eventPosition,
        optimalCameraPosition: optimalCameraPosition,
        involvedBodies: const [0],
        dramaticScore: 1.0,
        description: 'High drama event',
      );

      // Test with low dramatic score
      final event2 = OrbitalEvent(
        type: OrbitalEventType.apoapsis,
        timestamp: timestamp,
        eventPosition: eventPosition,
        optimalCameraPosition: optimalCameraPosition,
        involvedBodies: const [0],
        dramaticScore: 0.0,
        description: 'Low drama event',
      );

      expect(event1.dramaticScore, equals(1.0));
      expect(event2.dramaticScore, equals(0.0));
    });

    test('OrbitalEvent should handle empty involved bodies list', () {
      final event = OrbitalEvent(
        type: OrbitalEventType.periapsis,
        timestamp: DateTime.now(),
        eventPosition: vm.Vector3.zero(),
        optimalCameraPosition: vm.Vector3.zero(),
        involvedBodies: const [],
        dramaticScore: 0.5,
        description: 'Solo event',
      );

      expect(event.involvedBodies, isEmpty);
    });

    test('OrbitalEvent toString should contain relevant information', () {
      final event = OrbitalEvent(
        type: OrbitalEventType.closeApproach,
        timestamp: DateTime.now(),
        eventPosition: vm.Vector3.zero(),
        optimalCameraPosition: vm.Vector3.zero(),
        involvedBodies: const [0, 1],
        dramaticScore: 0.85,
        description: 'Test event',
      );

      final eventString = event.toString();
      expect(eventString, contains('OrbitalEvent'));
      expect(eventString, contains('closeApproach'));
      expect(eventString, contains('0.85'));
      expect(eventString, contains('[0, 1]'));
    });

    test('OrbitalEventType enum should have all expected values', () {
      expect(OrbitalEventType.values, hasLength(7));
      expect(OrbitalEventType.values, contains(OrbitalEventType.closeApproach));
      expect(OrbitalEventType.values, contains(OrbitalEventType.periapsis));
      expect(OrbitalEventType.values, contains(OrbitalEventType.apoapsis));
      expect(OrbitalEventType.values, contains(OrbitalEventType.slingshot));
      expect(
        OrbitalEventType.values,
        contains(OrbitalEventType.potentialCollision),
      );
      expect(OrbitalEventType.values, contains(OrbitalEventType.orbitalDecay));
      expect(OrbitalEventType.values, contains(OrbitalEventType.resonance));
    });
  });

  group('CameraMovement Model Tests', () {
    test(
      'CameraMovement constructor should initialize with correct values',
      () {
        final startPosition = vm.Vector3(1.0, 2.0, 3.0);
        final endPosition = vm.Vector3(4.0, 5.0, 6.0);
        final startTarget = vm.Vector3(7.0, 8.0, 9.0);
        final endTarget = vm.Vector3(10.0, 11.0, 12.0);
        const duration = 2.5;

        final movement = CameraMovement(
          startPosition: startPosition,
          endPosition: endPosition,
          startTarget: startTarget,
          endTarget: endTarget,
          duration: duration,
          type: CameraMovementType.linear,
        );

        expect(movement.startPosition, equals(startPosition));
        expect(movement.endPosition, equals(endPosition));
        expect(movement.startTarget, equals(startTarget));
        expect(movement.endTarget, equals(endTarget));
        expect(movement.duration, equals(duration));
        expect(movement.type, equals(CameraMovementType.linear));
      },
    );

    test('CameraMovement should handle zero duration', () {
      final movement = CameraMovement(
        startPosition: vm.Vector3.zero(),
        endPosition: vm.Vector3(1.0, 1.0, 1.0),
        startTarget: vm.Vector3.zero(),
        endTarget: vm.Vector3.zero(),
        duration: 0.0,
        type: CameraMovementType.easeInOut,
      );

      expect(movement.duration, equals(0.0));
    });

    test('CameraMovementType enum should have all expected values', () {
      expect(CameraMovementType.values, hasLength(4));
      expect(CameraMovementType.values, contains(CameraMovementType.linear));
      expect(CameraMovementType.values, contains(CameraMovementType.easeInOut));
      expect(CameraMovementType.values, contains(CameraMovementType.bezier));
      expect(CameraMovementType.values, contains(CameraMovementType.banking));
    });
  });

  group('PredictiveOrbitalConfig Model Tests', () {
    test(
      'PredictiveOrbitalConfig constructor should initialize with correct values',
      () {
        const predictionTimeframe = 20.0;
        const minDramaticScore = 0.4;
        const maxTrackedEvents = 5;
        const movementSpeed = 1.5;
        const useBanking = false;
        const dramaLevel = 0.8;

        final config = PredictiveOrbitalConfig(
          predictionTimeframe: predictionTimeframe,
          minDramaticScore: minDramaticScore,
          maxTrackedEvents: maxTrackedEvents,
          movementSpeed: movementSpeed,
          useBanking: useBanking,
          dramaLevel: dramaLevel,
        );

        expect(config.predictionTimeframe, equals(predictionTimeframe));
        expect(config.minDramaticScore, equals(minDramaticScore));
        expect(config.maxTrackedEvents, equals(maxTrackedEvents));
        expect(config.movementSpeed, equals(movementSpeed));
        expect(config.useBanking, equals(useBanking));
        expect(config.dramaLevel, equals(dramaLevel));
      },
    );

    test('PredictiveOrbitalConfig should have sensible default values', () {
      const config = PredictiveOrbitalConfig();

      expect(config.predictionTimeframe, equals(15.0));
      expect(config.minDramaticScore, equals(0.3));
      expect(config.maxTrackedEvents, equals(3));
      expect(config.movementSpeed, equals(1.0));
      expect(config.useBanking, equals(true));
      expect(config.dramaLevel, equals(0.7));
    });

    test(
      'PredictiveOrbitalConfig.forScenario should create appropriate configs',
      () {
        final solarSystemConfig = PredictiveOrbitalConfig.forScenario(
          'solarsystem',
        );
        final threeBodyConfig = PredictiveOrbitalConfig.forScenario(
          'threebody',
        );
        final galaxyConfig = PredictiveOrbitalConfig.forScenario('galaxy');

        // Solar system should have longer timeframe and lower drama
        expect(solarSystemConfig.predictionTimeframe, equals(30.0));
        expect(solarSystemConfig.minDramaticScore, equals(0.2));
        expect(solarSystemConfig.dramaLevel, equals(0.5));

        // Three body should have medium timeframe and higher drama
        expect(threeBodyConfig.predictionTimeframe, equals(8.0));
        expect(threeBodyConfig.minDramaticScore, equals(0.4));
        expect(threeBodyConfig.dramaLevel, equals(0.8));

        // Galaxy should have short timeframe and highest drama
        expect(galaxyConfig.predictionTimeframe, equals(5.0));
        expect(galaxyConfig.minDramaticScore, equals(0.5));
        expect(galaxyConfig.dramaLevel, equals(0.9));
      },
    );

    test(
      'PredictiveOrbitalConfig.forScenario should handle unknown scenarios',
      () {
        final unknownConfig = PredictiveOrbitalConfig.forScenario('unknown');
        const defaultConfig = PredictiveOrbitalConfig();

        expect(
          unknownConfig.predictionTimeframe,
          equals(defaultConfig.predictionTimeframe),
        );
        expect(
          unknownConfig.minDramaticScore,
          equals(defaultConfig.minDramaticScore),
        );
        expect(unknownConfig.dramaLevel, equals(defaultConfig.dramaLevel));
      },
    );

    test('PredictiveOrbitalConfig should validate parameter ranges', () {
      final config = PredictiveOrbitalConfig(
        predictionTimeframe: 5.0,
        minDramaticScore: 0.1,
        maxTrackedEvents: 1,
        movementSpeed: 0.5,
        useBanking: false,
        dramaLevel: 0.0,
      );

      expect(config.predictionTimeframe, greaterThan(0));
      expect(config.minDramaticScore, greaterThanOrEqualTo(0.0));
      expect(config.minDramaticScore, lessThanOrEqualTo(1.0));
      expect(config.maxTrackedEvents, greaterThan(0));
      expect(config.movementSpeed, greaterThan(0));
      expect(config.dramaLevel, greaterThanOrEqualTo(0.0));
      expect(config.dramaLevel, lessThanOrEqualTo(1.0));
    });
  });
}
