import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/account/presentation/widgets/email_verification_banner.dart';

import '../../../../test_utils.dart';

void main() {
  group('EmailVerificationBanner', () {
    testWidgets('calls onResendVerification when resend button is tapped', (
      tester,
    ) async {
      bool resendCalled = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onResendVerification: () => resendCalled = true,
            isSendingVerification: false,
          ),
        ),
      );

      // Find and tap the resend button
      final resendButton = find.text('Resend Verification Email');
      expect(resendButton, findsOneWidget);
      await tester.tap(resendButton);
      await tester.pump();
      expect(resendCalled, isTrue);
    });

    testWidgets('shows progress indicator when isSendingVerification is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onResendVerification: () {},
            isSendingVerification: true,
          ),
        ),
      );

      // Check for progress indicator when sending
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays proper layout structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onResendVerification: () {},
            isSendingVerification: false,
          ),
        ),
      );

      // Should have a Container as root
      expect(find.byType(Container), findsWidgets);
      // Should have icons
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('uses correct button type', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onResendVerification: () {},
            isSendingVerification: false,
          ),
        ),
      );

      // Should have one elevated button
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EmailVerificationBanner(
            onResendVerification: () {},
            isSendingVerification: false,
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });
  });
}
