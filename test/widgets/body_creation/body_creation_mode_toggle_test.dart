import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/body_creation/body_creation_mode_toggle.dart';
import 'package:graviton/widgets/haptics/haptic_circular_button.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('BodyCreationModeToggle Tests', () {
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

    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: BodyCreationModeToggle(isActive: false, onToggle: () {}),
        ),
      );

      expect(find.byType(BodyCreationModeToggle), findsOneWidget);
      expect(find.byType(HapticCircularButton), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('should call onToggle when tapped', (
      WidgetTester tester,
    ) async {
      bool toggleCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          child: BodyCreationModeToggle(
            isActive: false,
            onToggle: () => toggleCalled = true,
          ),
        ),
      );

      await tester.tap(find.byType(HapticCircularButton));
      await tester.pump();

      expect(toggleCalled, isTrue);
    });

    testWidgets('should show inactive styling when mode is inactive', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: BodyCreationModeToggle(isActive: false, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.iconColor, isNotNull);
      expect(button.backgroundColor, isNotNull);
      // Border color can be null or non-null
    });

    testWidgets('should show active styling when mode is active', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: BodyCreationModeToggle(isActive: true, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.iconColor, isNotNull);
      expect(button.backgroundColor, isNotNull);
      // Border color is null for active primary style
      expect(button.borderColor, isNull);
    });

    testWidgets('should have proper accessibility properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: BodyCreationModeToggle(isActive: false, onToggle: () {}),
        ),
      );

      final button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );

      expect(button.semanticsLabel, isNotNull);
      expect(button.semanticsHint, isNotNull);
      expect(button.tooltip, isNotNull);
    });

    testWidgets('should update styling when isActive changes', (
      WidgetTester tester,
    ) async {
      bool isActive = false;

      await tester.pumpWidget(
        createTestWidget(
          child: StatefulBuilder(
            builder: (context, setState) => BodyCreationModeToggle(
              isActive: isActive,
              onToggle: () {
                setState(() {
                  isActive = !isActive;
                });
              },
            ),
          ),
        ),
      );

      // Verify initial state
      var button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );
      final initialBackgroundColor = button.backgroundColor;

      // Tap to toggle
      await tester.tap(find.byType(HapticCircularButton));
      await tester.pumpAndSettle();

      // Verify styling changed
      button = tester.widget<HapticCircularButton>(
        find.byType(HapticCircularButton),
      );
      final newBackgroundColor = button.backgroundColor;

      expect(newBackgroundColor, isNot(equals(initialBackgroundColor)));
    });

    testWidgets('should work in different layout contexts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Row(
            children: [
              BodyCreationModeToggle(isActive: false, onToggle: () {}),
              const SizedBox(width: AppTypography.spacingLarge),
              BodyCreationModeToggle(isActive: true, onToggle: () {}),
            ],
          ),
        ),
      );

      expect(find.byType(BodyCreationModeToggle), findsNWidgets(2));
      expect(find.byType(HapticCircularButton), findsNWidgets(2));
    });

    testWidgets('should handle rapid taps correctly', (
      WidgetTester tester,
    ) async {
      int tapCount = 0;

      await tester.pumpWidget(
        createTestWidget(
          child: BodyCreationModeToggle(
            isActive: false,
            onToggle: () => tapCount++,
          ),
        ),
      );

      // Perform rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(HapticCircularButton));
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tapCount, equals(5));
    });
  });
}
