import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/live_session/session_empty_state.dart';

void main() {
  group('SessionEmptyState', () {
    Widget buildTestWidget({required String message}) {
      return MaterialApp(
        home: Scaffold(body: SessionEmptyState(message: message)),
      );
    }

    testWidgets('displays the message text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(message: 'No sessions available'),
      );

      expect(find.text('No sessions available'), findsOneWidget);
    });

    testWidgets('displays wifi_tethering_off icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'No sessions'));

      expect(find.byIcon(Icons.wifi_tethering_off), findsOneWidget);
    });

    testWidgets('is centered', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Test message'));

      // Verify the widget has proper centering by checking it contains a Center at the top level
      final sessionEmptyState = tester.widget<SessionEmptyState>(
        find.byType(SessionEmptyState),
      );

      // The widget exists and has expected message
      expect(sessionEmptyState.message, 'Test message');

      // Check that Center widgets exist in the widget tree
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('displays message in a Column', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Test'));

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('handles long messages', (tester) async {
      final longMessage =
          'This is a very long message that might wrap to multiple lines in the empty state widget';
      await tester.pumpWidget(buildTestWidget(message: longMessage));

      expect(find.text(longMessage), findsOneWidget);
    });
  });
}
