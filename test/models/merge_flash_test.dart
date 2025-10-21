import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('MergeFlash Model Tests', () {
    test('MergeFlash constructor should initialize with correct values', () {
      final position = vm.Vector3(1.0, 2.0, 3.0);
      const color = AppColors.basicOrange;

      final mergeFlash = MergeFlash(position, color);

      expect(mergeFlash.position, equals(position));
      expect(mergeFlash.color, equals(color));
      expect(mergeFlash.age, equals(0.0));
    });

    test('MergeFlash age should start at zero', () {
      final mergeFlash = MergeFlash(vm.Vector3.zero(), AppColors.basicRed);
      expect(mergeFlash.age, equals(0.0));
    });

    test('MergeFlash age should be mutable', () {
      final mergeFlash = MergeFlash(vm.Vector3.zero(), AppColors.basicBlue);

      mergeFlash.age = 0.5;
      expect(mergeFlash.age, equals(0.5));

      mergeFlash.age = 1.0;
      expect(mergeFlash.age, equals(1.0));
    });

    test('MergeFlash position should be mutable', () {
      final position = vm.Vector3(1.0, 1.0, 1.0);
      final mergeFlash = MergeFlash(position, AppColors.basicGreen);

      // Modify position
      mergeFlash.position.setValues(5.0, 6.0, 7.0);
      expect(mergeFlash.position.x, equals(5.0));
      expect(mergeFlash.position.y, equals(6.0));
      expect(mergeFlash.position.z, equals(7.0));
    });

    test('MergeFlash should handle different colors', () {
      final colors = [
        AppColors.basicRed,
        AppColors.basicGreen,
        AppColors.basicBlue,
        AppColors.basicYellow,
        AppColors.basicPurple,
        AppColors.basicOrange,
      ];

      for (final color in colors) {
        final mergeFlash = MergeFlash(vm.Vector3.zero(), color);
        expect(mergeFlash.color, equals(color));
      }
    });

    test('MergeFlash should handle negative positions', () {
      final position = vm.Vector3(-10.0, -20.0, -30.0);
      final mergeFlash = MergeFlash(position, AppColors.basicCyan);

      expect(mergeFlash.position.x, equals(-10.0));
      expect(mergeFlash.position.y, equals(-20.0));
      expect(mergeFlash.position.z, equals(-30.0));
    });

    test('MergeFlash should handle negative age values', () {
      final mergeFlash = MergeFlash(vm.Vector3.zero(), AppColors.basicPink);

      mergeFlash.age = -0.5;
      expect(mergeFlash.age, equals(-0.5));
    });

    test('MergeFlash should handle large age values', () {
      final mergeFlash = MergeFlash(vm.Vector3.zero(), AppColors.basicIndigo);

      mergeFlash.age = 100.0;
      expect(mergeFlash.age, equals(100.0));
    });
  });
}
