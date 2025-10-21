import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/app_flavor.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/screenshot_mode_widget.dart';
import 'package:provider/provider.dart';

void main() {
  group('ScreenshotModeWidget Internationalization', () {
    late AppState appState;

    setUp(() {
      // Set up dev flavor to enable screenshot mode
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);
      appState = AppState();
    });

    tearDown(() {
      appState.dispose();
    });

    Widget createWidgetWithLocale(Locale locale) {
      return MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChangeNotifierProvider<AppState>.value(value: appState, child: const ScreenshotModeWidget()),
        ),
      );
    }

    testWidgets('Should display English text by default', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Screenshot Mode'), findsOneWidget);
      expect(find.text('Enable preset scenes for capturing marketing screenshots'), findsOneWidget);
    });

    testWidgets('Should display German text when locale is German', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('de')));
      await tester.pumpAndSettle();

      expect(find.text('Screenshot-Modus'), findsOneWidget);
      expect(find.text('Vorgegebene Szenen für Marketing-Screenshots aktivieren'), findsOneWidget);
    });

    testWidgets('Should display Spanish text when locale is Spanish', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('es')));
      await tester.pumpAndSettle();

      expect(find.text('Modo de Captura'), findsOneWidget);
      expect(find.text('Activar escenas predefinidas para capturas de marketing'), findsOneWidget);
    });

    testWidgets('Should display French text when locale is French', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('fr')));
      await tester.pumpAndSettle();

      expect(find.text('Mode Capture d\'Écran'), findsOneWidget);
      expect(find.text('Activer des scènes prédéfinies pour les captures marketing'), findsOneWidget);
    });

    testWidgets('Should display Japanese text when locale is Japanese', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('ja')));
      await tester.pumpAndSettle();

      expect(find.text('スクリーンショットモード'), findsOneWidget);
      expect(find.text('マーケティング用スクリーンショット撮影のプリセットシーンを有効化'), findsOneWidget);
    });

    testWidgets('Should display Korean text when locale is Korean', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('ko')));
      await tester.pumpAndSettle();

      expect(find.text('스크린샷 모드'), findsOneWidget);
      expect(find.text('마케팅 스크린샷 촬영을 위한 프리셋 장면 활성화'), findsOneWidget);
    });

    testWidgets('Should display Chinese text when locale is Chinese', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('zh')));
      await tester.pumpAndSettle();

      expect(find.text('截图模式'), findsOneWidget);
      expect(find.text('启用预设场景以捕获营销截图'), findsOneWidget);
    });

    testWidgets('Should localize tooltips and buttons', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('de')));
      await tester.pumpAndSettle();

      // Enable screenshot mode first to see the preset controls
      final switchTile = find.byType(SwitchListTile);
      await tester.tap(switchTile);
      await tester.pumpAndSettle();

      // Check for localized tooltips - need to find by semantics since tooltips may not be visible
      expect(find.text('Szenen-Voreinstellung'), findsOneWidget);
      expect(find.text('Szene anwenden'), findsOneWidget);
    });

    testWidgets('Should handle all supported locales without errors', (tester) async {
      final supportedLocales = [
        const Locale('en'),
        const Locale('de'),
        const Locale('es'),
        const Locale('fr'),
        const Locale('ja'),
        const Locale('ko'),
        const Locale('zh'),
      ];

      for (final locale in supportedLocales) {
        await tester.pumpWidget(createWidgetWithLocale(locale));
        await tester.pumpAndSettle();

        // Verify widget builds without errors
        expect(find.byType(ScreenshotModeWidget), findsOneWidget);
        expect(find.byType(SwitchListTile), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Should include hide UI functionality when screenshot mode is enabled', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('en')));
      await tester.pumpAndSettle();

      // Enable screenshot mode via appState (avoid UI complexity)
      final screenshotService = ScreenshotModeService();
      screenshotService.enableScreenshotMode();

      // Rebuild widget
      await tester.pumpAndSettle();

      // Should have the hide UI toggle available
      expect(find.text('Hide Navigation'), findsOneWidget);
      expect(find.text('Hide app bar, bottom navigation, and copyright when screenshot mode is active'), findsOneWidget);
    });

    testWidgets('Should toggle hide UI setting correctly via state', (tester) async {
      await tester.pumpWidget(createWidgetWithLocale(const Locale('en')));
      await tester.pumpAndSettle();

      // Initial state should be false
      expect(appState.ui.hideUIInScreenshotMode, isFalse);

      // Toggle the setting directly
      appState.ui.toggleHideUIInScreenshotMode();
      await tester.pumpAndSettle();

      // Should now be true
      expect(appState.ui.hideUIInScreenshotMode, isTrue);
    });
  });
}
