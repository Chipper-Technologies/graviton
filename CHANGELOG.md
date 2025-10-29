# Changelog

All notable changes to the Graviton project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2025-10-28

### Added
- **Realistic Colors Feature**: Scientifically accurate color rendering based on stellar physics and Harvard spectral classification
  - **Stellar Classification System**: Temperature-based colors for stars using O, B, A, F, G, K, M spectral types
  - **UI Settings Toggle**: New option to enable/disable realistic colors with seamless switching between modes
  - **StellarColorService**: Dedicated service for calculating temperature-based colors and stellar physics
  - **Galaxy Formation Enhancement**: Proximity-based stellar heating system for realistic temperature dynamics
  - **Visual Effects Integration**: Sunspots, solar flares, and trails adapted to work with realistic stellar colors
  - **Internationalization Support**: Complete localization across all 7 supported languages for the new feature
- **AI-Driven Cinematic Camera Controller**: Revolutionary camera system with intelligent scene targeting and dramatic positioning
  - **Manual Control**: Traditional manual camera controls with enhanced follow mode capabilities
  - **Predictive Orbital**: AI-powered educational tours with orbital path predictions and automatic camera positioning for optimal viewing angles
  - **Dynamic Framing**: Real-time dramatic targeting system that automatically identifies and focuses on the most visually interesting events (close encounters, collisions, chaotic motion)
- **Orbital Prediction Engine**: Advanced physics simulation for anticipating dramatic celestial events
  - Collision detection and early warning system for imminent impacts
  - Close encounter prediction with automatic camera pre-positioning
  - Orbital decay analysis for educational demonstrations
- **Dramatic Scoring Algorithm**: Sophisticated AI system for rating scene interest levels
  - Multi-factor scoring considering proximity, velocity, mass, and approaching trajectories
  - Real-time evaluation of celestial interactions for optimal camera targeting
  - Configurable scoring parameters with comprehensive documentation for future tuning
- **Enhanced Rendering Constants**: Organized and documented constants for visual effects
  - Detailed parameter documentation with expected ranges and usage guidelines
  - Sunspot generation constants for realistic solar surface features
  - Body matching tolerance system for stable object identification across frames

### Improved
- **Camera Performance**: Optimized camera update cycles with 16ms target execution time for smooth 60fps operation
- **Test Coverage**: Comprehensive test suite with 64+ passing tests covering all camera techniques and edge cases
- **Code Documentation**: Enhanced constants documentation with scoring scales, units, and tuning guidance
- **Internationalization**: Fixed language display issues across all 7 supported languages
  - Corrected English language names appearing in non-English translations
  - Added complete translations for all cinematic camera technique labels and descriptions

### Technical Improvements
- **Constants Organization**: Extracted magic numbers to named constants in SimulationConstants for better maintainability
  - Temperature conversion constants with proper physics documentation
  - Stellar temperature thresholds for accurate physics validation
- **Camera State Management**: Robust state synchronization between simulation, camera, and UI systems
- **Mathematical Precision**: Validated coordinate transformations and camera calculations through comprehensive testing
- **Edge Case Handling**: Enhanced stability for empty scenarios, single bodies, and boundary conditions
- **Performance Benchmarking**: Automated performance validation ensuring camera updates complete within frame budget
- **API Compatibility**: Fixed compilation errors and ensured proper integration with existing simulation framework

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
