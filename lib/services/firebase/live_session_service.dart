import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart'
    show kDebugMode, debugPrint, visibleForTesting;
import 'package:graviton/features/auth/data/auth_service.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/services/firebase/realtime_database_service.dart';

/// Represents a live simulation session that can be shared with other users
///
/// Contains metadata about the session including the scenario being run,
/// the host user, and current viewer count.
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
}

/// Service for managing live simulation sessions using Firebase Realtime Database
///
/// This service enables real-time simulation sharing between users, allowing:
/// - Hosting a live session that others can view
/// - Browsing and joining active sessions
/// - Real-time presence tracking for viewers
/// - Live simulation state updates
///
/// Example usage:
/// ```dart
/// final liveService = LiveSessionService.instance;
///
/// // Start hosting a session
/// final sessionId = await liveService.startHosting(
///   scenarioName: 'Solar System',
///   displayName: 'John',
/// );
///
/// // Update simulation state
/// await liveService.updateSessionState(
///   isRunning: true,
///   timeScale: 4.0,
/// );
///
/// // Stop hosting
/// await liveService.stopHosting();
/// ```
class LiveSessionService {
  static LiveSessionService? _instance;

  /// Returns the singleton instance of [LiveSessionService]
  static LiveSessionService get instance =>
      _instance ??= LiveSessionService._();

  LiveSessionService._();

  // Database paths
  static const String _sessionsPath = 'live_sessions';
  static const String _viewersPath = 'viewers';

  // Session state
  String? _currentSessionId;
  bool _isHosting = false;
  StreamSubscription<dynamic>? _sessionSubscription;
  StreamSubscription<MapEntry<String?, dynamic>>? _viewerAddedSubscription;
  StreamSubscription<MapEntry<String?, dynamic>>? _viewerRemovedSubscription;

  // Callbacks
  void Function(int viewerCount)? _onViewerCountChanged;
  void Function(LiveSession session)? _onSessionUpdated;

  /// The ID of the current session being hosted or viewed
  String? get currentSessionId => _currentSessionId;

  /// Whether the current user is hosting a session
  bool get isHosting => _isHosting;

  /// Reference to the Realtime Database service
  RealtimeDatabaseService get _rtdb => RealtimeDatabaseService.instance;

  // =============================================================================
  // HOSTING
  // =============================================================================

  /// Start hosting a new live session
  ///
  /// Creates a new session in the database and sets up presence tracking.
  ///
  /// [scenarioName] The name of the scenario being simulated
  /// [displayName] The display name of the host (optional, uses auth name)
  ///
  /// Returns the session ID if successful, null otherwise.
  Future<String?> startHosting({
    required String scenarioName,
    String? displayName,
  }) async {
    if (_isHosting) {
      debugPrint('LiveSessionService: Already hosting a session');
      return _currentSessionId;
    }

    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null) {
      debugPrint('LiveSessionService: User not authenticated');
      return null;
    }

    try {
      final now = DateTime.now();
      final session = LiveSession(
        id: '', // Will be set by push
        hostId: user.uid,
        hostName: displayName ?? user.displayName ?? 'Anonymous',
        scenarioName: scenarioName,
        isRunning: false,
        timeScale: 1.0,
        viewerCount: 0,
        createdAt: now,
        updatedAt: now,
      );

      // Create the session
      final sessionId = await _rtdb.push(_sessionsPath, session.toMap());
      if (sessionId == null) {
        debugPrint('LiveSessionService: Failed to create session');
        return null;
      }

      _currentSessionId = sessionId;
      _isHosting = true;

      // Set up presence for automatic cleanup on disconnect
      await _setupHostPresence(sessionId);

      // Start listening for viewer changes
      _startViewerTracking(sessionId);

      if (kDebugMode) {
        debugPrint('LiveSessionService: Started hosting session $sessionId');
      }

      await FirebaseService.instance.logEvent(
        'live_session_started',
        parameters: {'scenario': scenarioName},
      );

      return sessionId;
    } catch (e, stackTrace) {
      debugPrint('LiveSessionService: Failed to start hosting: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return null;
    }
  }

  /// Update the current session state
  ///
  /// [isRunning] Whether the simulation is running
  /// [timeScale] The current time scale
  /// [scenarioName] Updated scenario name (optional)
  Future<bool> updateSessionState({
    bool? isRunning,
    double? timeScale,
    String? scenarioName,
  }) async {
    if (!_isHosting || _currentSessionId == null) {
      debugPrint('LiveSessionService: Not hosting a session');
      return false;
    }

    final updates = <String, dynamic>{
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };

    if (isRunning != null) updates['isRunning'] = isRunning;
    if (timeScale != null) updates['timeScale'] = timeScale;
    if (scenarioName != null) updates['scenarioName'] = scenarioName;

    return _rtdb.updateValues('$_sessionsPath/$_currentSessionId', updates);
  }

  /// Stop hosting the current session
  ///
  /// Removes the session from the database and cleans up resources.
  Future<bool> stopHosting() async {
    if (!_isHosting || _currentSessionId == null) {
      debugPrint('LiveSessionService: Not hosting a session');
      return false;
    }

    try {
      // Cancel subscriptions
      await _viewerAddedSubscription?.cancel();
      await _viewerRemovedSubscription?.cancel();
      _viewerAddedSubscription = null;
      _viewerRemovedSubscription = null;

      // Remove the session
      await _rtdb.remove('$_sessionsPath/$_currentSessionId');

      if (kDebugMode) {
        debugPrint(
          'LiveSessionService: Stopped hosting session $_currentSessionId',
        );
      }

      await FirebaseService.instance.logEvent('live_session_ended');

      _currentSessionId = null;
      _isHosting = false;

      return true;
    } catch (e, stackTrace) {
      debugPrint('LiveSessionService: Failed to stop hosting: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  /// Set up presence tracking for the host
  Future<void> _setupHostPresence(String sessionId) async {
    final sessionRef = _rtdb.ref('$_sessionsPath/$sessionId');
    if (sessionRef == null) return;

    // When host disconnects, remove the entire session
    await sessionRef.onDisconnect().remove();
  }

  /// Start tracking viewer additions/removals
  void _startViewerTracking(String sessionId) {
    final viewersPath = '$_sessionsPath/$sessionId/$_viewersPath';

    _viewerAddedSubscription = _rtdb.onChildAdded(viewersPath).listen((_) {
      _updateViewerCount(sessionId);
    });

    _viewerRemovedSubscription = _rtdb.onChildRemoved(viewersPath).listen((_) {
      _updateViewerCount(sessionId);
    });
  }

  /// Update the viewer count and notify callback
  Future<void> _updateViewerCount(String sessionId) async {
    final viewersPath = '$_sessionsPath/$sessionId/$_viewersPath';
    final viewers = await _rtdb.getMap(viewersPath);
    final count = viewers?.length ?? 0;

    // Update the count in the session
    await _rtdb.updateValues('$_sessionsPath/$sessionId', {
      'viewerCount': count,
    });

    _onViewerCountChanged?.call(count);
  }

  // =============================================================================
  // VIEWING
  // =============================================================================

  /// Get a stream of all active live sessions
  ///
  /// Returns a stream that emits a list of active sessions whenever
  /// the session list changes.
  Stream<List<LiveSession>> getActiveSessions() {
    return _rtdb.onValue(_sessionsPath).map((data) {
      if (data == null) return <LiveSession>[];

      final sessionsMap = Map<String, dynamic>.from(data as Map);
      return sessionsMap.entries.map((entry) {
        final sessionData = Map<String, dynamic>.from(entry.value as Map);
        return LiveSession.fromMap(entry.key, sessionData);
      }).toList();
    });
  }

  /// Join a live session as a viewer
  ///
  /// [sessionId] The ID of the session to join
  /// [onSessionUpdated] Callback when session state changes
  ///
  /// Returns true if successfully joined.
  Future<bool> joinSession(
    String sessionId, {
    void Function(LiveSession session)? onSessionUpdated,
  }) async {
    if (_isHosting) {
      debugPrint('LiveSessionService: Cannot join while hosting');
      return false;
    }

    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null) {
      debugPrint('LiveSessionService: User not authenticated');
      return false;
    }

    try {
      _currentSessionId = sessionId;
      _onSessionUpdated = onSessionUpdated;

      // Add self to viewers
      final viewerPath = '$_sessionsPath/$sessionId/$_viewersPath/${user.uid}';
      await _rtdb.setValue(viewerPath, {
        'joinedAt': ServerValue.timestamp,
        'displayName': user.displayName ?? 'Anonymous',
      });

      // Set up presence for automatic removal on disconnect
      final viewerRef = _rtdb.ref(viewerPath);
      await viewerRef?.onDisconnect().remove();

      // Start listening to session updates
      _sessionSubscription = _rtdb.onValue('$_sessionsPath/$sessionId').listen((
        data,
      ) {
        if (data != null && _onSessionUpdated != null) {
          final sessionData = Map<String, dynamic>.from(data as Map);
          _onSessionUpdated!(LiveSession.fromMap(sessionId, sessionData));
        }
      });

      if (kDebugMode) {
        debugPrint('LiveSessionService: Joined session $sessionId');
      }

      await FirebaseService.instance.logEvent('live_session_joined');

      return true;
    } catch (e, stackTrace) {
      debugPrint('LiveSessionService: Failed to join session: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  /// Leave the current session
  ///
  /// Removes the user from the viewers list and cleans up resources.
  Future<bool> leaveSession() async {
    if (_currentSessionId == null || _isHosting) {
      return false;
    }

    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null) return false;

    try {
      // Cancel session subscription
      await _sessionSubscription?.cancel();
      _sessionSubscription = null;

      // Remove from viewers
      final viewerPath =
          '$_sessionsPath/$_currentSessionId/$_viewersPath/${user.uid}';
      await _rtdb.remove(viewerPath);

      if (kDebugMode) {
        debugPrint('LiveSessionService: Left session $_currentSessionId');
      }

      await FirebaseService.instance.logEvent('live_session_left');

      _currentSessionId = null;
      _onSessionUpdated = null;

      return true;
    } catch (e, stackTrace) {
      debugPrint('LiveSessionService: Failed to leave session: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  // =============================================================================
  // CALLBACKS
  // =============================================================================

  /// Set callback for viewer count changes (host only)
  void setOnViewerCountChanged(void Function(int count)? callback) {
    _onViewerCountChanged = callback;
  }

  // =============================================================================
  // CLEANUP
  // =============================================================================

  /// Clean up all resources
  ///
  /// Call this when the user signs out or the app is closing.
  Future<void> dispose() async {
    if (_isHosting) {
      await stopHosting();
    } else if (_currentSessionId != null) {
      await leaveSession();
    }

    _onViewerCountChanged = null;
    _onSessionUpdated = null;
  }

  // =============================================================================
  // TESTING SUPPORT
  // =============================================================================

  /// Reset the singleton instance for testing purposes
  @visibleForTesting
  static void resetForTesting() {
    _instance?.dispose();
    _instance = null;
  }
}
