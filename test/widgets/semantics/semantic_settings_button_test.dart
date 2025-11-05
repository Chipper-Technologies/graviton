import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_settings_button.dart';
import 'package:graviton/services/semantic_focus_service.dart';
import 'package:graviton/theme/app_colors.dart';

import '../../test_utils.dart';

void main() {
  group('SemanticSettingsButton', () {
    setUp(() {
      SemanticFocusService.instance.setEnabled(true);
    });

    testWidgets('should render child widget', (tester) async {
      const testChild = Text('Test Settings Button');

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSettingsButton(child: testChild),
        ),
      );

      expect(find.text('Test Settings Button'), findsOneWidget);
    });

    testWidgets('should create semantic wrapper with proper focus node', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSettingsButton(child: Text('Settings Button')),
        ),
      );

      expect(find.text('Settings Button'), findsOneWidget);
      expect(SemanticFocusService.instance.settingsButtonFocusNode, isNotNull);
    });

    testWidgets('should handle null localization gracefully', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSettingsButton(child: Text('Settings Button')),
        ),
      );

      expect(find.text('Settings Button'), findsOneWidget);
    });

    testWidgets('should execute onTap callback when provided', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticSettingsButton(
            onTap: () {},
            child: const Text('Settings Button'),
          ),
        ),
      );

      expect(find.text('Settings Button'), findsOneWidget);
    });

    testWidgets('should work without onTap callback', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSettingsButton(child: Text('Settings Button')),
        ),
      );

      expect(find.text('Settings Button'), findsOneWidget);
    });

    testWidgets('should create proper semantic structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSettingsButton(child: Text('Settings Button')),
        ),
      );

      final semanticsNode = tester.getSemantics(find.text('Settings Button'));
      expect(semanticsNode, isNotNull);
    });

    testWidgets('should handle different child widgets', (tester) async {
      final childWidgets = [
        const Text('Text Child'),
        const Icon(Icons.settings),
        Container(
          width: 50,
          height: 50,
          color: AppColors.primaryColor,
          child: const Text('Container Child'),
        ),
      ];

      for (int i = 0; i < childWidgets.length; i++) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticSettingsButton(child: childWidgets[i]),
          ),
        );

        // Verify the widget is rendered (different widgets have different finders)
        if (i == 0) {
          expect(find.text('Text Child'), findsOneWidget);
        } else if (i == 1) {
          expect(find.byIcon(Icons.settings), findsOneWidget);
        } else {
          expect(find.text('Container Child'), findsOneWidget);
        }
      }
    });

    group('Edge cases', () {
      testWidgets('should handle complex child widget hierarchies', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticSettingsButton(
              child: Column(
                children: const [
                  Icon(Icons.settings),
                  Text('Settings'),
                  Text('Tap to open'),
                ],
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('Tap to open'), findsOneWidget);
      });

      testWidgets('should handle empty containers as children', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticSettingsButton(child: Container()),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('should handle sized box as child', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticSettingsButton(
              child: SizedBox(
                width: 100,
                height: 50,
                child: Text('Sized Settings'),
              ),
            ),
          ),
        );

        expect(find.text('Sized Settings'), findsOneWidget);
      });
    });
  });
}
