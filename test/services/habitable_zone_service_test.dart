import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/habitable_zone_service.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('HabitableZoneService - Physics Constants Integration', () {
    late HabitableZoneService service;

    setUp(() {
      service = HabitableZoneService();
    });

    group('Gas Giant Classification with SimulationConstants', () {
      test('should use gasGiantDensityThreshold from SimulationConstants', () {
        // Create a low-density planet that should be classified as gas giant
        final density = SimulationConstants.gasGiantDensityThreshold - 0.1;
        final radius = SimulationConstants.minGasGiantRadius + 1.0;

        // Calculate mass for target density: density = mass / volume
        // volume = (4/3) * π * r³
        final volume = (4.0 / 3.0) * math.pi * math.pow(radius, 3);
        final mass = density * volume;

        final gasGiant = Body(
          name: 'Gas Giant',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: mass,
          radius: radius,
          color: AppColors.uiOrangeAccent,
          bodyType: BodyType.planet,
        );

        final bodies = [gasGiant];
        final status = service.calculateHabitabilityStatus(gasGiant, bodies);

        expect(status, equals(HabitabilityStatus.gasGiant));
      });

      test('should use minGasGiantRadius from SimulationConstants', () {
        // Create a planet just below minimum gas giant radius
        final smallRadius = SimulationConstants.minGasGiantRadius - 0.1;
        final lowDensity = SimulationConstants.gasGiantDensityThreshold - 0.1;

        final volume = (4.0 / 3.0) * math.pi * math.pow(smallRadius, 3);
        final mass = lowDensity * volume;

        final smallBody = Body(
          name: 'Small Low-Density Body',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: mass,
          radius: smallRadius,
          color: AppColors.uiTextGrey,
          bodyType: BodyType.planet,
        );

        final bodies = [smallBody];
        final status = service.calculateHabitabilityStatus(smallBody, bodies);

        // Should NOT be classified as gas giant due to small radius
        expect(status, isNot(equals(HabitabilityStatus.gasGiant)));
      });

      test('rocky planet with high density should not be gas giant', () {
        final rockyDensity = SimulationConstants.gasGiantDensityThreshold + 0.5;
        final radius = SimulationConstants.minGasGiantRadius + 1.0;

        final volume = (4.0 / 3.0) * math.pi * math.pow(radius, 3);
        final mass = rockyDensity * volume;

        final rockyPlanet = Body(
          name: 'Rocky Planet',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: mass,
          radius: radius,
          color: AppColors.asteroidRockyBrown,
          bodyType: BodyType.planet,
        );

        final bodies = [rockyPlanet];
        final status = service.calculateHabitabilityStatus(rockyPlanet, bodies);

        expect(status, isNot(equals(HabitabilityStatus.gasGiant)));
      });
    });

    group('Atmosphere Retention with SimulationConstants', () {
      test('should use minMassForAtmosphere from SimulationConstants', () {
        final tooSmallMass = SimulationConstants.minMassForAtmosphere - 0.001;
        final radius = SimulationConstants.minRadiusForAtmosphere + 0.1;

        final tinyBody = Body(
          name: 'Too Small',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: tooSmallMass,
          radius: radius,
          color: AppColors.uiTextGrey,
          bodyType: BodyType.planet,
        );

        final bodies = [tinyBody];
        final status = service.calculateHabitabilityStatus(tinyBody, bodies);

        expect(status, equals(HabitabilityStatus.tooSmall));
      });

      test('should use minRadiusForAtmosphere from SimulationConstants', () {
        final mass = SimulationConstants.minMassForAtmosphere + 0.01;
        final tooSmallRadius =
            SimulationConstants.minRadiusForAtmosphere - 0.05;

        final tinyBody = Body(
          name: 'Too Small',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: mass,
          radius: tooSmallRadius,
          color: AppColors.uiTextGrey,
          bodyType: BodyType.planet,
        );

        final bodies = [tinyBody];
        final status = service.calculateHabitabilityStatus(tinyBody, bodies);

        expect(status, equals(HabitabilityStatus.tooSmall));
      });

      test('planet above both thresholds should retain atmosphere', () {
        final mass = SimulationConstants.minMassForAtmosphere + 0.01;
        final radius = SimulationConstants.minRadiusForAtmosphere + 0.1;

        final viableBody = Body(
          name: 'Viable Planet',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: mass,
          radius: radius,
          color: AppColors.primaryColor,
          bodyType: BodyType.planet,
        );

        final bodies = [viableBody];
        final status = service.calculateHabitabilityStatus(viableBody, bodies);

        expect(status, isNot(equals(HabitabilityStatus.tooSmall)));
      });
    });

    group('Extreme Gravity with Earth Reference Constants', () {
      test('should use earthReferenceMass and earthReferenceRadius', () {
        // Calculate Earth's reference gravity
        final earthGravity =
            SimulationConstants.earthReferenceMass /
            (SimulationConstants.earthReferenceRadius *
                SimulationConstants.earthReferenceRadius);

        // Create planet with exactly 10x Earth gravity (threshold)
        final extremeMass =
            SimulationConstants.extremeGravityThreshold *
            earthGravity *
            (SimulationConstants.earthReferenceRadius *
                SimulationConstants.earthReferenceRadius);

        final extremeGravityPlanet = Body(
          name: 'Extreme Gravity',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: extremeMass + 0.01, // Slightly above threshold
          radius: SimulationConstants.earthReferenceRadius,
          color: AppColors.stellarOType,
          bodyType: BodyType.planet,
        );

        final bodies = [extremeGravityPlanet];
        final status = service.calculateHabitabilityStatus(
          extremeGravityPlanet,
          bodies,
        );

        expect(status, equals(HabitabilityStatus.extremeGravity));
      });

      test(
        'planet with normal gravity should not be classified as extreme',
        () {
          final normalGravityPlanet = Body(
            name: 'Earth-like',
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: SimulationConstants.earthReferenceMass,
            radius: SimulationConstants.earthReferenceRadius,
            color: AppColors.primaryColor,
            bodyType: BodyType.planet,
          );

          final bodies = [normalGravityPlanet];
          final status = service.calculateHabitabilityStatus(
            normalGravityPlanet,
            bodies,
          );

          expect(status, isNot(equals(HabitabilityStatus.extremeGravity)));
        },
      );

      test('should use extremeGravityThreshold correctly', () {
        // Create planet with gravity just below threshold
        final earthGravity =
            SimulationConstants.earthReferenceMass /
            (SimulationConstants.earthReferenceRadius *
                SimulationConstants.earthReferenceRadius);

        final belowThresholdMass =
            (SimulationConstants.extremeGravityThreshold - 0.1) *
            earthGravity *
            (SimulationConstants.earthReferenceRadius *
                SimulationConstants.earthReferenceRadius);

        final normalPlanet = Body(
          name: 'Normal Gravity',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: belowThresholdMass,
          radius: SimulationConstants.earthReferenceRadius,
          color: AppColors.uiGreen,
          bodyType: BodyType.planet,
        );

        final bodies = [normalPlanet];
        final status = service.calculateHabitabilityStatus(
          normalPlanet,
          bodies,
        );

        expect(status, isNot(equals(HabitabilityStatus.extremeGravity)));
      });
    });

    group('High Radiation with SimulationConstants', () {
      test('should use highRadiationThreshold from SimulationConstants', () {
        // Create very bright star
        final brightStar = Body(
          name: 'Bright Star',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 50.0,
          radius: 3.0,
          color: AppColors.uiWhite,
          bodyType: BodyType.star,
          stellarLuminosity: SimulationConstants.solarLuminosity * 100,
        );

        // Place planet farther away to avoid tidal locking but still get high radiation
        // tidalLockingDistanceAU = 0.1 AU = 5.0 simulation units
        // Put planet at 10.0 units (0.2 AU) - beyond tidal locking
        final closePlanet = Body(
          name: 'Close Planet',
          position: vm.Vector3(10.0, 0, 0), // Changed from 2.0 to 10.0
          velocity: vm.Vector3.zero(),
          mass: SimulationConstants.earthReferenceMass,
          radius: SimulationConstants.earthReferenceRadius,
          color: AppColors.uiRed,
          bodyType: BodyType.planet,
        );

        final bodies = [brightStar, closePlanet];
        final status = service.calculateHabitabilityStatus(closePlanet, bodies);

        expect(status, equals(HabitabilityStatus.highRadiation));
      });
    });

    group('Tidal Locking with SimulationConstants', () {
      test('should use tidalLockingDistanceAU from SimulationConstants', () {
        final star = Body(
          name: 'Star',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.stellarGType,
          bodyType: BodyType.star,
          stellarLuminosity: SimulationConstants.solarLuminosity,
        );

        // Place planet just inside tidal locking threshold
        // tidalLockingDistanceAU = 0.1 AU
        // simulationUnitsToAU = 0.02 (1 unit = 0.02 AU)
        // 0.1 AU = 0.1 / 0.02 = 5.0 simulation units
        final tidalDistance =
            SimulationConstants.tidalLockingDistanceAU /
            SimulationConstants.simulationUnitsToAU;

        final lockedPlanet = Body(
          name: 'Tidally Locked',
          position: vm.Vector3(tidalDistance - 1.0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: SimulationConstants.earthReferenceMass,
          radius: SimulationConstants.earthReferenceRadius,
          color: AppColors.uiRed,
          bodyType: BodyType.planet,
        );

        final bodies = [star, lockedPlanet];
        final status = service.calculateHabitabilityStatus(
          lockedPlanet,
          bodies,
        );

        expect(status, equals(HabitabilityStatus.tidallyLocked));
      });

      test('planet beyond tidal locking distance should not be locked', () {
        final star = Body(
          name: 'Star',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.stellarGType,
          bodyType: BodyType.star,
          stellarLuminosity: SimulationConstants.solarLuminosity,
        );

        // Place planet beyond tidal locking threshold
        final tidalDistance =
            SimulationConstants.tidalLockingDistanceAU /
            SimulationConstants.simulationUnitsToAU;

        final distantPlanet = Body(
          name: 'Distant Planet',
          position: vm.Vector3(tidalDistance + 5.0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: SimulationConstants.earthReferenceMass,
          radius: SimulationConstants.earthReferenceRadius,
          color: AppColors.primaryColor,
          bodyType: BodyType.planet,
        );

        final bodies = [star, distantPlanet];
        final status = service.calculateHabitabilityStatus(
          distantPlanet,
          bodies,
        );

        expect(status, isNot(equals(HabitabilityStatus.tidallyLocked)));
      });
    });

    group('Constants Integration - Complete System', () {
      test('all habitability constants should work together consistently', () {
        // Verify that all constants are defined and accessible
        expect(SimulationConstants.gasGiantDensityThreshold, equals(0.8));
        expect(SimulationConstants.minGasGiantRadius, equals(3.0));
        expect(SimulationConstants.minMassForAtmosphere, equals(0.005));
        expect(SimulationConstants.minRadiusForAtmosphere, equals(0.15));
        expect(SimulationConstants.extremeGravityThreshold, equals(10.0));
        expect(SimulationConstants.highRadiationThreshold, equals(50.0));
        expect(SimulationConstants.tidalLockingDistanceAU, equals(0.1));
        expect(SimulationConstants.earthReferenceMass, equals(0.02));
        expect(SimulationConstants.earthReferenceRadius, equals(0.6));
      });

      test('constants should maintain logical relationships', () {
        // Gas giant threshold should be less than rocky planet density
        expect(SimulationConstants.gasGiantDensityThreshold, lessThan(1.0));

        // Atmosphere retention thresholds should be small values
        expect(SimulationConstants.minMassForAtmosphere, lessThan(0.1));
        expect(SimulationConstants.minRadiusForAtmosphere, lessThan(1.0));

        // Extreme gravity threshold should be significant multiplier
        expect(SimulationConstants.extremeGravityThreshold, greaterThan(5.0));

        // Tidal locking distance should be close to star
        expect(SimulationConstants.tidalLockingDistanceAU, lessThan(1.0));
      });
    });
  });
}
