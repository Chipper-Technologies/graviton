import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/platform_utils.dart';

void main() {
  group('PlatformUtils', () {
    group('Basic Platform Detection', () {
      test('platform detection getters return boolean values', () {
        // These just verify they return without errors and return bools
        expect(PlatformUtils.isAndroid, isA<bool>());
        expect(PlatformUtils.isIOS, isA<bool>());
        expect(PlatformUtils.isMacOS, isA<bool>());
        expect(PlatformUtils.isWindows, isA<bool>());
        expect(PlatformUtils.isLinux, isA<bool>());
        expect(PlatformUtils.isWeb, isA<bool>());
      });

      test('isWeb matches kIsWeb', () {
        expect(PlatformUtils.isWeb, equals(kIsWeb));
      });

      test('only one mobile platform can be true', () {
        final mobileCount = [
          PlatformUtils.isAndroid,
          PlatformUtils.isIOS,
        ].where((p) => p).length;

        // Either 0 (desktop/web) or 1 (mobile)
        expect(mobileCount, lessThanOrEqualTo(1));
      });

      test('only one desktop platform can be true', () {
        final desktopCount = [
          PlatformUtils.isMacOS,
          PlatformUtils.isWindows,
          PlatformUtils.isLinux,
        ].where((p) => p).length;

        // Either 0 (mobile/web) or 1 (desktop)
        expect(desktopCount, lessThanOrEqualTo(1));
      });
    });

    group('Platform Categories', () {
      test('isMobile is true only for Android or iOS', () {
        if (PlatformUtils.isMobile) {
          expect(
            PlatformUtils.isAndroid || PlatformUtils.isIOS,
            isTrue,
            reason: 'isMobile should only be true for Android or iOS',
          );
        }
      });

      test('isDesktop is true only for Windows, macOS, or Linux', () {
        if (PlatformUtils.isDesktop) {
          expect(
            PlatformUtils.isWindows ||
                PlatformUtils.isMacOS ||
                PlatformUtils.isLinux,
            isTrue,
            reason: 'isDesktop should only be true for desktop platforms',
          );
        }
      });

      test('isApple is true only for iOS or macOS', () {
        if (PlatformUtils.isApple) {
          expect(
            PlatformUtils.isIOS || PlatformUtils.isMacOS,
            isTrue,
            reason: 'isApple should only be true for iOS or macOS',
          );
        }
      });

      test('mobile and desktop are mutually exclusive', () {
        if (PlatformUtils.isMobile) {
          expect(PlatformUtils.isDesktop, isFalse);
        }
        if (PlatformUtils.isDesktop) {
          expect(PlatformUtils.isMobile, isFalse);
        }
      });

      test('web is separate from mobile/desktop', () {
        // Web can coexist with platform checks being false
        if (PlatformUtils.isWeb) {
          // On web, native platform checks should be false
          expect(PlatformUtils.isMobile, isFalse);
          expect(PlatformUtils.isDesktop, isFalse);
        }
      });
    });

    group('Platform Capabilities', () {
      test('supportsHover is true for desktop and web', () {
        expect(
          PlatformUtils.supportsHover,
          equals(PlatformUtils.isDesktop || PlatformUtils.isWeb),
        );
      });

      test('supportsHaptics is true for mobile', () {
        expect(PlatformUtils.supportsHaptics, equals(PlatformUtils.isMobile));
      });

      test('supportsCustomCursors is true for desktop and web', () {
        expect(
          PlatformUtils.supportsCustomCursors,
          equals(PlatformUtils.isDesktop || PlatformUtils.isWeb),
        );
      });

      test('hasPhysicalKeyboard is true for desktop', () {
        expect(
          PlatformUtils.hasPhysicalKeyboard,
          equals(PlatformUtils.isDesktop),
        );
      });

      test('supportsWindowManagement is true for desktop', () {
        expect(
          PlatformUtils.supportsWindowManagement,
          equals(PlatformUtils.isDesktop),
        );
      });

      test('supportsFileSystem is false only on web', () {
        expect(PlatformUtils.supportsFileSystem, equals(!PlatformUtils.isWeb));
      });

      test('hover and haptics are typically mutually exclusive', () {
        // If we support hover, we typically don't support haptics and vice versa
        if (PlatformUtils.supportsHover && !PlatformUtils.isWeb) {
          expect(PlatformUtils.supportsHaptics, isFalse);
        }
        if (PlatformUtils.supportsHaptics) {
          expect(PlatformUtils.supportsHover, isFalse);
        }
      });
    });

    group('UI Behavior Helpers', () {
      test('shouldShowTooltips matches supportsHover', () {
        expect(
          PlatformUtils.shouldShowTooltips,
          equals(PlatformUtils.supportsHover),
        );
      });

      test('shouldAutoHideCursor is true for desktop', () {
        expect(
          PlatformUtils.shouldAutoHideCursor,
          equals(PlatformUtils.isDesktop),
        );
      });

      test('usesSystemNavigationBar is true for Android', () {
        expect(
          PlatformUtils.usesSystemNavigationBar,
          equals(PlatformUtils.isAndroid),
        );
      });

      test('usesNativeTitleBar is true for desktop', () {
        expect(
          PlatformUtils.usesNativeTitleBar,
          equals(PlatformUtils.isDesktop),
        );
      });

      test('shouldUseCompactUI is true for desktop', () {
        expect(
          PlatformUtils.shouldUseCompactUI,
          equals(PlatformUtils.isDesktop),
        );
      });

      test('shouldShowScrollbars is true for desktop', () {
        expect(
          PlatformUtils.shouldShowScrollbars,
          equals(PlatformUtils.isDesktop),
        );
      });
    });

    group('Platform-Specific Values', () {
      test('getBottomSheetSystemBarPadding returns non-negative value', () {
        final padding = PlatformUtils.getBottomSheetSystemBarPadding();
        expect(padding, greaterThanOrEqualTo(0.0));
      });

      test('getBottomSheetSystemBarPadding is positive only on Android', () {
        final padding = PlatformUtils.getBottomSheetSystemBarPadding();
        if (PlatformUtils.isAndroid) {
          expect(padding, greaterThan(0.0));
        } else {
          expect(padding, equals(0.0));
        }
      });

      test('getMinimumTouchTargetSize returns reasonable values', () {
        final size = PlatformUtils.getMinimumTouchTargetSize();
        expect(size, greaterThan(0.0));
        expect(size, lessThan(100.0)); // Sanity check

        // Verify platform-specific sizing
        if (PlatformUtils.isMobile) {
          expect(size, equals(48.0));
        } else if (PlatformUtils.isDesktop) {
          expect(size, equals(32.0));
        } else {
          expect(size, equals(44.0)); // Web
        }
      });

      test('getIconSize returns reasonable values', () {
        final size = PlatformUtils.getIconSize();
        expect(size, greaterThan(0.0));
        expect(size, lessThan(50.0)); // Sanity check

        // Verify platform-specific sizing
        if (PlatformUtils.isMobile) {
          expect(size, equals(24.0));
        } else if (PlatformUtils.isDesktop) {
          expect(size, equals(20.0));
        } else {
          expect(size, equals(22.0)); // Web
        }
      });

      test('getAnimationDurationMultiplier returns reasonable values', () {
        final multiplier = PlatformUtils.getAnimationDurationMultiplier();
        expect(multiplier, greaterThan(0.0));
        expect(multiplier, lessThanOrEqualTo(2.0)); // Sanity check

        // Verify platform-specific multipliers
        if (PlatformUtils.isMobile) {
          expect(multiplier, equals(1.0));
        } else if (PlatformUtils.isDesktop) {
          expect(multiplier, equals(0.8));
        } else {
          expect(multiplier, equals(0.9)); // Web
        }
      });

      test('touch target size is larger on mobile than desktop', () {
        // This is a design principle test
        if (PlatformUtils.isMobile && !PlatformUtils.isWeb) {
          expect(
            PlatformUtils.getMinimumTouchTargetSize(),
            greaterThan(32.0),
            reason: 'Mobile touch targets should be larger than desktop',
          );
        }
      });
    });

    group('Debug Utilities', () {
      test('platformName returns non-empty string', () {
        expect(PlatformUtils.platformName, isNotEmpty);
      });

      test('platformName is one of known platforms', () {
        const knownPlatforms = [
          'Web',
          'Android',
          'iOS',
          'macOS',
          'Windows',
          'Linux',
          'Unknown',
        ];
        expect(knownPlatforms, contains(PlatformUtils.platformName));
      });

      test('osVersion returns string', () {
        expect(PlatformUtils.osVersion, isA<String>());
      });

      test('osVersion is empty on web', () {
        if (PlatformUtils.isWeb) {
          expect(PlatformUtils.osVersion, isEmpty);
        }
      });

      test('osVersion is non-empty on native platforms', () {
        if (!PlatformUtils.isWeb) {
          expect(PlatformUtils.osVersion, isNotEmpty);
        }
      });

      test('capabilitiesDescription returns string', () {
        expect(PlatformUtils.capabilitiesDescription, isA<String>());
      });

      test('capabilitiesDescription contains known capabilities', () {
        final description = PlatformUtils.capabilitiesDescription;
        const knownCapabilities = [
          'hover',
          'haptics',
          'cursors',
          'keyboard',
          'windows',
          'files',
        ];

        // Parse the comma-separated capabilities
        final capabilities = description.split(', ');

        // Every capability should be known
        for (final cap in capabilities) {
          if (cap.isNotEmpty) {
            expect(
              knownCapabilities,
              contains(cap),
              reason: 'Unknown capability: $cap',
            );
          }
        }
      });

      test('capabilitiesDescription matches actual capabilities', () {
        final description = PlatformUtils.capabilitiesDescription;

        if (PlatformUtils.supportsHover) {
          expect(description, contains('hover'));
        }
        if (PlatformUtils.supportsHaptics) {
          expect(description, contains('haptics'));
        }
        if (PlatformUtils.supportsCustomCursors) {
          expect(description, contains('cursors'));
        }
        if (PlatformUtils.hasPhysicalKeyboard) {
          expect(description, contains('keyboard'));
        }
        if (PlatformUtils.supportsWindowManagement) {
          expect(description, contains('windows'));
        }
        if (PlatformUtils.supportsFileSystem) {
          expect(description, contains('files'));
        }
      });
    });

    group('Edge Cases', () {
      test('all getters can be called multiple times', () {
        // Verify no state changes or errors on repeated calls
        for (var i = 0; i < 3; i++) {
          expect(PlatformUtils.isAndroid, equals(PlatformUtils.isAndroid));
          expect(PlatformUtils.isIOS, equals(PlatformUtils.isIOS));
          expect(PlatformUtils.isMobile, equals(PlatformUtils.isMobile));
          expect(PlatformUtils.isDesktop, equals(PlatformUtils.isDesktop));
          expect(
            PlatformUtils.supportsHover,
            equals(PlatformUtils.supportsHover),
          );
        }
      });

      test('all methods can be called multiple times', () {
        // Verify no state changes or errors on repeated calls
        for (var i = 0; i < 3; i++) {
          expect(
            PlatformUtils.getBottomSheetSystemBarPadding(),
            equals(PlatformUtils.getBottomSheetSystemBarPadding()),
          );
          expect(
            PlatformUtils.getMinimumTouchTargetSize(),
            equals(PlatformUtils.getMinimumTouchTargetSize()),
          );
          expect(
            PlatformUtils.getIconSize(),
            equals(PlatformUtils.getIconSize()),
          );
          expect(
            PlatformUtils.getAnimationDurationMultiplier(),
            equals(PlatformUtils.getAnimationDurationMultiplier()),
          );
          expect(
            PlatformUtils.platformName,
            equals(PlatformUtils.platformName),
          );
          expect(PlatformUtils.osVersion, equals(PlatformUtils.osVersion));
          expect(
            PlatformUtils.capabilitiesDescription,
            equals(PlatformUtils.capabilitiesDescription),
          );
        }
      });

      test('platform detection is internally consistent', () {
        // Verify logical consistency between platform checks
        final platformCount = [
          PlatformUtils.isAndroid,
          PlatformUtils.isIOS,
          PlatformUtils.isMacOS,
          PlatformUtils.isWindows,
          PlatformUtils.isLinux,
        ].where((p) => p).length;

        if (!PlatformUtils.isWeb) {
          // Should be exactly one native platform
          expect(
            platformCount,
            equals(1),
            reason: 'Exactly one native platform should be detected',
          );
        } else {
          // On web, no native platforms
          expect(
            platformCount,
            equals(0),
            reason: 'Web should not detect native platforms',
          );
        }
      });
    });

    group('Integration Tests', () {
      test('platform capabilities align with platform type', () {
        if (PlatformUtils.isMobile) {
          expect(PlatformUtils.supportsHaptics, isTrue);
          expect(PlatformUtils.hasPhysicalKeyboard, isFalse);
          expect(PlatformUtils.supportsWindowManagement, isFalse);
        }

        if (PlatformUtils.isDesktop) {
          expect(PlatformUtils.supportsHover, isTrue);
          expect(PlatformUtils.supportsCustomCursors, isTrue);
          expect(PlatformUtils.hasPhysicalKeyboard, isTrue);
          expect(PlatformUtils.supportsWindowManagement, isTrue);
          expect(PlatformUtils.supportsHaptics, isFalse);
        }

        if (PlatformUtils.isWeb) {
          expect(PlatformUtils.supportsHover, isTrue);
          expect(PlatformUtils.supportsCustomCursors, isTrue);
          expect(PlatformUtils.supportsFileSystem, isFalse);
          expect(PlatformUtils.osVersion, isEmpty);
        }
      });

      test('UI behavior helpers align with capabilities', () {
        expect(
          PlatformUtils.shouldShowTooltips,
          equals(PlatformUtils.supportsHover),
        );
        expect(
          PlatformUtils.shouldAutoHideCursor,
          equals(PlatformUtils.isDesktop),
        );
        expect(
          PlatformUtils.usesNativeTitleBar,
          equals(PlatformUtils.isDesktop),
        );
        expect(
          PlatformUtils.shouldUseCompactUI,
          equals(PlatformUtils.isDesktop),
        );
        expect(
          PlatformUtils.shouldShowScrollbars,
          equals(PlatformUtils.isDesktop),
        );
      });

      test('platform-specific values are consistent', () {
        // Mobile should have larger touch targets
        // Desktop should have faster animations
        // These are design principles

        if (PlatformUtils.isMobile) {
          expect(
            PlatformUtils.getMinimumTouchTargetSize(),
            greaterThanOrEqualTo(44.0),
          );
          expect(PlatformUtils.getAnimationDurationMultiplier(), equals(1.0));
        }

        if (PlatformUtils.isDesktop) {
          expect(PlatformUtils.getMinimumTouchTargetSize(), lessThan(48.0));
          expect(PlatformUtils.getAnimationDurationMultiplier(), lessThan(1.0));
        }
      });
    });
  });
}
