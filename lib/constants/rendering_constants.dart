/// Rendering and visual constants for Graviton
class RenderingConstants {
  // 3D Projection and rendering
  static const double projectionClipZThreshold = 1e-6;
  static const double clipZFallback = 1e9;
  static const double ndcTransformOffset = 0.5;
  static const double distanceClampMin = 0.1;
  static const double distanceClampMax = 1e9;

  // Body rendering
  static const double bodySizeMultiplier =
      175.0; // Much larger multiplier for gas giants
  static const double bodyMinSize = 2.0;
  static const double bodyMaxSize =
      875.0; // Much larger max size for gas giants
  static const double bodyGlowMultiplier = 2.6;
  static const double bodyAlpha = 0.8;
  static const double bodyGlowAlpha = 0.0; // for gradient end

  // Star field rendering
  static const double starSize = 0.7;
  static const double starDefaultRadius =
      3000.0; // Increased from 1000 to accommodate max zoom of 2000
  static const int starAlpha = 0x88;

  // Background gradient colors
  static const int backgroundTopColor = 0xFF05060D;
  static const int backgroundBottomColor = 0xFF000000;

  // Spherical gradient background constants
  static const int sphericalGradientSourceCount = 20;
  static const double sphericalGradientSourceRadius = 2500.0;
  static const double sphericalGradientAnimationScale = 0.05;
  static const double sphericalGradientBaseRadius = 800.0;
  static const double sphericalGradientRadiusVariation = 200.0;
  static const double sphericalGradientMinVisibility = 0.3;
  static const double sphericalGradientMaxVisibility = 0.7;
  static const double sphericalGradientBaseIntensity = 0.2;
  static const double sphericalGradientIntensityVariation = 0.1;
  static const double sphericalGradientPrimaryAlpha = 0.6;
  static const double sphericalGradientSecondaryAlpha = 0.3;
  static const double sphericalGradientTertiaryAlpha = 0.1;

  // Default UI settings
  static const double defaultUIOpacity = 0.8;
  static const double uiOpacityMin = 0.0;
  static const double uiOpacityMax = 1.0;
}
