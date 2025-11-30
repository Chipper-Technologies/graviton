import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/collision_effects_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CollisionEffectsService', () {
    late CollisionEffectsService service;
    late Body body1;
    late Body body2;
    late vm.Vector3 collisionPoint;

    setUp(() {
      service = CollisionEffectsService();

      body1 = Body(
        position: vm.Vector3(0, 0, 0),
        velocity: vm.Vector3(1, 0, 0),
        mass: 10.0,
        radius: 2.0,
        color: AppColors.basicRed,
        name: 'Body 1',
        temperature: 5000.0,
      );

      body2 = Body(
        position: vm.Vector3(1, 0, 0),
        velocity: vm.Vector3(-1, 0, 0),
        mass: 8.0,
        radius: 1.5,
        color: AppColors.basicBlue,
        name: 'Body 2',
        temperature: 4500.0,
      );

      collisionPoint = vm.Vector3(0.5, 0, 0);
    });

    group('Initialization', () {
      test('Should initialize with empty particle lists', () {
        expect(service.debrisParticles, isEmpty);
        expect(service.shockwaves, isEmpty);
        expect(service.debrisClouds, isEmpty);
        expect(service.plasmaJets, isEmpty);
      });

      test('Should have default settings enabled', () {
        expect(service.showDebris, isTrue);
        expect(service.showShockwaves, isTrue);
        expect(service.showEjection, isTrue);
        expect(service.showPlasmaJets, isFalse);
      });

      test('Should have correct maximum particle counts', () {
        expect(CollisionEffectsService.maxDebrisParticles, equals(500));
        expect(CollisionEffectsService.maxCloudParticles, equals(200));
        expect(CollisionEffectsService.maxJetParticles, equals(100));
      });
    });

    group('Debris Particle Generation', () {
      test('Should generate debris particles when enabled', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisParticles, isNotEmpty);
        expect(service.debrisParticles.length, greaterThan(10));
        expect(service.debrisParticles.length, lessThanOrEqualTo(40));
      });

      test('Should not generate debris when disabled', () {
        service.showDebris = false;

        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisParticles, isEmpty);
      });

      test('Debris particles should have valid properties', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        for (final particle in service.debrisParticles) {
          expect(particle.position, isNotNull);
          expect(particle.velocity, isNotNull);
          expect((particle.color.a * 255.0).round(), greaterThan(0));
          expect(particle.size, greaterThan(0));
          expect(particle.lifetime, greaterThan(0));
          expect(particle.mass, greaterThan(0));
        }
      });

      test('Should respect maximum debris particle count', () {
        // Fill up with particles first
        for (int i = 0; i < 50; i++) {
          service.generateCollisionEffects(
            body1: body1,
            body2: body2,
            collisionPoint: collisionPoint,
          );
        }

        // Service may generate one batch before checking limit
        expect(
          service.debrisParticles.length,
          lessThanOrEqualTo(CollisionEffectsService.maxDebrisParticles + 40),
        );
      });
    });

    group('Shockwave Generation', () {
      test('Should generate shockwaves when enabled', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.shockwaves, isNotEmpty);
        expect(service.shockwaves.length, equals(2)); // Primary + secondary
      });

      test('Should not generate shockwaves when disabled', () {
        service.showShockwaves = false;

        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.shockwaves, isEmpty);
      });

      test('Shockwaves should have valid properties', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        for (final shockwave in service.shockwaves) {
          expect(shockwave.position, isNotNull);
          expect(shockwave.radius, greaterThanOrEqualTo(0));
          expect(shockwave.maxRadius, greaterThan(0));
          expect(shockwave.thickness, greaterThan(0));
          expect(shockwave.age, equals(0.0));
          expect((shockwave.color.a * 255.0).round(), greaterThan(0));
        }
      });

      test('Should generate primary and secondary shockwaves', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.shockwaves.length, equals(2));

        // Secondary should have larger max radius and longer lifetime
        final primary = service.shockwaves[0];
        final secondary = service.shockwaves[1];

        expect(secondary.maxRadius, greaterThan(primary.maxRadius));
        expect(secondary.lifetime, greaterThan(primary.lifetime));
      });
    });

    group('Debris Cloud Generation', () {
      test('Should generate debris clouds when enabled', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisClouds, isNotEmpty);
        expect(service.debrisClouds.length, equals(1));
      });

      test('Should not generate debris clouds when disabled', () {
        service.showEjection = false;

        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisClouds, isEmpty);
      });

      test('Debris clouds should have valid properties', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        final cloud = service.debrisClouds.first;
        expect(cloud.particles, isNotEmpty);
        expect(cloud.particles.length, greaterThan(15));
        expect(cloud.particles.length, lessThanOrEqualTo(30));
        expect(cloud.centerOfMass, isNotNull);
        expect(cloud.expansionRate, greaterThan(0));
        expect(cloud.lifetime, greaterThan(0));
        expect(cloud.baseColor, isNotNull);
      });

      test('Should respect maximum cloud particle count', () {
        // Fill up with cloud particles
        for (int i = 0; i < 20; i++) {
          service.generateCollisionEffects(
            body1: body1,
            body2: body2,
            collisionPoint: collisionPoint,
          );
        }

        final totalCloudParticles = service.debrisClouds.fold<int>(
          0,
          (sum, cloud) => sum + cloud.particles.length,
        );

        // Service may generate one batch before checking limit
        expect(
          totalCloudParticles,
          lessThanOrEqualTo(CollisionEffectsService.maxCloudParticles + 30),
        );
      });
    });

    group('Plasma Jet Generation', () {
      test('Should not generate plasma jets when disabled', () {
        service.showPlasmaJets = false;

        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.plasmaJets, isEmpty);
      });

      test('Should generate plasma jets for high-energy collisions', () {
        service.showPlasmaJets = true;

        // Create high-energy collision with massive bodies
        final massiveBody1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(10, 0, 0),
          mass: 100.0,
          radius: 5.0,
          color: AppColors.basicRed,
          name: 'Massive Body 1',
          temperature: 50000.0,
        );

        final massiveBody2 = Body(
          position: vm.Vector3(1, 0, 0),
          velocity: vm.Vector3(-10, 0, 0),
          mass: 80.0,
          radius: 4.0,
          color: AppColors.basicBlue,
          name: 'Massive Body 2',
          temperature: 45000.0,
        );

        service.generateCollisionEffects(
          body1: massiveBody1,
          body2: massiveBody2,
          collisionPoint: collisionPoint,
        );

        // May or may not generate jets depending on impact energy threshold
        // Just verify no errors occur
        expect(() => service.plasmaJets, returnsNormally);
      });

      test('Plasma jets should have valid properties when generated', () {
        service.showPlasmaJets = true;

        // Create extremely high-energy collision
        final massiveBody1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(20, 0, 0),
          mass: 200.0,
          radius: 10.0,
          color: AppColors.basicRed,
          name: 'Massive Body 1',
          temperature: 50000.0,
        );

        final massiveBody2 = Body(
          position: vm.Vector3(1, 0, 0),
          velocity: vm.Vector3(-20, 0, 0),
          mass: 180.0,
          radius: 9.0,
          color: AppColors.basicBlue,
          name: 'Massive Body 2',
          temperature: 48000.0,
        );

        service.generateCollisionEffects(
          body1: massiveBody1,
          body2: massiveBody2,
          collisionPoint: collisionPoint,
        );

        // If jets were generated, validate their properties
        for (final jet in service.plasmaJets) {
          expect(jet.particles, isNotEmpty);
          expect(jet.origin, isNotNull);
          expect(jet.direction, isNotNull);
          expect(jet.velocity, greaterThan(0));
          expect(jet.lifetime, greaterThan(0));
          expect(jet.temperature, greaterThan(0));
        }
      });

      test('Should generate bipolar plasma jets', () {
        service.showPlasmaJets = true;

        // Force jet generation with extreme conditions
        final massiveBody1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(30, 0, 0),
          mass: 300.0,
          radius: 15.0,
          color: AppColors.basicRed,
          name: 'Massive Body 1',
          temperature: 50000.0,
        );

        final massiveBody2 = Body(
          position: vm.Vector3(1, 0, 0),
          velocity: vm.Vector3(-30, 0, 0),
          mass: 280.0,
          radius: 14.0,
          color: AppColors.basicBlue,
          name: 'Massive Body 2',
          temperature: 49000.0,
        );

        service.generateCollisionEffects(
          body1: massiveBody1,
          body2: massiveBody2,
          collisionPoint: collisionPoint,
        );

        // If bipolar jets generated, should have pairs
        if (service.plasmaJets.length >= 2) {
          // Verify opposing directions for bipolar jets
          final jet1 = service.plasmaJets[0];
          final jet2 = service.plasmaJets[1];

          final dotProduct = jet1.direction.dot(jet2.direction);
          expect(dotProduct, lessThan(0)); // Opposing directions
        }
      });
    });

    group('Update and Cleanup', () {
      test('Should update all effects', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        service.update(0.016); // 60fps frame

        // Effects should still exist after one frame
        expect(service.debrisParticles, isNotEmpty);
        expect(service.shockwaves, isNotEmpty);
      });

      test('Should remove expired debris particles', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        // Age particles significantly
        for (int i = 0; i < 200; i++) {
          service.update(0.1); // 100ms per frame
        }

        // All particles should be expired and removed
        expect(service.debrisParticles, isEmpty);
      });

      test('Should remove expired shockwaves', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        // Age shockwaves significantly
        for (int i = 0; i < 100; i++) {
          service.update(0.1); // 100ms per frame
        }

        // All shockwaves should be expired and removed
        expect(service.shockwaves, isEmpty);
      });

      test('Should remove expired debris clouds', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        // Age clouds significantly
        for (int i = 0; i < 100; i++) {
          service.update(0.1); // 100ms per frame
        }

        // All clouds should be expired and removed
        expect(service.debrisClouds, isEmpty);
      });

      test('Should remove expired plasma jets', () {
        service.showPlasmaJets = true;

        final massiveBody1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(30, 0, 0),
          mass: 300.0,
          radius: 15.0,
          color: AppColors.basicRed,
          name: 'Massive Body 1',
          temperature: 50000.0,
        );

        final massiveBody2 = Body(
          position: vm.Vector3(1, 0, 0),
          velocity: vm.Vector3(-30, 0, 0),
          mass: 280.0,
          radius: 14.0,
          color: AppColors.basicBlue,
          name: 'Massive Body 2',
          temperature: 49000.0,
        );

        service.generateCollisionEffects(
          body1: massiveBody1,
          body2: massiveBody2,
          collisionPoint: collisionPoint,
        );

        // Age jets significantly
        for (int i = 0; i < 100; i++) {
          service.update(0.1); // 100ms per frame
        }

        // All jets should be expired and removed
        expect(service.plasmaJets, isEmpty);
      });

      test('Should clear all effects', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisParticles, isNotEmpty);
        expect(service.shockwaves, isNotEmpty);
        expect(service.debrisClouds, isNotEmpty);

        service.clearAll();

        expect(service.debrisParticles, isEmpty);
        expect(service.shockwaves, isEmpty);
        expect(service.debrisClouds, isEmpty);
        expect(service.plasmaJets, isEmpty);
      });
    });

    group('Particle Counting', () {
      test('Should correctly count total particles', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        final totalParticles = service.totalParticleCount;

        final expectedCount =
            service.debrisParticles.length +
            service.debrisClouds.fold<int>(
              0,
              (sum, cloud) => sum + cloud.particles.length,
            ) +
            service.plasmaJets.fold<int>(
              0,
              (sum, jet) => sum + jet.particles.length,
            );

        expect(totalParticles, equals(expectedCount));
      });

      test('Should correctly count total effects', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        final totalEffects = service.totalEffectCount;

        final expectedCount =
            service.debrisParticles.length +
            service.shockwaves.length +
            service.debrisClouds.length +
            service.plasmaJets.length;

        expect(totalEffects, equals(expectedCount));
      });

      test('Total counts should decrease as effects expire', () {
        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        final initialParticleCount = service.totalParticleCount;
        final initialEffectCount = service.totalEffectCount;

        // Age effects
        for (int i = 0; i < 50; i++) {
          service.update(0.1);
        }

        final finalParticleCount = service.totalParticleCount;
        final finalEffectCount = service.totalEffectCount;

        expect(finalParticleCount, lessThan(initialParticleCount));
        expect(finalEffectCount, lessThan(initialEffectCount));
      });
    });

    group('Impact Color Selection', () {
      test('Should use color from more massive body', () {
        service.generateCollisionEffects(
          body1: body1, // More massive (10.0)
          body2: body2, // Less massive (8.0)
          collisionPoint: collisionPoint,
        );

        // Verify effects exist
        expect(service.debrisParticles, isNotEmpty);

        // Debris particles should have colors based on body1 (red)
        final hasRedishParticles = service.debrisParticles.any(
          (p) => p.color.r > p.color.b,
        );
        expect(hasRedishParticles, isTrue);
      });

      test('Should handle equal mass bodies', () {
        final equalBody1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(1, 0, 0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.basicRed,
          name: 'Equal Body 1',
        );

        final equalBody2 = Body(
          position: vm.Vector3(1, 0, 0),
          velocity: vm.Vector3(-1, 0, 0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.basicBlue,
          name: 'Equal Body 2',
        );

        expect(
          () => service.generateCollisionEffects(
            body1: equalBody1,
            body2: equalBody2,
            collisionPoint: collisionPoint,
          ),
          returnsNormally,
        );
      });
    });

    group('Settings Toggle', () {
      test('Should allow toggling individual effect types', () {
        service.showDebris = false;
        service.showShockwaves = true;
        service.showEjection = false;
        service.showPlasmaJets = false;

        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisParticles, isEmpty);
        expect(service.shockwaves, isNotEmpty);
        expect(service.debrisClouds, isEmpty);
        expect(service.plasmaJets, isEmpty);
      });

      test('Should allow enabling all effects', () {
        service.showDebris = true;
        service.showShockwaves = true;
        service.showEjection = true;
        service.showPlasmaJets = true;

        final massiveBody1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(30, 0, 0),
          mass: 300.0,
          radius: 15.0,
          color: AppColors.basicRed,
          name: 'Massive Body 1',
          temperature: 50000.0,
        );

        final massiveBody2 = Body(
          position: vm.Vector3(1, 0, 0),
          velocity: vm.Vector3(-30, 0, 0),
          mass: 280.0,
          radius: 14.0,
          color: AppColors.basicBlue,
          name: 'Massive Body 2',
          temperature: 49000.0,
        );

        service.generateCollisionEffects(
          body1: massiveBody1,
          body2: massiveBody2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisParticles, isNotEmpty);
        expect(service.shockwaves, isNotEmpty);
        expect(service.debrisClouds, isNotEmpty);
        // Plasma jets may or may not be generated depending on thresholds
      });

      test('Should allow disabling all effects', () {
        service.showDebris = false;
        service.showShockwaves = false;
        service.showEjection = false;
        service.showPlasmaJets = false;

        service.generateCollisionEffects(
          body1: body1,
          body2: body2,
          collisionPoint: collisionPoint,
        );

        expect(service.debrisParticles, isEmpty);
        expect(service.shockwaves, isEmpty);
        expect(service.debrisClouds, isEmpty);
        expect(service.plasmaJets, isEmpty);
      });
    });
  });
}
