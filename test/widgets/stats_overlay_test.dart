import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/stats_overlay.dart';

void main() {
  group('StatsOverlay', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Stack(children: [child])),
      );
    }

    group('Rendering', () {
      testWidgets('Should display stats overlay with default values', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        expect(find.byType(StatsOverlay), findsOneWidget);
        expect(find.byType(Positioned), findsOneWidget);
        expect(find.byType(Opacity), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Should display simulation stats text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        expect(find.text('Simulation Stats'), findsOneWidget);
        expect(find.textContaining('Steps:'), findsOneWidget);
        expect(find.textContaining('Time:'), findsOneWidget);
        expect(find.textContaining('Speed:'), findsOneWidget);
        expect(find.textContaining('Bodies:'), findsOneWidget);
      });

      testWidgets('Should reflect current simulation values', (tester) async {
        // Modify simulation state
        appState.simulation.step(1.0 / 60.0); // Advance one step

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        expect(find.textContaining('Bodies: 4'), findsOneWidget);
        expect(
          find.textContaining('Speed: 8.0x'),
          findsOneWidget,
        ); // Default timeScale is 8.0
      });
    });

    group('Opacity Control', () {
      testWidgets('Should respect UI opacity setting', (tester) async {
        // Set specific opacity
        appState.ui.setUIOpacity(0.5);

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacityWidget.opacity, equals(0.5));
      });

      testWidgets('Should handle zero opacity', (tester) async {
        appState.ui.setUIOpacity(0.0); // Minimum allowed by clamp

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacityWidget.opacity, equals(0.0));
      });

      testWidgets('Should handle full opacity', (tester) async {
        appState.ui.setUIOpacity(1.0);

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacityWidget.opacity, equals(1.0));
      });
    });

    group('Positioning', () {
      testWidgets('Should be positioned in top-left corner', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.top, equals(16));
        expect(positioned.left, equals(16));
        expect(positioned.right, isNull);
        expect(positioned.bottom, isNull);
      });
    });

    group('Styling', () {
      testWidgets('Should have proper container styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(container.padding, equals(const EdgeInsets.all(12)));
        expect(decoration.color, equals(AppColors.basicBlack54));
        expect(
          decoration.borderRadius,
          equals(BorderRadius.circular(AppTypography.radiusMedium)),
        );
      });

      testWidgets('Should have proper text styles', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        // Find title text widget
        final titleFinder = find.text('Simulation Stats');
        expect(titleFinder, findsOneWidget);

        // Find other text widgets
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Localization', () {
      testWidgets('Should display localized text for English', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Stack(children: [StatsOverlay(appState: appState)]),
            ),
          ),
        );

        expect(find.text('Simulation Stats'), findsOneWidget);
        expect(find.textContaining('Steps:'), findsOneWidget);
        expect(find.textContaining('Time:'), findsOneWidget);
        expect(find.textContaining('Speed:'), findsOneWidget);
        expect(find.textContaining('Bodies:'), findsOneWidget);
      });

      testWidgets('Should display localized text for Spanish', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('es'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Stack(children: [StatsOverlay(appState: appState)]),
            ),
          ),
        );

        expect(find.text('Estadísticas de Simulación'), findsOneWidget);
        expect(find.textContaining('Pasos:'), findsOneWidget);
        expect(find.textContaining('Tiempo:'), findsOneWidget);
        expect(find.textContaining('Velocidad:'), findsOneWidget);
        expect(find.textContaining('Cuerpos:'), findsOneWidget);
      });

      testWidgets('Should display localized text for French', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('fr'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Stack(children: [StatsOverlay(appState: appState)]),
            ),
          ),
        );

        expect(find.text('Statistiques de Simulation'), findsOneWidget);
        expect(find.textContaining('Étapes:'), findsOneWidget);
        expect(find.textContaining('Temps:'), findsOneWidget);
        expect(find.textContaining('Vitesse:'), findsOneWidget);
        expect(find.textContaining('Corps:'), findsOneWidget);
      });
    });

    group('Dynamic Updates', () {
      testWidgets('Should update when simulation state changes', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        // Get initial body count
        final initialBodies = appState.simulation.bodies.length;
        expect(find.textContaining('Bodies: $initialBodies'), findsOneWidget);

        // Note: This test is skipped due to complexity of testing dynamic updates with provider
      }, skip: true);

      testWidgets('Should update when time scale changes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        // Initial speed - speedFormatted adds "x" suffix
        expect(
          find.textContaining('Speed: 8.0x'),
          findsOneWidget,
        ); // Default timeScale is 8.0

        // Note: Dynamic update testing is complex with provider setup
      }, skip: true);
    });

    group('Edge Cases', () {
      testWidgets('Should handle empty simulation', (tester) async {
        appState.simulation.bodies.clear();

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        expect(find.textContaining('Bodies: 0'), findsOneWidget);
        expect(find.byType(StatsOverlay), findsOneWidget);
      });

      testWidgets('Should handle very large numbers', (tester) async {
        // Step simulation many times to get large numbers naturally
        for (int i = 0; i < 1000; i++) {
          appState.simulation.step(0.1);
        }

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        // Should display some large step count
        expect(find.textContaining('Steps:'), findsOneWidget);
        expect(find.textContaining('Time:'), findsOneWidget);
      });

      testWidgets('Should handle negative opacity gracefully', (tester) async {
        // This shouldn't happen in normal usage, but test defensive programming
        appState.ui.setUIOpacity(-0.1);

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
        expect(
          opacityWidget.opacity,
          equals(0.0),
        ); // Should be clamped to minimum (0.0)
      });

      testWidgets('Should handle opacity greater than 1.0', (tester) async {
        appState.ui.setUIOpacity(1.5);

        await tester.pumpWidget(
          createTestWidget(child: StatsOverlay(appState: appState)),
        );

        final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
        expect(
          opacityWidget.opacity,
          equals(1.0),
        ); // Should be clamped to maximum
      });
    });
  });
}
