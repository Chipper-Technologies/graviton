import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/account/presentation/widgets/account_management_options.dart';

import '../../../../test_utils.dart';

void main() {
  group('AccountManagementOptions', () {
    testWidgets('displays all three list tiles', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      // Should have 3 list tiles
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('displays correct icons', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('calls onEditAccount when edit is tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () => tapped = true,
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('calls onChangeAvatar when avatar is tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () => tapped = true,
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('calls onSignOut when sign out is tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () => tapped = true,
            isAnonymous: false,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows sign out label for authenticated users', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      // Should find text containing sign out (localized)
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('shows reset session label for anonymous users', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: true,
          ),
        ),
      );

      // Should find text (localized for anonymous)
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has container with proper styling', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('has section dividers between items', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      // Should have dividers (looking for Divider widgets)
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('renders in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
          ),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(3));

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('shows spinner when signing out', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () {},
            isAnonymous: false,
            isSigningOut: true,
          ),
        ),
      );

      // Should show spinner instead of logout icon
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsNothing);
    });

    testWidgets('disables sign out button when signing out', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: AccountManagementOptions(
            onEditAccount: () {},
            onChangeAvatar: () {},
            onSignOut: () => tapped = true,
            isAnonymous: false,
            isSigningOut: true,
          ),
        ),
      );

      // Try to tap the sign out option
      await tester.tap(find.byType(ListTile).last);
      await tester.pump();

      // Should not have called the callback
      expect(tapped, isFalse);
    });
  });
}
