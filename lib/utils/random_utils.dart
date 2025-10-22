import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Random generation utilities for physics simulation
class RandomUtils {
  RandomUtils._(); // Private constructor to prevent instantiation

  /// Generate random double within range [min, max]
  static double randomRange(double min, double max, [math.Random? random]) {
    final rand = random ?? math.Random();
    return min + rand.nextDouble() * (max - min);
  }

  /// Generate random integer within range [min, max] (inclusive)
  static int randomInt(int min, int max, [math.Random? random]) {
    final rand = random ?? math.Random();
    return min + rand.nextInt(max - min + 1);
  }

  /// Generate random angle in radians [0, 2π]
  static double randomAngle([math.Random? random]) {
    final rand = random ?? math.Random();
    return rand.nextDouble() * 2 * math.pi;
  }

  /// Generate random angle with offset and randomness
  static double randomAngleWithOffset(
    double baseAngle,
    double randomness, [
    math.Random? random,
  ]) {
    final rand = random ?? math.Random();
    return baseAngle + (rand.nextDouble() - 0.5) * randomness;
  }

  /// Generate random mass within specified range
  static double randomMass(double min, double max, [math.Random? random]) {
    return randomRange(min, max, random);
  }

  /// Generate random radius within specified range
  static double randomRadius(double min, double max, [math.Random? random]) {
    return randomRange(min, max, random);
  }

  /// Generate random distance within orbital constraints
  static double randomDistance(double min, double max, [math.Random? random]) {
    return randomRange(min, max, random);
  }

  /// Generate random height with symmetric distribution around zero
  static double randomHeight(double range, [math.Random? random]) {
    final rand = random ?? math.Random();
    return (rand.nextDouble() - 0.5) * range;
  }

  /// Generate random velocity magnitude within range
  static double randomVelocityMagnitude(
    double min,
    double max, [
    math.Random? random,
  ]) {
    return randomRange(min, max, random);
  }

  /// Generate random Z-velocity with direction
  static double randomZVelocity(double min, double max, [math.Random? random]) {
    final rand = random ?? math.Random();
    final magnitude = randomRange(min, max, rand);
    final direction = rand.nextBool() ? 1 : -1;
    return magnitude * direction;
  }

  /// Generate random velocity component with randomness factor
  static double randomVelocityComponent(
    double baseValue,
    double randomness, [
    math.Random? random,
  ]) {
    final rand = random ?? math.Random();
    return baseValue + (rand.nextDouble() - 0.5) * randomness;
  }

  /// Generate random 3D position within spherical constraints
  static vm.Vector3 randomPositionInSphere(
    double minRadius,
    double maxRadius,
    double heightRange, [
    math.Random? random,
  ]) {
    final rand = random ?? math.Random();

    final angle = randomAngle(rand);
    final distance = randomDistance(minRadius, maxRadius, rand);
    final height = randomHeight(heightRange, rand);

    return vm.Vector3(
      distance * math.cos(angle),
      distance * math.sin(angle),
      height,
    );
  }

  /// Generate random stellar color based on temperature/type
  static Color randomStellarColor([math.Random? random]) {
    final rand = random ?? math.Random();
    final colorIndex = rand.nextInt(6);

    // Based on stellar classification (O, B, A, F, G, K, M)
    switch (colorIndex) {
      case 0:
        return AppColors.randomStarBlue; // Blue (hot stars)
      case 1:
        return AppColors.randomStarWhite; // White
      case 2:
        return AppColors.randomStarCream; // Cream
      case 3:
        return AppColors.randomStarYellow; // Yellow (Sun-like)
      case 4:
        return AppColors.randomStarOrange; // Orange
      case 5:
        return AppColors.randomStarRed; // Red (cool stars)
      default:
        return AppColors.randomStarYellow;
    }
  }

  /// Generate random planetary color
  static Color randomPlanetaryColor([math.Random? random]) {
    final rand = random ?? math.Random();
    final colorIndex = rand.nextInt(8);

    switch (colorIndex) {
      case 0:
        return AppColors.randomPlanetBlue; // Royal Blue (Earth-like)
      case 1:
        return AppColors.randomPlanetCrimson; // Crimson (Mars-like)
      case 2:
        return AppColors.randomPlanetCornsilk; // Cornsilk (Venus-like)
      case 3:
        return AppColors.randomPlanetGoldenrod; // Goldenrod (Gas giant)
      case 4:
        return AppColors.randomPlanetSkyBlue; // Sky Blue (Ice giant)
      case 5:
        return AppColors.randomPlanetBrown; // Saddle Brown (Rocky)
      case 6:
        return AppColors.randomPlanetSilver; // Silver (Metal-rich)
      case 7:
        return AppColors.randomPlanetPurple; // Medium Purple (Exotic)
      default:
        return AppColors.randomPlanetBlue;
    }
  }

  /// Generate random asteroid color (greyish tones)
  static Color randomAsteroidColor([math.Random? random]) {
    final rand = random ?? math.Random();
    final grayLevel = randomRange(0.3, 0.7, rand);
    final tint = randomRange(0.0, 0.2, rand);

    // Add slight color tint to gray
    final r = (grayLevel + tint).clamp(0.0, 1.0);
    final g = (grayLevel + tint * 0.5).clamp(0.0, 1.0);
    final b = (grayLevel).clamp(0.0, 1.0);

    return Color.fromRGBO(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      1.0,
    );
  }

  /// Generate weighted random choice from list of options
  static T weightedChoice<T>(
    List<T> options,
    List<double> weights, [
    math.Random? random,
  ]) {
    if (options.isEmpty) throw ArgumentError('Options list cannot be empty');
    if (options.length != weights.length) {
      throw ArgumentError('Options and weights lists must have same length');
    }

    final rand = random ?? math.Random();
    final totalWeight = weights.fold<double>(
      0.0,
      (sum, weight) => sum + weight,
    );

    if (totalWeight <= 0) throw ArgumentError('Total weight must be positive');

    final randomValue = rand.nextDouble() * totalWeight;
    double cumulativeWeight = 0.0;

    for (int i = 0; i < options.length; i++) {
      cumulativeWeight += weights[i];
      if (randomValue <= cumulativeWeight) {
        return options[i];
      }
    }

    // Fallback (should not reach here with valid inputs)
    return options.last;
  }

  /// Generate random boolean with specified probability
  static bool randomBool(double probability, [math.Random? random]) {
    final rand = random ?? math.Random();
    return rand.nextDouble() < probability.clamp(0.0, 1.0);
  }

  /// Generate random value from Gaussian/normal distribution
  static double randomGaussian(
    double mean,
    double standardDeviation, [
    math.Random? random,
  ]) {
    final rand = random ?? math.Random();

    // Box-Muller transform
    double u1, u2, w;

    do {
      u1 = 2.0 * rand.nextDouble() - 1.0;
      u2 = 2.0 * rand.nextDouble() - 1.0;
      w = u1 * u1 + u2 * u2;
    } while (w >= 1.0);

    w = math.sqrt(-2.0 * math.log(w) / w);
    return (u1 * w) * standardDeviation + mean;
  }

  /// Generate random exponential distribution value
  static double randomExponential(double lambda, [math.Random? random]) {
    final rand = random ?? math.Random();
    return -math.log(1.0 - rand.nextDouble()) / lambda;
  }

  /// Generate random power law distribution value
  static double randomPowerLaw(
    double min,
    double max,
    double exponent, [
    math.Random? random,
  ]) {
    final rand = random ?? math.Random();

    if (exponent == -1.0) {
      return (min * math.pow(max / min, rand.nextDouble())).toDouble();
    } else {
      final exp1 = exponent + 1.0;
      final numerator = math.pow(max, exp1) - math.pow(min, exp1);
      return math
          .pow(math.pow(min, exp1) + rand.nextDouble() * numerator, 1.0 / exp1)
          .toDouble();
    }
  }

  /// Shuffle a list using Fisher-Yates algorithm
  static List<T> shuffle<T>(List<T> list, [math.Random? random]) {
    final rand = random ?? math.Random();
    final shuffled = List<T>.from(list);

    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = rand.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    return shuffled;
  }

  /// Generate random name from predefined lists
  static String randomCelestialName([math.Random? random]) {
    final rand = random ?? math.Random();

    final starNames = [
      'Alpheratz',
      'Mirach',
      'Almach',
      'Algol',
      'Aldebaran',
      'Rigel',
      'Capella',
      'Betelgeuse',
      'Sirius',
      'Procyon',
      'Pollux',
      'Regulus',
      'Spica',
      'Arcturus',
      'Vega',
      'Altair',
      'Deneb',
      'Fomalhaut',
      'Antares',
      'Canopus',
    ];

    final planetNames = [
      'Kepler',
      'Gliese',
      'Proxima',
      'Trappist',
      'Wolf',
      'Ross',
      'Lacaille',
      'Groombridge',
      'Lalande',
      'Piazzi',
      'HD',
      'TYC',
      'GSC',
      'HIP',
      'SAO',
    ];

    final suffixes = ['b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'];

    if (rand.nextBool()) {
      final starName = starNames[rand.nextInt(starNames.length)];
      final number = rand.nextInt(999) + 1;
      return '$starName-$number';
    } else {
      final planetName = planetNames[rand.nextInt(planetNames.length)];
      final number = rand.nextInt(9999) + 1;
      final suffix = suffixes[rand.nextInt(suffixes.length)];
      return '$planetName $number$suffix';
    }
  }
}
