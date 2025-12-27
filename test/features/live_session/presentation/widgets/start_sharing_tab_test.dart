import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/live_session/presentation/widgets/start_sharing_tab.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/common/toggle_option.dart';
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

    testWidgets('should show session name field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Session Name'), findsOneWidget);
    });

    testWidgets('should show password protection toggle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Password Protection'), findsOneWidget);
      // There are 2 switches now (password protection and camera sync)
      expect(find.byType(Switch), findsNWidgets(2));
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
      when(mockLiveSession.currentSession).thenReturn(null);
      when(mockLiveSession.hostedSession).thenReturn(null);
      when(mockLiveSession.syncCameraWithViewers).thenReturn(false);
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
      expect(find.text('Stop Sharing'), findsNothing);
    });

    testWidgets('should show hosting view when hosting', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(3);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Stop Sharing'), findsOneWidget);
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

      // Find the password protection toggle by its text
      final passwordToggle = find.ancestor(
        of: find.text('Password Protection'),
        matching: find.byType(ToggleOption),
      );
      expect(passwordToggle, findsOneWidget);

      // Tap to toggle on
      await tester.tap(passwordToggle);
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

      // Find and tap the password protection toggle
      final passwordToggle = find.ancestor(
        of: find.text('Password Protection'),
        matching: find.byType(ToggleOption),
      );
      await tester.tap(passwordToggle);
      await tester.pump();

      // Should show password input field (2 TextFields: session name + password)
      expect(find.byType(TextField), findsNWidgets(2));
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

      // Find and tap the password protection toggle
      final passwordToggle = find.ancestor(
        of: find.text('Password Protection'),
        matching: find.byType(ToggleOption),
      );
      await tester.tap(passwordToggle);
      await tester.pump();

      // Enter password (find the password field by hint text)
      final passwordField = find.widgetWithText(TextField, 'Enter password');
      await tester.enterText(passwordField, 'mypassword');
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

      // Find and tap the password protection toggle
      final passwordToggle = find.ancestor(
        of: find.text('Password Protection'),
        matching: find.byType(ToggleOption),
      );
      await tester.tap(passwordToggle);
      await tester.pump();

      // Try to start hosting without password
      await tester.tap(find.text('Start Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      // Should show error snackbar
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('should use custom session name when provided', (
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

      // Enter a custom session name
      final sessionNameField = find.widgetWithText(
        TextField,
        'Give your session a name',
      );
      await tester.enterText(sessionNameField, 'My Custom Session');
      await tester.pump();

      // Tap start hosting
      await tester.tap(find.text('Start Hosting'));
      await tester.pump(const Duration(milliseconds: 100));

      verify(
        mockLiveSession.startHosting(
          scenarioName: 'My Custom Session',
          password: null,
        ),
      ).called(1);
    });

    testWidgets('should show session name hint text', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Give your session a name'), findsOneWidget);
    });

    testWidgets('should call stopHosting when stop button pressed', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);
      when(mockLiveSession.stopHosting()).thenAnswer((_) async => true);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Tap stop sharing
      await tester.tap(find.text('Stop Sharing'));
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

      // Tap stop sharing
      await tester.tap(find.text('Stop Sharing'));
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

    testWidgets('should show stop icon in stop sharing button', (
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

      // Find and tap the password protection toggle
      final passwordToggle = find.ancestor(
        of: find.text('Password Protection'),
        matching: find.byType(ToggleOption),
      );
      await tester.tap(passwordToggle);
      await tester.pump();

      // Should show lock icon
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should show label icon for session name field', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.label_outline), findsOneWidget);
    });

    testWidgets(
      'should show hosting status banner with viewer count when hosting',
      (WidgetTester tester) async {
        when(mockLiveSession.isHosting).thenReturn(true);
        when(mockLiveSession.viewerCount).thenReturn(5);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Hosting banner has wifi_tethering icon
        expect(find.byIcon(Icons.wifi_tethering), findsOneWidget);
      },
    );

    testWidgets(
      'should show camera sync indicator when syncCameraWithViewers is enabled',
      (WidgetTester tester) async {
        when(mockLiveSession.isHosting).thenReturn(true);
        when(mockLiveSession.viewerCount).thenReturn(2);
        when(mockLiveSession.syncCameraWithViewers).thenReturn(true);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Camera sync indicator text should be visible in the hosting banner
        expect(find.text('Camera synced'), findsOneWidget);
      },
    );

    testWidgets(
      'should not show camera sync indicator when syncCameraWithViewers is disabled',
      (WidgetTester tester) async {
        when(mockLiveSession.isHosting).thenReturn(true);
        when(mockLiveSession.viewerCount).thenReturn(2);
        when(mockLiveSession.syncCameraWithViewers).thenReturn(false);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Camera sync indicator should not be visible
        expect(find.text('Camera synced'), findsNothing);
      },
    );
  });
}
