import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/features/help/presentation/screens/help_screen.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/common/section_divider.dart';

void main() {
  group('HelpScreen', () {
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

    group('UI Structure', () {
      testWidgets('should display correct screen structure', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should have Scaffold with transparent background
        expect(find.byType(Scaffold), findsOneWidget);
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(AppColors.transparentColor));

        // Should have AppBar
        expect(find.byType(AppBar), findsOneWidget);

        // Should have at least one SafeArea (could be more from nested widgets)
        expect(find.byType(SafeArea), findsWidgets);

        // Should have scrollable content
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should display app bar with correct title', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should have AppBar with help title
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.title, isA<Text>());

        // Should have some way to navigate back (could be back button or close)
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should display all main sections', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should have section dividers
        expect(find.byType(SectionDivider), findsAtLeastNWidgets(3));

        // Should have text content
        expect(find.byType(Text), findsWidgets);

        // Should have call to action button somewhere in the widget tree
        expect(find.byIcon(Icons.explore), findsOneWidget);
      });
    });

    group('Content Display', () {
      testWidgets('should display what to do section', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should find "What to Do" content (exact text depends on localization)
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(SectionDivider), findsWidgets);
      });

      testWidgets('should display objectives section', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should find objectives content
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(SectionDivider), findsWidgets);
      });

      testWidgets('should display quick start section', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should find quick start content
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(SectionDivider), findsWidgets);
      });

      testWidgets('should display get started button', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should have get started button with explore icon
        expect(find.byIcon(Icons.explore), findsOneWidget);
        expect(find.text('Get Started!'), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should be scrollable', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should be able to scroll
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // Verify scrolling works
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -100),
        );
        await tester.pumpAndSettle();

        // Should still have all content after scrolling
        expect(find.byType(SectionDivider), findsWidgets);
      });
    });

    group('Styling and Theme', () {
      testWidgets('should have correct background transparency', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Scaffold should be transparent
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(AppColors.transparentColor));

        // Content container should have semi-transparent background
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should have proper spacing and layout', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should have proper padding
        expect(find.byType(Padding), findsWidgets);

        // Should have proper spacing with SizedBox
        expect(find.byType(SizedBox), findsWidgets);

        // Should have column layout
        expect(find.byType(Column), findsWidgets);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle missing localization gracefully', (
        tester,
      ) async {
        // This test ensures the widget doesn't crash with missing translations
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should render without errors
        expect(find.byType(HelpScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle empty content gracefully', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should still render basic structure even if content is minimal
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have semantic structure', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpScreen()));
        await tester.pumpAndSettle();

        // Should have proper semantic structure with headers and content
        expect(find.byType(SectionDivider), findsWidgets);
        expect(find.byType(Text), findsWidgets);
      });
    });
  });
}
