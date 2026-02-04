import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/usage_data.dart';

void main() {
  group('UsageData', () {
    group('constructor', () {
      test('creates instance with required fields', () {
        final now = DateTime.now();
        final usageData = UsageData(
          sessionsHostedToday: 2,
          totalSessionTimeSeconds: 1800,
          date: now,
        );

        expect(usageData.sessionsHostedToday, equals(2));
        expect(usageData.totalSessionTimeSeconds, equals(1800));
        expect(usageData.date, equals(now));
        expect(usageData.currentSessionStart, isNull);
      });

      test('creates instance with optional currentSessionStart', () {
        final now = DateTime.now();
        final sessionStart = now.subtract(const Duration(minutes: 5));
        final usageData = UsageData(
          sessionsHostedToday: 1,
          totalSessionTimeSeconds: 600,
          date: now,
          currentSessionStart: sessionStart,
        );

        expect(usageData.currentSessionStart, equals(sessionStart));
      });
    });

    group('empty factory', () {
      test('creates empty UsageData with default values', () {
        final empty = UsageData.empty;

        expect(empty.sessionsHostedToday, equals(0));
        expect(empty.totalSessionTimeSeconds, equals(0));
        expect(empty.currentSessionStart, isNull);
      });

      test('empty date is today', () {
        final empty = UsageData.empty;
        final now = DateTime.now();

        expect(empty.date.year, equals(now.year));
        expect(empty.date.month, equals(now.month));
        expect(empty.date.day, equals(now.day));
      });
    });

    group('isInSession', () {
      test('returns false when currentSessionStart is null', () {
        final usageData = UsageData(
          sessionsHostedToday: 0,
          totalSessionTimeSeconds: 0,
          date: DateTime.now(),
        );

        expect(usageData.isInSession, isFalse);
      });

      test('returns true when currentSessionStart is set', () {
        final usageData = UsageData(
          sessionsHostedToday: 1,
          totalSessionTimeSeconds: 0,
          date: DateTime.now(),
          currentSessionStart: DateTime.now(),
        );

        expect(usageData.isInSession, isTrue);
      });
    });

    group('currentSessionDurationSeconds', () {
      test('returns 0 when not in session', () {
        final usageData = UsageData(
          sessionsHostedToday: 0,
          totalSessionTimeSeconds: 0,
          date: DateTime.now(),
        );

        expect(usageData.currentSessionDurationSeconds, equals(0));
      });

      test('returns positive value when in session', () {
        final sessionStart = DateTime.now().subtract(
          const Duration(seconds: 30),
        );
        final usageData = UsageData(
          sessionsHostedToday: 1,
          totalSessionTimeSeconds: 0,
          date: DateTime.now(),
          currentSessionStart: sessionStart,
        );

        expect(
          usageData.currentSessionDurationSeconds,
          greaterThanOrEqualTo(30),
        );
      });
    });

    group('totalTimeIncludingCurrent', () {
      test('equals totalSessionTimeSeconds when not in session', () {
        final usageData = UsageData(
          sessionsHostedToday: 2,
          totalSessionTimeSeconds: 1800,
          date: DateTime.now(),
        );

        expect(usageData.totalTimeIncludingCurrent, equals(1800));
      });

      test('includes current session duration when in session', () {
        final sessionStart = DateTime.now().subtract(
          const Duration(seconds: 60),
        );
        final usageData = UsageData(
          sessionsHostedToday: 1,
          totalSessionTimeSeconds: 1800,
          date: DateTime.now(),
          currentSessionStart: sessionStart,
        );

        expect(usageData.totalTimeIncludingCurrent, greaterThanOrEqualTo(1860));
      });
    });

    group('isToday', () {
      test('returns true when date is today', () {
        final usageData = UsageData(
          sessionsHostedToday: 0,
          totalSessionTimeSeconds: 0,
          date: DateTime.now(),
        );

        expect(usageData.isToday, isTrue);
      });

      test('returns false when date is yesterday', () {
        final usageData = UsageData(
          sessionsHostedToday: 0,
          totalSessionTimeSeconds: 0,
          date: DateTime.now().subtract(const Duration(days: 1)),
        );

        expect(usageData.isToday, isFalse);
      });

      test('returns false when date is in the past', () {
        final usageData = UsageData(
          sessionsHostedToday: 0,
          totalSessionTimeSeconds: 0,
          date: DateTime(2020, 1, 1),
        );

        expect(usageData.isToday, isFalse);
      });
    });

    group('copyWith', () {
      test('copies all fields when no arguments provided', () {
        final original = UsageData(
          sessionsHostedToday: 3,
          totalSessionTimeSeconds: 2700,
          date: DateTime(2024, 6, 15),
          currentSessionStart: DateTime(2024, 6, 15, 10, 30),
        );
        final copy = original.copyWith();

        expect(copy.sessionsHostedToday, equals(original.sessionsHostedToday));
        expect(
          copy.totalSessionTimeSeconds,
          equals(original.totalSessionTimeSeconds),
        );
        expect(copy.date, equals(original.date));
        expect(copy.currentSessionStart, equals(original.currentSessionStart));
      });

      test('updates sessionsHostedToday', () {
        final original = UsageData.empty;
        final updated = original.copyWith(sessionsHostedToday: 5);

        expect(updated.sessionsHostedToday, equals(5));
      });

      test('updates totalSessionTimeSeconds', () {
        final original = UsageData.empty;
        final updated = original.copyWith(totalSessionTimeSeconds: 3600);

        expect(updated.totalSessionTimeSeconds, equals(3600));
      });

      test('clears currentSessionStart when clearCurrentSession is true', () {
        final original = UsageData(
          sessionsHostedToday: 1,
          totalSessionTimeSeconds: 0,
          date: DateTime.now(),
          currentSessionStart: DateTime.now(),
        );
        final updated = original.copyWith(clearCurrentSession: true);

        expect(updated.currentSessionStart, isNull);
      });
    });

    group('JSON serialization', () {
      test('fromJson creates valid instance', () {
        final json = {
          'sessions_hosted_today': 2,
          'total_session_time_seconds': 1800,
          'date': '2024-06-15T00:00:00.000',
        };

        final usageData = UsageData.fromJson(json);

        expect(usageData.sessionsHostedToday, equals(2));
        expect(usageData.totalSessionTimeSeconds, equals(1800));
        expect(usageData.date.year, equals(2024));
        expect(usageData.date.month, equals(6));
        expect(usageData.date.day, equals(15));
      });

      test('fromJson handles missing optional fields', () {
        final json = <String, dynamic>{};

        final usageData = UsageData.fromJson(json);

        expect(usageData.sessionsHostedToday, equals(0));
        expect(usageData.totalSessionTimeSeconds, equals(0));
        expect(usageData.currentSessionStart, isNull);
      });

      test('fromJson parses currentSessionStart', () {
        final json = {
          'sessions_hosted_today': 1,
          'total_session_time_seconds': 600,
          'date': '2024-06-15T00:00:00.000',
          'current_session_start': '2024-06-15T10:30:00.000',
        };

        final usageData = UsageData.fromJson(json);

        expect(usageData.currentSessionStart, isNotNull);
        expect(usageData.currentSessionStart!.hour, equals(10));
        expect(usageData.currentSessionStart!.minute, equals(30));
      });

      test('toJson creates valid map', () {
        final usageData = UsageData(
          sessionsHostedToday: 2,
          totalSessionTimeSeconds: 1800,
          date: DateTime(2024, 6, 15),
        );

        final json = usageData.toJson();

        expect(json['sessions_hosted_today'], equals(2));
        expect(json['total_session_time_seconds'], equals(1800));
        expect(json['date'], contains('2024-06-15'));
      });

      test('toJson includes currentSessionStart when present', () {
        final usageData = UsageData(
          sessionsHostedToday: 1,
          totalSessionTimeSeconds: 0,
          date: DateTime(2024, 6, 15),
          currentSessionStart: DateTime(2024, 6, 15, 10, 30),
        );

        final json = usageData.toJson();

        expect(json['current_session_start'], contains('2024-06-15'));
      });

      test('round-trip serialization preserves data', () {
        final original = UsageData(
          sessionsHostedToday: 3,
          totalSessionTimeSeconds: 2700,
          date: DateTime(2024, 6, 15),
          currentSessionStart: DateTime(2024, 6, 15, 10, 30),
        );

        final json = original.toJson();
        final restored = UsageData.fromJson(json);

        expect(
          restored.sessionsHostedToday,
          equals(original.sessionsHostedToday),
        );
        expect(
          restored.totalSessionTimeSeconds,
          equals(original.totalSessionTimeSeconds),
        );
      });
    });

    group('equality', () {
      test('equal instances have same hashCode', () {
        final date = DateTime(2024, 6, 15);
        final a = UsageData(
          sessionsHostedToday: 2,
          totalSessionTimeSeconds: 1800,
          date: date,
        );
        final b = UsageData(
          sessionsHostedToday: 2,
          totalSessionTimeSeconds: 1800,
          date: date,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different instances are not equal', () {
        final date = DateTime(2024, 6, 15);
        final a = UsageData(
          sessionsHostedToday: 2,
          totalSessionTimeSeconds: 1800,
          date: date,
        );
        final b = UsageData(
          sessionsHostedToday: 3,
          totalSessionTimeSeconds: 1800,
          date: date,
        );

        expect(a, isNot(equals(b)));
      });

      test('identical instance equals itself', () {
        final usageData = UsageData.empty;
        expect(usageData == usageData, isTrue);
      });
    });

    group('toString', () {
      test('returns readable string', () {
        final usageData = UsageData(
          sessionsHostedToday: 2,
          totalSessionTimeSeconds: 1800,
          date: DateTime(2024, 6, 15),
        );

        final str = usageData.toString();

        expect(str, contains('UsageData'));
        expect(str, contains('sessionsHostedToday: 2'));
        expect(str, contains('totalSessionTimeSeconds: 1800'));
      });
    });
  });
}
