import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/dialog_title.dart';

/// Helper to create a MaterialApp wrapper for testing
Widget createTestApp({Widget? child, ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? ThemeData.light(),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    locale: const Locale('en'),
    home: child ?? const SizedBox(),
  );
}

void main() {
  group('DialogTitle Widget Tests', () {
    testWidgets('renders with required parameters', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(title: 'Test Title', icon: Icons.info),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('applies default styling correctly', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(
              title: 'Default Style Title',
              icon: Icons.settings,
            ),
          ),
        ),
      );

      // Find the icon widget
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.settings));
      expect(iconWidget.size, AppTypography.iconSizeXXLarge);

      // Find the text widget
      final textWidget = tester.widget<Text>(find.text('Default Style Title'));
      expect(textWidget.style?.fontWeight, FontWeight.bold);
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 2);
    });

    testWidgets('applies custom icon color and size', (tester) async {
      const customColor = Colors.red;
      const customSize = 32.0;

      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(
              title: 'Custom Icon Title',
              icon: Icons.warning,
              iconColor: customColor,
              iconSize: customSize,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.warning));
      expect(iconWidget.color, customColor);
      expect(iconWidget.size, customSize);
    });

    testWidgets('applies custom title style', (tester) async {
      const customStyle = TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Colors.green,
      );

      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(
              title: 'Custom Style Title',
              icon: Icons.star,
              titleStyle: customStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Custom Style Title'));
      expect(textWidget.style?.fontSize, customStyle.fontSize);
      expect(textWidget.style?.fontWeight, customStyle.fontWeight);
      expect(textWidget.style?.color, customStyle.color);
    });

    testWidgets('includes trailing widget when provided', (tester) async {
      const trailingKey = Key('trailing_widget');

      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(
              title: 'Title with Trailing',
              icon: Icons.edit,
              trailing: IconButton(
                key: trailingKey,
                onPressed: null,
                icon: Icon(Icons.close),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(trailingKey), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('handles custom spacing correctly', (tester) async {
      const customSpacing = 20.0;

      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(
              title: 'Custom Spacing Title',
              icon: Icons.space_bar,
              spacing: customSpacing,
            ),
          ),
        ),
      );

      // Find SizedBox widgets and verify spacing
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.any((box) => box.width == customSpacing), isTrue);
    });

    testWidgets('handles very long titles with overflow', (tester) async {
      const longTitle =
          'This is a very long title that should definitely overflow '
          'and be handled properly by the Expanded widget to prevent layout issues '
          'in dialog implementations across the application';

      await tester.pumpWidget(
        createTestApp(
          child: const SizedBox(
            width: 300, // Constrained width to force overflow
            child: Scaffold(
              body: DialogTitle(title: longTitle, icon: Icons.text_fields),
            ),
          ),
        ),
      );

      // Ensure the widget renders without throwing overflow errors
      expect(tester.takeException(), isNull);
      expect(find.text(longTitle), findsOneWidget);

      // Verify the text is inside an Expanded widget
      final expandedWidget = tester.widget<Expanded>(
        find.ancestor(
          of: find.text(longTitle),
          matching: find.byType(Expanded),
        ),
      );
      expect(expandedWidget, isNotNull);
    });

    testWidgets('maintains proper Row layout structure', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(
              title: 'Layout Test Title',
              icon: Icons.architecture,
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ),
      );

      // Verify the Row contains the expected children in order
      final rowWidget = tester.widget<Row>(find.byType(Row));
      expect(
        rowWidget.children.length,
        5,
      ); // Icon, SizedBox, Expanded, SizedBox, trailing

      // Verify structure by finding nested widgets
      expect(find.byIcon(Icons.architecture), findsOneWidget);
      expect(find.text('Layout Test Title'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('works with different theme colors', (tester) async {
      // Test with dark theme
      await tester.pumpWidget(
        createTestApp(
          theme: ThemeData.dark(),
          child: const Scaffold(
            body: DialogTitle(title: 'Dark Theme Title', icon: Icons.dark_mode),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Dark Theme Title'), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('handles empty title gracefully', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(title: '', icon: Icons.hourglass_empty),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text(''), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
    });

    testWidgets('supports accessibility features', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const Scaffold(
            body: DialogTitle(
              title: 'Accessible Title',
              icon: Icons.accessibility,
            ),
          ),
        ),
      );

      // Verify that text and icon are findable (basic accessibility check)
      expect(find.text('Accessible Title'), findsOneWidget);
      expect(find.byIcon(Icons.accessibility), findsOneWidget);

      // Ensure no a11y issues with the layout
      expect(tester.takeException(), isNull);
    });

    testWidgets('preserves text directionality', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: DialogTitle(
                title: 'RTL Title',
                icon: Icons.format_textdirection_r_to_l,
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('RTL Title'), findsOneWidget);
    });

    group('Edge Cases', () {
      testWidgets('handles null trailing widget correctly', (tester) async {
        await tester.pumpWidget(
          createTestApp(
            child: const Scaffold(
              body: DialogTitle(
                title: 'No Trailing Title',
                icon: Icons.remove,
                trailing: null,
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        // Should only have 3 children in Row (Icon, SizedBox, Expanded)
        final rowWidget = tester.widget<Row>(find.byType(Row));
        expect(rowWidget.children.length, 3);
      });

      testWidgets('handles zero spacing', (tester) async {
        await tester.pumpWidget(
          createTestApp(
            child: const Scaffold(
              body: DialogTitle(
                title: 'Zero Spacing Title',
                icon: Icons.compress,
                spacing: 0,
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        // Find SizedBox with zero width
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.width == 0), isTrue);
      });

      testWidgets('handles very small icon size', (tester) async {
        await tester.pumpWidget(
          createTestApp(
            child: const Scaffold(
              body: DialogTitle(
                title: 'Tiny Icon Title',
                icon: Icons.fiber_manual_record,
                iconSize: 1.0,
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.fiber_manual_record),
        );
        expect(iconWidget.size, 1.0);
      });
    });
  });
}
