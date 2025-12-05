import 'package:flutter/material.dart';
import '../theme/app_theme_constants.dart';
import 'app_colors.dart';

/// Enhanced typography system with improved hierarchy
class AppTypography {
  AppTypography._();

  // Display Styles (Large Headlines)
  static TextStyle displayLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize48,
      fontWeight: AppThemeConstants.fontWeightBold,
      letterSpacing: AppThemeConstants.letterSpacingTight,
      height: AppThemeConstants.lineHeightTight,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize40,
      fontWeight: AppThemeConstants.fontWeightBold,
      letterSpacing: AppThemeConstants.letterSpacingTight,
      height: AppThemeConstants.lineHeightTight,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize36,
      fontWeight: AppThemeConstants.fontWeightBold,
      letterSpacing: AppThemeConstants.letterSpacingTight,
      height: AppThemeConstants.lineHeightTight,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  // Headline Styles (Section Titles)
  static TextStyle headlineLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize32,
      fontWeight: AppThemeConstants.fontWeightSemiBold,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize28,
      fontWeight: AppThemeConstants.fontWeightSemiBold,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize24,
      fontWeight: AppThemeConstants.fontWeightSemiBold,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  // Title Styles (Card Titles, List Headers)
  static TextStyle titleLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize20,
      fontWeight: AppThemeConstants.fontWeightSemiBold,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize18,
      fontWeight: AppThemeConstants.fontWeightMedium,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize16,
      fontWeight: AppThemeConstants.fontWeightMedium,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  // Body Styles (Main Content)
  static TextStyle bodyLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize16,
      fontWeight: AppThemeConstants.fontWeightRegular,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightRelaxed,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize14,
      fontWeight: AppThemeConstants.fontWeightRegular,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightRelaxed,
      color: AppColors.getTextSecondary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize12,
      fontWeight: AppThemeConstants.fontWeightRegular,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextTertiary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  // Label Styles (Buttons, Chips, Tags)
  static TextStyle labelLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize14,
      fontWeight: AppThemeConstants.fontWeightMedium,
      letterSpacing: AppThemeConstants.letterSpacingWide,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize12,
      fontWeight: AppThemeConstants.fontWeightMedium,
      letterSpacing: AppThemeConstants.letterSpacingWide,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextSecondary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize10,
      fontWeight: AppThemeConstants.fontWeightMedium,
      letterSpacing: AppThemeConstants.letterSpacingWide,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getTextTertiary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  // Accent Styles (Highlighted Text)
  static TextStyle accentLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize20,
      fontWeight: AppThemeConstants.fontWeightSemiBold,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getAccentPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle accentMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize16,
      fontWeight: AppThemeConstants.fontWeightMedium,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getAccentPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }

  static TextStyle accentSmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: AppThemeConstants.fontSize14,
      fontWeight: AppThemeConstants.fontWeightMedium,
      letterSpacing: AppThemeConstants.letterSpacingNormal,
      height: AppThemeConstants.lineHeightNormal,
      color: AppColors.getAccentPrimary(brightness),
      fontFamily: AppThemeConstants.fontFamilyPrimary,
    );
  }
}


