import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/ui_state.dart';

void main() {
  group('UIState Fullscreen Functionality', () {
    late UIState uiState;

    setUp(() {
      uiState = UIState();
    });

    group('Initial State', () {
      test('should start with fullscreen disabled', () {
        expect(uiState.isFullscreen, isFalse);
      });
    });

    group('Fullscreen State Management', () {
      test('should set fullscreen state', () {
        expect(uiState.isFullscreen, isFalse);

        uiState.setFullscreen(true);

        expect(uiState.isFullscreen, isTrue);
      });

      test('should toggle fullscreen state', () {
        expect(uiState.isFullscreen, isFalse);

        uiState.toggleFullscreen();
        expect(uiState.isFullscreen, isTrue);

        uiState.toggleFullscreen();
        expect(uiState.isFullscreen, isFalse);
      });

      test('should handle setting same state multiple times', () {
        uiState.setFullscreen(true);
        expect(uiState.isFullscreen, isTrue);

        uiState.setFullscreen(true);
        expect(uiState.isFullscreen, isTrue);

        uiState.setFullscreen(false);
        expect(uiState.isFullscreen, isFalse);

        uiState.setFullscreen(false);
        expect(uiState.isFullscreen, isFalse);
      });
    });

    group('State Notifications', () {
      test('should notify listeners when fullscreen state changes', () {
        var notificationCount = 0;

        uiState.addListener(() {
          notificationCount++;
        });

        uiState.setFullscreen(true);
        expect(notificationCount, equals(1));

        uiState.setFullscreen(false);
        expect(notificationCount, equals(2));
      });

      test('should notify listeners when toggling fullscreen', () {
        var notificationCount = 0;

        uiState.addListener(() {
          notificationCount++;
        });

        uiState.toggleFullscreen();
        expect(notificationCount, equals(1));

        uiState.toggleFullscreen();
        expect(notificationCount, equals(2));
      });
    });

    group('Integration with Other UI State', () {
      test('should work independently of other UI settings', () {
        // Change other settings
        uiState.toggleTrails();
        uiState.toggleLabels();
        uiState.setUIOpacity(0.5);

        // Fullscreen should still work
        expect(uiState.isFullscreen, isFalse);

        uiState.setFullscreen(true);
        expect(uiState.isFullscreen, isTrue);

        // Other settings should be unaffected
        expect(uiState.showTrails, isFalse); // Was toggled from default true
        expect(uiState.showLabels, isFalse); // Was toggled from default true
        expect(uiState.uiOpacity, equals(0.5));
      });
    });

    group('State Persistence', () {
      test('should maintain state across multiple operations', () {
        // Perform various operations
        uiState.setFullscreen(true);
        uiState.toggleTrails();
        uiState.setFullscreen(false);
        uiState.toggleLabels();
        uiState.setFullscreen(true);

        // Final state should be correct
        expect(uiState.isFullscreen, isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle rapid state changes', () {
        // Rapid toggles
        for (int i = 0; i < 10; i++) {
          uiState.toggleFullscreen();
        }

        // Should end up in a consistent state (false after even number of toggles)
        expect(uiState.isFullscreen, isFalse);
      });

      test('should handle rapid set operations', () {
        // Rapid set calls
        for (int i = 0; i < 5; i++) {
          uiState.setFullscreen(true);
          uiState.setFullscreen(false);
        }

        expect(uiState.isFullscreen, isFalse);
      });
    });

    group('Listener Management', () {
      test('should properly handle listener addition and removal', () {
        var notificationCount = 0;

        void listener() {
          notificationCount++;
        }

        uiState.addListener(listener);
        uiState.setFullscreen(true);
        expect(notificationCount, equals(1));

        uiState.removeListener(listener);
        uiState.setFullscreen(false);
        expect(notificationCount, equals(1)); // Should not have incremented
      });

      test('should handle multiple listeners', () {
        var count1 = 0;
        var count2 = 0;

        uiState.addListener(() => count1++);
        uiState.addListener(() => count2++);

        uiState.setFullscreen(true);

        expect(count1, equals(1));
        expect(count2, equals(1));
      });
    });
  });
}
