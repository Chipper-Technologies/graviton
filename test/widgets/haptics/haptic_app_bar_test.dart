import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/l10n/app_localizations.dart';

void main() {
  group('HapticAppBar', () {
    Widget createTestWidget({Widget? child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', ''), Locale('es', '')],
        home: child ?? const Scaffold(appBar: HapticAppBar(title: 'Test')),
      );
    }

    testWidgets('displays title correctly', (WidgetTester tester) async {
      const title = 'Test Screen';

      await tester.pumpWidget(
        createTestWidget(
          child: const Scaffold(appBar: HapticAppBar(title: title)),
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('uses default styling when no custom colors provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Scaffold(appBar: const HapticAppBar(title: 'Test')),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      expect(
        appBar.backgroundColor,
        AppColors.uiBlack.withValues(alpha: AppTypography.opacityNearlyOpaque),
      );
      expect(appBar.foregroundColor, AppColors.uiWhite);
      expect(appBar.elevation, 0);
    });

    testWidgets('applies custom colors when provided', (
      WidgetTester tester,
    ) async {
      const customBg = Colors.red;
      const customFg = Colors.blue;
      const customElevation = 4.0;

      await tester.pumpWidget(
        createTestWidget(
          child: Scaffold(
            appBar: const HapticAppBar(
              title: 'Test',
              backgroundColor: customBg,
              foregroundColor: customFg,
              elevation: customElevation,
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      expect(appBar.backgroundColor, customBg);
      expect(appBar.foregroundColor, customFg);
      expect(appBar.elevation, customElevation);
    });

    testWidgets('shows haptic back button when can pop', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (context) => const Scaffold(body: Text('Home')),
                );
              } else if (settings.name == '/test') {
                return MaterialPageRoute(
                  builder: (context) =>
                      Scaffold(appBar: const HapticAppBar(title: 'Test')),
                );
              }
              return null;
            },
            initialRoute: '/',
          ),
        ),
      );

      // Navigate to test screen
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Push test screen
      final navigator = Navigator.of(tester.element(find.text('Home')));
      navigator.pushNamed('/test');
      await tester.pumpAndSettle();

      // Should show haptic back button
      expect(find.byType(HapticIconButton), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets(
      'does not show back button when automaticallyImplyLeading is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: const HapticAppBar(
                      title: 'Test',
                      automaticallyImplyLeading: false,
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // Should show no haptic buttons when automaticallyImplyLeading is false
        expect(find.byType(HapticIconButton), findsNothing);
        expect(find.byIcon(Icons.arrow_back), findsNothing);
      },
    );

    testWidgets('uses custom leading widget when provided', (
      WidgetTester tester,
    ) async {
      const customLeading = Icon(Icons.menu);

      await tester.pumpWidget(
        createTestWidget(
          child: const Scaffold(
            appBar: HapticAppBar(title: 'Test', leading: customLeading),
          ),
        ),
      );

      expect(find.byWidget(customLeading), findsOneWidget);
      // Should have no haptic buttons since custom leading is provided
      expect(find.byType(HapticIconButton), findsNothing);
    });

    testWidgets('displays custom actions when provided', (
      WidgetTester tester,
    ) async {
      final actions = [
        IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        IconButton(icon: const Icon(Icons.info), onPressed: () {}),
      ];

      await tester.pumpWidget(
        createTestWidget(
          child: Scaffold(
            appBar: HapticAppBar(title: 'Test', actions: actions),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('back button navigates back when pressed', (
      WidgetTester tester,
    ) async {
      bool popped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PopScope(
                        onPopInvokedWithResult: (didPop, result) {
                          popped = true;
                        },
                        child: Scaffold(
                          appBar: const HapticAppBar(title: 'Test'),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );

      // Navigate to test screen
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Tap back button (not logo button)
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
    });

    testWidgets('implements PreferredSizeWidget correctly', (
      WidgetTester tester,
    ) async {
      const appBar = HapticAppBar(title: 'Test');

      expect(appBar.preferredSize, const Size.fromHeight(kToolbarHeight));
    });

    testWidgets('handles null actions gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Scaffold(
            appBar: const HapticAppBar(title: 'Test', actions: null),
          ),
        ),
      );

      // Should not throw and should render normally
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets(
      'respects Navigator.canPop() when determining back button visibility',
      (WidgetTester tester) async {
        // Test with root route (cannot pop)
        await tester.pumpWidget(
          createTestWidget(
            child: Scaffold(appBar: const HapticAppBar(title: 'Root')),
          ),
        );

        // Should show no haptic buttons on root route
        expect(find.byType(HapticIconButton), findsNothing);
        expect(find.byIcon(Icons.arrow_back), findsNothing);
      },
    );

    testWidgets('applies custom titleSpacing when provided', (
      WidgetTester tester,
    ) async {
      const customTitleSpacing = 24.0;

      await tester.pumpWidget(
        createTestWidget(
          child: Scaffold(
            appBar: const HapticAppBar(
              title: 'Test',
              titleSpacing: customTitleSpacing,
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.titleSpacing, customTitleSpacing);
    });

    testWidgets('uses default titleSpacing when not provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Scaffold(appBar: const HapticAppBar(title: 'Test')),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.titleSpacing, isNull); // Should use AppBar default
    });
  });
}
