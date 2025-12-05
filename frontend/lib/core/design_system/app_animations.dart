import 'package:flutter/material.dart';

/// Enhanced animation system with improved timing and curves
class AppAnimations {
  AppAnimations._();

  // ========== Durations ==========
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Legacy compatibility
  static const Duration shortDuration = fast;
  static const Duration mediumDuration = medium;
  static const Duration longDuration = slow;

  // ========== Curves ==========
  static const Curve standard = Curves.easeOutCubic;
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve bounce = Curves.elasticOut;
  static const Curve sharp = Curves.easeOut;
  static const Curve gentle = Curves.easeInOut;
  static const Curve spring = Curves.easeOutBack;

  // Legacy compatibility
  static const Curve standardCurve = standard;
  static const Curve smoothCurve = smooth;
  static const Curve bounceCurve = bounce;

  // ========== Page Transitions ==========
  static PageRouteBuilder fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: standard,
          ),
          child: child,
        );
      },
      transitionDuration: medium,
      reverseTransitionDuration: fast,
    );
  }

  static PageRouteBuilder slideTransition(
    Widget page, {
    bool fromRight = true,
    bool fade = true,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = fromRight ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
        final slideAnimation = SlideTransition(
          position: Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: standard,
          )),
          child: child,
        );

        if (fade) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: standard,
            ),
            child: slideAnimation,
          );
        }
        return slideAnimation;
      },
      transitionDuration: medium,
      reverseTransitionDuration: fast,
    );
  }

  static PageRouteBuilder scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.9,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: spring,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: standard,
            ),
            child: child,
          ),
        );
      },
      transitionDuration: medium,
      reverseTransitionDuration: fast,
    );
  }

  static PageRouteBuilder slideUpTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: smooth,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: standard,
            ),
            child: child,
          ),
        );
      },
      transitionDuration: slow,
      reverseTransitionDuration: fast,
    );
  }

  // ========== Widget Animations ==========
  
  static Widget fadeIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = standard,
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

  static Widget slideIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = standard,
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

  static Widget scaleIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = spring,
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

  static Widget fadeSlideIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = standard,
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
            offset: Offset(
              beginOffset.dx * (1 - value),
              beginOffset.dy * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget fadeScaleIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = spring,
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

  // Staggered Animation for Lists
  static Widget staggered({
    required List<Widget> children,
    Duration staggerDuration = const Duration(milliseconds: 100),
    Duration itemDuration = medium,
    Curve curve = standard,
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

  // Pulse Animation
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
}


