import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/services/firebase/live_session_service.dart';

/// Manages the state of live session hosting and viewing
///
/// This state class bridges the LiveSessionService with the UI layer,
/// providing reactive updates for:
/// - Hosting status and viewer count
/// - Viewing status and session updates
/// - Active session list for browsing
///
/// Example usage:
/// ```dart
/// final liveState = LiveSessionState();
///
/// // Start hosting
/// await liveState.startHosting(scenarioName: 'Solar System');
///
/// // Listen to viewer count changes
/// liveState.addListener(() {
///   print('Viewer count: ${liveState.viewerCount}');
/// });
/// ```
class LiveSessionState extends ChangeNotifier {
  final LiveSessionService _service = LiveSessionService.instance;

  // Hosting state
  bool _isHosting = false;
  String? _hostedSessionId;
  int _viewerCount = 0;

  // Viewing state
  bool _isViewing = false;
  String? _viewedSessionId;
  LiveSession? _currentSession;

  // Active sessions stream
  StreamSubscription<List<LiveSession>>? _sessionsSubscription;
  List<LiveSession> _activeSessions = [];
  bool _isLoadingSessions = false;

  // =============================================================================
  // GETTERS
  // =============================================================================

  /// Whether the current user is hosting a session
  bool get isHosting => _isHosting;

  /// The ID of the session being hosted
  String? get hostedSessionId => _hostedSessionId;

  /// Number of viewers in the hosted session
  int get viewerCount => _viewerCount;

  /// Whether the current user is viewing a session
  bool get isViewing => _isViewing;

  /// The ID of the session being viewed
  String? get viewedSessionId => _viewedSessionId;

  /// The current session being viewed (null if not viewing)
  LiveSession? get currentSession => _currentSession;

  /// List of active sessions available to join
  List<LiveSession> get activeSessions => _activeSessions;

  /// Whether the session list is currently loading
  bool get isLoadingSessions => _isLoadingSessions;

  /// Whether the user is in any session (hosting or viewing)
  bool get isInSession => _isHosting || _isViewing;

  // =============================================================================
  // HOSTING
  // =============================================================================

  /// Start hosting a new live session
  ///
  /// [scenarioName] The name of the scenario being simulated
  /// [displayName] Optional display name for the host
  ///
  /// Returns true if hosting started successfully.
  Future<bool> startHosting({
    required String scenarioName,
    String? displayName,
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
    );

    if (sessionId != null) {
      _isHosting = true;
      _hostedSessionId = sessionId;
      _viewerCount = 0;
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Update the hosted session state
  ///
  /// Call this when simulation parameters change to sync with viewers.
  Future<bool> updateHostedSession({
    bool? isRunning,
    double? timeScale,
  }) async {
    if (!_isHosting) return false;

    return _service.updateSessionState(
      isRunning: isRunning,
      timeScale: timeScale,
    );
  }

  /// Stop hosting the current session
  Future<bool> stopHosting() async {
    if (!_isHosting) return false;

    final success = await _service.stopHosting();
    if (success) {
      _isHosting = false;
      _hostedSessionId = null;
      _viewerCount = 0;
      notifyListeners();
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
  ///
  /// Returns true if successfully joined.
  Future<bool> startViewing(String sessionId) async {
    if (_isViewing) {
      await stopViewing();
    }
    if (_isHosting) {
      await stopHosting();
    }

    final success = await _service.joinSession(
      sessionId,
      onSessionUpdated: _onSessionUpdated,
    );

    if (success) {
      _isViewing = true;
      _viewedSessionId = sessionId;
      notifyListeners();
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
      notifyListeners();
    }

    return success;
  }

  void _onSessionUpdated(LiveSession session) {
    _currentSession = session;
    notifyListeners();
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
  void stopSessionDiscovery() {
    _sessionsSubscription?.cancel();
    _sessionsSubscription = null;
    _activeSessions = [];
    _isLoadingSessions = false;
    notifyListeners();
  }

  // =============================================================================
  // CLEANUP
  // =============================================================================

  /// Clean up all resources
  Future<void> cleanup() async {
    stopSessionDiscovery();

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
