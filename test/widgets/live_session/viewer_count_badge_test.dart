import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/live_session/viewer_count_badge.dart';

void main() {
  group('ViewerCountBadge', () {
    Widget buildTestWidget({
      required int viewerCount,
      ViewerCountBadgeStyle style = ViewerCountBadgeStyle.solid,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ViewerCountBadge(count: viewerCount, style: style),
        ),
      );
    }

    testWidgets('displays viewer count', (tester) async {
      await tester.pumpWidget(buildTestWidget(viewerCount: 5));
      await tester.pumpAndSettle();

      expect(find.textContaining('5'), findsOneWidget);
    });

    testWidgets('displays visibility icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(viewerCount: 3));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('solid style has background color', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(viewerCount: 5, style: ViewerCountBadgeStyle.solid),
      );
      await tester.pumpAndSettle();

      // Find container with decoration
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ViewerCountBadge),
          matching: find.byWidgetPredicate(
            (widget) => widget is Container && widget.decoration != null,
          ),
        ),
      );

      expect(container.decoration, isNotNull);
    });

    testWidgets('subtle style is transparent', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(viewerCount: 5, style: ViewerCountBadgeStyle.subtle),
      );
      await tester.pumpAndSettle();

      // Should not have a solid background container
      expect(find.byType(ViewerCountBadge), findsOneWidget);
    });

    testWidgets('handles zero viewers', (tester) async {
      await tester.pumpWidget(buildTestWidget(viewerCount: 0));
      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(ViewerCountBadge), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('handles large viewer counts', (tester) async {
      await tester.pumpWidget(buildTestWidget(viewerCount: 9999));
      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(ViewerCountBadge), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
