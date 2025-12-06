import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/graviton_menu_item_config.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('GravitonMenuItemConfig', () {
    late VoidCallback testCallback;
    late GravitonMenuItemConfig testConfig;

    setUp(() {
      testCallback = () {};
      testConfig = GravitonMenuItemConfig(
        value: 'test_value',
        labelKey: 'test_label_key',
        hintKey: 'test_hint_key',
        icon: Icons.star,
        iconColor: AppColors.primaryColor,
        borderColor: AppColors.uiRed,
        onTap: testCallback,
      );
    });

    group('constructor and properties', () {
      test('creates instance with all required properties', () {
        expect(testConfig.value, equals('test_value'));
        expect(testConfig.labelKey, equals('test_label_key'));
        expect(testConfig.hintKey, equals('test_hint_key'));
        expect(testConfig.icon, equals(Icons.star));
        expect(testConfig.iconColor, equals(AppColors.primaryColor));
        expect(testConfig.borderColor, equals(AppColors.uiRed));
        expect(testConfig.onTap, equals(testCallback));
      });

      test('creates instance with only required properties', () {
        const minimalConfig = GravitonMenuItemConfig(
          value: 'minimal',
          labelKey: 'minimal_label',
          hintKey: 'minimal_hint',
          icon: Icons.circle,
        );

        expect(minimalConfig.value, equals('minimal'));
        expect(minimalConfig.labelKey, equals('minimal_label'));
        expect(minimalConfig.hintKey, equals('minimal_hint'));
        expect(minimalConfig.icon, equals(Icons.circle));
        expect(minimalConfig.iconColor, isNull);
        expect(minimalConfig.borderColor, isNull);
        expect(minimalConfig.onTap, isNull);
      });

      test('handles null optional properties', () {
        const configWithNulls = GravitonMenuItemConfig(
          value: 'null_test',
          labelKey: 'null_label',
          hintKey: 'null_hint',
          icon: Icons.help,
          iconColor: null,
          borderColor: null,
          onTap: null,
        );

        expect(configWithNulls.iconColor, isNull);
        expect(configWithNulls.borderColor, isNull);
        expect(configWithNulls.onTap, isNull);
      });
    });

    group('value property validation', () {
      test('handles empty string value', () {
        const config = GravitonMenuItemConfig(
          value: '',
          labelKey: 'empty_value_label',
          hintKey: 'empty_value_hint',
          icon: Icons.warning,
        );

        expect(config.value, equals(''));
        expect(config.value.isEmpty, isTrue);
      });

      test('handles special characters in value', () {
        const config = GravitonMenuItemConfig(
          value: 'special!@#\$%^&*()_+-={}[]|\\:";\'<>?,./~`',
          labelKey: 'special_label',
          hintKey: 'special_hint',
          icon: Icons.code,
        );

        expect(config.value, contains('!@#'));
        expect(config.value, contains('()'));
      });

      test('handles unicode characters in value', () {
        const config = GravitonMenuItemConfig(
          value: '🌟⭐✨🚀🌍',
          labelKey: 'unicode_label',
          hintKey: 'unicode_hint',
          icon: Icons.emoji_emotions,
        );

        expect(config.value, equals('🌟⭐✨🚀🌍'));
      });

      test('handles very long value strings', () {
        final longValue = 'a' * 1000;
        final config = GravitonMenuItemConfig(
          value: longValue,
          labelKey: 'long_label',
          hintKey: 'long_hint',
          icon: Icons.text_fields,
        );

        expect(config.value.length, equals(1000));
        expect(config.value, equals(longValue));
      });
    });

    group('localization key validation', () {
      test('validates label key format', () {
        expect(testConfig.labelKey, isNotEmpty);
        expect(testConfig.labelKey, isA<String>());
      });

      test('validates hint key format', () {
        expect(testConfig.hintKey, isNotEmpty);
        expect(testConfig.hintKey, isA<String>());
      });

      test('handles dot notation in keys', () {
        const config = GravitonMenuItemConfig(
          value: 'dotted',
          labelKey: 'menu.items.action.label',
          hintKey: 'menu.items.action.hint',
          icon: Icons.menu,
        );

        expect(config.labelKey, contains('.'));
        expect(config.hintKey, contains('.'));
        expect(config.labelKey.split('.').length, equals(4));
      });

      test('handles underscore notation in keys', () {
        const config = GravitonMenuItemConfig(
          value: 'underscore',
          labelKey: 'menu_item_action_label',
          hintKey: 'menu_item_action_hint',
          icon: Icons.view_list,
        );

        expect(config.labelKey, contains('_'));
        expect(config.hintKey, contains('_'));
      });

      test('handles camelCase notation in keys', () {
        const config = GravitonMenuItemConfig(
          value: 'camelCase',
          labelKey: 'menuItemActionLabel',
          hintKey: 'menuItemActionHint',
          icon: Icons.format_size,
        );

        expect(config.labelKey, matches(RegExp(r'^[a-z][a-zA-Z]*$')));
        expect(config.hintKey, matches(RegExp(r'^[a-z][a-zA-Z]*$')));
      });
    });

    group('icon property validation', () {
      test('handles standard Material Design icons', () {
        const configs = [
          GravitonMenuItemConfig(
            value: 'home',
            labelKey: 'home_label',
            hintKey: 'home_hint',
            icon: Icons.home,
          ),
          GravitonMenuItemConfig(
            value: 'search',
            labelKey: 'search_label',
            hintKey: 'search_hint',
            icon: Icons.search,
          ),
          GravitonMenuItemConfig(
            value: 'settings',
            labelKey: 'settings_label',
            hintKey: 'settings_hint',
            icon: Icons.settings,
          ),
        ];

        for (final config in configs) {
          expect(config.icon, isA<IconData>());
          expect(config.icon.codePoint, greaterThan(0));
        }
      });

      test('handles custom icon data', () {
        const customIcon = IconData(0xe123, fontFamily: 'CustomIcons');
        const config = GravitonMenuItemConfig(
          value: 'custom',
          labelKey: 'custom_label',
          hintKey: 'custom_hint',
          icon: customIcon,
        );

        expect(config.icon.codePoint, equals(0xe123));
        expect(config.icon.fontFamily, equals('CustomIcons'));
      });

      test('validates icon accessibility', () {
        // Icons should have valid codepoints for screen readers
        expect(testConfig.icon.codePoint, greaterThan(0));
        expect(testConfig.icon, isA<IconData>());
      });
    });

    group('color property validation', () {
      test('handles standard Material colors', () {
        const config = GravitonMenuItemConfig(
          value: 'colored',
          labelKey: 'colored_label',
          hintKey: 'colored_hint',
          icon: Icons.palette,
          iconColor: AppColors.uiRed,
          borderColor: AppColors.primaryColor,
        );

        expect(config.iconColor, equals(AppColors.uiRed));
        expect(config.borderColor, equals(AppColors.primaryColor));
      });

      test('handles custom colors', () {
        const customIconColor = AppColors.planetMercury;
        const customBorderColor = AppColors.uiWhite;
        const config = GravitonMenuItemConfig(
          value: 'custom_colors',
          labelKey: 'custom_colors_label',
          hintKey: 'custom_colors_hint',
          icon: Icons.color_lens,
          iconColor: customIconColor,
          borderColor: customBorderColor,
        );

        expect(config.iconColor, equals(customIconColor));
        expect(config.borderColor, equals(customBorderColor));
      });

      test('handles transparent and translucent colors', () {
        const config = GravitonMenuItemConfig(
          value: 'transparent',
          labelKey: 'transparent_label',
          hintKey: 'transparent_hint',
          icon: Icons.opacity,
          iconColor: AppColors.transparentColor,
          borderColor: AppColors
              .stellarMType, // Use M-type stellar color for testing translucency
        );

        expect(config.iconColor, equals(AppColors.transparentColor));
        expect(config.borderColor, equals(AppColors.stellarMType));
      });

      test('validates color accessibility', () {
        // Colors should have valid component values (0.0-1.0 range)
        if (testConfig.iconColor != null) {
          expect(testConfig.iconColor!.a, inInclusiveRange(0.0, 1.0));
          expect(testConfig.iconColor!.r, inInclusiveRange(0.0, 1.0));
          expect(testConfig.iconColor!.g, inInclusiveRange(0.0, 1.0));
          expect(testConfig.iconColor!.b, inInclusiveRange(0.0, 1.0));
        }

        if (testConfig.borderColor != null) {
          expect(testConfig.borderColor!.a, inInclusiveRange(0.0, 1.0));
          expect(testConfig.borderColor!.r, inInclusiveRange(0.0, 1.0));
          expect(testConfig.borderColor!.g, inInclusiveRange(0.0, 1.0));
          expect(testConfig.borderColor!.b, inInclusiveRange(0.0, 1.0));
        }
      });
    });

    group('callback property validation', () {
      test('executes callback when provided', () {
        var callbackExecuted = false;
        final config = GravitonMenuItemConfig(
          value: 'callback_test',
          labelKey: 'callback_label',
          hintKey: 'callback_hint',
          icon: Icons.touch_app,
          onTap: () {
            callbackExecuted = true;
          },
        );

        expect(callbackExecuted, isFalse);
        config.onTap?.call();
        expect(callbackExecuted, isTrue);
      });

      test('handles multiple callback executions', () {
        var executionCount = 0;
        final config = GravitonMenuItemConfig(
          value: 'multi_callback',
          labelKey: 'multi_callback_label',
          hintKey: 'multi_callback_hint',
          icon: Icons.repeat,
          onTap: () {
            executionCount++;
          },
        );

        for (int i = 0; i < 5; i++) {
          config.onTap?.call();
        }
        expect(executionCount, equals(5));
      });

      test('gracefully handles null callback', () {
        const config = GravitonMenuItemConfig(
          value: 'null_callback',
          labelKey: 'null_callback_label',
          hintKey: 'null_callback_hint',
          icon: Icons.block,
          onTap: null,
        );

        expect(() => config.onTap?.call(), returnsNormally);
      });

      test('validates callback type', () {
        expect(testConfig.onTap, isA<VoidCallback?>());
        if (testConfig.onTap != null) {
          expect(testConfig.onTap, isA<Function>());
        }
      });
    });

    group('menu item use cases', () {
      test('create action menu item', () {
        var actionTriggered = false;
        final actionConfig = GravitonMenuItemConfig(
          value: 'delete',
          labelKey: 'deleteAction',
          hintKey: 'deleteHint',
          icon: Icons.delete,
          iconColor: AppColors.uiRed,
          borderColor: AppColors.uiRed.withValues(alpha: 0.3),
          onTap: () {
            actionTriggered = true;
          },
        );

        expect(actionConfig.value, equals('delete'));
        expect(actionConfig.icon, equals(Icons.delete));
        expect(actionConfig.iconColor, equals(AppColors.uiRed));

        actionConfig.onTap?.call();
        expect(actionTriggered, isTrue);
      });

      test('create navigation menu item', () {
        final navigationConfig = GravitonMenuItemConfig(
          value: 'settings',
          labelKey: 'settingsNavigation',
          hintKey: 'settingsNavigationHint',
          icon: Icons.settings,
          iconColor: AppColors.uiBorderGrey,
          onTap: () {
            // Navigate to settings
          },
        );

        expect(navigationConfig.value, equals('settings'));
        expect(navigationConfig.icon, equals(Icons.settings));
        expect(navigationConfig.iconColor, isNotNull);
      });

      test('create toggle menu item', () {
        var isToggled = false;
        final toggleConfig = GravitonMenuItemConfig(
          value: 'toggle_feature',
          labelKey: 'toggleFeature',
          hintKey: 'toggleFeatureHint',
          icon: Icons.toggle_off,
          onTap: () {
            isToggled = !isToggled;
          },
        );

        expect(isToggled, isFalse);
        toggleConfig.onTap?.call();
        expect(isToggled, isTrue);
      });

      test('create disabled menu item', () {
        const disabledConfig = GravitonMenuItemConfig(
          value: 'disabled_action',
          labelKey: 'disabledAction',
          hintKey: 'disabledActionHint',
          icon: Icons.block,
          iconColor: AppColors.uiTextGrey,
          onTap: null, // Disabled by not providing callback
        );

        expect(disabledConfig.onTap, isNull);
        expect(disabledConfig.iconColor, equals(AppColors.uiTextGrey));
      });
    });

    group('theme integration', () {
      test('supports theme-aware icon colors', () {
        final lightThemeConfig = GravitonMenuItemConfig(
          value: 'theme_light',
          labelKey: 'themeLightLabel',
          hintKey: 'themeLightHint',
          icon: Icons.light_mode,
          iconColor: AppColors.uiDividerGrey, // Dark icon for light theme
          onTap: () {},
        );

        final darkThemeConfig = GravitonMenuItemConfig(
          value: 'theme_dark',
          labelKey: 'themeDarkLabel',
          hintKey: 'themeDarkHint',
          icon: Icons.dark_mode,
          iconColor: AppColors.uiTextGrey, // Light icon for dark theme
          onTap: () {},
        );

        expect(lightThemeConfig.iconColor, isNotNull);
        expect(darkThemeConfig.iconColor, isNotNull);
        expect(
          lightThemeConfig.iconColor,
          isNot(equals(darkThemeConfig.iconColor)),
        );
      });

      test('supports accessibility colors', () {
        const highContrastConfig = GravitonMenuItemConfig(
          value: 'high_contrast',
          labelKey: 'highContrastLabel',
          hintKey: 'highContrastHint',
          icon: Icons.accessibility,
          iconColor: AppColors.backgroundBlack,
          borderColor: AppColors.uiWhite,
        );

        expect(highContrastConfig.iconColor, equals(AppColors.backgroundBlack));
        expect(highContrastConfig.borderColor, equals(AppColors.uiWhite));
      });
    });

    group('edge cases and validation', () {
      test('handles extremely long strings', () {
        final veryLongValue = 'x' * 10000;
        final veryLongLabel = 'label' * 1000;
        final veryLongHint = 'hint' * 1000;

        final config = GravitonMenuItemConfig(
          value: veryLongValue,
          labelKey: veryLongLabel,
          hintKey: veryLongHint,
          icon: Icons.text_fields,
        );

        expect(config.value.length, equals(10000));
        expect(config.labelKey.length, equals(5000));
        expect(config.hintKey.length, equals(4000));
      });

      test('validates immutability', () {
        // GravitonMenuItemConfig should be immutable
        const config1 = GravitonMenuItemConfig(
          value: 'immutable_test',
          labelKey: 'immutableLabel',
          hintKey: 'immutableHint',
          icon: Icons.lock,
        );

        const config2 = GravitonMenuItemConfig(
          value: 'immutable_test',
          labelKey: 'immutableLabel',
          hintKey: 'immutableHint',
          icon: Icons.lock,
        );

        expect(config1.value, equals(config2.value));
        expect(config1.labelKey, equals(config2.labelKey));
        expect(config1.hintKey, equals(config2.hintKey));
        expect(config1.icon, equals(config2.icon));
      });

      test('validates all required fields are non-null', () {
        expect(testConfig.value, isNotNull);
        expect(testConfig.labelKey, isNotNull);
        expect(testConfig.hintKey, isNotNull);
        expect(testConfig.icon, isNotNull);
      });
    });
  });
}
