import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Accessibility helper utilities
class AccessibilityHelper {
  /// Minimum tap target size (48dp)
  static const double minTapTargetSize = 48.0;

  /// Provide haptic feedback
  static void hapticFeedback({
    HapticFeedbackType type = HapticFeedbackType.lightImpact,
  }) {
    switch (type) {
      case HapticFeedbackType.lightImpact:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.mediumImpact:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavyImpact:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selectionClick:
        HapticFeedback.selectionClick();
        break;
      case HapticFeedbackType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }

  /// Ensure minimum tap target size
  static Widget ensureMinTapTarget(Widget child, {double? minSize}) {
    final size = minSize ?? minTapTargetSize;
    return SizedBox(
      width: size,
      height: size,
      child: Center(child: child),
    );
  }

  /// Get semantic label for screen readers
  static String? getSemanticLabel(String? label) {
    return label?.isEmpty ?? true ? null : label;
  }

  /// Check if text scaling is enabled
  static bool isTextScalingEnabled(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.textScaler != TextScaler.linear(1.0);
  }

  /// Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Ensure text scales between 80% and 200%
  static TextScaler clampTextScaler(TextScaler scaler) {
    final scale = scaler.scale(1.0);
    final clampedScale = scale.clamp(0.8, 2.0);
    return TextScaler.linear(clampedScale);
  }
}

enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}

/// Accessible button wrapper
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? semanticHint;
  final HapticFeedbackType? hapticType;
  final double? minTapTargetSize;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
    this.semanticHint,
    this.hapticType,
    this.minTapTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: onPressed != null,
      child: InkWell(
        onTap: onPressed != null
            ? () {
                if (hapticType != null) {
                  AccessibilityHelper.hapticFeedback(type: hapticType!);
                }
                onPressed!();
              }
            : null,
        child: child,
      ),
    );

    if (minTapTargetSize != null) {
      button = AccessibilityHelper.ensureMinTapTarget(button, minSize: minTapTargetSize);
    }

    return button;
  }
}

/// Accessible card wrapper
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final String? semanticHint;

  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.semanticHint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: onTap != null,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}


