import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/shared/painters/shadow_info.dart';

void main() {
  group('ShadowInfo', () {
    test('should create instance with all required parameters', () {
      const shadowCenter = Offset(100, 200);
      const umbraRadius = 50.0;
      const penumbraRadius = 75.0;

      final shadowInfo = ShadowInfo(
        shadowCenter: shadowCenter,
        umbraRadius: umbraRadius,
        penumbraRadius: penumbraRadius,
      );

      expect(shadowInfo.shadowCenter, equals(shadowCenter));
      expect(shadowInfo.umbraRadius, equals(umbraRadius));
      expect(shadowInfo.penumbraRadius, equals(penumbraRadius));
    });

    test('should allow umbra and penumbra to be equal', () {
      const shadowCenter = Offset(0, 0);
      const radius = 100.0;

      final shadowInfo = ShadowInfo(
        shadowCenter: shadowCenter,
        umbraRadius: radius,
        penumbraRadius: radius,
      );

      expect(shadowInfo.umbraRadius, equals(shadowInfo.penumbraRadius));
    });

    test('should allow penumbra larger than umbra', () {
      const shadowCenter = Offset(50, 50);
      const umbraRadius = 30.0;
      const penumbraRadius = 60.0;

      final shadowInfo = ShadowInfo(
        shadowCenter: shadowCenter,
        umbraRadius: umbraRadius,
        penumbraRadius: penumbraRadius,
      );

      expect(shadowInfo.penumbraRadius, greaterThan(shadowInfo.umbraRadius));
    });

    test('should handle zero radii', () {
      const shadowCenter = Offset(0, 0);

      final shadowInfo = ShadowInfo(
        shadowCenter: shadowCenter,
        umbraRadius: 0.0,
        penumbraRadius: 0.0,
      );

      expect(shadowInfo.umbraRadius, equals(0.0));
      expect(shadowInfo.penumbraRadius, equals(0.0));
    });

    test('should handle negative offset coordinates', () {
      const shadowCenter = Offset(-100, -200);
      const umbraRadius = 50.0;
      const penumbraRadius = 75.0;

      final shadowInfo = ShadowInfo(
        shadowCenter: shadowCenter,
        umbraRadius: umbraRadius,
        penumbraRadius: penumbraRadius,
      );

      expect(shadowInfo.shadowCenter.dx, lessThan(0));
      expect(shadowInfo.shadowCenter.dy, lessThan(0));
    });
  });
}
