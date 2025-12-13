import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_switch.dart';
import 'package:graviton/services/ui/haptic_feedback_service.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HapticSwitch Tests', () {
    bool switchValue = false;

    setUp(() {
      switchValue = false;
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticSwitch child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticSwitch(
            value: switchValue,
            onChanged: (value) => switchValue = value,
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(HapticSwitch), findsOneWidget);
    });

    testWidgets('should call onChanged when toggled', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        createTestWidget(
          child: HapticSwitch(
            value: switchValue,
            onChanged: (value) {
              switchValue = value;
              called = true;
            },
          ),
        ),
      );

      // Tap the switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Should have called onChanged and updated value
      expect(called, isTrue);
      expect(switchValue, isTrue);
    });

    testWidgets('should handle disabled switch correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticSwitch(
            value: switchValue,
            onChanged: null, // Disabled
          ),
        ),
      );

      // Try to tap the switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Should not change value when disabled
      expect(switchValue, isFalse);
    });

    testWidgets('should handle multiple toggles', (tester) async {
      bool localSwitchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return HapticSwitch(
                  value: localSwitchValue,
                  onChanged: (value) =>
                      setState(() => localSwitchValue = value),
                );
              },
            ),
          ),
        ),
      );

      // Toggle multiple times
      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Should have ended up in the expected state
      expect(localSwitchValue, isTrue);
    });

    testWidgets('should pass through all switch properties', (tester) async {
      const activeColor = AppColors.uiRed;
      const inactiveThumbColor = AppColors.uiLightBlueAccent;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticSwitch(
            value: true,
            onChanged: (value) => switchValue = value,
            activeColor: activeColor,
            inactiveThumbColor: inactiveThumbColor,
          ),
        ),
      );

      final Switch switch_ = tester.widget(find.byType(Switch));
      expect(switch_.value, isTrue);
      expect(switch_.activeThumbColor, activeColor);
      expect(switch_.inactiveThumbColor, inactiveThumbColor);
    });

    testWidgets('should handle semantic properties correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: HapticSwitch(
            value: switchValue,
            onChanged: (value) => switchValue = value,
            autofocus: true,
          ),
        ),
      );

      final Switch switch_ = tester.widget(find.byType(Switch));
      expect(switch_.autofocus, isTrue);
    });

    testWidgets('should work when haptic feedback is disabled', (tester) async {
      HapticFeedbackService.instance.setEnabled(false);
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(
          child: HapticSwitch(
            value: switchValue,
            onChanged: (value) {
              switchValue = value;
              called = true;
            },
          ),
        ),
      );

      // Tap the switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Should still work even when haptic feedback is disabled
      expect(called, isTrue);
      expect(switchValue, isTrue);
    });
  });
}
