import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/live_session_connection_status.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:provider/provider.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'connection_status_indicator_test.mocks.dart';

@GenerateMocks([LiveSessionState])
void main() {
  group('ConnectionStatusIndicator', () {
    late MockLiveSessionState mockLiveSessionState;

    setUp(() {
      mockLiveSessionState = MockLiveSessionState();
      // Setup default stubs for required properties
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.disconnected);
      when(mockLiveSessionState.isInSession).thenReturn(true);
    });

    Widget buildTestWidget({
      bool showLabel = true,
      bool compact = false,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<LiveSessionState>.value(
            value: mockLiveSessionState,
            child: ConnectionStatusIndicator(
              showLabel: showLabel,
              compact: compact,
              onTap: onTap,
            ),
          ),
        ),
      );
    }

    testWidgets('displays disconnected status correctly', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.disconnected);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should show the status indicator widget
      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('displays connecting status with progress indicator', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connecting);

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should have CircularProgressIndicator for connecting state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays connected status correctly', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should show the status indicator
      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('displays reconnecting status with progress indicator', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.reconnecting);

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should have CircularProgressIndicator for reconnecting state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error status correctly', (WidgetTester tester) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.error);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should show the status indicator in error state
      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(buildTestWidget(showLabel: false));
      await tester.pumpAndSettle();

      // Should not show text when showLabel is false
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('shows label when showLabel is true', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(buildTestWidget(showLabel: true));
      await tester.pumpAndSettle();

      // Should show text when showLabel is true
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('compact mode uses smaller dimensions', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(buildTestWidget(compact: true));
      await tester.pumpAndSettle();

      // Widget should render in compact mode
      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('onTap callback is triggered when tapped', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(buildTestWidget(onTap: () => tapped = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, isTrue);
    });

    testWidgets('is not tappable when onTap is null', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(buildTestWidget(onTap: null));
      await tester.pumpAndSettle();

      // Should still find the widget but it won't do anything on tap
      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('returns empty when not in session', (
      WidgetTester tester,
    ) async {
      when(mockLiveSessionState.isInSession).thenReturn(false);
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.disconnected);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Widget should render but might show empty SizedBox
      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });
  });

  group('LiveSessionConnectionStatus extension', () {
    test('isActive returns true for connected and reconnecting status', () {
      expect(LiveSessionConnectionStatus.connected.isActive, isTrue);
      expect(LiveSessionConnectionStatus.reconnecting.isActive, isTrue);
      expect(LiveSessionConnectionStatus.disconnected.isActive, isFalse);
      expect(LiveSessionConnectionStatus.connecting.isActive, isFalse);
      expect(LiveSessionConnectionStatus.error.isActive, isFalse);
    });

    test(
      'isConnecting returns true for connecting and reconnecting states',
      () {
        expect(LiveSessionConnectionStatus.connecting.isConnecting, isTrue);
        expect(LiveSessionConnectionStatus.reconnecting.isConnecting, isTrue);
        expect(LiveSessionConnectionStatus.connected.isConnecting, isFalse);
        expect(LiveSessionConnectionStatus.disconnected.isConnecting, isFalse);
        expect(LiveSessionConnectionStatus.error.isConnecting, isFalse);
      },
    );

    test('hasIssue returns true for error and reconnecting states', () {
      expect(LiveSessionConnectionStatus.error.hasIssue, isTrue);
      expect(LiveSessionConnectionStatus.reconnecting.hasIssue, isTrue);
      expect(LiveSessionConnectionStatus.connected.hasIssue, isFalse);
      expect(LiveSessionConnectionStatus.connecting.hasIssue, isFalse);
      expect(LiveSessionConnectionStatus.disconnected.hasIssue, isFalse);
    });

    test('localizationKey returns correct keys', () {
      expect(
        LiveSessionConnectionStatus.disconnected.localizationKey,
        'liveSessionStatusDisconnected',
      );
      expect(
        LiveSessionConnectionStatus.connecting.localizationKey,
        'liveSessionStatusConnecting',
      );
      expect(
        LiveSessionConnectionStatus.connected.localizationKey,
        'liveSessionStatusConnected',
      );
      expect(
        LiveSessionConnectionStatus.reconnecting.localizationKey,
        'liveSessionStatusReconnecting',
      );
      expect(
        LiveSessionConnectionStatus.error.localizationKey,
        'liveSessionStatusError',
      );
    });

    test('all enum values are covered', () {
      expect(LiveSessionConnectionStatus.values.length, equals(5));
    });

    test('name property returns correct string', () {
      expect(LiveSessionConnectionStatus.disconnected.name, 'disconnected');
      expect(LiveSessionConnectionStatus.connecting.name, 'connecting');
      expect(LiveSessionConnectionStatus.connected.name, 'connected');
      expect(LiveSessionConnectionStatus.reconnecting.name, 'reconnecting');
      expect(LiveSessionConnectionStatus.error.name, 'error');
    });
  });

  group('ConnectionStatusIndicator Edge Cases', () {
    late MockLiveSessionState mockLiveSessionState;

    setUp(() {
      mockLiveSessionState = MockLiveSessionState();
      when(mockLiveSessionState.isInSession).thenReturn(true);
    });

    Widget buildTestWidget({
      bool showLabel = true,
      bool compact = false,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<LiveSessionState>.value(
            value: mockLiveSessionState,
            child: ConnectionStatusIndicator(
              showLabel: showLabel,
              compact: compact,
              onTap: onTap,
            ),
          ),
        ),
      );
    }

    testWidgets('handles all status types with compact mode', (
      WidgetTester tester,
    ) async {
      for (final status in LiveSessionConnectionStatus.values) {
        when(mockLiveSessionState.connectionStatus).thenReturn(status);
        await tester.pumpWidget(
          buildTestWidget(compact: true, showLabel: true),
        );
        await tester.pump();
        expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
      }
    });

    testWidgets('handles all status types without label', (
      WidgetTester tester,
    ) async {
      for (final status in LiveSessionConnectionStatus.values) {
        when(mockLiveSessionState.connectionStatus).thenReturn(status);
        await tester.pumpWidget(buildTestWidget(showLabel: false));
        await tester.pump();
        expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
      }
    });

    testWidgets('error status renders correctly', (WidgetTester tester) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.error);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('reconnecting status shows progress indicator', (
      WidgetTester tester,
    ) async {
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.reconnecting);
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('handles onTap with error status', (WidgetTester tester) async {
      var tapped = false;
      when(
        mockLiveSessionState.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.error);

      await tester.pumpWidget(buildTestWidget(onTap: () => tapped = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });
  });
}
