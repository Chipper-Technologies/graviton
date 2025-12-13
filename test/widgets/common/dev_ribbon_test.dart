import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/enums/app_flavor.dart';
import 'package:graviton/services/ui/screenshot_mode_service.dart';
import 'package:graviton/widgets/common/dev_ribbon.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('DevRibbon', () {
    late ScreenshotModeService screenshotService;

    setUp(() {
      screenshotService = ScreenshotModeService();
    });

    tearDown(() {
      // Reset FlavorConfig to default state after each test
      FlavorConfig.instance.initialize(flavor: AppFlavor.prod);
      // Ensure screenshot mode is disabled
      screenshotService.disableScreenshotMode();
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(body: DevRibbon(child: child)),
      );
    }

    group('Development Mode', () {
      setUp(() {
        // Set up development mode
        FlavorConfig.instance.initialize(flavor: AppFlavor.dev);
      });

      testWidgets('should display DEV banner when in development mode', (
        WidgetTester tester,
      ) async {
        const testChild = Text('Test Child');

        await tester.pumpWidget(createTestWidget(testChild));

        // Should find a Banner widget with 'DEV' message
        final devBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');

        expect(devBanners, hasLength(1));

        // Should still display the child widget
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets(
        'should remain visible when screenshot mode is enabled but not active',
        (WidgetTester tester) async {
          const testChild = Text('Test Child');

          await tester.pumpWidget(createTestWidget(testChild));

          // Initially should have the DEV banner
          final initialDevBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(initialDevBanners, hasLength(1));

          // Enable screenshot mode (but don't apply a preset, so isActive remains false)
          screenshotService.enableScreenshotMode();
          await tester.pump();

          // DEV banner should still be visible since isActive is false
          final enabledDevBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(enabledDevBanners, hasLength(1));
          expect(
            screenshotService.isActive,
            isFalse,
          ); // isActive should still be false

          // Child should still be visible
          expect(find.text('Test Child'), findsOneWidget);
        },
      );

      testWidgets('should verify screenshot mode enabled vs active states', (
        WidgetTester tester,
      ) async {
        const testChild = Text('Test Child');

        await tester.pumpWidget(createTestWidget(testChild));

        // Enable screenshot mode
        screenshotService.enableScreenshotMode();
        await tester.pump();

        // Verify that enabled does not mean active
        expect(screenshotService.isEnabled, isTrue);
        expect(screenshotService.isActive, isFalse);

        // DEV banner should still be visible since only isActive controls visibility
        final devBannersStillVisible = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(devBannersStillVisible, hasLength(1));

        // Disable screenshot mode
        screenshotService.disableScreenshotMode();
        await tester.pump();

        // DEV banner should still be visible
        final devBannersAfterDisable = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(devBannersAfterDisable, hasLength(1));
      });

      testWidgets('should have correct banner properties in development mode', (
        WidgetTester tester,
      ) async {
        const testChild = Text('Test Child');

        await tester.pumpWidget(createTestWidget(testChild));

        final devBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');

        expect(devBanners, hasLength(1));

        final devBanner = devBanners.first;
        expect(devBanner.message, equals('DEV'));
        expect(devBanner.location, equals(BannerLocation.topEnd));
        expect(devBanner.child, isA<Widget>());
        expect(devBanner.color, isNotNull);
        expect(devBanner.textStyle, isNotNull);
        expect(devBanner.shadow, isNotNull);
      });

      testWidgets(
        'should use ListenableBuilder listening to ScreenshotModeService',
        (WidgetTester tester) async {
          const testChild = Text('Test Child');

          await tester.pumpWidget(createTestWidget(testChild));

          // Find ListenableBuilder that listens to ScreenshotModeService
          final listenableBuilders = tester
              .widgetList<ListenableBuilder>(find.byType(ListenableBuilder))
              .where((builder) => builder.listenable is ScreenshotModeService);

          expect(listenableBuilders, hasLength(1));

          final screenshotListenableBuilder = listenableBuilders.first;
          expect(
            screenshotListenableBuilder.listenable,
            isA<ScreenshotModeService>(),
          );
        },
      );
    });

    group('Production Mode', () {
      setUp(() {
        // Set up production mode
        FlavorConfig.instance.initialize(flavor: AppFlavor.prod);
      });

      testWidgets(
        'should not display DEV banner when not in development mode',
        (WidgetTester tester) async {
          const testChild = Text('Test Child');

          await tester.pumpWidget(createTestWidget(testChild));

          // Should not find any Banner with DEV message
          final devBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(devBanners, hasLength(0));

          // Should still display the child widget directly
          expect(find.text('Test Child'), findsOneWidget);
        },
      );

      testWidgets('should return child directly when not in development mode', (
        WidgetTester tester,
      ) async {
        const testChild = Text('Test Child');

        await tester.pumpWidget(createTestWidget(testChild));

        // Should not have any Banner with DEV message in production
        final devBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');

        expect(devBanners, isEmpty);

        // Child should be rendered
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets(
        'should ignore screenshot mode state when not in development',
        (WidgetTester tester) async {
          const testChild = Text('Test Child');

          await tester.pumpWidget(createTestWidget(testChild));

          // Enable screenshot mode
          screenshotService.enableScreenshotMode();
          await tester.pump();

          // Should still not have DEV banner (since we're not in dev mode)
          final devBannersEnabled = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(devBannersEnabled, hasLength(0));
          expect(find.text('Test Child'), findsOneWidget);

          // Disable screenshot mode
          screenshotService.disableScreenshotMode();
          await tester.pump();

          // Should still not have DEV banner
          final devBannersDisabled = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(devBannersDisabled, hasLength(0));
          expect(find.text('Test Child'), findsOneWidget);
        },
      );
    });

    group('Widget Tree Structure', () {
      testWidgets(
        'should maintain proper widget hierarchy in development mode',
        (WidgetTester tester) async {
          FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

          final testChild = Container(
            key: const Key('test-child'),
            child: const Text('Test Child'),
          );

          await tester.pumpWidget(createTestWidget(testChild));

          // Should have DevRibbon as root
          expect(find.byType(DevRibbon), findsOneWidget);

          // Should have the original child within the tree
          expect(find.byKey(const Key('test-child')), findsOneWidget);
          expect(find.text('Test Child'), findsOneWidget);

          // Should have DEV banner visible
          final devBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(devBanners, hasLength(1));
        },
      );

      testWidgets(
        'should maintain proper widget hierarchy in production mode',
        (WidgetTester tester) async {
          FlavorConfig.instance.initialize(flavor: AppFlavor.prod);

          final testChild = Container(
            key: const Key('test-child'),
            child: const Text('Test Child'),
          );

          await tester.pumpWidget(createTestWidget(testChild));

          // Should have DevRibbon as root
          expect(find.byType(DevRibbon), findsOneWidget);

          // Should have the original child directly
          expect(find.byKey(const Key('test-child')), findsOneWidget);
          expect(find.text('Test Child'), findsOneWidget);

          // Should NOT have DEV banner in production
          final devBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(devBanners, hasLength(0));
        },
      );
    });

    group('Edge Cases', () {
      testWidgets('should handle empty child widget', (
        WidgetTester tester,
      ) async {
        FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

        const testChild = SizedBox.shrink();

        await tester.pumpWidget(createTestWidget(testChild));

        // Should still render DEV banner without error
        expect(find.byType(DevRibbon), findsOneWidget);
        final devBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(devBanners, hasLength(1));
      });

      testWidgets('should handle complex child widget trees', (
        WidgetTester tester,
      ) async {
        FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

        final complexChild = Column(
          children: [
            const Text('Header'),
            Row(
              children: [
                const Text('Left'),
                Expanded(
                  child: Container(
                    height: 100,
                    color: AppColors.primaryColor,
                    child: const Center(child: Text('Center')),
                  ),
                ),
                const Text('Right'),
              ],
            ),
            const Text('Footer'),
          ],
        );

        await tester.pumpWidget(createTestWidget(complexChild));

        // Should render all child widgets correctly
        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Left'), findsOneWidget);
        expect(find.text('Center'), findsOneWidget);
        expect(find.text('Right'), findsOneWidget);
        expect(find.text('Footer'), findsOneWidget);

        // Should still show DEV banner
        final devBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(devBanners, hasLength(1));
      });

      testWidgets('should handle screenshot mode enable and disable toggles', (
        WidgetTester tester,
      ) async {
        FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

        const testChild = Text('Test Child');

        await tester.pumpWidget(createTestWidget(testChild));

        // Initially should show DEV banner
        final initialDevBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(initialDevBanners, hasLength(1));

        // Toggle screenshot mode multiple times
        for (int i = 0; i < 3; i++) {
          screenshotService.enableScreenshotMode();
          await tester.pump();

          // DEV banner should remain visible (since isActive is still false)
          final enabledDevBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(enabledDevBanners, hasLength(1));

          screenshotService.disableScreenshotMode();
          await tester.pump();

          // DEV banner should still be visible
          final disabledDevBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(disabledDevBanners, hasLength(1));
        }

        // Should end with DEV banner visible
        final finalDevBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(finalDevBanners, hasLength(1));
        expect(find.text('Test Child'), findsOneWidget);
      });
    });

    group('Constructor', () {
      test('should require child parameter', () {
        expect(() => DevRibbon(child: Container()), returnsNormally);
      });

      test('should have proper key handling', () {
        const key = Key('dev-ribbon-key');
        final widget = DevRibbon(key: key, child: Container());

        expect(widget.key, equals(key));
        expect(widget.child, isA<Container>());
      });
    });

    group('Screenshot Service Integration', () {
      testWidgets(
        'should show screenshot service is enabled vs active difference',
        (WidgetTester tester) async {
          FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

          const testChild = Text('Test Child');

          await tester.pumpWidget(createTestWidget(testChild));

          // Initially should show DEV banner and service is disabled
          final initialDevBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(initialDevBanners, hasLength(1));
          expect(screenshotService.isEnabled, isFalse);
          expect(screenshotService.isActive, isFalse);

          // Enable screenshot mode (but doesn't make it active)
          screenshotService.enableScreenshotMode();
          await tester.pump();

          // Service should be enabled but not active, banner still visible
          expect(screenshotService.isEnabled, isTrue);
          expect(screenshotService.isActive, isFalse);
          final enabledDevBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(enabledDevBanners, hasLength(1));
        },
      );

      testWidgets('should handle screenshot service singleton properly', (
        WidgetTester tester,
      ) async {
        FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

        const testChild = Text('Test Child');

        await tester.pumpWidget(createTestWidget(testChild));

        // Should use the singleton instance
        final service1 = ScreenshotModeService();
        final service2 = ScreenshotModeService();
        expect(identical(service1, service2), isTrue);
        expect(identical(screenshotService, service1), isTrue);
      });
    });

    group('Flavor Config Integration', () {
      testWidgets(
        'should properly check development mode through FlavorConfig',
        (WidgetTester tester) async {
          // Test dev mode
          FlavorConfig.instance.initialize(flavor: AppFlavor.dev);
          expect(FlavorConfig.instance.isDevelopment, isTrue);

          const testChild = Text('Test Child Dev');
          await tester.pumpWidget(createTestWidget(testChild));
          final devBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(devBanners, hasLength(1));

          // Test prod mode
          FlavorConfig.instance.initialize(flavor: AppFlavor.prod);
          expect(FlavorConfig.instance.isDevelopment, isFalse);

          const testChildProd = Text('Test Child Prod');
          await tester.pumpWidget(createTestWidget(testChildProd));
          final prodDevBanners = tester
              .widgetList<Banner>(find.byType(Banner))
              .where((banner) => banner.message == 'DEV');
          expect(prodDevBanners, hasLength(0));
        },
      );

      testWidgets('should handle flavor config state changes', (
        WidgetTester tester,
      ) async {
        // Start in production mode
        FlavorConfig.instance.initialize(flavor: AppFlavor.prod);

        const testChild = Text('Test Child');
        await tester.pumpWidget(createTestWidget(testChild));

        // Should not show DEV banner in prod
        final prodDevBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(prodDevBanners, hasLength(0));

        // Switch to dev mode and rebuild
        FlavorConfig.instance.initialize(flavor: AppFlavor.dev);
        await tester.pumpWidget(createTestWidget(testChild));

        // Should now show DEV banner in dev
        final devDevBanners = tester
            .widgetList<Banner>(find.byType(Banner))
            .where((banner) => banner.message == 'DEV');
        expect(devDevBanners, hasLength(1));
      });
    });
  });
}
