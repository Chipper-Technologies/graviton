import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show GlobalKey;
import 'package:flutter/rendering.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/models/physics/physics_settings.dart';
import 'package:graviton/models/security/play_integrity_exception.dart';
import 'package:graviton/features/auth/data/auth_service.dart';
import 'package:graviton/services/platform/play_integrity_backend_service.dart';
import 'package:graviton/services/platform/play_integrity_service.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for sharing simulation states and screenshots
///
/// Provides functionality to:
/// - Capture current simulation viewport as image
/// - Export simulation state as importable JSON
/// - Share via native platform share dialogs
/// - Save to device storage
class SimulationShareService {
  SimulationShareService._();
  static final SimulationShareService instance = SimulationShareService._();

  /// Share current simulation state as JSON
  ///
  /// Returns true if share was successful, false otherwise
  Future<bool> shareSimulationState({
    required SimulationState simulationState,
    String? customName,
    String? subject,
    String? text,
  }) async {
    try {
      // Verify device integrity before sharing (Android only, prevents fraudulent scenarios)
      await _verifyDeviceIntegrityForShare();

      final jsonData = await exportSimulationStateToJson(
        simulationState: simulationState,
        customName: customName,
      );

      final fileName = _generateFileName(
        customName ?? 'graviton_simulation',
        'json',
      );

      // For web, we can't save to temp file, so share the text directly
      if (kIsWeb) {
        // On web, copy to clipboard or trigger download
        // For now, we'll return false as web sharing needs different implementation
        return false;
      }

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonData);

      // Share the file
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          subject: subject,
          text: text,
        ),
      );

      unawaited(
        Future.delayed(const Duration(seconds: 5), () async {
          try {
            if (await file.exists()) {
              await file.delete();
            }
          } catch (e) {
            debugPrint('Failed to delete temp file: $e');
          }
        }),
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Failed to share simulation state: $e');
      return false;
    }
  }

  /// Share simulation viewport as image
  ///
  /// Captures the current rendering and shares as PNG
  /// Returns true if share was successful, false otherwise
  Future<bool> shareSimulationImage({
    required GlobalKey repaintBoundaryKey,
    String? customName,
    String? subject,
    String? text,
  }) async {
    try {
      final imageBytes = await captureSimulationImage(repaintBoundaryKey);
      if (imageBytes == null) {
        return false;
      }

      final fileName = _generateFileName(
        customName ?? 'graviton_snapshot',
        'png',
      );

      // For web, handle differently
      if (kIsWeb) {
        // Web sharing needs different implementation
        return false;
      }

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      // Share the file
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          subject: subject,
          text: text,
        ),
      );

      unawaited(
        Future.delayed(const Duration(seconds: 5), () async {
          try {
            if (await file.exists()) {
              await file.delete();
            }
          } catch (e) {
            debugPrint('Failed to delete temp file: $e');
          }
        }),
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Failed to share simulation image: $e');
      return false;
    }
  }

  /// Export current simulation state to JSON string
  ///
  /// Creates a complete snapshot that can be imported later
  Future<String> exportSimulationStateToJson({
    required SimulationState simulationState,
    String? customName,
  }) async {
    final sim = simulationState.simulation;

    final Map<String, dynamic> exportData = {
      'version': '1.0.0',
      'timestamp': DateTime.now().toIso8601String(),
      'name': customName ?? 'Shared Simulation',
      'scenarioType': sim.currentScenario.name,
      'physics': {
        'gravitationalConstant': sim.gravitationalConstant,
        'softening': sim.softening,
        'collisionRadiusMultiplier': sim.collisionRadiusMultiplier,
        'maxTrailPoints': sim.maxTrail,
        'trailFadeRate': SimulationConstants.trailFadeRate,
        'vibrationThrottleTime': SimulationConstants.vibrationThrottleTime,
        'vibrationEnabled': true, // Default value
      },
      'simulation': {
        'timeScale': simulationState.timeScale,
        'totalTime': simulationState.totalTime,
        'stepCount': simulationState.stepCount,
      },
      'bodies': sim.bodies.map((body) => _serializeBody(body)).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Import simulation state from JSON string
  ///
  /// Returns a map containing the imported data, or null if import failed
  Future<Map<String, dynamic>?> importSimulationStateFromJson(
    String jsonString,
  ) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate required fields
      if (!data.containsKey('version') ||
          !data.containsKey('bodies') ||
          !data.containsKey('physics')) {
        debugPrint('Invalid simulation state JSON: missing required fields');
        return null;
      }

      return data;
    } catch (e) {
      debugPrint('Failed to parse simulation state JSON: $e');
      return null;
    }
  }

  /// Capture simulation viewport as PNG image
  ///
  /// Returns image bytes or null if capture failed
  Future<Uint8List?> captureSimulationImage(
    GlobalKey repaintBoundaryKey,
  ) async {
    try {
      final boundary =
          repaintBoundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('Failed to capture image: boundary is null');
        return null;
      }

      // Capture at 2x resolution for better quality
      final image = await boundary.toImage(pixelRatio: 2.0);

      // Create a new image with black background to ensure no transparency
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(image.width.toDouble(), image.height.toDouble());

      // Fill with opaque black background
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = AppColors.backgroundBlack,
      );

      // Draw captured image on top
      canvas.drawImage(image, Offset.zero, Paint());

      // Convert to image
      final picture = recorder.endRecording();
      final finalImage = await picture.toImage(image.width, image.height);
      final byteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Failed to capture simulation image: $e');
      return null;
    }
  }

  /// Save simulation state to local file
  ///
  /// Returns the file path if successful, null otherwise
  Future<String?> saveSimulationStateToFile({
    required SimulationState simulationState,
    String? customName,
    String? directoryPath,
  }) async {
    try {
      final jsonData = await exportSimulationStateToJson(
        simulationState: simulationState,
        customName: customName,
      );

      final fileName = _generateFileName(
        customName ?? 'graviton_simulation',
        'json',
      );

      // Determine save directory
      Directory saveDir;
      if (directoryPath != null) {
        saveDir = Directory(directoryPath);
      } else if (kIsWeb) {
        // Web doesn't have local file system
        return null;
      } else {
        saveDir = await getApplicationDocumentsDirectory();
      }

      final file = File('${saveDir.path}/$fileName');
      await file.writeAsString(jsonData);

      return file.path;
    } catch (e) {
      debugPrint('Failed to save simulation state to file: $e');
      return null;
    }
  }

  /// Save simulation image to local file
  ///
  /// Returns the file path if successful, null otherwise
  Future<String?> saveSimulationImageToFile({
    required GlobalKey repaintBoundaryKey,
    String? customName,
    String? directoryPath,
  }) async {
    try {
      final imageBytes = await captureSimulationImage(repaintBoundaryKey);
      if (imageBytes == null) {
        return null;
      }

      final fileName = _generateFileName(
        customName ?? 'graviton_snapshot',
        'png',
      );

      // Determine save directory
      Directory saveDir;
      if (directoryPath != null) {
        saveDir = Directory(directoryPath);
      } else if (kIsWeb) {
        // Web doesn't have local file system
        return null;
      } else {
        saveDir = await getApplicationDocumentsDirectory();
      }

      final file = File('${saveDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      return file.path;
    } catch (e) {
      debugPrint('Failed to save simulation image to file: $e');
      return null;
    }
  }

  /// Generate a unique filename with timestamp
  String _generateFileName(String baseName, String extension) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sanitizedName = baseName.replaceAll(RegExp(r'[^\w\s-]'), '');
    return '${sanitizedName}_$timestamp.$extension';
  }

  /// Serialize a Body to JSON format
  Map<String, dynamic> _serializeBody(Body body) {
    return {
      'name': body.name,
      'mass': body.mass,
      'radius': body.radius,
      'position': {
        'x': body.position.x,
        'y': body.position.y,
        'z': body.position.z,
      },
      'velocity': {
        'x': body.velocity.x,
        'y': body.velocity.y,
        'z': body.velocity.z,
      },
      'color': body.color.toARGB32(),
    };
  }

  /// Deserialize a Body from JSON format
  Body deserializeBody(Map<String, dynamic> json) {
    final position = json['position'] as Map<String, dynamic>;
    final velocity = json['velocity'] as Map<String, dynamic>;

    return Body(
      name: json['name'] as String,
      mass: (json['mass'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
      position: vm.Vector3(
        (position['x'] as num).toDouble(),
        (position['y'] as num).toDouble(),
        (position['z'] as num).toDouble(),
      ),
      velocity: vm.Vector3(
        (velocity['x'] as num).toDouble(),
        (velocity['y'] as num).toDouble(),
        (velocity['z'] as num).toDouble(),
      ),
      color: ui.Color(json['color'] as int),
    );
  }

  /// Verify device integrity before sharing (Android only)
  ///
  /// This helps prevent sharing of fraudulent or tampered simulation data.
  /// Silently succeeds on non-Android platforms or if verification fails.
  Future<void> _verifyDeviceIntegrityForShare() async {
    try {
      final integrityService = PlayIntegrityService();
      final backendService = PlayIntegrityBackendService.instance;
      final user = await AuthService.instance.getCurrentUserProfile();
      final userId = user?.uid ?? 'anonymous';

      // Determine package name based on flavor
      final packageName = FlavorConfig.instance.getPackageName();

      // Use enforcement-aware verification with backend callback
      await integrityService.verifyWithEnforcement(
        operationId: 'share_simulation',
        userId: userId,
        verifyTokenCallback: (token) async {
          return await backendService.verifyToken(
            token: token,
            packageName: packageName,
          );
        },
      );
    } catch (e) {
      // If it's an enforcement exception, rethrow to block operation
      if (e is IntegrityVerificationFailedException) {
        if (kDebugMode) {
          debugPrint(
            'SimulationShare: Integrity verification blocked share operation',
          );
        }
        rethrow;
      }

      // For other errors, log but don't block (backward compatibility)
      if (kDebugMode) {
        debugPrint('SimulationShare: Integrity verification error: $e');
      }
    }
  }

  /// Create PhysicsSettings from imported JSON data
  PhysicsSettings createPhysicsSettingsFromJson(Map<String, dynamic> json) {
    final physicsData = json['physics'] as Map<String, dynamic>;

    return PhysicsSettings(
      gravitationalConstant: (physicsData['gravitationalConstant'] as num)
          .toDouble(),
      softening: (physicsData['softening'] as num).toDouble(),
      collisionRadiusMultiplier:
          (physicsData['collisionRadiusMultiplier'] as num).toDouble(),
      maxTrailPoints: physicsData['maxTrailPoints'] as int,
      trailFadeRate: (physicsData['trailFadeRate'] as num?)?.toDouble() ?? 0.5,
      vibrationThrottleTime:
          (physicsData['vibrationThrottleTime'] as num?)?.toDouble() ?? 0.18,
      vibrationEnabled: physicsData['vibrationEnabled'] as bool? ?? true,
    );
  }

  /// Extract bodies list from imported JSON data
  List<Body> extractBodiesFromJson(Map<String, dynamic> json) {
    final bodiesData = json['bodies'] as List<dynamic>;
    return bodiesData
        .map((bodyJson) => deserializeBody(bodyJson as Map<String, dynamic>))
        .toList();
  }

  /// Extract scenario type from imported JSON data
  ScenarioType? extractScenarioTypeFromJson(Map<String, dynamic> json) {
    try {
      final scenarioName = json['scenarioType'] as String;
      return ScenarioType.values.firstWhere(
        (type) => type.name == scenarioName,
        orElse: () => ScenarioType.random,
      );
    } catch (e) {
      debugPrint('Failed to extract scenario type: $e');
      return null;
    }
  }
}
