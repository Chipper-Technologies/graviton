# Performance Optimization Prompt

You are working on Graviton's performance optimization. Target 60fps with complex physics simulations:

## Performance Targets

- **60 FPS**: Consistent framerate with up to 50 bodies
- **Memory**: <100MB RAM usage during normal operation
- **Startup**: <3 seconds cold start time
- **Battery**: Minimal battery drain during long simulations

## Physics Optimization

```dart
// Efficient N-body calculation with spatial optimization
class OptimizedSimulation {
  List<Body> _bodies = [];
  QuadTree _spatialIndex = QuadTree();
  
  void updatePhysics(double deltaTime) {
    // Rebuild spatial index periodically
    if (_frameCount % 10 == 0) {
      _rebuildSpatialIndex();
    }
    
    // Parallel force calculations
    final forces = List.generate(_bodies.length, (i) => Vector3.zero());
    
    for (int i = 0; i < _bodies.length; i++) {
      final nearbyBodies = _spatialIndex.queryRadius(_bodies[i].position, 50.0);
      
      for (final other in nearbyBodies) {
        if (other != _bodies[i]) {
          forces[i] += calculateGravitationalForce(_bodies[i], other);
        }
      }
    }
    
    // Update velocities and positions
    for (int i = 0; i < _bodies.length; i++) {
      _bodies[i].velocity += forces[i] * (deltaTime / _bodies[i].mass);
      _bodies[i].position += _bodies[i].velocity * deltaTime;
    }
  }
}
```

## Rendering Optimization

```dart
class HighPerformanceSpacePainter extends CustomPainter {
  // Cache expensive objects
  static final Paint _bodyPaint = Paint();
  static final Paint _trailPaint = Paint()..style = PaintingStyle.stroke;
  static final Path _reusablePath = Path();
  
  @override
  void paint(Canvas canvas, Size size) {
    // Early return if nothing to draw
    if (bodies.isEmpty) return;
    
    // Frustum culling - only draw visible objects
    final visibleBodies = bodies.where((body) {
      final screenPos = project3DTo2D(body.position, camera, size);
      return screenPos.dx >= -100 && screenPos.dx <= size.width + 100 &&
             screenPos.dy >= -100 && screenPos.dy <= size.height + 100;
    }).toList();
    
    // Level of detail based on distance
    for (final body in visibleBodies) {
      final screenPos = project3DTo2D(body.position, camera, size);
      final distance = (body.position - camera.target).length;
      
      if (distance < 20) {
        _drawDetailedBody(canvas, body, screenPos);
      } else {
        _drawSimpleBody(canvas, body, screenPos);
      }
    }
    
    // Batch trail rendering
    _drawTrailsBatched(canvas, size);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Only repaint if actually changed
    return oldDelegate is! HighPerformanceSpacePainter ||
           bodies.length != oldDelegate.bodies.length ||
           camera != oldDelegate.camera;
  }
}
```

## Memory Management

```dart
class TrailManager {
  final Map<int, CircularBuffer<TrailPoint>> _trails = {};
  
  void addTrailPoint(int bodyId, TrailPoint point) {
    _trails.putIfAbsent(
      bodyId, 
      () => CircularBuffer<TrailPoint>(SimulationConstants.maxTrailPoints),
    ).add(point);
  }
  
  void cleanupOldTrails() {
    _trails.removeWhere((id, trail) {
      // Remove empty trails
      return trail.isEmpty;
    });
    
    // Limit total trail points across all bodies
    final totalPoints = _trails.values
        .map((trail) => trail.length)
        .fold(0, (sum, length) => sum + length);
    
    if (totalPoints > SimulationConstants.maxTrailPoints * 10) {
      _reduceTrailDensity();
    }
  }
  
  void _reduceTrailDensity() {
    // Keep every 2nd point to reduce memory usage
    for (final trail in _trails.values) {
      final reducedPoints = <TrailPoint>[];
      for (int i = 0; i < trail.length; i += 2) {
        reducedPoints.add(trail[i]);
      }
      trail.clear();
      trail.addAll(reducedPoints);
    }
  }
}
```

## Async Operations

```dart
class BackgroundPhysicsService {
  Isolate? _physicsIsolate;
  SendPort? _sendPort;
  
  Future<void> startBackgroundPhysics() async {
    final receivePort = ReceivePort();
    
    _physicsIsolate = await Isolate.spawn(
      _physicsIsolateEntry,
      receivePort.sendPort,
    );
    
    _sendPort = await receivePort.first as SendPort;
  }
  
  void updatePhysicsAsync(List<Body> bodies, double deltaTime) {
    _sendPort?.send({
      'bodies': bodies.map((b) => b.toJson()).toList(),
      'deltaTime': deltaTime,
    });
  }
  
  static void _physicsIsolateEntry(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((message) {
      final Map<String, dynamic> data = message;
      
      // Perform physics calculations in background
      final bodies = (data['bodies'] as List)
          .map((json) => Body.fromJson(json))
          .toList();
      
      final deltaTime = data['deltaTime'] as double;
      
      // Calculate forces and update positions
      // ... physics calculations ...
      
      // Send results back to main isolate
      sendPort.send({
        'updatedBodies': bodies.map((b) => b.toJson()).toList(),
      });
    });
  }
}
```

## Profiling & Monitoring

```dart
class PerformanceMonitor {
  static final Stopwatch _frameTimer = Stopwatch();
  static final List<Duration> _frameTimes = [];
  static int _frameCount = 0;
  
  static void startFrame() {
    _frameTimer.reset();
    _frameTimer.start();
  }
  
  static void endFrame() {
    _frameTimer.stop();
    _frameTimes.add(_frameTimer.elapsed);
    _frameCount++;
    
    // Keep only last 60 frames
    if (_frameTimes.length > 60) {
      _frameTimes.removeAt(0);
    }
    
    // Log performance warnings
    if (_frameTimer.elapsed.inMilliseconds > 16) {
      debugPrint('Frame took ${_frameTimer.elapsed.inMilliseconds}ms (dropped frame)');
    }
    
    // Report FPS every second
    if (_frameCount % 60 == 0) {
      final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
      final fps = 1000 / avgFrameTime.inMilliseconds;
      debugPrint('Average FPS: ${fps.toStringAsFixed(1)}');
    }
  }
}
```

## Build Optimizations

```yaml
# pubspec.yaml optimizations
flutter:
  uses-material-design: true
  
  # Enable tree-shaking and minification
  build-tools:
    tree-shaking: true
    minify: true
```

## Performance Testing

```dart
void main() {
  group('Performance Tests', () {
    test('simulation maintains 60fps with 50 bodies', () {
      final simulation = Simulation();
      
      // Add 50 bodies
      for (int i = 0; i < 50; i++) {
        simulation.addBody(Body.randomStar());
      }
      
      final stopwatch = Stopwatch()..start();
      const targetFrameTime = Duration(milliseconds: 16); // 60fps
      
      // Simulate 60 frames
      for (int frame = 0; frame < 60; frame++) {
        final frameStart = stopwatch.elapsed;
        
        simulation.updatePhysics(1.0 / 60.0);
        
        final frameTime = stopwatch.elapsed - frameStart;
        expect(frameTime.inMilliseconds, lessThan(16));
      }
    });
    
    test('memory usage stays under 100MB', () {
      // Memory profiling test
      final simulation = Simulation();
      
      for (int i = 0; i < 100; i++) {
        simulation.addBody(Body.randomStar());
      }
      
      // Run for extended period
      for (int i = 0; i < 10000; i++) {
        simulation.updatePhysics(0.016);
      }
      
      // Check memory usage (implementation depends on platform)
      expect(getCurrentMemoryUsage(), lessThan(100 * 1024 * 1024)); // 100MB
    });
  });
}
```

## File Locations

- Performance monitoring: `lib/utils/performance_monitor.dart`
- Optimized rendering: `lib/painters/`
- Background physics: `lib/services/background_physics_service.dart`
- Spatial indexing: `lib/utils/quad_tree.dart`