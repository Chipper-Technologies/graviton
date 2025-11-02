# 🎬 Cinematic Camera Techniques

## Overview

Graviton's AI-driven cinematic camera system transforms the viewing experience by intelligently controlling camera movement to highlight the most dramatic and educational moments in gravitational simulations. The system offers three distinct approaches: manual control for traditional interaction, predictive orbital for educational tours, and dynamic framing for chaotic action tracking.

## Table of Contents

- [System Architecture](#system-architecture)
- [Available Techniques](#available-techniques)
  - [Manual Control](#1-manual-control)
  - [Predictive Orbital](#2-predictive-orbital)
  - [Dynamic Framing](#3-dynamic-framing)
- [Technical Implementation](#technical-implementation)
- [Configuration](#configuration)
- [Usage Guidelines](#usage-guidelines)

---

## System Architecture

The cinematic camera system is built on two core approaches:

1. **Predictive Orbital**: Tours and orbital predictions for educational scenarios
   - Predetermined cinematic tours for specific scenarios
   - Orbital mechanics predictions for event anticipation
   - Smooth, educational camera movements

2. **Dynamic Framing**: Real-time dramatic interactions for chaotic scenarios
   - Dramatic targeting system for random scenarios
   - Ultra-aggressive close-ups for chaotic interactions
   - Emergency transition interruption for dramatic moments
   - Real-time framing validation and ejection detection

### Key Technologies
- **Runge-Kutta 4th Order Integration**: For precise orbital predictions
- **Vector Mathematics**: 3D positioning and movement calculations
- **Compositional Rules**: Rule of thirds, leading lines, and framing principles
- **Physics Analysis**: Gravitational force analysis and momentum tracking

---

## Available Techniques

### 1. 📍 Manual Control
**Description**: Traditional user-controlled camera positioning with full manual control.

**Use Case**: When users want complete control over their viewing experience or for educational demonstrations requiring specific angles.

**Features**:
- Direct touch controls for pan, zoom, and rotation
- No AI interference or automated movements
- Immediate response to user input
- Best for: Educational presentations, detailed inspections, user-driven exploration

**AI Level**: None - Full manual control

---

### 2. 🔮 Predictive Orbital
**Description**: AI tours and orbital predictions for educational scenarios. Provides predetermined cinematic tours for specific scenarios and uses orbital mechanics predictions for event anticipation.

**Use Case**: Educational scenarios with known orbital patterns - solar system tours, earth-moon-sun dynamics, binary star interactions, asteroid belt navigation, and galaxy formation visualization.

**Technical Implementation**:
- **Predetermined Tours**: Smooth cinematic paths designed for specific scenarios
- **Orbital Prediction Engine**: Uses RK4 integration to simulate future body positions
- **Event Detection**: Identifies close approaches, periapsis/apoapsis passages, and orbital crossings
- **Smooth Transitions**: Interpolates camera movement with educational pacing

**Key Features**:
- Solar system planet tour with smooth transitions
- Earth-moon-sun phase-based viewing
- Binary star balanced perspectives
- Asteroid belt smooth navigation
- Galaxy formation sweeping orbital views

**Configuration Options**:
- **Look-ahead time**: How far into the future to predict (1-60 seconds)
- **Tour duration**: Length of each tour phase
- **Transition speed**: Speed of camera movements between positions
- **Educational pacing**: Timing optimized for learning

**Best for**: Educational content, known scenarios, smooth cinematic experiences

---

### 3. 🖼️ Dynamic Framing
**Description**: Real-time dramatic targeting for chaotic scenarios. Provides ultra-aggressive close-ups and reactive camera work for unpredictable interactions.

**Use Case**: Random scenarios, chaotic three-body problems, collision detection, ejection events, and any unpredictable gravitational dynamics.

**Technical Implementation**:
- **Dramatic Targeting System**: Exponential scoring for close encounters and collisions
- **Ejection Detection**: Multi-layer filtering to identify separated vs interacting bodies
- **Emergency Interruption**: Breaks transitions immediately for highly dramatic moments
- **Real-time Framing Validation**: Continuously ensures bodies stay in view
- **Ultra-aggressive Parameters**: Tight safety margins for maximum drama

**Key Features**:
- Ultra-close dramatic shots (1.5-35 unit distance range)
- 4x faster transitions for reactive tracking
- Emergency drama interruption (< 5 units or score > 80)
- Aggressive ejection detection (2.5 separation threshold)
- Real-time framing correction to prevent losing action

**Configuration Options**:
- **Drama sensitivity**: Threshold for detecting dramatic interactions
- **Safety margin**: Minimum distance multiplier (0.8-2.0)
- **Transition speed**: 4x faster for chaotic scenarios
- **Stickiness**: How long to hold on dramatic moments

**Best for**: Random scenarios, chaotic dynamics, collision courses, ejection events

---

## Technical Implementation
**Description**: Camera movements that respond to gravitational forces and momentum changes.

**Use Case**: Creates camera motion that mirrors the physics of the simulation, making gravitational effects more intuitive and visceral.

**Technical Implementation**:
- **Force Visualization**: Camera movement reflects dominant gravitational forces
- **Momentum Tracking**: Camera follows momentum changes in the system
- **Energy Visualization**: Camera distance and movement speed reflect system energy
- **Gravitational Flow**: Camera path follows gravitational field lines

**Key Behaviors**:
- Camera "pulled" toward massive objects during close approaches
- Faster movement during high-energy interactions
- Gentle drifting motion during stable orbital periods
- Sudden movements during collisions or ejections

**Configuration Options**:
- **Force sensitivity**: How strongly camera responds to gravitational forces
- **Momentum damping**: Smoothing factor for camera movements
- **Energy scaling**: How energy changes affect camera motion
- **Maximum response**: Limits on camera movement speed

**Best for**: Three-body chaos, gravitational slingshots, collision scenarios

---

## Technical Implementation

### Core Architecture

The cinematic camera system is implemented through two main approaches:

#### CinematicCameraController
```dart
class CinematicCameraController {
  // Main camera control dispatcher
  void updateCamera(CameraTechnique technique, SimulationState state);
  
  // Predictive orbital: Tours and predictions
  void _handlePredictiveOrbital(SimulationState state);
  
  // Dynamic framing: Real-time dramatic targeting
  void _handleDynamicFraming(SimulationState state);
  
  // Smooth camera transitions with scenario-specific speeds
  void _updateCameraForBodies(List<Body> bodies, CameraState camera);
}
```

#### Key Features

**Predictive Orbital Implementation**:
- Predetermined tour phases for educational scenarios
- Orbital prediction engine for unknown scenarios
- Smooth transitions with educational pacing
- Phase-based camera positioning

**Dynamic Framing Implementation**:
- Dramatic interaction scoring with exponential distance weighting
- Emergency transition interruption for highly dramatic moments
- Real-time framing validation to keep action in view
- Ultra-aggressive camera parameters for maximum drama

### Configuration

#### Scenario-Specific Parameters
```dart
class ScenarioCameraParameters {
  final double safetyMargin;      // Distance multiplier for framing
  final double minDistance;       // Closest camera position
  final double maxDistance;       // Furthest camera position
  final int targetLockFrames;     // How long to hold dramatic shots
  final double orbitSpeed;        // Camera movement speed
}
```

**Random Scenario (Dynamic Framing)**:
- `safetyMargin: 1.3` - Dramatic but safe framing
- `minDistance: 1.5` - Ultra-close shots
- `maxDistance: 35.0` - Tight maximum framing
- `targetLockFrames: 360` - 6 seconds for intense action

**Educational Scenarios (Predictive Orbital)**:
- Higher safety margins for stable viewing
- Longer lock frames for educational pacing
- Smoother transition speeds

---

## Usage Guidelines

### When to Use Each Technique

**Manual Control**:
- Traditional user interaction
- Custom camera work
- When AI techniques don't suit the scenario

**Predictive Orbital**:
- Educational content creation
- Known orbital scenarios (solar system, binary stars)
- Smooth, cinematic presentations
- Tours and guided experiences

**Dynamic Framing**:
- Chaotic scenarios (random, three-body)
- Action-focused viewing
- Collision and ejection events
- Maximum drama and engagement

### Performance Considerations

1. **Predictive Orbital**: Low performance impact, predetermined paths
2. **Dynamic Framing**: Moderate impact due to real-time calculations
3. **Manual**: Minimal performance impact

### Accessibility

All techniques support:
- Smooth motion for motion sensitivity
- Configurable transition speeds
- Manual override capability
- Educational timing options

---

## Future Development

The simplified architecture provides a solid foundation for:
- Enhanced tour creation tools
- More sophisticated dramatic targeting
- User-customizable camera behaviors
- Integration with educational content systems
class CameraMovement {
  final Vector3 targetPosition;         // Where camera should move
  final Vector3 targetLookAt;          // What camera should look at
  final double targetDistance;          // Optimal viewing distance
  final Duration transitionTime;        // How long transition should take
  final CameraMovementType type;        // smooth, quick, dramatic
}
```

### Configuration System

#### PredictiveOrbitalConfig
```dart
class PredictiveOrbitalConfig {
  final double lookAheadTime;           // 1-60 seconds
  final double eventSensitivity;        // 0.1-1.0
  final double cameraLeadTime;          // 0.5-5.0 seconds
  final double transitionSpeed;         // 0.1-2.0 multiplier
}
```

---

## Configuration

### Global Settings
All cinematic camera techniques can be configured through the app settings:

1. Open the Settings dialog
2. Navigate to "Camera Controls" section
3. Select desired technique from dropdown
4. Configure technique-specific parameters (when available)

### Technique Selection
```dart
// Example of technique selection in UI
DropdownButton<CinematicCameraTechnique>(
  value: currentTechnique,
  items: CinematicCameraTechnique.values.map((technique) =>
```dart
// Example of technique selection in UI
DropdownButton<CinematicCameraTechnique>(
  value: currentTechnique,
  items: CinematicCameraTechnique.values.map((technique) =>
    DropdownMenuItem(
      value: technique,
      child: Text(technique.displayName),
    )
  ).toList(),
  onChanged: (technique) => uiState.setCinematicCameraTechnique(technique),
)
```

### Advanced Configuration
For developers and advanced users, technique parameters can be modified in:
- `lib/services/cinematic_camera_controller.dart`
- `lib/enums/cinematic_camera_technique.dart`

---

*Last updated: October 2025*
*Part of the Graviton Physics Simulator project*