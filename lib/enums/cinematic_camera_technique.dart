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
  dynamicFraming('dynamic_framing'),

  /// Camera follows physics principles for natural movement
  /// - Camera "orbits" the target with simulated physics
  /// - Smooth banking into turns following curved trajectories
  /// - Natural shake/vibration during high-energy events
  physicsAware('physics_aware'),

  /// AI chooses camera angles based on current simulation state
  /// - Switches between wide shots and close-ups intelligently
  /// - Creates "establishing shots" for new scenarios
  /// - Educational vs dramatic vs overview mode switching
  contextualShots('contextual_shots'),

  /// Emotional pacing control based on simulation "tension"
  /// - Analyzes proximity, velocities, and chaos level
  /// - Adjusts camera movement speed accordingly
  /// - Creates buildup to dramatic moments
  emotionalPacing('emotional_pacing');

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
      case CinematicCameraTechnique.physicsAware:
        return 'Physics-Aware';
      case CinematicCameraTechnique.contextualShots:
        return 'Contextual Shots';
      case CinematicCameraTechnique.emotionalPacing:
        return 'Emotional Pacing';
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
      case CinematicCameraTechnique.physicsAware:
        return 'Camera follows physics principles for natural movement';
      case CinematicCameraTechnique.contextualShots:
        return 'AI selects optimal angles based on simulation state';
      case CinematicCameraTechnique.emotionalPacing:
        return 'Adjusts camera speed based on simulation tension';
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
