# README for GitHub Copilot Prompts

This directory contains specialized prompts for GitHub Copilot to help with Graviton development. Each prompt is tailored to specific aspects of this Flutter-based gravitational physics simulation app.

## Available Prompts

### Code Quality & Standards
- **[code-quality-standards.md](./code-quality-standards.md)** - **START HERE** - Non-negotiable coding standards including AppTypography usage, file organization, and no magic numbers policy

### Core Development
- **[physics-calculations.md](./physics-calculations.md)** - Guidelines for implementing accurate gravitational physics, N-body calculations, and numerical stability
- **[flutter-state-management.md](./flutter-state-management.md)** - Provider pattern usage, state architecture, and best practices for simulation state
- **[custom-painter-rendering.md](./custom-painter-rendering.md)** - Performance-optimized rendering with CustomPainter, 3D transformations, and trail visualization

### User Experience
- **[internationalization.md](./internationalization.md)** - i18n patterns for 7 supported languages, ARB file management, and scientific terminology
- **[accessibility.md](./accessibility.md)** - Screen reader support, haptic feedback for physics events, and keyboard navigation
- **[theme-visual-design.md](./theme-visual-design.md)** - Space-themed design system, stellar colors, and responsive layouts

### Features & Integration
- **[scenario-management.md](./scenario-management.md)** - Custom scenario creation, validation, and educational physics configurations
- **[firebase-integration.md](./firebase-integration.md)** - Analytics, crash reporting, remote config, and feature flags
- **[performance-optimization.md](./performance-optimization.md)** - 60fps targets, memory management, and spatial optimization algorithms
- **[testing.md](./testing.md)** - Unit tests, physics validation, widget testing, and performance benchmarks

## How to Use These Prompts

### Method 1: Reference in Comments
Add a reference to the relevant prompt in your code comments:
```dart
// @prompt physics-calculations.md
// Calculate gravitational force between two bodies
Vector3 calculateGravitationalForce(Body body1, Body body2) {
  // Implementation here
}
```

### Method 2: Copy Prompt Content
Copy the relevant sections from a prompt file and paste them as context when asking Copilot for help.

### Method 3: Include in Chat Context
When starting a chat with Copilot, mention which prompt file is relevant:
"Using the guidelines in physics-calculations.md, help me implement orbital velocity calculations."

## Project-Specific Context

Graviton is an educational physics simulation app with these key characteristics:

- **Target**: Educational users learning orbital mechanics
- **Languages**: 7 supported languages (EN, ES, FR, DE, JA, ZH, RU)
- **Platform**: Flutter (iOS, Android, Web)
- **Architecture**: Provider for state management, CustomPainter for rendering
- **Performance**: 60fps with up to 50 celestial bodies
- **Features**: Real-time physics, 3D visualization, custom scenarios, haptic feedback

## Code Quality Standards

When using these prompts, ensure your code meets these **NON-NEGOTIABLE** standards:

1. **AppTypography Constants** - Use `AppTypography` for ALL font sizes, opacity, spacing, icon sizes, and dimensions
2. **No Magic Numbers** - Every numeric value must be a named constant  
3. **One Class Per File** - Each class, model, and enum gets its own file with unit tests
4. **Utility Extraction** - Common functions go in `utils/` files, not private methods in classes
5. **Documentation** - All public APIs must have comprehensive documentation with examples
6. **Physics Accuracy** - Use proper constants, handle edge cases, maintain numerical stability
7. **Performance** - Target 60fps, optimize memory usage, use efficient algorithms  
8. **Internationalization** - All user-facing text must be localized
9. **Accessibility** - Support screen readers, keyboard navigation, and haptic feedback
10. **Testing** - Comprehensive coverage especially for physics calculations

## Contributing

When adding new prompts or updating existing ones:

1. Follow the established format and structure
2. Include practical code examples
3. Reference specific file locations in the project
4. Add testing guidance where applicable
5. Keep educational context in mind

## Related Documentation

- Project architecture: `docs/ARCHITECTURE.md`
- Performance guidelines: `docs/PERFORMANCE.md`
- Testing strategy: `test/README.md`
- Internationalization: `tools/i18n_manager.py`