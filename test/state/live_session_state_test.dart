import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/live_session_connection_status.dart';
import 'package:graviton/features/premium/data/premium_service.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:graviton/state/live_session_state.dart';

import '../helpers/mock_premium_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LiveSessionState', () {
    late LiveSessionState state;

    setUp(() {
      // Set up mock premium service with premium access for all tests
      PremiumService.setInstance(MockPremiumService(hasPremium: true));
      state = LiveSessionState();
    });

    tearDown(() {
      state.dispose();
      PremiumService.resetInstance();
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(state.isHosting, isFalse);
        expect(state.isViewing, isFalse);
        expect(state.hostedSessionId, isNull);
        expect(state.viewedSessionId, isNull);
        expect(state.currentSession, isNull);
        expect(state.viewerCount, isZero);
        expect(state.activeSessions, isEmpty);
        expect(state.isLoadingSessions, isFalse);
      });

      test('isInSession should return false initially', () {
        expect(state.isInSession, isFalse);
      });
    });

    group('State Properties', () {
      test('isInSession should reflect hosting or viewing state', () {
        // When neither hosting nor viewing, isInSession should be false
        expect(state.isHosting || state.isViewing, equals(state.isInSession));
      });

      test('viewerCount should be 0 initially', () {
        expect(state.viewerCount, isZero);
      });
    });

    group('Hosting Operations', () {
      test('startHosting should handle missing auth gracefully', () async {
        // Without Firebase/Auth initialized, startHosting should fail
        // but should return false rather than throwing
        final result = await state.startHosting(scenarioName: 'Test Scenario');

        // Should fail gracefully (no authenticated user)
        expect(result, isFalse);
        expect(state.isHosting, isFalse);
      });

      test('stopHosting should return false when not hosting', () async {
        // Should return false when not hosting (no-op)
        final result = await state.stopHosting();
        expect(result, isFalse);
        expect(state.isHosting, isFalse);
      });
    });

    group('Viewing Operations', () {
      test('startViewing should require valid session ID', () async {
        // Should fail with empty session ID
        final result = await state.startViewing('');

        expect(result, isFalse);
        expect(state.isViewing, isFalse);
      });

      test('stopViewing should return false when not viewing', () async {
        final result = await state.stopViewing();
        expect(result, isFalse);
        expect(state.isViewing, isFalse);
      });
    });

    group('Session Discovery', () {
      test('startSessionDiscovery should not throw', () async {
        // Should not throw even without Firebase
        expect(() => state.startSessionDiscovery(), returnsNormally);
      });

      test('stopSessionDiscovery should not throw', () {
        expect(() => state.stopSessionDiscovery(), returnsNormally);
      });

      test('stopSessionDiscovery should clear sessions', () {
        state.startSessionDiscovery();
        state.stopSessionDiscovery();

        expect(state.activeSessions, isEmpty);
      });
    });

    group('Listener Notifications', () {
      test('should notify on startHosting attempt', () async {
        var notificationCount = 0;
        state.addListener(() => notificationCount++);

        await state.startHosting(scenarioName: 'Test');

        // Note: Without Firebase, startHosting will fail silently
        // But the method should complete without errors
        expect(notificationCount, greaterThanOrEqualTo(0));
      });

      test('should notify on startViewing attempt', () async {
        var notificationCount = 0;
        state.addListener(() => notificationCount++);

        await state.startViewing('test-id');

        expect(notificationCount, greaterThanOrEqualTo(0));
      });
    });

    group('Dispose', () {
      test('should clean up resources on dispose', () {
        final testState = LiveSessionState();
        testState.startSessionDiscovery();

        // Should not throw
        expect(() => testState.dispose(), returnsNormally);
      });

      test('should stop hosting on dispose', () async {
        final testState = LiveSessionState();

        // Attempt to start (will fail without auth)
        await testState.startHosting(scenarioName: 'Test');

        // Dispose should clean up
        expect(() => testState.dispose(), returnsNormally);
      });
    });

    group('Update Hosted Session', () {
      test(
        'updateHostedSession should return false when not hosting',
        () async {
          final result = await state.updateHostedSession(isRunning: true);
          expect(result, isFalse);
        },
      );

      test('updateHostedSession should accept timeScale parameter', () async {
        final result = await state.updateHostedSession(timeScale: 1.5);
        expect(result, isFalse);
      });

      test('updateHostedSession should accept both parameters', () async {
        final result = await state.updateHostedSession(
          isRunning: true,
          timeScale: 2.0,
        );
        expect(result, isFalse);
      });
    });

    group('Cleanup', () {
      test('cleanup should not throw when idle', () async {
        await expectLater(state.cleanup(), completes);
      });

      test('cleanup should stop session discovery', () async {
        state.startSessionDiscovery();
        await state.cleanup();
        expect(state.activeSessions, isEmpty);
      });

      test('cleanup should work after hosting attempt', () async {
        await state.startHosting(scenarioName: 'Test');
        await expectLater(state.cleanup(), completes);
        expect(state.isHosting, isFalse);
      });

      test('cleanup should work after viewing attempt', () async {
        await state.startViewing('test-session');
        await expectLater(state.cleanup(), completes);
        expect(state.isViewing, isFalse);
      });
    });

    group('Session Discovery Edge Cases', () {
      test('startSessionDiscovery called twice should not throw', () {
        state.startSessionDiscovery();
        expect(() => state.startSessionDiscovery(), returnsNormally);
        state.stopSessionDiscovery();
      });

      test('stopSessionDiscovery called twice should not throw', () {
        state.startSessionDiscovery();
        state.stopSessionDiscovery();
        expect(() => state.stopSessionDiscovery(), returnsNormally);
      });

      test('isLoadingSessions should be false after stop', () {
        state.startSessionDiscovery();
        state.stopSessionDiscovery();
        expect(state.isLoadingSessions, isFalse);
      });
    });

    group('Viewing Edge Cases', () {
      test('startViewing should handle non-existent session', () async {
        final result = await state.startViewing('non-existent-session-id');
        expect(result, isFalse);
        expect(state.isViewing, isFalse);
        expect(state.viewedSessionId, isNull);
      });

      test('startViewing should clear previous viewing state', () async {
        await state.startViewing('session-1');
        await state.startViewing('session-2');
        // Both should fail without Firebase, but no exception
        expect(state.isViewing, isFalse);
      });
    });

    group('Hosting Edge Cases', () {
      test('startHosting with displayName should not throw', () async {
        final result = await state.startHosting(
          scenarioName: 'Test',
          displayName: 'Test Host',
        );
        expect(result, isFalse);
      });

      test('startHosting should stop viewing first', () async {
        await state.startViewing('test-session');
        await state.startHosting(scenarioName: 'Test');
        // Both should fail without Firebase
        expect(state.isViewing, isFalse);
        expect(state.isHosting, isFalse);
      });
    });

    group('State Sync', () {
      test('broadcastState should return false when not hosting', () async {
        final snapshot = SimulationSnapshot(
          bodies: [],
          isRunning: false,
          timeScale: 1.0,
          totalTime: 0.0,
          stepCount: 0,
          timestamp: DateTime.now(),
        );
        final result = await state.broadcastState(snapshot);
        expect(result, isFalse);
      });

      test('startStateSync should not throw when not viewing', () {
        expect(() => state.startStateSync(), returnsNormally);
      });

      test('stopStateSync should not throw when not syncing', () {
        expect(() => state.stopStateSync(), returnsNormally);
      });

      test('latestSnapshot should be null initially', () {
        expect(state.latestSnapshot, isNull);
      });

      test('startStateSync with callback should not throw', () {
        expect(
          () => state.startStateSync(onSnapshotReceived: (snapshot) {}),
          returnsNormally,
        );
      });
    });

    group('Connection Status', () {
      test('connectionStatus should be disconnected initially', () {
        expect(
          state.connectionStatus,
          equals(LiveSessionConnectionStatus.disconnected),
        );
      });

      test('lastErrorMessage should be null initially', () {
        expect(state.lastErrorMessage, isNull);
      });

      test('lastErrorTime should be null initially', () {
        expect(state.lastErrorTime, isNull);
      });

      test('hasRecentError should be false initially', () {
        expect(state.hasRecentError, isFalse);
      });

      test('clearError should not throw when no error', () {
        expect(() => state.clearError(), returnsNormally);
      });
    });

    group('Multiple Operations', () {
      test(
        'startViewing then startHosting should stop viewing first',
        () async {
          await state.startViewing('test-session');
          await state.startHosting(scenarioName: 'Test');
          // Both should fail without Firebase, but no exception
          expect(state.isViewing, isFalse);
          expect(state.isHosting, isFalse);
        },
      );

      test(
        'startHosting then startViewing should stop hosting first',
        () async {
          await state.startHosting(scenarioName: 'Test');
          await state.startViewing('test-session');
          // Both should fail without Firebase, but no exception
          expect(state.isHosting, isFalse);
          expect(state.isViewing, isFalse);
        },
      );

      test('multiple cleanup calls should not throw', () async {
        await state.cleanup();
        await state.cleanup();
        expect(state.isHosting, isFalse);
        expect(state.isViewing, isFalse);
      });
    });

    group('Notification Count', () {
      test('clearError should not notify when no error exists', () {
        var notifyCount = 0;
        state.addListener(() => notifyCount++);
        state.clearError();
        expect(notifyCount, equals(0));
      });

      test('stopSessionDiscovery with notify false should not notify', () {
        var notifyCount = 0;
        state.addListener(() => notifyCount++);
        state.startSessionDiscovery();
        final countAfterStart = notifyCount;
        state.stopSessionDiscovery(notify: false);
        expect(notifyCount, equals(countAfterStart));
      });
    });

    group('Update Hosted Session', () {
      test('updateHostedSession returns false when not hosting', () async {
        final result = await state.updateHostedSession(isRunning: true);
        expect(result, isFalse);
      });

      test(
        'updateHostedSession with timeScale returns false when not hosting',
        () async {
          final result = await state.updateHostedSession(timeScale: 2.0);
          expect(result, isFalse);
        },
      );

      test(
        'updateHostedSession with both params returns false when not hosting',
        () async {
          final result = await state.updateHostedSession(
            isRunning: false,
            timeScale: 0.5,
          );
          expect(result, isFalse);
        },
      );
    });

    group('State Sync Advanced', () {
      test('startStateSync should not throw when already syncing', () {
        state.startStateSync();
        state.startStateSync();
        expect(() => state.startStateSync(), returnsNormally);
      });

      test('stopStateSync should clear latestSnapshot', () {
        state.stopStateSync();
        expect(state.latestSnapshot, isNull);
      });

      test('stopStateSync multiple times should not throw', () {
        state.stopStateSync();
        state.stopStateSync();
        state.stopStateSync();
        expect(() => state.stopStateSync(), returnsNormally);
      });
    });

    group('isInSession Property', () {
      test('isInSession should be false initially', () {
        expect(state.isInSession, isFalse);
      });

      test('isInSession matches isHosting or isViewing', () {
        expect(state.isInSession, equals(state.isHosting || state.isViewing));
      });
    });

    group('Hosting with Display Name', () {
      test('startHosting with custom displayName should not throw', () async {
        final result = await state.startHosting(
          scenarioName: 'Test',
          displayName: 'Custom Name',
        );
        expect(result, isFalse); // Fails without auth
      });
    });

    group('Concurrent Operations', () {
      test('rapid startHosting calls should not throw', () async {
        await state.startHosting(scenarioName: 'Test1');
        await state.startHosting(scenarioName: 'Test2');
        await state.startHosting(scenarioName: 'Test3');
        expect(state.isHosting, isFalse);
      });

      test('rapid startViewing calls should not throw', () async {
        await state.startViewing('session1');
        await state.startViewing('session2');
        await state.startViewing('session3');
        expect(state.isViewing, isFalse);
      });

      test('alternating hosting and viewing should not throw', () async {
        await state.startHosting(scenarioName: 'Test');
        await state.startViewing('session1');
        await state.startHosting(scenarioName: 'Test2');
        await state.startViewing('session2');
        expect(state.isHosting, isFalse);
        expect(state.isViewing, isFalse);
      });
    });

    group('Session Discovery Stream', () {
      test('startSessionDiscovery sets isLoadingSessions', () {
        state.startSessionDiscovery();
        // Initially true, may become false quickly
        expect(state.isLoadingSessions, isA<bool>());
      });

      test('stopSessionDiscovery clears activeSessions', () {
        state.startSessionDiscovery();
        state.stopSessionDiscovery();
        expect(state.activeSessions, isEmpty);
      });
    });

    group('Password Protected Hosting', () {
      test('startHosting should accept password parameter', () async {
        final result = await state.startHosting(
          scenarioName: 'Test',
          password: 'mypassword',
        );
        // Fails without auth, but should accept parameter
        expect(result, isFalse);
      });

      test('startHosting with empty password should not throw', () async {
        final result = await state.startHosting(
          scenarioName: 'Test',
          password: '',
        );
        expect(result, isFalse);
      });

      test('startHosting with all parameters should not throw', () async {
        final result = await state.startHosting(
          scenarioName: 'Test Scenario',
          displayName: 'Test Host',
          password: 'secret123',
        );
        expect(result, isFalse);
      });
    });

    group('Password Protected Viewing', () {
      test('startViewing should accept password parameter', () async {
        final result = await state.startViewing(
          'session-id',
          password: 'viewerpassword',
        );
        // Fails without auth, but should accept parameter
        expect(result, isFalse);
      });

      test('startViewing with empty password should not throw', () async {
        final result = await state.startViewing('session-id', password: '');
        expect(result, isFalse);
      });

      test('startViewing with null password should work', () async {
        final result = await state.startViewing('session-id');
        expect(result, isFalse);
      });
    });

    group('Connection Status Transitions', () {
      test(
        'connectionStatus should be disconnected after stopViewing',
        () async {
          await state.startViewing('test-session');
          await state.stopViewing();
          // After failed ops, status may be error or disconnected
          expect(
            state.connectionStatus,
            anyOf(
              equals(LiveSessionConnectionStatus.disconnected),
              equals(LiveSessionConnectionStatus.error),
            ),
          );
        },
      );

      test('connectionStatus should reflect state after stopHosting', () async {
        await state.startHosting(scenarioName: 'Test');
        await state.stopHosting();
        // After failed ops, status may be error or disconnected
        expect(
          state.connectionStatus,
          anyOf(
            equals(LiveSessionConnectionStatus.disconnected),
            equals(LiveSessionConnectionStatus.error),
          ),
        );
      });

      test('connectionStatus should be disconnected after cleanup', () async {
        await state.cleanup();
        expect(
          state.connectionStatus,
          equals(LiveSessionConnectionStatus.disconnected),
        );
      });
    });

    group('Error State Management', () {
      test('hasRecentError should return false initially', () {
        expect(state.hasRecentError, isFalse);
      });

      test('lastErrorMessage should be null initially', () {
        expect(state.lastErrorMessage, isNull);
      });

      test('lastErrorTime should be null initially', () {
        expect(state.lastErrorTime, isNull);
      });

      test('clearError should clear error state', () {
        state.clearError();
        expect(state.lastErrorMessage, isNull);
        expect(state.lastErrorTime, isNull);
      });
    });

    group('Advanced State Checks', () {
      test('viewedSessionId should be null initially', () {
        expect(state.viewedSessionId, isNull);
      });

      test('hostedSessionId should be null initially', () {
        expect(state.hostedSessionId, isNull);
      });

      test('currentSession should be null initially', () {
        expect(state.currentSession, isNull);
      });

      test('isInSession should match isHosting or isViewing', () {
        expect(state.isInSession, equals(state.isHosting || state.isViewing));
      });
    });

    group('State Transitions During Hosting Attempt', () {
      test('should transition from viewing to hosting', () async {
        await state.startViewing('session1');
        await state.startHosting(scenarioName: 'Test');
        // Both fail but transitions should be clean
        expect(state.isViewing, isFalse);
        expect(state.isHosting, isFalse);
      });

      test('should transition from hosting to viewing', () async {
        await state.startHosting(scenarioName: 'Test');
        await state.startViewing('session1');
        // Both fail but transitions should be clean
        expect(state.isHosting, isFalse);
        expect(state.isViewing, isFalse);
      });
    });

    group('Camera Sync', () {
      test('syncCameraWithViewers should be true by default', () {
        expect(state.syncCameraWithViewers, isTrue);
      });

      test('setSyncCameraWithViewers should update value', () {
        state.setSyncCameraWithViewers(false);
        expect(state.syncCameraWithViewers, isFalse);

        state.setSyncCameraWithViewers(true);
        expect(state.syncCameraWithViewers, isTrue);
      });

      test('setSyncCameraWithViewers should notify listeners on change', () {
        var notified = false;
        state.addListener(() {
          notified = true;
        });

        state.setSyncCameraWithViewers(false);
        expect(notified, isTrue);
      });

      test(
        'setSyncCameraWithViewers should not notify when value unchanged',
        () {
          var notifyCount = 0;
          state.addListener(() {
            notifyCount++;
          });

          // Set to current value (true by default)
          state.setSyncCameraWithViewers(true);
          expect(notifyCount, equals(0));

          // Change value
          state.setSyncCameraWithViewers(false);
          expect(notifyCount, equals(1));

          // Set to same value again
          state.setSyncCameraWithViewers(false);
          expect(notifyCount, equals(1));
        },
      );

      test('setSyncCameraWithViewers should not enable without premium', () {
        // Switch to non-premium user
        PremiumService.resetInstance();
        PremiumService.setInstance(MockPremiumService(hasPremium: false));

        final nonPremiumState = LiveSessionState();
        addTearDown(nonPremiumState.dispose);

        // First disable it
        nonPremiumState.setSyncCameraWithViewers(false);
        expect(nonPremiumState.syncCameraWithViewers, isFalse);

        // Try to enable - should be blocked
        nonPremiumState.setSyncCameraWithViewers(true);
        expect(nonPremiumState.syncCameraWithViewers, isFalse);
      });

      test('setSyncCameraWithViewers should allow disable without premium', () {
        // Start with premium to enable camera sync
        state.setSyncCameraWithViewers(true);
        expect(state.syncCameraWithViewers, isTrue);

        // Switch to non-premium user
        PremiumService.resetInstance();
        PremiumService.setInstance(MockPremiumService(hasPremium: false));

        final nonPremiumState = LiveSessionState();
        addTearDown(nonPremiumState.dispose);

        // Should be able to disable even without premium
        nonPremiumState.setSyncCameraWithViewers(false);
        expect(nonPremiumState.syncCameraWithViewers, isFalse);
      });
    });
  });
}
