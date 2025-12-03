import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_switch_list_tile.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HapticSwitchListTile', () {
    testWidgets('renders with required properties', (
      WidgetTester tester,
    ) async {
      bool switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: switchValue,
              onChanged: (value) => switchValue = value,
              title: const Text('Test Switch'),
            ),
          ),
        ),
      );

      expect(find.byType(HapticSwitchListTile), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.text('Test Switch'), findsOneWidget);
    });

    testWidgets('calls onChanged and triggers haptic feedback when tapped', (
      WidgetTester tester,
    ) async {
      bool switchValue = false;
      bool onChangedCalled = false;
      List<MethodCall> hapticCalls = [];

      // Mock haptic feedback
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'HapticFeedback.vibrate') {
              hapticCalls.add(methodCall);
            }
            return null;
          });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: switchValue,
              onChanged: (value) {
                switchValue = value;
                onChangedCalled = true;
              },
              title: const Text('Test Switch'),
            ),
          ),
        ),
      );

      // Tap the switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(onChangedCalled, isTrue);
      expect(switchValue, isTrue);
      expect(hapticCalls.length, greaterThan(0));
    });

    testWidgets('respects disabled state when onChanged is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: false,
              onChanged: null,
              title: const Text('Disabled Switch'),
            ),
          ),
        ),
      );

      expect(find.byType(HapticSwitchListTile), findsOneWidget);

      // Try to tap the switch - should not respond
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Switch should remain in its original state
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
      expect(switchWidget.onChanged, isNull);
    });

    testWidgets('passes through all SwitchListTile properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: true,
              onChanged: (value) {},
              title: const Text('Main Title'),
              subtitle: const Text('Subtitle Text'),
              secondary: const Icon(Icons.settings),
              isThreeLine: true,
              dense: true,
              selected: true,
              activeColor: AppColors.uiGreen,
              inactiveThumbColor: AppColors.uiRed,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      );

      expect(find.text('Main Title'), findsOneWidget);
      expect(find.text('Subtitle Text'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);

      final switchListTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchListTile.value, isTrue);
      expect(switchListTile.isThreeLine, isTrue);
      expect(switchListTile.dense, isTrue);
      expect(switchListTile.selected, isTrue);
      expect(switchListTile.activeThumbColor, equals(AppColors.uiGreen));
      expect(switchListTile.inactiveThumbColor, equals(AppColors.uiRed));
      expect(switchListTile.contentPadding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('handles controlAffinity correctly', (
      WidgetTester tester,
    ) async {
      // Test trailing (default)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: false,
              onChanged: (value) {},
              title: const Text('Trailing Switch'),
              controlAffinity: false,
            ),
          ),
        ),
      );

      var switchListTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(
        switchListTile.controlAffinity,
        equals(ListTileControlAffinity.trailing),
      );

      // Test leading
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: false,
              onChanged: (value) {},
              title: const Text('Leading Switch'),
              controlAffinity: true,
            ),
          ),
        ),
      );

      switchListTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(
        switchListTile.controlAffinity,
        equals(ListTileControlAffinity.leading),
      );
    });

    testWidgets('supports material design properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: false,
              onChanged: (value) {},
              title: const Text('Material Switch'),
              tileColor: AppColors.primaryColor,
              selectedTileColor: AppColors.primaryColor,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              enableFeedback: false,
            ),
          ),
        ),
      );

      final switchListTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchListTile.tileColor, equals(AppColors.primaryColor));
      expect(switchListTile.selectedTileColor, equals(AppColors.primaryColor));
      expect(switchListTile.visualDensity, equals(VisualDensity.compact));
      expect(
        switchListTile.materialTapTargetSize,
        equals(MaterialTapTargetSize.shrinkWrap),
      );
      expect(switchListTile.enableFeedback, isFalse);
    });

    testWidgets('handles focus and autofocus properties', (
      WidgetTester tester,
    ) async {
      final focusNode = FocusNode();
      bool focusChanged = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSwitchListTile(
              value: false,
              onChanged: (value) {},
              title: const Text('Focus Switch'),
              focusNode: focusNode,
              autofocus: true,
              onFocusChange: (hasFocus) => focusChanged = true,
            ),
          ),
        ),
      );

      final switchListTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchListTile.focusNode, equals(focusNode));
      expect(switchListTile.autofocus, isTrue);
      expect(switchListTile.onFocusChange, isNotNull);

      // Verify focus change callback was called due to autofocus
      expect(focusChanged, isTrue);

      focusNode.dispose();
    });

    group('Haptic feedback integration', () {
      late List<MethodCall> hapticCalls;

      setUp(() {
        hapticCalls = [];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'HapticFeedback.vibrate') {
                hapticCalls.add(methodCall);
              }
              return null;
            });
      });

      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      testWidgets('triggers haptic feedback on value change', (
        WidgetTester tester,
      ) async {
        bool switchValue = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => HapticSwitchListTile(
                  value: switchValue,
                  onChanged: (value) => setState(() => switchValue = value),
                  title: const Text('Haptic Switch'),
                ),
              ),
            ),
          ),
        );

        hapticCalls.clear();

        // Tap to turn on
        await tester.tap(find.byType(Switch));
        await tester.pump();

        expect(hapticCalls.length, greaterThan(0));
        expect(
          hapticCalls.first.arguments,
          equals('HapticFeedbackType.selectionClick'),
        );

        hapticCalls.clear();

        // Tap to turn off
        await tester.tap(find.byType(Switch));
        await tester.pump();

        expect(hapticCalls.length, greaterThan(0));
        expect(
          hapticCalls.first.arguments,
          equals('HapticFeedbackType.selectionClick'),
        );
      });

      testWidgets('does not trigger haptic when disabled', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HapticSwitchListTile(
                value: false,
                onChanged: null,
                title: const Text('Disabled Switch'),
              ),
            ),
          ),
        );

        hapticCalls.clear();

        // Try to tap disabled switch
        await tester.tap(find.byType(Switch));
        await tester.pump();

        expect(hapticCalls, isEmpty);
      });
    });
  });
}
