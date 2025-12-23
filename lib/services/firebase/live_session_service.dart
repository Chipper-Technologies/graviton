import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart'
    show kDebugMode, debugPrint, visibleForTesting;
import 'package:graviton/features/auth/data/auth_service.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/services/firebase/realtime_database_service.dart';

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
  static const String _statePath = 'state';

  // State sync configuration
  /// Minimum interval between state broadcasts to avoid flooding
  static const Duration _minBroadcastInterval = Duration(milliseconds: 100);

  // Session state
  String? _currentSessionId;
  bool _isHosting = false;
  StreamSubscription<dynamic>? _sessionSubscription;
  StreamSubscription<MapEntry<String?, dynamic>>? _viewerAddedSubscription;
  StreamSubscription<MapEntry<String?, dynamic>>? _viewerRemovedSubscription;
  StreamSubscription<dynamic>? _stateSubscription;
  DateTime? _lastBroadcastTime;

  // Callbacks
  void Function(int viewerCount)? _onViewerCountChanged;
  void Function(LiveSession session)? _onSessionUpdated;
  void Function(SimulationSnapshot snapshot)? _onStateReceived;

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
  /// [password] Optional password for viewers to join (enables password protection)
  ///
  /// Returns the session ID if successful, null otherwise.
  Future<String?> startHosting({
    required String scenarioName,
    String? displayName,
    String? password,
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

      // Hash the password if provided
      String? passwordHash;
      if (password != null && password.isNotEmpty) {
        passwordHash = _hashPassword(password);
      }

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
        isPasswordProtected: passwordHash != null,
        passwordHash: passwordHash,
      );

      // Create the session - include password hash in database
      final sessionId = await _rtdb.push(
        _sessionsPath,
        session.toMap(includePasswordHash: true),
      );
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

    _viewerAddedSubscription = _rtdb
        .onChildAdded(viewersPath)
        .listen(
          (_) {
            _updateViewerCount(sessionId);
          },
          onError: (Object error, StackTrace stackTrace) {
            debugPrint(
              'LiveSessionService: Viewer added subscription error: $error',
            );
            if (kDebugMode) {
              debugPrint('Stack trace: $stackTrace');
            }
            FirebaseService.instance.recordError(error, stackTrace);
          },
          cancelOnError: false,
        );

    _viewerRemovedSubscription = _rtdb
        .onChildRemoved(viewersPath)
        .listen(
          (_) {
            _updateViewerCount(sessionId);
          },
          onError: (Object error, StackTrace stackTrace) {
            debugPrint(
              'LiveSessionService: Viewer removed subscription error: $error',
            );
            if (kDebugMode) {
              debugPrint('Stack trace: $stackTrace');
            }
            FirebaseService.instance.recordError(error, stackTrace);
          },
          cancelOnError: false,
        );
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
  /// the session list changes. Handles malformed data gracefully by
  /// skipping invalid entries and logging errors in debug mode.
  Stream<List<LiveSession>> getActiveSessions() {
    return _rtdb
        .onValue(_sessionsPath)
        .map((data) {
          if (data == null) return <LiveSession>[];

          // Validate that data is a Map
          if (data is! Map) {
            debugPrint(
              'LiveSessionService: Expected Map but got ${data.runtimeType}',
            );
            return <LiveSession>[];
          }

          final sessions = <LiveSession>[];
          final sessionsMap = Map<String, dynamic>.from(data);

          for (final entry in sessionsMap.entries) {
            try {
              // Skip if value is not a Map
              if (entry.value is! Map) {
                if (kDebugMode) {
                  debugPrint(
                    'LiveSessionService: Skipping invalid session entry '
                    '"${entry.key}" - expected Map but got '
                    '${entry.value.runtimeType}',
                  );
                }
                continue;
              }

              final sessionData = Map<String, dynamic>.from(entry.value as Map);
              sessions.add(LiveSession.fromMap(entry.key, sessionData));
            } catch (e) {
              // Log error but continue processing other sessions
              if (kDebugMode) {
                debugPrint(
                  'LiveSessionService: Error parsing session "${entry.key}": $e',
                );
              }
            }
          }

          return sessions;
        })
        .handleError((Object error, StackTrace stackTrace) {
          debugPrint(
            'LiveSessionService: Error in getActiveSessions stream: $error',
          );
          if (kDebugMode) {
            debugPrint('Stack trace: $stackTrace');
          }
          // Return empty list on error to prevent stream from terminating
          return <LiveSession>[];
        });
  }

  /// Join a live session as a viewer
  ///
  /// [sessionId] The ID of the session to join
  /// [password] The password for password-protected sessions
  /// [onSessionUpdated] Callback when session state changes
  ///
  /// Returns true if successfully joined, false if password is incorrect
  /// or the session doesn't exist.
  Future<bool> joinSession(
    String sessionId, {
    String? password,
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
      // Check if session is password protected and verify password
      final storedHash = await _getSessionPasswordHash(sessionId);
      if (storedHash != null) {
        if (password == null || password.isEmpty) {
          debugPrint('LiveSessionService: Password required but not provided');
          return false;
        }
        if (!_verifyPassword(password, storedHash)) {
          debugPrint('LiveSessionService: Incorrect password');
          return false;
        }
      }

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
      _sessionSubscription = _rtdb
          .onValue('$_sessionsPath/$sessionId')
          .listen(
            (data) {
              if (data == null || _onSessionUpdated == null) return;

              try {
                // Validate data is a Map before parsing
                if (data is! Map) {
                  if (kDebugMode) {
                    debugPrint(
                      'LiveSessionService: Session data is not a Map, '
                      'got ${data.runtimeType}',
                    );
                  }
                  return;
                }

                final sessionData = Map<String, dynamic>.from(data);
                _onSessionUpdated!(LiveSession.fromMap(sessionId, sessionData));
              } catch (e, stackTrace) {
                debugPrint(
                  'LiveSessionService: Error parsing session update: $e',
                );
                if (kDebugMode) {
                  debugPrint('Stack trace: $stackTrace');
                }
                // Don't rethrow - allow stream to continue
              }
            },
            onError: (Object error, StackTrace stackTrace) {
              debugPrint(
                'LiveSessionService: Session subscription error: $error',
              );
              if (kDebugMode) {
                debugPrint('Stack trace: $stackTrace');
              }
              FirebaseService.instance.recordError(error, stackTrace);
              // Stream will continue listening after error
            },
            cancelOnError: false,
          );

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
      await _stateSubscription?.cancel();
      _stateSubscription = null;

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
      _onStateReceived = null;

      return true;
    } catch (e, stackTrace) {
      debugPrint('LiveSessionService: Failed to leave session: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  // =============================================================================
  // STATE SYNC
  // =============================================================================

  /// Broadcast simulation state to all viewers (host only)
  ///
  /// [snapshot] The current simulation state to broadcast
  ///
  /// Returns true if successfully broadcast.
  /// Rate-limited to prevent flooding the database.
  Future<bool> broadcastState(SimulationSnapshot snapshot) async {
    if (!_isHosting || _currentSessionId == null) {
      debugPrint('LiveSessionService: Cannot broadcast - not hosting');
      return false;
    }

    // Rate limiting
    final now = DateTime.now();
    if (_lastBroadcastTime != null &&
        now.difference(_lastBroadcastTime!) < _minBroadcastInterval) {
      return false; // Skip this update, too soon
    }
    _lastBroadcastTime = now;

    try {
      final statePath = '$_sessionsPath/$_currentSessionId/$_statePath';
      final data = snapshot.toMap();

      // Update both the state sub-path and root session metadata
      await Future.wait([
        _rtdb.setValue(statePath, data),
        _rtdb.updateValues('$_sessionsPath/$_currentSessionId', {
          'isRunning': snapshot.isRunning,
          'timeScale': snapshot.timeScale,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        }),
      ]);

      return true;
    } catch (e, stackTrace) {
      debugPrint('LiveSessionService: Failed to broadcast state: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  /// Start receiving simulation state updates (viewer only)
  ///
  /// [onStateReceived] Callback when new state is received from host
  void startStateSync({
    required void Function(SimulationSnapshot snapshot) onStateReceived,
  }) {
    if (_isHosting || _currentSessionId == null) {
      debugPrint('LiveSessionService: Cannot start state sync');
      return;
    }

    _onStateReceived = onStateReceived;
    final statePath = '$_sessionsPath/$_currentSessionId/$_statePath';

    _stateSubscription = _rtdb
        .onValue(statePath)
        .listen(
          (data) {
            if (data == null || _onStateReceived == null) return;

            try {
              if (data is! Map) {
                if (kDebugMode) {
                  debugPrint(
                    'LiveSessionService: State data is not a Map, '
                    'got ${data.runtimeType}',
                  );
                }
                return;
              }

              final stateData = Map<String, dynamic>.from(data);
              final snapshot = SimulationSnapshot.fromMap(stateData);
              _onStateReceived!(snapshot);
            } catch (e, stackTrace) {
              debugPrint('LiveSessionService: Error parsing state update: $e');
              if (kDebugMode) {
                debugPrint('Stack trace: $stackTrace');
              }
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            debugPrint('LiveSessionService: State sync error: $error');
            if (kDebugMode) {
              debugPrint('Stack trace: $stackTrace');
            }
            FirebaseService.instance.recordError(error, stackTrace);
          },
          cancelOnError: false,
        );

    if (kDebugMode) {
      debugPrint(
        'LiveSessionService: Started state sync for $_currentSessionId',
      );
    }
  }

  /// Stop receiving simulation state updates
  void stopStateSync() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _onStateReceived = null;
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
    stopStateSync();

    if (_isHosting) {
      await stopHosting();
    } else if (_currentSessionId != null) {
      await leaveSession();
    }

    _onViewerCountChanged = null;
    _onSessionUpdated = null;
    _onStateReceived = null;
    _lastBroadcastTime = null;
  }

  // =============================================================================
  // PASSWORD HANDLING
  // =============================================================================

  /// Hash a password for storage
  ///
  /// Uses a simple hash for live session passwords. This is not meant for
  /// critical security but provides basic protection against casual viewing.
  String _hashPassword(String password) {
    // Use a simple hash combining the password with a salt
    // For production security, use bcrypt or argon2
    const salt = 'graviton_live_session_v1';
    final combined = '$salt$password$salt';
    return combined.hashCode.toRadixString(16);
  }

  /// Verify a password against a stored hash
  bool _verifyPassword(String password, String storedHash) {
    final inputHash = _hashPassword(password);
    return inputHash == storedHash;
  }

  /// Fetch the password hash for a session from the database
  Future<String?> _getSessionPasswordHash(String sessionId) async {
    final path = '$_sessionsPath/$sessionId/passwordHash';
    final hash = await _rtdb.getValue(path);
    return hash as String?;
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
