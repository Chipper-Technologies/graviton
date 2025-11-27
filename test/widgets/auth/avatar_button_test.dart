import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/auth/avatar_button.dart';
import 'package:provider/provider.dart';

import '../../test_utils.dart';

void main() {
  group('AvatarButton Widget Tests', () {
    late AuthState authState;
    bool onTapCalled = false;

    setUp(() {
      authState = AuthState();
      onTapCalled = false;
    });

    Widget buildTestWidget() {
      return TestUtils.wrapWithMaterialApp(
        child: ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: AvatarButton(
            onTap: () {
              onTapCalled = true;
            },
          ),
        ),
      );
    }

    testWidgets('displays default icon when user is not signed in', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // Should find the default account icon
      expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);

      // Should have faint border
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AvatarButton),
          matching: find.byType(Container).first,
        ),
      );
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.border, isNotNull);
    });

    testWidgets('displays user avatar emoji when set', (
      WidgetTester tester,
    ) async {
      // Create a user with avatar
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          isAnonymous: false,
          avatar: UserAvatar.sun,
          authProvider: AuthProviderType.emailPassword,
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should find the avatar emoji
      expect(find.text(UserAvatar.sun.emoji), findsOneWidget);

      // Should have primary color border for authenticated user
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AvatarButton),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, AppColors.primaryColor);
    });

    testWidgets('displays photo from URL when available', (
      WidgetTester tester,
    ) async {
      // Create a user with photoUrl
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          isAnonymous: false,
          authProvider: AuthProviderType.google,
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should find Image.network widget
      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));

      // Flutter may wrap NetworkImage in ResizeImage for optimization
      final imageProvider = image.image;
      if (imageProvider is ResizeImage) {
        expect(imageProvider.imageProvider, isA<NetworkImage>());
        final networkImage = imageProvider.imageProvider as NetworkImage;
        expect(networkImage.url, 'https://example.com/photo.jpg');
      } else {
        expect(imageProvider, isA<NetworkImage>());
        final networkImage = imageProvider as NetworkImage;
        expect(networkImage.url, 'https://example.com/photo.jpg');
      }
    });

    testWidgets('displays default icon for authenticated user without avatar', (
      WidgetTester tester,
    ) async {
      // Create a user without avatar or photo
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          isAnonymous: false,
          authProvider: AuthProviderType.emailPassword,
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should find the default authenticated icon (filled)
      expect(find.byIcon(Icons.account_circle), findsOneWidget);

      // Should have primary color border
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AvatarButton),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, AppColors.primaryColor);
    });

    testWidgets('calls onTap callback when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      expect(onTapCalled, false);

      // Tap the button
      await tester.tap(find.byType(AvatarButton));
      await tester.pumpAndSettle();

      expect(onTapCalled, true);
    });

    testWidgets('has correct tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find the Tooltip widget
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, isNotEmpty);
    });

    testWidgets('has correct size constraints', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Get the inner container (with tooltip as parent)
      final tooltipFinder = find.byType(Tooltip);
      final innerContainer = find.descendant(
        of: tooltipFinder,
        matching: find.byType(Container),
      );

      final Size size = tester.getSize(innerContainer);
      // Width is 32px, height is 32px + 12px vertical margin (6px top + 6px bottom)
      expect(size.width, 32.0);
      expect(size.height, 44.0); // 32 + 12 for vertical margin
    });

    testWidgets('has correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AvatarButton),
          matching: find.byType(Padding).first,
        ),
      );

      expect(
        padding.padding,
        const EdgeInsets.only(left: AppTypography.spacingLarge),
      );
    });

    testWidgets('prefers avatar emoji over photoUrl', (
      WidgetTester tester,
    ) async {
      // Create a user with both photoUrl and avatar
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          avatar: UserAvatar.sun,
          isAnonymous: false,
          authProvider: AuthProviderType.google,
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should find emoji (custom avatar takes precedence)
      expect(find.text(UserAvatar.sun.emoji), findsOneWidget);

      // Should NOT find the photo
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('handles network image error gracefully', (
      WidgetTester tester,
    ) async {
      // Create a user with invalid photoUrl
      authState.setCurrentUserForTest(
        UserProfile(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoUrl: 'https://invalid.url/photo.jpg',
          isAnonymous: false,
          authProvider: AuthProviderType.google,
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should find Image.network initially
      expect(find.byType(Image), findsOneWidget);

      // Trigger error
      await tester.pump();

      // Should fall back to default icon
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    testWidgets('icon size matches AppTypography constant', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.account_circle_outlined),
      );
      expect(icon.size, AppTypography.iconSizeXLarge);
    });
  });
}
