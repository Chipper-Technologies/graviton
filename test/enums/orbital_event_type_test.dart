import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/orbital_event_type.dart';

void main() {
  group('OrbitalEventType', () {
    test('should have all expected values', () {
      const expectedValues = {
        OrbitalEventType.closeApproach,
        OrbitalEventType.periapsis,
        OrbitalEventType.apoapsis,
        OrbitalEventType.slingshot,
        OrbitalEventType.potentialCollision,
        OrbitalEventType.orbitalDecay,
        OrbitalEventType.resonance,
      };

      expect(Set.from(OrbitalEventType.values), equals(expectedValues));
      expect(OrbitalEventType.values.length, equals(7));
    });

    test('should have correct enum names', () {
      expect(OrbitalEventType.closeApproach.name, equals('closeApproach'));
      expect(OrbitalEventType.periapsis.name, equals('periapsis'));
      expect(OrbitalEventType.apoapsis.name, equals('apoapsis'));
      expect(OrbitalEventType.slingshot.name, equals('slingshot'));
      expect(
        OrbitalEventType.potentialCollision.name,
        equals('potentialCollision'),
      );
      expect(OrbitalEventType.orbitalDecay.name, equals('orbitalDecay'));
      expect(OrbitalEventType.resonance.name, equals('resonance'));
    });

    test('should be convertible to string and back', () {
      for (final eventType in OrbitalEventType.values) {
        final stringValue = eventType.name;
        final backToEnum = OrbitalEventType.values.firstWhere(
          (e) => e.name == stringValue,
        );
        expect(backToEnum, equals(eventType));
      }
    });

    test('should be usable in switch statements', () {
      String getEventDescription(OrbitalEventType eventType) {
        switch (eventType) {
          case OrbitalEventType.closeApproach:
            return 'Bodies approaching closely';
          case OrbitalEventType.periapsis:
            return 'Closest point in orbit';
          case OrbitalEventType.apoapsis:
            return 'Farthest point in orbit';
          case OrbitalEventType.slingshot:
            return 'Gravity assist maneuver';
          case OrbitalEventType.potentialCollision:
            return 'Collision course detected';
          case OrbitalEventType.orbitalDecay:
            return 'Orbit spiraling inward';
          case OrbitalEventType.resonance:
            return 'Orbital resonance achieved';
        }
      }

      expect(
        getEventDescription(OrbitalEventType.closeApproach),
        equals('Bodies approaching closely'),
      );
      expect(
        getEventDescription(OrbitalEventType.periapsis),
        equals('Closest point in orbit'),
      );
      expect(
        getEventDescription(OrbitalEventType.apoapsis),
        equals('Farthest point in orbit'),
      );
      expect(
        getEventDescription(OrbitalEventType.slingshot),
        equals('Gravity assist maneuver'),
      );
      expect(
        getEventDescription(OrbitalEventType.potentialCollision),
        equals('Collision course detected'),
      );
      expect(
        getEventDescription(OrbitalEventType.orbitalDecay),
        equals('Orbit spiraling inward'),
      );
      expect(
        getEventDescription(OrbitalEventType.resonance),
        equals('Orbital resonance achieved'),
      );
    });
  });
}
