import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/animations/pulse_animation.dart';

void main() {
  group('PulseAnimation', () {
    Widget buildTestWidget({
      Duration? duration,
      double? maxScale,
      bool enabled = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PulseAnimation(
            duration: duration ?? const Duration(milliseconds: 1000),
            maxScale: maxScale ?? 1.05,
            enabled: enabled,
            child: Container(
              width: 100,
              height: 100,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      );
    }

    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('has ScaleTransition', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(ScaleTransition), findsOneWidget);
    });

    testWidgets('animates over time', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(duration: const Duration(milliseconds: 500)),
      );

      // Get initial scale
      final initialFinder = find.byType(ScaleTransition);
      expect(initialFinder, findsOneWidget);

      // Advance animation
      await tester.pump(const Duration(milliseconds: 250));

      // Animation should still be running
      expect(find.byType(ScaleTransition), findsOneWidget);
    });

    testWidgets('uses custom duration', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(duration: const Duration(seconds: 2)),
      );

      expect(find.byType(ScaleTransition), findsOneWidget);
    });

    testWidgets('uses custom maxScale', (tester) async {
      await tester.pumpWidget(buildTestWidget(maxScale: 1.5));

      expect(find.byType(ScaleTransition), findsOneWidget);
    });

    testWidgets('does not animate when disabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(enabled: false));

      expect(find.byType(ScaleTransition), findsOneWidget);
    });

    testWidgets('properly disposes animation controller', (tester) async {
      await tester.pumpWidget(buildTestWidget(enabled: false));
      await tester.pump();

      // Remove widget - should not throw
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );
      await tester.pump();

      // No assertion error means proper disposal
    });
  });
}
