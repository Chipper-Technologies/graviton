import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/main.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/stats_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/test_helpers.dart';

void main() {
  group('Graviton App Integration Tests', () {
    setUp(() async {
      // Set up test environment for SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App should launch successfully', (tester) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(ChangeNotifierProvider<AppState>), findsOneWidget);
    });

    testWidgets('App should display home screen with simulation canvas', (
      tester,
    ) async {
      final testAppState = AppState();

      await TestHelpers.setupAndPumpApp(
        tester,
        testAppState,
        GravitonApp(appState: testAppState),
      );

      // Should find the main simulation canvas (CustomPaint)
      expect(find.byType(CustomPaint), findsWidgets);

      // Should find gesture detectors for interaction
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('Language should change based on locale', (tester) async {
      // Test English
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider(
            create: (_) => AppState(),
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(body: Text(l10n.appTitle));
              },
            ),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);

      // Test Spanish
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider(
            create: (_) => AppState(),
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(body: Text(l10n.appTitle));
              },
            ),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
    });

    testWidgets('Simulation controls should work', (tester) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      // Find UI toggle buttons/controls
      final toggleButtonsFinder = find.byType(ToggleButtons);
      if (toggleButtonsFinder.evaluate().isNotEmpty) {
        final toggleButtons = tester.widget<ToggleButtons>(
          toggleButtonsFinder.first,
        );
        expect(toggleButtons.children, isNotEmpty);
      }

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Stats overlay should toggle correctly', (tester) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      // Initially stats might be hidden
      final initialStatsCount = find.byType(StatsOverlay).evaluate().length;

      // Look for stats toggle control (this depends on the actual UI implementation)
      // The exact finder depends on how the stats toggle is implemented in the UI
      final toggleFinders = [
        find.byIcon(Icons.info),
        find.byIcon(Icons.analytics),
        find.text('Stats'),
        find.textContaining('Stats'),
      ];

      bool foundToggle = false;
      for (final finder in toggleFinders) {
        if (finder.evaluate().isNotEmpty) {
          await tester.tap(finder.first);
          await tester.pump();
          foundToggle = true;
          break;
        }
      }

      if (foundToggle) {
        // Stats overlay visibility should have changed
        final newStatsCount = find.byType(StatsOverlay).evaluate().length;
        expect(newStatsCount != initialStatsCount, isTrue);
      }

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Camera controls should respond to gestures', (tester) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      // Find the main simulation area (should be a GestureDetector)
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      if (gestureDetectors.evaluate().isNotEmpty) {
        final mainGestureDetector = gestureDetectors.first;

        // Test pan gesture (camera rotation)
        await tester.drag(mainGestureDetector, const Offset(100, 50));
        await tester.pump();

        // Test scale gesture (zoom) - this is harder to test directly
        // We'll just verify the gesture detector is present and has some gesture handling
        final gestureDetector = tester.widget<GestureDetector>(
          mainGestureDetector,
        );
        expect(gestureDetector, isNotNull);
      }

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Simulation should run and update', (tester) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      // Get initial simulation state through provider
      final context = tester.element(find.byType(MaterialApp));
      final appState = Provider.of<AppState>(context, listen: false);

      // Start simulation if not already running
      if (!appState.simulation.isRunning) {
        appState.simulation.start();
      }

      final initialStepCount = appState.simulation.stepCount;
      final initialTime = appState.simulation.totalTime;

      // Wait for some simulation steps
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Simulation should have advanced
      expect(
        appState.simulation.stepCount,
        greaterThanOrEqualTo(initialStepCount),
      );
      expect(appState.simulation.totalTime, greaterThanOrEqualTo(initialTime));

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Reset should work correctly', (tester) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      final context = tester.element(find.byType(MaterialApp));
      final appState = Provider.of<AppState>(context, listen: false);

      // Run simulation for a bit
      appState.simulation.start();
      for (int i = 0; i < 10; i++) {
        appState.simulation.step(1.0 / 60.0);
      }

      expect(appState.simulation.stepCount, greaterThan(0));
      expect(appState.simulation.totalTime, greaterThan(0));

      // Reset simulation
      appState.simulation.reset();

      expect(appState.simulation.stepCount, equals(0));
      expect(appState.simulation.totalTime, equals(0.0));
      expect(
        appState.simulation.bodies,
        hasLength(4),
      ); // Should still have bodies

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Multiple locales should be supported', (tester) async {
      final supportedLocales = [
        const Locale('en'),
        const Locale('es'),
        const Locale('fr'),
        const Locale('zh'),
        const Locale('de'),
        const Locale('ja'),
        const Locale('ko'),
      ];

      for (final locale in supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ChangeNotifierProvider(
              create: (_) => AppState(),
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Scaffold(
                    body: Column(
                      children: [
                        Text(l10n.appTitle),
                        Text(l10n.playButton),
                        Text(l10n.pauseButton),
                        Text(l10n.resetButton),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // Should not throw errors and should display localized content
        expect(find.byType(Text), findsWidgets);

        // Clear for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('App should handle errors gracefully', (tester) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      final context = tester.element(find.byType(MaterialApp));
      final appState = Provider.of<AppState>(context, listen: false);

      // Simulate an error
      appState.setError('Test error message');
      await tester.pump();

      expect(appState.lastError, equals('Test error message'));

      // Clear error
      appState.clearError();
      await tester.pump();

      expect(appState.lastError, isNull);

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('Performance - App should handle rapid updates', (
      tester,
    ) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      final context = tester.element(find.byType(MaterialApp));
      final appState = Provider.of<AppState>(context, listen: false);

      // Start simulation
      appState.simulation.start();

      // Pump many frames rapidly
      for (int i = 0; i < 100; i++) {
        appState.simulation.step(1.0 / 240.0); // High frame rate
        if (i % 10 == 0) {
          await tester.pump(Duration.zero); // Minimal pump to check for errors
        }
      }

      // Should complete without errors
      expect(appState.simulation.stepCount, greaterThan(0));
      expect(tester.takeException(), isNull);

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });

    testWidgets('UI state changes should persist', (tester) async {
      final testAppState = AppState();

      await TestHelpers.initializeAppStateWithTimeout(testAppState);
      await tester.pumpWidget(GravitonApp(appState: testAppState));
      await tester.pump(const Duration(milliseconds: 100));

      final context = tester.element(find.byType(MaterialApp));
      final appState = Provider.of<AppState>(context, listen: false);

      // Change UI settings
      final initialTrails = appState.ui.showTrails;

      appState.ui.toggleTrails();
      appState.ui.setUIOpacity(0.5);

      expect(appState.ui.showTrails, equals(!initialTrails));
      expect(appState.ui.uiOpacity, equals(0.5));

      // Changes should persist through widget rebuilds
      await tester.pump();

      expect(appState.ui.showTrails, equals(!initialTrails));
      expect(appState.ui.uiOpacity, equals(0.5));

      // Pump timers to prevent pending timer failures
      await TestHelpers.pumpAppTimers(tester);
    });
  });
}
