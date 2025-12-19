import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_circular_button.dart';
import 'package:graviton/widgets/interaction/interaction_lock_toggle.dart';

void main() {
  group('InteractionLockToggle Tests', () {
    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: child),
      );
    }

    testWidgets('should render correctly when unlocked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: false, onToggle: () {}),
        ),
      );

      expect(find.byType(InteractionLockToggle), findsOneWidget);
      expect(find.byType(HapticCircularButton), findsOneWidget);
      expect(find.byIcon(Icons.lock_open), findsOneWidget);
    });

    testWidgets('should render correctly when locked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: true, onToggle: () {}),
        ),
      );

      expect(find.byType(InteractionLockToggle), findsOneWidget);
      expect(find.byType(HapticCircularButton), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should call onToggle when tapped', (
      WidgetTester tester,
    ) async {
      bool toggleCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(
            isLocked: false,
            onToggle: () => toggleCalled = true,
          ),
        ),
      );

      await tester.tap(find.byType(HapticCircularButton));
      await tester.pump();

      expect(toggleCalled, isTrue);
    });

    testWidgets('should show unlocked styling when not locked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: false, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.iconColor, equals(AppColors.uiWhite));
      expect(button.backgroundColor, isNotNull);
      // Border should be visible when unlocked
      expect(button.borderColor, isNotNull);
    });

    testWidgets('should show locked styling when locked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: true, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.iconColor, equals(AppColors.uiWhite));
      expect(button.backgroundColor, isNotNull);
      // Border should be null when locked (using primary color background)
      expect(button.borderColor, isNull);
    });

    testWidgets('should have correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: false, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.size, equals(AppTypography.buttonSizeStandard));
    });

    testWidgets('should have proper accessibility labels when unlocked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: false, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      // semanticsLabel should be the lock tooltip
      expect(button.semanticsLabel, isNotNull);
      // semanticsHint should describe what tapping will do
      expect(button.semanticsHint, isNotNull);
    });

    testWidgets('should have proper accessibility labels when locked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: true, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.semanticsLabel, isNotNull);
      expect(button.semanticsHint, isNotNull);
    });

    testWidgets('should show tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: false, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.tooltip, isNotNull);
    });

    testWidgets('icon should change based on locked state', (
      WidgetTester tester,
    ) async {
      // Test unlocked state
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: false, onToggle: () {}),
        ),
      );

      expect(find.byIcon(Icons.lock_open), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNothing);

      // Test locked state
      await tester.pumpWidget(
        createTestWidget(
          child: InteractionLockToggle(isLocked: true, onToggle: () {}),
        ),
      );

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.lock_open), findsNothing);
    });
  });
}
