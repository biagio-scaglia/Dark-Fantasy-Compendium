import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_theme.dart';

/// Widget per caricare e visualizzare icone SVG con colori personalizzati
class SvgIconWidget extends StatelessWidget {
  final String assetPath;
  final double? size;
  final Color? color;
  final BoxFit fit;
  final Color? backgroundColor;
  final double? padding;
  final List<BoxShadow>? shadows;

  const SvgIconWidget({
    super.key,
    required this.assetPath,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
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
        child: icon,
      );
    }

    return icon;
  }
}

/// Widget per icone SVG con sfondo gradiente e ombre
class SvgIconWithGradient extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color iconColor;
  final List<Color> gradientColors;
  final List<BoxShadow>? shadows;
  final double borderRadius;
  final Border? border;

  const SvgIconWithGradient({
    super.key,
    required this.assetPath,
    required this.size,
    required this.iconColor,
    required this.gradientColors,
    this.shadows,
    this.borderRadius = 10,
    this.border,
  });

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
          assetPath: assetPath,
          size: size * 0.5,
          color: iconColor,
        ),
      ),
    );
  }
}

