import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart'
    show kDebugMode, debugPrint, visibleForTesting;
import 'package:graviton/features/auth/data/auth_service.dart';
import 'package:graviton/services/firebase/firebase_service.dart';

/// Service for managing Firebase Realtime Database functionality
///
/// This service provides real-time data synchronization capabilities with
/// lower latency than Firestore, ideal for:
/// - Live simulation state sharing between users
/// - Real-time presence indicators
/// - Collaborative scenario editing
/// - Live activity feeds
///
/// The service implements a singleton pattern and handles initialization,
/// connection state monitoring, and provides type-safe database operations.
///
/// Example usage:
/// ```dart
/// final rtdb = RealtimeDatabaseService.instance;
/// await rtdb.initialize();
///
/// // Write data
/// await rtdb.setValue('simulations/abc123', {'status': 'running'});
///
/// // Listen to changes
/// rtdb.onValue('simulations/abc123').listen((data) {
///   print('Simulation data: $data');
/// });
/// ```
class RealtimeDatabaseService {
  static RealtimeDatabaseService? _instance;

  /// Returns the singleton instance of [RealtimeDatabaseService]
  static RealtimeDatabaseService get instance =>
      _instance ??= RealtimeDatabaseService._();

  RealtimeDatabaseService._();

  FirebaseDatabase? _database;
  bool _isInitialized = false;
  StreamSubscription<DatabaseEvent>? _connectionSubscription;
  bool _isConnected = false;

  /// The Firebase Realtime Database instance
  FirebaseDatabase? get database => _database;

  /// Whether the service has been initialized
  bool get isInitialized => _isInitialized;

  /// Whether there is an active connection to the database
  bool get isConnected => _isConnected;

  // =============================================================================
  // INITIALIZATION
  // =============================================================================

  /// Initialize the Realtime Database service
  ///
  /// This method sets up the database instance and configures connection
  /// monitoring. It should be called during app startup after Firebase
  /// core initialization.
  ///
  /// The method is idempotent - calling it multiple times is safe.
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      _database = FirebaseDatabase.instance;

      // Configure persistence for offline support
      _database!.setPersistenceEnabled(true);

      // Set up connection state monitoring
      _setupConnectionMonitoring();

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('RealtimeDatabaseService: Initialized successfully');
      }

      // Log initialization event
      await FirebaseService.instance.logEvent('realtime_database_initialized');
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Initialization failed: $e');
      FirebaseService.instance.recordError(e, stackTrace);
    }
  }

  /// Set up monitoring for database connection state
  void _setupConnectionMonitoring() {
    final connectedRef = _database!.ref('.info/connected');
    _connectionSubscription = connectedRef.onValue.listen((event) {
      _isConnected = event.snapshot.value as bool? ?? false;

      if (kDebugMode) {
        debugPrint(
          'RealtimeDatabaseService: Connection state changed: $_isConnected',
        );
      }
    });
  }

  /// Dispose of resources and clean up subscriptions
  ///
  /// This method cancels all active subscriptions, clears the database
  /// reference, and resets all state flags. After calling dispose, the
  /// service must be re-initialized before use.
  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _database = null;
    _isInitialized = false;
    _isConnected = false;

    if (kDebugMode) {
      debugPrint('RealtimeDatabaseService: Disposed');
    }
  }

  // =============================================================================
  // PATH VALIDATION
  // =============================================================================

  /// Characters that are not allowed in Firebase Realtime Database paths
  static final RegExp _invalidPathChars = RegExp(r'[.#$\[\]]');

  /// Pattern for path traversal attempts
  static final RegExp _pathTraversalPattern = RegExp(r'(^|/)\.\.(/|$)');

  /// Validates and sanitizes a database path
  ///
  /// Returns the sanitized path if valid, null if the path is invalid.
  /// Invalid paths include:
  /// - Empty or whitespace-only paths
  /// - Paths containing invalid characters (. # $ [ ])
  /// - Paths with consecutive slashes
  /// - Paths attempting path traversal (..)
  ///
  /// [path] The path to validate
  String? _validatePath(String path) {
    // Check for empty or whitespace-only path
    if (path.trim().isEmpty) {
      debugPrint('RealtimeDatabaseService: Invalid path - empty or whitespace');
      return null;
    }

    // Normalize the path - trim whitespace and remove leading/trailing slashes
    var sanitized = path.trim();
    while (sanitized.startsWith('/')) {
      sanitized = sanitized.substring(1);
    }
    while (sanitized.endsWith('/')) {
      sanitized = sanitized.substring(0, sanitized.length - 1);
    }

    // Check for empty path after normalization
    if (sanitized.isEmpty) {
      debugPrint(
        'RealtimeDatabaseService: Invalid path - empty after normalization',
      );
      return null;
    }

    // Check for path traversal attempts
    if (_pathTraversalPattern.hasMatch(sanitized)) {
      debugPrint(
        'RealtimeDatabaseService: Invalid path - path traversal detected: '
        '$path',
      );
      return null;
    }

    // Check for consecutive slashes
    if (sanitized.contains('//')) {
      debugPrint(
        'RealtimeDatabaseService: Invalid path - consecutive slashes: $path',
      );
      return null;
    }

    // Check for invalid characters in each path segment
    final segments = sanitized.split('/');
    for (final segment in segments) {
      if (segment.isEmpty) {
        debugPrint(
          'RealtimeDatabaseService: Invalid path - empty segment: $path',
        );
        return null;
      }

      if (_invalidPathChars.hasMatch(segment)) {
        debugPrint(
          'RealtimeDatabaseService: Invalid path - contains invalid '
          'characters (. # \$ [ ]): $path',
        );
        return null;
      }
    }

    return sanitized;
  }

  // =============================================================================
  // DATABASE REFERENCES
  // =============================================================================

  /// Get a database reference for the specified path
  ///
  /// Returns null if the service is not initialized or path is invalid.
  ///
  /// [path] The path in the database (e.g., 'simulations/abc123')
  ///
  /// Invalid paths include:
  /// - Empty or whitespace-only paths
  /// - Paths containing invalid characters (. # $ [ ])
  /// - Paths with consecutive slashes
  /// - Paths attempting path traversal (..)
  DatabaseReference? ref(String path) {
    if (!_isInitialized || _database == null) {
      debugPrint('RealtimeDatabaseService: Cannot get ref - not initialized');
      return null;
    }

    final validatedPath = _validatePath(path);
    if (validatedPath == null) {
      return null;
    }

    return _database!.ref(validatedPath);
  }

  /// Get a reference to the current user's data node
  ///
  /// Returns null if user is not authenticated or service not initialized.
  Future<DatabaseReference?> userRef() async {
    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null) {
      debugPrint('RealtimeDatabaseService: Cannot get userRef - not signed in');
      return null;
    }
    return ref('users/${user.uid}');
  }

  // =============================================================================
  // WRITE OPERATIONS
  // =============================================================================

  /// Set a value at the specified path
  ///
  /// This will overwrite any existing data at the path.
  ///
  /// [path] The database path
  /// [value] The value to set (must be JSON-serializable)
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> setValue(String path, dynamic value) async {
    final reference = ref(path);
    if (reference == null) return false;

    try {
      await reference.set(value);

      if (kDebugMode) {
        debugPrint('RealtimeDatabaseService: Set value at $path');
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Failed to set value at $path: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  /// Update specific fields at the specified path
  ///
  /// This merges the provided values with existing data, unlike [setValue]
  /// which overwrites completely.
  ///
  /// [path] The database path
  /// [values] Map of field names to values to update
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> updateValues(String path, Map<String, dynamic> values) async {
    final reference = ref(path);
    if (reference == null) return false;

    try {
      await reference.update(values);

      if (kDebugMode) {
        debugPrint('RealtimeDatabaseService: Updated values at $path');
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'RealtimeDatabaseService: Failed to update values at $path: $e',
      );
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  /// Push a new child node with an auto-generated key
  ///
  /// [path] The parent path
  /// [value] The value to push
  ///
  /// Returns the generated key if successful, null otherwise.
  Future<String?> push(String path, dynamic value) async {
    final reference = ref(path);
    if (reference == null) return null;

    try {
      final newRef = reference.push();
      await newRef.set(value);

      if (kDebugMode) {
        debugPrint(
          'RealtimeDatabaseService: Pushed new value at $path/${newRef.key}',
        );
      }
      return newRef.key;
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Failed to push at $path: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return null;
    }
  }

  /// Remove data at the specified path
  ///
  /// [path] The database path to remove
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> remove(String path) async {
    final reference = ref(path);
    if (reference == null) return false;

    try {
      await reference.remove();

      if (kDebugMode) {
        debugPrint('RealtimeDatabaseService: Removed data at $path');
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Failed to remove at $path: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  // =============================================================================
  // READ OPERATIONS
  // =============================================================================

  /// Read data once from the specified path
  ///
  /// [path] The database path to read
  ///
  /// Returns the data if successful, null otherwise.
  Future<dynamic> getValue(String path) async {
    final reference = ref(path);
    if (reference == null) return null;

    try {
      final snapshot = await reference.get();
      return snapshot.value;
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Failed to get value at $path: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return null;
    }
  }

  /// Read data once as a typed Map
  ///
  /// [path] The database path to read
  ///
  /// Returns the data as `Map<String, dynamic>` if successful, null otherwise.
  Future<Map<String, dynamic>?> getMap(String path) async {
    final value = await getValue(path);
    if (value == null) return null;

    try {
      return Map<String, dynamic>.from(value as Map);
    } catch (e) {
      debugPrint('RealtimeDatabaseService: Failed to cast value to Map: $e');
      return null;
    }
  }

  // =============================================================================
  // REAL-TIME LISTENERS
  // =============================================================================

  /// Listen to value changes at the specified path
  ///
  /// Returns a stream of data values. The stream emits null if the path
  /// doesn't exist or on errors.
  ///
  /// [path] The database path to listen to
  ///
  /// Example:
  /// ```dart
  /// rtdb.onValue('simulations/abc').listen((data) {
  ///   if (data != null) {
  ///     print('Simulation: $data');
  ///   }
  /// });
  /// ```
  Stream<dynamic> onValue(String path) {
    final reference = ref(path);
    if (reference == null) {
      return Stream.value(null);
    }

    return reference.onValue.map((event) => event.snapshot.value);
  }

  /// Listen to child added events at the specified path
  ///
  /// Returns a stream of (key, value) pairs for each child added.
  ///
  /// [path] The database path to listen to
  Stream<MapEntry<String?, dynamic>> onChildAdded(String path) {
    final reference = ref(path);
    if (reference == null) {
      return const Stream.empty();
    }

    return reference.onChildAdded.map(
      (event) => MapEntry(event.snapshot.key, event.snapshot.value),
    );
  }

  /// Listen to child changed events at the specified path
  ///
  /// Returns a stream of (key, value) pairs for each child modified.
  ///
  /// [path] The database path to listen to
  Stream<MapEntry<String?, dynamic>> onChildChanged(String path) {
    final reference = ref(path);
    if (reference == null) {
      return const Stream.empty();
    }

    return reference.onChildChanged.map(
      (event) => MapEntry(event.snapshot.key, event.snapshot.value),
    );
  }

  /// Listen to child removed events at the specified path
  ///
  /// Returns a stream of (key, value) pairs for each child removed.
  ///
  /// [path] The database path to listen to
  Stream<MapEntry<String?, dynamic>> onChildRemoved(String path) {
    final reference = ref(path);
    if (reference == null) {
      return const Stream.empty();
    }

    return reference.onChildRemoved.map(
      (event) => MapEntry(event.snapshot.key, event.snapshot.value),
    );
  }

  // =============================================================================
  // PRESENCE SYSTEM
  // =============================================================================

  /// Set up presence tracking for the current user
  ///
  /// This creates an entry in the presence node that is automatically
  /// removed when the user disconnects.
  ///
  /// [onlineValue] The value to set when user is online
  /// [offlineValue] The value to set when user disconnects
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> setupPresence({
    Map<String, dynamic>? onlineValue,
    Map<String, dynamic>? offlineValue,
  }) async {
    final userReference = await userRef();
    if (userReference == null) return false;

    try {
      final presenceRef = userReference.child('presence');

      // Set the online value
      final online =
          onlineValue ?? {'online': true, 'lastSeen': ServerValue.timestamp};
      await presenceRef.set(online);

      // Set what happens when user disconnects
      final offline =
          offlineValue ?? {'online': false, 'lastSeen': ServerValue.timestamp};
      await presenceRef.onDisconnect().set(offline);

      if (kDebugMode) {
        debugPrint('RealtimeDatabaseService: Presence tracking set up');
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Failed to setup presence: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  /// Remove presence tracking for the current user
  ///
  /// Call this when the user signs out to clean up presence data.
  Future<bool> removePresence() async {
    final userReference = await userRef();
    if (userReference == null) return false;

    try {
      final presenceRef = userReference.child('presence');
      await presenceRef.onDisconnect().cancel();
      await presenceRef.remove();

      if (kDebugMode) {
        debugPrint('RealtimeDatabaseService: Presence tracking removed');
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Failed to remove presence: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return false;
    }
  }

  // =============================================================================
  // TRANSACTION OPERATIONS
  // =============================================================================

  /// Run a transaction at the specified path
  ///
  /// Transactions ensure atomic read-modify-write operations, useful for
  /// counters, likes, or any data that might be updated concurrently.
  ///
  /// [path] The database path
  /// [transactionHandler] Function that receives current value and returns
  /// a Transaction result
  ///
  /// Returns the committed data if successful, null otherwise.
  Future<dynamic> runTransaction(
    String path,
    Transaction Function(Object?) transactionHandler,
  ) async {
    final reference = ref(path);
    if (reference == null) return null;

    try {
      final result = await reference.runTransaction(transactionHandler);

      if (result.committed) {
        if (kDebugMode) {
          debugPrint('RealtimeDatabaseService: Transaction committed at $path');
        }
        return result.snapshot.value;
      } else {
        debugPrint('RealtimeDatabaseService: Transaction aborted at $path');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Transaction failed at $path: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return null;
    }
  }

  /// Increment a numeric value atomically
  ///
  /// [path] The database path to the numeric field
  /// [delta] The amount to increment (can be negative for decrement)
  ///
  /// Returns the new value if successful, null otherwise.
  Future<num?> increment(String path, num delta) async {
    final result = await runTransaction(path, (Object? currentData) {
      // Handle null or non-numeric current values
      num currentValue;
      if (currentData == null) {
        currentValue = 0;
      } else if (currentData is num) {
        currentValue = currentData;
      } else {
        // If current value is not numeric, start from 0
        if (kDebugMode) {
          debugPrint(
            'RealtimeDatabaseService: increment found non-numeric value '
            '(${currentData.runtimeType}) at $path, starting from 0',
          );
        }
        currentValue = 0;
      }
      return Transaction.success(currentValue + delta);
    });

    // Safely convert result to num
    if (result == null) {
      return null;
    }
    if (result is num) {
      return result;
    }

    // Unexpected result type
    if (kDebugMode) {
      debugPrint(
        'RealtimeDatabaseService: increment returned unexpected type '
        '(${result.runtimeType}) at $path',
      );
    }
    return null;
  }

  // =============================================================================
  // QUERY OPERATIONS
  // =============================================================================

  /// Create a query with ordering and filtering
  ///
  /// [path] The database path
  /// [orderByChild] Child key to order by
  /// [limitToFirst] Limit results to first N items
  /// [limitToLast] Limit results to last N items
  /// [equalTo] Filter to items equal to this value
  /// [startAt] Start at this value (inclusive)
  /// [endAt] End at this value (inclusive)
  ///
  /// Returns a Query object or null if not initialized.
  Query? query({
    required String path,
    String? orderByChild,
    int? limitToFirst,
    int? limitToLast,
    dynamic equalTo,
    dynamic startAt,
    dynamic endAt,
  }) {
    final reference = ref(path);
    if (reference == null) return null;

    Query query = reference;

    if (orderByChild != null) {
      query = query.orderByChild(orderByChild);
    }

    if (equalTo != null) {
      query = query.equalTo(equalTo);
    }

    if (startAt != null) {
      query = query.startAt(startAt);
    }

    if (endAt != null) {
      query = query.endAt(endAt);
    }

    if (limitToFirst != null) {
      query = query.limitToFirst(limitToFirst);
    }

    if (limitToLast != null) {
      query = query.limitToLast(limitToLast);
    }

    return query;
  }

  /// Execute a query and return results as a list of maps
  ///
  /// Returns a list of (key, value) entries or empty list on error.
  Future<List<MapEntry<String, dynamic>>> queryOnce({
    required String path,
    String? orderByChild,
    int? limitToFirst,
    int? limitToLast,
    dynamic equalTo,
    dynamic startAt,
    dynamic endAt,
  }) async {
    final q = query(
      path: path,
      orderByChild: orderByChild,
      limitToFirst: limitToFirst,
      limitToLast: limitToLast,
      equalTo: equalTo,
      startAt: startAt,
      endAt: endAt,
    );

    if (q == null) return [];

    try {
      final snapshot = await q.get();
      final results = <MapEntry<String, dynamic>>[];

      for (final child in snapshot.children) {
        if (child.key != null) {
          results.add(MapEntry(child.key!, child.value));
        }
      }

      return results;
    } catch (e, stackTrace) {
      debugPrint('RealtimeDatabaseService: Query failed at $path: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      return [];
    }
  }

  // =============================================================================
  // TESTING SUPPORT
  // =============================================================================

  /// Reset the singleton instance for testing purposes
  ///
  /// This should only be used in tests to ensure a clean state between tests.
  @visibleForTesting
  static void resetForTesting() {
    _instance?.dispose();
    _instance = null;
  }
}
