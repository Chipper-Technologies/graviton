# Contributing to Graviton

Thank you for your interest in contributing to Graviton! This document provides guidelines for contributing to this physics simulation project.

## Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow. Please be respectful and professional in all interactions.

## How to Contribute

### Reporting Issues
- Use the GitHub issue tracker
- Provide detailed information about the bug or feature request
- Include steps to reproduce for bugs
- Check if the issue already exists before creating a new one

### Development Setup

1. **Prerequisites**
   - Flutter SDK (latest stable version)
   - Dart SDK (comes with Flutter)
   - Android Studio or VS Code
   - Git

2. **Clone and Setup**
   ```bash
   git clone https://github.com/Chipper-Technologies/graviton.git
   cd graviton
   flutter pub get
   ```

3. **Development Environment**
   ```bash
   # Run in development mode
   flutter run --dart-define-from-file config/dev.json --flavor dev
   
   # Run tests
   flutter test
   
   # Code analysis
   flutter analyze
   ```

### Code Style

- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex physics calculations
- Maintain consistent formatting with `dart format`
- Run `flutter analyze` before submitting

### Pull Request Process

1. **Fork the repository** and create a feature branch
2. **Make your changes** following the coding standards
3. **Write tests** for new functionality
4. **Ensure all tests pass** (`flutter test`)
5. **Update documentation** if needed
6. **Submit a pull request** with a clear description

### Commit Message Format

Use clear, descriptive commit messages:
```
feat: add new planetary scenario
fix: resolve orbital calculation precision issue
docs: update README with installation instructions
test: add tests for collision detection
```

## Development Areas

### Physics & Simulation
- Orbital mechanics improvements
- New celestial body scenarios
- Performance optimizations
- Numerical integration enhancements

### User Interface
- Accessibility improvements
- New visualization features
- Mobile-specific optimizations
- Internationalization (i18n)

### Testing
- Unit tests for physics calculations
- Widget tests for UI components
- Integration tests for complete workflows
- Performance testing

### Documentation
- Code documentation
- User guides
- Educational content
- API documentation

## Project Structure

```
lib/
├── models/          # Data models (Body, Vector3D, etc.)
├── services/        # Business logic services
├── state/           # State management (Provider)
├── screens/         # UI screens
├── widgets/         # Reusable widgets
├── painters/        # Custom painters for visualization
├── utils/           # Utility functions
├── constants/       # App constants
└── config/          # Configuration files

test/
├── models/          # Model tests
├── services/        # Service tests
├── state/           # State management tests
├── widgets/         # Widget tests
└── integration/     # Integration tests
```

## Testing Guidelines

- Write tests for all new features
- Maintain at least 80% code coverage
- Test edge cases and error conditions
- Use descriptive test names
- Group related tests logically

## Physics Accuracy

When contributing physics-related code:
- Use scientifically accurate formulas
- Include references to sources
- Consider numerical precision
- Test against known solutions
- Document assumptions and limitations

## Performance Considerations

- Profile code changes for performance impact
- Optimize for mobile devices
- Consider memory usage
- Test on various device specifications
- Maintain smooth animation (60fps target)

## Questions?

If you have questions about contributing:
- Open a GitHub issue with the "question" label
- Check existing issues and discussions
- Review the codebase for examples

## License

By contributing to Graviton, you agree that your contributions will be licensed under the MIT License.

Thank you for helping make Graviton better! 🚀