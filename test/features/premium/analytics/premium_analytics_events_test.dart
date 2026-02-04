import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/firebase_event.dart';

/// Tests for premium-related analytics events
///
/// Verifies that all purchase and session analytics events are properly
/// defined and have consistent naming conventions.
void main() {
  group('Premium Analytics Events', () {
    group('Purchase Events', () {
      test('purchaseStarted event exists', () {
        expect(FirebaseEvent.purchaseStarted, isNotNull);
        expect(FirebaseEvent.purchaseStarted.name, equals('purchaseStarted'));
      });

      test('purchaseCompleted event exists', () {
        expect(FirebaseEvent.purchaseCompleted, isNotNull);
        expect(
          FirebaseEvent.purchaseCompleted.name,
          equals('purchaseCompleted'),
        );
      });

      test('purchaseFailed event exists', () {
        expect(FirebaseEvent.purchaseFailed, isNotNull);
        expect(FirebaseEvent.purchaseFailed.name, equals('purchaseFailed'));
      });

      test('purchaseCancelled event exists', () {
        expect(FirebaseEvent.purchaseCancelled, isNotNull);
        expect(
          FirebaseEvent.purchaseCancelled.name,
          equals('purchaseCancelled'),
        );
      });
    });

    group('Restore Purchase Events', () {
      test('purchaseRestoreStarted event exists', () {
        expect(FirebaseEvent.purchaseRestoreStarted, isNotNull);
        expect(
          FirebaseEvent.purchaseRestoreStarted.name,
          equals('purchaseRestoreStarted'),
        );
      });

      test('purchaseRestoreCompleted event exists', () {
        expect(FirebaseEvent.purchaseRestoreCompleted, isNotNull);
        expect(
          FirebaseEvent.purchaseRestoreCompleted.name,
          equals('purchaseRestoreCompleted'),
        );
      });

      test('purchaseRestoreFailed event exists', () {
        expect(FirebaseEvent.purchaseRestoreFailed, isNotNull);
        expect(
          FirebaseEvent.purchaseRestoreFailed.name,
          equals('purchaseRestoreFailed'),
        );
      });
    });

    group('Session Events', () {
      test('freeSessionStarted event exists', () {
        expect(FirebaseEvent.freeSessionStarted, isNotNull);
        expect(
          FirebaseEvent.freeSessionStarted.name,
          equals('freeSessionStarted'),
        );
      });

      test('freeSessionEnded event exists', () {
        expect(FirebaseEvent.freeSessionEnded, isNotNull);
        expect(FirebaseEvent.freeSessionEnded.name, equals('freeSessionEnded'));
      });
    });

    group('Paywall Events', () {
      test('paywallOpened event exists', () {
        expect(FirebaseEvent.paywallOpened, isNotNull);
        expect(FirebaseEvent.paywallOpened.name, equals('paywallOpened'));
      });

      test('paywallClosed event exists', () {
        expect(FirebaseEvent.paywallClosed, isNotNull);
        expect(FirebaseEvent.paywallClosed.name, equals('paywallClosed'));
      });
    });

    group('Event Naming Conventions', () {
      test('all purchase events follow naming convention', () {
        final purchaseEvents = [
          FirebaseEvent.purchaseStarted,
          FirebaseEvent.purchaseCompleted,
          FirebaseEvent.purchaseFailed,
          FirebaseEvent.purchaseCancelled,
          FirebaseEvent.purchaseRestoreStarted,
          FirebaseEvent.purchaseRestoreCompleted,
          FirebaseEvent.purchaseRestoreFailed,
        ];

        for (final event in purchaseEvents) {
          expect(
            event.name.startsWith('purchase'),
            isTrue,
            reason: '${event.name} should start with "purchase"',
          );
        }
      });

      test('all session events follow naming convention', () {
        final sessionEvents = [
          FirebaseEvent.freeSessionStarted,
          FirebaseEvent.freeSessionEnded,
        ];

        for (final event in sessionEvents) {
          expect(
            event.name.contains('Session'),
            isTrue,
            reason: '${event.name} should contain "Session"',
          );
        }
      });

      test('all paywall events follow naming convention', () {
        final paywallEvents = [
          FirebaseEvent.paywallOpened,
          FirebaseEvent.paywallClosed,
        ];

        for (final event in paywallEvents) {
          expect(
            event.name.startsWith('paywall'),
            isTrue,
            reason: '${event.name} should start with "paywall"',
          );
        }
      });
    });

    group('Event Coverage', () {
      test('complete purchase lifecycle is covered', () {
        // A purchase flow should have: start, complete/fail/cancel
        expect(FirebaseEvent.purchaseStarted, isNotNull);
        expect(FirebaseEvent.purchaseCompleted, isNotNull);
        expect(FirebaseEvent.purchaseFailed, isNotNull);
        expect(FirebaseEvent.purchaseCancelled, isNotNull);
      });

      test('complete restore lifecycle is covered', () {
        // A restore flow should have: start, complete/fail
        expect(FirebaseEvent.purchaseRestoreStarted, isNotNull);
        expect(FirebaseEvent.purchaseRestoreCompleted, isNotNull);
        expect(FirebaseEvent.purchaseRestoreFailed, isNotNull);
      });

      test('complete session lifecycle is covered', () {
        // A session should have: start, end
        expect(FirebaseEvent.freeSessionStarted, isNotNull);
        expect(FirebaseEvent.freeSessionEnded, isNotNull);
      });

      test('complete paywall lifecycle is covered', () {
        // A paywall should have: open, close
        expect(FirebaseEvent.paywallOpened, isNotNull);
        expect(FirebaseEvent.paywallClosed, isNotNull);
      });
    });
  });
}
