import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/common/graviton_tab_bar.dart';
import 'package:graviton/widgets/common/graviton_tab.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

void main() {
  group('GravitonTabBar Tests', () {
    setUp(() {
      // TabController requires a TickerProvider, which we get from the test
    });

    Widget createTestWidget({
      required List<GravitonTab> tabs,
      List<bool>? disabledTabs,
      TabController? controller,
    }) {
      return MaterialApp(
        home: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            body: Builder(
              builder: (context) {
                final effectiveController =
                    controller ?? DefaultTabController.of(context);
                return GravitonTabBar(
                  controller: effectiveController,
                  tabs: tabs,
                  disabledTabs: disabledTabs,
                );
              },
            ),
          ),
        ),
      );
    }

    group('Basic Functionality', () {
      testWidgets('should render correctly with tabs', (tester) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
        ];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        expect(find.byType(GravitonTabBar), findsOneWidget);
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('should display all provided tabs', (tester) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
          const GravitonTab(icon: Icons.info, label: 'About'),
        ];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        final TabBar tabBar = tester.widget(find.byType(TabBar));
        expect(tabBar.tabs.length, 3);
      });
    });

    group('Container Styling', () {
      testWidgets('should have correct container styling', (tester) async {
        final tabs = [const GravitonTab(icon: Icons.home, label: 'Home')];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        final Container container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(GravitonTabBar),
                matching: find.byType(Container),
              )
              .first,
        );

        expect(container.constraints?.minHeight, 50);

        final BoxDecoration decoration = container.decoration as BoxDecoration;
        expect(
          decoration.borderRadius,
          BorderRadius.circular(AppTypography.radiusMedium),
        );
        expect(
          decoration.color,
          AppColors.uiBlack.withValues(alpha: AppTypography.opacityHigh),
        );

        final Border border = decoration.border as Border;
        expect(border.top.width, 1);
        expect(
          border.top.color,
          AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
        );
      });

      testWidgets('should have correct margin', (tester) async {
        final tabs = [const GravitonTab(icon: Icons.home, label: 'Home')];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        final Container container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(GravitonTabBar),
                matching: find.byType(Container),
              )
              .first,
        );

        expect(container.margin, EdgeInsets.all(AppTypography.spacingMedium));
      });
    });

    group('TabBar Configuration', () {
      testWidgets('should have correct TabBar properties', (tester) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
        ];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        final TabBar tabBar = tester.widget(find.byType(TabBar));

        expect(tabBar.indicatorSize, TabBarIndicatorSize.tab);
        expect(tabBar.dividerColor, AppColors.transparentColor);
        expect(tabBar.labelColor, AppColors.uiWhite);
        expect(
          tabBar.unselectedLabelColor,
          AppColors.uiWhite.withValues(alpha: AppTypography.opacityMediumHigh),
        );

        expect(tabBar.labelStyle?.fontSize, AppTypography.fontSizeMedium);
        expect(tabBar.labelStyle?.fontWeight, FontWeight.w600);
        expect(
          tabBar.unselectedLabelStyle?.fontSize,
          AppTypography.fontSizeMedium,
        );
        expect(tabBar.unselectedLabelStyle?.fontWeight, FontWeight.w500);
      });

      testWidgets('should have correct gradient indicator', (tester) async {
        final tabs = [const GravitonTab(icon: Icons.home, label: 'Home')];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        final TabBar tabBar = tester.widget(find.byType(TabBar));
        final BoxDecoration indicator = tabBar.indicator as BoxDecoration;

        expect(
          indicator.borderRadius,
          BorderRadius.circular(AppTypography.radiusMedium),
        );

        final LinearGradient gradient = indicator.gradient as LinearGradient;
        expect(gradient.colors.length, 2);
        expect(
          gradient.colors[0],
          AppColors.primaryColor.withValues(alpha: AppTypography.opacityMedium),
        );
        expect(
          gradient.colors[1],
          AppColors.primaryColor.withValues(alpha: AppTypography.opacityFaint),
        );
      });
    });

    group('Disabled Tabs', () {
      testWidgets(
        'should not show disabled overlays when disabledTabs is null',
        (tester) async {
          final tabs = [
            const GravitonTab(icon: Icons.home, label: 'Home'),
            const GravitonTab(icon: Icons.settings, label: 'Settings'),
          ];

          await tester.pumpWidget(createTestWidget(tabs: tabs));

          // Should find no positioned overlays when no disabled tabs
          expect(find.byType(Positioned), findsNothing);
        },
      );

      testWidgets('should show disabled overlays for disabled tabs', (
        tester,
      ) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
          const GravitonTab(icon: Icons.info, label: 'About'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            tabs: tabs,
            disabledTabs: [false, true, false], // Middle tab disabled
          ),
        );

        // Should find overlays for disabled tabs
        expect(find.byType(Positioned), findsOneWidget);

        // Should find GestureDetector within the overlay
        final Positioned positioned = tester.widget(find.byType(Positioned));
        expect(positioned, isNotNull);
      });

      testWidgets('should handle multiple disabled tabs', (tester) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
          const GravitonTab(icon: Icons.info, label: 'About'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            tabs: tabs,
            disabledTabs: [true, false, true], // First and third tabs disabled
          ),
        );

        // Should find overlays for both disabled tabs
        expect(find.byType(Positioned), findsNWidgets(2));
      });

      testWidgets('should handle all tabs disabled', (tester) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            tabs: tabs,
            disabledTabs: [true, true], // All tabs disabled
          ),
        );

        expect(find.byType(Positioned), findsNWidgets(2));
      });

      testWidgets('should handle no tabs disabled', (tester) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            tabs: tabs,
            disabledTabs: [false, false], // No tabs disabled
          ),
        );

        expect(find.byType(Positioned), findsNothing);
      });
    });

    group('Interaction', () {
      testWidgets('should handle tab taps for enabled tabs', (tester) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
        ];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        // Should be able to tap on TabBar (exact behavior depends on TabController)
        await tester.tap(find.byType(TabBar));
        await tester.pump();

        // No exception should occur
        expect(find.byType(TabBar), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have proper widget hierarchy', (tester) async {
        final tabs = [const GravitonTab(icon: Icons.home, label: 'Home')];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        // Verify widget hierarchy
        expect(
          find.descendant(
            of: find.byType(GravitonTabBar),
            matching: find.byType(Container),
          ),
          findsOneWidget,
        );

        // Verify TabBar is present instead of complex Stack hierarchy
        expect(
          find.descendant(
            of: find.byType(GravitonTabBar),
            matching: find.byType(TabBar),
          ),
          findsOneWidget,
        );

        // Verify main container SizedBox (height: 50.0)
        expect(
          find
              .descendant(
                of: find.byType(Stack),
                matching: find.byType(SizedBox),
              )
              .first,
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: find.byType(SizedBox),
            matching: find.byType(TabBar),
          ),
          findsOneWidget,
        );
      });

      testWidgets('should have correct SizedBox height', (tester) async {
        final tabs = [const GravitonTab(icon: Icons.home, label: 'Home')];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        final SizedBox sizedBox = tester.widget<SizedBox>(
          find
              .descendant(
                of: find.byType(GravitonTabBar),
                matching: find.byType(SizedBox),
              )
              .first,
        );

        expect(sizedBox.height, 50);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle single tab', (tester) async {
        final tabs = [const GravitonTab(icon: Icons.home, label: 'Home')];

        await tester.pumpWidget(createTestWidget(tabs: tabs));

        expect(find.byType(GravitonTabBar), findsOneWidget);
        final TabBar tabBar = tester.widget(find.byType(TabBar));
        expect(tabBar.tabs.length, 1);
      });

      testWidgets('should handle mismatched disabledTabs length', (
        tester,
      ) async {
        final tabs = [
          const GravitonTab(icon: Icons.home, label: 'Home'),
          const GravitonTab(icon: Icons.settings, label: 'Settings'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            tabs: tabs,
            disabledTabs: [true], // Shorter than tabs list
          ),
        );

        // Should not crash, may not show overlays for missing indices
        expect(find.byType(GravitonTabBar), findsOneWidget);
      });
    });
  });
}
