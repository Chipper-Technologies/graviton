import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('BodySnapshot', () {
    late Body testBody;

    setUp(() {
      testBody = Body(
        name: 'Test Star',
        position: vm.Vector3(100.0, 200.0, 50.0),
        velocity: vm.Vector3(1.0, -2.0, 0.5),
        mass: 1000.0,
        radius: 50.0,
        color: Colors.yellow,
        isPlanet: false,
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
        habitabilityStatus: HabitabilityStatus.unknown,
        temperature: 5778.0,
      );
    });

    test('fromBody should create snapshot with correct values', () {
      final snapshot = BodySnapshot.fromBody(testBody);

      expect(snapshot.name, equals('Test Star'));
      expect(snapshot.position.x, equals(100.0));
      expect(snapshot.position.y, equals(200.0));
      expect(snapshot.position.z, equals(50.0));
      expect(snapshot.velocity.x, equals(1.0));
      expect(snapshot.velocity.y, equals(-2.0));
      expect(snapshot.velocity.z, equals(0.5));
      expect(snapshot.mass, equals(1000.0));
      expect(snapshot.radius, equals(50.0));
      expect(snapshot.colorValue, equals(Colors.yellow.toARGB32()));
      expect(snapshot.isPlanet, isFalse);
      expect(snapshot.bodyType, equals(BodyType.star));
      expect(snapshot.stellarLuminosity, equals(1.0));
      expect(snapshot.habitabilityStatus, equals(HabitabilityStatus.unknown));
      expect(snapshot.temperature, equals(5778.0));
    });

    test('toMap should serialize correctly', () {
      final snapshot = BodySnapshot.fromBody(testBody);
      final map = snapshot.toMap();

      expect(map['name'], equals('Test Star'));
      expect(map['position'], equals([100.0, 200.0, 50.0]));
      expect(map['velocity'], equals([1.0, -2.0, 0.5]));
      expect(map['mass'], equals(1000.0));
      expect(map['radius'], equals(50.0));
      expect(map['colorValue'], equals(Colors.yellow.toARGB32()));
      expect(map['isPlanet'], isFalse);
      expect(map['bodyType'], equals(BodyType.star.index));
      expect(map['stellarLuminosity'], equals(1.0));
      expect(
        map['habitabilityStatus'],
        equals(HabitabilityStatus.unknown.index),
      );
      expect(map['temperature'], equals(5778.0));
    });

    test('fromMap should deserialize correctly', () {
      final map = {
        'name': 'Test Planet',
        'position': [50.0, 100.0, 25.0],
        'velocity': [0.5, -1.0, 0.25],
        'mass': 500.0,
        'radius': 25.0,
        'colorValue': Colors.blue.toARGB32(),
        'isPlanet': true,
        'bodyType': BodyType.planet.index,
        'stellarLuminosity': 0.0,
        'habitabilityStatus': HabitabilityStatus.habitable.index,
        'temperature': 288.0,
      };

      final snapshot = BodySnapshot.fromMap(map);

      expect(snapshot.name, equals('Test Planet'));
      expect(snapshot.position.x, equals(50.0));
      expect(snapshot.position.y, equals(100.0));
      expect(snapshot.position.z, equals(25.0));
      expect(snapshot.velocity.x, equals(0.5));
      expect(snapshot.velocity.y, equals(-1.0));
      expect(snapshot.velocity.z, equals(0.25));
      expect(snapshot.mass, equals(500.0));
      expect(snapshot.radius, equals(25.0));
      expect(snapshot.colorValue, equals(Colors.blue.toARGB32()));
      expect(snapshot.isPlanet, isTrue);
      expect(snapshot.bodyType, equals(BodyType.planet));
      expect(snapshot.stellarLuminosity, equals(0.0));
      expect(snapshot.habitabilityStatus, equals(HabitabilityStatus.habitable));
      expect(snapshot.temperature, equals(288.0));
    });

    test('fromMap should handle missing values with defaults', () {
      final snapshot = BodySnapshot.fromMap({});

      expect(snapshot.name, equals(''));
      expect(snapshot.position.x, equals(0.0));
      expect(snapshot.mass, equals(1.0));
      expect(snapshot.radius, equals(10.0));
      expect(snapshot.isPlanet, isFalse);
      expect(snapshot.temperature, equals(273.15));
    });

    test('roundtrip serialization should preserve data', () {
      final original = BodySnapshot.fromBody(testBody);
      final map = original.toMap();
      final restored = BodySnapshot.fromMap(map);

      expect(restored.name, equals(original.name));
      expect(restored.position.x, equals(original.position.x));
      expect(restored.position.y, equals(original.position.y));
      expect(restored.position.z, equals(original.position.z));
      expect(restored.velocity.x, equals(original.velocity.x));
      expect(restored.velocity.y, equals(original.velocity.y));
      expect(restored.velocity.z, equals(original.velocity.z));
      expect(restored.mass, equals(original.mass));
      expect(restored.radius, equals(original.radius));
      expect(restored.colorValue, equals(original.colorValue));
      expect(restored.isPlanet, equals(original.isPlanet));
      expect(restored.bodyType, equals(original.bodyType));
      expect(restored.stellarLuminosity, equals(original.stellarLuminosity));
      expect(restored.habitabilityStatus, equals(original.habitabilityStatus));
      expect(restored.temperature, equals(original.temperature));
    });

    test('applyTo should update body state', () {
      final targetBody = Body(
        name: 'Target',
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 1.0,
        radius: 1.0,
        color: Colors.white,
      );

      final snapshot = BodySnapshot.fromBody(testBody);
      snapshot.applyTo(targetBody);

      expect(targetBody.position.x, equals(100.0));
      expect(targetBody.position.y, equals(200.0));
      expect(targetBody.position.z, equals(50.0));
      expect(targetBody.velocity.x, equals(1.0));
      expect(targetBody.mass, equals(1000.0));
      expect(targetBody.radius, equals(50.0));
      expect(targetBody.color.toARGB32(), equals(Colors.yellow.toARGB32()));
    });

    test('toBody should create new body with correct state', () {
      final snapshot = BodySnapshot.fromBody(testBody);
      final newBody = snapshot.toBody();

      expect(newBody.name, equals('Test Star'));
      expect(newBody.position.x, equals(100.0));
      expect(newBody.mass, equals(1000.0));
      expect(newBody.bodyType, equals(BodyType.star));
    });

    test('toString should return readable format', () {
      final snapshot = BodySnapshot.fromBody(testBody);
      expect(snapshot.toString(), contains('BodySnapshot'));
      expect(snapshot.toString(), contains('Test Star'));
    });
  });

  group('SimulationSnapshot', () {
    late List<Body> testBodies;

    setUp(() {
      testBodies = [
        Body(
          name: 'Star',
          position: vm.Vector3(0.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 50.0,
          color: Colors.yellow,
          bodyType: BodyType.star,
        ),
        Body(
          name: 'Planet',
          position: vm.Vector3(100.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 5.0, 0.0),
          mass: 10.0,
          radius: 15.0,
          color: Colors.blue,
          isPlanet: true,
          bodyType: BodyType.planet,
        ),
      ];
    });

    test('fromSimulation should create snapshot with correct values', () {
      final snapshot = SimulationSnapshot.fromSimulation(
        bodies: testBodies,
        isRunning: true,
        timeScale: 4.0,
        totalTime: 1000.0,
        stepCount: 500,
      );

      expect(snapshot.bodies.length, equals(2));
      expect(snapshot.isRunning, isTrue);
      expect(snapshot.timeScale, equals(4.0));
      expect(snapshot.totalTime, equals(1000.0));
      expect(snapshot.stepCount, equals(500));
      expect(snapshot.timestamp, isNotNull);
    });

    test('toMap should serialize correctly', () {
      final snapshot = SimulationSnapshot.fromSimulation(
        bodies: testBodies,
        isRunning: true,
        timeScale: 2.0,
        totalTime: 500.0,
        stepCount: 250,
      );
      final map = snapshot.toMap();

      expect(map['bodies'], isList);
      expect((map['bodies'] as List).length, equals(2));
      expect(map['isRunning'], isTrue);
      expect(map['timeScale'], equals(2.0));
      expect(map['totalTime'], equals(500.0));
      expect(map['stepCount'], equals(250));
      expect(map['timestamp'], isA<int>());
    });

    test('fromMap should deserialize correctly', () {
      final map = {
        'bodies': [
          {
            'name': 'TestBody',
            'position': [10.0, 20.0, 30.0],
            'velocity': [1.0, 2.0, 3.0],
            'mass': 100.0,
            'radius': 20.0,
            'colorValue': Colors.red.toARGB32(),
            'isPlanet': true,
            'bodyType': BodyType.planet.index,
            'stellarLuminosity': 0.0,
            'habitabilityStatus': HabitabilityStatus.unknown.index,
            'temperature': 300.0,
          },
        ],
        'isRunning': false,
        'timeScale': 1.5,
        'totalTime': 750.0,
        'stepCount': 375,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final snapshot = SimulationSnapshot.fromMap(map);

      expect(snapshot.bodies.length, equals(1));
      expect(snapshot.bodies[0].name, equals('TestBody'));
      expect(snapshot.isRunning, isFalse);
      expect(snapshot.timeScale, equals(1.5));
      expect(snapshot.totalTime, equals(750.0));
      expect(snapshot.stepCount, equals(375));
    });

    test('fromMap should handle missing values with defaults', () {
      final snapshot = SimulationSnapshot.fromMap({});

      expect(snapshot.bodies, isEmpty);
      expect(snapshot.isRunning, isFalse);
      expect(snapshot.timeScale, equals(1.0));
      expect(snapshot.totalTime, equals(0.0));
      expect(snapshot.stepCount, equals(0));
    });

    test('roundtrip serialization should preserve data', () {
      final original = SimulationSnapshot.fromSimulation(
        bodies: testBodies,
        isRunning: true,
        timeScale: 4.0,
        totalTime: 1000.0,
        stepCount: 500,
      );
      final map = original.toMap();
      final restored = SimulationSnapshot.fromMap(map);

      expect(restored.bodies.length, equals(original.bodies.length));
      expect(restored.isRunning, equals(original.isRunning));
      expect(restored.timeScale, equals(original.timeScale));
      expect(restored.totalTime, equals(original.totalTime));
      expect(restored.stepCount, equals(original.stepCount));
    });

    test('isStale should return false for recent snapshot', () {
      final snapshot = SimulationSnapshot.fromSimulation(
        bodies: testBodies,
        isRunning: true,
        timeScale: 1.0,
        totalTime: 0.0,
        stepCount: 0,
      );

      expect(snapshot.isStale(), isFalse);
    });

    test('isStale should return true for old snapshot', () {
      final oldTimestamp = DateTime.now().subtract(const Duration(seconds: 10));
      final snapshot = SimulationSnapshot(
        bodies: [],
        isRunning: false,
        timeScale: 1.0,
        totalTime: 0.0,
        stepCount: 0,
        timestamp: oldTimestamp,
      );

      expect(snapshot.isStale(), isTrue);
      expect(snapshot.isStale(threshold: const Duration(seconds: 15)), isFalse);
    });

    test('toString should return readable format', () {
      final snapshot = SimulationSnapshot.fromSimulation(
        bodies: testBodies,
        isRunning: true,
        timeScale: 4.0,
        totalTime: 0.0,
        stepCount: 0,
      );

      expect(snapshot.toString(), contains('SimulationSnapshot'));
      expect(snapshot.toString(), contains('2'));
      expect(snapshot.toString(), contains('true'));
      expect(snapshot.toString(), contains('4.0'));
    });
  });
}
