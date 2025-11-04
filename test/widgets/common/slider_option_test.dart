import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/common/slider_option.dart';

void main() {
  group('SliderOption', () {
    testWidgets('renders simple slider correctly', (WidgetTester tester) async {
      double value = 5.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SliderOption.simple(
              label: 'Test Slider',
              value: value,
              min: 0.0,
              max: 10.0,
              divisions: 10,
              icon: Icons.star,
              onChanged: (newValue) {
                value = newValue;
              },
            ),
          ),
        ),
      );

      // Verify the label is displayed
      expect(find.text('Test Slider'), findsOneWidget);

      // Verify the icon is displayed
      expect(find.byIcon(Icons.star), findsOneWidget);

      // Verify the slider exists
      expect(find.byType(Slider), findsOneWidget);

      // Verify the slider has the correct value
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, equals(5.0));
      expect(slider.min, equals(0.0));
      expect(slider.max, equals(10.0));
      expect(slider.divisions, equals(10));
    });

    testWidgets('renders detailed slider correctly', (
      WidgetTester tester,
    ) async {
      double value = 7.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SliderOption.detailed(
              label: 'Detailed Slider',
              value: value,
              min: 0.0,
              max: 15.0,
              divisions: 30,
              icon: Icons.tune,
              onChanged: (newValue) {
                value = newValue;
              },
              formatter: (val) => '${val.toStringAsFixed(1)}x',
            ),
          ),
        ),
      );

      // Verify the label is displayed
      expect(find.text('Detailed Slider'), findsOneWidget);

      // Verify the formatted value is displayed
      expect(find.text('7.5x'), findsOneWidget);

      // Verify the icon is displayed
      expect(find.byIcon(Icons.tune), findsOneWidget);

      // Verify the slider exists
      expect(find.byType(Slider), findsOneWidget);

      // Verify the slider has the correct properties
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, equals(7.5));
      expect(slider.min, equals(0.0));
      expect(slider.max, equals(15.0));
      expect(slider.divisions, equals(30));
    });

    testWidgets('handles value clamping correctly', (
      WidgetTester tester,
    ) async {
      // Test value outside the range to verify clamping
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SliderOption.simple(
              label: 'Clamped Slider',
              value: 15.0, // Outside max range
              min: 0.0,
              max: 10.0,
              divisions: 10,
              icon: Icons.warning,
              onChanged: (newValue) {},
            ),
          ),
        ),
      );

      // Verify the slider clamps the value to the max
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, equals(10.0)); // Should be clamped to max
    });

    testWidgets('handles onChanged callback correctly', (
      WidgetTester tester,
    ) async {
      double value = 5.0;
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SliderOption.simple(
              label: 'Interactive Slider',
              value: value,
              min: 0.0,
              max: 10.0,
              divisions: 10,
              icon: Icons.check,
              onChanged: (newValue) {
                value = newValue;
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      // Find the slider and simulate dragging
      final sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(callbackCalled, isTrue);
    });
  });
}
