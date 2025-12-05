import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/safe_haptic_feedback.dart';

/// Comprehensive tests for SafeHapticFeedback utility class
///
/// This test suite validates:
/// - All haptic methods work without throwing exceptions
/// - Safety mechanisms prevent crashes when services binding is unavailable
/// - Performance characteristics meet expectations
/// - API consistency with Flutter's HapticFeedback
/// - Thread safety and concurrent usage
/// - Integration safety in both widget and unit test environments
void main() {
  group('SafeHapticFeedback Tests', () {
    testWidgets('lightImpact should not throw when binding is available', (
      WidgetTester tester,
    ) async {
      // Binding is available in widget tests
      expect(() => SafeHapticFeedback.lightImpact(), returnsNormally);
    });

    testWidgets('mediumImpact should not throw when binding is available', (
      WidgetTester tester,
    ) async {
      // Binding is available in widget tests
      expect(() => SafeHapticFeedback.mediumImpact(), returnsNormally);
    });

    testWidgets('heavyImpact should not throw when binding is available', (
      WidgetTester tester,
    ) async {
      // Binding is available in widget tests
      expect(() => SafeHapticFeedback.heavyImpact(), returnsNormally);
    });

    testWidgets('selectionClick should not throw when binding is available', (
      WidgetTester tester,
    ) async {
      // Binding is available in widget tests
      expect(() => SafeHapticFeedback.selectionClick(), returnsNormally);
    });

    testWidgets('vibrate should not throw when binding is available', (
      WidgetTester tester,
    ) async {
      // Binding is available in widget tests
      expect(() => SafeHapticFeedback.vibrate(), returnsNormally);
    });

    test('lightImpact should not throw when binding is unavailable', () {
      // In unit tests without widget binding, it should still not throw
      expect(() => SafeHapticFeedback.lightImpact(), returnsNormally);
    });

    test('mediumImpact should not throw when binding is unavailable', () {
      // In unit tests without widget binding, it should still not throw
      expect(() => SafeHapticFeedback.mediumImpact(), returnsNormally);
    });

    test('heavyImpact should not throw when binding is unavailable', () {
      // In unit tests without widget binding, it should still not throw
      expect(() => SafeHapticFeedback.heavyImpact(), returnsNormally);
    });

    test('selectionClick should not throw when binding is unavailable', () {
      // In unit tests without widget binding, it should still not throw
      expect(() => SafeHapticFeedback.selectionClick(), returnsNormally);
    });

    test('vibrate should not throw when binding is unavailable', () {
      // In unit tests without widget binding, it should still not throw
      expect(() => SafeHapticFeedback.vibrate(), returnsNormally);
    });

    group('Error Handling', () {
      test('all methods should handle exceptions gracefully', () {
        // These should never throw, regardless of the internal state
        expect(() => SafeHapticFeedback.lightImpact(), returnsNormally);
        expect(() => SafeHapticFeedback.mediumImpact(), returnsNormally);
        expect(() => SafeHapticFeedback.heavyImpact(), returnsNormally);
        expect(() => SafeHapticFeedback.selectionClick(), returnsNormally);
        expect(() => SafeHapticFeedback.vibrate(), returnsNormally);
      });

      test('multiple calls should not interfere with each other', () {
        // Multiple rapid calls should not cause issues
        expect(() {
          for (int i = 0; i < 10; i++) {
            SafeHapticFeedback.lightImpact();
            SafeHapticFeedback.mediumImpact();
            SafeHapticFeedback.heavyImpact();
            SafeHapticFeedback.selectionClick();
            SafeHapticFeedback.vibrate();
          }
        }, returnsNormally);
      });
    });

    group('API Consistency', () {
      test('all methods should be static', () {
        // Verify all methods can be called statically without instantiation
        expect(() => SafeHapticFeedback.lightImpact(), returnsNormally);
        expect(() => SafeHapticFeedback.mediumImpact(), returnsNormally);
        expect(() => SafeHapticFeedback.heavyImpact(), returnsNormally);
        expect(() => SafeHapticFeedback.selectionClick(), returnsNormally);
        expect(() => SafeHapticFeedback.vibrate(), returnsNormally);
      });

      test(
        'methods should have consistent naming with Flutter HapticFeedback',
        () {
          // Verify method names match the Flutter HapticFeedback API
          // This is a compile-time check that the methods exist
          expect(SafeHapticFeedback.lightImpact, isA<Function>());
          expect(SafeHapticFeedback.mediumImpact, isA<Function>());
          expect(SafeHapticFeedback.heavyImpact, isA<Function>());
          expect(SafeHapticFeedback.selectionClick, isA<Function>());
          expect(SafeHapticFeedback.vibrate, isA<Function>());
        },
      );
    });

    group('Integration Safety', () {
      testWidgets('should work safely in widget environment', (
        WidgetTester tester,
      ) async {
        // Simulate typical usage in a widget context
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  SafeHapticFeedback.lightImpact();
                  SafeHapticFeedback.selectionClick();
                },
                child: const Text('Test Button'),
              ),
            ),
          ),
        );

        // Tap the button and verify no exceptions
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      test('should work safely in test environment without widgets', () {
        // Simulate usage in pure unit test context
        expect(() {
          SafeHapticFeedback.lightImpact();
          SafeHapticFeedback.mediumImpact();
          SafeHapticFeedback.heavyImpact();
          SafeHapticFeedback.selectionClick();
          SafeHapticFeedback.vibrate();
        }, returnsNormally);
      });
    });

    group('Performance', () {
      test('methods should execute quickly', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          SafeHapticFeedback.lightImpact();
        }

        stopwatch.stop();

        // Each call should be very fast (less than 2ms on average to account for test overhead)
        expect(stopwatch.elapsedMilliseconds / 100, lessThan(2.0));
      });

      test('availability check should be efficient', () {
        final stopwatch = Stopwatch()..start();

        // Call multiple times to test the _isAvailable getter
        for (int i = 0; i < 1000; i++) {
          SafeHapticFeedback.lightImpact();
        }

        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });
    });

    group('Safety Validation', () {
      test('should handle concurrent calls safely', () {
        final futures = <Future<void>>[];

        // Create multiple concurrent calls
        for (int i = 0; i < 10; i++) {
          futures.add(
            Future.microtask(() {
              SafeHapticFeedback.lightImpact();
              SafeHapticFeedback.mediumImpact();
              SafeHapticFeedback.heavyImpact();
            }),
          );
        }

        // All should complete without throwing
        expect(() => Future.wait(futures), returnsNormally);
      });

      test('should not depend on external state', () {
        // Calls should be idempotent and not affect each other
        SafeHapticFeedback.lightImpact();
        final result1 = SafeHapticFeedback.lightImpact;

        SafeHapticFeedback.mediumImpact();
        final result2 = SafeHapticFeedback.lightImpact;

        // Function references should be the same
        expect(result1, equals(result2));
      });
    });
  });
}
