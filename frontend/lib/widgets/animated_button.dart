import 'package:flutter/material.dart';
import '../core/design_system/app_colors.dart';
import '../core/design_system/app_shadows.dart';
import '../core/design_system/app_animations.dart';
import '../core/theme/app_theme_constants.dart';
import '../core/accessibility/accessibility_helper.dart';

/// Enhanced animated button with hover, press, and focus states
/// Includes full accessibility support
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool enableHover;
  final bool enablePress;
  final Duration animationDuration;
  final Curve animationCurve;
  final String? semanticLabel;
  final String? semanticHint;
  final bool enableHaptic;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.enableHover = true,
    this.enablePress = true,
    this.animationDuration = AppAnimations.fast,
    this.animationCurve = AppAnimations.standard,
    this.semanticLabel,
    this.semanticHint,
    this.enableHaptic = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    if (widget.enablePress && widget.onPressed != null) {
      if (widget.enableHaptic) {
        AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.lightImpact);
      }
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePress && widget.onPressed != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePress && widget.onPressed != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget button = MouseRegion(
      onEnter: widget.enableHover
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.enableHover
          ? (_) => setState(() => _isHovered = false)
          : null,
      child: GestureDetector(
        onTapDown: widget.onPressed != null ? _handleTapDown : null,
        onTapUp: widget.onPressed != null ? _handleTapUp : null,
        onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );

    // Add accessibility
    button = Semantics(
      label: widget.semanticLabel,
      hint: widget.semanticHint,
      button: true,
      enabled: widget.onPressed != null,
      child: button,
    );

    // Ensure minimum tap target size
    return AccessibilityHelper.ensureMinTapTarget(button);
  }
}

/// Enhanced Elevated Button with animations
/// Includes full accessibility support
class AnimatedElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final String? semanticHint;
  final bool enableHaptic;

  const AnimatedElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.semanticHint,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = backgroundColor ?? AppColors.getAccentPrimary(brightness);
    final fgColor = foregroundColor ?? Colors.white;

    return AnimatedButton(
      onPressed: onPressed,
      semanticLabel: label,
      semanticHint: semanticHint,
      enableHaptic: enableHaptic,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: AppThemeConstants.spacing24,
              vertical: AppThemeConstants.spacing12,
            ),
        decoration: BoxDecoration(
          color: onPressed == null
              ? bgColor.withOpacity(0.3)
              : bgColor,
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          boxShadow: onPressed == null
              ? []
              : AppShadows.buttonShadow(context),
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: fgColor, size: 20),
              SizedBox(width: AppThemeConstants.spacing8),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: fgColor,
                    fontWeight: AppThemeConstants.fontWeightMedium,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}


