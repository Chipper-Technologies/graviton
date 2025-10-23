import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/about_dialog.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('URL Launcher Tests', () {
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
        home: Scaffold(body: child),
      );
    }

    testWidgets('Should display clickable GitHub link in about dialog', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(
        createTestWidget(Builder(builder: (context) => const AppAboutDialog())),
      );

      await tester.pumpAndSettle();

      // Look for the GitHub URL link
      expect(
        find.text('https://github.com/Chipper-Technologies/graviton'),
        findsOneWidget,
      );

      // Verify it's wrapped in an InkWell (clickable)
      final githubLink = find.text(
        'https://github.com/Chipper-Technologies/graviton',
      );
      final inkWell = find.ancestor(
        of: githubLink,
        matching: find.byType(InkWell),
      );
      expect(inkWell, findsOneWidget);
    });

    testWidgets('Should have website section with proper icon', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(
        createTestWidget(Builder(builder: (context) => const AppAboutDialog())),
      );

      await tester.pumpAndSettle();

      // Look for the language icon (used for website section)
      expect(find.byIcon(Icons.language), findsOneWidget);

      // Look for the website label
      expect(find.text('Website'), findsOneWidget);
    });
  });
}
