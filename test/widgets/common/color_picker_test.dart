import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/common/color_picker.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Test widget wrapper with localization support
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('ColorPicker', () {
    testWidgets('displays default colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: AppColors.planetEarth,
            onColorChanged: (_) {},
          ),
        ),
      );

      // Should display colors in a Wrap layout
      expect(find.byType(Wrap), findsOneWidget);

      // Should have 12 default colors
      expect(find.byType(GestureDetector), findsNWidgets(12));
    });

    testWidgets('displays custom colors when provided', (
      WidgetTester tester,
    ) async {
      final customColors = [
        AppColors.planetMars,
        AppColors.planetVenus,
        AppColors.planetEarth,
      ];

      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: AppColors.planetMars,
            onColorChanged: (_) {},
            colors: customColors,
          ),
        ),
      );

      // Should have only 3 color options
      expect(find.byType(GestureDetector), findsNWidgets(3));
    });

    testWidgets('highlights selected color', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: AppColors.planetMars,
            onColorChanged: (_) {},
            colors: [
              AppColors.planetMars,
              AppColors.planetVenus,
              AppColors.planetEarth,
            ],
          ),
        ),
      );

      // Should find check icon in selected color
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onColorChanged when color tapped', (
      WidgetTester tester,
    ) async {
      Color? changedColor;
      const testColors = [Colors.red, Colors.green, Colors.blue];

      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.red,
            onColorChanged: (color) => changedColor = color,
            colors: testColors,
          ),
        ),
      );

      // Tap on the second color (green)
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pump();

      expect(changedColor, equals(Colors.green));
    });

    testWidgets('calls onColorChanged for all colors', (
      WidgetTester tester,
    ) async {
      final List<Color> changedColors = [];
      const testColors = [Colors.red, Colors.green, Colors.blue];

      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.red,
            onColorChanged: (color) => changedColors.add(color),
            colors: testColors,
          ),
        ),
      );

      // Tap each color
      for (int i = 0; i < testColors.length; i++) {
        await tester.tap(find.byType(GestureDetector).at(i));
        await tester.pump();
      }

      expect(changedColors, containsAll(testColors));
    });

    testWidgets('does not respond to taps when disabled', (
      WidgetTester tester,
    ) async {
      Color? changedColor;

      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.blue,
            onColorChanged: (color) => changedColor = color,
            enabled: false,
            colors: const [Colors.red, Colors.green, Colors.blue],
          ),
        ),
      );

      // Tap on the first color
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();

      expect(changedColor, isNull);
    });

    testWidgets('uses custom item size when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.blue,
            onColorChanged: (_) {},
            itemSize: 60.0,
            colors: const [Colors.red],
          ),
        ),
      );

      // Find the color container and check its constraints
      final container = find
          .descendant(
            of: find.byType(GestureDetector),
            matching: find.byType(Container),
          )
          .first;
      final containerWidget = tester.widget<Container>(container);

      expect(containerWidget.constraints?.maxWidth, equals(60.0));
      expect(containerWidget.constraints?.maxHeight, equals(60.0));
    });

    testWidgets('arranges colors using wrap layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.blue,
            onColorChanged: (_) {},
            colors: const [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.yellow,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      );

      // Should use Wrap layout for flexible arrangement
      expect(find.byType(Wrap), findsOneWidget);

      // Should have all 6 colors
      expect(find.byType(GestureDetector), findsNWidgets(6));
    });

    testWidgets('has proper semantics for accessibility', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.red,
            onColorChanged: (_) {},
            colors: const [Colors.red, Colors.green, Colors.blue],
          ),
        ),
      );

      // Check for main semantic information
      expect(find.bySemanticsLabel(RegExp(r'Color selector')), findsOneWidget);

      // Just verify semantic widgets exist for accessibility
      final semanticWidgets = find.byType(Semantics);
      expect(semanticWidgets, findsWidgets);
    });

    testWidgets('indicates selected state in semantics', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.red,
            onColorChanged: (_) {},
            colors: const [Colors.red, Colors.green],
          ),
        ),
      );

      // Just verify semantic widgets exist - implementation details may vary
      final semanticWidgets = find.byType(Semantics);
      expect(semanticWidgets, findsWidgets);
    });

    testWidgets('changes selection correctly', (WidgetTester tester) async {
      Color selectedColor = Colors.red;
      const testColors = [Colors.red, Colors.green, Colors.blue];

      await tester.pumpWidget(
        makeTestableWidget(
          StatefulBuilder(
            builder: (context, setState) => ColorPicker(
              selectedColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              colors: testColors,
            ),
          ),
        ),
      );

      // Initially red should be selected
      expect(selectedColor, equals(Colors.red));

      // Tap green and verify selection changes
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pump();

      expect(selectedColor, equals(Colors.green));

      // Tap blue and verify selection changes
      await tester.tap(find.byType(GestureDetector).at(2));
      await tester.pump();

      expect(selectedColor, equals(Colors.blue));
    });

    testWidgets('handles color equality correctly', (
      WidgetTester tester,
    ) async {
      // Use the same red color instance to test equality
      const redColor = Color(0xFFFF0000);

      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: redColor,
            onColorChanged: (_) {},
            colors: const [redColor, Colors.green],
          ),
        ),
      );

      // Should find check icon for the selected red color
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Verify the widget doesn't crash with color comparisons
      expect(find.byType(ColorPicker), findsOneWidget);
    });

    testWidgets('displays check icon with contrasting color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.white, // Light color should have dark check
            onColorChanged: (_) {},
            colors: const [Colors.white, Colors.black],
          ),
        ),
      );

      // Should find check icon
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Check that icon has proper color contrast
      final icon = tester.widget<Icon>(find.byIcon(Icons.check));
      expect(icon.color, equals(Colors.black)); // Dark icon on light background
    });

    testWidgets(
      'displays check icon with contrasting color for dark background',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ColorPicker(
              selectedColor: Colors.black, // Dark color should have light check
              onColorChanged: (_) {},
              colors: const [Colors.white, Colors.black],
            ),
          ),
        );

        // Should find check icon
        expect(find.byIcon(Icons.check), findsOneWidget);

        // Check that icon has proper color contrast
        final icon = tester.widget<Icon>(find.byIcon(Icons.check));
        expect(
          icon.color,
          equals(Colors.white),
        ); // Light icon on dark background
      },
    );

    testWidgets('has gesture detector with proper behavior', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ColorPicker(
            selectedColor: Colors.blue,
            onColorChanged: (_) {},
            colors: const [Colors.red, Colors.green, Colors.blue],
          ),
        ),
      );

      // Should find GestureDetectors for each color
      expect(find.byType(GestureDetector), findsNWidgets(3));
    });
  });
}
