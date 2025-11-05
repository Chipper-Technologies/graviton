import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/speed_preset.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('SpeedPreset Enum', () {
    test('should have all expected speed presets', () {
      expect(SpeedPreset.values.length, equals(7));
      expect(SpeedPreset.values, contains(SpeedPreset.quarterSpeed));
      expect(SpeedPreset.values, contains(SpeedPreset.halfSpeed));
      expect(SpeedPreset.values, contains(SpeedPreset.normal));
      expect(SpeedPreset.values, contains(SpeedPreset.double));
      expect(SpeedPreset.values, contains(SpeedPreset.fast));
      expect(SpeedPreset.values, contains(SpeedPreset.veryFast));
      expect(SpeedPreset.values, contains(SpeedPreset.maximum));
    });

    test('should have correct multiplier values', () {
      expect(SpeedPreset.quarterSpeed.multiplier, equals(0.25));
      expect(SpeedPreset.halfSpeed.multiplier, equals(0.5));
      expect(SpeedPreset.normal.multiplier, equals(1.0));
      expect(SpeedPreset.double.multiplier, equals(2.0));
      expect(SpeedPreset.fast.multiplier, equals(4.0));
      expect(SpeedPreset.veryFast.multiplier, equals(8.0));
      expect(SpeedPreset.maximum.multiplier, equals(16.0));
    });

    test('should have appropriate icons', () {
      expect(SpeedPreset.quarterSpeed.icon, equals(Icons.slow_motion_video));
      expect(SpeedPreset.halfSpeed.icon, equals(Icons.play_arrow));
      expect(SpeedPreset.normal.icon, equals(Icons.play_arrow));
      expect(SpeedPreset.double.icon, equals(Icons.fast_forward));
      expect(SpeedPreset.fast.icon, equals(Icons.fast_forward));
      expect(SpeedPreset.veryFast.icon, equals(Icons.fast_forward));
      expect(SpeedPreset.maximum.icon, equals(Icons.fast_forward));
    });

    test('should have multipliers in ascending order', () {
      final multipliers = SpeedPreset.values
          .map((preset) => preset.multiplier)
          .toList();
      final sortedMultipliers = [...multipliers]..sort();
      expect(
        multipliers,
        equals(sortedMultipliers),
        reason: 'Speed presets should be ordered by multiplier value',
      );
    });

    test('should have unique multiplier values', () {
      final multipliers = SpeedPreset.values
          .map((preset) => preset.multiplier)
          .toSet();
      expect(
        multipliers.length,
        equals(SpeedPreset.values.length),
        reason: 'All speed presets should have unique multipliers',
      );
    });

    group('formattedSpeed extension', () {
      test('should format speed correctly', () {
        expect(
          SpeedPreset.quarterSpeed.formattedSpeed,
          anyOf(equals('0.3x'), equals('0.25x')),
        );
        expect(SpeedPreset.halfSpeed.formattedSpeed, equals('0.5x'));
        expect(SpeedPreset.normal.formattedSpeed, equals('1x'));
        expect(SpeedPreset.double.formattedSpeed, equals('2x'));
        expect(SpeedPreset.fast.formattedSpeed, equals('4x'));
        expect(SpeedPreset.veryFast.formattedSpeed, equals('8x'));
        expect(SpeedPreset.maximum.formattedSpeed, equals('16x'));
      });

      test('should use appropriate decimal places', () {
        // Integer values should not show decimal places
        expect(SpeedPreset.normal.formattedSpeed, equals('1x'));
        expect(SpeedPreset.double.formattedSpeed, equals('2x'));
        expect(SpeedPreset.fast.formattedSpeed, equals('4x'));

        // Non-integer values should show one decimal place
        expect(SpeedPreset.quarterSpeed.formattedSpeed, contains('.'));
        expect(SpeedPreset.halfSpeed.formattedSpeed, contains('.'));
      });
    });

    group('localizationKey extension', () {
      test('should return correct localization keys', () {
        expect(
          SpeedPreset.quarterSpeed.localizationKey,
          equals('speedQuarter'),
        );
        expect(SpeedPreset.halfSpeed.localizationKey, equals('speedHalf'));
        expect(SpeedPreset.normal.localizationKey, equals('speedNormal'));
        expect(SpeedPreset.double.localizationKey, equals('speedDouble'));
        expect(SpeedPreset.fast.localizationKey, equals('speedFast'));
        expect(SpeedPreset.veryFast.localizationKey, equals('speedVeryFast'));
        expect(SpeedPreset.maximum.localizationKey, equals('speedMaximum'));
      });

      test('should follow consistent naming pattern', () {
        for (final preset in SpeedPreset.values) {
          final key = preset.localizationKey;
          expect(
            key,
            startsWith('speed'),
            reason: '$key should start with "speed" prefix',
          );
          expect(
            key,
            matches(RegExp(r'^speed[A-Z][a-zA-Z]*$')),
            reason: '$key should follow camelCase pattern after prefix',
          );
        }
      });

      test('should have unique localization keys', () {
        final keys = SpeedPreset.values
            .map((preset) => preset.localizationKey)
            .toSet();
        expect(
          keys.length,
          equals(SpeedPreset.values.length),
          reason: 'All speed presets should have unique localization keys',
        );
      });
    });

    group('getLocalizedDisplayName extension', () {
      testWidgets('should return localized display names for all presets', (
        tester,
      ) async {
        const widget = MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Text('Test'),
        );

        await tester.pumpWidget(widget);
        final l10n = AppLocalizations.of(tester.element(find.byType(Text)))!;

        expect(
          SpeedPreset.quarterSpeed.getLocalizedDisplayName(l10n),
          isNotEmpty,
        );
        expect(SpeedPreset.halfSpeed.getLocalizedDisplayName(l10n), isNotEmpty);
        expect(SpeedPreset.normal.getLocalizedDisplayName(l10n), isNotEmpty);
        expect(SpeedPreset.double.getLocalizedDisplayName(l10n), isNotEmpty);
        expect(SpeedPreset.fast.getLocalizedDisplayName(l10n), isNotEmpty);
        expect(SpeedPreset.veryFast.getLocalizedDisplayName(l10n), isNotEmpty);
        expect(SpeedPreset.maximum.getLocalizedDisplayName(l10n), isNotEmpty);
      });

      testWidgets('should return different names for different presets', (
        tester,
      ) async {
        const widget = MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Text('Test'),
        );

        await tester.pumpWidget(widget);
        final l10n = AppLocalizations.of(tester.element(find.byType(Text)))!;

        final names = SpeedPreset.values
            .map((preset) => preset.getLocalizedDisplayName(l10n))
            .toSet();

        expect(
          names.length,
          equals(SpeedPreset.values.length),
          reason: 'All presets should have unique localized names',
        );
      });

      testWidgets(
        'should return strings matching expected localization calls',
        (tester) async {
          const widget = MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Text('Test'),
          );

          await tester.pumpWidget(widget);
          final l10n = AppLocalizations.of(tester.element(find.byType(Text)))!;

          // These should match the localization keys
          expect(
            SpeedPreset.quarterSpeed.getLocalizedDisplayName(l10n),
            equals(l10n.speedQuarter),
          );
          expect(
            SpeedPreset.halfSpeed.getLocalizedDisplayName(l10n),
            equals(l10n.speedHalf),
          );
          expect(
            SpeedPreset.normal.getLocalizedDisplayName(l10n),
            equals(l10n.speedNormal),
          );
          expect(
            SpeedPreset.double.getLocalizedDisplayName(l10n),
            equals(l10n.speedDouble),
          );
          expect(
            SpeedPreset.fast.getLocalizedDisplayName(l10n),
            equals(l10n.speedFast),
          );
          expect(
            SpeedPreset.veryFast.getLocalizedDisplayName(l10n),
            equals(l10n.speedVeryFast),
          );
          expect(
            SpeedPreset.maximum.getLocalizedDisplayName(l10n),
            equals(l10n.speedMaximum),
          );
        },
      );
    });

    group('fromMultiplier static method', () {
      test('should find exact matches', () {
        expect(
          SpeedPresetExtension.fromMultiplier(0.25),
          equals(SpeedPreset.quarterSpeed),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(0.5),
          equals(SpeedPreset.halfSpeed),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(1.0),
          equals(SpeedPreset.normal),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(2.0),
          equals(SpeedPreset.double),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(4.0),
          equals(SpeedPreset.fast),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(8.0),
          equals(SpeedPreset.veryFast),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(16.0),
          equals(SpeedPreset.maximum),
        );
      });

      test('should find closest matches for non-exact values', () {
        expect(
          SpeedPresetExtension.fromMultiplier(0.3),
          equals(SpeedPreset.quarterSpeed),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(0.7),
          equals(SpeedPreset.halfSpeed),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(1.3),
          equals(SpeedPreset.normal),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(3.0),
          equals(SpeedPreset.fast),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(6.0),
          equals(SpeedPreset.veryFast),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(12.0),
          equals(SpeedPreset.maximum),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(20.0),
          equals(SpeedPreset.maximum),
        );
      });

      test('should handle edge cases', () {
        expect(
          SpeedPresetExtension.fromMultiplier(0.0),
          equals(SpeedPreset.quarterSpeed),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(-1.0),
          equals(SpeedPreset.quarterSpeed),
        );
        expect(
          SpeedPresetExtension.fromMultiplier(100.0),
          equals(SpeedPreset.maximum),
        );
      });
    });

    group('static preset collections', () {
      test('allPresets should return all values', () {
        expect(SpeedPresetExtension.allPresets, equals(SpeedPreset.values));
        expect(SpeedPresetExtension.allPresets.length, equals(7));
      });

      test('commonPresets should exclude extreme speeds', () {
        expect(SpeedPresetExtension.commonPresets.length, equals(5));
        expect(
          SpeedPresetExtension.commonPresets,
          contains(SpeedPreset.quarterSpeed),
        );
        expect(
          SpeedPresetExtension.commonPresets,
          contains(SpeedPreset.halfSpeed),
        );
        expect(
          SpeedPresetExtension.commonPresets,
          contains(SpeedPreset.normal),
        );
        expect(
          SpeedPresetExtension.commonPresets,
          contains(SpeedPreset.double),
        );
        expect(SpeedPresetExtension.commonPresets, contains(SpeedPreset.fast));
        expect(
          SpeedPresetExtension.commonPresets,
          isNot(contains(SpeedPreset.veryFast)),
        );
        expect(
          SpeedPresetExtension.commonPresets,
          isNot(contains(SpeedPreset.maximum)),
        );
      });

      test('commonPresets should be in order', () {
        final multipliers = SpeedPresetExtension.commonPresets
            .map((preset) => preset.multiplier)
            .toList();
        final sortedMultipliers = [...multipliers]..sort();
        expect(
          multipliers,
          equals(sortedMultipliers),
          reason: 'Common presets should be ordered by multiplier value',
        );
      });
    });

    test('should cover appropriate speed range', () {
      final minMultiplier = SpeedPreset.values
          .map((p) => p.multiplier)
          .reduce((a, b) => a < b ? a : b);
      final maxMultiplier = SpeedPreset.values
          .map((p) => p.multiplier)
          .reduce((a, b) => a > b ? a : b);

      expect(
        minMultiplier,
        lessThan(1.0),
        reason: 'Should have slow speeds below normal',
      );
      expect(
        maxMultiplier,
        greaterThan(1.0),
        reason: 'Should have fast speeds above normal',
      );
      expect(
        maxMultiplier / minMultiplier,
        greaterThan(10),
        reason: 'Should cover significant speed range',
      );
    });

    test('should have normal speed as 1.0x', () {
      expect(
        SpeedPreset.normal.multiplier,
        equals(1.0),
        reason: 'Normal speed should be 1.0x for baseline simulation',
      );
    });

    test('should use appropriate icons for speed categories', () {
      // Slow speeds should use different icon
      expect(SpeedPreset.quarterSpeed.icon, equals(Icons.slow_motion_video));

      // Normal speeds should use play icon
      expect(SpeedPreset.halfSpeed.icon, equals(Icons.play_arrow));
      expect(SpeedPreset.normal.icon, equals(Icons.play_arrow));

      // Fast speeds should use fast forward icon
      expect(SpeedPreset.double.icon, equals(Icons.fast_forward));
      expect(SpeedPreset.fast.icon, equals(Icons.fast_forward));
      expect(SpeedPreset.veryFast.icon, equals(Icons.fast_forward));
      expect(SpeedPreset.maximum.icon, equals(Icons.fast_forward));
    });
  });
}
