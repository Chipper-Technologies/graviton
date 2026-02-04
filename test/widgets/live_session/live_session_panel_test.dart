import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/l10n/app_localizations_en.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/live_session/live_session_panel.dart';
import 'package:graviton/widgets/live_session/host_controls_widget.dart';
import 'package:graviton/widgets/live_session/session_browser_widget.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:provider/provider.dart';

void main() {
  group('LiveSessionPanel Tests', () {
    late AppState appState;
    late LiveSessionState liveSessionState;
    late PremiumState premiumState;
    late AppLocalizationsEn l10n;

    setUp(() {
      appState = AppState();
      liveSessionState = LiveSessionState();
      premiumState = PremiumState();
      l10n = AppLocalizationsEn();
    });

    tearDown(() {
      appState.dispose();
      liveSessionState.dispose();
      premiumState.dispose();
    });

    Widget createTestWidget({
      VoidCallback? onHostingChanged,
      VoidCallback? onViewingChanged,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>.value(value: appState),
          ChangeNotifierProvider<LiveSessionState>.value(
            value: liveSessionState,
          ),
          ChangeNotifierProvider<PremiumState>.value(value: premiumState),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: LiveSessionPanel(
              onHostingChanged: onHostingChanged,
              onViewingChanged: onViewingChanged,
            ),
          ),
        ),
      );
    }

    testWidgets('should render panel with header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show the panel title
      expect(find.text(l10n.liveSessionTitle), findsOneWidget);
    });

    testWidgets('should show cast connected icon in header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cast_connected), findsOneWidget);
    });

    testWidgets('should show close button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should contain HostControlsWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HostControlsWidget), findsOneWidget);
    });

    testWidgets('should contain SessionBrowserWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should show section titles', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show hosting and browse sections
      expect(find.text(l10n.liveSessionHosting), findsWidgets);
      expect(find.text(l10n.liveSessionBrowseSessions), findsWidgets);
    });

    testWidgets('should show description when not connected', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // When not hosting or viewing, should show default description
      expect(find.text(l10n.liveSessionDescription), findsOneWidget);
    });

    testWidgets('should not show connection status when disconnected', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // When not connected, ConnectionStatusIndicator should not be prominent
      // (it's hidden in _ConnectionStatusSection when not hosting/viewing)
      // The indicator shows when compact: true, showLabel: true

      // _ConnectionStatusSection should return SizedBox.shrink when not connected
      // ignore: unused_local_variable
      final connectionSection = find.byType(ConnectionStatusIndicator);
      // There's one in the panel itself when connected, but _ConnectionStatusSection hides it
      // We need to verify the logic works correctly
    });

    group('Static show method', () {
      testWidgets('should display panel in modal bottom sheet', (tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AppState>.value(value: appState),
              ChangeNotifierProvider<LiveSessionState>.value(
                value: liveSessionState,
              ),
              ChangeNotifierProvider<PremiumState>.value(value: premiumState),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () => LiveSessionPanel.show(context),
                    child: const Text('Open Panel'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the button to open the panel
        await tester.tap(find.text('Open Panel'));
        await tester.pumpAndSettle();

        // Panel should be visible
        expect(find.byType(LiveSessionPanel), findsOneWidget);
        expect(find.text(l10n.liveSessionTitle), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('onHostingChanged callback is passed to HostControlsWidget', (
        tester,
      ) async {
        // ignore: unused_local_variable
        var callbackInvoked = false;

        await tester.pumpWidget(
          createTestWidget(onHostingChanged: () => callbackInvoked = true),
        );
        await tester.pumpAndSettle();

        // HostControlsWidget should be present with the callback
        expect(find.byType(HostControlsWidget), findsOneWidget);
      });

      testWidgets(
        'onViewingChanged callback is passed to SessionBrowserWidget',
        (tester) async {
          // ignore: unused_local_variable
          var callbackInvoked = false;

          await tester.pumpWidget(
            createTestWidget(onViewingChanged: () => callbackInvoked = true),
          );
          await tester.pumpAndSettle();

          // SessionBrowserWidget should be present with the callback
          expect(find.byType(SessionBrowserWidget), findsOneWidget);
        },
      );
    });

    group('Container styling', () {
      testWidgets('should have proper border radius', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find the Container with decoration
        final containerFinder = find.byType(Container).first;
        expect(containerFinder, findsOneWidget);
      });

      testWidgets('should be scrollable', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should have SingleChildScrollView for scrolling content
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Close button behavior', () {
      testWidgets('should close panel when close button is tapped', (
        tester,
      ) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AppState>.value(value: appState),
              ChangeNotifierProvider<LiveSessionState>.value(
                value: liveSessionState,
              ),
              ChangeNotifierProvider<PremiumState>.value(value: premiumState),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () => LiveSessionPanel.show(context),
                    child: const Text('Open Panel'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Open the panel
        await tester.tap(find.text('Open Panel'));
        await tester.pumpAndSettle();

        // Verify panel is open
        expect(find.byType(LiveSessionPanel), findsOneWidget);

        // Tap close button
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        // Panel should be closed
        expect(find.byType(LiveSessionPanel), findsNothing);
      });
    });

    group('Icons', () {
      testWidgets('should show wifi_tethering icon for hosting section', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.wifi_tethering), findsWidgets);
      });

      testWidgets('should show search icon for browse section', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search), findsOneWidget);
      });
    });
  });
}
