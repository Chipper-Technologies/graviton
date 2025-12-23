import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/live_session/presentation/widgets/start_sharing_tab.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'start_sharing_tab_test.mocks.dart';

@GenerateMocks([LiveSessionState])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StartSharingTab', () {
    late AppState appState;
    late LiveSessionState liveSessionState;

    Widget createTestWidget({
      VoidCallback? onHostingStarted,
      VoidCallback? onHostingStopped,
    }) {
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
          home: Scaffold(
            body: StartSharingTab(
              appState: appState,
              onHostingStarted: onHostingStarted,
              onHostingStopped: onHostingStopped,
            ),
          ),
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

    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(StartSharingTab), findsOneWidget);
    });

    testWidgets('should show start hosting button initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Start Hosting'), findsOneWidget);
    });

    testWidgets('should show description text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.textContaining('Share your current simulation'),
        findsOneWidget,
      );
    });

    testWidgets('should show scenario to share', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Scenario to share'), findsOneWidget);
    });

    testWidgets('should show password protection toggle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Password Protection'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should accept callbacks', (WidgetTester tester) async {
      var startedCalled = false;
      var stoppedCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onHostingStarted: () => startedCalled = true,
          onHostingStopped: () => stoppedCalled = true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(StartSharingTab), findsOneWidget);
      expect(startedCalled, isFalse);
      expect(stoppedCalled, isFalse);
    });

    testWidgets('should have StatefulWidget state class', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      final widget = tester.widget<StartSharingTab>(
        find.byType(StartSharingTab),
      );
      expect(widget.createState(), isA<State<StartSharingTab>>());
    });
  });

  group('StartSharingTab with Mocked State', () {
    late AppState appState;
    late MockLiveSessionState mockLiveSession;

    Widget createMockedTestWidget({
      VoidCallback? onHostingStarted,
      VoidCallback? onHostingStopped,
    }) {
      return ChangeNotifierProvider<LiveSessionState>.value(
        value: mockLiveSession,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: StartSharingTab(
              appState: appState,
              onHostingStarted: onHostingStarted,
              onHostingStopped: onHostingStopped,
            ),
          ),
        ),
      );
    }

    setUp(() {
      appState = AppState();
      mockLiveSession = MockLiveSessionState();

      // Default mock behavior
      when(mockLiveSession.isHosting).thenReturn(false);
      when(mockLiveSession.isViewing).thenReturn(false);
      when(mockLiveSession.isInSession).thenReturn(false);
      when(mockLiveSession.viewerCount).thenReturn(0);
    });

    tearDown(() {
      appState.dispose();
    });

    testWidgets('should show start view when not hosting', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Start Hosting'), findsOneWidget);
      expect(find.text('Stop Hosting'), findsNothing);
    });

    testWidgets('should show hosting view when hosting', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(3);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Stop Hosting'), findsOneWidget);
      expect(find.text('Hosting Live Session'), findsOneWidget);
      expect(find.text('3 viewers'), findsOneWidget);
    });

    testWidgets('should show connection status when hosting', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('should toggle password protection', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Find the switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // Initially should be off
      Switch switchWidget = tester.widget(switchFinder);
      expect(switchWidget.value, isFalse);

      // Tap to toggle on
      await tester.tap(switchFinder);
      await tester.pump();

      // Should now show password input
      expect(find.text('Enter password'), findsOneWidget);
    });

    testWidgets('should show password field when protection enabled', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Toggle password protection on
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Should show password input field
      expect(find.byType(TextField), findsOneWidget);
      expect(
        find.textContaining('Viewers will need to enter this password'),
        findsOneWidget,
      );
    });

    testWidgets('should call startHosting without password', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);
      when(
        mockLiveSession.startHosting(
          scenarioName: anyNamed('scenarioName'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Tap start hosting
      await tester.tap(find.text('Start Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      verify(
        mockLiveSession.startHosting(
          scenarioName: anyNamed('scenarioName'),
          password: null,
        ),
      ).called(1);
    });

    testWidgets('should call startHosting with password', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);
      when(
        mockLiveSession.startHosting(
          scenarioName: anyNamed('scenarioName'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Toggle password protection on
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Enter password
      await tester.enterText(find.byType(TextField), 'mypassword');
      await tester.pump();

      // Tap start hosting
      await tester.tap(find.text('Start Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      verify(
        mockLiveSession.startHosting(
          scenarioName: anyNamed('scenarioName'),
          password: 'mypassword',
        ),
      ).called(1);
    });

    testWidgets('should show error when password required but empty', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Toggle password protection on
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Try to start hosting without password
      await tester.tap(find.text('Start Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      // Should show error snackbar
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('should call stopHosting when stop button pressed', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);
      when(mockLiveSession.stopHosting()).thenAnswer((_) async => true);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Tap stop hosting
      await tester.tap(find.text('Stop Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      verify(mockLiveSession.stopHosting()).called(1);
    });

    testWidgets('should invoke callback when hosting started', (
      WidgetTester tester,
    ) async {
      var callbackInvoked = false;

      when(mockLiveSession.isHosting).thenReturn(false);
      when(
        mockLiveSession.startHosting(
          scenarioName: anyNamed('scenarioName'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createMockedTestWidget(onHostingStarted: () => callbackInvoked = true),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Tap start hosting
      await tester.tap(find.text('Start Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(callbackInvoked, isTrue);
    });

    testWidgets('should invoke callback when hosting stopped', (
      WidgetTester tester,
    ) async {
      var callbackInvoked = false;

      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);
      when(mockLiveSession.stopHosting()).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createMockedTestWidget(onHostingStopped: () => callbackInvoked = true),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Tap stop hosting
      await tester.tap(find.text('Stop Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(callbackInvoked, isTrue);
    });

    testWidgets('should show wifi icon in start hosting button', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.wifi_tethering), findsOneWidget);
    });

    testWidgets('should show stop icon in stop hosting button', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);
    });

    testWidgets('should show lock icon when password enabled', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Initially shows unlock icon
      expect(find.byIcon(Icons.lock_open), findsOneWidget);

      // Toggle password protection
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Should show lock icon
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should show globe icon for scenario', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.public), findsOneWidget);
    });

    testWidgets('should show visibility icon for viewer count when hosting', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(5);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
