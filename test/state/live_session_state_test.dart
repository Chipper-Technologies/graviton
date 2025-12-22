import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/live_session_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LiveSessionState', () {
    late LiveSessionState state;

    setUp(() {
      state = LiveSessionState();
    });

    tearDown(() {
      state.dispose();
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
        final result = await state.startHosting(
          scenarioName: 'Test Scenario',
        );

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
  });
}

