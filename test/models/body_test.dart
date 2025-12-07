import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Body Model Tests', () {
    test('Body constructor should initialize with correct values', () {
      final position = vm.Vector3(1.0, 2.0, 3.0);
      final velocity = vm.Vector3(0.1, 0.2, 0.3);
      const mass = 10.0;
      const radius = 1.5;
      const color = AppColors.basicRed;
      const isPlanet = true;
      const name = 'Test Body';

      final body = Body(
        position: position,
        velocity: velocity,
        mass: mass,
        radius: radius,
        color: color,
        name: name,
        isPlanet: isPlanet,
      );

      expect(body.position, equals(position));
      expect(body.velocity, equals(velocity));
      expect(body.mass, equals(mass));
      expect(body.radius, equals(radius));
      expect(body.color, equals(color));
      expect(body.name, equals(name));
      expect(body.isPlanet, equals(isPlanet));
    });

    test('Body should have default isPlanet value of false', () {
      final body = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 1.0,
        radius: 1.0,
        color: AppColors.basicBlue,
        name: 'Test Body',
      );

      expect(body.isPlanet, isFalse);
    });

    test('Body position and velocity should be mutable', () {
      final body = Body(
        position: vm.Vector3(1.0, 1.0, 1.0),
        velocity: vm.Vector3(0.1, 0.1, 0.1),
        mass: 1.0,
        radius: 1.0,
        color: AppColors.basicGreen,
        name: 'Mutable Body',
      );

      // Modify position
      body.position.setValues(2.0, 3.0, 4.0);
      expect(body.position.x, equals(2.0));
      expect(body.position.y, equals(3.0));
      expect(body.position.z, equals(4.0));

      // Modify velocity
      body.velocity.setValues(0.2, 0.3, 0.4);
      expect(body.velocity.x, equals(0.2));
      expect(body.velocity.y, equals(0.3));
      expect(body.velocity.z, equals(0.4));
    });

    test('Body should handle zero mass', () {
      final body = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 0.0,
        radius: 1.0,
        color: AppColors.basicYellow,
        name: 'Zero Mass Body',
      );

      expect(body.mass, equals(0.0));
    });

    test('Body should handle negative values appropriately', () {
      final body = Body(
        position: vm.Vector3(-1.0, -2.0, -3.0),
        velocity: vm.Vector3(-0.1, -0.2, -0.3),
        mass: 1.0,
        radius: 0.5,
        color: AppColors.basicPurple,
        name: 'Negative Values Body',
      );

      expect(body.position.x, equals(-1.0));
      expect(body.position.y, equals(-2.0));
      expect(body.position.z, equals(-3.0));
      expect(body.velocity.x, equals(-0.1));
      expect(body.velocity.y, equals(-0.2));
      expect(body.velocity.z, equals(-0.3));
    });

    group('Temperature Conversions', () {
      test('should convert temperature to Celsius correctly', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          temperature: 293.15, // 20°C in Kelvin
        );

        expect(body.temperatureCelsius, closeTo(20.0, 0.01));
      });

      test('should convert temperature to Fahrenheit correctly', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          temperature: 273.15, // 0°C in Kelvin
        );

        expect(body.temperatureFahrenheit, closeTo(32.0, 0.01));
      });

      test('should identify reasonable temperature range', () {
        final coldBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Cold Body',
          bodyType: BodyType.planet,
          temperature: 223.15, // -50°C
        );

        final hotBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicRed,
          name: 'Hot Body',
          bodyType: BodyType.planet,
          temperature: 423.15, // 150°C
        );

        final comfortableBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Comfortable Body',
          bodyType: BodyType.planet,
          temperature: 293.15, // 20°C
        );

        expect(coldBody.hasReasonableTemperature, isTrue);
        expect(hotBody.hasReasonableTemperature, isTrue);
        expect(comfortableBody.hasReasonableTemperature, isTrue);
      });

      test('should categorize temperatures correctly', () {
        final frozen = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Frozen',
          bodyType: BodyType.planet,
          temperature: 100.0, // -173°C
        );

        final cold = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Cold',
          bodyType: BodyType.planet,
          temperature: 250.0, // -23°C
        );

        final moderate = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Moderate',
          bodyType: BodyType.planet,
          temperature: 293.15, // 20°C
        );

        final hot = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicOrange,
          name: 'Hot',
          bodyType: BodyType.planet,
          temperature: 373.15, // 100°C
        );

        final scorching = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicRed,
          name: 'Scorching',
          bodyType: BodyType.planet,
          temperature: 500.0, // 227°C
        );

        expect(frozen.temperatureCategory, equals('temperatureFrozen'));
        expect(cold.temperatureCategory, equals('temperatureCold'));
        expect(moderate.temperatureCategory, equals('temperatureModerate'));
        expect(hot.temperatureCategory, equals('temperatureHot'));
        expect(scorching.temperatureCategory, equals('temperatureScorching'));
      });
    });

    group('Body Type Properties', () {
      test('should identify luminous bodies correctly', () {
        final star = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.stellarGType,
          name: 'Star',
          bodyType: BodyType.star,
        );

        expect(star.isLuminous, isTrue);
      });

      test('should identify habitable bodies correctly', () {
        final planet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Planet',
          bodyType: BodyType.planet,
        );

        expect(planet.canBeHabitable, isTrue);
      });
    });

    group('Status Updates', () {
      test('should update habitability status', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          habitabilityStatus: HabitabilityStatus.unknown,
        );

        expect(body.habitabilityStatus, equals(HabitabilityStatus.unknown));

        body.updateHabitabilityStatus(HabitabilityStatus.habitable);
        expect(body.habitabilityStatus, equals(HabitabilityStatus.habitable));

        body.updateHabitabilityStatus(HabitabilityStatus.tooHot);
        expect(body.habitabilityStatus, equals(HabitabilityStatus.tooHot));
      });

      test('should update temperature', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          temperature: 273.15,
        );

        expect(body.temperature, equals(273.15));

        body.updateTemperature(293.15);
        expect(body.temperature, equals(293.15));
        expect(body.temperatureCelsius, closeTo(20.0, 0.01));
      });
    });

    group('Equality and Hashing', () {
      test('should compare bodies for equality correctly', () {
        final body1 = Body(
          position: vm.Vector3(1.0, 2.0, 3.0),
          velocity: vm.Vector3(0.1, 0.2, 0.3),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.basicRed,
          name: 'Body 1',
        );

        final body2 = Body(
          position: vm.Vector3(1.0, 2.0, 3.0),
          velocity: vm.Vector3(0.1, 0.2, 0.3),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.basicRed,
          name: 'Body 1',
        );

        final body3 = Body(
          position: vm.Vector3(2.0, 3.0, 4.0),
          velocity: vm.Vector3(0.2, 0.3, 0.4),
          mass: 20.0,
          radius: 2.0,
          color: AppColors.basicBlue,
          name: 'Body 3',
        );

        expect(body1 == body2, isTrue);
        expect(body1 == body3, isFalse);
        expect(body1 == body1, isTrue);
      });

      test('should generate consistent hash codes', () {
        final body1 = Body(
          position: vm.Vector3(1.0, 2.0, 3.0),
          velocity: vm.Vector3(0.1, 0.2, 0.3),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.basicRed,
          name: 'Body 1',
        );

        final body2 = Body(
          position: vm.Vector3(1.0, 2.0, 3.0),
          velocity: vm.Vector3(0.1, 0.2, 0.3),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.basicRed,
          name: 'Body 1',
        );

        expect(body1.hashCode, equals(body2.hashCode));
      });
    });

    group('Orbital Parameters', () {
      test('should set orbital parameters from constructor', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          orbitRadius: 100.0,
          orbitPhase: 1.57,
          orbitInclination: 0.5,
        );

        expect(body.orbitRadius, equals(100.0));
        expect(body.orbitPhase, equals(1.57));
        expect(body.orbitInclination, equals(0.5));
      });

      test('should update orbital parameters', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        body.orbitRadius = 200.0;
        body.orbitPhase = 3.14;
        body.orbitInclination = 1.0;

        expect(body.orbitRadius, equals(200.0));
        expect(body.orbitPhase, equals(3.14));
        expect(body.orbitInclination, equals(1.0));
      });

      test('should toggle orbital placement mode', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.isOrbitalPlacementActive, isFalse);

        body.isOrbitalPlacementActive = true;
        expect(body.isOrbitalPlacementActive, isTrue);

        body.isOrbitalPlacementActive = false;
        expect(body.isOrbitalPlacementActive, isFalse);
      });
    });

    group('Gravity Well', () {
      test('should default showGravityWell to false', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.showGravityWell, isFalse);
      });

      test('should set showGravityWell from constructor', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          showGravityWell: true,
        );

        expect(body.showGravityWell, isTrue);
      });

      test('should update showGravityWell via setter', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        body.showGravityWell = true;
        expect(body.showGravityWell, isTrue);

        body.showGravityWell = false;
        expect(body.showGravityWell, isFalse);
      });
    });

    group('Body Type Properties', () {
      test('should default to planet body type', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.bodyType, equals(BodyType.planet));
      });

      test('should set body type from constructor', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          bodyType: BodyType.star,
        );

        expect(body.bodyType, equals(BodyType.star));
      });

      test('isLuminous should delegate to bodyType', () {
        final starBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Star',
          bodyType: BodyType.star,
        );

        final planetBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Planet',
          bodyType: BodyType.planet,
        );

        expect(starBody.isLuminous, equals(BodyType.star.isLuminous));
        expect(planetBody.isLuminous, equals(BodyType.planet.isLuminous));
      });

      test('canBeHabitable should delegate to bodyType', () {
        final planetBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Planet',
          bodyType: BodyType.planet,
        );

        final starBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Star',
          bodyType: BodyType.star,
        );

        expect(
          planetBody.canBeHabitable,
          equals(BodyType.planet.canBeHabitable),
        );
        expect(starBody.canBeHabitable, equals(BodyType.star.canBeHabitable));
      });
    });

    group('Temperature Properties', () {
      test('should default temperature to 0°C (273.15K)', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          body.temperature,
          equals(SimulationConstants.kelvinToCelsiusOffset),
        );
        expect(body.temperatureCelsius, equals(0.0));
      });

      test('should convert temperature to Celsius correctly', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          temperature: 373.15, // 100°C
        );

        expect(body.temperatureCelsius, closeTo(100.0, 0.01));
      });

      test('should convert temperature to Fahrenheit correctly', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          temperature: 273.15, // 0°C = 32°F
        );

        expect(body.temperatureFahrenheit, closeTo(32.0, 0.01));

        body.temperature = 373.15; // 100°C = 212°F
        expect(body.temperatureFahrenheit, closeTo(212.0, 0.01));
      });

      test('should determine reasonable temperature for habitable bodies', () {
        final habitableBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Habitable Planet',
          bodyType: BodyType.planet,
          temperature: 293.15, // 20°C
        );

        final tooHotBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Hot Planet',
          bodyType: BodyType.planet,
          temperature: 473.15, // 200°C
        );

        final tooColdBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Cold Planet',
          bodyType: BodyType.planet,
          temperature: 173.15, // -100°C
        );

        final starBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Star',
          bodyType: BodyType.star,
          temperature: 293.15, // 20°C
        );

        expect(habitableBody.hasReasonableTemperature, isTrue);
        expect(tooHotBody.hasReasonableTemperature, isFalse);
        expect(tooColdBody.hasReasonableTemperature, isFalse);
        expect(
          starBody.hasReasonableTemperature,
          isFalse,
        ); // Stars can't be habitable
      });

      test('should categorize temperature correctly', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Planet',
          bodyType: BodyType.planet,
        );

        // Test non-habitable body
        final starBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Star',
          bodyType: BodyType.star,
        );
        expect(
          starBody.temperatureCategory,
          equals('temperatureNotApplicable'),
        );

        // Test frozen (-150°C)
        body.temperature = 123.15; // -150°C
        expect(body.temperatureCategory, equals('temperatureFrozen'));

        // Test cold (-25°C)
        body.temperature = 248.15; // -25°C
        expect(body.temperatureCategory, equals('temperatureCold'));

        // Test moderate (25°C)
        body.temperature = 298.15; // 25°C
        expect(body.temperatureCategory, equals('temperatureModerate'));

        // Test hot (75°C)
        body.temperature = 348.15; // 75°C
        expect(body.temperatureCategory, equals('temperatureHot'));

        // Test scorching (200°C)
        body.temperature = 473.15; // 200°C
        expect(body.temperatureCategory, equals('temperatureScorching'));
      });
    });

    group('Habitability Properties', () {
      test('should default habitability status to unknown', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.habitabilityStatus, equals(HabitabilityStatus.unknown));
      });

      test('should set habitability status from constructor', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          habitabilityStatus: HabitabilityStatus.habitable,
        );

        expect(body.habitabilityStatus, equals(HabitabilityStatus.habitable));
      });

      test('should update habitability status', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        body.updateHabitabilityStatus(HabitabilityStatus.tooHot);
        expect(body.habitabilityStatus, equals(HabitabilityStatus.tooHot));

        body.updateHabitabilityStatus(HabitabilityStatus.tooCold);
        expect(body.habitabilityStatus, equals(HabitabilityStatus.tooCold));
      });
    });

    group('Stellar Properties', () {
      test('should default stellar luminosity to 0.0', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.stellarLuminosity, equals(0.0));
      });

      test('should set stellar luminosity from constructor', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Star',
          stellarLuminosity: 1.5,
        );

        expect(body.stellarLuminosity, equals(1.5));
      });
    });

    group('Temperature Updates', () {
      test('should update temperature', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        const newTemperature = 350.0;
        body.updateTemperature(newTemperature);
        expect(body.temperature, equals(newTemperature));
      });
    });

    group('Equality and HashCode', () {
      test('should be equal for identical properties', () {
        final body1 = Body(
          position: vm.Vector3(1.0, 2.0, 3.0),
          velocity: vm.Vector3(0.1, 0.2, 0.3),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.basicRed,
          name: 'Test Body',
          isPlanet: true,
          bodyType: BodyType.planet,
          stellarLuminosity: 0.5,
          habitabilityStatus: HabitabilityStatus.habitable,
          temperature: 300.0,
          showGravityWell: true,
        );

        final body2 = Body(
          position: vm.Vector3(1.0, 2.0, 3.0),
          velocity: vm.Vector3(0.1, 0.2, 0.3),
          mass: 10.0,
          radius: 1.5,
          color: AppColors.basicRed,
          name: 'Test Body',
          isPlanet: true,
          bodyType: BodyType.planet,
          stellarLuminosity: 0.5,
          habitabilityStatus: HabitabilityStatus.habitable,
          temperature: 300.0,
          showGravityWell: true,
        );

        expect(body1, equals(body2));
        expect(body1.hashCode, equals(body2.hashCode));
      });

      test('should not be equal for different properties', () {
        final body1 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Body 1',
        );

        final body2 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Body 2', // Different name
        );

        expect(body1, isNot(equals(body2)));
        expect(body1.hashCode, isNot(equals(body2.hashCode)));
      });

      test('should be equal to itself', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body, equals(body));
        expect(body.hashCode, equals(body.hashCode));
      });
    });

    group('Relativistic Properties Tests', () {
      test('should initialize with default relativistic properties', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.properTime, equals(0.0));
        expect(body.timeDilationFactor, equals(1.0));
        expect(body.showRelativisticGlow, isFalse);
      });

      test('should allow setting custom relativistic properties', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          properTime: 100.0,
          timeDilationFactor: 1.1547,
          showRelativisticGlow: true,
        );

        expect(body.properTime, equals(100.0));
        expect(body.timeDilationFactor, equals(1.1547));
        expect(body.showRelativisticGlow, isTrue);
      });

      test('showRelativisticGlow getter and setter should work', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.showRelativisticGlow, isFalse);

        body.showRelativisticGlow = true;
        expect(body.showRelativisticGlow, isTrue);

        body.showRelativisticGlow = false;
        expect(body.showRelativisticGlow, isFalse);
      });

      test('equality should include relativistic properties', () {
        final body1 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          properTime: 50.0,
          timeDilationFactor: 1.2,
          showRelativisticGlow: true,
        );

        final body2 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          properTime: 50.0,
          timeDilationFactor: 1.2,
          showRelativisticGlow: true,
        );

        final body3 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          properTime: 100.0, // Different proper time
          timeDilationFactor: 1.2,
          showRelativisticGlow: true,
        );

        expect(body1, equals(body2));
        expect(body1, isNot(equals(body3)));
      });
    });

    group('Tidal Force Properties Tests', () {
      test('should initialize with default tidal properties', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.tidalStress, equals(0.0));
        expect(body.tidalAxisMajor, equals(vm.Vector3.zero()));
        expect(body.tidalAxisMinor, equals(vm.Vector3.zero()));
        expect(body.showTidalForces, isFalse);
        expect(body.tidalHeating, equals(0.0));
      });

      test('should allow setting custom tidal properties', () {
        final majorAxis = vm.Vector3(1.0, 0.0, 0.0);
        final minorAxis = vm.Vector3(0.0, 1.0, 0.0);

        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          tidalStress: 0.5,
          tidalAxisMajor: majorAxis,
          tidalAxisMinor: minorAxis,
          showTidalForces: true,
          tidalHeating: 10.0,
        );

        expect(body.tidalStress, equals(0.5));
        expect(body.tidalAxisMajor, equals(majorAxis));
        expect(body.tidalAxisMinor, equals(minorAxis));
        expect(body.showTidalForces, isTrue);
        expect(body.tidalHeating, equals(10.0));
      });

      test('showTidalForces getter and setter should work', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.showTidalForces, isFalse);

        body.showTidalForces = true;
        expect(body.showTidalForces, isTrue);

        body.showTidalForces = false;
        expect(body.showTidalForces, isFalse);
      });

      test('equality should include tidal properties', () {
        final majorAxis = vm.Vector3(1.0, 0.0, 0.0);
        final minorAxis = vm.Vector3(0.0, 1.0, 0.0);

        final body1 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          tidalStress: 0.3,
          tidalAxisMajor: majorAxis,
          tidalAxisMinor: minorAxis,
          showTidalForces: true,
          tidalHeating: 5.0,
        );

        final body2 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          tidalStress: 0.3,
          tidalAxisMajor: majorAxis,
          tidalAxisMinor: minorAxis,
          showTidalForces: true,
          tidalHeating: 5.0,
        );

        final body3 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
          tidalStress: 0.6, // Different tidal stress
          tidalAxisMajor: majorAxis,
          tidalAxisMinor: minorAxis,
          showTidalForces: true,
          tidalHeating: 5.0,
        );

        expect(body1, equals(body2));
        expect(body1, isNot(equals(body3)));
      });

      test('tidal axes can be modified after construction', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(body.tidalAxisMajor, equals(vm.Vector3.zero()));

        // Modify the tidal axis
        body.tidalAxisMajor = vm.Vector3(1.0, 0.0, 0.0);
        expect(body.tidalAxisMajor, equals(vm.Vector3(1.0, 0.0, 0.0)));

        body.tidalAxisMinor = vm.Vector3(0.0, 1.0, 0.0);
        expect(body.tidalAxisMinor, equals(vm.Vector3(0.0, 1.0, 0.0)));
      });
    });
  });
}
