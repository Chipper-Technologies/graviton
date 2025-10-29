# 🏗️ Graviton Architecture Documentation

This document provides a comprehensive overview of the Graviton app's architecture, design patterns, and implementation details.

## 📋 Table of Contents

- [🎯 Architecture Overview](#-architecture-overview)
- [📊 Architecture Diagram](#-architecture-diagram)
- [🏗️ Layer Breakdown](#️-layer-breakdown)
- [🔄 State Management](#-state-management)
- [🎨 Rendering System](#-rendering-system)
- [⚙️ Service Layer](#️-service-layer)
- [📱 UI Components](#-ui-components)
- [🌐 Internationalization](#-internationalization)
- [🔧 Configuration](#-configuration)
- [📁 Project Structure](#-project-structure)
- [🔗 Dependencies](#-dependencies)
- [🎯 Design Patterns](#-design-patterns)

## 🎯 Architecture Overview

Graviton follows a **clean architecture** approach with clear separation of concerns, ensuring maintainability, testability, and scalability. The app is built using Flutter with the Provider pattern for state management and custom painters for high-performance 3D rendering.

### Core Principles

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Provider Pattern**: Reactive state management throughout the app
- **Modular Design**: Specialized painters and services for different features

## 📊 Architecture Diagram

```mermaid
graph TB
    %% Entry Point
    Main["`**main.dart**
    App Entry Point
    - Flutter app initialization
    - Firebase setup
    - Flavor configuration
    - Device orientation setup`"]

    %% App Layer
    GravitonApp["`**GravitonApp**
    Root Application Widget
    - Provider setup
    - Localization
    - Theme configuration
    - Navigation setup`"]

    %% Screen Layer
    HomeScreen["`**HomeScreen**
    Main Application Screen
    - Simulation canvas
    - UI controls overlay
    - Gesture handling
    - Screenshot mode`"]

    %% State Management Layer (Provider Pattern)
    subgraph StateManagement["State Management (Provider)"]
        AppState["`**AppState**
        Central State Coordinator
        - Manages child states
        - Language handling
        - Error management
        - State synchronization`"]
        
        SimulationState["`**SimulationState**
        Physics Simulation Control
        - Start/stop/pause
        - Time scaling
        - Step counting
        - Scenario management`"]
        
        UIState["`**UIState**
        UI Settings & Preferences
        - Visual toggles
        - Opacity settings
        - Language selection
        - Persistent storage`"]
        
        CameraState["`**CameraState**
        3D Camera Control
        - View matrices
        - Auto-rotation
        - Zoom/pan handling
        - Scenario positioning`"]
        
        PhysicsState["`**PhysicsState**
        Physics Parameters
        - Per-scenario settings
        - Constants management
        - Parameter persistence`"]
    end

    %% Service Layer
    subgraph ServiceLayer["Service Layer"]
        SimulationService["`**Simulation Service**
        Core Physics Engine
        - Gravitational calculations
        - Collision detection
        - Body management
        - Trail system`"]
        
        ScenarioService["`**Scenario Service**
        Scenario Generation
        - Predefined setups
        - Body initialization
        - Astronomical accuracy`"]
        
        TemperatureService["`**Temperature Service**
        Thermal Modeling
        - Stellar radiation
        - Planetary temperatures
        - Habitability calculations`"]
        
        HabitableZoneService["`**Habitable Zone Service**
        Life Zone Calculations
        - Zone boundaries
        - Habitability status
        - Dynamic updates`"]
        
        FirebaseService["`**Firebase Service**
        Analytics & Crashlytics
        - Event tracking
        - Performance monitoring
        - Error reporting`"]
        
        RemoteConfigService["`**Remote Config Service**
        Feature Flags
        - A/B testing
        - Configuration management
        - Maintenance mode`"]
        
        VersionService["`**Version Service**
        App Updates
        - Version checking
        - Update prompts
        - Store redirects`"]
        
        ScreenshotModeService["`**Screenshot Mode Service**
        Screenshot Features
        - UI hiding
        - Preset configurations
        - Timer functionality`"]
    end

    %% Rendering Layer (Custom Painters)
    subgraph RenderingLayer["Rendering Layer (Custom Painters)"]
        GravitonPainter["`**GravitonPainter**
        Main Orchestrator
        - Coordinates all painters
        - 3D transformations
        - Depth sorting`"]
        
        CelestialBodyPainter["`**CelestialBody Painter**
        Planet Rendering
        - Realistic planets
        - Ring systems
        - Special effects`"]
        
        TrailPainter["`**Trail Painter**
        Motion History
        - Orbital trails
        - Warm/cool modes
        - Fade effects`"]
        
        BackgroundPainter["`**Background Painter**
        Space Environment
        - Starfield
        - Distant galaxies
        - Space gradients`"]
        
        OrbitalPathPainter["`**Orbital Path Painter**
        Predictive Paths
        - Future trajectories
        - Dual mode display`"]
        
        HabitabilityPainter["`**Habitability Painter**
        Life Zone Indicators
        - Zone visualization
        - Status indicators`"]
        
        GravityPainter["`**Gravity Painter**
        Field Visualization
        - Gravity wells
        - Field strength`"]
        
        EffectsPainter["`**Effects Painter**
        Visual Effects
        - Merge flashes
        - Collision effects`"]
        
        AsteroidBeltPainter["`**Asteroid Belt Painter**
        Particle Systems
        - Belt rendering
        - Particle management`"]
    end

    %% Widget Layer
    subgraph WidgetLayer["Widget Layer"]
        FloatingControls["`**Floating Controls**
        Simulation Control
        - Play/pause/reset
        - Auto-hide timer`"]
        
        SettingsDialog["`**Settings Dialog**
        Configuration UI
        - Physics parameters
        - Visual settings
        - Language selection`"]
        
        BottomControls["`**Bottom Controls**
        Camera & UI Controls
        - Stats toggle
        - Camera controls`"]
        
        StatsOverlay["`**Stats Overlay**
        Performance Info
        - FPS counter
        - Physics data
        - Time information`"]
        
        ScenarioSelector["`**Scenario Selector**
        Scenario Selection
        - Preset scenarios
        - Descriptions`"]
    end

    %% Model Layer
    subgraph ModelLayer["Model Layer"]
        Body["`**Body Model**
        Celestial Objects
        - Position/velocity
        - Mass/radius
        - Visual properties`"]
        
        TrailPoint["`**Trail Point**
        Motion History
        - Position data
        - Timestamp`"]
        
        PhysicsSettings["`**Physics Settings**
        Parameter Storage
        - Scenario-specific
        - Serialization`"]
        
        ScreenshotModels["`**Screenshot Models**
        Screenshot Config
        - Preset definitions
        - UI state storage`"]
    end

    %% Utils Layer
    subgraph UtilsLayer["Utilities"]
        PainterUtils["`**Painter Utils**
        3D Mathematics
        - Projections
        - Transformations`"]
        
        StarGenerator["`**Star Generator**
        Background Stars
        - Random generation
        - 3D positioning`"]
        
        VectorUtils["`**Vector Utils**
        Math Operations
        - Vector calculations
        - Utility functions`"]
    end

    %% Configuration
    subgraph ConfigLayer["Configuration"]
        FlavorConfig["`**Flavor Config**
        Build Variants
        - Dev/Prod modes
        - Feature flags`"]
        
        Constants["`**Constants**
        Physics & Rendering
        - Simulation constants
        - Rendering parameters`"]
        
        LocalizationFiles["`**Localization**
        Multi-language Support
        - 7 languages
        - ARB files`"]
    end

    %% External Dependencies
    subgraph ExternalDeps["External Dependencies"]
        Firebase["`**Firebase**
        - Analytics
        - Crashlytics
        - Remote Config`"]
        
        SharedPrefs["`**Shared Preferences**
        - Settings persistence
        - User preferences`"]
        
        VectorMath["`**Vector Math**
        - 3D mathematics
        - Matrix operations`"]
        
        Provider["`**Provider**
        - State management
        - Dependency injection`"]
    end

    %% Connections
    Main --> GravitonApp
    GravitonApp --> HomeScreen
    GravitonApp --> StateManagement
    
    HomeScreen --> WidgetLayer
    HomeScreen --> RenderingLayer
    
    StateManagement --> ServiceLayer
    StateManagement --> SharedPrefs
    
    ServiceLayer --> ModelLayer
    ServiceLayer --> Firebase
    
    RenderingLayer --> UtilsLayer
    RenderingLayer --> ModelLayer
    RenderingLayer --> VectorMath
    
    WidgetLayer --> StateManagement
    WidgetLayer --> Provider
    
    ConfigLayer --> StateManagement
    ConfigLayer --> ServiceLayer
    
    %% State relationships
    AppState --> SimulationState
    AppState --> UIState
    AppState --> CameraState
    AppState --> PhysicsState
    
    SimulationState --> SimulationService
    UIState --> LocalizationFiles
    PhysicsState --> PhysicsSettings
    
    %% Service relationships
    SimulationService --> ScenarioService
    SimulationService --> TemperatureService
    SimulationService --> HabitableZoneService
    
    %% Painter orchestration
    GravitonPainter --> CelestialBodyPainter
    GravitonPainter --> TrailPainter
    GravitonPainter --> BackgroundPainter
    GravitonPainter --> OrbitalPathPainter
    GravitonPainter --> HabitabilityPainter
    GravitonPainter --> GravityPainter
    GravitonPainter --> EffectsPainter
    GravitonPainter --> AsteroidBeltPainter

    %% Styling
    classDef stateClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef serviceClass fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef painterClass fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef widgetClass fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef modelClass fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    classDef configClass fill:#f1f8e9,stroke:#33691e,stroke-width:2px
    classDef externalClass fill:#fafafa,stroke:#424242,stroke-width:2px
    
    class AppState,SimulationState,UIState,CameraState,PhysicsState stateClass
    class SimulationService,ScenarioService,TemperatureService,HabitableZoneService,FirebaseService,RemoteConfigService,VersionService,ScreenshotModeService serviceClass
    class GravitonPainter,CelestialBodyPainter,TrailPainter,BackgroundPainter,OrbitalPathPainter,HabitabilityPainter,GravityPainter,EffectsPainter,AsteroidBeltPainter painterClass
    class FloatingControls,SettingsDialog,BottomControls,StatsOverlay,ScenarioSelector widgetClass
    class Body,TrailPoint,PhysicsSettings,ScreenshotModels modelClass
    class FlavorConfig,Constants,LocalizationFiles configClass
    class Firebase,SharedPrefs,VectorMath,Provider externalClass
```

## 🏗️ Layer Breakdown

### 1. Presentation Layer

**HomeScreen** serves as the main application screen, orchestrating:
- Canvas for 3D simulation rendering
- Overlay UI controls and dialogs
- Gesture handling for camera control
- Screenshot mode functionality

### 2. State Management Layer

Built on the **Provider pattern** with hierarchical state management:

- **AppState**: Central coordinator managing all child states
- **SimulationState**: Controls physics simulation lifecycle
- **UIState**: Manages visual settings and user preferences
- **CameraState**: Handles 3D camera positioning and movement
- **PhysicsState**: Per-scenario physics parameter management

### 3. Service Layer

Business logic and external integrations:

- **Core Physics**: Gravitational calculations and collision detection
- **Scenario Management**: Predefined astronomical setups
- **Environmental Services**: Temperature and habitability calculations
- **External Services**: Firebase analytics, remote config, version management

### 4. Rendering Layer

High-performance custom painters using Flutter's Canvas API:

- **Modular Design**: Specialized painters for different visual elements
- **3D Mathematics**: Vector transformations and projections
- **Performance Optimized**: Efficient rendering for 60fps target

### 5. Model Layer

Pure data classes representing domain entities:

- **Celestial Bodies**: Position, velocity, mass, and visual properties
- **Physics Parameters**: Configurable simulation constants
- **Configuration Models**: Settings and preferences

## 🔄 State Management

### Provider Pattern Implementation

```dart
// Hierarchical state management
AppState
├── SimulationState (physics simulation)
├── UIState (user preferences)
├── CameraState (3D camera control)
└── PhysicsState (physics parameters)
```

### State Synchronization

- **Reactive Updates**: All UI components listen to relevant state changes
- **Persistence**: Settings automatically saved to SharedPreferences
- **Error Handling**: Centralized error management through AppState

### Language Handling

Dynamic language switching with proper state management:
- Language changes trigger UI rebuilds
- Scenario names update with new localization
- Persistent language preference storage

## 🎨 Rendering System

### Custom Painter Architecture

The rendering system uses a **main orchestrator pattern**:

```dart
GravitonPainter (Main Orchestrator)
├── BackgroundPainter (starfield, galaxies)
├── TrailPainter (motion history)
├── OrbitalPathPainter (predictive paths)
├── HabitabilityPainter (life zones)
├── CelestialBodyPainter (planets, rings)
├── GravityPainter (field visualization)
├── EffectsPainter (collisions, flashes)
└── AsteroidBeltPainter (particle systems)
```

### 3D Mathematics

- **Vector Math**: Using `vector_math` library for matrix operations
- **Projection**: 3D world coordinates to 2D screen coordinates
- **Depth Sorting**: Back-to-front rendering for proper visual layering
- **Camera System**: Full 3D camera with pan, zoom, and rotation

### Performance Optimization

- **Efficient Trail Rendering**: Configurable opacity and warm/cool modes
- **Culling**: Objects outside view frustum aren't rendered
- **LOD System**: Distance-based level of detail for complex objects
- **Batch Rendering**: Multiple particles rendered efficiently

## ⚙️ Service Layer

### Core Physics Engine

**Simulation Service** implements:
- **N-body Gravitational Simulation**: Real-time physics calculations
- **Collision Detection**: Accurate body-to-body collision handling
- **Trail Management**: Motion history tracking and rendering
- **Time Scaling**: Adjustable simulation speed

### Scenario Management

**Scenario Service** provides:
- **Predefined Setups**: Solar system, binary stars, three-body problems
- **Astronomical Accuracy**: Realistic orbital mechanics
- **Dynamic Generation**: Procedural content for educational scenarios

### Environmental Services

- **Temperature Service**: Stellar radiation and planetary temperature modeling
- **Habitable Zone Service**: Life zone calculations and habitability status
- **Asteroid Belt System**: Particle-based belt rendering

### External Services

- **Firebase Integration**: Analytics, crashlytics, and remote configuration
- **Version Management**: Dual-threshold update system
- **Screenshot Mode**: Development-only feature for marketing materials

## 📱 UI Components

### Modular Widget Design

- **Floating Controls**: Video-style play/pause/reset controls
- **Settings Dialog**: Comprehensive configuration interface
- **Stats Overlay**: Real-time performance and physics data
- **Scenario Selector**: Educational scenario picker
- **Bottom Controls**: Camera and UI toggle controls

### Responsive Design

- **Adaptive Layout**: Works across phone, tablet, and web platforms
- **Gesture Handling**: Intuitive touch controls for 3D navigation
- **Accessibility**: Screen reader support and semantic labels

## 🌐 Internationalization

### Multi-language Support

- **7 Languages**: English, Spanish, French, German, Chinese, Japanese, Korean
- **ARB Format**: Industry-standard localization files
- **Dynamic Switching**: Runtime language changes
- **Educational Content**: Scenario names and descriptions localized

### Implementation

```dart
// Localization structure
l10n/
├── app_en.arb (template)
├── app_es.arb
├── app_fr.arb
├── app_de.arb
├── app_zh.arb
├── app_ja.arb
└── app_ko.arb
```

## 🔧 Configuration

### Build Variants

**Flavor Configuration** supports:
- **Development**: Debug features, screenshot mode, verbose logging
- **Production**: Optimized performance, analytics enabled

### Constants Management

- **Physics Constants**: Gravitational parameters, collision settings
- **Rendering Constants**: 3D projection parameters, visual settings
- **Educational Focus**: Keys for educational content organization

## 📁 Project Structure

```
lib/
├── main.dart                     # App entry point
├── config/                       # Configuration management
├── constants/                    # Application constants
├── enums/                        # Type definitions
├── l10n/                        # Internationalization
├── models/                      # Data models
├── services/                    # Business logic
├── state/                       # State management
├── utils/                       # Utilities
├── painters/                    # Rendering engines
├── widgets/                     # UI components
├── screens/                     # Application screens
└── theme/                       # Design system
```

## 🔗 Dependencies

### Core Dependencies

- **Flutter SDK**: Cross-platform UI framework
- **Provider**: State management solution
- **Vector Math**: 3D mathematics library
- **Shared Preferences**: Local data persistence

### Firebase Dependencies

- **Firebase Core**: Firebase initialization
- **Firebase Analytics**: User behavior tracking
- **Firebase Crashlytics**: Error reporting
- **Firebase Remote Config**: Feature flag management

### Development Dependencies

- **Flutter Test**: Unit and widget testing
- **Integration Test**: End-to-end testing
- **Build Runner**: Code generation
- **Flutter Launcher Icons**: Icon generation

## 🎯 Design Patterns

### Implemented Patterns

1. **Provider Pattern**: Reactive state management
2. **Orchestrator Pattern**: Main painter coordinates specialized painters
3. **Service Layer Pattern**: Business logic encapsulation
4. **Repository Pattern**: Data access abstraction
5. **Observer Pattern**: State change notifications
6. **Strategy Pattern**: Different rendering strategies for objects
7. **Factory Pattern**: Scenario and object creation
8. **Singleton Pattern**: Service instances and configuration

### Architecture Benefits

- **Maintainability**: Clear separation of concerns
- **Testability**: Each layer can be tested independently
- **Scalability**: Easy to add new features and scenarios
- **Performance**: Optimized rendering and physics calculations
- **Educational Value**: Clean code serves as learning resource

---

## 📚 Related Documentation

- [README.md](../README.md) - Project overview and getting started
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Development guidelines
- [docs/CAMERA_TECHNIQUES.md](CAMERA_TECHNIQUES.md) - Camera system documentation
- [test/README.md](../test/README.md) - Testing strategy and organization

---

*This architecture documentation is maintained alongside the codebase and should be updated when significant architectural changes are made.*