import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/dialog_action.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('DialogAction', () {
    late VoidCallback testCallback;
    late DialogAction testAction;

    setUp(() {
      testCallback = () {};
      testAction = DialogAction(
        text: 'Test Action',
        onPressed: testCallback,
        textColor: AppColors.uiWhite,
        backgroundColor: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
        isDestructive: false,
      );
    });

    group('constructor and properties', () {
      test('creates instance with all properties', () {
        expect(testAction.text, equals('Test Action'));
        expect(testAction.onPressed, equals(testCallback));
        expect(testAction.textColor, equals(AppColors.uiWhite));
        expect(testAction.backgroundColor, equals(AppColors.primaryColor));
        expect(testAction.fontWeight, equals(FontWeight.bold));
        expect(testAction.isDestructive, isFalse);
      });

      test('creates instance with only required properties', () {
        final minimalAction = DialogAction(
          text: 'Minimal',
          onPressed: testCallback,
        );

        expect(minimalAction.text, equals('Minimal'));
        expect(minimalAction.onPressed, equals(testCallback));
        expect(minimalAction.textColor, isNull);
        expect(minimalAction.backgroundColor, isNull);
        expect(minimalAction.fontWeight, isNull);
        expect(minimalAction.isDestructive, isFalse); // Default value
      });

      test('handles null optional properties', () {
        final actionWithNulls = DialogAction(
          text: 'Null Test',
          onPressed: testCallback,
          textColor: null,
          backgroundColor: null,
          fontWeight: null,
          isDestructive: false,
        );

        expect(actionWithNulls.textColor, isNull);
        expect(actionWithNulls.backgroundColor, isNull);
        expect(actionWithNulls.fontWeight, isNull);
      });

      test('validates default isDestructive value', () {
        final defaultAction = DialogAction(
          text: 'Default Test',
          onPressed: testCallback,
        );

        expect(defaultAction.isDestructive, isFalse);
      });
    });

    group('text property validation', () {
      test('handles empty string text', () {
        final emptyAction = DialogAction(text: '', onPressed: testCallback);

        expect(emptyAction.text, equals(''));
        expect(emptyAction.text.isEmpty, isTrue);
      });

      test('handles single character text', () {
        final singleCharAction = DialogAction(
          text: 'X',
          onPressed: testCallback,
        );

        expect(singleCharAction.text, equals('X'));
        expect(singleCharAction.text.length, equals(1));
      });

      test('handles very long text', () {
        final longText =
            'This is a very long action text that might wrap ' * 10;
        final longAction = DialogAction(
          text: longText,
          onPressed: testCallback,
        );

        expect(longAction.text, equals(longText));
        expect(longAction.text.length, greaterThan(100));
      });

      test('handles special characters in text', () {
        final specialAction = DialogAction(
          text: '!@#\$%^&*()_+-={}[]|\\:";\'<>?,./~`',
          onPressed: testCallback,
        );

        expect(specialAction.text, contains('!@#'));
        expect(specialAction.text, contains('()'));
      });

      test('handles unicode characters in text', () {
        final unicodeAction = DialogAction(
          text: '✓ Confirm 🚀',
          onPressed: testCallback,
        );

        expect(unicodeAction.text, equals('✓ Confirm 🚀'));
        expect(unicodeAction.text, contains('✓'));
        expect(unicodeAction.text, contains('🚀'));
      });

      test('handles newlines and whitespace', () {
        final whitespaceAction = DialogAction(
          text: '  Padded  \n  Text  ',
          onPressed: testCallback,
        );

        expect(whitespaceAction.text, equals('  Padded  \n  Text  '));
        expect(whitespaceAction.text, contains('\n'));
      });
    });

    group('callback execution validation', () {
      test('executes callback when called', () {
        var callbackExecuted = false;
        final executableAction = DialogAction(
          text: 'Execute Test',
          onPressed: () {
            callbackExecuted = true;
          },
        );

        expect(callbackExecuted, isFalse);
        executableAction.onPressed();
        expect(callbackExecuted, isTrue);
      });

      test('executes callback multiple times', () {
        var executionCount = 0;
        final multiExecAction = DialogAction(
          text: 'Multi Execute',
          onPressed: () {
            executionCount++;
          },
        );

        for (int i = 0; i < 5; i++) {
          multiExecAction.onPressed();
        }
        expect(executionCount, equals(5));
      });

      test('callback maintains closure variables', () {
        var capturedValue = 'initial';
        final closureAction = DialogAction(
          text: 'Closure Test',
          onPressed: () {
            capturedValue = 'modified';
          },
        );

        expect(capturedValue, equals('initial'));
        closureAction.onPressed();
        expect(capturedValue, equals('modified'));
      });

      test('validates callback type', () {
        expect(testAction.onPressed, isA<VoidCallback>());
        expect(testAction.onPressed, isA<Function>());
      });
    });

    group('color property validation', () {
      test('handles standard Material colors for text', () {
        final coloredAction = DialogAction(
          text: 'Colored Text',
          onPressed: testCallback,
          textColor: AppColors.uiRed,
          backgroundColor: AppColors.habitabilityHabitable,
        );

        expect(coloredAction.textColor, equals(AppColors.uiRed));
        expect(
          coloredAction.backgroundColor,
          equals(AppColors.habitabilityHabitable),
        );
      });

      test('handles custom colors', () {
        const customTextColor = Color(0xFF123456);
        const customBackgroundColor = Color(0xFFABCDEF);
        final customColorAction = DialogAction(
          text: 'Custom Colors',
          onPressed: testCallback,
          textColor: customTextColor,
          backgroundColor: customBackgroundColor,
        );

        expect(customColorAction.textColor, equals(customTextColor));
        expect(
          customColorAction.backgroundColor,
          equals(customBackgroundColor),
        );
      });

      test('handles transparent and translucent colors', () {
        final transparentAction = DialogAction(
          text: 'Transparent',
          onPressed: testCallback,
          textColor: AppColors.transparentColor,
          backgroundColor: const Color(0x80FF0000), // 50% red
        );

        expect(transparentAction.textColor, equals(AppColors.transparentColor));
        expect(
          transparentAction.backgroundColor?.a,
          closeTo(0.5, 0.01),
        ); // 50% opacity
      });

      test('validates color accessibility', () {
        // Colors should have valid ARGB components (0.0-1.0 range)
        if (testAction.textColor != null) {
          expect(testAction.textColor!.a, inInclusiveRange(0.0, 1.0));
          expect(testAction.textColor!.r, inInclusiveRange(0.0, 1.0));
          expect(testAction.textColor!.g, inInclusiveRange(0.0, 1.0));
          expect(testAction.textColor!.b, inInclusiveRange(0.0, 1.0));
        }

        if (testAction.backgroundColor != null) {
          expect(testAction.backgroundColor!.a, inInclusiveRange(0.0, 1.0));
          expect(testAction.backgroundColor!.r, inInclusiveRange(0.0, 1.0));
          expect(testAction.backgroundColor!.g, inInclusiveRange(0.0, 1.0));
          expect(testAction.backgroundColor!.b, inInclusiveRange(0.0, 1.0));
        }
      });

      test('handles null color values', () {
        final nullColorAction = DialogAction(
          text: 'Null Colors',
          onPressed: testCallback,
          textColor: null,
          backgroundColor: null,
        );

        expect(nullColorAction.textColor, isNull);
        expect(nullColorAction.backgroundColor, isNull);
      });
    });

    group('font weight validation', () {
      test('handles all FontWeight values', () {
        final fontWeights = [
          FontWeight.w100,
          FontWeight.w200,
          FontWeight.w300,
          FontWeight.w400,
          FontWeight.w500,
          FontWeight.w600,
          FontWeight.w700,
          FontWeight.w800,
          FontWeight.w900,
          FontWeight.normal,
          FontWeight.bold,
        ];

        for (final weight in fontWeights) {
          final weightedAction = DialogAction(
            text: 'Weight Test',
            onPressed: testCallback,
            fontWeight: weight,
          );

          expect(weightedAction.fontWeight, equals(weight));
          expect(weightedAction.fontWeight, isA<FontWeight>());
        }
      });

      test('handles null font weight', () {
        final nullWeightAction = DialogAction(
          text: 'Null Weight',
          onPressed: testCallback,
          fontWeight: null,
        );

        expect(nullWeightAction.fontWeight, isNull);
      });

      test('validates font weight types', () {
        final boldAction = DialogAction(
          text: 'Bold Test',
          onPressed: testCallback,
          fontWeight: FontWeight.bold,
        );

        expect(boldAction.fontWeight, isA<FontWeight?>());
        expect(boldAction.fontWeight!.index, equals(FontWeight.bold.index));
      });
    });

    group('isDestructive property validation', () {
      test('creates destructive action', () {
        final destructiveAction = DialogAction(
          text: 'Delete',
          onPressed: testCallback,
          isDestructive: true,
        );

        expect(destructiveAction.isDestructive, isTrue);
      });

      test('creates non-destructive action', () {
        final nonDestructiveAction = DialogAction(
          text: 'Save',
          onPressed: testCallback,
          isDestructive: false,
        );

        expect(nonDestructiveAction.isDestructive, isFalse);
      });

      test('validates boolean type', () {
        expect(testAction.isDestructive, isA<bool>());
        expect(testAction.isDestructive, isFalse);
      });
    });

    group('common dialog action patterns', () {
      test('creates confirm action', () {
        var confirmed = false;
        final confirmAction = DialogAction(
          text: 'Confirm',
          onPressed: () {
            confirmed = true;
          },
          textColor: AppColors.uiWhite,
          backgroundColor: AppColors.primaryColor,
          fontWeight: FontWeight.w500,
          isDestructive: false,
        );

        expect(confirmAction.text, equals('Confirm'));
        expect(confirmAction.isDestructive, isFalse);
        expect(confirmAction.backgroundColor, equals(AppColors.primaryColor));

        confirmAction.onPressed();
        expect(confirmed, isTrue);
      });

      test('creates cancel action', () {
        var cancelled = false;
        final cancelAction = DialogAction(
          text: 'Cancel',
          onPressed: () {
            cancelled = true;
          },
          textColor: AppColors.uiBorderGrey,
          fontWeight: FontWeight.w400,
          isDestructive: false,
        );

        expect(cancelAction.text, equals('Cancel'));
        expect(cancelAction.isDestructive, isFalse);
        expect(cancelAction.textColor, equals(AppColors.uiBorderGrey));

        cancelAction.onPressed();
        expect(cancelled, isTrue);
      });

      test('creates delete action', () {
        var deleted = false;
        final deleteAction = DialogAction(
          text: 'Delete',
          onPressed: () {
            deleted = true;
          },
          textColor: AppColors.uiWhite,
          backgroundColor: AppColors.uiRed,
          fontWeight: FontWeight.w600,
          isDestructive: true,
        );

        expect(deleteAction.text, equals('Delete'));
        expect(deleteAction.isDestructive, isTrue);
        expect(deleteAction.backgroundColor, equals(AppColors.uiRed));
        expect(deleteAction.textColor, equals(AppColors.uiWhite));

        deleteAction.onPressed();
        expect(deleted, isTrue);
      });

      test('creates save action', () {
        var saved = false;
        final saveAction = DialogAction(
          text: 'Save',
          onPressed: () {
            saved = true;
          },
          textColor: AppColors.uiWhite,
          backgroundColor: AppColors.habitabilityHabitable,
          fontWeight: FontWeight.w500,
          isDestructive: false,
        );

        expect(saveAction.text, equals('Save'));
        expect(saveAction.isDestructive, isFalse);
        expect(
          saveAction.backgroundColor,
          equals(AppColors.habitabilityHabitable),
        );

        saveAction.onPressed();
        expect(saved, isTrue);
      });

      test('creates warning action', () {
        var acknowledged = false;
        final warningAction = DialogAction(
          text: 'I Understand',
          onPressed: () {
            acknowledged = true;
          },
          textColor: AppColors.backgroundBlack,
          backgroundColor: AppColors.stellarKType,
          fontWeight: FontWeight.w600,
          isDestructive: false,
        );

        expect(warningAction.text, equals('I Understand'));
        expect(warningAction.backgroundColor, equals(AppColors.stellarKType));

        warningAction.onPressed();
        expect(acknowledged, isTrue);
      });
    });

    group('theme integration and styling', () {
      test('supports light theme styling', () {
        final lightThemeAction = DialogAction(
          text: 'Light Theme Action',
          onPressed: testCallback,
          textColor: AppColors.uiDividerGrey,
          backgroundColor: AppColors.uiTextGrey,
          fontWeight: FontWeight.w500,
        );

        expect(lightThemeAction.textColor, equals(AppColors.uiDividerGrey));
        expect(lightThemeAction.backgroundColor, equals(AppColors.uiTextGrey));
      });

      test('supports dark theme styling', () {
        final darkThemeAction = DialogAction(
          text: 'Dark Theme Action',
          onPressed: testCallback,
          textColor: AppColors.uiTextGrey,
          backgroundColor: AppColors.uiDividerGrey,
          fontWeight: FontWeight.w500,
        );

        expect(darkThemeAction.textColor, equals(AppColors.uiTextGrey));
        expect(
          darkThemeAction.backgroundColor,
          equals(AppColors.uiDividerGrey),
        );
      });

      test('supports high contrast accessibility', () {
        final highContrastAction = DialogAction(
          text: 'High Contrast',
          onPressed: testCallback,
          textColor: AppColors.backgroundBlack,
          backgroundColor: AppColors.uiWhite,
          fontWeight: FontWeight.w700,
        );

        expect(highContrastAction.textColor, equals(AppColors.backgroundBlack));
        expect(highContrastAction.backgroundColor, equals(AppColors.uiWhite));
        expect(highContrastAction.fontWeight, equals(FontWeight.w700));
      });
    });

    group('edge cases and validation', () {
      test('handles immutability', () {
        void dummyCallback() {}

        final action1 = DialogAction(
          text: 'Immutable Test',
          onPressed: dummyCallback,
        );

        // Should be able to create identical actions
        final action2 = DialogAction(
          text: 'Immutable Test',
          onPressed: dummyCallback,
        );

        expect(action1.text, equals(action2.text));
        expect(action1.isDestructive, equals(action2.isDestructive));
      });

      test('validates all required fields are non-null', () {
        expect(testAction.text, isNotNull);
        expect(testAction.onPressed, isNotNull);
        // Note: isDestructive has a default value of false, so it's never null
        expect(testAction.isDestructive, isNotNull);
      });

      test('handles complex callback scenarios', () {
        var complexValue = <String, int>{};
        final complexAction = DialogAction(
          text: 'Complex Callback',
          onPressed: () {
            complexValue['count'] = (complexValue['count'] ?? 0) + 1;
            complexValue['timestamp'] = DateTime.now().millisecondsSinceEpoch;
          },
        );

        expect(complexValue.isEmpty, isTrue);
        complexAction.onPressed();
        expect(complexValue['count'], equals(1));
        expect(complexValue['timestamp'], isNotNull);

        complexAction.onPressed();
        expect(complexValue['count'], equals(2));
      });

      test('validates action button accessibility', () {
        // Actions should have meaningful text for screen readers
        expect(testAction.text, isNotEmpty);
        expect(testAction.text, isA<String>());

        // Destructive actions should be clearly marked
        final destructive = DialogAction(
          text: 'Permanently Delete',
          onPressed: testCallback,
          isDestructive: true,
        );

        expect(destructive.isDestructive, isTrue);
        expect(destructive.text, contains('Delete'));
      });
    });
  });
}
