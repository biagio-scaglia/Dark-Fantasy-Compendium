import 'package:flutter/material.dart';
import '../core/design_system/app_colors.dart';
import '../core/design_system/app_shadows.dart';
import '../core/design_system/app_animations.dart';
import '../core/theme/app_theme_constants.dart';
import '../core/accessibility/accessibility_helper.dart';

/// Enhanced animated card with hover, press, and focus states
/// Includes full accessibility support
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final bool enableHover;
  final bool enablePress;
  final Duration animationDuration;
  final Curve animationCurve;
  final String? semanticLabel;
  final String? semanticHint;
  final bool enableHaptic;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.enableHover = true,
    this.enablePress = true,
    this.animationDuration = AppAnimations.fast,
    this.animationCurve = AppAnimations.standard,
    this.semanticLabel,
    this.semanticHint,
    this.enableHaptic = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePress && widget.onTap != null) {
      if (widget.enableHaptic) {
        AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.lightImpact);
      }
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePress && widget.onTap != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePress && widget.onTap != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cardColor = widget.color ?? AppColors.getSurface(brightness);
    final defaultBorderRadius = BorderRadius.circular(AppThemeConstants.radius12);
    final borderRadius = widget.borderRadius ?? defaultBorderRadius;
    final defaultElevation = widget.elevation ?? 2.0;
    final effectiveElevation = _isHovered && widget.enableHover
        ? defaultElevation * 1.5
        : defaultElevation;

    Widget card = MouseRegion(
      onEnter: widget.enableHover
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.enableHover
          ? (_) => setState(() => _isHovered = false)
          : null,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? _handleTapDown : null,
        onTapUp: widget.onTap != null ? _handleTapUp : null,
        onTapCancel: widget.onTap != null ? _handleTapCancel : null,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: widget.margin ?? EdgeInsets.all(AppThemeConstants.spacing8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: borderRadius,
                  border: widget.border ??
                      Border.all(
                        color: AppColors.getBorder(brightness),
                        width: 1,
                      ),
                  boxShadow: _isHovered && widget.enableHover
                      ? AppShadows.cardShadow(context)
                      : AppShadows.shadow2,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: borderRadius,
                    splashColor: AppColors.getAccentPrimary(brightness).withOpacity(0.1),
                    highlightColor: AppColors.getAccentPrimary(brightness).withOpacity(0.05),
                    child: Padding(
                      padding: widget.padding ?? EdgeInsets.all(AppThemeConstants.spacing16),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Add accessibility
    if (widget.onTap != null) {
      card = Semantics(
        label: widget.semanticLabel,
        hint: widget.semanticHint,
        button: true,
        enabled: widget.onTap != null,
        child: card,
      );
    }

    return card;
  }
}


