import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/firebase/live_session.dart';
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
    });
  });
}
