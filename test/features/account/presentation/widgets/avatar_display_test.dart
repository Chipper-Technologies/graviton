import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/user_avatar.dart';
import 'package:graviton/features/account/presentation/widgets/avatar_display.dart';

import '../../../../test_utils.dart';

void main() {
  group('AvatarDisplay', () {
    testWidgets('displays custom avatar when provided', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(avatar: UserAvatar.sun, size: 96.0),
        ),
      );

      // Should display the emoji
      expect(find.text('☀️'), findsOneWidget);
    });

    testWidgets('displays photo from URL when no custom avatar', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(
            photoUrl: 'https://example.com/photo.jpg',
            size: 96.0,
          ),
        ),
      );

      // Should use a Container
      expect(find.byType(Container), findsWidgets);
    }, skip: true); // NetworkImage makes HTTP requests in test environment

    testWidgets('displays default icon when no avatar or photo', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(child: const AvatarDisplay(size: 96.0)),
      );

      // Should display default account icon
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    testWidgets('prioritizes custom avatar over photo URL', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(
            avatar: UserAvatar.moon,
            photoUrl: 'https://example.com/photo.jpg',
            size: 96.0,
          ),
        ),
      );

      // Should display emoji, not photo
      expect(find.text('🌙'), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsNothing);
    });

    testWidgets('uses correct size for avatar', (tester) async {
      const testSize = 120.0;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(avatar: UserAvatar.star, size: testSize),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, testSize);
      expect(container.constraints?.maxHeight, testSize);
    });

    testWidgets('has circular shape', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(child: const AvatarDisplay(size: 96.0)),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('has border', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(child: const AvatarDisplay(size: 96.0)),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('scales emoji size with avatar size', (tester) async {
      const testSize = 200.0;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(avatar: UserAvatar.saturn, size: testSize),
        ),
      );

      final text = tester.widget<Text>(find.text('♄'));
      // Font size should be half of avatar size
      expect(text.style?.fontSize, testSize * 0.5);
    });

    testWidgets('ignores empty photo URL', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(photoUrl: '', size: 96.0),
        ),
      );

      // Should display default icon, not try to load empty URL
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    testWidgets('works with different avatar types', (tester) async {
      for (final avatar in UserAvatar.values) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: AvatarDisplay(avatar: avatar, size: 96.0),
          ),
        );

        // Should display the emoji for each avatar
        expect(find.text(avatar.emoji), findsOneWidget);
      }
    });

    testWidgets('renders correctly in small size', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(avatar: UserAvatar.comet, size: 32.0),
        ),
      );

      expect(find.text('☄️'), findsOneWidget);
    });

    testWidgets('renders correctly in large size', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const AvatarDisplay(avatar: UserAvatar.galaxy, size: 200.0),
        ),
      );

      expect(find.text('🌌'), findsOneWidget);
    });
  });
}
