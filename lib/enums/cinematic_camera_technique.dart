/// Available AI-driven cinematic camera techniques for following celestial bodies
enum CinematicCameraTechnique {
  /// Standard manual camera control (default behavior)
  manual('manual'),

  /// AI predicts orbital paths and pre-plans dramatic camera movements
  /// - Pre-positions camera for dramatic close encounters between bodies
  /// - Anticipates orbital decay and positions for impact shots
  /// - Creates smooth "chase cam" following elliptical orbits
  predictiveOrbital('predictive_orbital'),

  /// Automatically adjusts FOV and distance based on scene content
  /// - Rule of thirds positioning for primary bodies
  /// - Leading space for moving objects in direction of travel
  /// - Scale awareness (zoom out for multi-body, zoom in for detail)
  dynamicFraming('dynamic_framing');

  const CinematicCameraTechnique(this.value);

  /// The string value used for storage and analytics
  final String value;

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case CinematicCameraTechnique.manual:
        return 'Manual Control';
      case CinematicCameraTechnique.predictiveOrbital:
        return 'Predictive Orbital';
      case CinematicCameraTechnique.dynamicFraming:
        return 'Dynamic Framing';
    }
  }

  /// Get description for UI
  String get description {
    switch (this) {
      case CinematicCameraTechnique.manual:
        return 'Traditional manual camera controls with follow mode';
      case CinematicCameraTechnique.predictiveOrbital:
        return 'AI predicts orbital paths for dramatic camera movements';
      case CinematicCameraTechnique.dynamicFraming:
        return 'Automatically adjusts framing based on scene content';
    }
  }

  /// Check if this technique requires AI processing
  bool get requiresAI {
    return this != CinematicCameraTechnique.manual;
  }

  /// Parse from string value
  static CinematicCameraTechnique fromValue(String value) {
    return CinematicCameraTechnique.values.firstWhere(
      (technique) => technique.value == value,
      orElse: () => CinematicCameraTechnique.manual,
    );
  }
}
