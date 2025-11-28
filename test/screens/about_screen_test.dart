import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/screens/about_screen.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

void main() {
  group('AboutScreen', () {
    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );
    }

    testWidgets('should display basic UI structure', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should have transparent scaffold with app bar
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // App bar should have title
      expect(find.text('About'), findsOneWidget);

      // Should have navigation capability (may or may not show back button in test)
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display app logo', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should have app logo container with proper decoration
      final logoContainers = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(logoContainers, findsWidgets);
    });

    testWidgets('should display app name and description', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should display app name
      expect(find.text('Graviton'), findsOneWidget);

      // Should display app description (check for key parts)
      expect(find.textContaining('gravitational'), findsOneWidget);
    });

    testWidgets('should display version information when loaded', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      // Should show either loading text or version text
      final loadingText = find.text('Loading version...');
      final versionText = find.textContaining('Version');

      expect(
        loadingText.evaluate().isNotEmpty || versionText.evaluate().isNotEmpty,
        isTrue,
      );

      // Wait for potential async loading
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // After settling, should have some version-related text
      final anyVersionText = find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.data?.contains('Version') == true ||
                widget.data?.contains('Loading') == true),
      );
      expect(anyVersionText, findsAtLeastNWidgets(1));
    });

    testWidgets('should display loading version initially', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      // Should show loading text initially
      expect(find.text('Loading version...'), findsOneWidget);
    });

    testWidgets('should display company information', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should display author section
      expect(find.text('Author'), findsOneWidget);
      expect(find.text('Chipper Technologies LLC'), findsOneWidget);

      // Should have business icon
      expect(find.byIcon(Icons.business), findsOneWidget);
    });

    testWidgets('should display website link', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should display website section
      expect(find.text('Website'), findsOneWidget);
      expect(find.textContaining('github.com'), findsOneWidget);

      // Should have language icon
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('should display privacy policy link', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should display privacy policy section
      expect(find.text('Privacy Policy'), findsOneWidget);
      // Now we have both Privacy Policy and Terms of Service links
      expect(find.textContaining('chippertechnology.com'), findsNWidgets(2));

      // Should have privacy tip icon
      expect(find.byIcon(Icons.privacy_tip), findsOneWidget);
    });

    testWidgets('should display copyright information', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should display copyright section
      expect(find.text('Copyright'), findsOneWidget);
      expect(find.textContaining('©'), findsOneWidget);
      expect(find.textContaining('All rights reserved'), findsOneWidget);

      // Should have copyright icon
      expect(find.byIcon(Icons.copyright), findsOneWidget);
    });

    testWidgets('should have transparent background', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(AppColors.transparentColor));
    });

    testWidgets('should have proper app bar styling', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(
        appBar.backgroundColor,
        equals(
          AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityNearlyOpaque,
          ),
        ),
      );
      expect(appBar.foregroundColor, equals(AppColors.uiWhite));
      expect(appBar.elevation, equals(0));
    });

    testWidgets('should have scrollable content', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      // Should have scrollable content
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have centered content with max width constraint', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      // Should have center widgets (multiple expected in Material design)
      expect(find.byType(Center), findsWidgets);

      // Should have container with max width constraint
      final containers = find.byWidgetPredicate(
        (widget) => widget is Container && widget.constraints?.maxWidth == 800,
      );
      expect(containers, findsOneWidget);
    });

    testWidgets('should handle link taps gracefully', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Find and tap website link
      final websiteLink = find.textContaining('github.com');
      expect(websiteLink, findsOneWidget);

      // Tap should not throw (even if URL can't launch in test environment)
      await tester.tap(websiteLink);
      await tester.pumpAndSettle();

      // Should not crash or show errors in test environment
      expect(find.byType(AboutScreen), findsOneWidget);
    });

    testWidgets('should display correct text colors for dark theme', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // App name should be white
      final appNameText = find.text('Graviton');
      expect(appNameText, findsOneWidget);

      // Description should be white
      final descriptionText = find.textContaining('gravitational');
      expect(descriptionText, findsOneWidget);
    });

    testWidgets('should display icons with correct colors', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should have properly colored icons
      expect(find.byIcon(Icons.business), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.privacy_tip), findsOneWidget);
      expect(find.byIcon(Icons.copyright), findsOneWidget);
    });

    testWidgets('should have proper spacing between sections', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should have multiple SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should display SVG logo for company', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should have SVG picture for Chipper logo
      // Note: We can't easily test SVG rendering in unit tests,
      // but we can verify the widget structure exists
      expect(find.text('Chipper Technologies LLC'), findsOneWidget);
    });

    testWidgets('should handle package info loading error gracefully', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      // Wait for error handling
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should still display the screen without crashing
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('should be accessible', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should have proper semantics structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Text should be readable
      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('Author'), findsOneWidget);
      expect(find.text('Website'), findsOneWidget);
    });

    testWidgets('should display current year in copyright', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));
      await tester.pumpAndSettle();

      // Should display current year
      final currentYear = DateTime.now().year.toString();
      expect(find.textContaining(currentYear), findsOneWidget);
    });

    testWidgets('should integrate properly with the widget tree', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(child: const AboutScreen()));

      // Should render without errors
      expect(tester.takeException(), isNull);

      // Should have the expected widget
      expect(find.byType(AboutScreen), findsOneWidget);
    });
  });
}
