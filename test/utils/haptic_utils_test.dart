import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/services/haptic_feedback_service.dart';

void main() {
  group('HapticUtils Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    test('tap should call without errors', () {
      expect(() => HapticUtils.tap(), returnsNormally);
    });

    test('toggle should call without errors', () {
      expect(() => HapticUtils.toggle(), returnsNormally);
    });

    test('confirm should call without errors', () {
      expect(() => HapticUtils.confirm(), returnsNormally);
    });

    test('impact should call without errors', () {
      expect(() => HapticUtils.impact(), returnsNormally);
    });

    test('error should call without errors', () {
      expect(() => HapticUtils.error(), returnsNormally);
    });

    test('success should call without errors', () {
      expect(() => HapticUtils.success(), returnsNormally);
    });

    test('navigate should call without errors', () {
      expect(() => HapticUtils.navigate(), returnsNormally);
    });

    test('drag should call without errors', () {
      expect(() => HapticUtils.drag(), returnsNormally);
    });

    test('longPress should call without errors', () {
      expect(() => HapticUtils.longPress(), returnsNormally);
    });

    test('notification should call without errors', () {
      expect(() => HapticUtils.notification(), returnsNormally);
    });

    test('should respect disabled state', () async {
      // Disable haptic feedback
      HapticFeedbackService.instance.setEnabled(false);

      // Should still call without errors when disabled
      expect(() => HapticUtils.tap(), returnsNormally);
      expect(() => HapticUtils.toggle(), returnsNormally);
      expect(() => HapticUtils.confirm(), returnsNormally);
    });

    test('should handle multiple rapid calls', () async {
      // Should handle multiple calls without errors
      expect(() async {
        await HapticUtils.tap();
        await HapticUtils.tap();
        await HapticUtils.tap();
      }, returnsNormally);
    });

    test('should handle mixed feedback types', () async {
      // Should handle different feedback types without errors
      expect(() async {
        await HapticUtils.tap();
        await HapticUtils.toggle();
        await HapticUtils.impact();
        await HapticUtils.error();
      }, returnsNormally);
    });
  });
}
