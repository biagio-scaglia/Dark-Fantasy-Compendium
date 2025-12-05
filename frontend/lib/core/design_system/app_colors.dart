import 'package:flutter/material.dart';

/// Enhanced color palette with improved contrast and harmony
class AppColors {
  AppColors._();

  // ========== Light Mode Colors ==========
  
  // Backgrounds
  static const Color lightBackground = Color(0xFFF8F6F2);
  static const Color lightSurface = Color(0xFFFFFEFB);
  static const Color lightSurfaceVariant = Color(0xFFF5F2ED);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);
  
  // Text
  static const Color lightTextPrimary = Color(0xFF1C1B18);
  static const Color lightTextSecondary = Color(0xFF4A4843);
  static const Color lightTextTertiary = Color(0xFF6B6964);
  static const Color lightTextDisabled = Color(0xFF9B9994);
  
  // Borders & Dividers
  static const Color lightBorder = Color(0xFFE0DDD6);
  static const Color lightDivider = Color(0xFFE8E5DE);
  static const Color lightBorderSubtle = Color(0xFFF0EDE6);
  
  // Accent Colors - Gold/Brown (Light Mode)
  static const Color lightGold = Color(0xFFD4AF37);
  static const Color lightGoldVariant = Color(0xFFC9A961);
  static const Color lightGoldLight = Color(0xFFE8D47A);
  static const Color lightGoldDark = Color(0xFFB8941F);
  
  static const Color lightBrown = Color(0xFF8B6F47);
  static const Color lightBrownVariant = Color(0xFF6F5637);
  static const Color lightBrownLight = Color(0xFFA6895F);
  static const Color lightBrownDark = Color(0xFF5A4428);
  
  // Legacy Crimson/Violet (kept for compatibility)
  static const Color lightCrimson = Color(0xFF8B1538);
  static const Color lightCrimsonVariant = Color(0xFFA01D42);
  static const Color lightViolet = Color(0xFF6B2C91);
  static const Color lightVioletVariant = Color(0xFF7D3AA3);
  
  // Additional
  static const Color lightArcaneBlue = Color(0xFF4A7FB8);
  static const Color lightIronGray = Color(0xFF5A5A5A);
  static const Color lightParchment = Color(0xFFF9F6F0);
  
  // ========== Dark Mode Colors ==========
  
  // Backgrounds
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF252525);
  static const Color darkSurfaceElevated = Color(0xFF2A2A2A);
  
  // Text
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFCCCCCC);
  static const Color darkTextTertiary = Color(0xFF999999);
  static const Color darkTextDisabled = Color(0xFF666666);
  
  // Borders & Dividers
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color darkBorderSubtle = Color(0xFF2F2F2F);
  
  // Accent Colors - Crimson/Violet (Dark Mode)
  static const Color darkCrimson = Color(0xFFC41E3A);
  static const Color darkCrimsonGlow = Color(0xFFE63950);
  static const Color darkCrimsonLight = Color(0xFFE85A6F);
  static const Color darkCrimsonDark = Color(0xFFA01A2F);
  
  static const Color darkViolet = Color(0xFF8B4FC7);
  static const Color darkVioletGlow = Color(0xFFA66DD9);
  static const Color darkVioletLight = Color(0xFFB885E5);
  static const Color darkVioletDark = Color(0xFF6B3A9E);
  
  // Additional
  static const Color darkArcaneBlue = Color(0xFF4A90E2);
  static const Color darkIronGray = Color(0xFF3A3A3A);
  static const Color darkObsidian = Color(0xFF151515);
  
  // ========== Semantic Colors ==========
  
  // Error
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color errorDark = Color(0xFFFF5449);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color errorContainerDark = Color(0xFF93000A);
  
  // Success
  static const Color successLight = Color(0xFF2E7D32);
  static const Color successDark = Color(0xFF4CAF50);
  static const Color successContainerLight = Color(0xFFC8E6C9);
  static const Color successContainerDark = Color(0xFF1B5E20);
  
  // Warning
  static const Color warningLight = Color(0xFFF57C00);
  static const Color warningDark = Color(0xFFFF9800);
  static const Color warningContainerLight = Color(0xFFFFE0B2);
  static const Color warningContainerDark = Color(0xFFE65100);
  
  // Info
  static const Color infoLight = Color(0xFF1976D2);
  static const Color infoDark = Color(0xFF2196F3);
  static const Color infoContainerLight = Color(0xFFBBDEFB);
  static const Color infoContainerDark = Color(0xFF0D47A1);
  
  // ========== Helper Methods ==========
  
  static Color getAccentPrimary(Brightness brightness) {
    return brightness == Brightness.light ? lightGold : darkCrimson;
  }
  
  static Color getAccentPrimaryGlow(Brightness brightness) {
    return brightness == Brightness.light ? lightGoldLight : darkCrimsonGlow;
  }
  
  static Color getAccentSecondary(Brightness brightness) {
    return brightness == Brightness.light ? lightBrown : darkViolet;
  }
  
  static Color getAccentSecondaryGlow(Brightness brightness) {
    return brightness == Brightness.light ? lightBrownLight : darkVioletGlow;
  }
  
  static Color getBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }
  
  static Color getSurface(Brightness brightness) {
    return brightness == Brightness.light ? lightSurface : darkSurface;
  }
  
  static Color getSurfaceVariant(Brightness brightness) {
    return brightness == Brightness.light ? lightSurfaceVariant : darkSurfaceVariant;
  }
  
  static Color getTextPrimary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }
  
  static Color getTextSecondary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextSecondary : darkTextSecondary;
  }
  
  static Color getTextTertiary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextTertiary : darkTextTertiary;
  }
  
  static Color getBorder(Brightness brightness) {
    return brightness == Brightness.light ? lightBorder : darkBorder;
  }
  
  static Color getDivider(Brightness brightness) {
    return brightness == Brightness.light ? lightDivider : darkDivider;
  }
  
  // Context-based helpers
  static Color getAccentPrimaryFromContext(BuildContext context) {
    return getAccentPrimary(Theme.of(context).brightness);
  }
  
  static Color getAccentPrimaryGlowFromContext(BuildContext context) {
    return getAccentPrimaryGlow(Theme.of(context).brightness);
  }
  
  static Color getAccentSecondaryFromContext(BuildContext context) {
    return getAccentSecondary(Theme.of(context).brightness);
  }
  
  static Color getAccentSecondaryGlowFromContext(BuildContext context) {
    return getAccentSecondaryGlow(Theme.of(context).brightness);
  }
  
  static Color getBackgroundFromContext(BuildContext context) {
    return getBackground(Theme.of(context).brightness);
  }
  
  static Color getSurfaceFromContext(BuildContext context) {
    return getSurface(Theme.of(context).brightness);
  }
  
  static Color getSurfaceVariantFromContext(BuildContext context) {
    return getSurfaceVariant(Theme.of(context).brightness);
  }
  
  static Color getTextPrimaryFromContext(BuildContext context) {
    return getTextPrimary(Theme.of(context).brightness);
  }
  
  static Color getTextSecondaryFromContext(BuildContext context) {
    return getTextSecondary(Theme.of(context).brightness);
  }
  
  static Color getTextTertiaryFromContext(BuildContext context) {
    return getTextTertiary(Theme.of(context).brightness);
  }
  
  static Color getBorderFromContext(BuildContext context) {
    return getBorder(Theme.of(context).brightness);
  }
  
  static Color getDividerFromContext(BuildContext context) {
    return getDivider(Theme.of(context).brightness);
  }
}


