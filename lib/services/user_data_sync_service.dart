import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
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
/// - Custom scenarios (user-created simulations)
/// - Profile information (display name, avatar selection)
///
/// Note: Device-specific settings (UI preferences, physics settings, onboarding status)
/// are intentionally kept local-only as they represent device-specific preferences.
class UserDataSyncService {
  static final UserDataSyncService _instance = UserDataSyncService._internal();
  static UserDataSyncService get instance => _instance;

  UserDataSyncService._internal();

  // Firestore collections
  static const String _usersCollection = 'users';

  // Document field keys
  static const String _customScenariosField = 'customScenarios';
  static const String _profileField = 'profile';
  static const String _lastSyncField = 'lastSync';
  static const String _createdAtField = 'createdAt';
  static const String _updatedAtField = 'updatedAt';

  // Profile sub-fields
  static const String _displayNameField = 'displayName';
  static const String _avatarField = 'avatar';

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
      if (kDebugMode) {
        debugPrint('UserDataSync: User is anonymous, skipping cloud sync');
      }
      _isInitialized = true;
      return;
    }

    // Check email verification for cloud sync
    final isVerified = await AuthService.instance.requireEmailVerification();
    if (!isVerified) {
      if (kDebugMode) {
        debugPrint('UserDataSync: Email not verified, skipping cloud sync');
      }
      _isInitialized = true;
      return;
    }

    try {
      // Start listening to cloud changes
      await _startCloudSync();
      _isInitialized = true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('UserDataSync: Failed to initialize: $e');
      }
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
      if (kDebugMode) {
        debugPrint('UserDataSync: Cannot migrate - user not authenticated');
      }
      return;
    }

    // Check email verification before migrating data
    final isVerified = await AuthService.instance.requireEmailVerification();
    if (!isVerified) {
      if (kDebugMode) {
        debugPrint('UserDataSync: Cannot migrate - email not verified');
      }
      return;
    }

    try {
      _isSyncing = true;

      // Gather all local data
      final localData = await _gatherLocalData();

      // Upload to Firestore
      final userDoc = _getUserDocument(user.uid);
      
      // Use set with merge for web compatibility
      await userDoc.set(
        {
          ...localData,
          _createdAtField: FieldValue.serverTimestamp(),
          _updatedAtField: FieldValue.serverTimestamp(),
          _lastSyncField: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

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
  /// Call this whenever user saves or modifies custom scenarios or profile information.
  /// This uploads the change to Firestore if user is authenticated.
  Future<void> syncToCloud({
    List<CustomScenario>? scenarios,
    Map<String, dynamic>? profile,
  }) async {
    final user = await AuthService.instance.getCurrentUserProfile();
    if (user == null || user.isAnonymous) {
      // Local-only mode - no sync needed
      return;
    }


    // Check email verification for cloud sync
    final isVerified = await AuthService.instance.requireEmailVerification();
    if (!isVerified) {
      if (kDebugMode) {
        debugPrint('UserDataSync: Email not verified, skipping cloud sync');
      }
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

      if (profile != null) {
        updates[_profileField] = profile;
      }

      final userDoc = _getUserDocument(user.uid);
      await userDoc.set(updates, SetOptions(merge: true));

      // Track when we successfully synced to cloud
      _lastSyncToCloud = DateTime.now();

      debugPrint('UserDataSync: Synced ${updates.keys.where((k) => !k.startsWith('_')).length} fields to cloud');
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

  /// Delete user's cloud data
  ///
  /// Called when user deletes their account. This removes all cloud data
  /// but preserves local storage so they can continue using the app.
  Future<void> deleteCloudData(String userId) async {
    try {
      if (kDebugMode) {
        debugPrint('UserDataSync: Deleting cloud data');
      }

      final userDoc = _getUserDocument(userId);
      await userDoc.delete();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('UserDataSync: Failed to delete cloud data: $e');
      }
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
    // Gather custom scenarios
    final scenarios = await CustomScenarioStorage.getAllScenarios();
    final scenariosJson = scenarios.map((s) => s.toJson()).toList();

    // Gather profile information
    final profile = await _gatherProfileData();

    return {_customScenariosField: scenariosJson, _profileField: profile};
  }

  /// Gather profile data
  Future<Map<String, dynamic>> _gatherProfileData() async {
    final user = await AuthService.instance.getCurrentUserProfile();
    final profile = <String, dynamic>{};

    if (user?.displayName != null) {
      profile[_displayNameField] = user!.displayName;
    }

    if (user?.avatar != null) {
      profile[_avatarField] = user!.avatar!.name;
    }

    return profile;
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

      // Merge custom scenarios
      if (cloudData.containsKey(_customScenariosField)) {
        await _mergeCustomScenarios(
          cloudData[_customScenariosField] as List<dynamic>,
        );
      }

      // Merge profile information
      if (cloudData.containsKey(_profileField)) {
        await _mergeProfile(cloudData[_profileField] as Map<String, dynamic>);
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

  /// Merge profile information from cloud
  Future<void> _mergeProfile(Map<String, dynamic> profile) async {
    try {
      // Note: Display name is stored in Firebase Auth, but we can use this
      // to update local anonymous user display name if needed
      final prefs = await SharedPreferences.getInstance();

      if (profile.containsKey(_displayNameField)) {
        await prefs.setString(
          'anonymous_display_name',
          profile[_displayNameField] as String,
        );
      }

      // Avatar will be handled by the auth system when profile is reloaded
      debugPrint('UserDataSync: Merged profile data from cloud');
    } catch (e) {
      debugPrint('UserDataSync: Failed to merge profile: $e');
    }
  }

  /// Sync profile information to cloud
  ///
  /// Convenience method for syncing profile changes (display name, avatar).
  Future<void> syncProfile() async {
    if (_isSyncing) {
      return;
    }

    try {
      final profile = await _gatherProfileData();
      await syncToCloud(profile: profile);
    } catch (e, stackTrace) {
      debugPrint('UserDataSync: Failed to sync profile: $e');
      FirebaseService.instance.recordError(e, stackTrace);
    }
  }
}
