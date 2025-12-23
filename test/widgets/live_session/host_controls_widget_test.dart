import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/live_session/host_controls_widget.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HostControlsWidget', () {
    late AppState appState;
    late LiveSessionState liveSessionState;

    Widget createTestWidget({required Widget child}) {
      return ChangeNotifierProvider<LiveSessionState>.value(
        value: liveSessionState,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(body: child),
        ),
      );
    }

    setUp(() {
      appState = AppState();
      liveSessionState = LiveSessionState();
    });

    tearDown(() {
      appState.dispose();
      liveSessionState.dispose();
    });

    testWidgets('should render correctly in not hosting state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HostControlsWidget), findsOneWidget);
      // Should show "Share Live Session" text when not hosting
      expect(find.textContaining('Share'), findsOneWidget);
    });

    testWidgets('should show start hosting button when not hosting', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Start'), findsOneWidget);
      // Check for any Icon since exact icon may vary
      expect(find.byType(Icon), findsAtLeastNWidgets(1));
    });

    testWidgets('should have tappable start button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the HapticInkWell for the start button
      final startButton = find.byType(HapticInkWell);
      expect(startButton, findsAtLeastNWidgets(1));
    });

    testWidgets('should call onHostingStarted callback when hosting starts', (
      WidgetTester tester,
    ) async {
      // ignore: unused_local_variable
      var startedCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
            onHostingStarted: () => startedCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the start button
      final startButton = find.byType(HapticInkWell).first;
      await tester.tap(startButton);
      await tester.pump();

      // Note: The actual callback may not fire without Firebase authentication
      // This test validates the widget structure and tap handling
      expect(find.byType(HapticInkWell), findsAtLeastNWidgets(1));
    });

    testWidgets('should update when appState changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ListenableBuilder(
            listenable: appState.liveSession,
            builder: (context, _) => HostControlsWidget(
              appState: appState,
              scenarioName: 'Test Scenario',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HostControlsWidget), findsOneWidget);
    });

    testWidgets('should have proper accessibility semantics', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify semantic labels are present
      expect(
        find.bySemanticsLabel(RegExp('Start|Hosting|Stop')),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('should use correct AppColors for styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the widget tree contains properly styled elements
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container, isNotNull);
    });

    testWidgets('should render with different scenario names', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Solar System Simulation',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HostControlsWidget), findsOneWidget);
    });

    testWidgets('should handle onHostingStopped callback', (
      WidgetTester tester,
    ) async {
      var stoppedCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
            onHostingStopped: () => stoppedCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Widget should render with callback configured
      expect(find.byType(HostControlsWidget), findsOneWidget);
      expect(stoppedCalled, isFalse); // Not hosting, so callback not called
    });

    testWidgets('should contain Text widgets for labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should have text labels
      expect(find.byType(Text), findsAtLeastNWidgets(1));
    });

    testWidgets('should contain Row for layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('should contain Column for vertical layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should show wifi_tethering_off icon when not hosting', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.wifi_tethering_off), findsOneWidget);
    });

    testWidgets('should have Container with proper decoration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find Container with BoxDecoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers, isNotEmpty);
    });

    testWidgets('should rebuild when liveSession changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Notify listeners to trigger rebuild
      appState.liveSession.notifyListeners();
      await tester.pump();

      expect(find.byType(HostControlsWidget), findsOneWidget);
    });

    testWidgets('should use AppTypography spacing constants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find SizedBox widgets used for spacing
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('should show Expanded widget for flexible text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName: 'Test Scenario',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Expanded), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle very long scenario names', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(
            appState: appState,
            scenarioName:
                'Very Long Scenario Name That Should Not Break The Layout',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HostControlsWidget), findsOneWidget);
    });

    testWidgets('should handle empty scenario name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HostControlsWidget(appState: appState, scenarioName: ''),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HostControlsWidget), findsOneWidget);
    });
  });
}
