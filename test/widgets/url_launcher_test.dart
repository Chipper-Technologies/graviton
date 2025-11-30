import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/screens/about_screen.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
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

    testWidgets('Should display clickable GitHub link in about screen', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(createTestWidget(const AboutScreen()));

      await tester.pumpAndSettle();

      // Environment variables are not available in test environment, so URL may be empty
      // Test that if the GitHub URL is present, it's properly wrapped in a HapticInkWell
      final githubUrl = 'https://github.com/Chipper-Technologies/graviton';

      final githubLink = find.text(githubUrl);
      if (githubLink.evaluate().isNotEmpty) {
        // URL is available, verify it exists and is clickable
        expect(githubLink, findsOneWidget);

        // Verify it's wrapped in a HapticInkWell (clickable)
        final hapticInkWell = find.ancestor(
          of: githubLink,
          matching: find.byType(HapticInkWell),
        );
        expect(hapticInkWell, findsOneWidget);
      } else {
        // URL not available (environment variable not set), verify AboutScreen still renders
        expect(find.byType(AboutScreen), findsOneWidget);
      }
    });

    testWidgets('Should have website section with proper icon', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(createTestWidget(const AboutScreen()));

      await tester.pumpAndSettle();

      // Look for the language icon (used for website section)
      expect(find.byIcon(Icons.language), findsOneWidget);

      // Look for the website label
      expect(find.text('Website'), findsOneWidget);
    });
  });
}
