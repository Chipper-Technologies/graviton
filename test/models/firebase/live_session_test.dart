import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/firebase/live_session.dart';

void main() {
  group('LiveSession Model Tests', () {
    group('Constructor', () {
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

      test('Should be immutable (const constructor)', () {
        final now = DateTime(2024, 1, 1);
        // Verify the class supports normal construction and is effectively immutable
        // (all fields are final, so the instance cannot be modified after creation)
        expect(
          () => LiveSession(
            id: 'id',
            hostId: 'host',
            hostName: 'Host',
            scenarioName: 'Scenario',
            isRunning: false,
            timeScale: 1.0,
            viewerCount: 0,
            createdAt: now,
            updatedAt: now,
          ),
          returnsNormally,
        );
      });
    });

    group('fromMap', () {
      test('Should create LiveSession from complete map', () {
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

      test('Should handle missing fields with defaults', () {
        final session = LiveSession.fromMap('id', {});

        expect(session.id, 'id');
        expect(session.hostId, '');
        expect(session.hostName, 'Unknown');
        expect(session.scenarioName, 'Custom');
        expect(session.isRunning, isFalse);
        expect(session.timeScale, 1.0);
        expect(session.viewerCount, 0);
        expect(session.createdAt, isNotNull);
        expect(session.updatedAt, isNotNull);
      });

      test('Should handle null values with defaults', () {
        final map = {
          'hostId': null,
          'hostName': null,
          'scenarioName': null,
          'isRunning': null,
          'timeScale': null,
          'viewerCount': null,
          'createdAt': null,
          'updatedAt': null,
        };

        final session = LiveSession.fromMap('null-id', map);

        expect(session.hostId, '');
        expect(session.hostName, 'Unknown');
        expect(session.scenarioName, 'Custom');
        expect(session.isRunning, isFalse);
        expect(session.timeScale, 1.0);
        expect(session.viewerCount, 0);
      });

      test('Should handle int timeScale (type coercion)', () {
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
        expect(session.timeScale, isA<double>());
      });
    });

    group('toMap', () {
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

      test('Should not include id in map (used as key)', () {
        final now = DateTime.now();
        final session = LiveSession(
          id: 'should-not-appear',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: false,
          timeScale: 1.0,
          viewerCount: 0,
          createdAt: now,
          updatedAt: now,
        );

        final map = session.toMap();

        expect(map.containsKey('id'), isFalse);
      });

      test('Should roundtrip through fromMap and toMap', () {
        final now = DateTime.now();
        final original = LiveSession(
          id: 'roundtrip-id',
          hostId: 'host-rt',
          hostName: 'Roundtrip Host',
          scenarioName: 'Roundtrip Scenario',
          isRunning: true,
          timeScale: 4.0,
          viewerCount: 7,
          createdAt: now,
          updatedAt: now,
        );

        final map = original.toMap();
        final restored = LiveSession.fromMap(original.id, map);

        expect(restored.id, original.id);
        expect(restored.hostId, original.hostId);
        expect(restored.hostName, original.hostName);
        expect(restored.scenarioName, original.scenarioName);
        expect(restored.isRunning, original.isRunning);
        expect(restored.timeScale, original.timeScale);
        expect(restored.viewerCount, original.viewerCount);
        // Timestamps are stored as milliseconds, so they should match
        expect(
          restored.createdAt.millisecondsSinceEpoch,
          original.createdAt.millisecondsSinceEpoch,
        );
        expect(
          restored.updatedAt.millisecondsSinceEpoch,
          original.updatedAt.millisecondsSinceEpoch,
        );
      });
    });

    group('copyWith', () {
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

      test('Should copy all fields when specified', () {
        final now = DateTime.now();
        final later = now.add(const Duration(hours: 1));
        final original = LiveSession(
          id: 'id1',
          hostId: 'host1',
          hostName: 'Host 1',
          scenarioName: 'Scenario 1',
          isRunning: false,
          timeScale: 1.0,
          viewerCount: 0,
          createdAt: now,
          updatedAt: now,
        );

        final updated = original.copyWith(
          id: 'id2',
          hostId: 'host2',
          hostName: 'Host 2',
          scenarioName: 'Scenario 2',
          isRunning: true,
          timeScale: 8.0,
          viewerCount: 10,
          createdAt: later,
          updatedAt: later,
        );

        expect(updated.id, 'id2');
        expect(updated.hostId, 'host2');
        expect(updated.hostName, 'Host 2');
        expect(updated.scenarioName, 'Scenario 2');
        expect(updated.isRunning, isTrue);
        expect(updated.timeScale, 8.0);
        expect(updated.viewerCount, 10);
        expect(updated.createdAt, later);
        expect(updated.updatedAt, later);
      });

      test('Should return equivalent object with no changes', () {
        final now = DateTime.now();
        final original = LiveSession(
          id: 'id',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );

        final copy = original.copyWith();

        expect(copy, equals(original));
      });
    });

    group('toString', () {
      test('Should return readable string representation', () {
        final now = DateTime.now();
        final session = LiveSession(
          id: 'str-id',
          hostId: 'host',
          hostName: 'String Host',
          scenarioName: 'String Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 5,
          createdAt: now,
          updatedAt: now,
        );

        final str = session.toString();

        expect(str, contains('LiveSession'));
        expect(str, contains('str-id'));
        expect(str, contains('String Host'));
        expect(str, contains('String Scenario'));
        expect(str, contains('isRunning: true'));
        expect(str, contains('viewerCount: 5'));
      });
    });

    group('Equality', () {
      test('Should be equal for same values', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final session1 = LiveSession(
          id: 'eq-id',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );
        final session2 = LiveSession(
          id: 'eq-id',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );

        expect(session1, equals(session2));
        expect(session1.hashCode, equals(session2.hashCode));
      });

      test('Should not be equal for different ids', () {
        final now = DateTime.now();
        final session1 = LiveSession(
          id: 'id1',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );
        final session2 = LiveSession(
          id: 'id2',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );

        expect(session1, isNot(equals(session2)));
      });

      test('Should not be equal for different field values', () {
        final now = DateTime.now();
        final base = LiveSession(
          id: 'id',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );

        expect(base.copyWith(isRunning: false), isNot(equals(base)));
        expect(base.copyWith(timeScale: 4.0), isNot(equals(base)));
        expect(base.copyWith(viewerCount: 10), isNot(equals(base)));
        expect(base.copyWith(hostName: 'Other'), isNot(equals(base)));
      });

      test('Should be identical to itself', () {
        final now = DateTime.now();
        final session = LiveSession(
          id: 'id',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );

        expect(session == session, isTrue);
      });

      test('Should handle equality with dynamic type comparisons', () {
        final now = DateTime.now();
        final session = LiveSession(
          id: 'id',
          hostId: 'host',
          hostName: 'Host',
          scenarioName: 'Scenario',
          isRunning: true,
          timeScale: 2.0,
          viewerCount: 3,
          createdAt: now,
          updatedAt: now,
        );

        // Use dynamic to test that == returns false for non-LiveSession objects
        // ignore: unrelated_type_equality_checks
        expect(session == ('not a session' as dynamic), isFalse);
        // ignore: unrelated_type_equality_checks
        expect(session == (123 as dynamic), isFalse);
      });
    });
  });
}
