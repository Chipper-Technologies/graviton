import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';

void main() {
  group('Internationalization Tests', () {
    testWidgets('English locale should have correct strings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('en'),
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: _TestWidget.new),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
      expect(find.text('Speed'), findsOneWidget);
    });

    testWidgets('Spanish locale should have correct strings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('es'),
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: _TestWidget.new),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('Reproducir'), findsOneWidget);
      expect(find.text('Velocidad'), findsOneWidget);
    });

    testWidgets('French locale should have correct strings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('fr'),
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: _TestWidget.new),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('Lecture'), findsOneWidget);
      expect(find.text('Vitesse'), findsOneWidget);
    });

    testWidgets('Chinese locale should have correct strings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('zh'),
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: _TestWidget.new),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('播放'), findsOneWidget);
      expect(find.text('速度'), findsOneWidget);
    });

    testWidgets('German locale should have correct strings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('de'),
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: _TestWidget.new),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('Wiedergabe'), findsOneWidget);
      expect(find.text('Geschwindigkeit'), findsOneWidget);
    });

    testWidgets('Japanese locale should have correct strings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('ja'),
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: _TestWidget.new),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('再生'), findsOneWidget);
      expect(find.text('速度'), findsOneWidget);
    });

    testWidgets('Korean locale should have correct strings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('ko'),
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: _TestWidget.new),
          ),
        ),
      );

      expect(find.text('Graviton'), findsOneWidget);
      expect(find.text('재생'), findsOneWidget);
      expect(find.text('속도'), findsOneWidget);
    });
  });
}

class _TestWidget extends StatelessWidget {
  const _TestWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(l10n.appTitle),
        Text(l10n.playButton),
        Text(l10n.speedLabel),
      ],
    );
  }
}
