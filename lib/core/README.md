# Core Module

This directory contains shared functionality used across all features of the Graviton application.

## Structure

```
core/
├── constants/     # Application-wide constants (physics, UI, platform)
├── theme/         # Theme definitions (colors, typography, constraints)
├── utils/         # Utility functions and helpers
├── config/        # Configuration and environment setup
└── enums/         # Shared enumerations
```

## Purpose

The `core` module provides:
- **Constants**: Physics constants, UI constants, rendering parameters
- **Theme**: AppColors, AppTypography, AppConstraints
- **Utils**: Helper functions for common operations (math, color, physics)
- **Config**: Flavor configuration, environment setup
- **Enums**: Shared enums used across multiple features

## Guidelines

- Code in `core` should have **no dependencies** on feature modules
- All utilities should be **stateless** and **pure functions** where possible
- Constants should follow the project's naming conventions
- Keep `core` lean - only include truly shared code

## Migration Status

🚧 **Phase 1**: Directory structure created alongside existing code
- Existing code remains in original locations
- New structure being prepared for gradual migration
- Both structures will coexist during transition

## Related Documentation

- See `.github/copilot-instructions.md` for code quality standards
- See `CONTRIBUTING.md` for contribution guidelines
