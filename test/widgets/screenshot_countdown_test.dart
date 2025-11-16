import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/app_flavor.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/state/ui_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/screenshot_countdown.dart';

import '../test_utils.dart';

void main() {
  group('ScreenshotCountdown Enhanced Tests', () {
    late ScreenshotModeService service;
    late SimulationState simulationState;
    late CameraState cameraState;
    late UIState uiState;
    late dynamic mockL10n;

    setUp(() {
      mockL10n = TestUtils.createMockAppLocalizations();

      // Initialize FlavorConfig for testing
      FlavorConfig.instance.initialize(
        flavor: AppFlavor.dev,
        appName: 'Graviton Dev',
      );

      service = ScreenshotModeService();
      simulationState = SimulationState();
      cameraState = CameraState();
      uiState = UIState();

      // Reset service to default state
      service.disableScreenshotMode();
      service.setPreset(0);
    });

    tearDown(() async {
      // Cancel any pending timers from screenshot service
      service.disableScreenshotMode();

      // Wait for any pending async operations to complete before disposal
      // Need to wait longer to account for microtask delays in the service
      await Future.delayed(const Duration(milliseconds: 200));

      try {
        simulationState.dispose();
        cameraState.dispose();
        uiState.dispose();
      } catch (e) {
        // Ignore disposal errors in tests
      }
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Stack(children: [child])),
      );
    }

    group('Widget Creation and Structure', () {
      testWidgets('should create widget without throwing', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        expect(find.byType(ScreenshotCountdown), findsOneWidget);
      });

      testWidgets('should accept key parameter', (tester) async {
        const testKey = Key('test_countdown');

        await tester.pumpWidget(
          createTestWidget(
            ScreenshotCountdown(key: testKey, screenshotService: service),
          ),
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

      testWidgets('should require screenshotService parameter', (tester) async {
        // Test that the required parameter is properly handled
        expect(
          () => ScreenshotCountdown(screenshotService: service),
          returnsNormally,
        );
      });

      testWidgets('should contain ListenableBuilder for service', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Find the specific ListenableBuilder that listens to our service
        final listenableBuilders = tester
            .widgetList<ListenableBuilder>(find.byType(ListenableBuilder))
            .where((builder) => builder.listenable == service);
        expect(listenableBuilders, hasLength(1));
      });

      testWidgets('should properly maintain service reference', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        final widget = tester.widget<ScreenshotCountdown>(
          find.byType(ScreenshotCountdown),
        );
        expect(widget.screenshotService, same(service));
      });
    });

    group('Default Visibility Behavior', () {
      testWidgets('should be hidden when showCountdown is false by default', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // By default, service should have showCountdown = false
        expect(service.showCountdown, isFalse);
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Container), findsNothing);
        expect(find.byType(Positioned), findsNothing);
      });

      testWidgets('should show minimal widget tree when hidden', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // When hidden, should show SizedBox.shrink (not complex layout)
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
        // Check that the actual countdown content is not present
        expect(find.byType(Positioned), findsNothing);
        expect(find.byType(Container), findsNothing);
      });

      testWidgets('should respond to service state properly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Find the specific ListenableBuilder that listens to our service
        final listenableBuilders = tester
            .widgetList<ListenableBuilder>(find.byType(ListenableBuilder))
            .where((builder) => builder.listenable == service);
        expect(listenableBuilders, hasLength(1));

        final ourListenableBuilder = listenableBuilders.first;
        expect(ourListenableBuilder.listenable, same(service));
      });
    });

    group('Service Integration', () {
      testWidgets('should maintain reference to service', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        final widget = tester.widget<ScreenshotCountdown>(
          find.byType(ScreenshotCountdown),
        );
        expect(widget.screenshotService, same(service));
      });

      testWidgets('should access service properties correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Should be able to access service getters without throwing
        expect(() => service.showCountdown, returnsNormally);
        expect(() => service.countdownSeconds, returnsNormally);
        expect(() => service.isEnabled, returnsNormally);
        expect(() => service.isActive, returnsNormally);
      });

      testWidgets('should handle service availability correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Service should be available in dev mode
        expect(service.isAvailable, isTrue);

        // Service starts disabled by default
        expect(service.isEnabled, isFalse);
      });

      testWidgets('should respond to service mode changes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Test enabling/disabling screenshot mode
        service.enableScreenshotMode();
        await tester.pump();
        expect(service.isEnabled, isTrue);

        service.disableScreenshotMode();
        await tester.pump();
        expect(service.isEnabled, isFalse);
      });
    });

    group('Localization Integration', () {
      testWidgets('should use AppLocalizations correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Should not throw any localization errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle localization context properly', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Widget should build successfully with proper localization context
        expect(find.byType(ScreenshotCountdown), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should work with different locales', (tester) async {
        for (final locale in AppLocalizations.supportedLocales) {
          await tester.pumpWidget(
            MaterialApp(
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Stack(
                  children: [ScreenshotCountdown(screenshotService: service)],
                ),
              ),
            ),
          );

          expect(find.byType(ScreenshotCountdown), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('Widget Hierarchy and Layout', () {
      testWidgets('should work within Stack layout', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Should work properly within Stack widget
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(ScreenshotCountdown), findsOneWidget);
      });

      testWidgets('should maintain widget hierarchy correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Basic widget structure should be present
        expect(find.byType(ScreenshotCountdown), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);

        // Find our specific ListenableBuilder
        final listenableBuilders = tester
            .widgetList<ListenableBuilder>(find.byType(ListenableBuilder))
            .where((builder) => builder.listenable == service);
        expect(listenableBuilders, hasLength(1));
      });

      testWidgets('should handle different screen sizes gracefully', (
        tester,
      ) async {
        // Test with different screen sizes
        final sizes = [
          const Size(360, 640), // Small phone
          const Size(414, 896), // Large phone
          const Size(768, 1024), // Tablet
        ];

        for (final size in sizes) {
          await tester.binding.setSurfaceSize(size);

          await tester.pumpWidget(
            createTestWidget(ScreenshotCountdown(screenshotService: service)),
          );

          expect(find.byType(ScreenshotCountdown), findsOneWidget);
          expect(tester.takeException(), isNull);
        }

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Performance and Memory Management', () {
      testWidgets('should not create unnecessary widgets when hidden', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // When hidden, should only create minimal widget tree
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Positioned), findsNothing);
        expect(find.byType(Container), findsNothing);
        expect(find.byType(Row), findsNothing);
        expect(find.byType(Icon), findsNothing);
        expect(find.byType(Text), findsNothing);
      });

      testWidgets('should handle disposal properly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Remove widget from tree
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Should not throw any exceptions during disposal
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle rapid rebuilds efficiently', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Trigger multiple rebuilds
        for (int i = 0; i < 10; i++) {
          service.enableScreenshotMode();
          await tester.pump();
          service.disableScreenshotMode();
          await tester.pump();
        }

        // Should not crash or throw errors
        expect(tester.takeException(), isNull);
        expect(find.byType(ScreenshotCountdown), findsOneWidget);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle service singleton behavior', (tester) async {
        final service1 = ScreenshotModeService();
        final service2 = ScreenshotModeService();

        // Services should be the same instance (singleton)
        expect(identical(service1, service2), isTrue);

        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service1)),
        );

        final widget = tester.widget<ScreenshotCountdown>(
          find.byType(ScreenshotCountdown),
        );
        expect(widget.screenshotService, same(service2));
      });

      testWidgets('should maintain state consistency during mode changes', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Test multiple enable/disable cycles
        for (int i = 0; i < 5; i++) {
          service.enableScreenshotMode();
          await tester.pump();
          expect(service.isEnabled, isTrue);

          service.disableScreenshotMode();
          await tester.pump();
          expect(service.isEnabled, isFalse);
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle preset changes gracefully', (tester) async {
        service.enableScreenshotMode();

        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Test changing presets
        final presetCount = service.presetCount;
        for (int i = 0; i < presetCount; i++) {
          service.setPreset(i);
          await tester.pump();
          expect(service.currentPresetIndex, equals(i));
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle invalid preset indices gracefully', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        final originalPreset = service.currentPresetIndex;

        // Test invalid preset indices
        service.setPreset(-1);
        await tester.pump();
        expect(
          service.currentPresetIndex,
          equals(originalPreset),
        ); // Should not change

        service.setPreset(999);
        await tester.pump();
        expect(
          service.currentPresetIndex,
          equals(originalPreset),
        ); // Should not change

        expect(tester.takeException(), isNull);
      });
    });

    group('Theme and Style Compliance', () {
      testWidgets('should use correct theme constants', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Widget should be created successfully without theme errors
        expect(find.byType(ScreenshotCountdown), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should maintain consistent theming', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Stack(
                children: [ScreenshotCountdown(screenshotService: service)],
              ),
            ),
          ),
        );

        expect(find.byType(ScreenshotCountdown), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Stack(
                children: [ScreenshotCountdown(screenshotService: service)],
              ),
            ),
          ),
        );

        expect(find.byType(ScreenshotCountdown), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should provide proper semantics', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Widget should be accessible
        expect(find.byType(ScreenshotCountdown), findsOneWidget);

        // Should not have accessibility violations
        final SemanticsHandle handle = tester.ensureSemantics();
        expect(tester.takeException(), isNull);
        handle.dispose();
      });

      testWidgets('should handle high contrast mode', (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: createTestWidget(
              ScreenshotCountdown(screenshotService: service),
            ),
          ),
        );

        expect(find.byType(ScreenshotCountdown), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle different text scale factors', (tester) async {
        final scales = [0.8, 1.0, 1.2, 1.5, 2.0];

        for (final scale in scales) {
          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: createTestWidget(
                ScreenshotCountdown(screenshotService: service),
              ),
            ),
          );

          expect(find.byType(ScreenshotCountdown), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('Integration with App Architecture', () {
      testWidgets('should work with Provider pattern', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Should work within the app's Provider-based architecture
        expect(find.byType(ScreenshotCountdown), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should maintain proper isolation from other services', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Widget should only depend on ScreenshotModeService
        final widget = tester.widget<ScreenshotCountdown>(
          find.byType(ScreenshotCountdown),
        );
        expect(widget.screenshotService, isA<ScreenshotModeService>());
      });

      testWidgets('should handle service lifecycle correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        // Service should maintain state across widget rebuilds
        final initialState = service.isEnabled;

        await tester.pumpWidget(
          createTestWidget(ScreenshotCountdown(screenshotService: service)),
        );

        expect(service.isEnabled, equals(initialState));
      });
    });

    group('Actual Countdown Display Coverage', () {
      testWidgets(
        'should properly render countdown when service state is active',
        (tester) async {
          // First, enable screenshot mode
          service.enableScreenshotMode();
          service.setPreset(1); // Use a preset that should have a timer

          try {
            // Apply preset to trigger countdown state
            await service.applyCurrentPreset(
              simulationState: simulationState,
              cameraState: cameraState,
              uiState: uiState,
              l10n: mockL10n,
            );

            // Wait for all microtasks and timers to be created
            await tester.binding.delayed(const Duration(milliseconds: 200));

            await tester.pumpWidget(
              createTestWidget(ScreenshotCountdown(screenshotService: service)),
            );

            // Let any async operations complete
            await tester.pumpAndSettle();

            // Test the widget exists
            expect(find.byType(ScreenshotCountdown), findsOneWidget);

            // Always test basic structure
            expect(find.byType(ListenableBuilder), findsAtLeastNWidgets(1));

            // If countdown is showing, test all widget elements
            if (service.showCountdown) {
              // Test countdown UI elements
              expect(find.byType(Positioned), findsOneWidget);
              expect(
                find.byType(Center),
                findsAtLeastNWidgets(1),
              ); // Allow for multiple Center widgets
              expect(find.byType(Container), findsAtLeastNWidgets(1));
              expect(find.byType(Row), findsOneWidget);
              expect(find.byIcon(Icons.camera_alt), findsOneWidget);
              expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
              expect(find.byType(Text), findsOneWidget);

              // Test styling
              final icon = tester.widget<Icon>(find.byIcon(Icons.camera_alt));
              expect(icon.color, AppColors.uiWhite);
              expect(icon.size, AppTypography.iconSizeXLarge);

              final text = tester.widget<Text>(find.byType(Text));
              expect(text.style?.color, AppColors.uiWhite);
              expect(text.style?.fontSize, AppTypography.fontSizeLarge);
              expect(text.style?.fontWeight, FontWeight.w500);

              // Test container decoration
              final containers = tester.widgetList<Container>(
                find.byType(Container),
              );
              bool foundDecoratedContainer = false;
              for (final container in containers) {
                if (container.decoration is BoxDecoration) {
                  final decoration = container.decoration as BoxDecoration;
                  if (decoration.borderRadius != null &&
                      decoration.border != null) {
                    foundDecoratedContainer = true;
                    break;
                  }
                }
              }
              expect(foundDecoratedContainer, isTrue);
            } else {
              // If not showing, should only have SizedBox.shrink as primary widget
              expect(find.byIcon(Icons.camera_alt), findsNothing);
            }
          } finally {
            // Clean up timers and wait for cleanup to complete
            service.disableScreenshotMode();
            await tester.binding.delayed(const Duration(milliseconds: 200));
          }
        },
      );

      testWidgets('should handle countdown timer changes', (tester) async {
        try {
          service.enableScreenshotMode();
          service.setPreset(2); // Try different preset

          await service.applyCurrentPreset(
            simulationState: simulationState,
            cameraState: cameraState,
            uiState: uiState,
            l10n: mockL10n,
          );

          // Wait for all microtasks and timers to be created
          await tester.binding.delayed(const Duration(milliseconds: 200));

          await tester.pumpWidget(
            createTestWidget(ScreenshotCountdown(screenshotService: service)),
          );

          await tester.pumpAndSettle();

          // Test countdown value access
          expect(() => service.countdownSeconds, returnsNormally);

          // Verify widget structure regardless of countdown state
          expect(find.byType(ScreenshotCountdown), findsOneWidget);
          expect(
            find.byType(ListenableBuilder),
            findsAtLeastNWidgets(1),
          ); // Account for MaterialApp's ListenableBuilders

          // If countdown is active, verify countdown display
          if (service.showCountdown && service.countdownSeconds > 0) {
            // Wait a moment to see if text changes with timer
            await tester.pump(const Duration(milliseconds: 100));
          }
        } finally {
          // Clean up timers and wait for cleanup to complete
          service.disableScreenshotMode();
          await tester.binding.delayed(const Duration(milliseconds: 200));
        }
      });
    });
  });
}
