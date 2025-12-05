// Re-export from new design system for backward compatibility
export '../design_system/app_animations.dart' show AppAnimations;

import 'package:flutter/material.dart';
import '../design_system/app_animations.dart' as new_animations;

// Legacy compatibility - redirect to new system
class AppAnimations {
  // Durata standard delle animazioni
  static const Duration shortDuration = new_animations.AppAnimations.fast;
  static const Duration mediumDuration = new_animations.AppAnimations.medium;
  static const Duration longDuration = new_animations.AppAnimations.slow;

  // Curve standard
  static const Curve standardCurve = new_animations.AppAnimations.standard;
  static const Curve bounceCurve = new_animations.AppAnimations.bounce;
  static const Curve smoothCurve = new_animations.AppAnimations.smooth;

  // Fade In Animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = mediumDuration,
    Curve curve = standardCurve,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide Animation
  static Widget slideIn({
    required Widget child,
    Duration duration = mediumDuration,
    Curve curve = standardCurve,
    Offset offset = const Offset(0, 30),
    bool fromTop = false,
    bool fromLeft = false,
    bool fromRight = false,
    bool fromBottom = true,
  }) {
    Offset beginOffset;
    if (fromTop) {
      beginOffset = Offset(0, -offset.dy);
    } else if (fromLeft) {
      beginOffset = Offset(-offset.dx, 0);
    } else if (fromRight) {
      beginOffset = Offset(offset.dx, 0);
    } else {
      beginOffset = offset;
    }

    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: beginOffset, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Scale Animation
  static Widget scaleIn({
    required Widget child,
    Duration duration = mediumDuration,
    Curve curve = standardCurve,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Combined Fade + Slide Animation
  static Widget fadeSlideIn({
    required Widget child,
    Duration duration = mediumDuration,
    Curve curve = standardCurve,
    Offset offset = const Offset(0, 30),
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
    Duration delay = Duration.zero,
    bool fromTop = false,
    bool fromLeft = false,
    bool fromRight = false,
    bool fromBottom = true,
  }) {
    Offset beginOffset;
    if (fromTop) {
      beginOffset = Offset(0, -offset.dy);
    } else if (fromLeft) {
      beginOffset = Offset(-offset.dx, 0);
    } else if (fromRight) {
      beginOffset = Offset(offset.dx, 0);
    } else {
      beginOffset = offset;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: Interval(
        delay.inMilliseconds / (duration + delay).inMilliseconds,
        1.0,
        curve: curve,
      ),
      builder: (context, value, child) {
        return Opacity(
          opacity: beginOpacity + (endOpacity - beginOpacity) * value,
          child: Transform.translate(
            offset: Offset(beginOffset.dx * (1 - value), beginOffset.dy * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Combined Fade + Scale Animation
  static Widget fadeScaleIn({
    required Widget child,
    Duration duration = mediumDuration,
    Curve curve = standardCurve,
    double beginScale = 0.8,
    double endScale = 1.0,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: Interval(
        delay.inMilliseconds / (duration + delay).inMilliseconds,
        1.0,
        curve: curve,
      ),
      builder: (context, value, child) {
        return Opacity(
          opacity: beginOpacity + (endOpacity - beginOpacity) * value,
          child: Transform.scale(
            scale: beginScale + (endScale - beginScale) * value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Staggered Animation Builder
  static Widget staggered({
    required List<Widget> children,
    Duration staggerDuration = const Duration(milliseconds: 100),
    Duration itemDuration = mediumDuration,
    Curve curve = standardCurve,
    Widget Function(Widget child, int index)? builder,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final delay = staggerDuration * index;
        
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: itemDuration + delay,
          curve: Interval(
            delay.inMilliseconds / (itemDuration + delay).inMilliseconds,
            1.0,
            curve: curve,
          ),
          builder: (context, value, child) {
            // child is guaranteed to be non-null since we pass it explicitly
            final nonNullChild = child ?? const SizedBox.shrink();
            if (builder != null) {
              return builder(nonNullChild, index);
            }
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: nonNullChild,
              ),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  // Pulse Animation (for loading states or highlights)
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: minScale, end: maxScale),
      duration: duration,
      curve: Curves.easeInOut,
      onEnd: () {
        // This will be handled by the parent if needed
      },
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Shimmer Effect (for loading placeholders)
  static Widget shimmer({
    required Widget child,
    Color baseColor = const Color(0xFF3D2818),
    Color highlightColor = const Color(0xFFD4AF37),
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [baseColor, highlightColor.withOpacity(0.3), baseColor],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

// Custom Page Transitions
class CustomPageTransitions {
  static PageRouteBuilder fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: AppAnimations.mediumDuration,
    );
  }

  static PageRouteBuilder slideTransition(Widget page, {bool fromRight = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = fromRight ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
        return SlideTransition(
          position: Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AppAnimations.standardCurve,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: AppAnimations.mediumDuration,
    );
  }

  static PageRouteBuilder scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AppAnimations.standardCurve,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: AppAnimations.mediumDuration,
    );
  }

  static PageRouteBuilder medievalTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AppAnimations.smoothCurve,
          )),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AppAnimations.standardCurve,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: AppAnimations.longDuration,
    );
  }
}


