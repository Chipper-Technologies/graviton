# Scenario & Configuration Management Prompt

You are working on Graviton's scenario system. Create and manage physics scenarios for educational exploration:

## Scenario Architecture

1. **Preset Scenarios**: Pre-built educational scenarios (Solar System, Binary Stars, etc.)
2. **Custom Scenarios**: User-created scenarios with validation
3. **Scenario Serialization**: JSON-based save/load system
4. **Configuration Validation**: Ensure physics stability

## Scenario Structure

```dart
class CustomScenario {
  final String id;
  final String name;
  final String description;
  final List<BodyData> bodies;
  final PhysicsSettings physicsSettings;
  final CameraPosition initialCamera;
  final Map<String, dynamic> metadata;
  
  CustomScenario({
    required this.id,
    required this.name,
    required this.description,
    required this.bodies,
    required this.physicsSettings,
    required this.initialCamera,
    this.metadata = const {},
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'bodies': bodies.map((b) => b.toJson()).toList(),
    'physicsSettings': physicsSettings.toJson(),
    'initialCamera': initialCamera.toJson(),
    'metadata': metadata,
    'version': '1.0',
    'created': DateTime.now().toIso8601String(),
  };
}
```

## Scenario Validation

```dart
class ScenarioValidator {
  static ScenarioValidationResult validate(CustomScenario scenario) {
    final errors = <String>[];
    final warnings = <String>[];
    
    // Basic validation
    if (scenario.name.isEmpty) {
      errors.add('Scenario name cannot be empty');
    }
    
    if (scenario.bodies.length < 2) {
      warnings.add('Scenarios with fewer than 2 bodies may not be interesting');
    }
    
    // Physics validation
    for (final body in scenario.bodies) {
      if (body.mass <= 0) {
        errors.add('Body ${body.name} has invalid mass: ${body.mass}');
      }
      
      if (body.radius <= 0) {
        errors.add('Body ${body.name} has invalid radius: ${body.radius}');
      }
    }
    
    // Stability check
    final stabilityResult = _checkSystemStability(scenario.bodies);
    if (stabilityResult.isUnstable) {
      warnings.add('System may be unstable: ${stabilityResult.reason}');
    }
    
    // Energy check
    final totalEnergy = _calculateTotalEnergy(scenario.bodies);
    if (totalEnergy > 0) {
      warnings.add('System has positive total energy - bodies may escape');
    }
    
    return ScenarioValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
  
  static StabilityResult _checkSystemStability(List<BodyData> bodies) {
    // Check for very close bodies that might cause numerical issues
    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final distance = (bodies[i].position - bodies[j].position).length;
        final combinedRadius = bodies[i].radius + bodies[j].radius;
        
        if (distance < combinedRadius * 2) {
          return StabilityResult(
            isUnstable: true,
            reason: 'Bodies ${bodies[i].name} and ${bodies[j].name} are too close',
          );
        }
      }
    }
    
    return StabilityResult(isUnstable: false);
  }
}
```

## Preset Scenario Definitions

```dart
class PresetScenarios {
  static CustomScenario get solarSystem => CustomScenario(
    id: 'solar_system',
    name: 'Solar System',
    description: 'Our solar system with major planets',
    bodies: [
      BodyData.star(
        name: 'Sun',
        mass: 333000, // Earth masses
        radius: 109, // Earth radii
        position: Vector3.zero(),
        velocity: Vector3.zero(),
        color: const Color(0xFFFFD700),
      ),
      BodyData.planet(
        name: 'Earth',
        mass: 1.0,
        radius: 1.0,
        position: Vector3(150, 0, 0), // 1 AU
        velocity: Vector3(0, 29.8, 0), // km/s
        color: const Color(0xFF6B93D6),
      ),
      // ... more planets
    ],
    physicsSettings: PhysicsSettings.realistic(),
    initialCamera: CameraPosition.solarSystemView(),
  );
  
  static CustomScenario get binaryStars => CustomScenario(
    id: 'binary_stars',
    name: 'Binary Star System',
    description: 'Two massive stars orbiting their common barycenter',
    bodies: [
      BodyData.star(
        name: 'Star A',
        mass: 20.0,
        radius: 2.5,
        position: Vector3(-10, 0, 0),
        velocity: Vector3(0, 5, 0),
        color: const Color(0xFFFF6B6B),
      ),
      BodyData.star(
        name: 'Star B',
        mass: 15.0,
        radius: 2.0,
        position: Vector3(10, 0, 0),
        velocity: Vector3(0, -6.67, 0),
        color: const Color(0xFF4ECDC4),
      ),
    ],
    physicsSettings: PhysicsSettings.educational(),
    initialCamera: CameraPosition.binarySystemView(),
  );
}
```

## Scenario Manager

```dart
class CustomScenarioManager {
  final CustomScenarioStorage _storage;
  final List<CustomScenario> _scenarios = [];
  
  CustomScenarioManager(this._storage);
  
  Future<void> loadScenarios() async {
    try {
      final scenarios = await _storage.loadAllScenarios();
      _scenarios.clear();
      _scenarios.addAll(scenarios);
    } catch (e) {
      debugPrint('Failed to load scenarios: $e');
    }
  }
  
  Future<String?> saveScenario(CustomScenario scenario) async {
    // Validate before saving
    final validation = ScenarioValidator.validate(scenario);
    if (!validation.isValid) {
      throw ScenarioValidationException(validation.errors);
    }
    
    try {
      await _storage.saveScenario(scenario);
      _scenarios.add(scenario);
      return null; // Success
    } catch (e) {
      return 'Failed to save scenario: $e';
    }
  }
  
  Future<void> deleteScenario(String scenarioId) async {
    await _storage.deleteScenario(scenarioId);
    _scenarios.removeWhere((s) => s.id == scenarioId);
  }
  
  List<CustomScenario> getScenarios() => List.unmodifiable(_scenarios);
  
  CustomScenario? getScenario(String id) {
    return _scenarios.firstWhere(
      (s) => s.id == id,
      orElse: () => null,
    );
  }
}
```

## Educational Configurations

```dart
class PhysicsSettings {
  final double gravitationalConstant;
  final double timeScale;
  final double collisionSoftening;
  final bool enableCollisions;
  final bool enableTrails;
  final bool enableTemperature;
  
  const PhysicsSettings({
    required this.gravitationalConstant,
    required this.timeScale,
    required this.collisionSoftening,
    required this.enableCollisions,
    required this.enableTrails,
    required this.enableTemperature,
  });
  
  // Realistic physics for accurate simulations
  factory PhysicsSettings.realistic() => const PhysicsSettings(
    gravitationalConstant: 6.67e-11,
    timeScale: 1.0,
    collisionSoftening: 0.001,
    enableCollisions: true,
    enableTrails: true,
    enableTemperature: true,
  );
  
  // Educational physics for stable, visible interactions
  factory PhysicsSettings.educational() => const PhysicsSettings(
    gravitationalConstant: 1.2,
    timeScale: 0.5,
    collisionSoftening: 0.01,
    enableCollisions: true,
    enableTrails: true,
    enableTemperature: false,
  );
  
  // Fast demo with exaggerated effects
  factory PhysicsSettings.demonstration() => const PhysicsSettings(
    gravitationalConstant: 2.0,
    timeScale: 2.0,
    collisionSoftening: 0.1,
    enableCollisions: true,
    enableTrails: true,
    enableTemperature: false,
  );
}
```

## Import/Export

```dart
class ScenarioImportExport {
  static Future<CustomScenario> importFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      
      // Validate JSON structure
      final validation = ScenarioJsonSchema.validate(json);
      if (!validation.isValid) {
        throw FormatException('Invalid scenario format: ${validation.errors}');
      }
      
      return CustomScenario.fromJson(json);
    } catch (e) {
      throw FormatException('Failed to parse scenario: $e');
    }
  }
  
  static String exportToJson(CustomScenario scenario) {
    return const JsonEncoder.withIndent('  ').convert(scenario.toJson());
  }
  
  static Future<void> exportToFile(CustomScenario scenario, String filePath) async {
    final jsonString = exportToJson(scenario);
    final file = File(filePath);
    await file.writeAsString(jsonString);
  }
  
  static Future<CustomScenario> importFromFile(String filePath) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    return importFromJson(jsonString);
  }
}
```

## Testing Scenarios

```dart
testWidgets('scenario validation catches invalid configurations', (tester) async {
  final invalidScenario = CustomScenario(
    id: 'test',
    name: '', // Invalid: empty name
    description: 'Test scenario',
    bodies: [
      BodyData.star(mass: -1.0), // Invalid: negative mass
    ],
    physicsSettings: PhysicsSettings.educational(),
    initialCamera: CameraPosition.initial(),
  );
  
  final result = ScenarioValidator.validate(invalidScenario);
  
  expect(result.isValid, isFalse);
  expect(result.errors, contains('Scenario name cannot be empty'));
  expect(result.errors, contains('Body has invalid mass: -1.0'));
});
```

## File Locations

- Scenario models: `lib/models/custom_scenario.dart`
- Validation: `lib/models/scenario_validation_result.dart`
- Storage: `lib/services/custom_scenario_storage.dart`
- Manager: `lib/services/custom_scenario_manager.dart`
- Serialization: `lib/services/scenario_serialization_service.dart`
- JSON schema: `lib/models/scenario_json_schema.dart`