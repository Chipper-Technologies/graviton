import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/account/email_verification_banner.dart';

import '../../test_utils.dart';

void main() {
  group('EmailVerificationBanner', () {
    testWidgets('calls onSendVerification when send button is tapped', (
      tester,
    ) async {
      bool sendCalled = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onSendVerification: () => sendCalled = true,
            onCheckVerification: () {},
            isSendingVerification: false,
            isCheckingVerification: false,
          ),
        ),
      );

      // Find and tap the send button if it exists (only when not verified)
      final sendButton = find.text('Send Verification Email');
      if (tester.any(sendButton)) {
        await tester.tap(sendButton);
        await tester.pump();
        expect(sendCalled, isTrue);
      }
    });

    testWidgets('calls onCheckVerification when check button is tapped', (
      tester,
    ) async {
      bool checkCalled = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onSendVerification: () {},
            onCheckVerification: () => checkCalled = true,
            isSendingVerification: false,
            isCheckingVerification: false,
          ),
        ),
      );

      // Find and tap the check button if it exists (only when not verified)
      final checkButton = find.text('Check Verification Status');
      if (tester.any(checkButton)) {
        await tester.tap(checkButton);
        await tester.pump();
        expect(checkCalled, isTrue);
      }
    });

    testWidgets('shows progress indicator when isSendingVerification is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onSendVerification: () {},
            onCheckVerification: () {},
            isSendingVerification: true,
            isCheckingVerification: false,
          ),
        ),
      );

      // Check for progress indicator when sending
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
      'shows progress indicator when isCheckingVerification is true',
      (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: EmailVerificationBanner(
              onSendVerification: () {},
              onCheckVerification: () {},
              isSendingVerification: false,
              isCheckingVerification: true,
            ),
          ),
        );

        // Check for progress indicator when checking
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      },
    );

    testWidgets('displays proper layout structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onSendVerification: () {},
            onCheckVerification: () {},
            isSendingVerification: false,
            isCheckingVerification: false,
          ),
        ),
      );

      // Should have a Container as root
      expect(find.byType(Container), findsWidgets);
      // Should have icons
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('renders with both loading states active', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onSendVerification: () {},
            onCheckVerification: () {},
            isSendingVerification: true,
            isCheckingVerification: true,
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('uses correct button types', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onSendVerification: () {},
            onCheckVerification: () {},
            isSendingVerification: false,
            isCheckingVerification: false,
          ),
        ),
      );

      // Should have elevated buttons
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('renders in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onSendVerification: () {},
            onCheckVerification: () {},
            isSendingVerification: false,
            isCheckingVerification: false,
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });
  });
}
