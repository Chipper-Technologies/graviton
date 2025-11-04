import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/copyright_text.dart';
import 'package:graviton/screens/about_screen.dart';
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

    testWidgets('Should navigate to About screen when About link is tapped', (
      WidgetTester tester,
    ) async {
      // Use a larger screen size to avoid overflow
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Tap the About link
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Check that the AboutScreen appears
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('Graviton'), findsAtLeastNWidgets(1));
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

    testWidgets('Should close screen correctly using navigation', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Open the About screen
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Verify AboutScreen is displayed
      expect(find.byType(AboutScreen), findsOneWidget);

      // Find and tap the back button (AppBar automatically provides this)
      final backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify we're back to the original screen
      expect(find.byType(AboutScreen), findsNothing);
    });

    testWidgets('Should use transparent page route when About is tapped', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(createTestWidget(const CopyrightText()));

      await tester.pumpAndSettle();

      // Tap the About link
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Check that the AboutScreen appears with transparent background
      expect(find.byType(AboutScreen), findsOneWidget);

      // Verify the AboutScreen uses transparent scaffold
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);
      expect(scaffold.backgroundColor, Colors.transparent);
    });
  });
}
