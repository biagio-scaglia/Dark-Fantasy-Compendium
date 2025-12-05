import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_theme.dart';

/// Base path for all SVG icons
const String _iconsBasePath = 'assets/icons/';

/// Widget to load and display SVG icons with custom colors
/// Automatically supports Light and Dark mode with theme-appropriate colors
class SvgIconWidget extends StatelessWidget {
  /// Relative path to the icon inside assets/icons/
  /// Example: "sword.svg" or "shield.svg"
  final String iconPath;
  
  /// Icon size (width and height)
  final double? size;
  
  /// Custom color (optional). If null, uses theme color
  final Color? color;
  
  /// If true, automatically applies theme color based on Light/Dark mode
  final bool useThemeColor;
  
  final BoxFit fit;
  final Color? backgroundColor;
  final double? padding;
  final List<BoxShadow>? shadows;
  
  /// Full path of placeholder icon to use in case of error
  final String? placeholderPath;

  SvgIconWidget({
    super.key,
    String? iconPath,
    String? assetPath, // Backward compatibility
    this.size,
    this.color,
    this.useThemeColor = true,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
    this.shadows,
    this.placeholderPath,
  }) : iconPath = _resolveIconPath(iconPath, assetPath),
        assert(iconPath != null || assetPath != null, 'Either iconPath or assetPath must be provided');

  /// Constructor that accepts full path (for backward compatibility)
  SvgIconWidget.fromFullPath({
    super.key,
    required String assetPath,
    this.size,
    this.color,
    this.useThemeColor = true,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
    this.shadows,
    this.placeholderPath,
  }) : iconPath = assetPath.startsWith(_iconsBasePath)
          ? assetPath.substring(_iconsBasePath.length)
          : assetPath.startsWith('icons/')
            ? assetPath.substring('icons/'.length)
            : assetPath.startsWith('assets/icons/')
              ? assetPath.substring('assets/icons/'.length)
              : assetPath;

  /// Helper method to resolve icon path from either iconPath or assetPath
  /// Returns a relative path (without assets/icons/ prefix) that can be used with _fullAssetPath
  static String _resolveIconPath(String? iconPath, String? assetPath) {
    String? pathToResolve = iconPath ?? assetPath;
    if (pathToResolve == null) {
      throw ArgumentError('Either iconPath or assetPath must be provided');
    }
    
    // If path starts with assets/icons/, remove prefix to get relative path
    if (pathToResolve.startsWith(_iconsBasePath)) {
      return pathToResolve.substring(_iconsBasePath.length);
    }
    
    // If it starts with icons/, convert to relative path (remove icons/ prefix)
    if (pathToResolve.startsWith('icons/')) {
      return pathToResolve.substring('icons/'.length);
    }
    
    // Se inizia con assets/ ma non con assets/icons/, è un path completo diverso
    // Restituiscilo così com'è (sarà gestito da _fullAssetPath)
    if (pathToResolve.startsWith('assets/')) {
      return pathToResolve;
    }
    
    // Otherwise it's a relative path (e.g: "sword.svg"), return it as is
    return pathToResolve;
  }

  /// Builds the full icon path
  /// In Flutter, if pubspec.yaml has "- assets/icons/", we need to pass "assets/icons/..." to SvgPicture.asset()
  String get _fullAssetPath {
    // If iconPath already starts with assets/icons/, it's already correct
    if (iconPath.startsWith(_iconsBasePath)) {
      return iconPath;
    }
    // If it starts with icons/, convert to assets/icons/
    if (iconPath.startsWith('icons/')) {
      return iconPath.replaceFirst('icons/', 'assets/icons/');
    }
    // If it starts with assets/icons/icons/, fix it
    if (iconPath.startsWith('assets/icons/icons/')) {
      return iconPath.replaceFirst('assets/icons/icons/', 'assets/icons/');
    }
    // If it starts with assets/ but not with assets/icons/, it's a different full path
    // Return it as is (will be handled by SvgPicture.asset)
    if (iconPath.startsWith('assets/')) {
      return iconPath;
    }
    // Altrimenti è un path relativo (es: "sword.svg"), aggiungi il prefisso assets/icons/
    return '$_iconsBasePath$iconPath';
  }

  /// Ottiene il colore appropriato in base al tema
  Color? _getThemeColor(BuildContext context) {
    if (color != null) return color;
    
    if (!useThemeColor) return null;
    
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? AppTheme.lightTextPrimary
        : AppTheme.darkTextPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor(context);
    final fullPath = _fullAssetPath;
    
    // Debug: print to see the built path
    // print('SvgIconWidget: iconPath=$iconPath, fullPath=$fullPath');

    Widget iconWidget = _SvgIconWithErrorHandling(
      assetPath: fullPath,
      size: size,
      colorFilter: themeColor != null
          ? ColorFilter.mode(themeColor, BlendMode.srcIn)
          : null,
      fit: fit,
      placeholderBuilder: (context) => _buildLoadingPlaceholder(context),
      errorPlaceholder: _buildErrorPlaceholder(context),
    );

    if (backgroundColor != null || padding != null || shadows != null) {
      return Container(
        padding: padding != null ? EdgeInsets.all(padding!) : null,
        decoration: backgroundColor != null || shadows != null
            ? BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: shadows,
              )
            : null,
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  /// Costruisce il widget placeholder durante il caricamento
  Widget _buildLoadingPlaceholder(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.lightSurfaceVariant
            : AppTheme.darkSurfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: SizedBox(
          width: (size ?? 24) * 0.5,
          height: (size ?? 24) * 0.5,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: brightness == Brightness.light
                ? AppTheme.lightTextTertiary
                : AppTheme.darkTextTertiary,
          ),
        ),
      ),
    );
  }

  /// Costruisce il widget placeholder in caso di errore
  Widget _buildErrorPlaceholder(BuildContext context) {
    final themeColor = _getThemeColor(context);
    final brightness = Theme.of(context).brightness;
    
    // Se anche il placeholder fallisce, mostra un'icona Material
    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.lightSurfaceVariant
            : AppTheme.darkSurfaceVariant,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: brightness == Brightness.light
              ? AppTheme.lightBorder
              : AppTheme.darkBorder,
          width: 1,
        ),
      ),
      child: Icon(
        Icons.image_not_supported,
        size: (size ?? 24) * 0.6,
        color: themeColor ?? (brightness == Brightness.light
            ? AppTheme.lightTextTertiary
            : AppTheme.darkTextTertiary),
      ),
    );
  }
}

/// Internal widget that handles SVG loading errors gracefully
class _SvgIconWithErrorHandling extends StatelessWidget {
  final String assetPath;
  final double? size;
  final ColorFilter? colorFilter;
  final BoxFit fit;
  final Widget Function(BuildContext)? placeholderBuilder;
  final Widget errorPlaceholder;

  const _SvgIconWithErrorHandling({
    required this.assetPath,
    this.size,
    this.colorFilter,
    this.fit = BoxFit.contain,
    this.placeholderBuilder,
    required this.errorPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder(
          future: _loadAsset(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return errorPlaceholder;
            }
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return placeholderBuilder?.call(context) ?? errorPlaceholder;
            }
            
            if (snapshot.hasData && snapshot.data == true) {
              return SvgPicture.asset(
                assetPath,
                width: size,
                height: size,
                fit: fit,
                colorFilter: colorFilter,
                placeholderBuilder: placeholderBuilder,
              );
            }
            
            return errorPlaceholder;
          },
        );
      },
    );
  }

  Future<bool> _loadAsset(BuildContext context) async {
    try {
      // Try to load the asset to verify it exists
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (e) {
      // Log error in debug mode for troubleshooting
      if (kDebugMode) {
        debugPrint('SvgIconWidget: Failed to load asset $assetPath: $e');
      }
      return false;
    }
  }
}

/// Widget for SVG icons with gradient background and shadows
class SvgIconWithGradient extends StatelessWidget {
  final String iconPath;
  final double size;
  final Color? iconColor;
  final List<Color> gradientColors;
  final List<BoxShadow>? shadows;
  final double borderRadius;
  final Border? border;
  final bool useThemeColor;

  SvgIconWithGradient({
    super.key,
    String? iconPath,
    String? assetPath, // Backward compatibility
    required this.size,
    this.iconColor,
    required this.gradientColors,
    this.shadows,
    this.borderRadius = 10,
    this.border,
    this.useThemeColor = true,
  }) : iconPath = _resolveIconPathForGradient(iconPath, assetPath),
        assert(iconPath != null || assetPath != null, 'Either iconPath or assetPath must be provided');

  /// Helper method to resolve icon path from either iconPath or assetPath
  static String _resolveIconPathForGradient(String? iconPath, String? assetPath) {
    if (iconPath != null) {
      return iconPath;
    }
    if (assetPath != null) {
      // If assetPath starts with assets/icons/, extract relative path
      if (assetPath.startsWith(_iconsBasePath)) {
        return assetPath.substring(_iconsBasePath.length);
      }
      // If it's a full path starting with assets/, return as is
      if (assetPath.startsWith('assets/')) {
        return assetPath;
      }
      // Otherwise, assume it's a relative path
      return assetPath;
    }
    throw ArgumentError('Either iconPath or assetPath must be provided');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: shadows,
      ),
      child: Center(
        child: SvgIconWidget(
          iconPath: iconPath,
          size: size * 0.5,
          color: iconColor,
          useThemeColor: useThemeColor,
        ),
      ),
    );
  }
}


