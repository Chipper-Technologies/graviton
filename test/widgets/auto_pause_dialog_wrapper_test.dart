import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/simulation_status.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/auto_pause_dialog_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

void main() {
  group('AutoPauseDialogWrapper', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    testWidgets('pauses running simulation when dialog opens', (tester) async {
      // Start simulation
      appState.simulation.start();
      await tester.pumpAndSettle();

      expect(appState.simulation.status, equals(SimulationStatus.running));

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AutoPauseDialogWrapper.show(
                        context: context,
                        child: const AlertDialog(title: Text('Test Dialog')),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Tap button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify simulation was paused
      expect(appState.simulation.status, equals(SimulationStatus.paused));
    });

    testWidgets('resumes simulation when dialog closes', (tester) async {
      // Start simulation
      appState.simulation.start();
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AutoPauseDialogWrapper.show(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Test Dialog'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(appState.simulation.status, equals(SimulationStatus.paused));

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify simulation resumed
      expect(appState.simulation.status, equals(SimulationStatus.running));
    });

    testWidgets('does not resume if simulation was already paused', (
      tester,
    ) async {
      // Start with paused simulation
      appState.simulation.start();
      appState.simulation.pauseSimulation();
      await tester.pumpAndSettle();

      expect(appState.simulation.status, equals(SimulationStatus.paused));

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AutoPauseDialogWrapper.show(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Test Dialog'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Show and close dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify simulation remains paused
      expect(appState.simulation.status, equals(SimulationStatus.paused));
    });

    testWidgets('handles barrierDismissible correctly', (tester) async {
      appState.simulation.start();

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AutoPauseDialogWrapper.show(
                        context: context,
                        barrierDismissible: false,
                        child: const AlertDialog(title: Text('Test Dialog')),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.text('Test Dialog'), findsOneWidget);

      // Try to dismiss by tapping barrier
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible (not dismissible)
      expect(find.text('Test Dialog'), findsOneWidget);
    });

    testWidgets('renders child widget correctly', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AutoPauseDialogWrapper.show(
                        context: context,
                        child: const AlertDialog(
                          title: Text('Custom Title'),
                          content: Text('Custom Content'),
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify child content is rendered
      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Custom Content'), findsOneWidget);
    });

    testWidgets('handles missing AppState gracefully', (tester) async {
      // Widget without AppState provider
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    AutoPauseDialogWrapper.show(
                      context: context,
                      child: const AlertDialog(title: Text('Test Dialog')),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              );
            },
          ),
        ),
      );

      // Should not throw when AppState is missing
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsOneWidget);
    });

    testWidgets('static show method returns dialog result', (tester) async {
      String? result;

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      result = await AutoPauseDialogWrapper.show<String>(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Test Dialog'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'result'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals('result'));
    });

    testWidgets('handles custom barrier color', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AutoPauseDialogWrapper.show(
                        context: context,
                        barrierColor: AppColors.uiRed.withValues(
                          alpha: AppTypography.opacityMedium,
                        ),
                        child: const AlertDialog(title: Text('Test Dialog')),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog should be visible with custom barrier
      expect(find.text('Test Dialog'), findsOneWidget);
    });

    testWidgets('direct widget construction works', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MaterialApp(
            home: AutoPauseDialogWrapper(
              child: AlertDialog(title: Text('Direct Widget')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Direct Widget'), findsOneWidget);
    });
  });
}
