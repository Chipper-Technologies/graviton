import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/account/terms_acceptance_checkbox.dart';

import '../../test_utils.dart';

void main() {
  group('TermsAcceptanceCheckbox', () {
    testWidgets('displays checkbox and text correctly', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(isAccepted: false, onChanged: (_) {}),
        ),
      );

      // Should have a checkbox
      expect(find.byType(Checkbox), findsOneWidget);

      // Should have text buttons for terms and privacy (localized)
      expect(find.byType(TextButton), findsNWidgets(2));
    });

    testWidgets('checkbox reflects isAccepted state', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(isAccepted: true, onChanged: (_) {}),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('calls onChanged when checkbox is tapped', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(
            isAccepted: false,
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(changedValue, isTrue);
    });

    testWidgets('calls onTermsTapped when Terms of Service is tapped', (
      tester,
    ) async {
      bool termsTapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(
            isAccepted: false,
            onChanged: (_) {},
            onTermsTapped: () => termsTapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Terms of Service'));
      await tester.pump();

      expect(termsTapped, isTrue);
    });

    testWidgets('calls onPrivacyTapped when Privacy Policy is tapped', (
      tester,
    ) async {
      bool privacyTapped = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(
            isAccepted: false,
            onChanged: (_) {},
            onPrivacyTapped: () => privacyTapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();

      expect(privacyTapped, isTrue);
    });

    testWidgets('handles null callbacks gracefully', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(isAccepted: false, onChanged: (_) {}),
        ),
      );

      // Should not throw when tapping links with null callbacks
      await tester.tap(find.text('Terms of Service'));
      await tester.pump();

      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();

      expect(find.byType(TermsAcceptanceCheckbox), findsOneWidget);
    });

    testWidgets('uses Row layout for checkbox and text', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(isAccepted: false, onChanged: (_) {}),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('text is expandable to handle different screen sizes', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(isAccepted: false, onChanged: (_) {}),
        ),
      );

      // Should have Expanded widget for text
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('renders correctly in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: TermsAcceptanceCheckbox(isAccepted: false, onChanged: (_) {}),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('toggles checkbox state correctly', (tester) async {
      bool currentValue = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return TermsAcceptanceCheckbox(
                isAccepted: currentValue,
                onChanged: (value) {
                  setState(() => currentValue = value);
                },
              );
            },
          ),
        ),
      );

      // Initially unchecked
      expect(currentValue, isFalse);

      // Tap to check
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Now should be checked
      expect(currentValue, isTrue);
    });
  });
}
