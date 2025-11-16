# Theme & Visual Design Prompt

You are working on Graviton's theme system and visual design. Create a cohesive space-themed aesthetic:

## Theme Structure

```dart
class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: AppColors.darkColorScheme,
    textTheme: AppTypography.textTheme,
    appBarTheme: _darkAppBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    floatingActionButtonTheme: _fabTheme,
    cardTheme: _cardTheme,
    dialogTheme: _dialogTheme,
  );
  
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: AppColors.lightColorScheme,
    textTheme: AppTypography.textTheme,
    // ... light theme variants
  );
}
```

## Color Palette

```dart
class AppColors {
  // Primary cosmic colors
  static const Color deepSpace = Color(0xFF0B0D17);
  static const Color nebulaPurple = Color(0xFF6366F1);
  static const Color starWhite = Color(0xFFFFFFFF);
  static const Color cosmicBlue = Color(0xFF3B82F6);
  static const Color galaxyPink = Color(0xFFEC4899);
  static const Color solarGold = Color(0xFFFBBF24);
  
  // Stellar classification colors
  static const Color classO = Color(0xFF9BB0FF); // Blue giants
  static const Color classB = Color(0xFFAABFFF); // Blue-white
  static const Color classA = Color(0xFFCAD7FF); // White
  static const Color classF = Color(0xFFF8F7FF); // Yellow-white
  static const Color classG = Color(0xFFFFE7A3); // Yellow (Sun)
  static const Color classK = Color(0xFFFFD2A1); // Orange
  static const Color classM = Color(0xFFFFAD51); // Red dwarf
  
  // Physics visualization
  static const Color gravitationalField = Color(0xFF3F3FFF);
  static const Color kineticEnergy = Color(0xFFFF6B6B);
  static const Color potentialEnergy = Color(0xFF4ECDC4);
  static const Color temperature = Color(0xFFFFE066);
  
  // UI semantics
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: nebulaPurple,
    onPrimary: starWhite,
    secondary: cosmicBlue,
    onSecondary: starWhite,
    tertiary: galaxyPink,
    onTertiary: starWhite,
    surface: Color(0xFF1A1B23),
    onSurface: starWhite,
    background: deepSpace,
    onBackground: starWhite,
    error: error,
    onError: starWhite,
  );
}
```

## Typography System

**CRITICAL**: Always use AppTypography constants - never magic numbers!

```dart
// ✅ CORRECT: Using AppTypography for all dimensions and styling
class CosmicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;
  
  const CosmicButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTypography.spacingLarge,
        vertical: AppTypography.spacingMedium,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            buttonColor,
            buttonColor.withValues(alpha: AppTypography.opacityHigh),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withValues(alpha: AppTypography.opacityFaint),
            blurRadius: AppTypography.spacingSmall,
            offset: Offset(0, AppTypography.spacingXSmall),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppTypography.iconSizeMedium, // Use AppTypography!
            ),
            SizedBox(width: AppTypography.spacingSmall),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: AppTypography.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppColors.starWhite.withValues(
                alpha: AppTypography.opacityFull,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ❌ WRONG: Magic numbers everywhere
Container(
  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Use AppTypography!
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0), // Use AppTypography.radiusLarge!
    color: Colors.blue.withOpacity(0.8), // Use AppTypography.opacityHigh!
  ),
  child: Text(
    'Button',
    style: TextStyle(fontSize: 14.0), // Use AppTypography.fontSizeMedium!
  ),
)
```

## Component Themes

```dart
class ComponentThemes {
  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.deepSpace,
    foregroundColor: AppColors.starWhite,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.textTheme.headlineMedium,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  static final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.nebulaPurple,
      foregroundColor: AppColors.starWhite,
      elevation: 2,
      shadowColor: AppColors.nebulaPurple.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  );
  
  static final FloatingActionButtonThemeData fabTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.cosmicBlue,
    foregroundColor: AppColors.starWhite,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
  
  static final CardTheme cardTheme = CardTheme(
    color: AppColors.deepSpace.withOpacity(0.7),
    shadowColor: AppColors.nebulaPurple.withOpacity(0.2),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: AppColors.nebulaPurple.withOpacity(0.3),
        width: 1,
      ),
    ),
  );
}
```

## Custom Widgets with Theme

```dart
class CosmicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;
  
  const CosmicButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            buttonColor,
            buttonColor.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Physics Visualization Styles

```dart
class PhysicsVisualizationStyles {
  // Trail styles based on body type
  static Paint getTrailPaint(BodyType type, double alpha) {
    Color color;
    switch (type) {
      case BodyType.star:
        color = AppColors.solarGold;
        break;
      case BodyType.planet:
        color = AppColors.cosmicBlue;
        break;
      case BodyType.moon:
        color = AppColors.starWhite;
        break;
      case BodyType.asteroid:
        color = AppColors.warning;
        break;
    }
    
    return Paint()
      ..color = color.withOpacity(alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
  }
  
  // Body glow effects
  static Paint getBodyGlowPaint(Color bodyColor, double intensity) {
    return Paint()
      ..color = bodyColor.withOpacity(0.3 * intensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 * intensity)
      ..style = PaintingStyle.fill;
  }
  
  // Force vector visualization
  static Paint get forceVectorPaint => Paint()
    ..color = AppColors.gravitationalField.withOpacity(0.8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;
}
```

## Responsive Design

```dart
class ResponsiveBreakpoints {
  static const double mobileMax = 600;
  static const double tabletMax = 1200;
  static const double desktopMin = 1201;
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobileMax;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobileMax && width <= tabletMax;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > tabletMax;
  }
}

// Responsive layout helper
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
```

## Animation Curves & Durations

```dart
class AppAnimations {
  // Duration constants
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration cosmic = Duration(milliseconds: 800);
  
  // Custom curves for space-like motion
  static const Curve orbital = Curves.easeInOutCubic;
  static const Curve gravity = Curves.easeInQuart;
  static const Curve escape = Curves.easeOutCubic;
  static const Curve collision = Curves.elasticOut;
  
  // Physics-based spring simulation
  static SpringSimulation createOrbitSpring({
    required double displacement,
    required double velocity,
  }) {
    return SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 100.0,
        ratio: 0.8,
      ),
      0.0,
      displacement,
      velocity,
    );
  }
}
```

## Dark Mode & Accessibility

```dart
class AccessibleTheme {
  static ThemeData getHighContrastTheme(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppTheme.darkTheme.copyWith(
            colorScheme: AppColors.darkColorScheme.copyWith(
              primary: Colors.cyan,
              onSurface: Colors.white,
              surface: Colors.black,
            ),
          )
        : AppTheme.lightTheme.copyWith(
            colorScheme: AppColors.lightColorScheme.copyWith(
              primary: Colors.blue[900]!,
              onSurface: Colors.black,
              surface: Colors.white,
            ),
          );
  }
  
  static bool shouldUseHighContrast(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }
}
```

## File Locations

- Theme configuration: `lib/theme/app_theme.dart`
- Color definitions: `lib/theme/app_colors.dart`
- Typography: `lib/theme/app_typography.dart`
- Custom widgets: `lib/widgets/themed/`
- Responsive utils: `lib/utils/responsive_utils.dart`