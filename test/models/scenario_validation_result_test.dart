import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/scenario_validation_result.dart';

void main() {
  group('ScenarioValidationResult', () {
    group('Constructor', () {
      test('should create instance with required parameters', () {
        const result = ScenarioValidationResult(isValid: true, errors: []);

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should create instance with validation errors', () {
        const errors = ['Error 1', 'Error 2'];
        const result = ScenarioValidationResult(isValid: false, errors: errors);

        expect(result.isValid, isFalse);
        expect(result.errors, equals(errors));
      });
    });

    group('Named constructors', () {
      test('valid() should create successful validation result', () {
        const result = ScenarioValidationResult.valid();

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
        expect(result.hasErrors, isFalse);
        expect(result.errorCount, equals(0));
      });

      test('invalid() should create failed validation result with errors', () {
        const errors = ['Invalid field', 'Missing data'];
        final result = ScenarioValidationResult.invalid(errors);

        expect(result.isValid, isFalse);
        expect(result.errors, equals(errors));
        expect(result.hasErrors, isTrue);
        expect(result.errorCount, equals(2));
      });

      test(
        'singleError() should create failed validation result with one error',
        () {
          const error = 'Single error message';
          final result = ScenarioValidationResult.singleError(error);

          expect(result.isValid, isFalse);
          expect(result.errors, equals([error]));
          expect(result.hasErrors, isTrue);
          expect(result.errorCount, equals(1));
        },
      );
    });

    group('Properties', () {
      test('hasErrors should return true when errors exist', () {
        final result = ScenarioValidationResult.singleError('Error');
        expect(result.hasErrors, isTrue);
      });

      test('hasErrors should return false when no errors exist', () {
        const result = ScenarioValidationResult.valid();
        expect(result.hasErrors, isFalse);
      });

      test('errorCount should return correct number of errors', () {
        const errors = ['Error 1', 'Error 2', 'Error 3'];
        final result = ScenarioValidationResult.invalid(errors);
        expect(result.errorCount, equals(3));
      });

      test('formattedErrors should join errors with commas', () {
        const errors = ['First error', 'Second error', 'Third error'];
        final result = ScenarioValidationResult.invalid(errors);
        expect(
          result.formattedErrors,
          equals('First error, Second error, Third error'),
        );
      });

      test('formattedErrors should return empty string when no errors', () {
        const result = ScenarioValidationResult.valid();
        expect(result.formattedErrors, equals(''));
      });
    });

    group('Methods', () {
      test(
        'copyWithAdditionalErrors should add new errors and make result invalid',
        () {
          const originalErrors = ['Original error'];
          final original = ScenarioValidationResult.invalid(originalErrors);

          const newErrors = ['New error 1', 'New error 2'];
          final updated = original.copyWithAdditionalErrors(newErrors);

          expect(updated.isValid, isFalse);
          expect(
            updated.errors,
            equals(['Original error', 'New error 1', 'New error 2']),
          );
          expect(updated.errorCount, equals(3));
        },
      );

      test(
        'copyWithAdditionalErrors should make valid result invalid when adding errors',
        () {
          const original = ScenarioValidationResult.valid();

          const newErrors = ['New error'];
          final updated = original.copyWithAdditionalErrors(newErrors);

          expect(updated.isValid, isFalse);
          expect(updated.errors, equals(['New error']));
        },
      );

      test('merge should combine two valid results into valid result', () {
        const result1 = ScenarioValidationResult.valid();
        const result2 = ScenarioValidationResult.valid();

        final merged = result1.merge(result2);

        expect(merged.isValid, isTrue);
        expect(merged.errors, isEmpty);
      });

      test(
        'merge should combine valid and invalid results into invalid result',
        () {
          const validResult = ScenarioValidationResult.valid();
          final invalidResult = ScenarioValidationResult.singleError('Error');

          final merged = validResult.merge(invalidResult);

          expect(merged.isValid, isFalse);
          expect(merged.errors, equals(['Error']));
        },
      );

      test('merge should combine two invalid results', () {
        final result1 = ScenarioValidationResult.invalid([
          'Error 1',
          'Error 2',
        ]);
        final result2 = ScenarioValidationResult.invalid([
          'Error 3',
          'Error 4',
        ]);

        final merged = result1.merge(result2);

        expect(merged.isValid, isFalse);
        expect(
          merged.errors,
          equals(['Error 1', 'Error 2', 'Error 3', 'Error 4']),
        );
        expect(merged.errorCount, equals(4));
      });
    });

    group('Equality and hashCode', () {
      test('should be equal when isValid and errors are the same', () {
        const result1 = ScenarioValidationResult(isValid: true, errors: []);
        const result2 = ScenarioValidationResult(isValid: true, errors: []);

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should be equal when isValid and errors match exactly', () {
        const errors = ['Error 1', 'Error 2'];
        const result1 = ScenarioValidationResult(
          isValid: false,
          errors: errors,
        );
        const result2 = ScenarioValidationResult(
          isValid: false,
          errors: errors,
        );

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should not be equal when isValid differs', () {
        const result1 = ScenarioValidationResult(isValid: true, errors: []);
        const result2 = ScenarioValidationResult(isValid: false, errors: []);

        expect(result1, isNot(equals(result2)));
      });

      test('should not be equal when errors differ', () {
        const result1 = ScenarioValidationResult(
          isValid: false,
          errors: ['Error 1'],
        );
        const result2 = ScenarioValidationResult(
          isValid: false,
          errors: ['Error 2'],
        );

        expect(result1, isNot(equals(result2)));
      });

      test('should not be equal when error order differs', () {
        const result1 = ScenarioValidationResult(
          isValid: false,
          errors: ['Error 1', 'Error 2'],
        );
        const result2 = ScenarioValidationResult(
          isValid: false,
          errors: ['Error 2', 'Error 1'],
        );

        expect(result1, isNot(equals(result2)));
      });

      test('should be equal to self (reflexive)', () {
        final result = ScenarioValidationResult.singleError('Test error');
        expect(result, equals(result));
      });

      test('should handle different types in equality check', () {
        const result = ScenarioValidationResult.valid();
        expect(result, isNot(equals('not a validation result')));
        expect(result, isNot(equals(42)));
        expect(result, isNot(equals(null)));
      });
    });

    group('toString', () {
      test(
        'should provide meaningful string representation for valid result',
        () {
          const result = ScenarioValidationResult.valid();
          expect(
            result.toString(),
            equals('ScenarioValidationResult(isValid: true, errors: [])'),
          );
        },
      );

      test(
        'should provide meaningful string representation for invalid result',
        () {
          final result = ScenarioValidationResult.singleError('Test error');
          expect(
            result.toString(),
            equals(
              'ScenarioValidationResult(isValid: false, errors: [Test error])',
            ),
          );
        },
      );

      test('should handle multiple errors in string representation', () {
        const errors = ['Error 1', 'Error 2'];
        final result = ScenarioValidationResult.invalid(errors);
        expect(
          result.toString(),
          equals(
            'ScenarioValidationResult(isValid: false, errors: [Error 1, Error 2])',
          ),
        );
      });
    });

    group('Edge cases', () {
      test('should handle empty error list', () {
        const result = ScenarioValidationResult(isValid: false, errors: []);

        expect(result.hasErrors, isFalse);
        expect(result.errorCount, equals(0));
        expect(result.formattedErrors, isEmpty);
      });

      test('should handle very long error messages', () {
        const longError =
            'This is a very long error message that contains a lot of text and details about what went wrong during validation';
        final result = ScenarioValidationResult.singleError(longError);

        expect(result.errors.first, equals(longError));
        expect(result.formattedErrors, equals(longError));
      });

      test('should handle special characters in error messages', () {
        const specialError = 'Error with special chars: <>&"\'';
        final result = ScenarioValidationResult.singleError(specialError);

        expect(result.errors.first, equals(specialError));
        expect(result.formattedErrors, equals(specialError));
      });

      test('should handle unicode characters in error messages', () {
        const unicodeError = 'Error with unicode: 🚀 ñáéíóú 中文';
        final result = ScenarioValidationResult.singleError(unicodeError);

        expect(result.errors.first, equals(unicodeError));
        expect(result.formattedErrors, equals(unicodeError));
      });

      test('should handle empty string errors', () {
        const errors = ['', 'Valid error', ''];
        final result = ScenarioValidationResult.invalid(errors);

        expect(result.errors, equals(errors));
        expect(result.errorCount, equals(3));
        expect(result.formattedErrors, equals(', Valid error, '));
      });
    });

    group('Real-world scenarios', () {
      test('should handle typical scenario validation errors', () {
        const errors = [
          'Missing required field: metadata',
          'Body count exceeds maximum of 50',
          'Invalid gravitational constant value',
          'Scenario name too long',
        ];
        final result = ScenarioValidationResult.invalid(errors);

        expect(result.isValid, isFalse);
        expect(result.hasErrors, isTrue);
        expect(result.errorCount, equals(4));
        expect(result.formattedErrors, contains('Missing required field'));
        expect(result.formattedErrors, contains('Body count exceeds'));
      });

      test('should merge validation results from different validators', () {
        final metadataErrors = ScenarioValidationResult.invalid([
          'Invalid name',
          'Missing description',
        ]);
        final physicsErrors = ScenarioValidationResult.invalid([
          'Invalid gravity constant',
        ]);
        const bodyErrors = ScenarioValidationResult.valid();

        final finalResult = metadataErrors
            .merge(physicsErrors)
            .merge(bodyErrors);

        expect(finalResult.isValid, isFalse);
        expect(finalResult.errorCount, equals(3));
        expect(finalResult.errors, contains('Invalid name'));
        expect(finalResult.errors, contains('Invalid gravity constant'));
      });
    });
  });
}
