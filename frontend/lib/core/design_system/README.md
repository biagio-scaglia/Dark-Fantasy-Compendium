# Design System Documentation

This directory contains the enhanced design system for the Dark Fantasy Compendium Flutter app.

## Structure

### `app_colors.dart`
Enhanced color palette with improved contrast and harmony for both light and dark modes.

**Key Features:**
- Semantic color naming (light/dark variants)
- Context-aware color helpers
- Improved contrast ratios for accessibility
- Consistent accent colors (Gold/Brown for light, Crimson/Violet for dark)

**Usage:**
```dart
// Context-aware colors
final accentColor = AppColors.getAccentPrimaryFromContext(context);
final backgroundColor = AppColors.getBackgroundFromContext(context);
final textColor = AppColors.getTextPrimaryFromContext(context);
```

### `app_typography.dart`
Typography system with improved hierarchy and responsive scaling.

**Key Features:**
- Display, Headline, Title, Body, and Label styles
- Accent text styles for highlighted content
- Context-aware text styles
- Consistent font families and weights

**Usage:**
```dart
Text(
  'Title',
  style: AppTypography.titleLarge(context),
)
```

### `app_shadows.dart`
Enhanced shadow system for depth and elevation.

**Key Features:**
- Standard shadows (shadow1, shadow2, shadow4, shadow8, shadow16)
- Glow shadows for accent elements
- Context-aware shadows (soft, card, elevated, button, appBar, bottomNav)
- Inner shadows for pressed states

**Usage:**
```dart
Container(
  decoration: BoxDecoration(
    boxShadow: AppShadows.cardShadow(context),
  ),
)
```

### `app_animations.dart`
Enhanced animation system with improved timing and curves.

**Key Features:**
- Standard durations (instant, fast, normal, medium, slow, verySlow)
- Standard curves (standard, smooth, bounce, sharp, gentle, spring)
- Page transitions (fade, slide, scale, slideUp)
- Widget animations (fadeIn, slideIn, scaleIn, fadeSlideIn, fadeScaleIn)
- Staggered animations for lists

**Usage:**
```dart
// Page transition
AppAnimations.fadeTransition(page)

// Widget animation
AppAnimations.fadeSlideIn(
  child: widget,
  duration: AppAnimations.medium,
)
```

## Design Principles

1. **Consistency**: All colors, typography, and spacing follow a consistent system
2. **Accessibility**: Improved contrast ratios and semantic color usage
3. **Responsiveness**: Adaptive spacing and typography based on screen size
4. **Performance**: Optimized animations with appropriate durations
5. **Maintainability**: Centralized design tokens for easy updates

## Migration Guide

### Colors
Replace direct color references with AppColors helpers:
```dart
// Old
Color(0xFFD4AF37)

// New
AppColors.getAccentPrimaryFromContext(context)
```

### Typography
Use AppTypography instead of Theme.of(context).textTheme:
```dart
// Old
Theme.of(context).textTheme.titleLarge

// New
AppTypography.titleLarge(context)
```

### Shadows
Use AppShadows instead of manual BoxShadow:
```dart
// Old
BoxShadow(color: Colors.black.withOpacity(0.1), ...)

// New
AppShadows.cardShadow(context)
```

### Animations
Use AppAnimations for consistent timing:
```dart
// Old
Duration(milliseconds: 300)

// New
AppAnimations.medium
```

