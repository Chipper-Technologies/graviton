import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/common/section_divider.dart';

void main() {
  group('SectionDivider', () {
    testWidgets('should render plain divider with default styling', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SectionDivider.plain())),
      );

      // Assert
      expect(find.byType(SectionDivider), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, equals(AppColors.uiDividerGrey));
      expect(divider.thickness, equals(1.0));
      expect(divider.height, equals(1.0));
      expect(divider.indent, equals(0.0));
      expect(divider.endIndent, equals(0.0));
    });

    testWidgets('should render labeled divider with text', (
      WidgetTester tester,
    ) async {
      // Arrange
      const labelText = 'Test Section';

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SectionDivider.labeled(labelText))),
      );

      // Assert
      expect(find.byType(SectionDivider), findsOneWidget);
      expect(find.text(labelText), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);

      // Should have two Container widgets for left and right divider lines
      expect(find.byType(Container), findsNWidgets(2));

      // Check that containers have the correct color
      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final container in containers) {
        expect(container.color, equals(AppColors.uiDividerGrey));
      }
    });

    testWidgets('should apply custom color to plain divider', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customColor = AppColors.uiRed;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SectionDivider.plain(color: customColor)),
        ),
      );

      // Assert
      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, equals(customColor));
    });

    testWidgets('should apply custom color to labeled divider', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customColor = AppColors.primaryColor;
      const labelText = 'Custom Section';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.labeled(labelText, color: customColor),
          ),
        ),
      );

      // Assert
      expect(find.text(labelText), findsOneWidget);

      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final container in containers) {
        expect(container.color, equals(customColor));
      }
    });

    testWidgets('should apply custom thickness to plain divider', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customThickness = 3.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.plain(thickness: customThickness),
          ),
        ),
      );

      // Assert
      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.thickness, equals(customThickness));
    });

    testWidgets('should apply custom thickness to labeled divider', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customThickness = 2.5;
      const labelText = 'Thick Section';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.labeled(labelText, thickness: customThickness),
          ),
        ),
      );

      // Assert
      expect(find.text(labelText), findsOneWidget);

      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final container in containers) {
        expect(container.constraints?.maxHeight, equals(customThickness));
      }
    });

    testWidgets('should apply custom indents to plain divider', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customIndent = 20.0;
      const customEndIndent = 30.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.plain(
              indent: customIndent,
              endIndent: customEndIndent,
            ),
          ),
        ),
      );

      // Assert
      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.indent, equals(customIndent));
      expect(divider.endIndent, equals(customEndIndent));
    });

    testWidgets('should apply custom label style', (WidgetTester tester) async {
      // Arrange
      const labelText = 'Styled Section';
      const customStyle = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.uiGreen,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.labeled(labelText, labelStyle: customStyle),
          ),
        ),
      );

      // Assert
      expect(find.text(labelText), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text(labelText));
      expect(textWidget.style?.fontSize, equals(20));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
      expect(textWidget.style?.color, equals(AppColors.uiGreen));
    });

    testWidgets('should apply top and bottom spacing', (
      WidgetTester tester,
    ) async {
      // Arrange
      const topSpacing = 16.0;
      const bottomSpacing = 24.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.plain(
              topSpacing: topSpacing,
              bottomSpacing: bottomSpacing,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Column), findsOneWidget);
      expect(
        find.byType(SizedBox),
        findsNWidgets(3),
      ); // Top, bottom spacing, plus Divider's internal SizedBox

      final sizedBoxes = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .toList();
      // Filter to find our spacing SizedBoxes (exclude Divider's internal ones)
      final spacingSizedBoxes = sizedBoxes
          .where(
            (box) => box.height == topSpacing || box.height == bottomSpacing,
          )
          .toList();

      expect(spacingSizedBoxes.length, equals(2));
      expect(spacingSizedBoxes.any((box) => box.height == topSpacing), isTrue);
      expect(
        spacingSizedBoxes.any((box) => box.height == bottomSpacing),
        isTrue,
      );
    });

    testWidgets(
      'should not add spacing when topSpacing and bottomSpacing are 0',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionDivider.plain(topSpacing: 0.0, bottomSpacing: 0.0),
            ),
          ),
        );

        // Assert
        expect(find.byType(Column), findsNothing);
        // Divider widget creates its own internal SizedBox, so we can't expect zero
        expect(find.byType(Divider), findsOneWidget);
      },
    );

    testWidgets('should apply custom label padding', (
      WidgetTester tester,
    ) async {
      // Arrange
      const labelText = 'Padded Section';
      const customPadding = 32.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.labeled(
              labelText,
              labelPadding: customPadding,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(labelText), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(
        padding.padding,
        equals(EdgeInsets.symmetric(horizontal: customPadding)),
      );
    });

    testWidgets(
      'should use default theme colors for label when no custom style provided',
      (WidgetTester tester) async {
        // Arrange
        const labelText = 'Default Styled Section';

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              textTheme: const TextTheme(
                titleSmall: TextStyle(color: AppColors.stellarOType),
              ),
              colorScheme: const ColorScheme.light(
                onSurfaceVariant: AppColors.uiOrangeAccent,
              ),
            ),
            home: Scaffold(body: SectionDivider.labeled(labelText)),
          ),
        );

        // Assert
        expect(find.text(labelText), findsOneWidget);

        final textWidget = tester.widget<Text>(find.text(labelText));
        expect(textWidget.style?.color, equals(AppColors.uiOrangeAccent));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w500));
      },
    );

    testWidgets('should render correctly with all custom parameters', (
      WidgetTester tester,
    ) async {
      // Arrange
      const labelText = 'Full Custom Section';
      const customStyle = TextStyle(color: AppColors.uiRed, fontSize: 18);
      const customColor = AppColors.primaryColor;
      const customThickness = 2.0;
      const customLabelPadding = 20.0;
      const customTopSpacing = 10.0;
      const customBottomSpacing = 15.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionDivider.labeled(
              labelText,
              labelStyle: customStyle,
              color: customColor,
              thickness: customThickness,
              labelPadding: customLabelPadding,
              topSpacing: customTopSpacing,
              bottomSpacing: customBottomSpacing,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SectionDivider), findsOneWidget);
      expect(find.text(labelText), findsOneWidget);
      expect(find.byType(Column), findsOneWidget); // Due to spacing
      expect(find.byType(SizedBox), findsNWidgets(2)); // Top and bottom spacing

      // Check text style
      final textWidget = tester.widget<Text>(find.text(labelText));
      expect(textWidget.style?.color, equals(AppColors.uiRed));
      expect(textWidget.style?.fontSize, equals(18));

      // Check padding
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(
        padding.padding,
        equals(EdgeInsets.symmetric(horizontal: customLabelPadding)),
      );

      // Check spacing
      final sizedBoxes = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .toList();
      expect(sizedBoxes[0].height, equals(customTopSpacing));
      expect(sizedBoxes[1].height, equals(customBottomSpacing));
    });

    group('Constructor tests', () {
      testWidgets('SectionDivider.plain should have correct default values', (
        WidgetTester tester,
      ) async {
        // Act
        const divider = SectionDivider.plain();

        // Assert
        expect(divider.label, isNull);
        expect(divider.labelStyle, isNull);
        expect(divider.thickness, equals(1.0));
        expect(divider.color, isNull);
        expect(divider.labelPadding, equals(0.0));
        expect(divider.topSpacing, equals(0.0));
        expect(divider.bottomSpacing, equals(0.0));
        expect(divider.indent, equals(0.0));
        expect(divider.endIndent, equals(0.0));
        expect(divider.height, equals(1.0));
      });

      testWidgets('SectionDivider.labeled should have correct default values', (
        WidgetTester tester,
      ) async {
        // Act
        const divider = SectionDivider.labeled('Test');

        // Assert
        expect(divider.label, equals('Test'));
        expect(divider.labelStyle, isNull);
        expect(divider.thickness, equals(1.0));
        expect(divider.color, isNull);
        expect(divider.labelPadding, equals(16.0));
        expect(divider.topSpacing, equals(0.0));
        expect(divider.bottomSpacing, equals(0.0));
        expect(divider.indent, equals(0.0));
        expect(divider.endIndent, equals(0.0));
        expect(divider.height, isNull);
      });
    });
  });
}
