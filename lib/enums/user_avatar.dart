/// Predefined cosmic-themed avatar options for user profiles
///
/// Each avatar represents a celestial body or astronomical object,
/// providing users with thematic profile pictures that match the
/// app's gravitational physics and space exploration theme.
enum UserAvatar {
  /// Sun - yellow star, central body of our solar system
  sun('sun', '☀️'),

  /// Mercury - small rocky planet
  mercury('mercury', '☿️'),

  /// Venus - bright morning/evening star
  venus('venus', '♀'),

  /// Earth - our home planet
  earth('earth', '🌍'),

  /// Mars - the red planet
  mars('mars', '♂'),

  /// Jupiter - massive gas giant
  jupiter('jupiter', '♃'),

  /// Saturn - ringed gas giant
  saturn('saturn', '♄'),

  /// Uranus - ice giant
  uranus('uranus', '♅'),

  /// Neptune - distant ice giant
  neptune('neptune', '♆'),

  /// Moon - Earth's natural satellite
  moon('moon', '🌙'),

  /// Star - generic star
  star('star', '⭐'),

  /// Comet - icy celestial traveler
  comet('comet', '☄️'),

  /// Galaxy - spiral galaxy
  galaxy('galaxy', '🌌'),

  /// Black hole - gravitational singularity
  blackHole('black_hole', '⚫'),

  /// Neutron star - dense stellar remnant
  neutronStar('neutron_star', '✨'),

  /// Asteroid - rocky minor planet
  asteroid('asteroid', '☄️'),

  /// Nebula - cosmic cloud
  nebula('nebula', '🌠'),

  /// Supernova - stellar explosion
  supernova('supernova', '💥');

  const UserAvatar(this.id, this.emoji);

  /// Unique identifier for the avatar
  final String id;

  /// Emoji representation of the avatar
  final String emoji;

  /// Get an avatar by its ID
  static UserAvatar? fromId(String id) {
    try {
      return UserAvatar.values.firstWhere((avatar) => avatar.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get a random avatar
  static UserAvatar random() {
    final index = DateTime.now().millisecondsSinceEpoch % values.length;
    return values[index];
  }
}
