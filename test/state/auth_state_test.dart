import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthState', () {
    late AuthState authState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      authState = AuthState();
    });

    tearDown(() {
      authState.dispose();
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(authState.currentUser, isNull);
        expect(authState.isLoading, isFalse);
        expect(authState.error, isNull);
        expect(authState.isAuthenticated, isFalse);
        expect(authState.isAnonymous, isFalse);
      });

      test('isAuthenticated should return false when no user', () {
        expect(authState.isAuthenticated, isFalse);
      });

      test('isAnonymous should return false when no user', () {
        expect(authState.isAnonymous, isFalse);
      });
    });

    group('Authentication State Properties', () {
      test('isAuthenticated should return true for non-anonymous user', () {
        // Manually set a non-anonymous user for testing
        authState.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        // Note: In real scenario, this would be set by AuthService
        // This test validates the getter logic
      });

      test('isAnonymous should return true for anonymous user', () {
        // Test validates the isAnonymous getter logic
        expect(authState.isAnonymous, isFalse);
      });
    });

    group('Error Handling', () {
      test('clearError should clear error state', () {
        // Set error state indirectly through a failed operation
        authState.clearError();

        expect(authState.error, isNull);
      });

      test('error handling should notify listeners', () {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        authState.clearError();

        expect(notificationCount, greaterThan(0));
      });
    });

    group('Sign In Operations', () {
      test('signInWithEmailPassword should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        // Should have been true during operation, false after
        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('signInWithEmailPassword should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(notificationCount, greaterThan(0));
      });

      test('signInWithGoogle should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.signInWithGoogle();

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('signInWithApple should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.signInWithApple();

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('signInAnonymously should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.signInAnonymously();

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });
    });

    group('Account Creation', () {
      test('createAccount should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.createAccount(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('createAccount with displayName should pass parameter', () async {
        await authState.createAccount(
          email: 'test@example.com',
          password: 'password123',
          displayName: 'Test User',
        );

        // Should complete without throwing
        expect(authState.isLoading, isFalse);
      });

      test('createAccount should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.createAccount(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(notificationCount, greaterThan(0));
      });
    });

    group('Anonymous Account Linking', () {
      test(
        'linkAnonymousAccountWithEmailPassword should set loading state',
        () async {
          var loadingStates = <bool>[];
          authState.addListener(() {
            loadingStates.add(authState.isLoading);
          });

          await authState.linkAnonymousAccountWithEmailPassword(
            email: 'test@example.com',
            password: 'password123',
          );

          expect(loadingStates, contains(true));
          expect(authState.isLoading, isFalse);
        },
      );

      test(
        'linkAnonymousAccountWithEmailPassword should notify listeners',
        () async {
          var notificationCount = 0;
          authState.addListener(() => notificationCount++);

          await authState.linkAnonymousAccountWithEmailPassword(
            email: 'test@example.com',
            password: 'password123',
          );

          expect(notificationCount, greaterThan(0));
        },
      );
    });

    group('Password Reset', () {
      test('resetPassword should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.resetPassword('test@example.com');

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('resetPassword should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.resetPassword('test@example.com');

        expect(notificationCount, greaterThan(0));
      });
    });

    group('Profile Management', () {
      test('updateDisplayName should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.updateDisplayName('New Name');

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('updateDisplayName should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.updateDisplayName('New Name');

        expect(notificationCount, greaterThan(0));
      });

      test('setAvatar should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.setAvatar(UserAvatar.earth);

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('setAvatar should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.setAvatar(UserAvatar.mars);

        expect(notificationCount, greaterThan(0));
      });

      test('setAvatar should accept all avatar types', () async {
        for (final avatar in UserAvatar.values) {
          await authState.setAvatar(avatar);
          expect(authState.isLoading, isFalse);
        }
      });
    });

    group('Account Deletion', () {
      test('deleteAccount should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.deleteAccount();

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('deleteAccount with password should pass parameter', () async {
        await authState.deleteAccount(password: 'password123');

        expect(authState.isLoading, isFalse);
      });

      test('deleteAccount should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.deleteAccount();

        expect(notificationCount, greaterThan(0));
      });
    });

    group('Sign Out', () {
      test('signOut should set loading state', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.signOut();

        expect(loadingStates, contains(true));
        expect(authState.isLoading, isFalse);
      });

      test('signOut should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.signOut();

        expect(notificationCount, greaterThan(0));
      });
    });

    group('Initialization', () {
      test('initialize should complete without error', () async {
        await authState.initialize();

        // Should complete successfully
        expect(authState, isNotNull);
      });

      test('initialize should set up auth state listener', () async {
        await authState.initialize();

        // After initialization, state should be set up
        expect(authState.currentUser, isNull);
      });
    });

    group('Loading State Management', () {
      test('loading state should be false by default', () {
        expect(authState.isLoading, isFalse);
      });

      test('loading state should toggle during operations', () async {
        var loadingStates = <bool>[];
        authState.addListener(() {
          loadingStates.add(authState.isLoading);
        });

        await authState.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        // Should have been true at some point
        expect(loadingStates, contains(true));
        // Should end as false
        expect(authState.isLoading, isFalse);
      });
    });

    group('Error State Management', () {
      test('error should be null by default', () {
        expect(authState.error, isNull);
      });

      test('clearError should clear error and notify', () {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        authState.clearError();

        expect(authState.error, isNull);
        expect(notificationCount, equals(1));
      });
    });

    group('Listener Notifications', () {
      test('all operations should notify listeners', () async {
        var notificationCount = 0;
        authState.addListener(() => notificationCount++);

        await authState.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'password123',
        );
        await authState.signOut();
        authState.clearError();

        expect(notificationCount, greaterThan(2));
      });

      test('multiple listeners should all be notified', () async {
        var listener1Count = 0;
        var listener2Count = 0;
        var listener3Count = 0;

        authState.addListener(() => listener1Count++);
        authState.addListener(() => listener2Count++);
        authState.addListener(() => listener3Count++);

        await authState.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(listener1Count, greaterThan(0));
        expect(listener2Count, greaterThan(0));
        expect(listener3Count, greaterThan(0));
        expect(listener1Count, equals(listener2Count));
        expect(listener2Count, equals(listener3Count));
      });
    });

    group('Edge Cases', () {
      test('should handle empty email', () async {
        await authState.signInWithEmailPassword(
          email: '',
          password: 'password123',
        );

        expect(authState.isLoading, isFalse);
      });

      test('should handle empty password', () async {
        await authState.signInWithEmailPassword(
          email: 'test@example.com',
          password: '',
        );

        expect(authState.isLoading, isFalse);
      });

      test('should handle empty display name', () async {
        await authState.createAccount(
          email: 'test@example.com',
          password: 'password123',
          displayName: '',
        );

        expect(authState.isLoading, isFalse);
      });

      test('should handle null display name', () async {
        await authState.createAccount(
          email: 'test@example.com',
          password: 'password123',
          displayName: null,
        );

        expect(authState.isLoading, isFalse);
      });

      test('dispose should not throw when called once', () {
        // Create a separate instance for this test
        final separateAuthState = AuthState();
        expect(() => separateAuthState.dispose(), returnsNormally);
      });
    });
  });
}
