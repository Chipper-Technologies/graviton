import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/copyright_text.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('CopyrightText Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('de'),
          Locale('ja'),
          Locale('zh'),
        ],
        home: Scaffold(body: Stack(children: [child])),
      );
    }

    testWidgets('Should render copyright text widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Check that the copyright text widget contains the About link and copyright symbol
      expect(find.text('About'), findsOneWidget);
      expect(find.textContaining('©'), findsOneWidget);
    });

    testWidgets('Should open About dialog when About link is tapped', (
      WidgetTester tester,
    ) async {
      // Use a larger screen size to avoid overflow
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Tap the About link
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Check that the dialog appears
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Graviton'), findsOneWidget);
    });

    testWidgets('Should have proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Check that the About text has underline decoration
      final aboutTextWidget = tester.widget<Text>(find.text('About'));
      expect(aboutTextWidget.style?.decoration, TextDecoration.underline);
    });

    testWidgets('Should display copyright text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Check that the copyright text is displayed
      expect(find.textContaining('Chipper Technologies'), findsOneWidget);
      expect(find.textContaining('©'), findsOneWidget);
    });

    testWidgets('Should close dialog correctly', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Open the dialog
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.byType(Dialog), findsOneWidget);

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.byType(Dialog), findsNothing);
    });
  });
}
