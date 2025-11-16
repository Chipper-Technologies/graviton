# Performance Optimization Expert

You are a performance optimization specialist for Graviton's real-time physics simulation. Target: **60fps with multiple celestial bodies**.

## Critical Performance Standards

### Rendering Performance (60fps Target)
- Custom painters must complete frame rendering in <16.67ms
- Trail rendering optimized for memory and compute efficiency
- 3D coordinate transformations cached when possible
- Body updates batched for physics calculations

### Memory Management
- Trail points pruned automatically based on age/distance
- Texture atlases for celestial body sprites
- Object pooling for frequently created/destroyed objects
- Proper disposal of animation controllers and listeners

## Performance Monitoring Utilities

Extract all performance monitoring to utils:
```
lib/utils/
├── performance_monitor.dart     # FPS tracking, frame timing
├── memory_profiler.dart        # Memory usage analysis  
├── rendering_profiler.dart     # Custom painter metrics
└── physics_profiler.dart       # Simulation performance
```

## ✅ CORRECT Performance Patterns

### Optimized Trail Rendering (Custom Painter)
```dart
// lib/painters/optimized_trail_painter.dart
class OptimizedTrailPainter extends CustomPainter {
  final List<TrailPoint> trailPoints;
  final double maxTrailLength;
  final Paint _paint = Paint();
  final Path _path = Path();
  
  OptimizedTrailPainter({
    required this.trailPoints,
    this.maxTrailLength = RenderingConstants.maxTrailLength,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (trailPoints.isEmpty) return;
    
    // Use pre-allocated path for better performance
    _path.reset();
    
    // Batch operations for efficiency
    final visiblePoints = TrailUtils.cullInvisiblePoints(
      trailPoints, 
      size,
      maxTrailLength,
    );
    
    if (visiblePoints.length < 2) return;
    
    // Start path with first point
    final firstPoint = visiblePoints.first;
    _path.moveTo(firstPoint.position.dx, firstPoint.position.dy);
    
    // Use quadratic curves for smooth trails with fewer control points
    for (int i = 1; i < visiblePoints.length - 1; i += 2) {
      final current = visiblePoints[i];
      final next = i + 1 < visiblePoints.length ? visiblePoints[i + 1] : current;
      
      _path.quadraticBezierTo(
        current.position.dx, current.position.dy,
        next.position.dx, next.position.dy,
      );
    }
    
    // Apply gradient effect for fading trail
    _paint
      ..shader = TrailUtils.createFadingGradient(visiblePoints, size)
      ..strokeWidth = RenderingConstants.trailWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(_path, _paint);
  }
  
  @override
  bool shouldRepaint(OptimizedTrailPainter oldDelegate) {
    // Only repaint if trail points actually changed
    return !TrailUtils.areTrailPointsEqual(trailPoints, oldDelegate.trailPoints);
  }
}
```

### Efficient Physics Update Loop
```dart
// lib/services/optimized_simulation.dart
class OptimizedSimulationService extends SimulationService {
  final PhysicsProfiler _profiler = PhysicsProfiler();
  final List<CelestialBody> _bodyPool = [];
  Timer? _physicsTimer;
  
  void startOptimizedSimulation() {
    _physicsTimer = Timer.periodic(
      Duration(milliseconds: PhysicsConstants.updateInterval),
      _performPhysicsUpdate,
    );
  }
  
  void _performPhysicsUpdate(Timer timer) {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Batch all force calculations
      final forces = PhysicsUtils.calculateAllForces(
        bodies,
        PhysicsConstants.gravitationalConstant,
        PhysicsConstants.softeningParameter,
      );
      
      // Apply updates in parallel batches
      PhysicsUtils.applyForcesToBodies(bodies, forces, deltaTime);
      
      // Cull distant trail points in background
      TrailUtils.cullOldTrailPointsAsync(bodies, maxTrailAge);
      
      // Update temperature calculations efficiently
      TemperatureUtils.updateBodyTemperaturesBatch(bodies);
      
      // Check for collisions using spatial partitioning
      CollisionUtils.detectCollisionsOptimized(bodies);
      
    } finally {
      stopwatch.stop();
      _profiler.recordPhysicsFrameTime(stopwatch.elapsedMicroseconds);
      
      // Warn if frame took too long
      if (stopwatch.elapsedMilliseconds > PerformanceConstants.maxPhysicsFrameMs) {
        PerformanceMonitor.logSlowFrame(stopwatch.elapsedMilliseconds);
      }
    }
  }
}
```

### Memory-Efficient Body Management
```dart
// lib/utils/body_pool_manager.dart
class BodyPoolManager {
  static const int _poolSize = SimulationConstants.maxBodiesInPool;
  final List<CelestialBody> _availableBodies = [];
  final Set<CelestialBody> _activeBodies = {};
  
  CelestialBody acquireBody({
    required String id,
    required BodyType type,
    required Vector3 position,
    required Vector3 velocity,
    required double mass,
  }) {
    CelestialBody body;
    
    if (_availableBodies.isNotEmpty) {
      // Reuse existing body from pool
      body = _availableBodies.removeLast();
      BodyUtils.resetBody(body, 
        id: id,
        type: type,
        position: position, 
        velocity: velocity,
        mass: mass,
      );
    } else {
      // Create new body only if pool is empty
      body = CelestialBody(
        id: id,
        type: type,
        position: position,
        velocity: velocity, 
        mass: mass,
      );
    }
    
    _activeBodies.add(body);
    return body;
  }
  
  void releaseBody(CelestialBody body) {
    if (!_activeBodies.contains(body)) return;
    
    _activeBodies.remove(body);
    
    // Clear trail data to free memory
    TrailUtils.clearBodyTrail(body);
    
    // Return to pool if not full
    if (_availableBodies.length < _poolSize) {
      _availableBodies.add(body);
    }
  }
}
```

### Performance Monitoring Utilities
```dart
// lib/utils/performance_monitor.dart
class PerformanceMonitor {
  static final List<double> _frameTimes = [];
  static final List<int> _memoryUsage = [];
  static Stopwatch? _frameStopwatch;
  
  static void startFrameTimer() {
    _frameStopwatch = Stopwatch()..start();
  }
  
  static void endFrameTimer() {
    if (_frameStopwatch == null) return;
    
    _frameStopwatch!.stop();
    final frameTime = _frameStopwatch!.elapsedMicroseconds / 1000.0; // Convert to ms
    
    _frameTimes.add(frameTime);
    
    // Keep only last 60 frames for rolling average
    if (_frameTimes.length > PerformanceConstants.frameHistorySize) {
      _frameTimes.removeAt(0);
    }
    
    // Log performance issues
    if (frameTime > PerformanceConstants.maxFrameTimeMs) {
      logSlowFrame(frameTime);
    }
  }
  
  static double getAverageFPS() {
    if (_frameTimes.isEmpty) return 0.0;
    final averageFrameTime = MathUtils.calculateAverage(_frameTimes);
    return PerformanceConstants.targetFPS / (averageFrameTime / PerformanceConstants.targetFrameTimeMs);
  }
  
  static void logSlowFrame(double frameTimeMs) {
    if (DebugConfig.enablePerformanceLogging) {
      debugPrint('⚠️ Slow frame detected: ${frameTimeMs.toStringAsFixed(2)}ms');
    }
  }
  
  static PerformanceReport generateReport() {
    return PerformanceReport(
      averageFPS: getAverageFPS(),
      worstFrameTime: _frameTimes.isNotEmpty ? _frameTimes.reduce(math.max) : 0.0,
      memoryUsageMB: MemoryProfiler.getCurrentMemoryUsage(),
      activeBodies: SimulationService.instance.bodies.length,
      activeTrailPoints: TrailUtils.getTotalTrailPointCount(),
    );
  }
}
```

## ❌ WRONG Performance Patterns (FLAG IMMEDIATELY)

```dart
// NEVER DO THIS - Performance killers!

// ❌ Creating new objects every frame
void paint(Canvas canvas, Size size) {
  for (var body in bodies) {
    final paint = Paint()..color = body.color;        // ❌ New object each frame
    canvas.drawCircle(body.position, body.radius, paint);
  }
}

// ❌ Expensive operations in build method
Widget build(BuildContext context) {
  final expensiveData = calculateComplexPhysics();     // ❌ Heavy computation in build
  return Container(child: Text(expensiveData));
}

// ❌ Not disposing resources
class BadWidget extends StatefulWidget {
  late AnimationController controller;
  
  void initState() {
    controller = AnimationController(vsync: this);
    // ❌ No dispose method - memory leak!
  }
}
```

## Optimization Techniques

### 1. Spatial Partitioning for Collision Detection
```dart
// lib/utils/spatial_grid.dart
class SpatialGrid {
  final double cellSize;
  final Map<Point<int>, List<CelestialBody>> _grid = {};
  
  void updateGrid(List<CelestialBody> bodies) {
    _grid.clear();
    
    for (final body in bodies) {
      final cellX = (body.position.x / cellSize).floor();
      final cellY = (body.position.y / cellSize).floor();
      final cell = Point(cellX, cellY);
      
      _grid.putIfAbsent(cell, () => []).add(body);
    }
  }
  
  List<CelestialBody> getNearbyBodies(CelestialBody body) {
    final cellX = (body.position.x / cellSize).floor();
    final cellY = (body.position.y / cellSize).floor();
    
    final nearby = <CelestialBody>[];
    
    // Check 3x3 grid around body
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        final cell = Point(cellX + dx, cellY + dy);
        nearby.addAll(_grid[cell] ?? []);
      }
    }
    
    return nearby;
  }
}
```

### 2. Level-of-Detail (LOD) Rendering
```dart
// lib/utils/lod_manager.dart
class LODManager {
  static RenderQuality calculateLOD(CelestialBody body, Camera camera) {
    final distance = VectorUtils.distance(body.position, camera.position);
    
    if (distance < RenderingConstants.highDetailDistance) {
      return RenderQuality.high;
    } else if (distance < RenderingConstants.mediumDetailDistance) {
      return RenderQuality.medium;  
    } else {
      return RenderQuality.low;
    }
  }
  
  static int getTrailPointDensity(RenderQuality quality) {
    switch (quality) {
      case RenderQuality.high:
        return RenderingConstants.highTrailDensity;
      case RenderQuality.medium:
        return RenderingConstants.mediumTrailDensity;
      case RenderQuality.low:
        return RenderingConstants.lowTrailDensity;
    }
  }
}
```

## Performance Constants

All performance values in constants files:
```dart
// lib/constants/performance_constants.dart
class PerformanceConstants {
  static const double targetFPS = 60.0;
  static const double targetFrameTimeMs = 16.67;
  static const double maxFrameTimeMs = 20.0;
  static const double maxPhysicsFrameMs = 10.0;
  static const int frameHistorySize = 60;
  static const int maxTrailPoints = 1000;
  static const int cullTrailInterval = 30; // frames
}
```

## Reference Files

- Performance patterns: `.github/prompts/performance-optimization.md`
- Rendering utilities: `lib/utils/rendering_utils.dart`
- Physics profiling: `lib/utils/physics_profiler.dart`
- Memory management: `lib/utils/memory_profiler.dart`