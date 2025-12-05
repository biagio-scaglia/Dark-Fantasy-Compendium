import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../theme/app_theme_constants.dart';

/// Enhanced shadow system for depth and elevation
class AppShadows {
  AppShadows._();

  // Standard Shadows
  static List<BoxShadow> get shadow1 {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 4,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> get shadow2 {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.12),
        blurRadius: 8,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> get shadow4 {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 16,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> get shadow8 {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.18),
        blurRadius: 24,
        offset: const Offset(0, 12),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> get shadow16 {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.20),
        blurRadius: 32,
        offset: const Offset(0, 16),
        spreadRadius: 0,
      ),
    ];
  }

  // Glow Shadows (for accent elements)
  static List<BoxShadow> glowShadow(Color color, {double intensity = 0.4}) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity * 0.5),
        blurRadius: AppThemeConstants.glowBlurRadius * 2,
        spreadRadius: AppThemeConstants.glowSpreadRadius,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: AppThemeConstants.glowBlurRadius,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
    ];
  }

  static List<BoxShadow> glowShadowFromContext(BuildContext context, {double intensity = 0.4}) {
    final color = AppColors.getAccentPrimaryGlow(Theme.of(context).brightness);
    return glowShadow(color, intensity: intensity);
  }

  // Soft Shadows (subtle depth)
  static List<BoxShadow> softShadow(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return [
      BoxShadow(
        color: brightness == Brightness.light
            ? Colors.black.withOpacity(0.06)
            : Colors.black.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  // Card Shadow
  static List<BoxShadow> cardShadow(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return [
      BoxShadow(
        color: brightness == Brightness.light
            ? Colors.black.withOpacity(0.10)
            : Colors.black.withOpacity(0.4),
        blurRadius: 16,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  // Elevated Shadow (for floating elements)
  static List<BoxShadow> elevatedShadow(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return [
      BoxShadow(
        color: brightness == Brightness.light
            ? Colors.black.withOpacity(0.12)
            : Colors.black.withOpacity(0.5),
        blurRadius: 24,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ];
  }

  // Inner Shadow (for pressed states)
  static List<BoxShadow> innerShadow(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return [
      BoxShadow(
        color: brightness == Brightness.light
            ? Colors.black.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
        spreadRadius: -2,
      ),
    ];
  }

  // Button Shadow (interactive)
  static List<BoxShadow> buttonShadow(BuildContext context, {bool isPressed = false}) {
    if (isPressed) {
      return shadow1;
    }
    final brightness = Theme.of(context).brightness;
    return [
      BoxShadow(
        color: brightness == Brightness.light
            ? Colors.black.withOpacity(0.15)
            : Colors.black.withOpacity(0.4),
        blurRadius: 12,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  // AppBar Shadow
  static List<BoxShadow> appBarShadow(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return [
      BoxShadow(
        color: brightness == Brightness.light
            ? Colors.black.withOpacity(0.08)
            : Colors.black.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ];
  }

  // Bottom Navigation Shadow
  static List<BoxShadow> bottomNavShadow(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final accentColor = AppColors.getAccentPrimary(brightness);
    return [
      BoxShadow(
        color: brightness == Brightness.light
            ? Colors.black.withOpacity(0.1)
            : Colors.black.withOpacity(0.4),
        blurRadius: 16,
        offset: const Offset(0, -2),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: accentColor.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, -1),
        spreadRadius: 0,
      ),
    ];
  }
}


