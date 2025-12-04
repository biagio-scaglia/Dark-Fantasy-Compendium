import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_theme.dart';

/// Base path for all SVG icons
const String _iconsBasePath = 'icons/';

/// Widget per caricare e visualizzare icone SVG con colori personalizzati
/// Supporta automaticamente Light e Dark mode con colori adeguati al tema
class SvgIconWidget extends StatelessWidget {
  /// Path relativo all'icona dentro assets/icons/
  /// Esempio: "lorc/sword.svg" o "delapouite/shield.svg"
  final String iconPath;
  
  /// Dimensione dell'icona (larghezza e altezza)
  final double? size;
  
  /// Colore personalizzato (opzionale). Se null, usa il colore del tema
  final Color? color;
  
  /// Se true, applica automaticamente il colore del tema in base a Light/Dark mode
  final bool useThemeColor;
  
  final BoxFit fit;
  final Color? backgroundColor;
  final double? padding;
  final List<BoxShadow>? shadows;
  
  /// Path completo dell'icona placeholder da usare in caso di errore
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

  /// Costruttore che accetta il path completo (per retrocompatibilità)
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
          : assetPath.startsWith('assets/icons/')
            ? assetPath.substring('assets/icons/'.length)
            : assetPath;

  /// Helper method to resolve icon path from either iconPath or assetPath
  /// Returns a relative path (without icons/ prefix) that can be used with _fullAssetPath
  static String _resolveIconPath(String? iconPath, String? assetPath) {
    String? pathToResolve = iconPath ?? assetPath;
    if (pathToResolve == null) {
      throw ArgumentError('Either iconPath or assetPath must be provided');
    }
    
    // Se il path inizia con icons/, rimuovi il prefisso per ottenere il path relativo
    if (pathToResolve.startsWith(_iconsBasePath)) {
      return pathToResolve.substring(_iconsBasePath.length);
    }
    
    // Se inizia con assets/icons/, convertilo a path relativo
    if (pathToResolve.startsWith('assets/icons/')) {
      return pathToResolve.substring('assets/icons/'.length);
    }
    
    // Se inizia con assets/ ma non con assets/icons/, è un path completo diverso
    // Restituiscilo così com'è (sarà gestito da _fullAssetPath)
    if (pathToResolve.startsWith('assets/')) {
      return pathToResolve;
    }
    
    // Altrimenti è un path relativo (es: "lorc/sword.svg"), restituiscilo così com'è
    return pathToResolve;
  }

  /// Costruisce il path completo dell'icona
  /// In Flutter, se nel pubspec.yaml c'è "- icons/", dobbiamo passare "icons/..." a SvgPicture.asset()
  String get _fullAssetPath {
    // Se iconPath inizia già con icons/, è già corretto
    if (iconPath.startsWith(_iconsBasePath)) {
      return iconPath;
    }
    // Se inizia con assets/icons/, convertilo a icons/
    if (iconPath.startsWith('assets/icons/')) {
      return iconPath.replaceFirst('assets/icons/', 'icons/');
    }
    // Se inizia con assets/icons/icons/, correggilo
    if (iconPath.startsWith('assets/icons/icons/')) {
      return iconPath.replaceFirst('assets/icons/icons/', 'icons/');
    }
    // Se inizia con assets/ ma non con assets/icons/, è un path completo diverso
    // Restituiscilo così com'è (sarà gestito da SvgPicture.asset)
    if (iconPath.startsWith('assets/')) {
      return iconPath;
    }
    // Altrimenti è un path relativo (es: "lorc/sword.svg"), aggiungi il prefisso icons/
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
    
    // Debug: print per vedere il path costruito
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
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Widget per icone SVG con sfondo gradiente e ombre
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

