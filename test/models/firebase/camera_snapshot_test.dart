import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/firebase/camera_snapshot.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CameraSnapshot', () {
    group('constructor', () {
      test('should create snapshot with all properties', () {
        final target = vm.Vector3(10.0, 20.0, 30.0);
        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.1,
          distance: 500.0,
          target: target,
          followMode: true,
          followedBodyIndex: 2,
          selectedBody: 1,
          autoRotate: true,
          fieldOfView: 75.0,
        );

        expect(snapshot.yaw, equals(0.5));
        expect(snapshot.pitch, equals(0.3));
        expect(snapshot.roll, equals(0.1));
        expect(snapshot.distance, equals(500.0));
        expect(snapshot.target.x, equals(10.0));
        expect(snapshot.target.y, equals(20.0));
        expect(snapshot.target.z, equals(30.0));
        expect(snapshot.followMode, isTrue);
        expect(snapshot.followedBodyIndex, equals(2));
        expect(snapshot.selectedBody, equals(1));
        expect(snapshot.autoRotate, isTrue);
        expect(snapshot.fieldOfView, equals(75.0));
      });

      test('should create snapshot with optional null values', () {
        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          followedBodyIndex: null,
          selectedBody: null,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        expect(snapshot.followedBodyIndex, isNull);
        expect(snapshot.selectedBody, isNull);
      });
    });

    group('toMap', () {
      test('should serialize all properties correctly', () {
        final target = vm.Vector3(10.0, 20.0, 30.0);
        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.1,
          distance: 500.0,
          target: target,
          followMode: true,
          followedBodyIndex: 2,
          selectedBody: 1,
          autoRotate: true,
          fieldOfView: 75.0,
        );

        final map = snapshot.toMap();

        expect(map['yaw'], equals(0.5));
        expect(map['pitch'], equals(0.3));
        expect(map['roll'], equals(0.1));
        expect(map['distance'], equals(500.0));
        expect(map['target'], equals([10.0, 20.0, 30.0]));
        expect(map['followMode'], isTrue);
        expect(map['followedBodyIndex'], equals(2));
        expect(map['selectedBody'], equals(1));
        expect(map['autoRotate'], isTrue);
        expect(map['fieldOfView'], equals(75.0));
      });

      test('should omit null optional fields', () {
        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          followedBodyIndex: null,
          selectedBody: null,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        final map = snapshot.toMap();

        expect(map.containsKey('followedBodyIndex'), isFalse);
        expect(map.containsKey('selectedBody'), isFalse);
      });
    });

    group('fromMap', () {
      test('should deserialize all properties correctly', () {
        final map = {
          'yaw': 0.5,
          'pitch': 0.3,
          'roll': 0.1,
          'distance': 500.0,
          'target': [10.0, 20.0, 30.0],
          'followMode': true,
          'followedBodyIndex': 2,
          'selectedBody': 1,
          'autoRotate': true,
          'fieldOfView': 75.0,
        };

        final snapshot = CameraSnapshot.fromMap(map);

        expect(snapshot.yaw, equals(0.5));
        expect(snapshot.pitch, equals(0.3));
        expect(snapshot.roll, equals(0.1));
        expect(snapshot.distance, equals(500.0));
        expect(snapshot.target.x, equals(10.0));
        expect(snapshot.target.y, equals(20.0));
        expect(snapshot.target.z, equals(30.0));
        expect(snapshot.followMode, isTrue);
        expect(snapshot.followedBodyIndex, equals(2));
        expect(snapshot.selectedBody, equals(1));
        expect(snapshot.autoRotate, isTrue);
        expect(snapshot.fieldOfView, equals(75.0));
      });

      test('should use default values for missing fields', () {
        final map = <String, dynamic>{};

        final snapshot = CameraSnapshot.fromMap(map);

        expect(snapshot.yaw, equals(0.6));
        expect(snapshot.pitch, equals(0.3));
        expect(snapshot.roll, equals(0.0));
        expect(snapshot.distance, equals(300.0));
        expect(snapshot.target.x, equals(0.0));
        expect(snapshot.target.y, equals(0.0));
        expect(snapshot.target.z, equals(0.0));
        expect(snapshot.followMode, isFalse);
        expect(snapshot.followedBodyIndex, isNull);
        expect(snapshot.selectedBody, isNull);
        expect(snapshot.autoRotate, isFalse);
        expect(snapshot.fieldOfView, equals(60.0));
      });

      test('should handle int values for doubles', () {
        final map = {
          'yaw': 1,
          'pitch': 0,
          'roll': 0,
          'distance': 500,
          'target': [10, 20, 30],
          'followMode': false,
          'autoRotate': false,
          'fieldOfView': 60,
        };

        final snapshot = CameraSnapshot.fromMap(map);

        expect(snapshot.yaw, equals(1.0));
        expect(snapshot.distance, equals(500.0));
        expect(snapshot.target.x, equals(10.0));
        expect(snapshot.fieldOfView, equals(60.0));
      });

      test('should handle malformed target array', () {
        final map = {
          'yaw': 0.5,
          'pitch': 0.3,
          'roll': 0.0,
          'distance': 300.0,
          'target': [10.0], // Invalid - only 1 element
          'followMode': false,
          'autoRotate': false,
          'fieldOfView': 60.0,
        };

        final snapshot = CameraSnapshot.fromMap(map);

        // Should fall back to zero vector
        expect(snapshot.target.x, equals(0.0));
        expect(snapshot.target.y, equals(0.0));
        expect(snapshot.target.z, equals(0.0));
      });

      test('should handle null target', () {
        final map = {
          'yaw': 0.5,
          'pitch': 0.3,
          'roll': 0.0,
          'distance': 300.0,
          'target': null,
          'followMode': false,
          'autoRotate': false,
          'fieldOfView': 60.0,
        };

        final snapshot = CameraSnapshot.fromMap(map);

        expect(snapshot.target.x, equals(0.0));
        expect(snapshot.target.y, equals(0.0));
        expect(snapshot.target.z, equals(0.0));
      });
    });

    group('roundtrip serialization', () {
      test('should preserve all values through toMap/fromMap', () {
        final target = vm.Vector3(10.0, 20.0, 30.0);
        final original = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.1,
          distance: 500.0,
          target: target,
          followMode: true,
          followedBodyIndex: 2,
          selectedBody: 1,
          autoRotate: true,
          fieldOfView: 75.0,
        );

        final map = original.toMap();
        final restored = CameraSnapshot.fromMap(map);

        expect(restored.yaw, equals(original.yaw));
        expect(restored.pitch, equals(original.pitch));
        expect(restored.roll, equals(original.roll));
        expect(restored.distance, equals(original.distance));
        expect(restored.target.x, equals(original.target.x));
        expect(restored.target.y, equals(original.target.y));
        expect(restored.target.z, equals(original.target.z));
        expect(restored.followMode, equals(original.followMode));
        expect(restored.followedBodyIndex, equals(original.followedBodyIndex));
        expect(restored.selectedBody, equals(original.selectedBody));
        expect(restored.autoRotate, equals(original.autoRotate));
        expect(restored.fieldOfView, equals(original.fieldOfView));
      });

      test('should preserve snapshot without optional fields', () {
        final original = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: false,
          followedBodyIndex: null,
          selectedBody: null,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        final map = original.toMap();
        final restored = CameraSnapshot.fromMap(map);

        expect(restored.followedBodyIndex, isNull);
        expect(restored.selectedBody, isNull);
      });
    });

    group('toString', () {
      test('should return readable format', () {
        final snapshot = CameraSnapshot(
          yaw: 0.5,
          pitch: 0.3,
          roll: 0.0,
          distance: 300.0,
          target: vm.Vector3.zero(),
          followMode: true,
          followedBodyIndex: 1,
          selectedBody: 2,
          autoRotate: false,
          fieldOfView: 60.0,
        );

        final str = snapshot.toString();

        expect(str, contains('CameraSnapshot'));
        expect(str, contains('yaw'));
        expect(str, contains('pitch'));
        expect(str, contains('followMode'));
      });
    });
  });
}
