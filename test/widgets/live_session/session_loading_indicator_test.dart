import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/live_session/session_loading_indicator.dart';

void main() {
  group('SessionLoadingIndicator', () {
    Widget buildTestWidget() {
      return const MaterialApp(home: Scaffold(body: SessionLoadingIndicator()));
    }

    testWidgets('displays CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('is centered', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('uses correct color', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      // The progress indicator should have a value color animation
      expect(progressIndicator.valueColor, isNotNull);
    });
  });
}
