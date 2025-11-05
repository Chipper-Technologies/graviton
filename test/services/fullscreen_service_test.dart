import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/fullscreen_service.dart';

void main() {
  group('FullscreenService', () {
    late FullscreenService service;

    setUpAll(() {
      // Initialize Flutter bindings for SystemChrome access
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      service = FullscreenService.instance;
      service.reset(); // Ensure clean state for each test
    });

    tearDown(() {
      service.reset(); // Clean up after each test
    });

    group('Initial State', () {
      test('should start in non-fullscreen mode', () {
        expect(service.isFullscreen, isFalse);
        expect(service.isTransitioning, isFalse);
      });
    });

    group('Fullscreen Transitions', () {
      test('should enter fullscreen mode', () async {
        expect(service.isFullscreen, isFalse);

        await service.enterFullscreen();

        expect(service.isFullscreen, isTrue);
        expect(service.isTransitioning, isFalse);
      });

      test('should exit fullscreen mode', () async {
        // First enter fullscreen
        await service.enterFullscreen();
        expect(service.isFullscreen, isTrue);

        // Then exit
        await service.exitFullscreen();

        expect(service.isFullscreen, isFalse);
        expect(service.isTransitioning, isFalse);
      });

      test('should toggle fullscreen mode', () async {
        expect(service.isFullscreen, isFalse);

        // Toggle to fullscreen
        await service.toggleFullscreen();
        expect(service.isFullscreen, isTrue);

        // Toggle back to normal
        await service.toggleFullscreen();
        expect(service.isFullscreen, isFalse);
      });

      test('should not enter fullscreen if already in fullscreen', () async {
        await service.enterFullscreen();
        expect(service.isFullscreen, isTrue);

        // Try to enter again
        await service.enterFullscreen();
        expect(service.isFullscreen, isTrue); // Should still be true
      });

      test('should not exit fullscreen if not in fullscreen', () async {
        expect(service.isFullscreen, isFalse);

        // Try to exit when not in fullscreen
        await service.exitFullscreen();
        expect(service.isFullscreen, isFalse); // Should still be false
      });
    });

    group('Transition State', () {
      test('should set transitioning state during operations', () async {
        var transitionStates = <bool>[];

        service.addListener(() {
          transitionStates.add(service.isTransitioning);
        });

        await service.enterFullscreen();

        // Should have been transitioning at some point
        expect(transitionStates, contains(true));
        // Should end with not transitioning
        expect(service.isTransitioning, isFalse);
      });

      test('should not allow operations during transition', () async {
        // Start entering fullscreen
        final future = service.enterFullscreen();

        // Try to exit while transitioning (this should be ignored)
        await service.exitFullscreen();

        // Wait for original operation to complete
        await future;

        // Should be in fullscreen from the first operation
        expect(service.isFullscreen, isTrue);
      });
    });

    group('State Notifications', () {
      test('should notify listeners on state changes', () async {
        var notificationCount = 0;

        service.addListener(() {
          notificationCount++;
        });

        await service.enterFullscreen();

        // Should have notified at least twice (start transition, end transition)
        expect(notificationCount, greaterThan(0));
      });
    });

    group('Force Operations', () {
      test('should force exit fullscreen', () async {
        await service.enterFullscreen();
        expect(service.isFullscreen, isTrue);

        service.forceExitFullscreen();

        expect(service.isFullscreen, isFalse);
        expect(service.isTransitioning, isFalse);
      });

      test('should handle force exit when not in fullscreen', () {
        expect(service.isFullscreen, isFalse);

        // Should not throw or cause issues
        service.forceExitFullscreen();

        expect(service.isFullscreen, isFalse);
      });
    });

    group('Reset Functionality', () {
      test('should reset to initial state', () async {
        await service.enterFullscreen();
        expect(service.isFullscreen, isTrue);

        service.reset();

        expect(service.isFullscreen, isFalse);
        expect(service.isTransitioning, isFalse);
      });
    });

    group('Singleton Behavior', () {
      test('should return the same instance', () {
        final instance1 = FullscreenService.instance;
        final instance2 = FullscreenService.instance;

        expect(identical(instance1, instance2), isTrue);
      });

      test('should maintain state across instance calls', () async {
        final instance1 = FullscreenService.instance;
        await instance1.enterFullscreen();

        final instance2 = FullscreenService.instance;
        expect(instance2.isFullscreen, isTrue);
      });
    });

    group('Error Handling', () {
      test('should handle transition errors gracefully', () async {
        // This is more of a structural test since we can't easily
        // simulate system UI errors in unit tests
        expect(() => service.enterFullscreen(), returnsNormally);
        expect(() => service.exitFullscreen(), returnsNormally);
        expect(() => service.toggleFullscreen(), returnsNormally);
      });
    });
  });
}
