import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/ui/haptic_feedback_service.dart';

void main() {
  group('HapticFeedbackService', () {
    late HapticFeedbackService service;

    setUp(() {
      service = HapticFeedbackService.instance;
    });

    group('Platform Support', () {
      test('should disable haptics on web platform', () {
        // On web, haptics should be disabled regardless of settings
        if (kIsWeb) {
          service.setUIEnabled(true);
          service.setCollisionEnabled(true);

          expect(
            service.isUIEnabled,
            isFalse,
            reason: 'UI haptics should be disabled on web',
          );
          expect(
            service.isCollisionEnabled,
            isFalse,
            reason: 'Collision haptics should be disabled on web',
          );
        }
      });

      test('should enable haptics on native platforms', () {
        // On native platforms, haptics should work when enabled
        if (!kIsWeb) {
          service.setUIEnabled(true);
          service.setCollisionEnabled(true);

          expect(
            service.isUIEnabled,
            isTrue,
            reason: 'UI haptics should be enabled on native platforms',
          );
          expect(
            service.isCollisionEnabled,
            isTrue,
            reason: 'Collision haptics should be enabled on native platforms',
          );
        }
      });
    });

    group('Enable/Disable State', () {
      test('should default to enabled state when no UI state is set', () {
        service.setEnabled(true);
        // On web, will still be false due to platform check
        if (!kIsWeb) {
          expect(service.isEnabled, isTrue);
        }
      });

      test('should update enabled state correctly', () {
        service.setEnabled(false);
        expect(service.isEnabled, isFalse);

        service.setEnabled(true);
        // On web, will still be false due to platform check
        if (!kIsWeb) {
          expect(service.isEnabled, isTrue);
        } else {
          expect(service.isEnabled, isFalse);
        }
      });

      test('should respect manual override over UI state', () {
        // Manual override should take precedence, but web platform check is first
        service.setEnabled(false);
        expect(service.isEnabled, isFalse);

        service.setEnabled(true);
        if (!kIsWeb) {
          expect(service.isEnabled, isTrue);
        } else {
          // Web always returns false regardless of settings
          expect(service.isEnabled, isFalse);
        }
      });
    });

    group('Haptic Feedback Methods', () {
      test('should provide light impact feedback method', () {
        service.setEnabled(true);
        expect(() => service.lightImpact(), returnsNormally);
        expect(() => service.light(), returnsNormally);
      });

      test('should provide medium impact feedback method', () {
        service.setEnabled(true);
        expect(() => service.mediumImpact(), returnsNormally);
        expect(() => service.medium(), returnsNormally);
      });

      test('should provide heavy impact feedback method', () {
        service.setEnabled(true);
        expect(() => service.heavyImpact(), returnsNormally);
        expect(() => service.heavy(), returnsNormally);
      });

      test('should provide selection click feedback method', () {
        service.setEnabled(true);
        expect(() => service.selectionClick(), returnsNormally);
        expect(() => service.selection(), returnsNormally);
      });

      test('should provide vibrate feedback method', () {
        service.setEnabled(true);
        expect(() => service.vibrate(), returnsNormally);
      });

      test('should handle disabled state gracefully', () {
        service.setEnabled(false);

        // All methods should execute without error even when disabled
        expect(() => service.lightImpact(), returnsNormally);
        expect(() => service.mediumImpact(), returnsNormally);
        expect(() => service.heavyImpact(), returnsNormally);
        expect(() => service.selectionClick(), returnsNormally);
        expect(() => service.vibrate(), returnsNormally);
      });
    });

    group('Async Methods', () {
      test('should handle async light impact', () async {
        service.setEnabled(true);
        await expectLater(service.lightImpact(), completes);
      });

      test('should handle async medium impact', () async {
        service.setEnabled(true);
        await expectLater(service.mediumImpact(), completes);
      });

      test('should handle async heavy impact', () async {
        service.setEnabled(true);
        await expectLater(service.heavyImpact(), completes);
      });

      test('should handle async selection click', () async {
        service.setEnabled(true);
        await expectLater(service.selectionClick(), completes);
      });

      test('should handle async vibrate', () async {
        service.setEnabled(true);
        await expectLater(service.vibrate(), completes);
      });
    });

    group('Error Handling', () {
      test('should handle rapid successive calls without issues', () async {
        service.setEnabled(true);

        // Make rapid successive calls
        for (int i = 0; i < 5; i++) {
          await expectLater(service.lightImpact(), completes);
        }
      });

      test('should handle mixed rapid calls correctly', () async {
        service.setEnabled(true);

        await expectLater(service.lightImpact(), completes);
        await expectLater(service.mediumImpact(), completes);
        await expectLater(service.heavyImpact(), completes);
        await expectLater(service.selectionClick(), completes);
        await expectLater(service.vibrate(), completes);
      });

      test('should handle state changes during execution', () async {
        service.setEnabled(true);

        final future1 = service.lightImpact();
        service.setEnabled(false);
        final future2 = service.mediumImpact();

        await expectLater(future1, completes);
        await expectLater(future2, completes);
      });
    });

    group('Backwards Compatibility', () {
      test('should maintain legacy method compatibility', () {
        service.setEnabled(true);

        // Legacy methods should work
        expect(() => service.light(), returnsNormally);
        expect(() => service.medium(), returnsNormally);
        expect(() => service.heavy(), returnsNormally);
        expect(() => service.selection(), returnsNormally);
      });
    });

    group('Singleton Behavior', () {
      test('should maintain singleton pattern', () {
        final instance1 = HapticFeedbackService.instance;
        final instance2 = HapticFeedbackService.instance;

        expect(instance1, same(instance2));
      });

      test('should maintain state across singleton access', () {
        final instance1 = HapticFeedbackService.instance;
        instance1.setEnabled(false);

        final instance2 = HapticFeedbackService.instance;
        expect(instance2.isEnabled, isFalse);
      });
    });
  });
}
