import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/firebase_event.dart';

void main() {
  group('FirebaseEvent Enum', () {
    test('should have all expected Firebase events', () {
      // 18 original + 18 premium events + 3 stripe events = 39 total
      expect(FirebaseEvent.values.length, equals(39));
      expect(FirebaseEvent.values, contains(FirebaseEvent.appInitialized));
      expect(FirebaseEvent.values, contains(FirebaseEvent.appStart));
      expect(FirebaseEvent.values, contains(FirebaseEvent.appError));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationStarted));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationPaused));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationResumed));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationStopped));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationReset));
      expect(FirebaseEvent.values, contains(FirebaseEvent.settingsChanged));
      expect(FirebaseEvent.values, contains(FirebaseEvent.performanceMetric));
      expect(FirebaseEvent.values, contains(FirebaseEvent.uiInteraction));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationAction));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationShared));
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.simulationImageShared),
      );
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.simulationStateShared),
      );
      expect(FirebaseEvent.values, contains(FirebaseEvent.shareDialogOpened));
      expect(FirebaseEvent.values, contains(FirebaseEvent.shareCancelled));
      expect(FirebaseEvent.values, contains(FirebaseEvent.shareFailed));
      // Premium events
      expect(FirebaseEvent.values, contains(FirebaseEvent.paywallOpened));
      expect(FirebaseEvent.values, contains(FirebaseEvent.paywallClosed));
      expect(FirebaseEvent.values, contains(FirebaseEvent.purchaseStarted));
      expect(FirebaseEvent.values, contains(FirebaseEvent.purchaseCompleted));
      expect(FirebaseEvent.values, contains(FirebaseEvent.purchaseFailed));
      expect(FirebaseEvent.values, contains(FirebaseEvent.purchaseCancelled));
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.purchaseRestoreStarted),
      );
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.purchaseRestoreCompleted),
      );
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.purchaseRestoreFailed),
      );
      expect(FirebaseEvent.values, contains(FirebaseEvent.subscriptionExpired));
      expect(FirebaseEvent.values, contains(FirebaseEvent.trialStarted));
      expect(FirebaseEvent.values, contains(FirebaseEvent.trialConverted));
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.premiumFeatureAccessed),
      );
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.premiumFeatureBlocked),
      );
      expect(FirebaseEvent.values, contains(FirebaseEvent.sessionLimitReached));
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.durationLimitReached),
      );
      expect(FirebaseEvent.values, contains(FirebaseEvent.freeSessionStarted));
      expect(FirebaseEvent.values, contains(FirebaseEvent.freeSessionEnded));
      // Stripe web payment events
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.stripePurchaseInitiated),
      );
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.stripePurchaseCompleted),
      );
      expect(
        FirebaseEvent.values,
        contains(FirebaseEvent.stripePurchaseFailed),
      );
    });

    test('should have correct string values', () {
      expect(FirebaseEvent.appInitialized.value, equals('app_initialized'));
      expect(FirebaseEvent.appStart.value, equals('app_start'));
      expect(FirebaseEvent.appError.value, equals('app_error'));
      expect(
        FirebaseEvent.simulationStarted.value,
        equals('simulation_started'),
      );
      expect(FirebaseEvent.simulationPaused.value, equals('simulation_paused'));
      expect(
        FirebaseEvent.simulationResumed.value,
        equals('simulation_resumed'),
      );
      expect(
        FirebaseEvent.simulationStopped.value,
        equals('simulation_stopped'),
      );
      expect(FirebaseEvent.simulationReset.value, equals('simulation_reset'));
      expect(FirebaseEvent.settingsChanged.value, equals('settings_changed'));
      expect(
        FirebaseEvent.performanceMetric.value,
        equals('performance_metric'),
      );
      expect(FirebaseEvent.uiInteraction.value, equals('ui_'));
      expect(FirebaseEvent.simulationAction.value, equals('simulation_'));
      expect(FirebaseEvent.simulationShared.value, equals('simulation_shared'));
      expect(
        FirebaseEvent.simulationImageShared.value,
        equals('simulation_image_shared'),
      );
      expect(
        FirebaseEvent.simulationStateShared.value,
        equals('simulation_state_shared'),
      );
      expect(
        FirebaseEvent.shareDialogOpened.value,
        equals('share_dialog_opened'),
      );
      expect(FirebaseEvent.shareCancelled.value, equals('share_cancelled'));
      expect(FirebaseEvent.shareFailed.value, equals('share_failed'));
    });

    test('should follow snake_case convention for string values', () {
      for (final event in FirebaseEvent.values) {
        // Allow underscore suffix for prefix events
        expect(
          event.value,
          matches(RegExp(r'^[a-z]+(_[a-z]+)*_?$')),
          reason: '${event.value} should follow snake_case convention',
        );
      }
    });

    test('should group related events logically', () {
      // App lifecycle events
      final appEvents = FirebaseEvent.values
          .where((event) => event.value.startsWith('app_'))
          .toList();
      expect(
        appEvents.length,
        equals(3),
        reason: 'Should have exactly 3 app lifecycle events',
      );

      // Simulation lifecycle events
      final simulationEvents = FirebaseEvent.values
          .where(
            (event) =>
                event.value.startsWith('simulation_') &&
                event.value != 'simulation_',
          )
          .toList();
      expect(
        simulationEvents.length,
        equals(8),
        reason:
            'Should have exactly 8 simulation lifecycle events (5 original + 3 sharing)',
      );

      // Share events
      final shareEvents = FirebaseEvent.values
          .where((event) => event.value.contains('share'))
          .toList();
      expect(
        shareEvents.length,
        equals(6),
        reason: 'Should have exactly 6 share-related events',
      );

      // Purchase/subscription events
      final purchaseEvents = FirebaseEvent.values
          .where((event) => event.value.startsWith('purchase_'))
          .toList();
      expect(
        purchaseEvents.length,
        equals(7),
        reason: 'Should have exactly 7 purchase-related events',
      );

      // Stripe web payment events
      final stripeEvents = FirebaseEvent.values
          .where((event) => event.value.startsWith('stripe_'))
          .toList();
      expect(
        stripeEvents.length,
        equals(3),
        reason: 'Should have exactly 3 stripe payment events',
      );

      // Premium feature events
      final premiumEvents = FirebaseEvent.values
          .where((event) => event.value.startsWith('premium_'))
          .toList();
      expect(
        premiumEvents.length,
        equals(2),
        reason: 'Should have exactly 2 premium feature events',
      );

      // Session limit events
      final limitEvents = FirebaseEvent.values
          .where((event) => event.value.contains('limit'))
          .toList();
      expect(
        limitEvents.length,
        equals(2),
        reason: 'Should have exactly 2 limit-related events',
      );
    });

    test('should have all sharing events', () {
      final sharingEvents = [
        FirebaseEvent.simulationShared,
        FirebaseEvent.simulationImageShared,
        FirebaseEvent.simulationStateShared,
        FirebaseEvent.shareDialogOpened,
        FirebaseEvent.shareCancelled,
        FirebaseEvent.shareFailed,
      ];

      for (final event in sharingEvents) {
        expect(FirebaseEvent.values, contains(event));
        expect(event.value, contains('share'));
      }
    });

    test('should have all Stripe web payment events', () {
      final stripeEvents = [
        FirebaseEvent.stripePurchaseInitiated,
        FirebaseEvent.stripePurchaseCompleted,
        FirebaseEvent.stripePurchaseFailed,
      ];

      for (final event in stripeEvents) {
        expect(FirebaseEvent.values, contains(event));
        expect(event.value, startsWith('stripe_'));
      }

      // Verify correct string values
      expect(
        FirebaseEvent.stripePurchaseInitiated.value,
        equals('stripe_purchase_initiated'),
      );
      expect(
        FirebaseEvent.stripePurchaseCompleted.value,
        equals('stripe_purchase_completed'),
      );
      expect(
        FirebaseEvent.stripePurchaseFailed.value,
        equals('stripe_purchase_failed'),
      );
    });

    test('should have static methods for dynamic event creation', () {
      // Test UI event creation
      expect(FirebaseEvent.uiEvent('button_tap'), equals('ui_button_tap'));
      expect(
        FirebaseEvent.uiEvent('dialog_opened'),
        equals('ui_dialog_opened'),
      );
      expect(
        FirebaseEvent.uiEvent('gesture_start'),
        equals('ui_gesture_start'),
      );

      // Test simulation event creation
      expect(
        FirebaseEvent.simulationEvent('body_selected'),
        equals('simulation_body_selected'),
      );
      expect(
        FirebaseEvent.simulationEvent('camera_focus'),
        equals('simulation_camera_focus'),
      );
      expect(
        FirebaseEvent.simulationEvent('scenario_changed'),
        equals('simulation_scenario_changed'),
      );
    });

    test('should handle empty strings in static methods', () {
      expect(FirebaseEvent.uiEvent(''), equals('ui_'));
      expect(FirebaseEvent.simulationEvent(''), equals('simulation_'));
    });

    test('should create consistent event names with static methods', () {
      final testActions = ['test', 'action_name', 'multiple_words'];

      for (final action in testActions) {
        final uiEvent = FirebaseEvent.uiEvent(action);
        final simulationEvent = FirebaseEvent.simulationEvent(action);

        expect(uiEvent, startsWith('ui_'));
        expect(simulationEvent, startsWith('simulation_'));
        expect(uiEvent, endsWith(action));
        expect(simulationEvent, endsWith(action));
      }
    });

    test('should have comprehensive lifecycle coverage', () {
      // App lifecycle
      expect(FirebaseEvent.values, contains(FirebaseEvent.appInitialized));
      expect(FirebaseEvent.values, contains(FirebaseEvent.appStart));
      expect(FirebaseEvent.values, contains(FirebaseEvent.appError));

      // Simulation lifecycle - should cover all states
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationStarted));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationPaused));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationResumed));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationStopped));
      expect(FirebaseEvent.values, contains(FirebaseEvent.simulationReset));
    });

    test('should have proper Firebase Analytics naming', () {
      for (final event in FirebaseEvent.values) {
        // Firebase event names should not start with numbers
        expect(
          event.value,
          isNot(matches(RegExp(r'^[0-9]'))),
          reason: '${event.value} should not start with a number',
        );

        // Should not contain spaces or special characters (except underscore)
        expect(event.value, isNot(contains(' ')));
        expect(event.value, isNot(contains('-')));
        expect(event.value, isNot(contains('.')));
        expect(event.value, isNot(contains('#')));
      }
    });

    test('should have meaningful event names for analytics', () {
      final nonPrefixEvents = FirebaseEvent.values
          .where((event) => !event.value.endsWith('_'))
          .toList();

      for (final event in nonPrefixEvents) {
        expect(
          event.value.length,
          greaterThan(5),
          reason: '${event.value} should be descriptive for analytics',
        );
      }
    });
  });
}
