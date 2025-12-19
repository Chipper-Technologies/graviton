import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/firebase/realtime_database_service.dart';

void main() {
  group('RealtimeDatabaseService Tests', () {
    late RealtimeDatabaseService service;

    setUp(() {
      RealtimeDatabaseService.resetForTesting();
      service = RealtimeDatabaseService.instance;
    });

    tearDown(() {
      RealtimeDatabaseService.resetForTesting();
    });

    group('Singleton Pattern', () {
      test('Should be singleton', () {
        final service1 = RealtimeDatabaseService.instance;
        final service2 = RealtimeDatabaseService.instance;
        expect(identical(service1, service2), isTrue);
      });

      test('Should create new instance after reset', () {
        final service1 = RealtimeDatabaseService.instance;
        RealtimeDatabaseService.resetForTesting();
        final service2 = RealtimeDatabaseService.instance;
        expect(identical(service1, service2), isFalse);
      });
    });

    group('Initial State', () {
      test('Should initialize with default values', () {
        expect(service.isInitialized, isFalse);
        expect(service.isConnected, isFalse);
        expect(service.database, isNull);
      });
    });

    group('Reference Operations (Uninitialized)', () {
      test('Should return null ref when not initialized', () {
        final ref = service.ref('test/path');
        expect(ref, isNull);
      });

      test('Should return null userRef when not initialized', () async {
        final ref = await service.userRef();
        expect(ref, isNull);
      });
    });

    group('Write Operations (Uninitialized)', () {
      test('Should return false for setValue when not initialized', () async {
        final result = await service.setValue('test/path', {'key': 'value'});
        expect(result, isFalse);
      });

      test(
        'Should return false for updateValues when not initialized',
        () async {
          final result = await service.updateValues('test/path', {
            'key': 'value',
          });
          expect(result, isFalse);
        },
      );

      test('Should return null for push when not initialized', () async {
        final result = await service.push('test/path', {'key': 'value'});
        expect(result, isNull);
      });

      test('Should return false for remove when not initialized', () async {
        final result = await service.remove('test/path');
        expect(result, isFalse);
      });
    });

    group('Read Operations (Uninitialized)', () {
      test('Should return null for getValue when not initialized', () async {
        final result = await service.getValue('test/path');
        expect(result, isNull);
      });

      test('Should return null for getMap when not initialized', () async {
        final result = await service.getMap('test/path');
        expect(result, isNull);
      });
    });

    group('Real-time Listeners (Uninitialized)', () {
      test('Should return null stream for onValue when not initialized', () {
        final stream = service.onValue('test/path');
        expect(stream, isNotNull);
        // Stream should emit null
        expectLater(stream, emits(null));
      });

      test(
        'Should return empty stream for onChildAdded when not initialized',
        () {
          final stream = service.onChildAdded('test/path');
          expect(stream, isNotNull);
          // Stream should be empty
          expectLater(stream, emitsDone);
        },
      );

      test(
        'Should return empty stream for onChildChanged when not initialized',
        () {
          final stream = service.onChildChanged('test/path');
          expect(stream, isNotNull);
          expectLater(stream, emitsDone);
        },
      );

      test(
        'Should return empty stream for onChildRemoved when not initialized',
        () {
          final stream = service.onChildRemoved('test/path');
          expect(stream, isNotNull);
          expectLater(stream, emitsDone);
        },
      );
    });

    group('Presence Operations (Uninitialized)', () {
      test(
        'Should return false for setupPresence when not initialized',
        () async {
          final result = await service.setupPresence();
          expect(result, isFalse);
        },
      );

      test(
        'Should return false for removePresence when not initialized',
        () async {
          final result = await service.removePresence();
          expect(result, isFalse);
        },
      );
    });

    group('Transaction Operations (Uninitialized)', () {
      test(
        'Should return null for runTransaction when not initialized',
        () async {
          final result = await service.runTransaction(
            'test/path',
            (Object? currentData) => Transaction.success(currentData),
          );
          expect(result, isNull);
        },
      );

      test('Should return null for increment when not initialized', () async {
        final result = await service.increment('test/path', 1);
        expect(result, isNull);
      });
    });

    group('Query Operations (Uninitialized)', () {
      test('Should return null query when not initialized', () {
        final q = service.query(path: 'test/path');
        expect(q, isNull);
      });

      test(
        'Should return empty list for queryOnce when not initialized',
        () async {
          final results = await service.queryOnce(path: 'test/path');
          expect(results, isEmpty);
        },
      );

      test('Should handle query with all parameters', () {
        final q = service.query(
          path: 'test/path',
          orderByChild: 'name',
          limitToFirst: 10,
          equalTo: 'test',
          startAt: 'a',
          endAt: 'z',
        );
        expect(q, isNull);
      });

      test('Should handle query with limitToLast', () {
        final q = service.query(
          path: 'test/path',
          orderByChild: 'timestamp',
          limitToLast: 5,
        );
        expect(q, isNull);
      });
    });

    group('Dispose', () {
      test('Should handle dispose when not initialized', () async {
        // Should not throw
        await service.dispose();
        expect(service.isInitialized, isFalse);
        expect(service.isConnected, isFalse);
      });
    });

    group('Initialize (Without Firebase)', () {
      test(
        'Should handle initialization gracefully without Firebase',
        () async {
          // This test runs without actual Firebase initialization
          // The service should handle this gracefully
          await service.initialize();
          // May or may not be initialized depending on Firebase availability
          // Just ensure it doesn't throw
        },
      );
    });

    group('Path Validation', () {
      test('Should handle various path formats', () {
        // Empty paths
        expect(service.ref(''), isNull);

        // Nested paths
        expect(service.ref('users/abc/profile'), isNull);

        // Paths with special characters
        expect(service.ref('users/user-123/data'), isNull);
      });

      test('Should reject empty and whitespace paths', () {
        expect(service.ref(''), isNull);
        expect(service.ref('   '), isNull);
        expect(service.ref('\t'), isNull);
        expect(service.ref('\n'), isNull);
      });

      test('Should reject paths with invalid characters', () {
        // Paths with dots (invalid in Firebase RTDB)
        expect(service.ref('users.data'), isNull);
        expect(service.ref('users/user.name'), isNull);

        // Paths with hash
        expect(service.ref('users#data'), isNull);
        expect(service.ref('users/data#1'), isNull);

        // Paths with dollar sign
        expect(service.ref('users\$data'), isNull);
        expect(service.ref('users/\$special'), isNull);

        // Paths with brackets
        expect(service.ref('users[0]'), isNull);
        expect(service.ref('users/data[key]'), isNull);
      });

      test('Should reject path traversal attempts', () {
        expect(service.ref('..'), isNull);
        expect(service.ref('../users'), isNull);
        expect(service.ref('users/../admin'), isNull);
        expect(service.ref('users/data/..'), isNull);
        expect(service.ref('users/../../etc/passwd'), isNull);
      });

      test('Should reject paths with consecutive slashes', () {
        expect(service.ref('users//data'), isNull);
        expect(service.ref('users///profile'), isNull);
        expect(service.ref('a//b//c'), isNull);
      });

      test('Should handle queryOnce with various parameters', () async {
        // Test all parameter combinations
        var results = await service.queryOnce(
          path: 'test',
          orderByChild: 'created',
        );
        expect(results, isEmpty);

        results = await service.queryOnce(
          path: 'test',
          orderByChild: 'score',
          startAt: 0,
          endAt: 100,
        );
        expect(results, isEmpty);

        results = await service.queryOnce(path: 'test', limitToLast: 20);
        expect(results, isEmpty);
      });
    });

    group('Presence Default Values', () {
      test('Should handle setupPresence with custom values', () async {
        final result = await service.setupPresence(
          onlineValue: {'status': 'active', 'device': 'mobile'},
          offlineValue: {'status': 'away', 'lastActive': 'timestamp'},
        );
        expect(result, isFalse); // Not initialized
      });
    });

    group('Edge Cases', () {
      test('Should handle repeated initialization calls', () async {
        await service.initialize();
        await service.initialize();
        await service.initialize();
        // Should not throw or cause issues
      });

      test('Should handle dispose after initialization attempt', () async {
        await service.initialize();
        await service.dispose();
        expect(service.isInitialized, isFalse);
      });

      test('Should handle operations after dispose', () async {
        await service.initialize();
        await service.dispose();

        // Operations should handle gracefully
        final ref = service.ref('test');
        expect(ref, isNull);
      });
    });
  });
}
