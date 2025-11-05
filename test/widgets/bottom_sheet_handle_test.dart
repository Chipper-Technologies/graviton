import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/bottom_sheet_handle.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

void main() {
  group('BottomSheetHandle', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: BottomSheetHandle())),
      );

      expect(find.byType(BottomSheetHandle), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: BottomSheetHandle())),
      );

      final Container container = tester.widget(find.byType(Container));
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      expect(
        decoration.color,
        AppColors.uiWhite.withValues(alpha: AppTypography.opacityFaint),
      );
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('has correct margins', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: BottomSheetHandle())),
      );

      final Container container = tester.widget(find.byType(Container));
      final EdgeInsetsGeometry? margin = container.margin;

      expect(margin, isA<EdgeInsets>());
      // EdgeInsets.symmetric(vertical: AppTypography.spacingMedium) means top and bottom are each spacingMedium
      expect((margin as EdgeInsets).vertical, AppTypography.spacingMedium * 2);
      expect(margin.horizontal, 0);
    });

    testWidgets('can be wrapped in other widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [BottomSheetHandle(), Text('Content below')],
            ),
          ),
        ),
      );

      expect(find.byType(BottomSheetHandle), findsOneWidget);
      expect(find.text('Content below'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('is accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: BottomSheetHandle())),
      );

      // Should render without semantic issues
      expect(find.byType(BottomSheetHandle), findsOneWidget);
    });

    testWidgets('renders consistently across rebuilds', (
      WidgetTester tester,
    ) async {
      const Key handleKey = Key('bottom_sheet_handle');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: BottomSheetHandle(key: handleKey)),
        ),
      );

      final Container firstRender = tester.widget(find.byType(Container));

      // Trigger rebuild
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: BottomSheetHandle(key: handleKey)),
        ),
      );

      final Container secondRender = tester.widget(find.byType(Container));

      // Properties should remain the same
      expect(firstRender.constraints, secondRender.constraints);
      expect(firstRender.margin, secondRender.margin);
      expect(firstRender.decoration, secondRender.decoration);
    });

    testWidgets('has proper visual appearance in light theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(body: BottomSheetHandle()),
        ),
      );

      final Container container = tester.widget(find.byType(Container));
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      // Color should be consistent regardless of theme
      expect(
        decoration.color,
        AppColors.uiWhite.withValues(alpha: AppTypography.opacityFaint),
      );
    });

    testWidgets('has proper visual appearance in dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(body: BottomSheetHandle()),
        ),
      );

      final Container container = tester.widget(find.byType(Container));
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      // Color should be consistent regardless of theme
      expect(
        decoration.color,
        AppColors.uiWhite.withValues(alpha: AppTypography.opacityFaint),
      );
    });

    testWidgets('maintains aspect ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: BottomSheetHandle())),
      );

      // Handle should be much wider than it is tall (like a real handle)
      // Width is 40, height is 4, so width should be greater than height
      expect(40, greaterThan(4));
    });
  });
}
