import 'dart:math' as math;

import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Enhanced star data with visual properties
class StarData {
  final vm.Vector3 position;
  final double size;
  final double brightness;
  final int color;

  const StarData(this.position, this.size, this.brightness, this.color);
}

/// Utility class for generating background stars
class StarGenerator {
  /// Generates a spherical distribution of stars for the background with enhanced visual properties
  static List<StarData> generateStars(int count, {double radius = RenderingConstants.starDefaultRadius}) {
    final rnd = math.Random(); // Remove fixed seed for randomness
    final stars = <StarData>[];

    // Star color palette (realistic stellar colors from app theme)
    final starColors = [
      AppColors.randomStarWhite.toARGB32(), // White (most common)
      AppColors.randomStarWhite.toARGB32(), // White
      AppColors.randomStarCream.toARGB32(), // Cream white
      AppColors.randomStarYellow.toARGB32(), // Light yellow
      AppColors.randomStarYellow.toARGB32(), // Yellow
      AppColors.randomStarOrange.toARGB32(), // Orange
      AppColors.randomStarOrange.toARGB32(), // Orange
      AppColors.randomStarBlue.toARGB32(), // Light blue
      AppColors.nebulaSkyBlue.toARGB32(), // Sky blue
      AppColors.nebulaRoyalBlue.toARGB32(), // Royal blue
    ];

    for (int i = 0; i < count; i++) {
      // Generate spherical position
      final u = rnd.nextDouble() * 2 - 1;
      final t = rnd.nextDouble() * 2 * math.pi;
      final s = math.sqrt(1 - u * u);
      final x = s * math.cos(t);
      final y = u;
      final z = s * math.sin(t);
      final position = vm.Vector3(x, y, z) * radius;

      // Vary star properties for realism
      final size = RenderingConstants.starSize * (0.3 + rnd.nextDouble() * 1.7); // 0.3x to 2x base size
      final brightness = 0.3 + rnd.nextDouble() * 0.7; // 30% to 100% brightness
      final color = starColors[rnd.nextInt(starColors.length)];

      stars.add(StarData(position, size, brightness, color));
    }

    return stars;
  }

  /// Generates a spherical distribution of simple stars (backward compatibility)
  static List<vm.Vector3> generateSimpleStars(int count, {double radius = RenderingConstants.starDefaultRadius}) {
    final rnd = math.Random();
    final stars = <vm.Vector3>[];

    for (int i = 0; i < count; i++) {
      final u = rnd.nextDouble() * 2 - 1;
      final t = rnd.nextDouble() * 2 * math.pi;
      final s = math.sqrt(1 - u * u);
      final x = s * math.cos(t);
      final y = u;
      final z = s * math.sin(t);
      stars.add(vm.Vector3(x, y, z) * radius);
    }

    return stars;
  }
}
