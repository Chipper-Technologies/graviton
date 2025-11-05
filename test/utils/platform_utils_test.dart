import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/constants/rendering_constants.dart';

void main() {
  group('PlatformUtils Tests', () {
    group('Platform Detection', () {
      test('isAndroid should return boolean without throwing', () {
        expect(() => PlatformUtils.isAndroid, returnsNormally);
        expect(PlatformUtils.isAndroid, isA<bool>());
      });

      test('isIOS should return boolean without throwing', () {
        expect(() => PlatformUtils.isIOS, returnsNormally);
        expect(PlatformUtils.isIOS, isA<bool>());
      });

      test('isMobile should return boolean without throwing', () {
        expect(() => PlatformUtils.isMobile, returnsNormally);
        expect(PlatformUtils.isMobile, isA<bool>());
      });

      test('isDesktop should return boolean without throwing', () {
        expect(() => PlatformUtils.isDesktop, returnsNormally);
        expect(PlatformUtils.isDesktop, isA<bool>());
      });

      test('isWeb should return boolean without throwing', () {
        expect(() => PlatformUtils.isWeb, returnsNormally);
        expect(PlatformUtils.isWeb, isA<bool>());
      });

      test(
        'platform detection should be mutually exclusive for mobile vs desktop vs web',
        () {
          final platformChecks = [
            PlatformUtils.isMobile,
            PlatformUtils.isDesktop,
            PlatformUtils.isWeb,
          ];

          // At least one should be true
          expect(platformChecks.any((check) => check), isTrue);

          // At most one should be true (mutually exclusive)
          expect(
            platformChecks.where((check) => check).length,
            lessThanOrEqualTo(1),
          );
        },
      );

      test('Android and iOS should be mutually exclusive', () {
        // Both can't be true at the same time
        expect(PlatformUtils.isAndroid && PlatformUtils.isIOS, isFalse);
      });

      test('isMobile should be true if Android or iOS is true', () {
        if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
          expect(PlatformUtils.isMobile, isTrue);
        }
      });
    });

    group('Bottom Sheet System Bar Padding', () {
      test(
        'getBottomSheetSystemBarPadding should return valid non-negative number',
        () {
          final padding = PlatformUtils.getBottomSheetSystemBarPadding();
          expect(padding, isA<double>());
          expect(padding, greaterThanOrEqualTo(0.0));
        },
      );

      test(
        'getBottomSheetSystemBarPadding should return RenderingConstants value for appropriate platforms',
        () {
          final padding = PlatformUtils.getBottomSheetSystemBarPadding();

          // Should either be 0.0 or the constant value
          expect(
            padding == 0.0 ||
                padding == RenderingConstants.bottomSheetSystemBarPadding,
            isTrue,
          );
        },
      );

      test(
        'getBottomSheetSystemBarPadding should be consistent across multiple calls',
        () {
          final padding1 = PlatformUtils.getBottomSheetSystemBarPadding();
          final padding2 = PlatformUtils.getBottomSheetSystemBarPadding();

          expect(padding1, equals(padding2));
        },
      );

      test(
        'getBottomSheetSystemBarPadding should return 0 for web platform',
        () {
          if (PlatformUtils.isWeb) {
            expect(PlatformUtils.getBottomSheetSystemBarPadding(), equals(0.0));
          }
        },
      );

      test(
        'getBottomSheetSystemBarPadding should use rendering constant when non-zero',
        () {
          final padding = PlatformUtils.getBottomSheetSystemBarPadding();

          if (padding > 0.0) {
            expect(
              padding,
              equals(RenderingConstants.bottomSheetSystemBarPadding),
            );
          }
        },
      );
    });

    group('Platform Utility Edge Cases', () {
      test('all platform detection methods should handle repeated calls', () {
        // Call each method multiple times to ensure stability
        for (int i = 0; i < 5; i++) {
          expect(() => PlatformUtils.isAndroid, returnsNormally);
          expect(() => PlatformUtils.isIOS, returnsNormally);
          expect(() => PlatformUtils.isMobile, returnsNormally);
          expect(() => PlatformUtils.isDesktop, returnsNormally);
          expect(() => PlatformUtils.isWeb, returnsNormally);
        }
      });

      test(
        'PlatformUtils should be a utility class with only static methods',
        () {
          // This test verifies the class is designed as a utility class
          // by ensuring we can call static methods without instantiation
          expect(() => PlatformUtils.isAndroid, returnsNormally);
          expect(
            () => PlatformUtils.getBottomSheetSystemBarPadding(),
            returnsNormally,
          );
        },
      );
    });
  });
}
