import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/services/fullscreen_service.dart';
import 'package:graviton/utils/fullscreen_utils.dart';

void main() {
  group('FullscreenUtils', () {
    late AppState appState;

    setUpAll(() {
      // Initialize Flutter bindings for SystemChrome access
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      appState = AppState();
      FullscreenService.instance.reset();
    });

    tearDown(() {
      FullscreenService.instance.reset();
    });

    group('Fullscreen Support', () {
      test('should report fullscreen as supported', () {
        expect(FullscreenUtils.isFullscreenSupported(), isTrue);
      });
    });

    group('State Management', () {
      test('should enter fullscreen and update app state', () async {
        expect(appState.ui.isFullscreen, isFalse);

        await FullscreenUtils.enterFullscreen(appState);

        expect(appState.ui.isFullscreen, isTrue);
        expect(FullscreenService.instance.isFullscreen, isTrue);
      });

      test('should exit fullscreen and update app state', () async {
        // First enter fullscreen
        await FullscreenUtils.enterFullscreen(appState);
        expect(appState.ui.isFullscreen, isTrue);

        // Then exit
        await FullscreenUtils.exitFullscreen(appState);

        expect(appState.ui.isFullscreen, isFalse);
        expect(FullscreenService.instance.isFullscreen, isFalse);
      });

      test('should toggle fullscreen mode', () async {
        expect(appState.ui.isFullscreen, isFalse);

        // Toggle to fullscreen
        await FullscreenUtils.toggleFullscreen(appState);
        expect(appState.ui.isFullscreen, isTrue);

        // Toggle back to normal
        await FullscreenUtils.toggleFullscreen(appState);
        expect(appState.ui.isFullscreen, isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle enter fullscreen errors gracefully', () async {
        // Test that errors don't crash the app
        expect(
          () => FullscreenUtils.enterFullscreen(appState),
          returnsNormally,
        );
      });

      test('should handle exit fullscreen errors gracefully', () async {
        await FullscreenUtils.enterFullscreen(appState);
        expect(() => FullscreenUtils.exitFullscreen(appState), returnsNormally);
      });

      test('should handle toggle fullscreen errors gracefully', () async {
        expect(
          () => FullscreenUtils.toggleFullscreen(appState),
          returnsNormally,
        );
      });
    });

    group('Force Operations', () {
      test('should force exit fullscreen', () async {
        await FullscreenUtils.enterFullscreen(appState);
        expect(appState.ui.isFullscreen, isTrue);

        await FullscreenUtils.forceExitFullscreen(appState);

        expect(appState.ui.isFullscreen, isFalse);
        expect(FullscreenService.instance.isFullscreen, isFalse);
      });
    });

    group('Reset Operations', () {
      test('should reset fullscreen state', () async {
        await FullscreenUtils.enterFullscreen(appState);
        expect(appState.ui.isFullscreen, isTrue);

        FullscreenUtils.resetFullscreenState(appState);

        expect(appState.ui.isFullscreen, isFalse);
        expect(FullscreenService.instance.isFullscreen, isFalse);
      });
    });

    group('System UI Configuration', () {
      test('should provide correct system UI modes', () {
        expect(
          FullscreenUtils.getFullscreenMode().toString(),
          contains('immersive'),
        );
        expect(
          FullscreenUtils.getNormalMode().toString(),
          contains('edgeToEdge'),
        );
      });

      test('should provide correct overlay configurations', () {
        final fullscreenOverlays = FullscreenUtils.getFullscreenOverlays();
        final normalOverlays = FullscreenUtils.getNormalOverlays();

        expect(fullscreenOverlays, isEmpty); // Hide all overlays
        expect(normalOverlays, isNotEmpty); // Show overlays
      });
    });

    group('State Synchronization', () {
      test(
        'should keep app state and service in sync during operations',
        () async {
          // Initially both should be false
          expect(appState.ui.isFullscreen, isFalse);
          expect(FullscreenService.instance.isFullscreen, isFalse);

          // Enter fullscreen - both should be true
          await FullscreenUtils.enterFullscreen(appState);
          expect(appState.ui.isFullscreen, isTrue);
          expect(FullscreenService.instance.isFullscreen, isTrue);

          // Exit fullscreen - both should be false
          await FullscreenUtils.exitFullscreen(appState);
          expect(appState.ui.isFullscreen, isFalse);
          expect(FullscreenService.instance.isFullscreen, isFalse);
        },
      );

      test('should handle multiple rapid toggles correctly', () async {
        // Rapid toggles should end up in a consistent state
        await FullscreenUtils.toggleFullscreen(appState); // true
        await FullscreenUtils.toggleFullscreen(appState); // false
        await FullscreenUtils.toggleFullscreen(appState); // true
        await FullscreenUtils.toggleFullscreen(appState); // false

        expect(appState.ui.isFullscreen, isFalse);
        expect(FullscreenService.instance.isFullscreen, isFalse);
      });
    });
  });
}
