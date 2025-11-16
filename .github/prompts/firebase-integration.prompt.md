# Firebase Integration Prompt

You are working on Graviton's Firebase integration for analytics, crash reporting, and remote configuration:

## Firebase Services Used

1. **Firebase Analytics**: User behavior and feature usage tracking
2. **Firebase Crashlytics**: Crash reporting and error monitoring
3. **Firebase Remote Config**: Feature flags and A/B testing
4. **Cloud Firestore**: Scenario sharing and user data (optional)

## Analytics Patterns

```dart
// Track physics simulation events
class SimulationAnalytics {
  static Future<void> trackSimulationStarted({
    required String scenarioType,
    required int bodyCount,
    required String difficulty,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: FirebaseEvent.simulationStarted.name,
      parameters: {
        'scenario_type': scenarioType,
        'body_count': bodyCount,
        'difficulty': difficulty,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
  
  static Future<void> trackBodyCollision({
    required String body1Type,
    required String body2Type,
    required double relativeVelocity,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: FirebaseEvent.bodyCollision.name,
      parameters: {
        'body1_type': body1Type,
        'body2_type': body2Type,
        'relative_velocity': relativeVelocity,
        'collision_energy': relativeVelocity * relativeVelocity,
      },
    );
  }
  
  static Future<void> trackFeatureUsage(String feature) async {
    await FirebaseAnalytics.instance.logEvent(
      name: FirebaseEvent.featureUsed.name,
      parameters: {
        'feature_name': feature,
        'screen': 'simulation',
      },
    );
  }
}
```

## Crash Reporting

```dart
class CrashReporting {
  static Future<void> initialize() async {
    // Set custom keys for better crash context
    await FirebaseCrashlytics.instance.setCustomKey('app_flavor', FlavorConfig.instance.flavor);
    await FirebaseCrashlytics.instance.setCustomKey('physics_engine_version', '2.1.0');
    
    // Set user identifier (anonymized)
    final deviceId = await DeviceInfo.getDeviceId();
    await FirebaseCrashlytics.instance.setUserIdentifier(deviceId);
  }
  
  static Future<void> recordPhysicsError({
    required String errorType,
    required Map<String, dynamic> context,
    StackTrace? stackTrace,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      'Physics Engine Error: $errorType',
      stackTrace,
      context: context,
    );
  }
  
  static Future<void> recordSimulationState({
    required int bodyCount,
    required double timeElapsed,
    required bool isStable,
  }) async {
    await FirebaseCrashlytics.instance.setCustomKey('body_count', bodyCount);
    await FirebaseCrashlytics.instance.setCustomKey('simulation_time', timeElapsed);
    await FirebaseCrashlytics.instance.setCustomKey('system_stable', isStable);
  }
}
```

## Remote Configuration

```dart
class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  static RemoteConfigService get instance => _instance;
  RemoteConfigService._internal();
  
  FirebaseRemoteConfig? _remoteConfig;
  
  Future<void> initialize() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      
      // Set default values
      await _remoteConfig!.setDefaults({
        'max_bodies_limit': 50,
        'enable_advanced_physics': true,
        'enable_temperature_simulation': true,
        'trail_quality_high': false,
        'enable_haptic_feedback': true,
        'tutorial_version': '1.0',
        'feature_scene_editor': false,
        'performance_optimization_level': 'medium',
      });
      
      // Set fetch settings
      await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      
      // Fetch and activate
      await _remoteConfig!.fetchAndActivate();
    } catch (e) {
      debugPrint('Remote config initialization failed: $e');
    }
  }
  
  int get maxBodiesLimit => _remoteConfig?.getInt('max_bodies_limit') ?? 50;
  bool get enableAdvancedPhysics => _remoteConfig?.getBool('enable_advanced_physics') ?? true;
  bool get enableTemperatureSimulation => _remoteConfig?.getBool('enable_temperature_simulation') ?? true;
  bool get enableHighQualityTrails => _remoteConfig?.getBool('trail_quality_high') ?? false;
  bool get enableHapticFeedback => _remoteConfig?.getBool('enable_haptic_feedback') ?? true;
  String get tutorialVersion => _remoteConfig?.getString('tutorial_version') ?? '1.0';
  bool get enableSceneEditor => _remoteConfig?.getBool('feature_scene_editor') ?? false;
  String get performanceOptimizationLevel => _remoteConfig?.getString('performance_optimization_level') ?? 'medium';
  
  Future<void> refresh() async {
    try {
      await _remoteConfig?.fetchAndActivate();
    } catch (e) {
      debugPrint('Failed to refresh remote config: $e');
    }
  }
}
```

## Event Definitions

```dart
enum FirebaseEvent {
  // Simulation events
  simulationStarted('simulation_started'),
  simulationPaused('simulation_paused'),
  simulationReset('simulation_reset'),
  
  // Physics events
  bodyCollision('body_collision'),
  bodyEjected('body_ejected'),
  orbitStabilized('orbit_stabilized'),
  systemChaos('system_chaos'),
  
  // User interaction
  featureUsed('feature_used'),
  scenarioCreated('scenario_created'),
  scenarioShared('scenario_shared'),
  tutorialCompleted('tutorial_completed'),
  
  // Performance
  performanceWarning('performance_warning'),
  frameDropDetected('frame_drop_detected'),
  
  // Errors
  physicsError('physics_error'),
  renderingError('rendering_error'),
  configurationError('configuration_error');
  
  const FirebaseEvent(this.name);
  final String name;
}
```

## Conditional Features

```dart
class FeatureFlags {
  static bool get sceneEditorEnabled {
    return RemoteConfigService.instance.enableSceneEditor;
  }
  
  static bool get advancedPhysicsEnabled {
    return RemoteConfigService.instance.enableAdvancedPhysics;
  }
  
  static int get maxBodiesAllowed {
    return RemoteConfigService.instance.maxBodiesLimit;
  }
}

// Usage in widgets
class SimulationControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayPauseButton(),
        ResetButton(),
        if (FeatureFlags.sceneEditorEnabled) SceneEditorButton(),
        if (FeatureFlags.advancedPhysicsEnabled) AdvancedPhysicsPanel(),
      ],
    );
  }
}
```

## Error Handling

```dart
class SafeFirebaseOperation {
  static Future<T?> execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      debugPrint('Firebase operation failed: $e');
      
      // Record the failure itself
      await FirebaseCrashlytics.instance.recordError(
        'Firebase Operation Failed',
        stackTrace,
        context: {'operation_type': T.toString()},
      );
      
      return null;
    }
  }
}

// Usage
await SafeFirebaseOperation.execute(() async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'simulation_started',
    parameters: {'scenario': 'solar_system'},
  );
});
```

## Testing Firebase Integration

```dart
class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}
class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  group('Firebase Integration Tests', () {
    late MockFirebaseAnalytics mockAnalytics;
    
    setUp(() {
      mockAnalytics = MockFirebaseAnalytics();
      // Inject mock for testing
    });
    
    testWidgets('tracks simulation events correctly', (tester) async {
      await SimulationAnalytics.trackSimulationStarted(
        scenarioType: 'solar_system',
        bodyCount: 9,
        difficulty: 'normal',
      );
      
      verify(mockAnalytics.logEvent(
        name: 'simulation_started',
        parameters: argThat(contains('scenario_type')),
      )).called(1);
    });
    
    test('handles Firebase initialization failure gracefully', () async {
      // Test that app continues to work without Firebase
      expect(() async {
        await FirebaseService.instance.initialize();
      }, returnsNormally);
    });
  });
}
```

## Privacy & Compliance

```dart
class AnalyticsConsent {
  static Future<bool> hasUserConsented() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('analytics_consent') ?? false;
  }
  
  static Future<void> setUserConsent(bool consent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_consent', consent);
    
    // Enable/disable Firebase analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(consent);
  }
  
  static Future<void> requestConsent(BuildContext context) async {
    if (await hasUserConsented()) return;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AnalyticsConsentDialog(),
    );
    
    await setUserConsent(result ?? false);
  }
}
```

## File Locations

- Firebase service: `lib/services/firebase_service.dart`
- Remote config: `lib/services/remote_config_service.dart`
- Event definitions: `lib/enums/firebase_event.dart`
- Analytics helpers: `lib/utils/analytics_helper.dart`