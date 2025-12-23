import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/core/enums/live_session_connection_status.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('Live Session Integration Tests', () {
    group('SimulationSnapshot Serialization', () {
      test('snapshot correctly serializes and deserializes bodies', () {
        final bodies = <Body>[
          Body(
            name: 'Star A',
            position: vm.Vector3(10.0, 20.0, 30.0),
            velocity: vm.Vector3(1.0, 2.0, 3.0),
            mass: 100.0,
            radius: 15.0,
            color: AppColors.stellarOType,
          ),
          Body(
            name: 'Planet B',
            position: vm.Vector3(100.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, 5.0, 0.0),
            mass: 1.0,
            radius: 5.0,
            color: AppColors.planetEarth,
          ),
        ];

        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: bodies,
          isRunning: true,
          timeScale: 4.0,
          totalTime: 200.0,
          stepCount: 2000,
        );

        // Serialize
        final map = snapshot.toMap();

        // Deserialize
        final restored = SimulationSnapshot.fromMap(map);

        expect(restored.bodies.length, equals(2));
        expect(restored.bodies.first.name, equals('Star A'));
        expect(restored.bodies.first.mass, equals(100.0));
        expect(restored.bodies.last.name, equals('Planet B'));
        expect(restored.isRunning, isTrue);
        expect(restored.timeScale, equals(4.0));
        expect(restored.totalTime, equals(200.0));
        expect(restored.stepCount, equals(2000));
      });

      test('snapshot handles empty body list', () {
        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: <Body>[],
          isRunning: false,
          timeScale: 1.0,
          totalTime: 0.0,
          stepCount: 0,
        );

        final map = snapshot.toMap();
        final restored = SimulationSnapshot.fromMap(map);

        expect(restored.bodies, isEmpty);
        expect(restored.isRunning, isFalse);
      });

      test('snapshot preserves vector precision', () {
        final body = Body(
          name: 'Precise Body',
          position: vm.Vector3(1.23456789, 2.34567890, 3.45678901),
          velocity: vm.Vector3(0.12345678, 0.23456789, 0.34567890),
          mass: 1.0,
          radius: 5.0,
          color: AppColors.uiWhite,
        );

        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: <Body>[body],
          isRunning: true,
          timeScale: 1.0,
          totalTime: 0.0,
          stepCount: 0,
        );

        final map = snapshot.toMap();
        final restored = SimulationSnapshot.fromMap(map);
        final restoredBody = restored.bodies.first;

        // Check position components with reasonable precision
        expect(restoredBody.position.x, closeTo(1.23456789, 0.0001));
        expect(restoredBody.position.y, closeTo(2.34567890, 0.0001));
        expect(restoredBody.position.z, closeTo(3.45678901, 0.0001));

        // Check velocity components
        expect(restoredBody.velocity.x, closeTo(0.12345678, 0.0001));
        expect(restoredBody.velocity.y, closeTo(0.23456789, 0.0001));
        expect(restoredBody.velocity.z, closeTo(0.34567890, 0.0001));
      });

      test('snapshot preserves color values', () {
        final body = Body(
          name: 'Colored Body',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 5.0,
          color: AppColors.stellarGType,
        );

        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: <Body>[body],
          isRunning: false,
          timeScale: 1.0,
          totalTime: 0.0,
          stepCount: 0,
        );

        final map = snapshot.toMap();
        final restored = SimulationSnapshot.fromMap(map);
        final restoredBody = restored.bodies.first;

        expect(restoredBody.colorValue, equals(AppColors.stellarGType.value));
      });

      test('body snapshot can be converted back to Body', () {
        final originalBody = Body(
          name: 'Original',
          position: vm.Vector3(50.0, 100.0, 150.0),
          velocity: vm.Vector3(1.0, 2.0, 3.0),
          mass: 10.0,
          radius: 8.0,
          color: AppColors.stellarMType,
        );

        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: <Body>[originalBody],
          isRunning: true,
          timeScale: 2.0,
          totalTime: 100.0,
          stepCount: 1000,
        );

        final map = snapshot.toMap();
        final restored = SimulationSnapshot.fromMap(map);
        final restoredBodySnapshot = restored.bodies.first;
        final recreatedBody = restoredBodySnapshot.toBody();

        expect(recreatedBody.name, equals('Original'));
        expect(recreatedBody.position.x, equals(50.0));
        expect(recreatedBody.position.y, equals(100.0));
        expect(recreatedBody.position.z, equals(150.0));
        expect(recreatedBody.mass, equals(10.0));
        expect(recreatedBody.radius, equals(8.0));
      });
    });

    group('LiveSession Model', () {
      test('creates session from map correctly', () {
        final now = DateTime.now();
        final map = <String, dynamic>{
          'hostId': 'user-123',
          'hostName': 'TestHost',
          'scenarioName': 'Solar System',
          'isRunning': true,
          'timeScale': 4.0,
          'viewerCount': 5,
          'createdAt': now.millisecondsSinceEpoch,
          'updatedAt': now.millisecondsSinceEpoch,
        };

        final session = LiveSession.fromMap('session-abc', map);

        expect(session.id, equals('session-abc'));
        expect(session.hostId, equals('user-123'));
        expect(session.hostName, equals('TestHost'));
        expect(session.scenarioName, equals('Solar System'));
        expect(session.isRunning, isTrue);
        expect(session.timeScale, equals(4.0));
        expect(session.viewerCount, equals(5));
      });

      test('handles missing fields with defaults', () {
        final session = LiveSession.fromMap('session-123', <String, dynamic>{});

        expect(session.id, equals('session-123'));
        expect(session.hostId, isEmpty);
        expect(session.hostName, equals('Unknown'));
        expect(session.scenarioName, equals('Custom'));
        expect(session.isRunning, isFalse);
        expect(session.timeScale, equals(1.0));
        expect(session.viewerCount, equals(0));
      });

      test('session serializes to map correctly', () {
        final now = DateTime.now();
        final session = LiveSession(
          id: 'test-session',
          hostId: 'host-001',
          hostName: 'Alice',
          scenarioName: 'Binary Stars',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );

        final map = session.toMap();

        expect(map['hostId'], equals('host-001'));
        expect(map['hostName'], equals('Alice'));
        expect(map['scenarioName'], equals('Binary Stars'));
        expect(map['isRunning'], isTrue);
        expect(map['timeScale'], equals(2.0));
        expect(map['viewerCount'], equals(3));
      });
    });

    group('LiveSessionConnectionStatus', () {
      test('connected status indicates active connection', () {
        const status = LiveSessionConnectionStatus.connected;
        expect(status.isActive, isTrue);
        expect(status.isConnecting, isFalse);
        expect(status.hasIssue, isFalse);
      });

      test('connecting status indicates connection in progress', () {
        const status = LiveSessionConnectionStatus.connecting;
        expect(status.isActive, isFalse);
        expect(status.isConnecting, isTrue);
        expect(status.hasIssue, isFalse);
      });

      test('reconnecting status indicates both active and issue', () {
        const status = LiveSessionConnectionStatus.reconnecting;
        expect(status.isActive, isTrue);
        expect(status.isConnecting, isTrue);
        expect(status.hasIssue, isTrue);
      });

      test('error status indicates issue', () {
        const status = LiveSessionConnectionStatus.error;
        expect(status.isActive, isFalse);
        expect(status.isConnecting, isFalse);
        expect(status.hasIssue, isTrue);
      });

      test('disconnected status indicates no connection', () {
        const status = LiveSessionConnectionStatus.disconnected;
        expect(status.isActive, isFalse);
        expect(status.isConnecting, isFalse);
        expect(status.hasIssue, isFalse);
      });

      test('all statuses have localization keys', () {
        for (final status in LiveSessionConnectionStatus.values) {
          expect(status.localizationKey, isNotEmpty);
          expect(status.localizationKey, startsWith('liveSessionStatus'));
        }
      });
    });

    group('BodySnapshot Operations', () {
      test('applyTo updates existing body state', () {
        final targetBody = Body(
          name: 'Target',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 5.0,
          color: AppColors.uiWhite,
        );

        final sourceBody = Body(
          name: 'Target', // Same name for matching
          position: vm.Vector3(100.0, 200.0, 300.0),
          velocity: vm.Vector3(10.0, 20.0, 30.0),
          mass: 50.0,
          radius: 15.0,
          color: AppColors.stellarBType,
        );

        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: <Body>[sourceBody],
          isRunning: true,
          timeScale: 1.0,
          totalTime: 0.0,
          stepCount: 0,
        );

        final map = snapshot.toMap();
        final restored = SimulationSnapshot.fromMap(map);
        final bodySnapshot = restored.bodies.first;

        // Apply snapshot to target body
        bodySnapshot.applyTo(targetBody);

        expect(targetBody.position.x, equals(100.0));
        expect(targetBody.position.y, equals(200.0));
        expect(targetBody.position.z, equals(300.0));
        expect(targetBody.mass, equals(50.0));
        expect(targetBody.radius, equals(15.0));
      });

      test('handles multiple bodies in simulation', () {
        final bodies = <Body>[];
        for (int i = 0; i < 10; i++) {
          bodies.add(
            Body(
              name: 'Body $i',
              position: vm.Vector3(i * 10.0, i * 20.0, i * 30.0),
              velocity: vm.Vector3.zero(),
              mass: i + 1.0,
              radius: (i + 1) * 2.0,
              color: AppColors.uiWhite,
            ),
          );
        }

        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: bodies,
          isRunning: true,
          timeScale: 8.0,
          totalTime: 500.0,
          stepCount: 5000,
        );

        final map = snapshot.toMap();
        final restored = SimulationSnapshot.fromMap(map);

        expect(restored.bodies.length, equals(10));

        for (int i = 0; i < 10; i++) {
          expect(restored.bodies[i].name, equals('Body $i'));
          expect(restored.bodies[i].mass, equals(i + 1.0));
        }
      });
    });

    group('End-to-End Serialization', () {
      test('complete simulation state roundtrips correctly', () {
        // Create a complex simulation scenario
        final bodies = <Body>[
          Body(
            name: 'Sun',
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 50.0,
            color: AppColors.stellarGType,
          ),
          Body(
            name: 'Mercury',
            position: vm.Vector3(100.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, 15.0, 0.0),
            mass: 0.5,
            radius: 3.0,
            color: AppColors.planetMercury,
          ),
          Body(
            name: 'Venus',
            position: vm.Vector3(150.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, 12.0, 0.0),
            mass: 0.8,
            radius: 5.0,
            color: AppColors.planetVenus,
          ),
          Body(
            name: 'Earth',
            position: vm.Vector3(200.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, 10.0, 0.0),
            mass: 1.0,
            radius: 6.0,
            color: AppColors.planetEarth,
          ),
        ];

        final originalSnapshot = SimulationSnapshot.fromSimulation(
          bodies: bodies,
          isRunning: true,
          timeScale: 4.0,
          totalTime: 365.25,
          stepCount: 8766,
        );

        // Simulate network transmission (serialize -> deserialize)
        final map = originalSnapshot.toMap();
        final receivedSnapshot = SimulationSnapshot.fromMap(map);

        // Verify all data survived roundtrip
        expect(receivedSnapshot.bodies.length, equals(4));
        expect(receivedSnapshot.isRunning, equals(originalSnapshot.isRunning));
        expect(receivedSnapshot.timeScale, equals(originalSnapshot.timeScale));
        expect(receivedSnapshot.totalTime, equals(originalSnapshot.totalTime));
        expect(receivedSnapshot.stepCount, equals(originalSnapshot.stepCount));

        // Verify each body
        final bodyNames = ['Sun', 'Mercury', 'Venus', 'Earth'];
        for (int i = 0; i < bodyNames.length; i++) {
          expect(receivedSnapshot.bodies[i].name, equals(bodyNames[i]));
        }
      });

      test('simulation state can be applied to recreate bodies', () {
        final originalBodies = <Body>[
          Body(
            name: 'Alpha',
            position: vm.Vector3(10.0, 20.0, 30.0),
            velocity: vm.Vector3(1.0, 2.0, 3.0),
            mass: 5.0,
            radius: 10.0,
            color: AppColors.stellarOType,
          ),
          Body(
            name: 'Beta',
            position: vm.Vector3(50.0, 60.0, 70.0),
            velocity: vm.Vector3(4.0, 5.0, 6.0),
            mass: 8.0,
            radius: 12.0,
            color: AppColors.stellarAType,
          ),
        ];

        final snapshot = SimulationSnapshot.fromSimulation(
          bodies: originalBodies,
          isRunning: true,
          timeScale: 2.0,
          totalTime: 100.0,
          stepCount: 1000,
        );

        // Serialize and deserialize (simulating network transmission)
        final map = snapshot.toMap();
        final receivedSnapshot = SimulationSnapshot.fromMap(map);

        // Recreate bodies on the viewing end
        final recreatedBodies =
            receivedSnapshot.bodies.map((bs) => bs.toBody()).toList();

        expect(recreatedBodies.length, equals(2));

        // Verify Alpha
        expect(recreatedBodies[0].name, equals('Alpha'));
        expect(recreatedBodies[0].position.x, equals(10.0));
        expect(recreatedBodies[0].mass, equals(5.0));

        // Verify Beta
        expect(recreatedBodies[1].name, equals('Beta'));
        expect(recreatedBodies[1].position.x, equals(50.0));
        expect(recreatedBodies[1].mass, equals(8.0));
      });
    });
  });
}
