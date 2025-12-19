/// Represents a live simulation session that can be shared with other users
///
/// Contains metadata about the session including the scenario being run,
/// the host user, and current viewer count.
///
/// This model is used by [LiveSessionService] to represent real-time
/// simulation sessions stored in Firebase Realtime Database.
///
/// Example usage:
/// ```dart
/// final session = LiveSession(
///   id: 'abc123',
///   hostId: 'user-456',
///   hostName: 'John',
///   scenarioName: 'Solar System',
///   isRunning: true,
///   timeScale: 4.0,
///   viewerCount: 3,
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
/// );
///
/// // Serialize for database
/// final map = session.toMap();
///
/// // Deserialize from database
/// final restored = LiveSession.fromMap('abc123', map);
/// ```
class LiveSession {
  /// Unique identifier for the session
  final String id;

  /// User ID of the session host
  final String hostId;

  /// Display name of the host
  final String hostName;

  /// Name of the scenario being simulated
  final String scenarioName;

  /// Whether the simulation is currently running
  final bool isRunning;

  /// Current time scale of the simulation
  final double timeScale;

  /// Number of active viewers (excluding host)
  final int viewerCount;

  /// Timestamp when session was created
  final DateTime createdAt;

  /// Timestamp of last update
  final DateTime updatedAt;

  /// Creates a new [LiveSession] instance
  ///
  /// All fields are required to ensure complete session data.
  const LiveSession({
    required this.id,
    required this.hostId,
    required this.hostName,
    required this.scenarioName,
    required this.isRunning,
    required this.timeScale,
    required this.viewerCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a LiveSession from a database map
  ///
  /// [id] The session identifier from the database key
  /// [map] The session data from the database value
  ///
  /// Missing fields will use sensible defaults:
  /// - `hostId`: empty string
  /// - `hostName`: 'Unknown'
  /// - `scenarioName`: 'Custom'
  /// - `isRunning`: false
  /// - `timeScale`: 1.0
  /// - `viewerCount`: 0
  /// - `createdAt`/`updatedAt`: current time
  factory LiveSession.fromMap(String id, Map<String, dynamic> map) {
    return LiveSession(
      id: id,
      hostId: map['hostId'] as String? ?? '',
      hostName: map['hostName'] as String? ?? 'Unknown',
      scenarioName: map['scenarioName'] as String? ?? 'Custom',
      isRunning: map['isRunning'] as bool? ?? false,
      timeScale: (map['timeScale'] as num?)?.toDouble() ?? 1.0,
      viewerCount: map['viewerCount'] as int? ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Convert session to a map for database storage
  ///
  /// Note: The `id` field is not included as it is typically used
  /// as the database key rather than stored in the value.
  Map<String, dynamic> toMap() {
    return {
      'hostId': hostId,
      'hostName': hostName,
      'scenarioName': scenarioName,
      'isRunning': isRunning,
      'timeScale': timeScale,
      'viewerCount': viewerCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Create a copy with updated fields
  ///
  /// Any field not specified will retain its current value.
  LiveSession copyWith({
    String? id,
    String? hostId,
    String? hostName,
    String? scenarioName,
    bool? isRunning,
    double? timeScale,
    int? viewerCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LiveSession(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      scenarioName: scenarioName ?? this.scenarioName,
      isRunning: isRunning ?? this.isRunning,
      timeScale: timeScale ?? this.timeScale,
      viewerCount: viewerCount ?? this.viewerCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'LiveSession(id: $id, hostName: $hostName, '
        'scenarioName: $scenarioName, isRunning: $isRunning, '
        'viewerCount: $viewerCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiveSession &&
        other.id == id &&
        other.hostId == hostId &&
        other.hostName == hostName &&
        other.scenarioName == scenarioName &&
        other.isRunning == isRunning &&
        other.timeScale == timeScale &&
        other.viewerCount == viewerCount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      hostId,
      hostName,
      scenarioName,
      isRunning,
      timeScale,
      viewerCount,
      createdAt,
      updatedAt,
    );
  }
}
