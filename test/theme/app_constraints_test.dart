import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_constraints.dart';

void main() {
  group('AppConstraints', () {
    group('Dialog Dimensions', () {
      test('should have correct standard dialog width', () {
        expect(AppConstraints.dialogStandardWidth, equals(600));
      });

      test('should have correct dialog heights', () {
        expect(AppConstraints.dialogCompactHeight, equals(600));
        expect(AppConstraints.dialogMediumHeight, equals(800));
        expect(AppConstraints.dialogLargeHeight, equals(900));
      });
    });

    group('Dialog Constraints', () {
      test('dialogCompact should have correct constraints', () {
        const constraints = AppConstraints.dialogCompact;
        expect(constraints.maxWidth, equals(600));
        expect(constraints.maxHeight, equals(600));
      });

      test('dialogMedium should have correct constraints', () {
        const constraints = AppConstraints.dialogMedium;
        expect(constraints.maxWidth, equals(600));
        expect(constraints.maxHeight, equals(800));
      });

      test('dialogLarge should have correct constraints', () {
        const constraints = AppConstraints.dialogLarge;
        expect(constraints.maxWidth, equals(600));
        expect(constraints.maxHeight, equals(900));
      });

      test('customDialog should create constraints with default values', () {
        final constraints = AppConstraints.customDialog();
        expect(constraints.minWidth, equals(0));
        expect(constraints.maxWidth, equals(600)); // dialogStandardWidth
        expect(constraints.minHeight, equals(0));
        expect(constraints.maxHeight, equals(double.infinity));
      });

      test('customDialog should use provided width and height', () {
        final constraints = AppConstraints.customDialog(
          width: 400,
          height: 300,
        );
        expect(constraints.minWidth, equals(400));
        expect(constraints.maxWidth, equals(400));
        expect(constraints.minHeight, equals(300));
        expect(constraints.maxHeight, equals(300));
      });

      test('customDialog should use provided maxWidth and maxHeight', () {
        final constraints = AppConstraints.customDialog(
          maxWidth: 800,
          maxHeight: 1000,
        );
        expect(constraints.maxWidth, equals(800));
        expect(constraints.maxHeight, equals(1000));
      });

      test('customDialog should prioritize maxWidth over width', () {
        final constraints = AppConstraints.customDialog(
          width: 400,
          maxWidth: 500,
        );
        expect(constraints.maxWidth, equals(500));
      });
    });

    group('Dialog Padding', () {
      test('should have correct standard padding', () {
        expect(AppConstraints.dialogPadding, equals(const EdgeInsets.all(24)));
      });

      test('should have correct compact padding', () {
        expect(
          AppConstraints.dialogPaddingCompact,
          equals(const EdgeInsets.all(16)),
        );
      });
    });

    group('Dialog Decoration', () {
      test('should have correct border radius', () {
        expect(AppConstraints.dialogBorderRadius, equals(24.0));
      });

      test('should have correct top radius', () {
        expect(
          AppConstraints.dialogTopRadius,
          equals(const Radius.circular(24.0)),
        );
      });

      test('dialogRoundedBorder should create correct border radius', () {
        final border = AppConstraints.dialogRoundedBorder;
        expect(border, equals(BorderRadius.circular(24.0)));
      });

      test('dialogTopBorder should create correct top-only border radius', () {
        final border = AppConstraints.dialogTopBorder;
        const expectedBorder = BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        );
        expect(border, equals(expectedBorder));
      });
    });
  });
}
