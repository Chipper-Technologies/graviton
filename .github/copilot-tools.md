# Graviton Physics Simulation Tool Set

Specialized tool set for working with Graviton's gravitational physics simulation and educational astronomy features.

## Physics Calculation Tools

### `@graviton-physics`
**Purpose**: Assist with physics calculations, orbital mechanics, and simulation accuracy

**Capabilities**:
- Calculate gravitational forces using Newton's law of universal gravitation
- Validate energy conservation in N-body systems
- Generate realistic orbital velocities and trajectories
- Check numerical stability of physics integrations
- Convert between astronomical units and SI units

**Examples**:
```
@graviton-physics Calculate the orbital velocity for Earth around the Sun
@graviton-physics Validate energy conservation for this three-body system
@graviton-physics What's the gravitational force between these two celestial bodies?
```

### `@graviton-scenarios`
**Purpose**: Create and validate educational astronomy scenarios

**Capabilities**:
- Generate realistic solar system configurations
- Create binary star systems with accurate mass ratios
- Design three-body problem scenarios for education
- Validate scenario physics for stability
- Convert real astronomical data into simulation parameters

**Examples**:
```
@graviton-scenarios Create a stable three-body scenario for intermediate students
@graviton-scenarios Generate the Jupiter-Europa system with realistic parameters
@graviton-scenarios Validate this binary star configuration for educational use
```

## Development Workflow Tools

### `@graviton-build`
**Purpose**: Handle Flutter build processes and flavor management

**Capabilities**:
- Run development vs production builds with proper configurations
- Manage `--dart-define-from-file` parameters for different environments
- Execute platform-specific builds (iOS, Android, Web)
- Handle Firebase configuration switching between dev/prod
- Run automated testing suites

**Examples**:
```
@graviton-build Run development build with Firebase dev configuration
@graviton-build Build production APK for Google Play Store
@graviton-build Execute all physics accuracy tests
```

### `@graviton-test`
**Purpose**: Generate and run comprehensive tests for physics simulation

**Capabilities**:
- Create unit tests for physics calculations with numerical precision
- Generate widget tests for UI components with haptic feedback
- Write integration tests for simulation state management
- Validate test coverage for critical physics functions
- Run accessibility tests for screen readers and haptic patterns

**Examples**:
```
@graviton-test Generate unit tests for orbital velocity calculations
@graviton-test Create widget tests for cosmic-themed UI components
@graviton-test Run accessibility tests for simulation controls
```

## Code Quality Tools

### `@graviton-standards`
**Purpose**: Enforce Graviton's strict coding standards and patterns

**Capabilities**:
- Check AppTypography constants usage (flag all magic numbers)
- Validate one-class-per-file organization
- Ensure utility functions are extracted to utils/ directories
- Verify comprehensive documentation for physics formulas
- Check internationalization compliance for 7 supported languages

**Examples**:
```
@graviton-standards Review this widget for AppTypography compliance
@graviton-standards Check if this class needs to be split into separate files
@graviton-standards Validate documentation for this physics utility function
```

### `@graviton-i18n`
**Purpose**: Manage internationalization for 7 languages with scientific accuracy

**Capabilities**:
- Generate ARB keys for new UI text
- Translate scientific terms consistently across languages
- Format numbers and units culturally appropriately
- Validate translation completeness across all supported locales
- Handle physics terminology that should remain consistent

**Examples**:
```
@graviton-i18n Generate ARB keys for these new simulation controls
@graviton-i18n How should "gravitational constant" be localized for Japanese?
@graviton-i18n Format this mass value appropriately for German locale
```

## Performance & Rendering Tools

### `@graviton-performance`
**Purpose**: Optimize rendering performance for 60fps physics simulation

**Capabilities**:
- Analyze CustomPainter performance bottlenecks
- Optimize trail rendering and memory usage
- Implement level-of-detail rendering based on camera distance
- Monitor frame timing and detect performance issues
- Suggest spatial partitioning improvements for N-body calculations

**Examples**:
```
@graviton-performance Optimize this trail painter for better frame rates
@graviton-performance Analyze memory usage during long simulations
@graviton-performance Implement LOD rendering for this celestial body painter
```

### `@graviton-3d`
**Purpose**: Handle 3D coordinate transformations and camera systems

**Capabilities**:
- Transform 3D simulation coordinates to 2D screen positions
- Implement cinematic camera movements and controls
- Calculate proper perspective and depth for celestial bodies
- Handle camera rotation and zoom with physics-appropriate constraints
- Generate camera animations for educational demonstrations

**Examples**:
```
@graviton-3d Transform these celestial body positions to screen coordinates
@graviton-3d Implement smooth camera tracking for this orbital motion
@graviton-3d Create a cinematic flyby animation for the solar system
```

## Educational Content Tools

### `@graviton-education`
**Purpose**: Create scientifically accurate educational content and tutorials

**Capabilities**:
- Generate lesson plans based on physics concepts
- Create interactive tutorials for different difficulty levels
- Validate astronomical accuracy of educational scenarios
- Design progressive learning experiences
- Generate explanatory text for complex physics phenomena

**Examples**:
```
@graviton-education Create a tutorial for understanding Lagrange points
@graviton-education Design a lesson plan for orbital mechanics
@graviton-education Explain gravitational slingshot effects for beginners
```

### `@graviton-accessibility`
**Purpose**: Ensure inclusive design for users with disabilities

**Capabilities**:
- Implement screen reader support for physics simulations
- Design haptic feedback patterns for different collision types
- Create audio descriptions of gravitational interactions
- Ensure keyboard navigation for all simulation controls
- Validate WCAG compliance for cosmic-themed UI

**Examples**:
```
@graviton-accessibility Add screen reader support for this simulation control
@graviton-accessibility Design haptic patterns for planetary collisions
@graviton-accessibility Create audio descriptions for this orbital animation
```

## Integration & Firebase Tools

### `@graviton-firebase`
**Purpose**: Manage Firebase services and remote configuration

**Capabilities**:
- Configure analytics for simulation usage patterns
- Implement A/B testing for educational features
- Manage remote config for feature flags and physics parameters
- Handle crashlytics reporting with simulation context
- Coordinate dev/prod Firebase project configurations

**Examples**:
```
@graviton-firebase Set up analytics for tracking simulation interactions
@graviton-firebase Configure remote config for new physics parameters
@graviton-firebase Debug crashlytics integration for this service
```

## Usage Instructions

1. **Activate Tool Set**: Use `@graviton-[toolname]` prefix in Copilot chat
2. **Provide Context**: Include relevant file paths and specific requirements
3. **Specify Standards**: Reference AppTypography usage and file organization requirements
4. **Educational Focus**: Mention if content is for educational/tutorial purposes

## Integration with Existing Configuration

These tool sets complement the existing GitHub Copilot configuration:
- **Instructions** (`.github/instructions/`): Applied automatically to all interactions
- **Chat Modes** (`.github/chatmodes/`): Interactive specialized assistance
- **Prompts** (`.github/prompts/`): Detailed reference documentation

## Examples of Combined Usage

```
@graviton-physics @graviton-standards Calculate Earth-Moon orbital mechanics with proper AppTypography constants

@graviton-build @graviton-test Build development version and run physics accuracy tests

@graviton-education @graviton-accessibility Create an accessible tutorial for three-body problems

@graviton-performance @graviton-3d Optimize celestial body rendering with efficient 3D transformations
```

These tool sets are specifically designed for Graviton's unique combination of physics simulation, educational content, multi-language support, and strict code quality standards.