import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/common/graviton_tab.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

void main() {
  group('GravitonTab Tests', () {
    Widget createTestWidget({required GravitonTab child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    group('Basic Functionality', () {
      testWidgets('should render correctly with required properties', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(icon: Icons.home, label: 'Home'),
          ),
        );

        expect(find.byType(GravitonTab), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should display icon and label', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(icon: Icons.settings, label: 'Settings'),
          ),
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);

        // Verify icon size
        final Icon icon = tester.widget(find.byIcon(Icons.settings));
        expect(icon.size, AppTypography.iconSizeLarge);
      });
    });

    group('State Properties', () {
      testWidgets('should show active state styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.star,
              label: 'Active',
              isActive: true,
            ),
          ),
        );

        final Icon icon = tester.widget(find.byIcon(Icons.star));
        expect(icon.color, AppColors.primaryColor);

        final Text text = tester.widget(find.text('Active'));
        expect(text.style?.color, AppColors.primaryColor);
      });

      testWidgets('should show inactive state styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.star_border,
              label: 'Inactive',
              isActive: false,
            ),
          ),
        );

        final Icon icon = tester.widget(find.byIcon(Icons.star_border));
        expect(icon.color, isNull);

        final Text text = tester.widget(find.text('Inactive'));
        expect(text.style?.color, isNull);
      });

      testWidgets('should show disabled state styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.block,
              label: 'Disabled',
              isEnabled: false,
            ),
          ),
        );

        final Icon icon = tester.widget(find.byIcon(Icons.block));
        expect(
          icon.color,
          AppColors.uiWhite.withValues(alpha: AppTypography.opacityMedium),
        );

        final Opacity opacity = tester.widget(find.byType(Opacity));
        expect(opacity.opacity, 0.7);
      });
    });

    group('Active Dot Indicator', () {
      testWidgets(
        'should show active dot when enabled and showActiveDot is true',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              child: const GravitonTab(
                icon: Icons.notification_important,
                label: 'Notifications',
                showActiveDot: true,
                isEnabled: true,
              ),
            ),
          );

          expect(
            find.descendant(
              of: find.byType(GravitonTab),
              matching: find.byType(Stack),
            ),
            findsOneWidget,
          );
          expect(find.byType(Positioned), findsOneWidget);

          final Container dotContainer = tester.widget<Container>(
            find.descendant(
              of: find.byType(Positioned),
              matching: find.byType(Container),
            ),
          );
          expect(dotContainer.constraints?.minWidth, 6);
          expect(dotContainer.constraints?.minHeight, 6);

          final BoxDecoration decoration =
              dotContainer.decoration as BoxDecoration;
          expect(decoration.color, AppColors.uiOrange);
          expect(decoration.shape, BoxShape.circle);
        },
      );

      testWidgets('should not show active dot when disabled', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.notification_important,
              label: 'Notifications',
              showActiveDot: true,
              isEnabled: false,
            ),
          ),
        );

        expect(find.byType(Positioned), findsNothing);
      });

      testWidgets('should not show active dot when showActiveDot is false', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.notification_important,
              label: 'Notifications',
              showActiveDot: false,
              isEnabled: true,
            ),
          ),
        );

        expect(find.byType(Positioned), findsNothing);
      });
    });

    group('Layout', () {
      testWidgets('should have proper spacing between icon and text', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(icon: Icons.home, label: 'Home'),
          ),
        );

        // Find the spacer SizedBox that has width: AppTypography.spacingSmall (between icon and text)
        final spacerFinder = find.descendant(
          of: find.byType(GravitonTab),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.width == AppTypography.spacingSmall,
          ),
        );

        expect(spacerFinder, findsOneWidget);
        final SizedBox spacer = tester.widget<SizedBox>(spacerFinder);
        expect(spacer.width, AppTypography.spacingSmall);
      });

      testWidgets('should use Row with mainAxisSize.min', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(icon: Icons.home, label: 'Home'),
          ),
        );

        final Row row = tester.widget(find.byType(Row));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
    });

    group('All Properties Combinations', () {
      testWidgets('should handle all properties together', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.star,
              label: 'Featured',
              isActive: true,
              showActiveDot: true,
              isEnabled: true,
            ),
          ),
        );

        // Verify active styling
        final Icon icon = tester.widget(find.byIcon(Icons.star));
        expect(icon.color, AppColors.primaryColor);

        final Text text = tester.widget(find.text('Featured'));
        expect(text.style?.color, AppColors.primaryColor);

        // Verify active dot is shown
        expect(find.byType(Positioned), findsOneWidget);

        // Verify full opacity
        final Opacity opacity = tester.widget(find.byType(Opacity));
        expect(opacity.opacity, 1.0);
      });

      testWidgets('should handle disabled state with all properties', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.star,
              label: 'Featured',
              isActive: true,
              showActiveDot: true,
              isEnabled: false,
            ),
          ),
        );

        // Verify disabled styling overrides active styling
        final Icon icon = tester.widget(find.byIcon(Icons.star));
        expect(
          icon.color,
          AppColors.uiWhite.withValues(alpha: AppTypography.opacityMedium),
        );

        // Verify active dot is not shown when disabled
        expect(find.byType(Positioned), findsNothing);

        // Verify reduced opacity
        final Opacity opacity = tester.widget(find.byType(Opacity));
        expect(opacity.opacity, 0.7);
      });
    });

    group('Default Values', () {
      testWidgets('should use correct default values', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(icon: Icons.home, label: 'Home'),
          ),
        );

        final GravitonTab tab = tester.widget(find.byType(GravitonTab));
        expect(tab.isActive, false);
        expect(tab.showActiveDot, false);
        expect(tab.isEnabled, true);

        // Verify default styling
        final Opacity opacity = tester.widget(find.byType(Opacity));
        expect(opacity.opacity, 1.0);

        // No active dot by default
        expect(find.byType(Positioned), findsNothing);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const GravitonTab(
              icon: Icons.accessibility,
              label: 'Accessibility',
            ),
          ),
        );

        // Verify that text is present for screen readers
        expect(find.text('Accessibility'), findsOneWidget);

        // Verify icon is present
        expect(find.byIcon(Icons.accessibility), findsOneWidget);
      });
    });
  });
}
