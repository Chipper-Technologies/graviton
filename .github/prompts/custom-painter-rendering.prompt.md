# Custom Painter & Rendering Prompt

You are working on Graviton's rendering system using Flutter's CustomPainter. Focus on performance and visual quality:

## Performance Guidelines

1. **Avoid Expensive Operations**: No complex calculations in `paint()` method
2. **Cache Objects**: Reuse Paint objects and paths when possible
3. **Selective Repainting**: Override `shouldRepaint()` intelligently
4. **Trail Management**: Limit trail points using `SimulationConstants.maxTrailPoints`

## Rendering Patterns

```dart
class SpacePainter extends CustomPainter {
  final List<Body> bodies;
  final Map<int, List<TrailPoint>> trails;
  final CameraPosition cameraPosition;
  
  // Cache expensive objects
  final Paint _bodyPaint = Paint();
  final Paint _trailPaint = Paint()..style = PaintingStyle.stroke;
  
  SpacePainter({
    required this.bodies,
    required this.trails,
    required this.cameraPosition,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Transform coordinate system
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(cameraPosition.zoom);
    
    // Draw trails first (background)
    _drawTrails(canvas, size);
    
    // Draw bodies (foreground)
    _drawBodies(canvas, size);
  }
  
  // ✅ CORRECT: Using AppTypography constants and extracted utilities
  void _drawBodies(Canvas canvas, Size size) {
    for (final body in bodies) {
      final screenPos = RenderingUtils.project3DTo2D(
        body.position, 
        cameraPosition, 
        size,
      );
      
      // Use constants for all dimensions
      final radius = math.max(
        body.radius * cameraPosition.zoom,
        RenderingConstants.minimumBodySize, // No magic numbers!
      );
      
      _bodyPaint.color = body.color.withValues(
        alpha: AppTypography.opacityHigh, // Use AppTypography!
      );
      
      canvas.drawCircle(screenPos, radius, _bodyPaint);
    }
  }
  
  @override
  bool shouldRepaint(SpacePainter oldDelegate) {
    return bodies != oldDelegate.bodies ||
           trails != oldDelegate.trails ||
           cameraPosition != oldDelegate.cameraPosition;
  }
}
```

## 3D Coordinate Transformation

**Extract to utility file - no private utilities in classes:**

```dart
// ✅ CORRECT: In lib/utils/rendering_utils.dart
class RenderingUtils {
  /// Project 3D world coordinates to 2D screen coordinates
  /// 
  /// Uses perspective projection with camera transformations.
  /// Returns off-screen coordinates for points behind camera.
  static Offset project3DTo2D(
    Vector3 position, 
    CameraPosition camera, 
    Size size,
  ) {
    // Apply camera transformations
    final transformed = MathUtils.applyRotation(
      position - camera.target, 
      camera.rotation,
    );
    
    // Perspective projection
    final distance = transformed.z + camera.distance;
    if (distance <= RenderingConstants.nearClipPlane) {
      return const Offset(-1000, -1000); // Behind camera
    }
    
    final scale = RenderingConstants.focalLength / distance;
    
    return Offset(
      transformed.x * scale * camera.zoom,
      transformed.y * scale * camera.zoom,
    );
  }
}
```

## Trail Rendering

```dart
void _drawTrails(Canvas canvas, Size size) {
  for (final trail in trails.values) {
    if (trail.length < 2) continue;
    
    final path = Path();
    bool first = true;
    
    for (int i = 0; i < trail.length; i++) {
      final point = trail[i];
      final screenPos = project3DTo2D(point.position, cameraPosition, size);
      
      // Skip points behind camera or too far
      if (screenPos.dx < -1000) continue;
      
      if (first) {
        path.moveTo(screenPos.dx, screenPos.dy);
        first = false;
      } else {
        path.lineTo(screenPos.dx, screenPos.dy);
      }
    }
    
    // Apply fading alpha based on trail age
    _trailPaint.color = Colors.white.withOpacity(0.6);
    canvas.drawPath(path, _trailPaint);
  }
}
```

## Best Practices

1. **Memory Management**: Clear old trail points regularly
2. **Clipping**: Use `canvas.clipRect()` for performance
3. **LOD**: Implement level-of-detail for distant objects
4. **Color Management**: Use `StellarColorService` for realistic stellar colors
5. **Accessibility**: Provide semantic descriptions for visual elements

## File Locations

- Painters: `lib/painters/`
- Rendering services: `lib/services/stellar_color_service.dart`
- Models: `lib/models/trail_point.dart`, `lib/models/camera_position.dart`