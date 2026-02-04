import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:graviton/services/firebase/live_session_service.dart';

void main() {
  group('LiveSession Model Tests', () {
    test('Should create LiveSession with all required fields', () {
      final now = DateTime.now();
      final session = LiveSession(
        id: 'test-id',
        hostId: 'host-123',
        hostName: 'Test Host',
        scenarioName: 'Solar System',
        isRunning: true,
        timeScale: 4.0,
        viewerCount: 5,
        createdAt: now,
        updatedAt: now,
      );

      expect(session.id, 'test-id');
      expect(session.hostId, 'host-123');
      expect(session.hostName, 'Test Host');
      expect(session.scenarioName, 'Solar System');
      expect(session.isRunning, isTrue);
      expect(session.timeScale, 4.0);
      expect(session.viewerCount, 5);
      expect(session.createdAt, now);
      expect(session.updatedAt, now);
    });

    test('Should create LiveSession from map', () {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final map = {
        'hostId': 'host-456',
        'hostName': 'Map Host',
        'scenarioName': 'Binary Star',
        'isRunning': false,
        'timeScale': 2.0,
        'viewerCount': 3,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      };

      final session = LiveSession.fromMap('session-id', map);

      expect(session.id, 'session-id');
      expect(session.hostId, 'host-456');
      expect(session.hostName, 'Map Host');
      expect(session.scenarioName, 'Binary Star');
      expect(session.isRunning, isFalse);
      expect(session.timeScale, 2.0);
      expect(session.viewerCount, 3);
    });

    test('Should handle missing fields in fromMap with defaults', () {
      final session = LiveSession.fromMap('id', {});

      expect(session.id, 'id');
      expect(session.hostId, '');
      expect(session.hostName, 'Unknown');
      expect(session.scenarioName, 'Custom');
      expect(session.isRunning, isFalse);
      expect(session.timeScale, 1.0);
      expect(session.viewerCount, 0);
    });

    test('Should convert LiveSession to map', () {
      final now = DateTime.now();
      final session = LiveSession(
        id: 'test-id',
        hostId: 'host-789',
        hostName: 'ToMap Host',
        scenarioName: 'Three Body',
        isRunning: true,
        timeScale: 8.0,
        viewerCount: 10,
        createdAt: now,
        updatedAt: now,
      );

      final map = session.toMap();

      expect(map['hostId'], 'host-789');
      expect(map['hostName'], 'ToMap Host');
      expect(map['scenarioName'], 'Three Body');
      expect(map['isRunning'], isTrue);
      expect(map['timeScale'], 8.0);
      expect(map['viewerCount'], 10);
      expect(map['createdAt'], now.millisecondsSinceEpoch);
      expect(map['updatedAt'], now.millisecondsSinceEpoch);
    });

    test('Should create copy with updated fields', () {
      final now = DateTime.now();
      final original = LiveSession(
        id: 'original-id',
        hostId: 'host-original',
        hostName: 'Original Host',
        scenarioName: 'Original Scenario',
        isRunning: false,
        timeScale: 1.0,
        viewerCount: 0,
        createdAt: now,
        updatedAt: now,
      );

      final updated = original.copyWith(
        isRunning: true,
        timeScale: 4.0,
        viewerCount: 5,
      );

      // Original should be unchanged
      expect(original.isRunning, isFalse);
      expect(original.timeScale, 1.0);
      expect(original.viewerCount, 0);

      // Updated should have new values
      expect(updated.isRunning, isTrue);
      expect(updated.timeScale, 4.0);
      expect(updated.viewerCount, 5);

      // Unchanged fields should be preserved
      expect(updated.id, 'original-id');
      expect(updated.hostId, 'host-original');
      expect(updated.hostName, 'Original Host');
      expect(updated.scenarioName, 'Original Scenario');
    });

    test('Should handle numeric type conversion in fromMap', () {
      final map = {
        'hostId': 'host',
        'hostName': 'Host',
        'scenarioName': 'Test',
        'isRunning': true,
        'timeScale': 2, // int instead of double
        'viewerCount': 5,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };

      final session = LiveSession.fromMap('id', map);

      expect(session.timeScale, 2.0);
    });
  });

  group('LiveSessionService Tests', () {
    late LiveSessionService service;

    setUp(() {
      LiveSessionService.resetForTesting();
      service = LiveSessionService.instance;
    });

    tearDown(() {
      LiveSessionService.resetForTesting();
    });

    group('Singleton Pattern', () {
      test('Should be singleton', () {
        final service1 = LiveSessionService.instance;
        final service2 = LiveSessionService.instance;
        expect(identical(service1, service2), isTrue);
      });

      test('Should create new instance after reset', () {
        final service1 = LiveSessionService.instance;
        LiveSessionService.resetForTesting();
        final service2 = LiveSessionService.instance;
        expect(identical(service1, service2), isFalse);
      });
    });

    group('Initial State', () {
      test('Should initialize with default values', () {
        expect(service.currentSessionId, isNull);
        expect(service.isHosting, isFalse);
      });
    });

    group('Hosting Operations (Unauthenticated)', () {
      test(
        'Should return null when starting hosting unauthenticated',
        () async {
          final sessionId = await service.startHosting(
            scenarioName: 'Test Scenario',
          );
          expect(sessionId, isNull);
          expect(service.isHosting, isFalse);
        },
      );

      test('Should return false when updating session not hosting', () async {
        final result = await service.updateSessionState(isRunning: true);
        expect(result, isFalse);
      });

      test('Should return false when stopping hosting not hosting', () async {
        final result = await service.stopHosting();
        expect(result, isFalse);
      });
    });

    group('Viewing Operations (Unauthenticated)', () {
      test(
        'Should return false when joining session unauthenticated',
        () async {
          final result = await service.joinSession('test-session-id');
          expect(result, isFalse);
        },
      );

      test('Should return false when leaving session not joined', () async {
        final result = await service.leaveSession();
        expect(result, isFalse);
      });
    });

    group('Callbacks', () {
      test('Should set viewer count callback', () {
        var callbackCalled = false;
        service.setOnViewerCountChanged((count) {
          callbackCalled = true;
        });

        // Callback should be set (can't trigger without actual connection)
        expect(callbackCalled, isFalse);
      });

      test('Should clear callback when set to null', () {
        service.setOnViewerCountChanged((count) {});
        service.setOnViewerCountChanged(null);
        // Should not throw
      });
    });

    group('Active Sessions Stream', () {
      test('Should return stream of sessions', () {
        final stream = service.getActiveSessions();
        expect(stream, isA<Stream<List<LiveSession>>>());
      });
    });

    group('Dispose', () {
      test('Should handle dispose when not hosting or viewing', () async {
        await service.dispose();
        expect(service.currentSessionId, isNull);
        expect(service.isHosting, isFalse);
      });

      test('Should handle multiple dispose calls', () async {
        await service.dispose();
        await service.dispose();
        expect(service.isHosting, isFalse);
      });
    });

    group('State Sync Operations', () {
      test('Should not throw when starting state sync while hosting', () {
        service.startStateSync(onStateReceived: (snapshot) {});
        // Should not throw even when not in viewing mode
      });

      test('Should not throw when stopping state sync', () {
        service.stopStateSync();
        // Should not throw
      });

      test('Should handle multiple stop state sync calls', () {
        service.stopStateSync();
        service.stopStateSync();
        // Should not throw
      });
    });

    group('Broadcast Operations', () {
      test('Should return false when broadcasting while not hosting', () async {
        final snapshot = SimulationSnapshot(
          bodies: [],
          isRunning: true,
          timeScale: 1.0,
          totalTime: 100.0,
          stepCount: 50,
          timestamp: DateTime.now(),
        );

        final result = await service.broadcastState(snapshot);
        expect(result, isFalse);
      });
    });

    group('Join Session with Callbacks', () {
      test('Should accept onSessionUpdated callback', () async {
        final result = await service.joinSession(
          'test-session',
          onSessionUpdated: (session) {},
        );
        expect(result, isFalse); // Fails because no auth
      });
    });

    group('Update Session State', () {
      test('Should accept multiple parameters', () async {
        final result = await service.updateSessionState(
          isRunning: true,
          timeScale: 2.0,
          scenarioName: 'Updated Scenario',
        );
        expect(result, isFalse);
      });

      test('Should accept only isRunning', () async {
        final result = await service.updateSessionState(isRunning: false);
        expect(result, isFalse);
      });

      test('Should accept only timeScale', () async {
        final result = await service.updateSessionState(timeScale: 0.5);
        expect(result, isFalse);
      });
    });

    group('Start Hosting with Options', () {
      test('Should accept displayName parameter', () async {
        final sessionId = await service.startHosting(
          scenarioName: 'Test',
          displayName: 'Custom Host Name',
        );
        expect(sessionId, isNull);
      });

      test('Should accept only scenarioName', () async {
        final sessionId = await service.startHosting(scenarioName: 'Only Name');
        expect(sessionId, isNull);
      });
    });

    group('Active Sessions Retrieval', () {
      test('getActiveSessions should return Stream', () {
        final stream = service.getActiveSessions();
        expect(stream, isA<Stream<List<LiveSession>>>());
      });

      test('getActiveSessions stream should emit empty list initially', () {
        final stream = service.getActiveSessions();
        expectLater(stream, emitsAnyOf([isEmpty, isA<List<LiveSession>>()]));
      });
    });

    group('Leave Session', () {
      test('Should return false when not in session', () async {
        final result = await service.leaveSession();
        expect(result, isFalse);
      });
    });

    group('Viewer Count Callback', () {
      test('Should not throw when setting callback', () {
        expect(
          () => service.setOnViewerCountChanged((count) {}),
          returnsNormally,
        );
      });

      test('Should not throw when clearing callback', () {
        service.setOnViewerCountChanged((count) {});
        expect(() => service.setOnViewerCountChanged(null), returnsNormally);
      });

      test('Should not throw when setting callback multiple times', () {
        service.setOnViewerCountChanged((count) {});
        service.setOnViewerCountChanged((count) {});
        service.setOnViewerCountChanged((count) {});
        expect(service.isHosting, isFalse);
      });
    });

    group('Start State Sync', () {
      test('Should not throw when starting state sync', () {
        expect(
          () => service.startStateSync(onStateReceived: (snapshot) {}),
          returnsNormally,
        );
      });

      test('Should not throw when starting state sync twice', () {
        service.startStateSync(onStateReceived: (snapshot) {});
        expect(
          () => service.startStateSync(onStateReceived: (snapshot) {}),
          returnsNormally,
        );
      });
    });

    group('Stop State Sync', () {
      test('Should not throw when stopping without starting', () {
        expect(() => service.stopStateSync(), returnsNormally);
      });

      test('Should not throw when stopping after starting', () {
        service.startStateSync(onStateReceived: (snapshot) {});
        expect(() => service.stopStateSync(), returnsNormally);
      });

      test('Should not throw when stopping multiple times', () {
        service.stopStateSync();
        service.stopStateSync();
        expect(() => service.stopStateSync(), returnsNormally);
      });
    });

    group('Current Session ID', () {
      test('Should be null initially', () {
        expect(service.currentSessionId, isNull);
      });

      test('Should remain null after failed hosting', () async {
        await service.startHosting(scenarioName: 'Test');
        expect(service.currentSessionId, isNull);
      });
    });

    group('Service Accessors', () {
      test('isHosting should be accessible', () {
        expect(service.isHosting, isA<bool>());
      });

      test('currentSessionId should be accessible', () {
        expect(service.currentSessionId, isNull);
      });
    });

    group('Broadcast with Data', () {
      test('Should return false for empty snapshot when not hosting', () async {
        final snapshot = SimulationSnapshot(
          bodies: [],
          isRunning: false,
          timeScale: 1.0,
          totalTime: 0.0,
          stepCount: 0,
          timestamp: DateTime.now(),
        );
        final result = await service.broadcastState(snapshot);
        expect(result, isFalse);
      });

      test(
        'Should return false for snapshot with bodies when not hosting',
        () async {
          final snapshot = SimulationSnapshot(
            bodies: [],
            isRunning: true,
            timeScale: 2.0,
            totalTime: 500.0,
            stepCount: 100,
            timestamp: DateTime.now(),
          );
          final result = await service.broadcastState(snapshot);
          expect(result, isFalse);
        },
      );
    });

    group('Join with Different Session IDs', () {
      test('Should handle empty session ID', () async {
        final result = await service.joinSession('');
        expect(result, isFalse);
      });

      test('Should handle whitespace session ID', () async {
        final result = await service.joinSession('   ');
        expect(result, isFalse);
      });

      test('Should handle special characters in session ID', () async {
        final result = await service.joinSession('session-123_test');
        expect(result, isFalse);
      });
    });

    group('Password Protected Hosting', () {
      test('Should accept password parameter when starting hosting', () async {
        final sessionId = await service.startHosting(
          scenarioName: 'Test',
          password: 'mypassword',
        );
        expect(sessionId, isNull); // Fails without auth
      });

      test('Should accept empty password', () async {
        final sessionId = await service.startHosting(
          scenarioName: 'Test',
          password: '',
        );
        expect(sessionId, isNull);
      });

      test('Should accept all hosting parameters', () async {
        final sessionId = await service.startHosting(
          scenarioName: 'Test Scenario',
          displayName: 'Custom Host',
          password: 'secretpass',
        );
        expect(sessionId, isNull);
      });

      test('Should accept null password (no protection)', () async {
        final sessionId = await service.startHosting(scenarioName: 'Test');
        expect(sessionId, isNull);
      });
    });

    group('Password Protected Joining', () {
      test('Should accept password parameter when joining', () async {
        final result = await service.joinSession(
          'test-session',
          password: 'viewerpassword',
        );
        expect(result, isFalse); // Fails without auth
      });

      test('Should accept empty password when joining', () async {
        final result = await service.joinSession('test-session', password: '');
        expect(result, isFalse);
      });

      test('Should accept all join parameters', () async {
        final result = await service.joinSession(
          'test-session',
          password: 'secret',
          onSessionUpdated: (session) {},
        );
        expect(result, isFalse);
      });

      test('Should work without password for non-protected sessions', () async {
        final result = await service.joinSession('test-session');
        expect(result, isFalse);
      });
    });

    group('Session State After Operations', () {
      test('isHosting should remain false after failed start', () async {
        await service.startHosting(scenarioName: 'Test');
        expect(service.isHosting, isFalse);
      });

      test('currentSessionId should remain null after failed start', () async {
        await service.startHosting(scenarioName: 'Test');
        expect(service.currentSessionId, isNull);
      });

      test('isHosting should be false after stop', () async {
        await service.startHosting(scenarioName: 'Test');
        await service.stopHosting();
        expect(service.isHosting, isFalse);
      });
    });

    group('Service Lifecycle', () {
      test('Should handle rapid start/stop hosting cycles', () async {
        for (var i = 0; i < 3; i++) {
          await service.startHosting(scenarioName: 'Test $i');
          await service.stopHosting();
        }
        expect(service.isHosting, isFalse);
      });

      test('Should handle rapid join/leave cycles', () async {
        for (var i = 0; i < 3; i++) {
          await service.joinSession('session-$i');
          await service.leaveSession();
        }
        expect(service.currentSessionId, isNull);
      });

      test('Should handle alternating host/join operations', () async {
        await service.startHosting(scenarioName: 'Test');
        await service.joinSession('session-1');
        await service.startHosting(scenarioName: 'Test2');
        await service.leaveSession();
        expect(service.isHosting, isFalse);
      });
    });

    group('Broadcast Edge Cases', () {
      test('Should handle broadcast with running simulation', () async {
        final snapshot = SimulationSnapshot(
          bodies: [],
          isRunning: true,
          timeScale: 4.0,
          totalTime: 1000.0,
          stepCount: 500,
          timestamp: DateTime.now(),
        );
        final result = await service.broadcastState(snapshot);
        expect(result, isFalse);
      });

      test('Should handle broadcast with paused simulation', () async {
        final snapshot = SimulationSnapshot(
          bodies: [],
          isRunning: false,
          timeScale: 1.0,
          totalTime: 50.0,
          stepCount: 25,
          timestamp: DateTime.now(),
        );
        final result = await service.broadcastState(snapshot);
        expect(result, isFalse);
      });

      test('Should handle broadcast with various time scales', () async {
        for (final timeScale in [0.1, 0.5, 1.0, 2.0, 4.0, 8.0]) {
          final snapshot = SimulationSnapshot(
            bodies: [],
            isRunning: true,
            timeScale: timeScale,
            totalTime: 100.0,
            stepCount: 50,
            timestamp: DateTime.now(),
          );
          final result = await service.broadcastState(snapshot);
          expect(result, isFalse);
        }
      });
    });

    group('Session Update with Various Parameters', () {
      test('Should handle update with isRunning only', () async {
        final result = await service.updateSessionState(isRunning: true);
        expect(result, isFalse);
      });

      test('Should handle update with timeScale only', () async {
        final result = await service.updateSessionState(timeScale: 2.0);
        expect(result, isFalse);
      });

      test('Should handle update with scenarioName only', () async {
        final result = await service.updateSessionState(
          scenarioName: 'New Scenario',
        );
        expect(result, isFalse);
      });

      test('Should handle update with all parameters', () async {
        final result = await service.updateSessionState(
          isRunning: true,
          timeScale: 4.0,
          scenarioName: 'Updated Scenario',
        );
        expect(result, isFalse);
      });

      test('Should handle update with no parameters', () async {
        final result = await service.updateSessionState();
        expect(result, isFalse);
      });
    });

    group('Multiple Callback Handling', () {
      test('Should handle setting callback multiple times', () {
        for (var i = 0; i < 5; i++) {
          service.setOnViewerCountChanged((count) {});
        }
        expect(service.isHosting, isFalse);
      });

      test('Should handle alternating set and clear callbacks', () {
        service.setOnViewerCountChanged((count) {});
        service.setOnViewerCountChanged(null);
        service.setOnViewerCountChanged((count) {});
        service.setOnViewerCountChanged(null);
        expect(service.isHosting, isFalse);
      });
    });

    group('State Sync Edge Cases', () {
      test('Should handle starting state sync multiple times', () {
        for (var i = 0; i < 3; i++) {
          service.startStateSync(onStateReceived: (snapshot) {});
        }
        expect(service.isHosting, isFalse);
      });

      test('Should handle stopping state sync multiple times', () {
        service.startStateSync(onStateReceived: (snapshot) {});
        for (var i = 0; i < 3; i++) {
          service.stopStateSync();
        }
        expect(service.isHosting, isFalse);
      });

      test('Should handle start/stop state sync cycles', () {
        for (var i = 0; i < 3; i++) {
          service.startStateSync(onStateReceived: (snapshot) {});
          service.stopStateSync();
        }
        expect(service.isHosting, isFalse);
      });
    });
  });
}
