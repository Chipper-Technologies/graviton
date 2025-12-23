import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;
import 'package:graviton/core/enums/live_session_connection_status.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:graviton/services/firebase/live_session_service.dart';

/// Manages the state of live session hosting and viewing
///
/// This state class bridges the LiveSessionService with the UI layer,
/// providing reactive updates for:
/// - Hosting status and viewer count
/// - Viewing status and session updates
/// - Active session list for browsing
/// - Real-time simulation state synchronization
/// - Connection status and error handling
///
/// Example usage:
/// ```dart
/// final liveState = LiveSessionState();
///
/// // Start hosting
/// await liveState.startHosting(scenarioName: 'Solar System');
///
/// // Broadcast simulation state
/// await liveState.broadcastState(snapshot);
///
/// // Listen to viewer count changes
/// liveState.addListener(() {
///   print('Viewer count: ${liveState.viewerCount}');
///   print('Connection: ${liveState.connectionStatus}');
/// });
/// ```
class LiveSessionState extends ChangeNotifier {
  final LiveSessionService _service = LiveSessionService.instance;

  // Hosting state
  bool _isHosting = false;
  String? _hostedSessionId;
  int _viewerCount = 0;
  String? _hostedScenarioName;
  bool _hostedIsPasswordProtected = false;
  bool _syncCameraWithViewers = true; // Default to syncing camera

  // Viewing state
  bool _isViewing = false;
  String? _viewedSessionId;
  LiveSession? _currentSession;
  SimulationSnapshot? _latestSnapshot;

  // Connection state
  LiveSessionConnectionStatus _connectionStatus =
      LiveSessionConnectionStatus.disconnected;
  String? _lastErrorMessage;
  DateTime? _lastErrorTime;

  // Active sessions stream
  StreamSubscription<List<LiveSession>>? _sessionsSubscription;
  List<LiveSession> _activeSessions = [];
  bool _isLoadingSessions = false;

  // State sync callback for viewer
  void Function(SimulationSnapshot snapshot)? _onSnapshotReceived;

  // =============================================================================
  // GETTERS
  // =============================================================================

  /// Whether the current user is hosting a session
  bool get isHosting => _isHosting;

  /// The ID of the session being hosted
  String? get hostedSessionId => _hostedSessionId;

  /// The session being hosted (null if not hosting)
  /// Looks up the session from activeSessions by hostedSessionId
  LiveSession? get hostedSession {
    if (!_isHosting || _hostedSessionId == null) return null;
    // First try to find in active sessions
    try {
      return _activeSessions.firstWhere((s) => s.id == _hostedSessionId);
    } catch (_) {
      // Fall back to locally stored data
      if (_hostedScenarioName != null) {
        return LiveSession(
          id: _hostedSessionId!,
          hostId: '',
          hostName: '',
          scenarioName: _hostedScenarioName!,
          isRunning: true,
          timeScale: 1.0,
          viewerCount: _viewerCount,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isPasswordProtected: _hostedIsPasswordProtected,
        );
      }
      return null;
    }
  }

  /// Number of viewers in the hosted session
  int get viewerCount => _viewerCount;

  /// Whether the current user is viewing a session
  bool get isViewing => _isViewing;

  /// The ID of the session being viewed
  String? get viewedSessionId => _viewedSessionId;

  /// The current session being viewed (null if not viewing)
  LiveSession? get currentSession => _currentSession;

  /// The latest simulation snapshot received from host (viewer only)
  SimulationSnapshot? get latestSnapshot => _latestSnapshot;

  /// List of active sessions available to join
  List<LiveSession> get activeSessions => _activeSessions;

  /// Whether the session list is currently loading
  bool get isLoadingSessions => _isLoadingSessions;

  /// Whether the user is in any session (hosting or viewing)
  bool get isInSession => _isHosting || _isViewing;

  /// Current connection status for the live session
  LiveSessionConnectionStatus get connectionStatus => _connectionStatus;

  /// The last error message that occurred (null if no error)
  String? get lastErrorMessage => _lastErrorMessage;

  /// When the last error occurred (null if no error)
  DateTime? get lastErrorTime => _lastErrorTime;

  /// Whether there's a recent error (within last 30 seconds)
  bool get hasRecentError =>
      _lastErrorTime != null &&
      DateTime.now().difference(_lastErrorTime!) < const Duration(seconds: 30);

  /// Whether camera movements should be synced to viewers
  bool get syncCameraWithViewers => _syncCameraWithViewers;

  /// Toggle whether camera movements are synced with viewers
  void setSyncCameraWithViewers(bool value) {
    if (_syncCameraWithViewers != value) {
      _syncCameraWithViewers = value;
      notifyListeners();
    }
  }

  // =============================================================================
  // ERROR HANDLING
  // =============================================================================

  /// Set an error state with message
  void _setError(String message) {
    _connectionStatus = LiveSessionConnectionStatus.error;
    _lastErrorMessage = message;
    _lastErrorTime = DateTime.now();
    notifyListeners();
  }

  /// Clear any error state
  void clearError() {
    if (_lastErrorMessage != null) {
      _lastErrorMessage = null;
      _lastErrorTime = null;
      notifyListeners();
    }
  }

  /// Update connection status
  void _setConnectionStatus(LiveSessionConnectionStatus status) {
    if (_connectionStatus != status) {
      _connectionStatus = status;
      notifyListeners();
    }
  }

  // =============================================================================
  // HOSTING
  // =============================================================================

  /// Start hosting a new live session
  ///
  /// [scenarioName] The name of the scenario being simulated
  /// [displayName] Optional display name for the host
  /// [password] Optional password for viewers to join (enables password protection)
  ///
  /// Returns true if hosting started successfully.
  Future<bool> startHosting({
    required String scenarioName,
    String? displayName,
    String? password,
  }) async {
    if (_isHosting) return true;
    if (_isViewing) {
      await stopViewing();
    }

    // Set up the viewer count callback before starting
    _service.setOnViewerCountChanged(_onViewerCountChanged);

    final sessionId = await _service.startHosting(
      scenarioName: scenarioName,
      displayName: displayName,
      password: password,
    );

    if (sessionId != null) {
      _isHosting = true;
      _hostedSessionId = sessionId;
      _hostedScenarioName = scenarioName;
      _hostedIsPasswordProtected = password != null && password.isNotEmpty;
      _viewerCount = 0;
      _setConnectionStatus(LiveSessionConnectionStatus.connected);
      clearError();
      notifyListeners();
      return true;
    }

    _setError('Failed to start hosting session');
    return false;
  }

  /// Update the hosted session state
  ///
  /// Call this when simulation parameters change to sync with viewers.
  /// [isRunning] Whether the simulation is running
  /// [timeScale] The time scale factor
  /// [scenarioName] The name of the current scenario (for display purposes)
  Future<bool> updateHostedSession({
    bool? isRunning,
    double? timeScale,
    String? scenarioName,
  }) async {
    if (!_isHosting) return false;

    // Update local state if scenario name is provided
    if (scenarioName != null) {
      _hostedScenarioName = scenarioName;
      notifyListeners();
    }

    return _service.updateSessionState(
      isRunning: isRunning,
      timeScale: timeScale,
      scenarioName: scenarioName,
    );
  }

  /// Stop hosting the current session
  Future<bool> stopHosting() async {
    if (!_isHosting) return false;

    final success = await _service.stopHosting();
    if (success) {
      _isHosting = false;
      _hostedSessionId = null;
      _hostedScenarioName = null;
      _hostedIsPasswordProtected = false;
      _viewerCount = 0;
      _setConnectionStatus(LiveSessionConnectionStatus.disconnected);
      notifyListeners();
    } else {
      _setError('Failed to stop hosting session');
    }

    return success;
  }

  void _onViewerCountChanged(int count) {
    _viewerCount = count;
    notifyListeners();
  }

  // =============================================================================
  // VIEWING
  // =============================================================================

  /// Start viewing a live session
  ///
  /// [sessionId] The ID of the session to join
  /// [password] The password to join (required for password-protected sessions)
  ///
  /// Returns true if successfully joined.
  /// Returns false if trying to join own hosted session.
  Future<bool> startViewing(String sessionId, {String? password}) async {
    // Prevent joining your own session
    if (_isHosting && _hostedSessionId == sessionId) {
      _setError('Cannot join your own session');
      return false;
    }

    if (_isViewing) {
      await stopViewing();
    }
    if (_isHosting) {
      await stopHosting();
    }

    _setConnectionStatus(LiveSessionConnectionStatus.connecting);

    final success = await _service.joinSession(
      sessionId,
      password: password,
      onSessionUpdated: _onSessionUpdated,
    );

    if (success) {
      _isViewing = true;
      _viewedSessionId = sessionId;
      _setConnectionStatus(LiveSessionConnectionStatus.connected);
      clearError();
      notifyListeners();
    } else {
      _setError('Failed to join session');
    }

    return success;
  }

  /// Stop viewing the current session
  Future<bool> stopViewing() async {
    if (!_isViewing) return false;

    final success = await _service.leaveSession();
    if (success) {
      _isViewing = false;
      _viewedSessionId = null;
      _currentSession = null;
      _latestSnapshot = null;
      _setConnectionStatus(LiveSessionConnectionStatus.disconnected);
      notifyListeners();
    } else {
      _setError('Failed to leave session');
    }

    return success;
  }

  void _onSessionUpdated(LiveSession session) {
    _currentSession = session;
    notifyListeners();
  }

  // =============================================================================
  // STATE SYNC
  // =============================================================================

  /// Broadcast simulation state to viewers (host only)
  ///
  /// [snapshot] The current simulation state to broadcast
  ///
  /// Returns true if successfully broadcast.
  Future<bool> broadcastState(SimulationSnapshot snapshot) async {
    if (!_isHosting) return false;
    return _service.broadcastState(snapshot);
  }

  /// Start receiving simulation state updates (viewer only)
  ///
  /// [onSnapshotReceived] Callback when new state is received from host
  void startStateSync({
    void Function(SimulationSnapshot snapshot)? onSnapshotReceived,
  }) {
    if (!_isViewing) return;

    _onSnapshotReceived = onSnapshotReceived;
    _service.startStateSync(
      onStateReceived: (snapshot) {
        _latestSnapshot = snapshot;
        _onSnapshotReceived?.call(snapshot);
        notifyListeners();
      },
    );
  }

  /// Stop receiving simulation state updates
  void stopStateSync() {
    _service.stopStateSync();
    _latestSnapshot = null;
    _onSnapshotReceived = null;
  }

  // =============================================================================
  // SESSION DISCOVERY
  // =============================================================================

  /// Start listening to active sessions
  ///
  /// Call this when entering the session browser screen.
  void startSessionDiscovery() {
    if (_sessionsSubscription != null) return;

    _isLoadingSessions = true;
    notifyListeners();

    _sessionsSubscription = _service.getActiveSessions().listen(
      (sessions) {
        _activeSessions = sessions;
        _isLoadingSessions = false;
        notifyListeners();
      },
      onError: (Object error) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('LiveSessionState: Error loading sessions: $error');
        }
        _isLoadingSessions = false;
        notifyListeners();
      },
    );
  }

  /// Stop listening to active sessions
  ///
  /// Call this when leaving the session browser screen.
  /// Set [notify] to false when calling from dispose to avoid state updates
  /// during widget teardown.
  void stopSessionDiscovery({bool notify = true}) {
    _sessionsSubscription?.cancel();
    _sessionsSubscription = null;
    _activeSessions = [];
    _isLoadingSessions = false;
    if (notify) {
      notifyListeners();
    }
  }

  // =============================================================================
  // CLEANUP
  // =============================================================================

  /// Clean up all resources
  Future<void> cleanup() async {
    stopSessionDiscovery();
    stopStateSync();

    if (_isHosting) {
      await stopHosting();
    }
    if (_isViewing) {
      await stopViewing();
    }
  }

  @override
  void dispose() {
    cleanup();
    super.dispose();
  }
}
