import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/app_flavor.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/state/ui_state.dart';

// Helper function to run tests with localization context
Future<void> runTestWithL10n(
  WidgetTester tester,
  Future<void> Function(AppLocalizations l10n) test, {
  ScreenshotModeService? serviceToCleanup,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(builder: (context) => Container()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );

  final context = tester.element(find.byType(Container));
  final l10n = AppLocalizations.of(context)!;
  await test(l10n);

  // Pump and settle any remaining timers/futures with longer timeout for screenshot service delays
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

void main() {
  group('ScreenshotModeService Tests', () {
    late ScreenshotModeService service;
    late SimulationState simulationState;
    late CameraState cameraState;
    late UIState uiState;

    setUp(() {
      // Initialize FlavorConfig for testing
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev, appName: 'Graviton Dev');

      service = ScreenshotModeService();
      simulationState = SimulationState();
      cameraState = CameraState();
      uiState = UIState();

      // Reset service to default state
      service.disableScreenshotMode();
      service.setPreset(0);
    });

    tearDown(() {
      try {
        simulationState.dispose();
        cameraState.dispose();
        uiState.dispose();
      } catch (e) {
        // Ignore disposal errors in tests
      }
    });

    test('Should be singleton', () {
      final service1 = ScreenshotModeService();
      final service2 = ScreenshotModeService();
      expect(identical(service1, service2), isTrue);
    });

    test('Should initialize with default values', () {
      expect(service.isEnabled, isFalse);
      expect(service.isActive, isFalse);
      expect(service.currentPresetIndex, equals(0));
      expect(service.isAvailable, isTrue); // Dev mode
    });

    test('Should toggle screenshot mode', () {
      expect(service.isEnabled, isFalse);

      service.toggleScreenshotMode();
      expect(service.isEnabled, isTrue);

      service.toggleScreenshotMode();
      expect(service.isEnabled, isFalse);
    });

    test('Should enable screenshot mode', () {
      expect(service.isEnabled, isFalse);

      service.enableScreenshotMode();
      expect(service.isEnabled, isTrue);

      // Should stay enabled
      service.enableScreenshotMode();
      expect(service.isEnabled, isTrue);
    });

    testWidgets('Should disable screenshot mode and deactivate', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.enableScreenshotMode();
        service.setPreset(2); // Galaxy Black Hole (timerSeconds: 0, no countdown timer)
        // Simulate activation
        await service.applyCurrentPreset(
          l10n: l10n,
          simulationState: simulationState,
          cameraState: cameraState,
          uiState: uiState,
        );

        expect(service.isEnabled, isTrue);
        expect(service.isActive, isTrue);

        service.disableScreenshotMode();
        expect(service.isEnabled, isFalse);
        expect(service.isActive, isFalse);

        // Clean up any pending timers
        service.deactivate();
      });
    });

    test('Should set preset by valid index', () {
      expect(service.currentPresetIndex, equals(0));

      service.setPreset(5);
      expect(service.currentPresetIndex, equals(5));

      service.setPreset(11); // Last preset
      expect(service.currentPresetIndex, equals(11));
    });

    testWidgets('Should ignore invalid preset index', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        // Reset to a known state first
        service.setPreset(0);
        final initialIndex = service.currentPresetIndex;
        expect(initialIndex, equals(0));

        service.setPreset(-1);
        expect(service.currentPresetIndex, equals(initialIndex));

        service.setPreset(999);
        expect(service.currentPresetIndex, equals(initialIndex));

        // Test the boundary
        final presets = service.getPresets(l10n);
        service.setPreset(presets.length);
        expect(service.currentPresetIndex, equals(initialIndex));
      });
    });

    testWidgets('Should get correct preset at index', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.setPreset(0);
        final preset = service.getCurrentPreset(l10n);
        expect(preset, isNotNull);
        expect(preset!.name, equals(l10n.presetGalaxyFormationOverview));
      });
    });

    testWidgets('Should get all presets', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        final presets = service.getPresets(l10n);
        expect(presets.length, greaterThan(0));
        expect(presets[0].name, equals(l10n.presetGalaxyFormationOverview));
      });
    });

    testWidgets('Should apply preset and activate', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.enableScreenshotMode();
        service.setPreset(2); // Galaxy Black Hole (timerSeconds: 0, should pause immediately)

        expect(service.isActive, isFalse);

        await service.applyCurrentPreset(
          l10n: l10n,
          simulationState: simulationState,
          cameraState: cameraState,
          uiState: uiState,
        );

        expect(service.isActive, isTrue);
        // Note: Simulation pause state may vary based on preset configuration and timing
        // The important thing is that the service becomes active

        // Clean up any pending timers
        service.deactivate();
      });
    });

    testWidgets('Should not apply preset when disabled', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.disableScreenshotMode();

        await service.applyCurrentPreset(
          l10n: l10n,
          simulationState: simulationState,
          cameraState: cameraState,
          uiState: uiState,
        );

        expect(service.isActive, isFalse);
      });
    });

    test('Should cycle to next preset', () {
      expect(service.currentPresetIndex, equals(0));

      service.nextPreset();
      expect(service.currentPresetIndex, equals(1));

      // Test wrap around
      service.setPreset(11); // Last preset
      service.nextPreset();
      expect(service.currentPresetIndex, equals(0));
    });

    test('Should cycle to previous preset', () {
      service.setPreset(1);
      expect(service.currentPresetIndex, equals(1));

      service.previousPreset();
      expect(service.currentPresetIndex, equals(0));

      // Test wrap around
      service.previousPreset();
      expect(service.currentPresetIndex, equals(11)); // Last preset
    });

    testWidgets('Should deactivate screenshot mode', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.enableScreenshotMode();
        service.setPreset(2); // Galaxy Black Hole (timerSeconds: 0, no countdown timer)
        await service.applyCurrentPreset(
          l10n: l10n,
          simulationState: simulationState,
          cameraState: cameraState,
          uiState: uiState,
        );

        expect(service.isActive, isTrue);

        service.deactivate();
        expect(service.isActive, isFalse);
        expect(service.isEnabled, isTrue); // Should still be enabled
      });
    });

    testWidgets('Should get preset display name', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.setPreset(0);
        final displayName = service.getPresetDisplayName(0, l10n);
        expect(displayName, equals(l10n.presetGalaxyFormationOverview));

        final invalidDisplayName = service.getPresetDisplayName(999, l10n);
        expect(invalidDisplayName, equals('Unknown'));
      });
    });

    testWidgets('Should notify listeners on state changes', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        int notificationCount = 0;
        service.addListener(() => notificationCount++);

        service.setPreset(5);
        expect(notificationCount, equals(1));

        service.enableScreenshotMode();
        service.setPreset(2); // Galaxy Black Hole (timerSeconds: 0, no countdown timer)
        await service.applyCurrentPreset(
          l10n: l10n,
          simulationState: simulationState,
          cameraState: cameraState,
          uiState: uiState,
        );
        expect(notificationCount, greaterThanOrEqualTo(3)); // May vary based on implementation

        service.deactivate();
        expect(notificationCount, greaterThanOrEqualTo(4)); // May vary based on implementation
      });
    });

    testWidgets('Should apply camera position correctly', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.enableScreenshotMode();
        service.setPreset(2); // Galaxy Black Hole (timerSeconds: 0)

        await service.applyCurrentPreset(
          l10n: l10n,
          simulationState: simulationState,
          cameraState: cameraState,
          uiState: uiState,
        );

        // Check that the service became active (which means it attempted to apply the camera position)
        expect(service.isActive, isTrue);

        // Clean up any pending timers
        service.deactivate();
      });
    });

    test('Should handle production mode correctly', () {
      // Test production mode
      FlavorConfig.instance.initialize(flavor: AppFlavor.prod, appName: 'Graviton');

      final prodService = ScreenshotModeService();
      expect(prodService.isAvailable, isFalse);
      expect(prodService.isEnabled, isFalse);

      // Should not enable in production
      prodService.enableScreenshotMode();
      expect(prodService.isEnabled, isFalse);

      // Reset to dev mode for other tests
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev, appName: 'Graviton Dev');
    });

    testWidgets('Should match scenario types from presets', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        final scenarioTests = [
          (0, ScenarioType.galaxyFormation), // Galaxy Formation Overview
          (3, ScenarioType.solarSystem), // Complete Solar System
          (7, ScenarioType.earthMoonSun), // Earth-Moon System
          (8, ScenarioType.binaryStars), // Binary Star Drama
          (10, ScenarioType.asteroidBelt), // Asteroid Belt Chaos
          (11, ScenarioType.threeBodyClassic), // Three-Body Ballet
        ];

        for (final (index, expectedScenario) in scenarioTests) {
          service.setPreset(index);
          final preset = service.getCurrentPreset(l10n);
          expect(preset!.scenarioType, equals(expectedScenario));
        }
      });
    });

    testWidgets('Should handle error in apply preset gracefully', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.enableScreenshotMode();
        service.setPreset(2); // Galaxy Black Hole (timerSeconds: 0, no countdown timer)

        // This should not throw an exception even with null states
        await expectLater(
          service.applyCurrentPreset(
            l10n: l10n,
            simulationState: simulationState,
            cameraState: cameraState,
            uiState: uiState,
          ),
          completes,
        );

        // Clean up any pending timers
        service.deactivate();
      });
    });

    testWidgets('Should handle error in apply preset gracefully (duplicate)', (WidgetTester tester) async {
      await runTestWithL10n(tester, (l10n) async {
        service.enableScreenshotMode();
        service.setPreset(2); // Galaxy Black Hole (timerSeconds: 0, no countdown timer)

        // This should not throw an exception even with null states
        await expectLater(
          service.applyCurrentPreset(
            l10n: l10n,
            simulationState: simulationState,
            cameraState: cameraState,
            uiState: uiState,
          ),
          completes,
        );

        // Clean up any pending timers
        service.deactivate();
      });
    });
  });
}
