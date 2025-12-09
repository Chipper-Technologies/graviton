import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/ui/keyboard_navigation_service.dart';

void main() {
  group('KeyboardNavigationService', () {
    late KeyboardNavigationService service;

    setUp(() {
      service = KeyboardNavigationService.instance;
    });

    group('Singleton pattern', () {
      test('should return the same instance', () {
        final instance1 = KeyboardNavigationService.instance;
        final instance2 = KeyboardNavigationService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Enable/Disable functionality', () {
      test('should enable and disable keyboard navigation', () {
        service.setEnabled(false);

        bool callbackCalled = false;
        service.registerCallbacks(onPlayPause: () => callbackCalled = true);

        final handled = service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.space,
            physicalKey: PhysicalKeyboardKey.space,
            timeStamp: Duration.zero,
          ),
        );

        expect(handled, isFalse);
        expect(callbackCalled, isFalse);

        // Re-enable and test again
        service.setEnabled(true);

        final handledAfterEnable = service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.space,
            physicalKey: PhysicalKeyboardKey.space,
            timeStamp: Duration.zero,
          ),
        );

        expect(handledAfterEnable, isTrue);
        expect(callbackCalled, isTrue);
      });
    });

    group('Callback registration', () {
      test('should register and execute callbacks for different keys', () {
        bool spacePressed = false;
        bool rPressed = false;
        bool cPressed = false;

        service.registerCallbacks(
          onPlayPause: () => spacePressed = true,
          onReset: () => rPressed = true,
          onCenterCamera: () => cPressed = true,
        );

        // Test space key
        service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.space,
            physicalKey: PhysicalKeyboardKey.space,
            timeStamp: Duration.zero,
          ),
        );

        // Test R key
        service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.keyR,
            physicalKey: PhysicalKeyboardKey.keyR,
            timeStamp: Duration.zero,
          ),
        );

        // Test C key
        service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.keyC,
            physicalKey: PhysicalKeyboardKey.keyC,
            timeStamp: Duration.zero,
          ),
        );

        expect(spacePressed, isTrue);
        expect(rPressed, isTrue);
        expect(cPressed, isTrue);
      });

      test('should handle all registered shortcuts', () {
        final callbackResults = <String, bool>{};

        service.registerCallbacks(
          onPlayPause: () => callbackResults['playPause'] = true,
          onReset: () => callbackResults['reset'] = true,
          onCenterCamera: () => callbackResults['centerCamera'] = true,
          onToggleAutoRotate: () => callbackResults['autoRotate'] = true,
          onZoomIn: () => callbackResults['zoomIn'] = true,
          onZoomOut: () => callbackResults['zoomOut'] = true,
          onToggleTrails: () => callbackResults['trails'] = true,
          onToggleStats: () => callbackResults['stats'] = true,
          onToggleLabels: () => callbackResults['labels'] = true,
          onOpenSettings: () => callbackResults['settings'] = true,
        );

        final testCases = [
          (LogicalKeyboardKey.space, 'playPause'),
          (LogicalKeyboardKey.keyR, 'reset'),
          (LogicalKeyboardKey.keyC, 'centerCamera'),
          (LogicalKeyboardKey.keyA, 'autoRotate'),
          (LogicalKeyboardKey.equal, 'zoomIn'),
          (LogicalKeyboardKey.minus, 'zoomOut'),
          (LogicalKeyboardKey.keyT, 'trails'),
          (LogicalKeyboardKey.keyS, 'stats'),
          (LogicalKeyboardKey.keyL, 'labels'),
          (LogicalKeyboardKey.escape, 'settings'),
        ];

        for (final (key, expectedCallback) in testCases) {
          callbackResults.clear();

          service.handleKeyEvent(
            KeyDownEvent(
              logicalKey: key,
              physicalKey: PhysicalKeyboardKey.space, // Placeholder
              timeStamp: Duration.zero,
            ),
          );

          expect(
            callbackResults[expectedCallback],
            isTrue,
            reason: 'Callback for $expectedCallback should be called',
          );
        }
      });
    });

    group('Key event handling', () {
      test('should only handle KeyDownEvent events', () {
        bool callbackCalled = false;
        service.registerCallbacks(onPlayPause: () => callbackCalled = true);

        // Test KeyUpEvent (should not be handled)
        final upEventHandled = service.handleKeyEvent(
          const KeyUpEvent(
            logicalKey: LogicalKeyboardKey.space,
            physicalKey: PhysicalKeyboardKey.space,
            timeStamp: Duration.zero,
          ),
        );

        expect(upEventHandled, isFalse);
        expect(callbackCalled, isFalse);

        // Test KeyDownEvent (should be handled)
        final downEventHandled = service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.space,
            physicalKey: PhysicalKeyboardKey.space,
            timeStamp: Duration.zero,
          ),
        );

        expect(downEventHandled, isTrue);
        expect(callbackCalled, isTrue);
      });

      test('should not handle unregistered key events', () {
        final handled = service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.keyZ,
            physicalKey: PhysicalKeyboardKey.keyZ,
            timeStamp: Duration.zero,
          ),
        );

        expect(handled, isFalse);
      });

      test('should handle multiple key events in sequence', () {
        int spaceCount = 0;
        int rCount = 0;

        service.registerCallbacks(
          onPlayPause: () => spaceCount++,
          onReset: () => rCount++,
        );

        // Press space multiple times
        for (int i = 0; i < 3; i++) {
          service.handleKeyEvent(
            const KeyDownEvent(
              logicalKey: LogicalKeyboardKey.space,
              physicalKey: PhysicalKeyboardKey.space,
              timeStamp: Duration.zero,
            ),
          );
        }

        // Press R once
        service.handleKeyEvent(
          const KeyDownEvent(
            logicalKey: LogicalKeyboardKey.keyR,
            physicalKey: PhysicalKeyboardKey.keyR,
            timeStamp: Duration.zero,
          ),
        );

        expect(spaceCount, equals(3));
        expect(rCount, equals(1));
      });
    });

    group('Keyboard shortcuts help', () {
      test('should provide comprehensive keyboard shortcuts help', () {
        final help = service.getKeyboardShortcutsHelp();

        expect(help, isNotEmpty);
        expect(help, contains('Space'));
        expect(help, contains('Play/Pause'));
        expect(help, contains('R'));
        expect(help, contains('Reset'));
        expect(help, contains('C'));
        expect(help, contains('Center'));
        expect(help, contains('A'));
        expect(help, contains('auto-rotation'));
        expect(help, contains('Zoom'));
        expect(help, contains('T'));
        expect(help, contains('trails'));
        expect(help, contains('S'));
        expect(help, contains('statistics'));
        expect(help, contains('L'));
        expect(help, contains('labels'));
        expect(help, contains('Ctrl'));
        expect(help, contains('Esc'));
        expect(help, contains('settings'));
      });
    });

    group('Focus management', () {
      test('should handle focus requests', () {
        expect(() => service.requestFocus(), returnsNormally);
        expect(service.hasFocus, isA<bool>());
      });

      test('should provide focus node access', () {
        expect(service.simulationFocusNode, isNotNull);
      });
    });

    group('Widget creation', () {
      testWidgets('should create keyboard listener widget', (tester) async {
        final testWidget = service.createKeyboardListener(
          child: const Text('Test'),
        );

        expect(testWidget, isA<KeyboardListener>());
      });

      testWidgets('should create keyboard listener with custom focus', (
        tester,
      ) async {
        final testWidget = service.createKeyboardListener(
          child: const Text('Test'),
          requestFocus: false,
        );

        expect(testWidget, isA<KeyboardListener>());
      });
    });

    group('Edge cases', () {
      test('should handle null callbacks gracefully', () {
        service.registerCallbacks(); // No callbacks registered

        expect(
          () => service.handleKeyEvent(
            const KeyDownEvent(
              logicalKey: LogicalKeyboardKey.space,
              physicalKey: PhysicalKeyboardKey.space,
              timeStamp: Duration.zero,
            ),
          ),
          returnsNormally,
        );
      });

      test('should handle rapid key events', () {
        int callCount = 0;

        service.registerCallbacks(onPlayPause: () => callCount++);

        // Simulate rapid key presses
        for (int i = 0; i < 100; i++) {
          service.handleKeyEvent(
            const KeyDownEvent(
              logicalKey: LogicalKeyboardKey.space,
              physicalKey: PhysicalKeyboardKey.space,
              timeStamp: Duration.zero,
            ),
          );
        }

        expect(callCount, equals(100));
      });
    });

    group('Performance', () {
      test('should handle key events efficiently', () {
        int callCount = 0;
        service.registerCallbacks(onPlayPause: () => callCount++);

        final stopwatch = Stopwatch()..start();

        // Handle many key events
        const eventCount = 1000;
        for (int i = 0; i < eventCount; i++) {
          service.handleKeyEvent(
            const KeyDownEvent(
              logicalKey: LogicalKeyboardKey.space,
              physicalKey: PhysicalKeyboardKey.space,
              timeStamp: Duration.zero,
            ),
          );
        }

        stopwatch.stop();

        // Verify all events were processed correctly
        expect(callCount, equals(eventCount));

        // Performance check: should handle events at reasonable rate (> 100 events/sec)
        // This is a more lenient check that focuses on correctness while ensuring
        // no catastrophic performance regression
        final eventsPerSecond =
            (eventCount / stopwatch.elapsedMilliseconds) * 1000;
        expect(eventsPerSecond, greaterThan(100));
      });
    });

    group('Cleanup', () {
      test('should dispose resources', () {
        expect(() => service.dispose(), returnsNormally);
      });
    });
  });
}
