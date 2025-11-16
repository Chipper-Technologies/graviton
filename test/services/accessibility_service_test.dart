import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/accessibility_service.dart';
import 'package:graviton/l10n/app_localizations.dart';
import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccessibilityService', () {
    late AccessibilityService accessibilityService;
    late AppLocalizations mockL10n;

    setUp(() {
      accessibilityService = AccessibilityService.instance;
      mockL10n = TestUtils.createMockAppLocalizations();
    });

    group('singleton pattern', () {
      test('should return same instance', () {
        final instance1 = AccessibilityService.instance;
        final instance2 = AccessibilityService.instance;

        expect(instance1, same(instance2));
      });
    });

    group('announceToScreenReader', () {
      test('should not throw when called with valid message', () {
        const message = 'Test announcement';

        expect(
          () => accessibilityService.announceToScreenReader(message),
          returnsNormally,
        );
      });

      test('should not throw when called with empty message', () {
        expect(
          () => accessibilityService.announceToScreenReader(''),
          returnsNormally,
        );
      });
    });

    group('announceSimulationEvent', () {
      test('should not throw when called with event and context', () {
        const event = 'Simulation started';
        const context = 'Bodies are moving';

        expect(
          () => accessibilityService.announceSimulationEvent(
            event,
            additionalContext: context,
          ),
          returnsNormally,
        );
      });

      test('should not throw when called with event only', () {
        const event = 'Simulation paused';

        expect(
          () => accessibilityService.announceSimulationEvent(event),
          returnsNormally,
        );
      });
    });

    group('announceMergeEvent', () {
      test('should not throw when called with localization', () {
        const body1 = 'Earth';
        const body2 = 'Mars';

        expect(
          () => accessibilityService.announceMergeEvent(
            body1,
            body2,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });
    });

    group('announceSimulationStateChange', () {
      test('should not throw with running state', () {
        const state = 'running';

        expect(
          () => accessibilityService.announceSimulationStateChange(
            state,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should not throw with paused state', () {
        const state = 'paused';

        expect(
          () => accessibilityService.announceSimulationStateChange(
            state,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should not throw with unknown state', () {
        const state = 'unknown';

        expect(
          () => accessibilityService.announceSimulationStateChange(
            state,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });
    });

    group('announceScenarioChange', () {
      test('should not throw when called', () {
        const scenarioName = 'Solar System';

        expect(
          () => accessibilityService.announceScenarioChange(
            scenarioName,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });
    });

    group('announcePhysicsChange', () {
      test('should not throw with speed parameter', () {
        const parameter = 'speed';
        const value = '2.5';

        expect(
          () => accessibilityService.announcePhysicsChange(
            parameter,
            value,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should not throw with gravity parameter', () {
        const parameter = 'gravity';
        const value = '9.81';

        expect(
          () => accessibilityService.announcePhysicsChange(
            parameter,
            value,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should not throw with unknown parameter', () {
        const parameter = 'temperature';
        const value = '300.0';

        expect(
          () => accessibilityService.announcePhysicsChange(
            parameter,
            value,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should handle collisionradius parameter', () {
        const parameter = 'collisionradius';
        const value = '1.5';

        expect(
          () => accessibilityService.announcePhysicsChange(
            parameter,
            value,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should handle case insensitive parameters', () {
        const parameter = 'SPEED';
        const value = '3.0';

        expect(
          () => accessibilityService.announcePhysicsChange(
            parameter,
            value,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });
    });

    group('announceCameraAction', () {
      test('should not throw with reset action', () {
        const action = 'reset';

        expect(
          () =>
              accessibilityService.announceCameraAction(action, l10n: mockL10n),
          returnsNormally,
        );
      });

      test('should not throw with focus action', () {
        const action = 'focus';

        expect(
          () =>
              accessibilityService.announceCameraAction(action, l10n: mockL10n),
          returnsNormally,
        );
      });

      test('should not throw with unknown action', () {
        const action = 'rotate';

        expect(
          () =>
              accessibilityService.announceCameraAction(action, l10n: mockL10n),
          returnsNormally,
        );
      });

      test('should handle follow and unfollow actions', () {
        const followAction = 'follow';
        const unfollowAction = 'unfollow';

        expect(
          () => accessibilityService.announceCameraAction(
            followAction,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
        expect(
          () => accessibilityService.announceCameraAction(
            unfollowAction,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should handle case insensitive actions', () {
        const action = 'RESET';

        expect(
          () =>
              accessibilityService.announceCameraAction(action, l10n: mockL10n),
          returnsNormally,
        );
      });
    });

    group('announceTutorialProgress', () {
      test('should not throw when called', () {
        const stepName = 'Adjust gravity settings';
        const currentStep = 3;
        const totalSteps = 5;

        expect(
          () => accessibilityService.announceTutorialProgress(
            stepName,
            currentStep,
            totalSteps,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });
    });

    group('announceError', () {
      test('should not throw when called', () {
        const errorMessage = 'Physics calculation failed';

        expect(
          () =>
              accessibilityService.announceError(errorMessage, l10n: mockL10n),
          returnsNormally,
        );
      });
    });

    group('announceSettingChange', () {
      test('should not throw with enabled setting', () {
        const settingName = 'Show trails';
        const isEnabled = true;

        expect(
          () => accessibilityService.announceSettingChange(
            settingName,
            isEnabled,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should not throw with disabled setting', () {
        const settingName = 'Auto-pause';
        const isEnabled = false;

        expect(
          () => accessibilityService.announceSettingChange(
            settingName,
            isEnabled,
            l10n: mockL10n,
          ),
          returnsNormally,
        );
      });
    });
  });
}
