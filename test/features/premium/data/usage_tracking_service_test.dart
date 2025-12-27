import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/data/usage_tracking_service.dart';
import 'package:graviton/features/premium/domain/usage_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UsageTrackingService', () {
    late UsageTrackingService service;

    setUp(() async {
      // Reset SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      service = UsageTrackingService.instance;
      await service.initialize();
    });

    test('initial usage data has zero sessions', () {
      final usageData = service.usageData;
      expect(usageData, isA<UsageData>());
      expect(usageData.sessionsHostedToday, equals(0));
      expect(usageData.currentSessionDurationSeconds, equals(0));
    });

    test('canStartSession returns true when under limit', () {
      const limit = 3;
      expect(service.canStartSession(limit), isTrue);
    });

    test('startSession initializes session tracking', () {
      expect(service.usageData.isInSession, isFalse);
      service.startSession();
      expect(service.usageData.isInSession, isTrue);
    });

    test('endSession stops session tracking', () {
      service.startSession();
      expect(service.usageData.isInSession, isTrue);
      service.endSession();
      expect(service.usageData.isInSession, isFalse);
    });

    test('hasExceededDurationLimit returns false for short sessions', () {
      const limitMinutes = 15;
      service.startSession();
      // New session should not exceed limit immediately
      expect(service.hasExceededDurationLimit(limitMinutes), isFalse);
      service.endSession();
    });

    test('getRemainingSessionTime returns positive value for new session', () {
      const limitMinutes = 15;
      service.startSession();
      final remaining = service.getRemainingSessionTime(limitMinutes);
      expect(remaining, greaterThan(0));
      expect(remaining, lessThanOrEqualTo(limitMinutes * 60));
      service.endSession();
    });
  });
}
