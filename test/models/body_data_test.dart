import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body_data.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';

void main() {
  group('BodyData', () {
    test('should create instance with all required fields', () {
      final bodyData = BodyData(
        name: 'Earth',
        position: [150000000.0, 0.0, 0.0],
        velocity: [0.0, 29800.0, 0.0],
        mass: 5.972e24,
        radius: 6371000.0,
        color: '#0000FF',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 288.0,
        showGravityWell: true,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.habitable,
      );

      expect(bodyData.name, equals('Earth'));
      expect(bodyData.position, equals([150000000.0, 0.0, 0.0]));
      expect(bodyData.velocity, equals([0.0, 29800.0, 0.0]));
      expect(bodyData.mass, equals(5.972e24));
      expect(bodyData.radius, equals(6371000.0));
      expect(bodyData.color, equals('#0000FF'));
      expect(bodyData.bodyType, equals(BodyType.planet));
      expect(bodyData.stellarLuminosity, equals(0.0));
      expect(bodyData.temperature, equals(288.0));
      expect(bodyData.showGravityWell, isTrue);
      expect(bodyData.isPlanet, isTrue);
      expect(bodyData.habitabilityStatus, equals(HabitabilityStatus.habitable));
    });

    test('should create star instance with correct values', () {
      final star = BodyData(
        name: 'Sun',
        position: [0.0, 0.0, 0.0],
        velocity: [0.0, 0.0, 0.0],
        mass: 1.989e30,
        radius: 696340000.0,
        color: '#FFFF00',
        bodyType: BodyType.star,
        stellarLuminosity: 3.828e26,
        temperature: 5778.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      );

      expect(star.name, equals('Sun'));
      expect(star.bodyType, equals(BodyType.star));
      expect(star.stellarLuminosity, equals(3.828e26));
      expect(star.temperature, equals(5778.0));
      expect(star.isPlanet, isFalse);
      expect(star.habitabilityStatus, equals(HabitabilityStatus.unknown));
    });

    test('should serialize to JSON correctly', () {
      final bodyData = BodyData(
        name: 'Mars',
        position: [227000000.0, 0.0, 0.0],
        velocity: [0.0, 24077.0, 0.0],
        mass: 6.417e23,
        radius: 3389500.0,
        color: '#FF4500',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 210.0,
        showGravityWell: true,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.tooCold,
      );

      final json = bodyData.toJson();

      expect(json['name'], equals('Mars'));
      expect(json['position'], equals([227000000.0, 0.0, 0.0]));
      expect(json['velocity'], equals([0.0, 24077.0, 0.0]));
      expect(json['mass'], equals(6.417e23));
      expect(json['radius'], equals(3389500.0));
      expect(json['color'], equals('#FF4500'));
      expect(json['bodyType'], equals('planet'));
      expect(json['stellarLuminosity'], equals(0.0));
      expect(json['temperature'], equals(210.0));
      expect(json['showGravityWell'], isTrue);
      expect(json['isPlanet'], isTrue);
      expect(json['habitabilityStatus'], equals('tooCold'));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'name': 'Venus',
        'position': [108200000.0, 0.0, 0.0],
        'velocity': [0.0, 35020.0, 0.0],
        'mass': 4.867e24,
        'radius': 6051800.0,
        'color': '#FFC649',
        'bodyType': 'planet',
        'stellarLuminosity': 0.0,
        'temperature': 737.0,
        'showGravityWell': false,
        'isPlanet': true,
        'habitabilityStatus': 'tooHot',
      };

      final bodyData = BodyData.fromJson(json);

      expect(bodyData.name, equals('Venus'));
      expect(bodyData.position, equals([108200000.0, 0.0, 0.0]));
      expect(bodyData.velocity, equals([0.0, 35020.0, 0.0]));
      expect(bodyData.mass, equals(4.867e24));
      expect(bodyData.radius, equals(6051800.0));
      expect(bodyData.color, equals('#FFC649'));
      expect(bodyData.bodyType, equals(BodyType.planet));
      expect(bodyData.stellarLuminosity, equals(0.0));
      expect(bodyData.temperature, equals(737.0));
      expect(bodyData.showGravityWell, isFalse);
      expect(bodyData.isPlanet, isTrue);
      expect(bodyData.habitabilityStatus, equals(HabitabilityStatus.tooHot));
    });

    test('should handle round-trip serialization', () {
      final original = BodyData(
        name: 'Asteroid Ceres',
        position: [413700000.0, 0.0, 0.0],
        velocity: [0.0, 17882.0, 0.0],
        mass: 9.1e20,
        radius: 473000.0,
        color: '#808080',
        bodyType: BodyType.asteroid,
        stellarLuminosity: 0.0,
        temperature: 167.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      );

      final json = original.toJson();
      final deserialized = BodyData.fromJson(json);

      expect(deserialized.name, equals(original.name));
      expect(deserialized.position, equals(original.position));
      expect(deserialized.velocity, equals(original.velocity));
      expect(deserialized.mass, equals(original.mass));
      expect(deserialized.radius, equals(original.radius));
      expect(deserialized.color, equals(original.color));
      expect(deserialized.bodyType, equals(original.bodyType));
      expect(
        deserialized.stellarLuminosity,
        equals(original.stellarLuminosity),
      );
      expect(deserialized.temperature, equals(original.temperature));
      expect(deserialized.showGravityWell, equals(original.showGravityWell));
      expect(deserialized.isPlanet, equals(original.isPlanet));
      expect(
        deserialized.habitabilityStatus,
        equals(original.habitabilityStatus),
      );
    });

    test('should handle all BodyType values', () {
      for (final bodyType in BodyType.values) {
        final bodyData = BodyData(
          name: 'Test Body',
          position: [0.0, 0.0, 0.0],
          velocity: [0.0, 0.0, 0.0],
          mass: 1.0,
          radius: 1.0,
          color: '#FFFFFF',
          bodyType: bodyType,
          stellarLuminosity: 0.0,
          temperature: 0.0,
          showGravityWell: false,
          isPlanet: false,
          habitabilityStatus: HabitabilityStatus.unknown,
        );

        final json = bodyData.toJson();
        final deserialized = BodyData.fromJson(json);

        expect(deserialized.bodyType, equals(bodyType));
      }
    });

    test('should handle all HabitabilityStatus values', () {
      for (final status in HabitabilityStatus.values) {
        final bodyData = BodyData(
          name: 'Test Body',
          position: [0.0, 0.0, 0.0],
          velocity: [0.0, 0.0, 0.0],
          mass: 1.0,
          radius: 1.0,
          color: '#FFFFFF',
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
          temperature: 0.0,
          showGravityWell: false,
          isPlanet: false,
          habitabilityStatus: status,
        );

        final json = bodyData.toJson();
        final deserialized = BodyData.fromJson(json);

        expect(deserialized.habitabilityStatus, equals(status));
      }
    });

    test('should handle invalid bodyType in JSON (falls back to planet)', () {
      final json = {
        'name': 'Test',
        'position': [0.0, 0.0, 0.0],
        'velocity': [0.0, 0.0, 0.0],
        'mass': 1.0,
        'radius': 1.0,
        'color': '#FFFFFF',
        'bodyType': 'invalidType',
        'stellarLuminosity': 0.0,
        'temperature': 0.0,
        'showGravityWell': false,
        'isPlanet': false,
        'habitabilityStatus': 'unknown',
      };

      final bodyData = BodyData.fromJson(json);

      expect(bodyData.bodyType, equals(BodyType.planet)); // fallback value
    });

    test(
      'should handle invalid habitabilityStatus in JSON (falls back to unknown)',
      () {
        final json = {
          'name': 'Test',
          'position': [0.0, 0.0, 0.0],
          'velocity': [0.0, 0.0, 0.0],
          'mass': 1.0,
          'radius': 1.0,
          'color': '#FFFFFF',
          'bodyType': 'planet',
          'stellarLuminosity': 0.0,
          'temperature': 0.0,
          'showGravityWell': false,
          'isPlanet': false,
          'habitabilityStatus': 'invalidStatus',
        };

        final bodyData = BodyData.fromJson(json);

        expect(
          bodyData.habitabilityStatus,
          equals(HabitabilityStatus.unknown),
        ); // fallback value
      },
    );

    test('should handle 3D position and velocity vectors', () {
      final bodyData = BodyData(
        name: 'Test 3D Body',
        position: [100.0, 200.0, 300.0],
        velocity: [10.0, 20.0, 30.0],
        mass: 1.0,
        radius: 1.0,
        color: '#FFFFFF',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 0.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      );

      expect(bodyData.position.length, equals(3));
      expect(bodyData.velocity.length, equals(3));
      expect(bodyData.position, equals([100.0, 200.0, 300.0]));
      expect(bodyData.velocity, equals([10.0, 20.0, 30.0]));

      // Test serialization maintains 3D vectors
      final json = bodyData.toJson();
      final deserialized = BodyData.fromJson(json);

      expect(deserialized.position, equals([100.0, 200.0, 300.0]));
      expect(deserialized.velocity, equals([10.0, 20.0, 30.0]));
    });

    test('should handle extreme values', () {
      final bodyData = BodyData(
        name: 'Extreme Body',
        position: [1e50, -1e50, 0.0],
        velocity: [1e10, -1e10, 1e5],
        mass: 1e100,
        radius: 1e20,
        color: '#000000',
        bodyType: BodyType.star,
        stellarLuminosity: 1e50,
        temperature: 1e6,
        showGravityWell: true,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.tooHot,
      );

      expect(bodyData.mass, equals(1e100));
      expect(bodyData.radius, equals(1e20));
      expect(bodyData.stellarLuminosity, equals(1e50));
      expect(bodyData.temperature, equals(1e6));

      // Test serialization with extreme values
      final json = bodyData.toJson();
      final deserialized = BodyData.fromJson(json);

      expect(deserialized.mass, equals(1e100));
      expect(deserialized.radius, equals(1e20));
      expect(deserialized.stellarLuminosity, equals(1e50));
      expect(deserialized.temperature, equals(1e6));
    });

    test('should handle minimum values', () {
      final bodyData = BodyData(
        name: '',
        position: [0.0, 0.0, 0.0],
        velocity: [0.0, 0.0, 0.0],
        mass: 0.0,
        radius: 0.0,
        color: '',
        bodyType: BodyType.asteroid,
        stellarLuminosity: 0.0,
        temperature: 0.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      );

      expect(bodyData.name, isEmpty);
      expect(bodyData.mass, equals(0.0));
      expect(bodyData.radius, equals(0.0));
      expect(bodyData.stellarLuminosity, equals(0.0));
      expect(bodyData.temperature, equals(0.0));
      expect(bodyData.color, isEmpty);

      // Test serialization with minimum values
      final json = bodyData.toJson();
      final deserialized = BodyData.fromJson(json);

      expect(deserialized.name, isEmpty);
      expect(deserialized.mass, equals(0.0));
      expect(deserialized.radius, equals(0.0));
      expect(deserialized.color, isEmpty);
    });
  });
}
