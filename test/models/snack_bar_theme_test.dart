import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/snack_bar_theme.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('SnackBarTheme', () {
    const backgroundColor = AppColors.backgroundBlack;
    const borderColor = AppColors.primaryColor;
    const textColor = AppColors.uiWhite;
    const iconColor = AppColors.primaryColor;
    const actionColor = AppColors.primaryColor;
    const testIcon = Icons.info_outline;

    late SnackBarTheme testTheme;

    setUp(() {
      testTheme = const SnackBarTheme(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
        actionColor: actionColor,
        icon: testIcon,
      );
    });

    test('should create theme with all required properties', () {
      expect(testTheme.backgroundColor, equals(backgroundColor));
      expect(testTheme.borderColor, equals(borderColor));
      expect(testTheme.textColor, equals(textColor));
      expect(testTheme.iconColor, equals(iconColor));
      expect(testTheme.actionColor, equals(actionColor));
      expect(testTheme.icon, equals(testIcon));
    });

    test('copyWith should return same theme when no parameters provided', () {
      final copiedTheme = testTheme.copyWith();

      expect(copiedTheme.backgroundColor, equals(testTheme.backgroundColor));
      expect(copiedTheme.borderColor, equals(testTheme.borderColor));
      expect(copiedTheme.textColor, equals(testTheme.textColor));
      expect(copiedTheme.iconColor, equals(testTheme.iconColor));
      expect(copiedTheme.actionColor, equals(testTheme.actionColor));
      expect(copiedTheme.icon, equals(testTheme.icon));
    });

    test('copyWith should override only specified properties', () {
      const newBackgroundColor = AppColors.uiRed;
      const newIcon = Icons.error_outline;

      final copiedTheme = testTheme.copyWith(
        backgroundColor: newBackgroundColor,
        icon: newIcon,
      );

      expect(copiedTheme.backgroundColor, equals(newBackgroundColor));
      expect(copiedTheme.icon, equals(newIcon));
      // Other properties should remain unchanged
      expect(copiedTheme.borderColor, equals(testTheme.borderColor));
      expect(copiedTheme.textColor, equals(testTheme.textColor));
      expect(copiedTheme.iconColor, equals(testTheme.iconColor));
      expect(copiedTheme.actionColor, equals(testTheme.actionColor));
    });

    test('equality should work correctly', () {
      const identicalTheme = SnackBarTheme(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
        actionColor: actionColor,
        icon: testIcon,
      );

      const differentTheme = SnackBarTheme(
        backgroundColor: AppColors.uiRed, // Different color
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
        actionColor: actionColor,
        icon: testIcon,
      );

      expect(testTheme == identicalTheme, isTrue);
      expect(testTheme == differentTheme, isFalse);
      expect(testTheme == testTheme, isTrue); // Identity
    });

    test('hashCode should be consistent', () {
      const identicalTheme = SnackBarTheme(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
        actionColor: actionColor,
        icon: testIcon,
      );

      expect(testTheme.hashCode, equals(identicalTheme.hashCode));
    });

    test('toString should include all properties', () {
      final stringRepresentation = testTheme.toString();

      expect(stringRepresentation, contains('SnackBarTheme('));
      expect(
        stringRepresentation,
        contains('backgroundColor: $backgroundColor'),
      );
      expect(stringRepresentation, contains('borderColor: $borderColor'));
      expect(stringRepresentation, contains('textColor: $textColor'));
      expect(stringRepresentation, contains('iconColor: $iconColor'));
      expect(stringRepresentation, contains('actionColor: $actionColor'));
      expect(stringRepresentation, contains('icon: $testIcon'));
    });

    test('should handle different icon types correctly', () {
      const icons = [
        Icons.info_outline,
        Icons.check_circle_outline,
        Icons.warning_outlined,
        Icons.error_outline,
      ];

      for (final icon in icons) {
        final theme = testTheme.copyWith(icon: icon);
        expect(theme.icon, equals(icon));
      }
    });

    test('should handle different color combinations correctly', () {
      final colorCombinations = [
        {
          'bg': AppColors.backgroundBlack,
          'border': AppColors.primaryColor,
          'text': AppColors.uiWhite,
          'icon': AppColors.primaryColor,
          'action': AppColors.primaryColor,
        },
        {
          'bg': AppColors.uiTextGrey,
          'border': AppColors.uiGreen,
          'text': AppColors.backgroundBlack,
          'icon': AppColors.uiGreen,
          'action': AppColors.uiGreen,
        },
        {
          'bg': AppColors.uiRed,
          'border': AppColors.uiWhite,
          'text': AppColors.uiWhite,
          'icon': AppColors.uiWhite,
          'action': AppColors.uiWhite,
        },
      ];

      for (final colors in colorCombinations) {
        final theme = SnackBarTheme(
          backgroundColor: colors['bg']!,
          borderColor: colors['border']!,
          textColor: colors['text']!,
          iconColor: colors['icon']!,
          actionColor: colors['action']!,
          icon: Icons.info,
        );

        expect(theme.backgroundColor, equals(colors['bg']));
        expect(theme.borderColor, equals(colors['border']));
        expect(theme.textColor, equals(colors['text']));
        expect(theme.iconColor, equals(colors['icon']));
        expect(theme.actionColor, equals(colors['action']));
      }
    });
  });
}
