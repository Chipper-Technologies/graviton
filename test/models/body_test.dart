import 'package:flutter_test/flutter_test.dart';
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
  });
}
