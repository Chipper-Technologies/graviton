import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/services/auth_service.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for syncing user data between local storage and Firestore
///
/// This service implements a local-first architecture with last-write-wins conflict resolution:
/// - **Local-first writes**: All changes are written to local storage (SharedPreferences) first,
///   then immediately synced to cloud for authenticated users
/// - **Last-write-wins sync**: When cloud data changes (from another device), it overwrites
///   local data to maintain cross-device consistency
/// - **Offline support**: Anonymous users work fully offline; data automatically migrates
///   when creating an account
/// - **Stale update prevention**: Cloud updates older than the last local sync are ignored
/// - **Account deletion**: Removes cloud data but preserves local storage for continued use
///
/// Data synced includes:
/// - Custom scenarios
/// - App settings (UI preferences, physics settings)
/// - Per-scenario physics settings
/// - Onboarding completion status
class UserDataSyncService {
  static final UserDataSyncService _instance = UserDataSyncService._internal();
  static UserDataSyncService get instance => _instance;

  UserDataSyncService._internal();

  // Firestore collections
  static const String _usersCollection = 'users';

  // Document field keys
  static const String _customScenariosField = 'customScenarios';
  static const String _settingsField = 'settings';
  static const String _scenarioPhysicsField = 'scenarioPhysics';
  static const String _onboardingField = 'onboarding';
  static const String _lastSyncField = 'lastSync';
  static const String _createdAtField = 'createdAt';
  static const String _updatedAtField = 'updatedAt';

  // Settings sub-fields (from UIState, SimulationState, PhysicsState)
  static const String _uiSettingsField = 'ui';
  static const String _simulationSettingsField = 'simulation';

  // Sync state
  StreamSubscription<DocumentSnapshot>? _syncSubscription;
  bool _isSyncing = false;
  bool _isInitialized = false;

  // Track last successful sync to cloud to ignore stale updates
  DateTime? _lastSyncToCloud;

  /// Initialize the sync service
  ///
  /// Call this after user signs in to start syncing.
  /// For anonymous users, this does nothing (local-only mode).
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null || user.isAnonymous) {
      debugPrint('UserDataSync: User is anonymous, skipping cloud sync');
      _isInitialized = true;
      return;
    }

    try {
      // Start listening to cloud changes
      await _startCloudSync();
      _isInitialized = true;
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Failed to initialize: $e');
      FirebaseService.instance.recordError(e, stackTrace);
    }
  }

  /// Migrate local data to cloud when user creates account
  ///
  /// This is called after successful account creation to upload
  /// all existing local data to the user's Firestore document.
  Future<void> migrateLocalDataToCloud() async {
    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null || user.isAnonymous) {
      debugPrint('UserDataSync: Cannot migrate - user not authenticated');
      return;
    }

    try {
      _isSyncing = true;

      // Gather all local data
      final localData = await _gatherLocalData();

      // Upload to Firestore
      final userDoc = _getUserDocument(user.uid);
      await userDoc.set({
        ...localData,
        _createdAtField: FieldValue.serverTimestamp(),
        _updatedAtField: FieldValue.serverTimestamp(),
        _lastSyncField: FieldValue.serverTimestamp(),
      });

      // Track successful migration as a sync
      _lastSyncToCloud = DateTime.now();
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Migration failed: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync local change to cloud
  ///
  /// Call this whenever user makes a change locally (saves scenario, changes setting, etc.)
  /// This uploads the change to Firestore if user is authenticated.
  Future<void> syncToCloud({
    List<CustomScenario>? scenarios,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scenarioPhysics,
    Map<String, dynamic>? onboarding,
  }) async {
    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null || user.isAnonymous) {
      // Local-only mode - no sync needed
      return;
    }

    if (_isSyncing) {
      // Avoid sync loops
      return;
    }

    try {
      _isSyncing = true;

      final updates = <String, dynamic>{
        _updatedAtField: FieldValue.serverTimestamp(),
        _lastSyncField: FieldValue.serverTimestamp(),
      };

      if (scenarios != null) {
        updates[_customScenariosField] = scenarios
            .map((s) => s.toJson())
            .toList();
      }

      if (settings != null) {
        updates[_settingsField] = settings;
      }

      if (scenarioPhysics != null) {
        updates[_scenarioPhysicsField] = scenarioPhysics;
      }

      if (onboarding != null) {
        updates[_onboardingField] = onboarding;
      }

      final userDoc = _getUserDocument(user.uid);
      await userDoc.update(updates);

      // Track when we successfully synced to cloud
      _lastSyncToCloud = DateTime.now();

      debugPrint('UserDataSync: Synced ${updates.length - 2} fields to cloud');
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Sync to cloud failed: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      // Don't rethrow - local data is still saved
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync custom scenarios to cloud
  ///
  /// Convenience method for syncing just the custom scenarios.
  Future<void> syncCustomScenarios() async {
    if (_isSyncing) {
      return;
    }

    try {
      final scenarios = await CustomScenarioStorage.getAllScenarios();
      await syncToCloud(scenarios: scenarios);
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Failed to sync custom scenarios: $e');
      FirebaseService.instance.recordError(e, stackTrace);
    }
  }

  /// Sync settings to cloud
  ///
  /// Convenience method for syncing app settings.
  Future<void> syncSettings() async {
    if (_isSyncing) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final settings = await _gatherSettingsData(prefs);
      await syncToCloud(settings: settings);
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Failed to sync settings: $e');
      FirebaseService.instance.recordError(e, stackTrace);
    }
  }

  /// Sync per-scenario physics settings to cloud
  ///
  /// Convenience method for syncing physics settings.
  Future<void> syncScenarioPhysics() async {
    if (_isSyncing) {
      debugPrint(
        'UserDataSync: Already syncing, skipping scenario physics sync',
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final scenarioPhysics = await _gatherScenarioPhysicsData(prefs);
      await syncToCloud(scenarioPhysics: scenarioPhysics);
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Failed to sync scenario physics: $e');
      FirebaseService.instance.recordError(e, stackTrace);
    }
  }

  /// Delete user's cloud data
  ///
  /// Called when user deletes their account. This removes all cloud data
  /// but preserves local storage so they can continue using the app.
  Future<void> deleteCloudData(String userId) async {
    try {
      debugPrint('UserDataSync: Deleting cloud data for user $userId');

      final userDoc = _getUserDocument(userId);
      await userDoc.delete();
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Failed to delete cloud data: $e');
      FirebaseService.instance.recordError(e, stackTrace);
      rethrow;
    }
  }

  /// Stop syncing (call on sign out)
  Future<void> stopSync() async {
    await _syncSubscription?.cancel();
    _syncSubscription = null;
    _isInitialized = false;
  }

  // =============================================================================
  // PRIVATE METHODS
  // =============================================================================

  /// Get Firestore document reference for user
  DocumentReference<Map<String, dynamic>> _getUserDocument(String userId) {
    return FirebaseFirestore.instance.collection(_usersCollection).doc(userId);
  }

  /// Start listening to cloud changes
  Future<void> _startCloudSync() async {
    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null || user.isAnonymous) {
      return;
    }

    final userDoc = _getUserDocument(user.uid);

    // Check if document exists
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // First time user - migrate local data
      await migrateLocalDataToCloud();
    } else {
      // Existing user - merge cloud data with local
      await _mergeCloudDataToLocal(docSnapshot.data()!);
    }

    // Listen for future changes
    _syncSubscription = userDoc.snapshots().listen(
      (snapshot) {
        if (!snapshot.exists || _isSyncing) {
          return;
        }

        final cloudData = snapshot.data()!;

        // Check if cloud update is older than our last sync
        if (_lastSyncToCloud != null &&
            cloudData.containsKey(_updatedAtField)) {
          try {
            final cloudTimestamp = cloudData[_updatedAtField] as Timestamp?;
            if (cloudTimestamp != null) {
              final cloudTime = cloudTimestamp.toDate();
              // If cloud data is older than our last sync, ignore it (stale)
              if (cloudTime.isBefore(_lastSyncToCloud!)) {
                debugPrint(
                  'UserDataSync: Ignoring stale cloud update from $cloudTime',
                );
                return;
              }
            }
          } catch (e) {
            debugPrint('UserDataSync: Failed to parse cloud timestamp: $e');
          }
        }

        // Cloud data changed - merge to local
        _mergeCloudDataToLocal(cloudData);
      },
      onError: (error, stackTrace) {
        debugPrint('UserDataSync: Cloud sync stream error: $error');
        FirebaseService.instance.recordError(error, stackTrace);
      },
    );
  }

  /// Gather all local data for migration/sync
  Future<Map<String, dynamic>> _gatherLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    // Gather custom scenarios
    final scenarios = await CustomScenarioStorage.getAllScenarios();
    final scenariosJson = scenarios.map((s) => s.toJson()).toList();

    // Gather settings
    final settings = await _gatherSettingsData(prefs);

    // Gather per-scenario physics settings
    final scenarioPhysics = await _gatherScenarioPhysicsData(prefs);

    // Gather onboarding status
    final onboarding = await _gatherOnboardingData(prefs);

    return {
      _customScenariosField: scenariosJson,
      _settingsField: settings,
      _scenarioPhysicsField: scenarioPhysics,
      _onboardingField: onboarding,
    };
  }

  /// Gather settings data from SharedPreferences
  Future<Map<String, dynamic>> _gatherSettingsData(
    SharedPreferences prefs,
  ) async {
    // UI settings (from UIState)
    final uiSettings = <String, dynamic>{};
    for (final key in prefs.getKeys()) {
      if (key.startsWith('ui_')) {
        final value = prefs.get(key);
        if (value != null) {
          uiSettings[key] = value;
        }
      }
    }

    // Simulation settings (from SimulationState)
    final simulationSettings = <String, dynamic>{};
    for (final key in prefs.getKeys()) {
      if (key.startsWith('simulation_') && !key.contains('_scenario_')) {
        final value = prefs.get(key);
        if (value != null) {
          simulationSettings[key] = value;
        }
      }
    }

    return {
      _uiSettingsField: uiSettings,
      _simulationSettingsField: simulationSettings,
    };
  }

  /// Gather per-scenario physics settings
  Future<Map<String, dynamic>> _gatherScenarioPhysicsData(
    SharedPreferences prefs,
  ) async {
    final scenarioPhysics = <String, dynamic>{};

    // Per-scenario physics settings (from PhysicsState)
    for (final key in prefs.getKeys()) {
      if (key.startsWith('simulation_') && key.contains('_scenario_')) {
        final value = prefs.get(key);
        if (value != null) {
          scenarioPhysics[key] = value;
        }
      }
    }

    return scenarioPhysics;
  }

  /// Gather onboarding data
  Future<Map<String, dynamic>> _gatherOnboardingData(
    SharedPreferences prefs,
  ) async {
    final onboarding = <String, dynamic>{};

    for (final key in prefs.getKeys()) {
      if (key.startsWith('onboarding_')) {
        final value = prefs.get(key);
        if (value != null) {
          onboarding[key] = value;
        }
      }
    }

    return onboarding;
  }

  /// Merge cloud data to local storage
  Future<void> _mergeCloudDataToLocal(Map<String, dynamic> cloudData) async {
    if (_isSyncing) {
      debugPrint('UserDataSync: Already syncing, skipping merge');
      return;
    }

    try {
      _isSyncing = true;
      debugPrint('UserDataSync: Merging cloud data to local...');

      final prefs = await SharedPreferences.getInstance();

      // Merge custom scenarios
      if (cloudData.containsKey(_customScenariosField)) {
        await _mergeCustomScenarios(
          cloudData[_customScenariosField] as List<dynamic>,
        );
      }

      // Merge settings
      if (cloudData.containsKey(_settingsField)) {
        await _mergeSettings(
          prefs,
          cloudData[_settingsField] as Map<String, dynamic>,
        );
      }

      // Merge per-scenario physics
      if (cloudData.containsKey(_scenarioPhysicsField)) {
        await _mergeScenarioPhysics(
          prefs,
          cloudData[_scenarioPhysicsField] as Map<String, dynamic>,
        );
      }

      // Merge onboarding status
      if (cloudData.containsKey(_onboardingField)) {
        await _mergeOnboarding(
          prefs,
          cloudData[_onboardingField] as Map<String, dynamic>,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Failed to merge cloud data: $e');
      FirebaseService.instance.recordError(e, stackTrace);
    } finally {
      _isSyncing = false;
    }
  }

  /// Merge custom scenarios from cloud using last-write-wins strategy
  ///
  /// Replaces local scenarios with cloud scenarios to maintain cross-device consistency.
  /// This implements last-write-wins conflict resolution: the most recent write (cloud)
  /// overwrites local data. Stale cloud updates (older than last local sync) are ignored
  /// by the caller. This prevents duplicates when scenarios are renamed on other devices.
  Future<void> _mergeCustomScenarios(List<dynamic> cloudScenarios) async {
    try {
      // Parse all cloud scenarios
      final scenarios = <CustomScenario>[];
      for (final cloudScenarioJson in cloudScenarios) {
        try {
          final scenario = CustomScenario.fromJson(
            cloudScenarioJson as Map<String, dynamic>,
          );
          scenarios.add(scenario);
        } catch (e) {
          debugPrint('UserDataSync: Failed to parse scenario: $e');
        }
      }

      // Replace local scenarios entirely with cloud scenarios
      // This prevents duplicates when scenarios are renamed
      final prefs = await SharedPreferences.getInstance();
      final jsonList = scenarios.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString('custom_scenarios', jsonString);

      debugPrint(
        'UserDataSync: Replaced local scenarios with ${scenarios.length} from cloud',
      );
    } catch (e) {
      debugPrint('UserDataSync: Failed to merge scenarios: $e');
    }
  }

  /// Merge settings from cloud
  Future<void> _mergeSettings(
    SharedPreferences prefs,
    Map<String, dynamic> settings,
  ) async {
    // Merge UI settings
    if (settings.containsKey(_uiSettingsField)) {
      final uiSettings = settings[_uiSettingsField] as Map<String, dynamic>;
      for (final entry in uiSettings.entries) {
        await _setPreferenceValue(prefs, entry.key, entry.value);
      }
    }

    // Merge simulation settings
    if (settings.containsKey(_simulationSettingsField)) {
      final simSettings =
          settings[_simulationSettingsField] as Map<String, dynamic>;
      for (final entry in simSettings.entries) {
        await _setPreferenceValue(prefs, entry.key, entry.value);
      }
    }
  }

  /// Merge per-scenario physics settings from cloud
  Future<void> _mergeScenarioPhysics(
    SharedPreferences prefs,
    Map<String, dynamic> scenarioPhysics,
  ) async {
    for (final entry in scenarioPhysics.entries) {
      await _setPreferenceValue(prefs, entry.key, entry.value);
    }
  }

  /// Merge onboarding status from cloud
  Future<void> _mergeOnboarding(
    SharedPreferences prefs,
    Map<String, dynamic> onboarding,
  ) async {
    for (final entry in onboarding.entries) {
      await _setPreferenceValue(prefs, entry.key, entry.value);
    }
  }

  /// Set a preference value based on its type
  Future<void> _setPreferenceValue(
    SharedPreferences prefs,
    String key,
    dynamic value,
  ) async {
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }
}
