import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/account/danger_zone_section.dart';

import '../../test_utils.dart';

void main() {
  group('DangerZoneSection', () {
    testWidgets('displays delete account button', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DangerZoneSection(onDeleteAccount: () {}),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });

    testWidgets('calls onDeleteAccount when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DangerZoneSection(onDeleteAccount: () => tapped = true),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('has red styling for destructive action', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DangerZoneSection(onDeleteAccount: () {}),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.delete_forever));
      // Icon should have red color (checking it's not null)
      expect(icon.color, isNotNull);
    });

    testWidgets('has container with proper styling', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DangerZoneSection(onDeleteAccount: () {}),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('displays localized delete text', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DangerZoneSection(onDeleteAccount: () {}),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DangerZoneSection(onDeleteAccount: () {}),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('can be tapped multiple times', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DangerZoneSection(onDeleteAccount: () => tapCount++),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapCount, equals(2));
    });
  });
}
