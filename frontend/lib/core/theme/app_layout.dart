import 'package:flutter/material.dart';
import 'app_theme_constants.dart';

enum BreakpointType {
  small,
  medium,
  large,
}

class AppLayout {
  AppLayout._();

  static BreakpointType getBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppThemeConstants.smallBreakpoint) {
      return BreakpointType.small;
    } else if (width < AppThemeConstants.mediumBreakpoint) {
      return BreakpointType.medium;
    } else {
      return BreakpointType.large;
    }
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3);
  }

  static EdgeInsets safeAreaInsets(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static double safeAreaTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double safeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double safeAreaLeft(BuildContext context) {
    return MediaQuery.of(context).padding.left;
  }

  static double safeAreaRight(BuildContext context) {
    return MediaQuery.of(context).padding.right;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final breakpoint = getBreakpoint(context);
    final basePadding = breakpoint == BreakpointType.small
        ? AppThemeConstants.spacing16
        : AppThemeConstants.spacing24;
    final safeArea = safeAreaInsets(context);
    return EdgeInsets.only(
      left: basePadding + safeArea.left,
      right: basePadding + safeArea.right,
      top: basePadding + safeArea.top,
      bottom: basePadding + safeArea.bottom,
    );
  }

  static EdgeInsets horizontalPadding(BuildContext context) {
    final breakpoint = getBreakpoint(context);
    final basePadding = breakpoint == BreakpointType.small
        ? AppThemeConstants.spacing16
        : AppThemeConstants.spacing24;
    final safeArea = safeAreaInsets(context);
    return EdgeInsets.only(
      left: basePadding + safeArea.left,
      right: basePadding + safeArea.right,
    );
  }

  static EdgeInsets verticalPadding(BuildContext context) {
    final basePadding = AppThemeConstants.spacing16;
    final safeArea = safeAreaInsets(context);
    return EdgeInsets.only(
      top: basePadding + safeArea.top,
      bottom: basePadding + safeArea.bottom,
    );
  }

  static double cardPadding(BuildContext context) {
    final breakpoint = getBreakpoint(context);
    return breakpoint == BreakpointType.small
        ? AppThemeConstants.spacing12
        : AppThemeConstants.spacing16;
  }

  static int gridColumnCount(BuildContext context) {
    final breakpoint = getBreakpoint(context);
    switch (breakpoint) {
      case BreakpointType.small:
        return 1;
      case BreakpointType.medium:
        return 2;
      case BreakpointType.large:
        return 3;
    }
  }

  static double responsiveFontSize(
    BuildContext context,
    double baseSize,
  ) {
    final breakpoint = getBreakpoint(context);
    final scaleFactor = textScaleFactor(context);
    double multiplier = 1.0;
    switch (breakpoint) {
      case BreakpointType.small:
        multiplier = 0.9;
        break;
      case BreakpointType.medium:
        multiplier = 1.0;
        break;
      case BreakpointType.large:
        multiplier = 1.1;
        break;
    }
    return baseSize * multiplier * scaleFactor;
  }

  static double responsiveSpacing(
    BuildContext context,
    double baseSpacing,
  ) {
    final breakpoint = getBreakpoint(context);
    double multiplier = 1.0;
    switch (breakpoint) {
      case BreakpointType.small:
        multiplier = 0.85;
        break;
      case BreakpointType.medium:
        multiplier = 1.0;
        break;
      case BreakpointType.large:
        multiplier = 1.15;
        break;
    }
    return baseSpacing * multiplier;
  }

  static double buttonHeight(BuildContext context) {
    return AppThemeConstants.minTapTargetSize;
  }

  static bool isSmallDevice(BuildContext context) {
    return getBreakpoint(context) == BreakpointType.small;
  }

  static bool isMediumDevice(BuildContext context) {
    return getBreakpoint(context) == BreakpointType.medium;
  }

  static bool isLargeDevice(BuildContext context) {
    return getBreakpoint(context) == BreakpointType.large;
  }
}


