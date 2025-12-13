import 'package:graviton/models/celestial/body.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Light source contribution for blended lighting calculations
///
/// Represents the contribution of a single light source (star) to the
/// illumination of a celestial body, including intensity and direction.
class LightContribution {
  /// The star body that is contributing light
  final Body star;

  /// The normalized intensity of light from this source (0.0-1.0)
  ///
  /// Calculated using inverse square law with distance and normalized
  /// by [RenderingConstants.lightIntensityNormalizationFactor]
  final double intensity;

  /// The direction vector from the body being lit to this light source
  ///
  /// Used for calculating hemisphere lighting, specular highlights,
  /// and atmospheric scattering effects
  final vm.Vector3 direction;

  /// Creates a light contribution
  ///
  /// All parameters are required:
  /// - [star]: The light-emitting body
  /// - [intensity]: Normalized light intensity (0.0-1.0)
  /// - [direction]: Direction vector to light source (should be normalized)
  LightContribution({
    required this.star,
    required this.intensity,
    required this.direction,
  });
}
