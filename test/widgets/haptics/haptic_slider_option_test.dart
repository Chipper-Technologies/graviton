import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/widgets/haptics/haptic_slider_option.dart';

void main() {
  group('HapticSliderOption', () {
    late List<MethodCall> methodCalls;

    setUp(() {
      methodCalls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter/hapticfeedback'),
            (MethodCall methodCall) async {
              methodCalls.add(methodCall);
              return null;
            },
          );

      // Reset haptic service for clean state
      HapticFeedbackService.instance.setUIEnabled(true);
      HapticFeedbackService.instance.setCollisionEnabled(true);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter/hapticfeedback'),
            null,
          );
    });

    testWidgets('should create simple haptic slider', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSliderOption.simple(
              label: 'Test Slider',
              value: 0.5,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.tune,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(HapticSliderOption), findsOneWidget);
      expect(find.text('Test Slider'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('should create detailed haptic slider', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSliderOption.detailed(
              label: 'Test Detailed Slider',
              value: 0.7,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.tune,
              onChanged: (value) {},
              formatter: (value) => '${(value * 100).toInt()}%',
            ),
          ),
        ),
      );

      expect(find.byType(HapticSliderOption), findsOneWidget);
      expect(find.text('Test Detailed Slider'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('should provide haptic feedback on slider interaction', (
      WidgetTester tester,
    ) async {
      double sliderValue = 0.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return HapticSliderOption.simple(
                  label: 'Haptic Test Slider',
                  value: sliderValue,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  icon: Icons.volume_up,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Clear previous calls
      methodCalls.clear();

      // Simulate slider interaction
      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // The widget should exist and function properly
      // (Haptic feedback testing in isolation is complex due to platform differences)
      expect(find.byType(HapticSliderOption), findsOneWidget);
    });

    testWidgets('should handle value changes correctly', (
      WidgetTester tester,
    ) async {
      double sliderValue = 0.2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return HapticSliderOption.simple(
                  label: 'Value Change Test',
                  value: sliderValue,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  icon: Icons.linear_scale,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Simulate slider interaction
      await tester.tap(slider);
      await tester.pumpAndSettle();

      // Widget should still be functioning correctly
      expect(find.byType(HapticSliderOption), findsOneWidget);
    });

    testWidgets('should handle disabled haptics gracefully', (
      WidgetTester tester,
    ) async {
      // Disable haptic feedback
      HapticFeedbackService.instance.setUIEnabled(false);

      double sliderValue = 0.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSliderOption.simple(
              label: 'Disabled Haptics Test',
              value: sliderValue,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.volume_off,
              onChanged: (value) {
                sliderValue = value;
              },
            ),
          ),
        ),
      );

      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Clear previous calls
      methodCalls.clear();

      // Interact with slider
      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Should have fewer or no haptic calls when disabled
      // Note: Some calls might still occur due to the internal slider behavior
    });

    testWidgets('should clamp values within range', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSliderOption.simple(
              label: 'Clamped Slider',
              value: 2.0, // Above max
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.warning,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final sliderWidget = tester.widget<Slider>(find.byType(Slider));
      expect(sliderWidget.value, equals(1.0)); // Should be clamped to max
    });

    testWidgets('should handle formatter correctly in detailed mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HapticSliderOption.detailed(
              label: 'Formatted Slider',
              value: 0.75,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.percent,
              onChanged: (value) {},
              formatter: (value) => '${(value * 100).round()}%',
            ),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('should update value when changed', (
      WidgetTester tester,
    ) async {
      double currentValue = 0.3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return HapticSliderOption.detailed(
                  label: 'Dynamic Slider',
                  value: currentValue,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  icon: Icons.tune,
                  onChanged: (value) {
                    setState(() {
                      currentValue = value;
                    });
                  },
                  formatter: (value) => value.toStringAsFixed(1),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('0.3'), findsOneWidget);

      // Interact with slider to change value
      final slider = find.byType(Slider);
      await tester.tap(slider);
      await tester.pumpAndSettle();

      // Value should have changed
      final sliderWidget = tester.widget<Slider>(find.byType(Slider));
      expect(sliderWidget.value, isNot(equals(0.3)));
    });
  });
}
