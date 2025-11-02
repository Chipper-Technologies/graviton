import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/widgets/screenshot_countdown.dart';

void main() {
  group('ScreenshotCountdown', () {
    late ScreenshotModeService service;

    /// Set up service before each test
    setUp(() {
      service = ScreenshotModeService();
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Stack(children: [child])),
      );
    }

    testWidgets('should create widget successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      expect(find.byType(ScreenshotCountdown), findsOneWidget);
    });

    testWidgets('should display correct widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      // Should have ListenableBuilder as the root widget
      expect(find.byType(ListenableBuilder), findsAtLeastNWidgets(1));
      expect(find.byType(ScreenshotCountdown), findsOneWidget);
    });

    testWidgets('should handle key parameter correctly', (
      WidgetTester tester,
    ) async {
      const testKey = Key('test_countdown');

      await tester.pumpWidget(
        createTestWidget(
          ScreenshotCountdown(key: testKey, screenshotService: service),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('should be responsive to service parameter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      // Widget should exist with the provided service
      final widget = tester.widget<ScreenshotCountdown>(
        find.byType(ScreenshotCountdown),
      );

      expect(widget.screenshotService, equals(service));
    });

    testWidgets('should handle const constructor', (WidgetTester tester) async {
      // Test that widget can be created (const constructor pattern available)
      final widget = ScreenshotCountdown(screenshotService: service);
      expect(widget, isA<ScreenshotCountdown>());
      expect(widget.screenshotService, equals(service));
    });

    testWidgets('should show/hide based on service state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      // Initially should show SizedBox.shrink when countdown is not active
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));

      // The countdown should not be showing by default
      expect(service.showCountdown, isFalse);
    });

    testWidgets('should maintain proper localization context', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      // Verify that localization context is available (no assertion errors)
      expect(find.byType(ScreenshotCountdown), findsOneWidget);
    });

    testWidgets('should require service parameter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      // Service parameter is required and should be present
      final widget = tester.widget<ScreenshotCountdown>(
        find.byType(ScreenshotCountdown),
      );
      expect(widget.screenshotService, isNotNull);
    });

    testWidgets('should maintain widget hierarchy correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      // Basic widget structure should be present
      expect(find.byType(ScreenshotCountdown), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should be compatible with Stack layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ScreenshotCountdown(screenshotService: service)),
      );

      // Should work properly within Stack widget - there may be multiple Stack widgets
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(ScreenshotCountdown), findsOneWidget);
    });
  });
}
