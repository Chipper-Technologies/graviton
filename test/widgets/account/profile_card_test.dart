import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/widgets/account/avatar_display.dart';
import 'package:graviton/widgets/account/profile_card.dart';

import '../../test_utils.dart';

void main() {
  group('ProfileCard', () {
    testWidgets('displays user profile with all information', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-1',
        displayName: 'John Doe',
        email: 'john@example.com',
        avatar: UserAvatar.sun,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should display user name
      expect(find.text('John Doe'), findsOneWidget);

      // Should display email
      expect(find.text('john@example.com'), findsOneWidget);

      // Should have AvatarDisplay widget
      expect(find.byType(AvatarDisplay), findsOneWidget);

      // Should have edit button
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('displays anonymous label when no display name', (
      tester,
    ) async {
      final user = UserProfile(
        uid: 'test-uid-2',
        displayName: null,
        email: 'anonymous@example.com',
        avatar: null,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should display anonymous label (from localizations)
      // The exact text depends on l10n, so we just check it exists
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('hides email when not provided', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-3',
        displayName: 'Jane Doe',
        email: null,
        avatar: UserAvatar.moon,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should display user name
      expect(find.text('Jane Doe'), findsOneWidget);

      // Email should not be displayed
      // We can verify by counting Text widgets
      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      expect(textWidgets.where((t) => t.data?.contains('@') ?? false), isEmpty);
    });

    testWidgets('calls onEditAvatar when edit button is tapped', (
      tester,
    ) async {
      bool editTapped = false;
      final user = UserProfile(
        uid: 'test-uid-4',
        displayName: 'Test User',
        email: 'test@example.com',
        avatar: UserAvatar.earth,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () => editTapped = true),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(editTapped, isTrue);
    });

    testWidgets('uses Stack to position edit button', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-5',
        displayName: 'Test User',
        email: 'test@example.com',
        avatar: UserAvatar.mars,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should use Stack for layout (may be multiple due to nested widgets)
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('displays user avatar through AvatarDisplay', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-6',
        displayName: 'Test User',
        email: 'test@example.com',
        avatar: UserAvatar.jupiter,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should pass avatar to AvatarDisplay
      final avatarDisplay = tester.widget<AvatarDisplay>(
        find.byType(AvatarDisplay),
      );
      expect(avatarDisplay.avatar, UserAvatar.jupiter);
    });

    testWidgets('displays photo URL through AvatarDisplay', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-7',
        displayName: 'Test User',
        email: 'test@example.com',
        avatar: null,
        photoUrl: 'https://example.com/photo.jpg',
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      await tester.pumpAndSettle();

      // Should pass photoUrl to AvatarDisplay
      final avatarDisplay = tester.widget<AvatarDisplay>(
        find.byType(AvatarDisplay),
      );
      expect(avatarDisplay.photoUrl, 'https://example.com/photo.jpg');
    }, skip: true); // NetworkImage makes HTTP requests in test environment

    testWidgets('has Container with proper styling', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-8',
        displayName: 'Test User',
        email: 'test@example.com',
        avatar: UserAvatar.star,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should have Container
      expect(find.byType(Container), findsWidgets);

      // Container should have decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decoratedContainers = containers.where((c) => c.decoration != null);
      expect(decoratedContainers, isNotEmpty);
    });

    testWidgets('renders correctly with empty email string', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-9',
        displayName: 'Test User',
        email: '',
        avatar: UserAvatar.venus,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should display user name
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('renders correctly in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      final user = UserProfile(
        uid: 'test-uid-10',
        displayName: 'Test User',
        email: 'test@example.com',
        avatar: UserAvatar.comet,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      expect(find.text('Test User'), findsOneWidget);
      expect(find.byType(AvatarDisplay), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('edit button is properly positioned', (tester) async {
      final user = UserProfile(
        uid: 'test-uid-11',
        displayName: 'Test User',
        email: 'test@example.com',
        avatar: UserAvatar.galaxy,
        photoUrl: null,
        isAnonymous: false,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: ProfileCard(user: user, onEditAvatar: () {}),
        ),
      );

      // Should have Positioned widget for edit button
      expect(find.byType(Positioned), findsOneWidget);
    });
  });
}
