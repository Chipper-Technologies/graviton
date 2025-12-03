import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Utility functions for integration tests
class IntegrationTestUtils {
  /// Scrolls down in a ListView to make content visible
  ///
  /// [tester] The widget tester instance
  /// [offset] The scroll offset (negative values scroll down, positive scroll up)
  static Future<void> scrollDown(
    WidgetTester tester, {
    double offset = -500,
  }) async {
    await tester.drag(find.byType(ListView), Offset(0, offset));
    await tester.pumpAndSettle();
  }

  /// Scrolls up in a ListView to make content visible
  ///
  /// [tester] The widget tester instance
  /// [offset] The scroll offset (positive values scroll up, negative scroll down)
  static Future<void> scrollUp(
    WidgetTester tester, {
    double offset = 500,
  }) async {
    await tester.drag(find.byType(ListView), Offset(0, offset));
    await tester.pumpAndSettle();
  }
}
