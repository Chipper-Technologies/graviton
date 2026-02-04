/// Model representing user's usage for the current day
///
/// Tracks session counts and durations for enforcing free tier limits.
class UsageData {
  /// Number of sessions hosted today
  final int sessionsHostedToday;

  /// Total session time today in seconds
  final int totalSessionTimeSeconds;

  /// Date of the usage data (for reset detection)
  final DateTime date;

  /// Current session start time (if in session)
  final DateTime? currentSessionStart;

  const UsageData({
    required this.sessionsHostedToday,
    required this.totalSessionTimeSeconds,
    required this.date,
    this.currentSessionStart,
  });

  /// Default empty usage data
  static UsageData get empty => UsageData(
    sessionsHostedToday: 0,
    totalSessionTimeSeconds: 0,
    date: DateTime.now(),
  );

  /// Whether the user is currently in a session
  bool get isInSession => currentSessionStart != null;

  /// Current session duration in seconds
  int get currentSessionDurationSeconds {
    if (currentSessionStart == null) return 0;
    return DateTime.now().difference(currentSessionStart!).inSeconds;
  }

  /// Total time including current session
  int get totalTimeIncludingCurrent {
    return totalSessionTimeSeconds + currentSessionDurationSeconds;
  }

  /// Create a copy with modified values
  UsageData copyWith({
    int? sessionsHostedToday,
    int? totalSessionTimeSeconds,
    DateTime? date,
    DateTime? currentSessionStart,
    bool clearCurrentSession = false,
  }) {
    return UsageData(
      sessionsHostedToday: sessionsHostedToday ?? this.sessionsHostedToday,
      totalSessionTimeSeconds:
          totalSessionTimeSeconds ?? this.totalSessionTimeSeconds,
      date: date ?? this.date,
      currentSessionStart: clearCurrentSession
          ? null
          : (currentSessionStart ?? this.currentSessionStart),
    );
  }

  /// Create from JSON (SharedPreferences storage)
  factory UsageData.fromJson(Map<String, dynamic> json) {
    return UsageData(
      sessionsHostedToday: json['sessions_hosted_today'] as int? ?? 0,
      totalSessionTimeSeconds: json['total_session_time_seconds'] as int? ?? 0,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      currentSessionStart: json['current_session_start'] != null
          ? DateTime.parse(json['current_session_start'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sessions_hosted_today': sessionsHostedToday,
      'total_session_time_seconds': totalSessionTimeSeconds,
      'date': date.toIso8601String(),
      if (currentSessionStart != null)
        'current_session_start': currentSessionStart!.toIso8601String(),
    };
  }

  /// Check if this usage data is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsageData &&
        other.sessionsHostedToday == sessionsHostedToday &&
        other.totalSessionTimeSeconds == totalSessionTimeSeconds &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day &&
        other.currentSessionStart == currentSessionStart;
  }

  @override
  int get hashCode {
    return Object.hash(
      sessionsHostedToday,
      totalSessionTimeSeconds,
      date.year,
      date.month,
      date.day,
      currentSessionStart,
    );
  }

  @override
  String toString() {
    return 'UsageData('
        'sessionsHostedToday: $sessionsHostedToday, '
        'totalSessionTimeSeconds: $totalSessionTimeSeconds, '
        'date: ${date.toIso8601String()}, '
        'currentSessionStart: $currentSessionStart)';
  }
}
