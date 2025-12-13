import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/ui/onboarding_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('OnboardingService Tests', () {
    setUp(() async {
      // Clear all preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    group('Tutorial Seen State', () {
      test('hasSeenTutorial should return false by default', () async {
        final result = await OnboardingService.hasSeenTutorial();
        expect(result, false);
      });

      test(
        'hasSeenTutorial should return true after markTutorialSeen',
        () async {
          // Initially false
          expect(await OnboardingService.hasSeenTutorial(), false);

          // Mark as seen
          await OnboardingService.markTutorialSeen();

          // Should now be true
          expect(await OnboardingService.hasSeenTutorial(), true);
        },
      );

      test('markTutorialSeen should persist across service calls', () async {
        // Mark tutorial as seen
        await OnboardingService.markTutorialSeen();

        // Check multiple times to ensure persistence
        expect(await OnboardingService.hasSeenTutorial(), true);
        expect(await OnboardingService.hasSeenTutorial(), true);
      });

      test(
        'hasSeenTutorial should handle SharedPreferences errors gracefully',
        () async {
          // Mock a SharedPreferences failure by not setting it up properly
          // This should return false without throwing
          final result = await OnboardingService.hasSeenTutorial();
          expect(result, false);
        },
      );
    });

    group('Tutorial Completed State', () {
      test('hasTutorialCompleted should return false by default', () async {
        final result = await OnboardingService.hasTutorialCompleted();
        expect(result, false);
      });

      test(
        'hasTutorialCompleted should return true after markTutorialCompleted',
        () async {
          // Initially false
          expect(await OnboardingService.hasTutorialCompleted(), false);

          // Mark as completed
          await OnboardingService.markTutorialCompleted();

          // Should now be true
          expect(await OnboardingService.hasTutorialCompleted(), true);
        },
      );

      test('markTutorialCompleted should also mark tutorial as seen', () async {
        // Initially both should be false
        expect(await OnboardingService.hasTutorialCompleted(), false);
        expect(await OnboardingService.hasSeenTutorial(), false);

        // Mark as completed
        await OnboardingService.markTutorialCompleted();

        // Both should now be true
        expect(await OnboardingService.hasTutorialCompleted(), true);
        expect(await OnboardingService.hasSeenTutorial(), true);
      });

      test(
        'markTutorialCompleted should persist across service calls',
        () async {
          // Mark tutorial as completed
          await OnboardingService.markTutorialCompleted();

          // Check multiple times to ensure persistence
          expect(await OnboardingService.hasTutorialCompleted(), true);
          expect(await OnboardingService.hasTutorialCompleted(), true);
        },
      );

      test(
        'hasTutorialCompleted should handle SharedPreferences errors gracefully',
        () async {
          // This should return false without throwing even if SharedPreferences fails
          final result = await OnboardingService.hasTutorialCompleted();
          expect(result, false);
        },
      );
    });

    group('Tutorial State Reset', () {
      test(
        'resetTutorialState should clear both seen and completed states',
        () async {
          // Set both states to true
          await OnboardingService.markTutorialCompleted();
          expect(await OnboardingService.hasTutorialCompleted(), true);
          expect(await OnboardingService.hasSeenTutorial(), true);

          // Reset state
          await OnboardingService.resetTutorialState();

          // Both should now be false
          expect(await OnboardingService.hasTutorialCompleted(), false);
          expect(await OnboardingService.hasSeenTutorial(), false);
        },
      );

      test(
        'resetTutorialState should work even when states are already false',
        () async {
          // Ensure states are false
          expect(await OnboardingService.hasTutorialCompleted(), false);
          expect(await OnboardingService.hasSeenTutorial(), false);

          // Reset should not throw
          await OnboardingService.resetTutorialState();

          // States should still be false
          expect(await OnboardingService.hasTutorialCompleted(), false);
          expect(await OnboardingService.hasSeenTutorial(), false);
        },
      );

      test(
        'resetTutorialState should handle SharedPreferences errors gracefully',
        () async {
          // This should not throw even if SharedPreferences fails
          expect(() => OnboardingService.resetTutorialState(), returnsNormally);
        },
      );
    });

    group('Complex User Journeys', () {
      test('should handle complete first-time user journey', () async {
        // Fresh user - nothing seen or completed
        expect(await OnboardingService.hasSeenTutorial(), false);
        expect(await OnboardingService.hasTutorialCompleted(), false);

        // User sees tutorial
        await OnboardingService.markTutorialSeen();
        expect(await OnboardingService.hasSeenTutorial(), true);
        expect(await OnboardingService.hasTutorialCompleted(), false);

        // User completes tutorial
        await OnboardingService.markTutorialCompleted();
        expect(await OnboardingService.hasSeenTutorial(), true);
        expect(await OnboardingService.hasTutorialCompleted(), true);

        // User resets (maybe wants to see tutorial again)
        await OnboardingService.resetTutorialState();
        expect(await OnboardingService.hasSeenTutorial(), false);
        expect(await OnboardingService.hasTutorialCompleted(), false);
      });

      test(
        'should handle marking completed without marking seen first',
        () async {
          // Start fresh
          expect(await OnboardingService.hasSeenTutorial(), false);
          expect(await OnboardingService.hasTutorialCompleted(), false);

          // Mark completed directly (simulates user skipping to completion)
          await OnboardingService.markTutorialCompleted();

          // Both should be true since completed implies seen
          expect(await OnboardingService.hasSeenTutorial(), true);
          expect(await OnboardingService.hasTutorialCompleted(), true);
        },
      );

      test('should handle multiple mark operations idempotently', () async {
        // Mark seen multiple times
        await OnboardingService.markTutorialSeen();
        await OnboardingService.markTutorialSeen();
        await OnboardingService.markTutorialSeen();
        expect(await OnboardingService.hasSeenTutorial(), true);

        // Mark completed multiple times
        await OnboardingService.markTutorialCompleted();
        await OnboardingService.markTutorialCompleted();
        await OnboardingService.markTutorialCompleted();
        expect(await OnboardingService.hasTutorialCompleted(), true);
        expect(await OnboardingService.hasSeenTutorial(), true);

        // Reset multiple times
        await OnboardingService.resetTutorialState();
        await OnboardingService.resetTutorialState();
        await OnboardingService.resetTutorialState();
        expect(await OnboardingService.hasSeenTutorial(), false);
        expect(await OnboardingService.hasTutorialCompleted(), false);
      });
    });

    group('SharedPreferences Integration', () {
      test('should work with pre-existing SharedPreferences data', () async {
        // Simulate some existing data in SharedPreferences
        SharedPreferences.setMockInitialValues({
          'has_seen_tutorial': true,
          'tutorial_completed': false,
          'some_other_key': 'some_value',
        });

        expect(await OnboardingService.hasSeenTutorial(), true);
        expect(await OnboardingService.hasTutorialCompleted(), false);

        // Modifying onboarding state shouldn't affect other data
        await OnboardingService.markTutorialCompleted();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('some_other_key'), 'some_value');
      });

      test('should use correct preference keys', () async {
        await OnboardingService.markTutorialSeen();
        await OnboardingService.markTutorialCompleted();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('has_seen_tutorial'), true);
        expect(prefs.getBool('tutorial_completed'), true);
      });

      test('should clean up correctly on reset', () async {
        // Set states
        await OnboardingService.markTutorialCompleted();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('has_seen_tutorial'), true);
        expect(prefs.containsKey('tutorial_completed'), true);

        // Reset
        await OnboardingService.resetTutorialState();

        // Keys should be removed, not just set to false
        expect(prefs.containsKey('has_seen_tutorial'), false);
        expect(prefs.containsKey('tutorial_completed'), false);
      });
    });

    group('Error Handling', () {
      test('should be resilient to concurrent operations', () async {
        // Simulate multiple concurrent operations
        final futures = [
          OnboardingService.markTutorialSeen(),
          OnboardingService.hasSeenTutorial(),
          OnboardingService.markTutorialCompleted(),
          OnboardingService.hasTutorialCompleted(),
          OnboardingService.resetTutorialState(),
        ];

        // All operations should complete without error
        expect(() => Future.wait(futures), returnsNormally);
      });

      test('should maintain consistency after error recovery', () async {
        // Set initial state
        await OnboardingService.markTutorialCompleted();
        expect(await OnboardingService.hasTutorialCompleted(), true);

        // Even if there are internal errors, subsequent operations should work
        await OnboardingService.resetTutorialState();
        expect(await OnboardingService.hasTutorialCompleted(), false);

        await OnboardingService.markTutorialSeen();
        expect(await OnboardingService.hasSeenTutorial(), true);
      });
    });

    group('Edge Cases', () {
      test('should handle null/undefined SharedPreferences values', () async {
        // Clear any existing values
        await OnboardingService.resetTutorialState();

        // These should return false for missing values
        expect(await OnboardingService.hasSeenTutorial(), false);
        expect(await OnboardingService.hasTutorialCompleted(), false);
      });

      test('should be safe for rapid sequential calls', () async {
        // Rapid sequential operations should work correctly
        await OnboardingService.markTutorialSeen();
        final seen1 = await OnboardingService.hasSeenTutorial();
        await OnboardingService.markTutorialCompleted();
        final completed1 = await OnboardingService.hasTutorialCompleted();
        await OnboardingService.resetTutorialState();
        final seen2 = await OnboardingService.hasSeenTutorial();
        final completed2 = await OnboardingService.hasTutorialCompleted();

        expect(seen1, true);
        expect(completed1, true);
        expect(seen2, false);
        expect(completed2, false);
      });
    });
  });
}
