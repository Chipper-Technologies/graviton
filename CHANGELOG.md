# Changelog

All notable changes to the Graviton project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-10-25

### Added
- **Interactive Tutorial Overlay**: Swipe navigation and colored step indicators with visual guidance for new users
- **Standardized Dialog System**: Consistent constraints, padding, and visual styling across all app dialogs
- **Real-time Temperature Physics**: Planetary temperature calculation based on stellar radiation using blackbody physics
- **Enhanced Floating Controls**: Labeled buttons in video-style simulation controls for improved usability
- **Menu Icon Integration**: Tutorial now displays actual three-dot menu icons instead of text symbols

### Improved
- **Collision Physics**: Reduced collision sensitivity for more realistic planetary interactions and merging behavior
- **Tutorial Accuracy**: Updated all tutorial descriptions to reflect current app control layout and navigation
- **Multi-language Support**: Enhanced localization with split text support for inline icon display across all 7 languages
- **User Experience**: More intuitive interface with proper visual cues and standardized interaction patterns

### Technical Improvements
- **ARB Localization**: Updated all language files with split text keys for enhanced tutorial icon integration
- **Tutorial System**: Sophisticated text rendering with inline icon display capabilities
- **Code Organization**: Improved dialog structure and consistent component patterns throughout the app
- **Temperature Integration**: Throttled temperature updates with mass-weighted averaging during collisions
- **Internationalization**: Complete tutorial translations with proper icon placement for 7 languages

## [1.0.0] - 2025-10-21

### Added
- Initial release of Graviton physics simulation app
- Advanced gravitational physics simulation engine
- Real-time 3D visualization with orbital mechanics
- Multiple celestial body scenarios (binary stars, solar system, galaxy formation)
- Interactive camera controls with auto-zoom and rotation
- Multi-language support (7 languages)
- Customizable simulation parameters (time scale, physics accuracy)
- Visual trails and orbital path display
- Statistics overlay with real-time physics data
- Firebase analytics and crash reporting
- Cross-platform support (iOS, Android, Web)
- Comprehensive test suite with 500+ tests
- Screenshot mode for documentation
- Responsive UI with material design
- Accessibility features and internationalization

### Technical Features
- Provider-based state management
- Modular architecture with clean separation of concerns
- Custom physics engine with numerical integration
- 3D coordinate transformations and camera projections
- Performance optimizations for smooth 60fps animation
- Comprehensive error handling and logging
- CI/CD pipeline with automated testing
- Multi-flavor build configuration (dev/prod)
