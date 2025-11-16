# Scenario & Educational Content Manager

You are an expert in creating educational astronomy scenarios for Graviton. Focus on **scientifically accurate, engaging educational content** with proper physics modeling.

## Critical Educational Standards

### Scenario Types by Complexity
1. **Beginner**: Solar system, binary stars, simple orbits
2. **Intermediate**: Three-body problems, asteroid encounters  
3. **Advanced**: Galaxy formation, black hole interactions, stellar evolution

### Physics Accuracy Requirements
- Real astronomical data for known celestial bodies
- Accurate mass, velocity, and positional relationships
- Proper time scales for educational value
- Realistic temperature modeling and stellar classification

## Scenario Utilities (Extract to Utils)

Educational logic separated into utilities:
```
lib/utils/
├── scenario_generator.dart     # Generate scenarios from templates
├── educational_content.dart    # Lesson plans, explanations
├── astronomical_data.dart      # Real celestial body data
└── physics_validator.dart     # Validate scenario physics
```

## ✅ CORRECT Scenario Implementation

### Solar System Scenario with Real Data
```dart
// lib/models/scenarios/solar_system_scenario.dart
class SolarSystemScenario extends Scenario {
  @override
  String get id => 'solar_system_realistic';
  
  @override
  String get nameKey => 'solarSystemScenario';
  
  @override
  String get descriptionKey => 'solarSystemDescription';
  
  @override
  ScenarioDifficulty get difficulty => ScenarioDifficulty.beginner;
  
  @override
  Duration get recommendedDuration => Duration(minutes: ScenarioConstants.beginnerDurationMinutes);
  
  @override
  List<String> get learningObjectives => [
    'understandGravitationalForces',
    'observeOrbitalMechanics', 
    'exploreScaleOfSolarSystem',
  ];
  
  @override
  List<CelestialBody> generateBodies() {
    return [
      // Sun - Center of solar system
      CelestialBody(
        id: 'sun',
        type: BodyType.star,
        mass: AstronomicalData.sunMass,
        position: Vector3.zero(),
        velocity: Vector3.zero(),
        radius: AstronomicalData.sunRadius,
        temperature: AstronomicalData.sunSurfaceTemperature,
        stellarClass: StellarClass.G, // G-type main-sequence star
      ),
      
      // Mercury
      CelestialBody(
        id: 'mercury',
        type: BodyType.planet,
        mass: AstronomicalData.mercuryMass,
        position: Vector3(AstronomicalData.mercuryDistanceFromSun, 0, 0),
        velocity: Vector3(0, AstronomicalData.mercuryOrbitalVelocity, 0),
        radius: AstronomicalData.mercuryRadius,
        temperature: TemperatureUtils.calculatePlanetaryTemperature(
          AstronomicalData.mercuryDistanceFromSun,
          AstronomicalData.sunLuminosity,
          AstronomicalData.mercuryAlbedo,
        ),
      ),
      
      // Venus
      CelestialBody(
        id: 'venus',
        type: BodyType.planet,
        mass: AstronomicalData.venusMass,
        position: Vector3(AstronomicalData.venusDistanceFromSun, 0, 0),
        velocity: Vector3(0, AstronomicalData.venusOrbitalVelocity, 0),
        radius: AstronomicalData.venusRadius,
        temperature: AstronomicalData.venusSurfaceTemperature, // Greenhouse effect
      ),
      
      // Earth-Moon system
      ...ScenarioGenerator.createEarthMoonSystem(),
      
      // Mars
      CelestialBody(
        id: 'mars',
        type: BodyType.planet,
        mass: AstronomicalData.marsMass,
        position: Vector3(AstronomicalData.marsDistanceFromSun, 0, 0),
        velocity: Vector3(0, AstronomicalData.marsOrbitalVelocity, 0),
        radius: AstronomicalData.marsRadius,
        temperature: TemperatureUtils.calculatePlanetaryTemperature(
          AstronomicalData.marsDistanceFromSun,
          AstronomicalData.sunLuminosity,
          AstronomicalData.marsAlbedo,
        ),
      ),
    ];
  }
  
  @override
  CameraConfiguration get initialCamera => CameraConfiguration(
    position: Vector3(
      0, 
      0, 
      AstronomicalData.astronomicalUnit * CameraConstants.solarSystemViewDistance,
    ),
    target: Vector3.zero(),
    fieldOfView: CameraConstants.defaultFieldOfView,
  );
  
  @override
  SimulationParameters get parameters => SimulationParameters(
    timeStep: ScenarioConstants.solarSystemTimeStep,
    gravitationalConstant: PhysicsConstants.gravitationalConstant,
    enableCollisions: true,
    enableTemperatureCalculation: true,
    trailLength: ScenarioConstants.defaultTrailLength,
  );
  
  @override
  List<EducationalNote> get educationalNotes => [
    EducationalNote(
      titleKey: 'gravitationalForceTitle',
      contentKey: 'gravitationalForceExplanation',
      triggerCondition: EducationalTrigger.onStart,
      relevantBodies: ['sun', 'earth'],
    ),
    EducationalNote(
      titleKey: 'orbitalMechanicsTitle',
      contentKey: 'orbitalMechanicsExplanation',
      triggerCondition: EducationalTrigger.afterTime(Duration(seconds: 30)),
      relevantBodies: ['earth', 'mars'],
    ),
  ];
}
```

### Three-Body Problem Educational Scenario
```dart
// lib/models/scenarios/three_body_scenario.dart
class ThreeBodyScenario extends Scenario {
  @override
  String get id => 'three_body_lagrange_points';
  
  @override
  ScenarioDifficulty get difficulty => ScenarioDifficulty.intermediate;
  
  @override
  List<CelestialBody> generateBodies() {
    // Set up Earth-Moon-L4 Trojan scenario
    final earthMoonDistance = AstronomicalData.earthMoonDistance;
    final earthMoonMass = AstronomicalData.earthMass + AstronomicalData.moonMass;
    final orbitalVelocity = PhysicsUtils.calculateCircularOrbitVelocity(
      AstronomicalData.sunMass,
      AstronomicalData.astronomicalUnit,
    );
    
    return [
      // Earth at L4 Lagrange point relative to Sun-Jupiter
      CelestialBody(
        id: 'earth_primary',
        type: BodyType.planet,
        mass: AstronomicalData.earthMass,
        position: Vector3(
          AstronomicalData.astronomicalUnit * math.cos(math.pi / 3),
          AstronomicalData.astronomicalUnit * math.sin(math.pi / 3),
          0,
        ),
        velocity: Vector3(
          -orbitalVelocity * math.sin(math.pi / 3),
          orbitalVelocity * math.cos(math.pi / 3),
          0,
        ),
        radius: AstronomicalData.earthRadius,
        temperature: AstronomicalData.earthSurfaceTemperature,
      ),
      
      // Jupiter as massive perturber
      CelestialBody(
        id: 'jupiter',
        type: BodyType.planet,
        mass: AstronomicalData.jupiterMass,
        position: Vector3(
          AstronomicalData.jupiterDistanceFromSun,
          0,
          0,
        ),
        velocity: Vector3(0, AstronomicalData.jupiterOrbitalVelocity, 0),
        radius: AstronomicalData.jupiterRadius,
        temperature: AstronomicalData.jupiterSurfaceTemperature,
      ),
      
      // Small test mass at L4 point
      CelestialBody(
        id: 'trojan_asteroid',
        type: BodyType.asteroid,
        mass: ScenarioConstants.asteroidMass,
        position: Vector3(
          AstronomicalData.astronomicalUnit * math.cos(math.pi / 3) + ScenarioConstants.asteroidOffset,
          AstronomicalData.astronomicalUnit * math.sin(math.pi / 3),
          0,
        ),
        velocity: Vector3(
          -orbitalVelocity * math.sin(math.pi / 3),
          orbitalVelocity * math.cos(math.pi / 3),
          0,
        ),
        radius: ScenarioConstants.asteroidRadius,
        temperature: TemperatureUtils.calculateAsteroidTemperature(
          AstronomicalData.astronomicalUnit,
          AstronomicalData.sunLuminosity,
        ),
      ),
    ];
  }
  
  @override
  List<EducationalNote> get educationalNotes => [
    EducationalNote(
      titleKey: 'lagrangePointsTitle',
      contentKey: 'lagrangePointsExplanation',
      triggerCondition: EducationalTrigger.onStart,
      relevantBodies: ['earth_primary', 'jupiter', 'trojan_asteroid'],
      physicsFormula: 'F₁ + F₂ + F₃ = ma_centripetal',
    ),
    EducationalNote(
      titleKey: 'threeBodyStabilityTitle', 
      contentKey: 'threeBodyStabilityExplanation',
      triggerCondition: EducationalTrigger.whenBodiesClose(
        ['earth_primary', 'trojan_asteroid'],
        threshold: ScenarioConstants.closeApproachDistance,
      ),
    ),
  ];
}
```

### Educational Content Generation Utility
```dart
// lib/utils/educational_content.dart
class EducationalContent {
  /// Generate contextual explanations based on current simulation state
  static String generateDynamicExplanation(
    String templateKey,
    List<CelestialBody> relevantBodies,
    SimulationState state,
  ) {
    final template = LocalizationUtils.getTemplate(templateKey);
    final context = PhysicsAnalyzer.analyzeCurrentState(relevantBodies, state);
    
    return template.render({
      'currentForces': NumberFormatUtils.formatScientificNumber(
        context.totalForce,
        state.locale,
      ),
      'orbitalPeriod': DateTimeUtils.formatAstronomicalTime(
        context.estimatedPeriod,
        state.locale,
      ),
      'kineticEnergy': NumberFormatUtils.formatScientificNumber(
        context.kineticEnergy,
        state.locale,
      ),
      'potentialEnergy': NumberFormatUtils.formatScientificNumber(
        context.potentialEnergy,
        state.locale,
      ),
    });
  }
  
  /// Create lesson plan based on scenario and student progress
  static LessonPlan createAdaptiveLessonPlan(
    Scenario scenario,
    StudentProgress progress,
  ) {
    final objectives = scenario.learningObjectives
        .where((obj) => !progress.completedObjectives.contains(obj))
        .toList();
    
    return LessonPlan(
      title: scenario.nameKey,
      objectives: objectives,
      activities: _generateActivitiesForObjectives(objectives),
      assessmentCriteria: _generateAssessmentCriteria(objectives),
      estimatedDuration: scenario.recommendedDuration,
      difficulty: scenario.difficulty,
    );
  }
}
```

### Scenario Validation Utility
```dart
// lib/utils/physics_validator.dart
class PhysicsValidator {
  /// Validate that scenario has stable initial conditions
  static ValidationResult validateScenarioPhysics(Scenario scenario) {
    final bodies = scenario.generateBodies();
    final issues = <ValidationIssue>[];
    
    // Check for energy conservation
    final initialEnergy = PhysicsUtils.calculateTotalEnergy(bodies);
    if (!initialEnergy.isFinite) {
      issues.add(ValidationIssue(
        severity: IssueSeverity.error,
        messageKey: 'infiniteInitialEnergy',
        affectedBodies: bodies.map((b) => b.id).toList(),
      ));
    }
    
    // Check for collision-course trajectories
    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final body1 = bodies[i];
        final body2 = bodies[j];
        
        final timeToCollision = PhysicsUtils.calculateTimeToCollision(
          body1, body2);
        
        if (timeToCollision != null && 
            timeToCollision < scenario.recommendedDuration) {
          issues.add(ValidationIssue(
            severity: IssueSeverity.warning,
            messageKey: 'potentialCollision',
            affectedBodies: [body1.id, body2.id],
            estimatedTime: timeToCollision,
          ));
        }
      }
    }
    
    // Validate realistic scale
    if (!ScaleValidator.isRealisticScale(bodies)) {
      issues.add(ValidationIssue(
        severity: IssueSeverity.info,
        messageKey: 'unrealisticScale',
      ));
    }
    
    return ValidationResult(
      isValid: issues.where((i) => i.severity == IssueSeverity.error).isEmpty,
      issues: issues,
    );
  }
}
```

## ❌ WRONG Scenario Patterns (FLAG IMMEDIATELY)

```dart
// ❌ Hardcoded values instead of constants
mass: 1.989e30                              // ❌ Use AstronomicalData.sunMass
position: Vector3(149597870700, 0, 0)       // ❌ Use AstronomicalData.astronomicalUnit

// ❌ Unrealistic physics  
velocity: Vector3(0, 1000000, 0)            // ❌ Calculate realistic orbital velocity
temperature: 6000                           // ❌ Use proper temperature calculation

// ❌ No educational content
// Missing educationalNotes, learningObjectives, etc.

// ❌ Magic numbers for UI
padding: EdgeInsets.all(16.0)               // ❌ Use AppTypography.spacingLarge
```

## Educational Progression System

### Adaptive Difficulty
```dart
class ScenarioProgression {
  static Scenario getNextScenario(StudentProgress progress) {
    if (progress.completedScenarios.isEmpty) {
      return SolarSystemScenario();
    }
    
    if (progress.hasCompletedDifficulty(ScenarioDifficulty.beginner)) {
      return ThreeBodyScenario();
    }
    
    if (progress.hasCompletedDifficulty(ScenarioDifficulty.intermediate)) {
      return GalacticInteractionScenario();
    }
    
    // Advanced scenarios
    return BlackHoleAccretionScenario();
  }
}
```

### Real-Time Hints and Guidance
```dart
class EducationalHintSystem {
  static void checkForHintOpportunities(
    SimulationState state,
    StudentProgress progress,
  ) {
    // Detect interesting physics phenomena  
    final phenomena = PhysicsAnalyzer.detectPhenomena(state.bodies);
    
    for (final phenomenon in phenomena) {
      if (!progress.hasSeenPhenomenon(phenomenon.type)) {
        HintUtils.showEducationalHint(
          titleKey: phenomenon.educationalTitleKey,
          explanationKey: phenomenon.educationalExplanationKey,
          relevantBodies: phenomenon.involvedBodies,
        );
      }
    }
  }
}
```

## File Organization for Scenarios

Each scenario gets its own file with comprehensive testing:
```
lib/models/scenarios/
├── solar_system_scenario.dart
├── three_body_scenario.dart
├── binary_star_scenario.dart
├── asteroid_encounter_scenario.dart
└── galactic_interaction_scenario.dart

test/models/scenarios/
├── solar_system_scenario_test.dart
├── three_body_scenario_test.dart  
├── binary_star_scenario_test.dart
├── asteroid_encounter_scenario_test.dart
└── galactic_interaction_scenario_test.dart
```

## Reference Files

- Scenario patterns: `.github/prompts/scenario-management.md`
- Astronomical data: `lib/constants/astronomical_data.dart`
- Educational utilities: `lib/utils/educational_content.dart`
- Physics validation: `lib/utils/physics_validator.dart`