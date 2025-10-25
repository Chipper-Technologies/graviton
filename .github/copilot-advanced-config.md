# GitHub Copilot Advanced Review Configuration

## Project-Specific Review Patterns

### Physics & Mathematics Review Prompts

When reviewing files in `lib/services/simulation.dart` or physics-related code:
```
Focus on:
- Numerical stability of integration methods
- Correct implementation of gravitational formulas (F = G * m1 * m2 / r²)
- Proper handling of collision detection and response
- Unit consistency throughout calculations
- Performance implications of mathematical operations in render loops
- Proper encapsulation of physics parameters with private fields and public getters
```

### UI/UX Review Prompts

When reviewing files in `lib/widgets/` or `lib/screens/`:
```
Focus on:
- Accessibility compliance (semantics, contrast, navigation)
- Proper state management using Provider pattern
- Localization completeness (no hardcoded strings)
- Responsive design across different screen sizes
- Loading states and error handling for user interactions
- Performance of custom painters and animations
```

### Localization Review Prompts

When reviewing files in `lib/l10n/`:
```
Focus on:
- Consistency across all 7 supported languages
- Proper context and pluralization handling
- Cultural appropriateness of educational content
- Missing translations or placeholder text
- ARB key naming conventions and organization
```

### Test Review Prompts

When reviewing files in `test/`:
```
Focus on:
- Coverage of critical physics calculations
- Edge cases in orbital mechanics
- Performance testing for rendering components  
- Accessibility testing for UI components
- Proper test organization and naming
- Mock usage for external dependencies
```

## Contextual Review Instructions

### For Pull Requests with "physics" label:
```
This PR involves physics calculations. Pay special attention to:
1. Mathematical accuracy of formulas
2. Numerical stability and precision
3. Unit conversions and scaling
4. Performance impact of calculations
5. Test coverage for edge cases
6. Documentation of complex algorithms
```

### For Pull Requests with "ui" label:
```
This PR involves user interface changes. Pay special attention to:
1. Material Design compliance
2. Accessibility features
3. Localization completeness
4. Responsive design
5. State management patterns
6. Loading and error states
```

### For Pull Requests with "performance" label:
```
This PR involves performance optimizations. Pay special attention to:
1. Frame rate impact (target: 60fps)
2. Memory usage and potential leaks
3. Efficient rendering techniques
4. Algorithmic complexity improvements
5. Profiling and benchmarking needs
6. Trade-offs between performance and readability
```

### For Pull Requests with "localization" label:
```
This PR involves internationalization. Pay special attention to:
1. Completeness across all 7 languages
2. Proper ARB file structure
3. Context-appropriate translations
4. Cultural sensitivity
5. Pluralization handling
6. Text overflow and layout considerations
```

## Review Quality Standards

### Code Complexity Thresholds
- Methods > 50 lines: Suggest decomposition
- Classes > 500 lines: Suggest refactoring
- Cyclomatic complexity > 10: Flag for simplification
- Nesting depth > 4: Suggest early returns or extraction

### Performance Standards
- Render loop operations: Must be O(1) or O(n) where n is small
- Physics calculations: Document time complexity
- Memory allocations: Minimize in hot paths
- File I/O: Always async, proper error handling

### Documentation Requirements
- Public APIs: Comprehensive doc comments
- Physics formulas: Mathematical notation and references
- Complex algorithms: Step-by-step explanation
- Configuration options: Clear usage examples

## Language-Specific Guidelines

### Dart/Flutter Best Practices
- Prefer const constructors where possible
- Use named parameters for readability
- Implement proper dispose methods
- Follow effective dart style guide
- Use null safety consistently

### Physics Simulation Specifics
- All physics constants in `SimulationConstants`
- Immutable data structures where possible
- Clear separation between model and view
- Deterministic behavior for testing
- Proper error propagation

## Review Automation Rules

### Auto-approve conditions:
- Only formatting changes (dart format)
- Documentation-only updates
- Translation updates with no code changes
- Version bumps in pubspec.yaml

### Require human review:
- Changes to physics calculation logic
- New UI components or significant changes
- Performance-critical modifications
- Security-related updates
- Breaking API changes

### Flag for expert review:
- Orbital mechanics algorithms
- 3D rendering optimizations
- State management architecture changes
- Accessibility implementation
- Internationalization infrastructure