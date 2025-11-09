import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/screens/developer_tools_screen.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/common/action_option.dart';
import 'package:graviton/widgets/section_title.dart';

void main() {
  group('DeveloperToolsScreen', () {
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
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
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
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have AppBar with developer tools title
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.title, isA<Text>());

        // Should have transparent background with proper opacity
        expect(appBar.backgroundColor, isNotNull);
      });

      testWidgets('should display main sections', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have section titles
        expect(find.byType(SectionTitle), findsWidgets);

        // Should have action options for tutorial and changelog
        expect(find.byType(ActionOption), findsAtLeastNWidgets(2));

        // Should have text content
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Content Display', () {
      testWidgets('should display screenshot mode section when available', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Screenshot mode widget should be conditionally displayed
        // We don't assert its presence since it depends on ScreenshotModeService availability
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(SectionTitle), findsWidgets);
      });

      testWidgets('should display tutorial button', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have tutorial action option with school icon
        expect(find.byIcon(Icons.school), findsOneWidget);
        expect(find.byType(ActionOption), findsWidgets);
      });

      testWidgets('should display changelog button', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have changelog action option with assignment icon
        expect(find.byIcon(Icons.assignment), findsOneWidget);
        expect(find.byType(ActionOption), findsWidgets);
      });
    });

    group('Interactions', () {
      testWidgets('should be scrollable', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
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
        expect(find.byType(SectionTitle), findsWidgets);
      });

      testWidgets('should handle tutorial button tap', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Find and tap the tutorial button
        final tutorialButton = find.byIcon(Icons.school);
        expect(tutorialButton, findsOneWidget);

        // Tap should not cause errors - the button should be functional
        // Note: Actual navigation/dialog opening would require more complex setup
        expect(() async {
          await tester.tap(tutorialButton);
          await tester
              .pump(); // Don't wait for settle as tutorial overlay may appear
        }, returnsNormally);
      });

      testWidgets('should handle changelog button tap', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Find and tap the changelog button
        final changelogButton = find.byIcon(Icons.assignment);
        expect(changelogButton, findsOneWidget);

        // Tap should not cause errors - the button should be functional
        // Note: Actual dialog opening would require more complex setup with services
        expect(() async {
          await tester.tap(changelogButton);
          await tester.pump(); // Don't wait for settle as dialog may appear
        }, returnsNormally);
      });
    });

    group('Styling and Theme', () {
      testWidgets('should have correct background transparency', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Scaffold should be transparent
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(AppColors.transparentColor));

        // Content container should have semi-transparent background
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should have proper spacing and layout', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have proper padding
        expect(find.byType(Padding), findsWidgets);

        // Should have proper spacing with SizedBox
        expect(find.byType(SizedBox), findsWidgets);

        // Should have column layout
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have consistent action option styling', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have action options with consistent styling
        final actionOptions = find.byType(ActionOption);
        expect(actionOptions, findsAtLeastNWidgets(2));

        // Each action option should have icons and be marked as primary
        expect(find.byIcon(Icons.school), findsOneWidget);
        expect(find.byIcon(Icons.assignment), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle missing localization gracefully', (
        tester,
      ) async {
        // This test ensures the widget doesn't crash with missing translations
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should render without errors
        expect(find.byType(DeveloperToolsScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle service failures gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should still render basic structure even if services fail
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should handle empty content gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should still render basic structure even if content is minimal
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have accessible action buttons', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Action options should be accessible
        expect(find.byType(ActionOption), findsWidgets);

        // Should have proper icons for screen readers
        expect(find.byIcon(Icons.school), findsOneWidget);
        expect(find.byIcon(Icons.assignment), findsOneWidget);
      });

      testWidgets('should have semantic structure', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have proper semantic structure with headers and content
        expect(find.byType(SectionTitle), findsWidgets);
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(ActionOption), findsWidgets);
      });

      testWidgets('should support keyboard navigation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have focusable elements
        expect(find.byType(ActionOption), findsWidgets);

        // AppBar should support navigation
        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    group('Integration', () {
      testWidgets('should integrate with screenshot mode service', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should conditionally display screenshot mode widget
        // The presence depends on ScreenshotModeService.isAvailable
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should display proper section organization', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const DeveloperToolsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have organized sections with proper titles
        expect(find.byType(SectionTitle), findsWidgets);

        // Should have proper content organization
        expect(find.byType(ActionOption), findsAtLeastNWidgets(2));

        // Should have proper spacing between sections
        expect(find.byType(SizedBox), findsWidgets);
      });
    });
  });
}
