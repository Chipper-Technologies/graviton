import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

void main() {
  group('AppTypography Tests', () {
    group('Font Size Constants', () {
      test('should have correct font size values', () {
        // Test all font sizes are positive doubles
        expect(AppTypography.fontSizeXSmall, equals(10.0));
        expect(AppTypography.fontSizeXXSmall, equals(11.0));
        expect(AppTypography.fontSizeSmall, equals(12.0));
        expect(AppTypography.fontSizeMedium, equals(14.0));
        expect(AppTypography.fontSizeLarge, equals(16.0));
        expect(AppTypography.fontSizeXLarge, equals(18.0));
        expect(AppTypography.fontSizeXXLarge, equals(20.0));
        expect(AppTypography.fontSizeTitle, equals(24.0));
        expect(AppTypography.fontSizeHeader, equals(28.0));
      });

      test('font sizes should be in ascending order', () {
        // Ensure logical progression from smallest to largest
        expect(
          AppTypography.fontSizeXSmall,
          lessThan(AppTypography.fontSizeXXSmall),
        );
        expect(
          AppTypography.fontSizeXXSmall,
          lessThan(AppTypography.fontSizeSmall),
        );
        expect(
          AppTypography.fontSizeSmall,
          lessThan(AppTypography.fontSizeMedium),
        );
        expect(
          AppTypography.fontSizeMedium,
          lessThan(AppTypography.fontSizeLarge),
        );
        expect(
          AppTypography.fontSizeLarge,
          lessThan(AppTypography.fontSizeXLarge),
        );
        expect(
          AppTypography.fontSizeXLarge,
          lessThan(AppTypography.fontSizeXXLarge),
        );
        expect(
          AppTypography.fontSizeXXLarge,
          lessThan(AppTypography.fontSizeTitle),
        );
        expect(
          AppTypography.fontSizeTitle,
          lessThan(AppTypography.fontSizeHeader),
        );
      });

      test('all font sizes should be positive', () {
        // Verify no negative or zero font sizes
        expect(AppTypography.fontSizeXSmall, greaterThan(0.0));
        expect(AppTypography.fontSizeXXSmall, greaterThan(0.0));
        expect(AppTypography.fontSizeSmall, greaterThan(0.0));
        expect(AppTypography.fontSizeMedium, greaterThan(0.0));
        expect(AppTypography.fontSizeLarge, greaterThan(0.0));
        expect(AppTypography.fontSizeXLarge, greaterThan(0.0));
        expect(AppTypography.fontSizeXXLarge, greaterThan(0.0));
        expect(AppTypography.fontSizeTitle, greaterThan(0.0));
        expect(AppTypography.fontSizeHeader, greaterThan(0.0));
      });
    });

    group('Opacity Value Constants', () {
      test('should have correct opacity values within valid range', () {
        // Basic opacity values
        expect(AppTypography.opacityBarely, equals(0.05));
        expect(AppTypography.opacityDisabled, equals(0.1));
        expect(AppTypography.opacityVeryFaint, equals(0.2));
        expect(AppTypography.opacityFaint, equals(0.3));
        expect(AppTypography.opacitySemiTransparent, equals(0.4));
        expect(AppTypography.opacityMedium, equals(0.5));
        expect(AppTypography.opacityMediumHigh, equals(0.6));
        expect(AppTypography.opacityHigh, equals(0.7));
        expect(AppTypography.opacityVeryHigh, equals(0.8));
        expect(AppTypography.opacityNearlyOpaque, equals(0.9));
        expect(AppTypography.opacityFull, equals(1.0));

        // Specialized opacity values
        expect(AppTypography.opacitySubtle, equals(0.1));
        expect(AppTypography.opacityMidFade, equals(0.15));
        expect(AppTypography.opacityLowMedium, equals(0.25));
        expect(AppTypography.opacityAlmostOpaque, equals(0.95));
        expect(AppTypography.opacityTransparent, equals(0.0));
      });

      test('all opacity values should be within valid range 0.0 to 1.0', () {
        final opacityValues = [
          AppTypography.opacityBarely,
          AppTypography.opacityDisabled,
          AppTypography.opacityVeryFaint,
          AppTypography.opacityFaint,
          AppTypography.opacitySemiTransparent,
          AppTypography.opacityMedium,
          AppTypography.opacityMediumHigh,
          AppTypography.opacityHigh,
          AppTypography.opacityVeryHigh,
          AppTypography.opacityNearlyOpaque,
          AppTypography.opacityFull,
          AppTypography.opacitySubtle,
          AppTypography.opacityMidFade,
          AppTypography.opacityLowMedium,
          AppTypography.opacityAlmostOpaque,
          AppTypography.opacityTransparent,
        ];

        for (final opacity in opacityValues) {
          expect(
            opacity,
            greaterThanOrEqualTo(0.0),
            reason: 'Opacity $opacity must be >= 0.0',
          );
          expect(
            opacity,
            lessThanOrEqualTo(1.0),
            reason: 'Opacity $opacity must be <= 1.0',
          );
        }
      });

      test('opacity values should be in logical ascending order', () {
        // Test basic progression makes sense
        expect(AppTypography.opacityTransparent, equals(0.0));
        expect(
          AppTypography.opacityBarely,
          greaterThan(AppTypography.opacityTransparent),
        );
        expect(
          AppTypography.opacityDisabled,
          greaterThan(AppTypography.opacityBarely),
        );
        expect(
          AppTypography.opacityVeryFaint,
          greaterThan(AppTypography.opacityDisabled),
        );
        expect(
          AppTypography.opacityFaint,
          greaterThan(AppTypography.opacityVeryFaint),
        );
        expect(
          AppTypography.opacitySemiTransparent,
          greaterThan(AppTypography.opacityFaint),
        );
        expect(
          AppTypography.opacityMedium,
          greaterThan(AppTypography.opacitySemiTransparent),
        );
        expect(
          AppTypography.opacityMediumHigh,
          greaterThan(AppTypography.opacityMedium),
        );
        expect(
          AppTypography.opacityHigh,
          greaterThan(AppTypography.opacityMediumHigh),
        );
        expect(
          AppTypography.opacityVeryHigh,
          greaterThan(AppTypography.opacityHigh),
        );
        expect(
          AppTypography.opacityNearlyOpaque,
          greaterThan(AppTypography.opacityVeryHigh),
        );
        expect(AppTypography.opacityFull, equals(1.0));
      });
    });

    group('Icon Size Constants', () {
      test('should have correct icon size values', () {
        expect(AppTypography.iconSizeSmall, equals(14.0));
        expect(AppTypography.iconSizeMedium, equals(16.0));
        expect(AppTypography.iconSizeLarge, equals(18.0));
        expect(AppTypography.iconSizeXLarge, equals(20.0));
        expect(AppTypography.iconSizeXXLarge, equals(24.0));
        expect(AppTypography.iconSizeXXXLarge, equals(28.0));
        expect(AppTypography.iconSizeXXXXLarge, equals(48.0));
        expect(AppTypography.iconSizeHuge, equals(64.0));
      });

      test('icon sizes should be in ascending order', () {
        expect(
          AppTypography.iconSizeSmall,
          lessThan(AppTypography.iconSizeMedium),
        );
        expect(
          AppTypography.iconSizeMedium,
          lessThan(AppTypography.iconSizeLarge),
        );
        expect(
          AppTypography.iconSizeLarge,
          lessThan(AppTypography.iconSizeXLarge),
        );
        expect(
          AppTypography.iconSizeXLarge,
          lessThan(AppTypography.iconSizeXXLarge),
        );
        expect(
          AppTypography.iconSizeXXLarge,
          lessThan(AppTypography.iconSizeXXXLarge),
        );
        expect(
          AppTypography.iconSizeXXXLarge,
          lessThan(AppTypography.iconSizeXXXXLarge),
        );
        expect(
          AppTypography.iconSizeXXXXLarge,
          lessThan(AppTypography.iconSizeHuge),
        );
      });

      test('all icon sizes should be positive', () {
        expect(AppTypography.iconSizeSmall, greaterThan(0.0));
        expect(AppTypography.iconSizeMedium, greaterThan(0.0));
        expect(AppTypography.iconSizeLarge, greaterThan(0.0));
        expect(AppTypography.iconSizeXLarge, greaterThan(0.0));
        expect(AppTypography.iconSizeXXLarge, greaterThan(0.0));
        expect(AppTypography.iconSizeXXXLarge, greaterThan(0.0));
        expect(AppTypography.iconSizeXXXXLarge, greaterThan(0.0));
        expect(AppTypography.iconSizeHuge, greaterThan(0.0));
      });
    });

    group('Spacing Constants', () {
      test('should have correct spacing values', () {
        expect(AppTypography.spacingXXSmall, equals(2.0));
        expect(AppTypography.spacingXSmall, equals(4.0));
        expect(AppTypography.spacingSmall, equals(8.0));
        expect(AppTypography.spacingMedium, equals(12.0));
        expect(AppTypography.spacingLarge, equals(16.0));
        expect(AppTypography.spacingXLarge, equals(20.0));
        expect(AppTypography.spacingXXLarge, equals(24.0));
        expect(AppTypography.spacingXXXLarge, equals(32.0));
      });

      test('spacing values should be in ascending order', () {
        expect(
          AppTypography.spacingXXSmall,
          lessThan(AppTypography.spacingXSmall),
        );
        expect(
          AppTypography.spacingXSmall,
          lessThan(AppTypography.spacingSmall),
        );
        expect(
          AppTypography.spacingSmall,
          lessThan(AppTypography.spacingMedium),
        );
        expect(
          AppTypography.spacingMedium,
          lessThan(AppTypography.spacingLarge),
        );
        expect(
          AppTypography.spacingLarge,
          lessThan(AppTypography.spacingXLarge),
        );
        expect(
          AppTypography.spacingXLarge,
          lessThan(AppTypography.spacingXXLarge),
        );
        expect(
          AppTypography.spacingXXLarge,
          lessThan(AppTypography.spacingXXXLarge),
        );
      });

      test('all spacing values should be positive', () {
        expect(AppTypography.spacingXXSmall, greaterThan(0.0));
        expect(AppTypography.spacingXSmall, greaterThan(0.0));
        expect(AppTypography.spacingSmall, greaterThan(0.0));
        expect(AppTypography.spacingMedium, greaterThan(0.0));
        expect(AppTypography.spacingLarge, greaterThan(0.0));
        expect(AppTypography.spacingXLarge, greaterThan(0.0));
        expect(AppTypography.spacingXXLarge, greaterThan(0.0));
        expect(AppTypography.spacingXXXLarge, greaterThan(0.0));
      });
    });

    group('Border Radius Constants', () {
      test('should have correct radius values', () {
        expect(AppTypography.radiusSmall, equals(4.0));
        expect(AppTypography.radiusMedium, equals(8.0));
        expect(AppTypography.radiusLarge, equals(12.0));
        expect(AppTypography.radiusXLarge, equals(16.0));
        expect(AppTypography.radiusXXLarge, equals(20.0));
        expect(AppTypography.radiusXXXLarge, equals(24.0));
        expect(AppTypography.radiusRound, equals(25.0));
      });

      test('radius values should be in ascending order', () {
        expect(AppTypography.radiusSmall, lessThan(AppTypography.radiusMedium));
        expect(AppTypography.radiusMedium, lessThan(AppTypography.radiusLarge));
        expect(AppTypography.radiusLarge, lessThan(AppTypography.radiusXLarge));
        expect(
          AppTypography.radiusXLarge,
          lessThan(AppTypography.radiusXXLarge),
        );
        expect(
          AppTypography.radiusXXLarge,
          lessThan(AppTypography.radiusXXXLarge),
        );
        expect(
          AppTypography.radiusXXXLarge,
          lessThan(AppTypography.radiusRound),
        );
      });

      test('all radius values should be positive', () {
        expect(AppTypography.radiusSmall, greaterThan(0.0));
        expect(AppTypography.radiusMedium, greaterThan(0.0));
        expect(AppTypography.radiusLarge, greaterThan(0.0));
        expect(AppTypography.radiusXLarge, greaterThan(0.0));
        expect(AppTypography.radiusXXLarge, greaterThan(0.0));
        expect(AppTypography.radiusXXXLarge, greaterThan(0.0));
        expect(AppTypography.radiusRound, greaterThan(0.0));
      });
    });

    group('Border Width Constants', () {
      test('should have correct border width values', () {
        expect(AppTypography.borderThin, equals(1.0));
        expect(AppTypography.borderMedium, equals(1.5));
        expect(AppTypography.borderThick, equals(2.0));
      });

      test('border widths should be in ascending order', () {
        expect(AppTypography.borderThin, lessThan(AppTypography.borderMedium));
        expect(AppTypography.borderMedium, lessThan(AppTypography.borderThick));
      });

      test('all border widths should be positive', () {
        expect(AppTypography.borderThin, greaterThan(0.0));
        expect(AppTypography.borderMedium, greaterThan(0.0));
        expect(AppTypography.borderThick, greaterThan(0.0));
      });
    });

    group('UI Component Dimensions', () {
      test('should have correct dropdown item height', () {
        expect(AppTypography.dropdownItemHeight, equals(44.0));
        expect(AppTypography.dropdownItemHeight, greaterThan(0.0));
      });

      test('should have correct avatar size', () {
        expect(AppTypography.avatarSize, equals(32.0));
        expect(AppTypography.avatarSize, greaterThan(0.0));
      });

      test('should have correct avatar margin', () {
        expect(AppTypography.avatarMargin, equals(6.0));
        expect(AppTypography.avatarMargin, greaterThan(0.0));
      });

      test('should have correct avatar selection size', () {
        expect(AppTypography.avatarSelectionSize, equals(48.0));
        expect(AppTypography.avatarSelectionSize, greaterThan(0.0));
      });

      test('should have correct avatar display size', () {
        expect(AppTypography.avatarDisplaySize, equals(96.0));
        expect(AppTypography.avatarDisplaySize, greaterThan(0.0));
      });

      test('should have correct avatar display multiplier', () {
        expect(AppTypography.avatarDisplayMultiplier, equals(1.5));
        expect(AppTypography.avatarDisplayMultiplier, greaterThan(0.0));
      });

      test('should have correct icon warning multiplier', () {
        expect(AppTypography.iconWarningMultiplier, equals(2.0));
        expect(AppTypography.iconWarningMultiplier, greaterThan(0.0));
      });
    });

    group('Text Style Constants', () {
      test('should have valid text styles with correct font sizes', () {
        expect(AppTypography.smallText, isA<TextStyle>());
        expect(
          AppTypography.smallText.fontSize,
          equals(AppTypography.fontSizeSmall),
        );

        expect(AppTypography.mediumText, isA<TextStyle>());
        expect(
          AppTypography.mediumText.fontSize,
          equals(AppTypography.fontSizeMedium),
        );

        expect(AppTypography.largeText, isA<TextStyle>());
        expect(
          AppTypography.largeText.fontSize,
          equals(AppTypography.fontSizeLarge),
        );

        expect(AppTypography.titleText, isA<TextStyle>());
        expect(
          AppTypography.titleText.fontSize,
          equals(AppTypography.fontSizeTitle),
        );
        expect(AppTypography.titleText.fontWeight, equals(FontWeight.bold));

        expect(AppTypography.headerText, isA<TextStyle>());
        expect(
          AppTypography.headerText.fontSize,
          equals(AppTypography.fontSizeHeader),
        );
        expect(AppTypography.headerText.fontWeight, equals(FontWeight.bold));
      });

      test('text styles should use AppTypography constants', () {
        // Verify text styles use the correct font size constants
        expect(AppTypography.smallText.fontSize, equals(12.0));
        expect(AppTypography.mediumText.fontSize, equals(14.0));
        expect(AppTypography.largeText.fontSize, equals(16.0));
        expect(AppTypography.titleText.fontSize, equals(24.0));
        expect(AppTypography.headerText.fontSize, equals(28.0));
      });

      test('title and header text should have bold font weight', () {
        expect(
          AppTypography.titleText.fontWeight,
          equals(FontWeight.bold),
          reason: 'Title text must use bold font weight',
        );
        expect(
          AppTypography.headerText.fontWeight,
          equals(FontWeight.bold),
          reason: 'Header text must use bold font weight',
        );
      });
    });

    group('Helper Method Tests', () {
      group('textWithOpacity method', () {
        test('should create text style with correct color and opacity', () {
          const testColor = Colors.white;
          const testOpacity = 0.7;

          final textStyle = AppTypography.textWithOpacity(
            testColor,
            testOpacity,
          );

          expect(textStyle, isA<TextStyle>());
          expect(textStyle.color, isNotNull);
          expect(
            (textStyle.color!.a * 255.0).round() & 0xff,
            equals((testOpacity * 255).round()),
          );
          expect(textStyle.fontSize, equals(AppTypography.fontSizeSmall));
        });

        test('should use custom font size when provided', () {
          const testColor = Colors.blue;
          const testOpacity = 0.5;
          const customFontSize = 20.0;

          final textStyle = AppTypography.textWithOpacity(
            testColor,
            testOpacity,
            fontSize: customFontSize,
          );

          expect(textStyle.fontSize, equals(customFontSize));
          expect(
            (textStyle.color!.a * 255.0).round() & 0xff,
            equals((testOpacity * 255).round()),
          );
        });

        test('should handle edge case opacity values', () {
          const testColor = Colors.red;

          // Test minimum opacity
          final transparentStyle = AppTypography.textWithOpacity(
            testColor,
            0.0,
          );
          expect((transparentStyle.color!.a * 255.0).round() & 0xff, equals(0));

          // Test maximum opacity
          final opaqueStyle = AppTypography.textWithOpacity(testColor, 1.0);
          expect((opaqueStyle.color!.a * 255.0).round() & 0xff, equals(255));
        });
      });

      group('createTextShadow method', () {
        test('should create text shadow with default values', () {
          final shadows = AppTypography.createTextShadow();

          expect(shadows, isA<List<Shadow>>());
          expect(shadows.length, equals(1));

          final shadow = shadows.first;
          expect(shadow.offset, equals(const Offset(1, 1)));
          expect(shadow.blurRadius, equals(2.0));
          expect(
            (shadow.color.a * 255.0).round() & 0xff,
            equals((AppTypography.opacityVeryHigh * 255).round()),
          );
        });

        test('should create text shadow with custom parameters', () {
          const customColor = Colors.blue;
          const customOpacity = 0.5;
          const customBlurRadius = 4.0;
          const customOffset = Offset(2, 3);

          final shadows = AppTypography.createTextShadow(
            color: customColor,
            opacity: customOpacity,
            blurRadius: customBlurRadius,
            offset: customOffset,
          );

          final shadow = shadows.first;
          expect(shadow.offset, equals(customOffset));
          expect(shadow.blurRadius, equals(customBlurRadius));
          expect(
            (shadow.color.a * 255.0).round() & 0xff,
            equals((customOpacity * 255).round()),
          );
        });

        test('should use AppColors.uiBlack as default color', () {
          final shadows = AppTypography.createTextShadow();
          final shadow = shadows.first;

          // Verify it uses AppColors.uiBlack with opacity applied
          expect(
            (shadow.color.r * 255.0).round() & 0xff,
            equals((AppColors.uiBlack.r * 255.0).round() & 0xff),
          );
          expect(
            (shadow.color.g * 255.0).round() & 0xff,
            equals((AppColors.uiBlack.g * 255.0).round() & 0xff),
          );
          expect(
            (shadow.color.b * 255.0).round() & 0xff,
            equals((AppColors.uiBlack.b * 255.0).round() & 0xff),
          );
        });
      });

      group('createBorder method', () {
        test('should create border with default values', () {
          final border = AppTypography.createBorder();

          expect(border, isA<Border>());
          expect(border.top.width, equals(AppTypography.borderThin));
          expect(border.right.width, equals(AppTypography.borderThin));
          expect(border.bottom.width, equals(AppTypography.borderThin));
          expect(border.left.width, equals(AppTypography.borderThin));
        });

        test('should create border with custom parameters', () {
          const customColor = Colors.green;
          const customOpacity = 0.6;
          const customWidth = 3.0;

          final border = AppTypography.createBorder(
            color: customColor,
            opacity: customOpacity,
            width: customWidth,
          );

          expect(border.top.width, equals(customWidth));
          expect(
            (border.top.color.a * 255.0).round() & 0xff,
            equals((customOpacity * 255).round()),
          );
          expect(
            (border.top.color.r * 255.0).round() & 0xff,
            equals((customColor.r * 255.0).round() & 0xff),
          );
          expect(
            (border.top.color.g * 255.0).round() & 0xff,
            equals((customColor.g * 255.0).round() & 0xff),
          );
          expect(
            (border.top.color.b * 255.0).round() & 0xff,
            equals((customColor.b * 255.0).round() & 0xff),
          );
        });

        test('should use AppColors.uiWhite as default color', () {
          final border = AppTypography.createBorder();

          // Verify it uses AppColors.uiWhite with opacity applied
          expect(
            (border.top.color.r * 255.0).round() & 0xff,
            equals((AppColors.uiWhite.r * 255.0).round() & 0xff),
          );
          expect(
            (border.top.color.g * 255.0).round() & 0xff,
            equals((AppColors.uiWhite.g * 255.0).round() & 0xff),
          );
          expect(
            (border.top.color.b * 255.0).round() & 0xff,
            equals((AppColors.uiWhite.b * 255.0).round() & 0xff),
          );
          expect(
            (border.top.color.a * 255.0).round() & 0xff,
            equals((AppTypography.opacityVeryFaint * 255).round()),
          );
        });
      });

      group('createRadius method', () {
        test('should create border radius with correct value', () {
          const testRadius = 10.0;
          final borderRadius = AppTypography.createRadius(testRadius);

          expect(borderRadius, isA<BorderRadius>());
          expect(borderRadius.topLeft.x, equals(testRadius));
          expect(borderRadius.topRight.x, equals(testRadius));
          expect(borderRadius.bottomLeft.x, equals(testRadius));
          expect(borderRadius.bottomRight.x, equals(testRadius));
        });

        test('should handle different radius values', () {
          // Test with AppTypography constants
          final smallRadius = AppTypography.createRadius(
            AppTypography.radiusSmall,
          );
          expect(smallRadius.topLeft.x, equals(4.0));

          final largeRadius = AppTypography.createRadius(
            AppTypography.radiusLarge,
          );
          expect(largeRadius.topLeft.x, equals(12.0));

          // Test with zero radius
          final zeroRadius = AppTypography.createRadius(0.0);
          expect(zeroRadius.topLeft.x, equals(0.0));
        });
      });
    });

    group('Typography Design System Consistency', () {
      test('should use consistent scaling between related constants', () {
        // Font sizes should follow reasonable progression
        expect(
          AppTypography.fontSizeMedium / AppTypography.fontSizeSmall,
          closeTo(1.17, 0.1),
        );
        expect(
          AppTypography.fontSizeLarge / AppTypography.fontSizeMedium,
          closeTo(1.14, 0.1),
        );

        // Icon sizes should follow similar progression
        expect(
          AppTypography.iconSizeMedium / AppTypography.iconSizeSmall,
          closeTo(1.14, 0.1),
        );
        expect(
          AppTypography.iconSizeLarge / AppTypography.iconSizeMedium,
          closeTo(1.13, 0.1),
        );

        // Spacing should follow consistent increments
        expect(
          AppTypography.spacingSmall / AppTypography.spacingXSmall,
          equals(2.0),
        );
        expect(
          AppTypography.spacingMedium / AppTypography.spacingSmall,
          equals(1.5),
        );
      });

      test('should have consistent naming patterns', () {
        // This is more of a documentation test to ensure consistency
        // Font size progression: XSmall, XXSmall, Small, Medium, Large, XLarge, XXLarge, Title, Header
        // Icon size progression: Small, Medium, Large, XLarge, XXLarge, XXXLarge, XXXXLarge, Huge
        // Spacing progression: XXSmall, XSmall, Small, Medium, Large, XLarge, XXLarge, XXXLarge
        // Radius progression: Small, Medium, Large, XLarge, XXLarge, XXXLarge, Round

        // Just verify the constants exist (already tested above)
        expect(AppTypography.fontSizeSmall, isNotNull);
        expect(AppTypography.iconSizeSmall, isNotNull);
        expect(AppTypography.spacingSmall, isNotNull);
        expect(AppTypography.radiusSmall, isNotNull);
      });

      test('should have appropriate defaults for helper methods', () {
        // Default font size for textWithOpacity should be small
        const testColor = Colors.white;
        final textStyle = AppTypography.textWithOpacity(testColor, 0.5);
        expect(
          textStyle.fontSize,
          equals(AppTypography.fontSizeSmall),
          reason: 'Default font size should use fontSizeSmall constant',
        );

        // Default opacity for createTextShadow should be very high
        final shadows = AppTypography.createTextShadow();
        expect(
          (shadows.first.color.a * 255.0).round() & 0xff,
          equals((AppTypography.opacityVeryHigh * 255).round()),
          reason: 'Default shadow opacity should use opacityVeryHigh constant',
        );

        // Default border width should be thin
        final border = AppTypography.createBorder();
        expect(
          border.top.width,
          equals(AppTypography.borderThin),
          reason: 'Default border width should use borderThin constant',
        );
      });
    });
  });
}
