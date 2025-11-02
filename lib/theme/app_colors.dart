import 'dart:ui';

import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/celestial_body_name.dart';

/// Comprehensive color theme for the Graviton app.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // =============================================================================
  // SPACE & COSMIC COLORS
  // =============================================================================

  /// Deep space background colors
  static const Color spaceDeepBlueBlack = Color(0xFF0a0a1a);
  static const Color spacePurple = Color(0xFF2a1a3f);
  static const Color spaceDeepPurple = Color(0xFF3d1a5c);
  static const Color spacePureBlack = Color(0xFF000000);

  /// Enhanced vibrant purple variants for more prominence
  static const Color spaceVibrantPurple = Color(0xFF5a2d7a);
  static const Color spaceMysticPurple = Color(0xFF7b3f9b);
  static const Color spaceRoyalPurple = Color(0xFF663399);

  /// Galaxy glow colors - bluish/purple cosmic theme
  static const Color galaxySlateBlue = Color(0xFF6A5ACD);
  static const Color galaxyDarkSlateBlue = Color(0xFF483D8B);
  static const Color galaxyRoyalBlue = Color(0xFF4169E1);
  static const Color galaxyPureBlue = Color(0xFF0000FF);
  static const Color galaxyIndigo = Color(0xFF4B0082);

  /// Galactic center/accretion disk colors - warm glow
  static const Color accretionMoccasin = Color(0xFFFFE4B5);
  static const Color accretionPlum = Color(0xFFDDA0DD);
  static const Color accretionMediumPurple = Color(0xFF9370DB);
  static const Color accretionGold = Color(0xFFFFD700);
  static const Color accretionOrange = Color(0xFFFFA500);
  static const Color accretionDarkOrange = Color(0xFFFF8C00);
  static const Color accretionWhite = Color(0xFFFFFFFF);
  static const Color accretionOrangeRed = Color(0xFFFF4500);
  static const Color accretionTomato = Color(0xFFFF6347);
  static const Color accretionRed = Color(0xFFFF0000);

  /// Star colors for background nebula effects
  static const Color starMediumSlateBlue = Color(0xFF9370DB);
  static const Color starPlum = Color(0xFFDDA0DD);
  static const Color starBlueViolet = Color(0xFF8A2BE2);
  static const Color starSlateBlue = Color(0xFF6A5ACD);
  static const Color starMediumSlateBlue2 = Color(0xFF7B68EE);
  static const Color starDarkOrchid = Color(0xFF9932CC);
  static const Color starDarkMagenta = Color(0xFF8B008B);
  static const Color starRoyalBlue = Color(0xFF4169E1);
  static const Color starCornflowerBlue = Color(0xFF6495ED);
  static const Color starSkyBlue = Color(0xFF87CEEB);

  /// Stellar classification colors (Harvard spectral classification)
  /// Based on main sequence stellar temperatures and realistic blackbody colors
  static const Color stellarOType = Color(0xFF9BB0FF); // > 30,000K (blue)
  static const Color stellarBType = Color(
    0xFFAABFFF,
  ); // 10,000-30,000K (blue-white)
  static const Color stellarAType = Color(0xFFCAD7FF); // 7,500-10,000K (white)
  static const Color stellarFType = Color(
    0xFFF8F7FF,
  ); // 6,000-7,500K (yellow-white)
  static const Color stellarGType = Color(
    0xFFFFE4B5,
  ); // 5,200-6,000K (yellow, Sun-like)
  static const Color stellarKType = Color(0xFFFFD2A1); // 3,700-5,200K (orange)
  static const Color stellarMType = Color(0xFFFFAD51); // < 3,700K (red dwarf)

  // =============================================================================
  // CELESTIAL BODY COLORS
  // =============================================================================

  /// Solar system planet colors
  static const Color planetMercury = Color(0xFF8C7853);
  static const Color planetVenus = Color(0xFFFFC649);
  static const Color planetEarth = Color(0xFF6B93D6);
  static const Color planetMars = Color(0xFFCD5C5C);
  static const Color planetJupiter = Color(0xFFD8CA9D);
  static const Color planetSaturn = Color(0xFFFFE4B5);
  static const Color planetUranus = Color(0xFF4CC9F0);
  static const Color planetNeptune = Color(0xFF4169E1);

  /// Planetary type colors based on composition and temperature
  /// Gas giants
  static const Color gasGiantJupiterLike = Color(
    0xFFFAD5A5,
  ); // Tan/beige (very massive)
  static const Color gasGiantSaturnLike = Color(0xFFFFC649); // Golden (massive)
  static const Color iceGiantUranusLike = Color(0xFF4FD0E4); // Ice blue (cold)
  static const Color iceGiantNeptuneLike = Color(0xFF4B70DD); // Deep blue

  /// Terrestrial planets
  static const Color terrestrialHotVenus = Color(
    0xFFFFC649,
  ); // Hot, thick atmosphere
  static const Color terrestrialEarthLike = Color(
    0xFF6B93D6,
  ); // Temperate, water
  static const Color terrestrialColdMars = Color(0xFFE27D00); // Cold, red
  static const Color terrestrialRockyMercury = Color(
    0xFF8C7853,
  ); // Rocky, no atmosphere

  /// Super-Earths and mini-Neptunes
  static const Color superEarthHot = Color(0xFFFF6B6B); // Hot super-Earth
  static const Color superEarthTemperate = Color(
    0xFF4ECDC4,
  ); // Temperate super-Earth
  static const Color superEarthCold = Color(0xFF95A5A6); // Cold super-Earth

  /// Moon colors
  static const Color moonIcy = Color(0xFFD5DBDB); // Icy moon (very cold)
  static const Color moonRocky = Color(0xFFBDC3C7); // Rocky moon (cold)
  static const Color moonWarm = Color(0xFF95A5A6); // Warm moon

  /// General celestial body colors for scenarios
  static const Color celestialAmber = Color(0xFFFFD166);
  static const Color celestialTeal = Color(0xFF06D6A0);
  static const Color celestialBlue = Color(0xFF118AB2);
  static const Color celestialRed = Color(0xFFE63946);
  static const Color celestialPink = Color(0xFFF72585);
  static const Color celestialLightBlue = Color(0xFF4CC9F0);
  static const Color celestialGold = Color(0xFFFFD700);
  static const Color celestialSilver = Color(0xFFC0C0C0);
  static const Color celestialOrange = Color(0xFFFFB020); // Solar system orange
  static const Color celestialRedPlanet = Color(0xFFFF6B6B);
  static const Color celestialTealPlanet = Color(0xFF4ECDC4);
  static const Color celestialBluePlanet = Color(0xFF45B7D1);
  static const Color celestialPlumPlanet = Color(0xFFDDA0DD);
  static const Color celestialBluePlanet2 = Color(0xFF4A90E2);
  static const Color celestialRedPlanet2 = Color(0xFFE74C3C);
  static const Color celestialBlackHole = Color(0xFF000000);

  /// Asteroid and small body colors
  static const Color asteroidBrownish = Color(0xFF8B6B3F);
  static const Color kuiperBeltIcy = Color(
    0xFFB8E6FF,
  ); // Icy blue-white for Kuiper objects

  /// Binary star system colors
  static const Color binaryStarBrown = Color(0xFF8B5A3C); // Central brown star
  static const Color binaryStarWhite = Color(
    0xFFE8E8E8,
  ); // White companion star
  static const Color binaryStarBlue = Color(0xFF87CEEB); // Blue companion star

  // =============================================================================
  // HABITABILITY & STATUS COLORS
  // =============================================================================

  /// Colors for habitability zones and status indicators
  static const Color habitabilityHabitable = Color(0xFF4CAF50); // Green
  static const Color habitabilityTooHot = Color(0xFFF44336); // Red
  static const Color habitabilityTooCold = Color(0xFF2196F3); // Blue
  static const Color habitabilityUnknown = Color(0xFF9E9E9E); // Grey
  static const Color habitabilityDangerZone = Color(
    0xFFFF5722,
  ); // Deep orange/red

  /// Temperature visualization colors - from cold to hot
  static const Color temperatureFrozen = Color(
    0xFF1E90FF,
  ); // Deep blue (frozen)
  static const Color temperatureCold = Color(0xFF87CEEB); // Sky blue (cold)
  static const Color temperatureCool = Color(0xFF90EE90); // Light green (cool)
  static const Color temperatureWarm = Color(0xFFFFFF00); // Yellow (warm)
  static const Color temperatureHot = Color(0xFFFFA500); // Orange (hot)
  static const Color temperatureVeryHot = Color(
    0xFFFF4500,
  ); // Red-orange (very hot)
  static const Color temperatureScorching = Color(
    0xFF8B0000,
  ); // Dark red (scorching)

  // =============================================================================
  // UI & INTERFACE COLORS
  // =============================================================================

  /// Development and debug UI colors
  static const Color devRibbonRed = Color(0xFFFF0000);
  static const Color devRibbonWhite = Color(0xFFFFFFFF);

  /// General UI element colors
  static const Color uiDividerGrey = Color(0xFF424242); // Colors.grey[800]
  static const Color uiBorderGrey = Color(0xFF616161); // Colors.grey[700]
  static const Color uiDarkBlueOrbit = Color(
    0xFF1565C0,
  ); // Colors.blue.shade800
  static const Color uiTextGrey = Color(0xFF9E9E9E); // Colors.grey[500]
  static const Color uiWhiteBorder = Color(
    0xFFFFFFFF,
  ); // White for borders with transparency
  static const Color uiBlackOverlay = Color(0x8A000000); // Colors.black54
  static const Color uiWhite = Color(0xFFFFFFFF); // Colors.white
  static const Color uiWhite70 = Color(0xB3FFFFFF); // Colors.white70
  static const Color uiStatusOrange = Color(0xFFFF9800); // Colors.orange
  static const Color uiStatusGreen = Color(0xFF4CAF50); // Colors.green
  static const Color uiCyanAccent = Color(0xFF18FFFF); // Colors.cyanAccent
  static const Color uiCyan = Color(0xFF00FFFF); // Colors.cyan
  static const Color uiOrangeAccent = Color(0xFFFFAB40); // Colors.orangeAccent
  static const Color uiLightBlueAccent = Color(
    0xFF40C4FF,
  ); // Colors.lightBlueAccent
  static const Color uiGreen = Color(0xFF4CAF50); // Colors.green
  static const Color uiYellow = Color(0xFFFFEB3B); // Colors.yellow
  static const Color uiOrange = Color(0xFFFF9800); // Colors.orange
  static const Color uiRed = Color(0xFFF44336); // Colors.red
  static const Color uiBlack = Color(0xFF000000); // Colors.black
  static const Color uiSelectionYellow = Color(
    0xFFFFEB3B,
  ); // Colors.yellow (selection)
  static const Color uiDevRed = Color(0xFFFF0000); // Colors.red for dev ribbon

  /// Primary app theme colors
  static const Color primaryColor = Color(0xFF818cf8); // Main app primary color
  static const Color sectionTitlePurple = Color(
    0xFFB19CD9,
  ); // Light purple for section titles

  /// Off-screen indicator colors
  static const Color offScreenBlackHole = Color(
    0xFF404040,
  ); // Dark grey for black holes
  static const Color offScreenSun = Color(0xFFFFD700); // Gold for sun
  static const Color offScreenMercury = Color(0xFF8C7853); // Mercury color
  static const Color offScreenVenus = Color(0xFFFFC649); // Venus color
  static const Color offScreenEarth = Color(0xFF6B93D6); // Earth color
  static const Color offScreenMars = Color(0xFFCD5C5C); // Mars color
  static const Color offScreenJupiter = Color(0xFFD8CA9D); // Jupiter color
  static const Color offScreenSaturn = Color(0xFFFAD5A5); // Saturn color
  static const Color offScreenUranus = Color(0xFF4FD0E3); // Uranus color
  static const Color offScreenNeptune = Color(0xFF4B70DD); // Neptune color

  /// Random system/utility colors
  static const Color randomStarBlue = Color(
    0xFFADD8E6,
  ); // Light blue for hot stars
  static const Color randomStarWhite = Color(0xFFFFFFFF); // White stars
  static const Color randomStarCream = Color(0xFFFFFACD); // Cream stars
  static const Color randomStarYellow = Color(0xFFFFD700); // Yellow stars
  static const Color randomStarOrange = Color(0xFFFF8C00); // Orange stars
  static const Color randomStarRed = Color(0xFFFF4500); // Red stars
  static const Color randomPlanetBlue = Color(0xFF4169E1); // Blue planets
  static const Color randomPlanetCrimson = Color(0xFFDC143C); // Red planets
  static const Color randomPlanetCornsilk = Color(
    0xFFFFF8DC,
  ); // Venus-like planets
  static const Color randomPlanetGoldenrod = Color(0xFFDAA520); // Gas giants
  static const Color randomPlanetSkyBlue = Color(0xFF87CEEB); // Ice giants
  static const Color randomPlanetBrown = Color(0xFF8B4513); // Rocky planets
  static const Color randomPlanetSilver = Color(
    0xFFC0C0C0,
  ); // Metal-rich planets
  static const Color randomPlanetPurple = Color(0xFF9370DB); // Exotic planets

  // =============================================================================
  // VISUAL EFFECTS & PAINTER COLORS
  // =============================================================================

  /// Graviton painter colors
  static const Color gravitonOrangeRed = Color(
    0xFFFF4500,
  ); // Bright orange-red for graviton rings
  static const Color gravitonGold = Color(
    0xFFFFD700,
  ); // Pure gold for graviton highlights

  /// Star glow gradient colors
  static const Color starGlowWhite = Color(0xFFFFFFFF); // Bright white center
  static const Color starGlowGold = Color(0xFFFFD700); // Golden ring
  static const Color starGlowOrange = Color(0xFFFF8C00); // Orange outer
  static const Color starGlowRedOrange = Color(0xFFFF6B35); // Dim orange edge

  /// Accretion disk colors
  static const Color accretionDiskGold = Color(
    0xFFFFD700,
  ); // Bright gold center
  static const Color accretionDiskOrange = Color(0xFFFFA500); // Orange middle
  static const Color accretionDiskRed = Color(0xFFFF4500); // Red outer

  /// Corona glow colors
  static const Color coronaYellow = Color(0xFFFFFF00); // Bright yellow center
  static const Color coronaGold = Color(0xFFFFD700); // Gold middle
  static const Color coronaOrange = Color(0xFFFFA500); // Orange edge

  /// Moon surface colors
  static const Color moonLightGray = Color(0xFFBEAE9C); // Light gray center
  static const Color moonBrownGray = Color(0xFF8C7853); // Brown-gray edge
  static const Color moonShadow = Color(0xFF6D5D4F); // Shadow color

  /// Venus surface colors
  static const Color venusYellow = Color(0xFFFFC649); // Bright Venus surface
  static const Color venusOrangeMiddle = Color(
    0xFFFFB347,
  ); // Orange middle for Venus atmosphere
  static const Color venusOuterGlow = Color(0xFFFFA500); // Outer glow
  static const Color venusCreamCenter = Color(0xFFFFF8DC); // Light cream center
  static const Color venusGoldenEdge = Color(0xFFFFC649); // Golden yellow edge

  /// Earth surface colors
  static const Color earthSkyBlue = Color(0xFF87CEEB); // Sky blue
  static const Color earthDeepBlue = Color(0xFF1E90FF); // Deep blue
  static const Color earthGreen = Color(0xFF228B22); // Forest green

  /// Mars surface colors
  static const Color marsFaintRed = Color(0xFFCD5C5C); // Faint red
  static const Color marsBrightRed = Color(0xFFDC143C); // Bright red center
  static const Color marsMediumRed = Color(0xFFCD5C5C); // Medium red edge
  static const Color marsIceWhite = Color(0xFFFFFFFF); // Ice caps

  /// Jupiter surface colors
  static const Color jupiterCreamCenter = Color(0xFFD8CA9D); // Cream center
  static const Color jupiterGoldEdge = Color(0xFFDAA520); // Gold edge
  static const Color jupiterSurface = Color(0xFFD8CA9D); // Main surface
  static const Color jupiterBandGold = Color(0xFFB8860B); // Band color
  static const Color jupiterBandBrown = Color(0xFF8B4513); // Brown band
  static const Color jupiterRedSpot = Color(0xFFDC143C); // Great Red Spot

  /// Saturn surface colors
  static const Color saturnCreamCenter = Color(
    0xFFFFF8DC,
  ); // Light cream center
  static const Color saturnGoldenMiddle = Color(
    0xFFEEDC82,
  ); // Golden yellow middle
  static const Color saturnBurlywoodEdge = Color(0xFFDEB887); // Burlywood edge
  static const Color saturnRingColor = Color(0xFFDEB887); // Ring color

  /// Saturn ring system colors
  static const Color saturnDRing = Color(
    0xFFD3D3D3,
  ); // D Ring - Very close inner ring
  static const Color saturnCRing = Color(0xFFE6E6FA); // C Ring - Crepe ring
  static const Color saturnBRing = Color(
    0xFFF5F5DC,
  ); // B Ring - Main bright ring
  static const Color saturnARing = Color(
    0xFFFFE4E1,
  ); // A Ring - Outer main ring
  static const Color saturnFRing = Color(
    0xFFDDDDDD,
  ); // F Ring - Very narrow shepherd ring

  /// Uranus surface colors
  static const Color uranusCyanCenter = Color(0xFF87CEEB); // Light cyan center
  static const Color uranusCyanMiddle = Color(0xFF4FD0E7); // Cyan middle
  static const Color uranusTurquoiseEdge = Color(0xFF40E0D0); // Turquoise edge

  /// Neptune surface colors
  static const Color neptuneCornflowerCenter = Color(
    0xFF6495ED,
  ); // Cornflower blue center
  static const Color neptuneDeepBlueEdge = Color(0xFF4B70DD); // Deep blue edge
  static const Color neptuneDarkSpot = Color(0xFF191970); // Dark storm spot
  static const Color neptuneWindBand = Color(0xFF483D8B); // Wind band color

  /// Generic dark colors for various uses
  static const Color genericDarkGray = Color(
    0xFF505050,
  ); // Dark gray for rings and shadows
  static const Color transparentColor = Color(0x00000000); // Fully transparent

  /// Basic colors for testing and general use
  static const Color basicRed = Color(0xFFF44336); // Colors.red equivalent
  static const Color basicBlue = Color(0xFF2196F3); // Colors.blue equivalent
  static const Color basicGreen = Color(0xFF4CAF50); // Colors.green equivalent
  static const Color basicYellow = Color(
    0xFFFFEB3B,
  ); // Colors.yellow equivalent
  static const Color basicPurple = Color(
    0xFF9C27B0,
  ); // Colors.purple equivalent
  static const Color basicOrange = Color(
    0xFFFF9800,
  ); // Colors.orange equivalent
  static const Color basicCyan = Color(0xFF00FFFF); // Colors.cyan equivalent
  static const Color basicPink = Color(0xFFE91E63); // Colors.pink equivalent
  static const Color basicIndigo = Color(
    0xFF3F51B5,
  ); // Colors.indigo equivalent
  static const Color basicGrey = Color(0xFF9E9E9E); // Colors.grey equivalent
  static const Color basicBlack54 = Color(
    0x8A000000,
  ); // Colors.black54 equivalent

  /// List of basic colors for testing (Colors.primaries equivalent)
  static const List<Color> basicPrimaries = [
    basicRed,
    basicBlue,
    basicGreen,
    basicYellow,
    basicPurple,
    basicOrange,
    basicCyan,
    basicPink,
    basicIndigo,
  ];

  /// Test simulation colors
  static const Color testAmber = Color(0xFFFFD166); // amber
  static const Color testTeal = Color(0xFF06D6A0); // teal
  static const Color testBlue = Color(0xFF118AB2); // blue
  static const Color testRed = Color(0xFFE63946); // red
  static const Color testPink = Color(0xFFF72585); // pink
  static const Color testLightBlue = Color(0xFF4CC9F0); // light blue

  /// Gravity well colors
  static const Color gravityWellYellow = Color(
    0xFFFFEB3B,
  ); // Colors.yellow equivalent
  static const Color gravityWellBlue = Color(
    0xFF2196F3,
  ); // Colors.blue equivalent
  static const Color gravityWellCyan = Color(
    0xFF00FFFF,
  ); // Colors.cyan equivalent

  /// Background gradient colors
  static const Color backgroundDeepBlue = Color(
    0xFF0a0a1a,
  ); // Deep space blue-black
  static const Color backgroundPurple = Color(
    0xFF2a1a3f,
  ); // Enhanced space purple - more vibrant
  static const Color backgroundDeepPurple = Color(
    0xFF3d1a5c,
  ); // Enhanced deep purple - more vibrant
  static const Color backgroundBlack = Color(0xFF000000); // Pure black

  /// Enhanced vibrant background purples for gradient prominence
  static const Color backgroundVibrantPurple = Color(
    0xFF5a2d7a,
  ); // Bright purple
  static const Color backgroundMysticPurple = Color(
    0xFF7b3f9b,
  ); // Mystic purple
  static const Color backgroundRoyalPurple = Color(0xFF663399); // Royal purple

  /// Nebula colors for stars
  static const Color nebulaMediumSlateBlue = Color(
    0xFF9370DB,
  ); // Medium slate blue
  static const Color nebulaPlum = Color(0xFFDDA0DD); // Plum
  static const Color nebulaBlueViolet = Color(0xFF8A2BE2); // Blue violet
  static const Color nebulaSlateBlue = Color(0xFF6A5ACD); // Slate blue
  static const Color nebulaMediumSlateBlue2 = Color(
    0xFF7B68EE,
  ); // Medium slate blue variant
  static const Color nebulaDarkOrchid = Color(0xFF9932CC); // Dark orchid
  static const Color nebulaDarkMagenta = Color(0xFF8B008B); // Dark magenta
  static const Color nebulaRoyalBlue = Color(0xFF4169E1); // Royal blue
  static const Color nebulaCornflowerBlue = Color(
    0xFF6495ED,
  ); // Cornflower blue
  static const Color nebulaSkyBlue = Color(0xFF87CEEB); // Sky blue

  /// Enhanced vibrant nebula purples for more prominence
  static const Color nebulaVibrantPurple = Color(
    0xFFAA55DD,
  ); // Bright vibrant purple
  static const Color nebulaMysticPurple = Color(
    0xFFBB66EE,
  ); // Mystic glowing purple
  static const Color nebulaElectricPurple = Color(
    0xFF9955FF,
  ); // Electric purple
  static const Color nebulaCosmicPurple = Color(
    0xFF7744CC,
  ); // Cosmic deep purple

  // =============================================================================
  // ALPHA & TRANSPARENCY CONSTANTS
  // =============================================================================

  /// Common alpha values used throughout the app
  static const double alphaVeryFaint = 0.003;
  static const double alphaAlmostInvisible = 0.004;
  static const double alphaExtremelyFaint = 0.008;
  static const double alphaVeryFaint2 = 0.010;
  static const double alphaFaint = 0.012;
  static const double alphaVeryFaint3 = 0.016;
  static const double alphaVeryFaint4 = 0.02;
  static const double alphaFaint2 = 0.025;
  static const double alphaFaint3 = 0.03;
  static const double alphaLow = 0.05;
  static const double alphaMediumFaint = 0.06;
  static const double alphaLowMedium = 0.08;
  static const double alphaMedium = 0.10;
  static const double alphaMediumHigh = 0.12;
  static const double alphaSemiVisible = 0.15;
  static const double alphaVisible = 0.18;
  static const double alphaMoreVisible = 0.20;
  static const double alphaQuarter = 0.25;
  static const double alphaMediumVisible = 0.30;
  static const double alphaSemiTransparent = 0.4;
  static const double alphaHalf = 0.5;
  static const double alphaMostlyOpaque = 0.6;
  static const double alphaHigh = 0.7;
  static const double alphaVeryOpaque = 0.8;
  static const double alphaNearlyOpaque = 0.9;
  static const double alphaFullyOpaque = 1.0;

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Create a color with specified alpha from any base color
  static Color withAlpha(Color baseColor, double alpha) {
    return baseColor.withValues(alpha: alpha);
  }

  /// Create gradient colors for glow effects
  static List<Color> createGlowGradient(
    Color baseColor,
    List<double> alphaStops,
  ) {
    return alphaStops.map((alpha) => withAlpha(baseColor, alpha)).toList();
  }

  /// Get habitability color by status
  static Color getHabitabilityColor(String status) {
    switch (status.toLowerCase()) {
      case 'habitable':
        return habitabilityHabitable;
      case 'too_hot':
        return habitabilityTooHot;
      case 'too_cold':
        return habitabilityTooCold;
      default:
        return habitabilityUnknown;
    }
  }

  /// Get temperature visualization color based on temperature in Kelvin
  static Color getTemperatureColor(double temperatureKelvin) {
    final celsius =
        temperatureKelvin - SimulationConstants.kelvinToCelsiusOffset;

    // Color scale from blue (cold) to red (hot)
    if (celsius < -50) return temperatureFrozen;
    if (celsius < 0) return temperatureCold;
    if (celsius < 25) return temperatureCool;
    if (celsius < 50) return temperatureWarm;
    if (celsius < 100) return temperatureHot;
    if (celsius < 200) return temperatureVeryHot;
    return temperatureScorching;
  }

  /// Get planet color by name
  static Color getPlanetColor(String planetName) {
    final celestialBody = CelestialBodyName.fromString(planetName);

    switch (celestialBody) {
      case CelestialBodyName.mercury:
        return planetMercury;
      case CelestialBodyName.venus:
        return planetVenus;
      case CelestialBodyName.earth:
        return planetEarth;
      case CelestialBodyName.mars:
        return planetMars;
      case CelestialBodyName.jupiter:
        return planetJupiter;
      case CelestialBodyName.saturn:
        return planetSaturn;
      case CelestialBodyName.uranus:
        return planetUranus;
      case CelestialBodyName.neptune:
        return planetNeptune;
      default:
        return celestialBlue;
    }
  }
}
