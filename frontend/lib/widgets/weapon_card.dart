import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';
import 'svg_icon_widget.dart';
import '../utils/icon_mapper.dart';

class WeaponCard extends StatelessWidget {
  final Map<String, dynamic> weapon;
  final bool animated;
  final Duration? animationDelay;

  const WeaponCard({
    super.key,
    required this.weapon,
    this.animated = false,
    this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final rarity = weapon['rarity'] ?? 'common';
    final rarityColor = AppTheme.getRarityColor(rarity);

    final card = Card(
      elevation: 8,
      shadowColor: rarityColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/weapons/${weapon['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.getSecondaryBackgroundFromContext(context),
                AppTheme.getPrimaryBackgroundFromContext(context),
                rarityColor.withOpacity(0.15),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: rarityColor.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: rarityColor.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SvgIconWithGradient(
                assetPath: IconMapper.getIconPath(
                  customPath: weapon['icon_path'] as String?,
                  type: weapon['type'] as String?,
                  entityType: 'weapon',
                ) ?? IconMapper.getWeaponIconPath(weapon['type'] as String?) ?? 'assets/icons/broadsword.svg',
                size: 65,
                iconColor: AppTheme.getPrimaryBackgroundFromContext(context),
                gradientColors: [
                  rarityColor,
                  rarityColor.withOpacity(0.7),
                ],
                borderRadius: 10,
                border: Border.all(
                  color: rarityColor.withOpacity(0.8),
                  width: 2,
                ),
                shadows: [
                  BoxShadow(
                    color: rarityColor.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            weapon['name'] ?? '',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              shadows: [
                                Shadow(
                                  color: AppTheme.getPrimaryBackgroundFromContext(context).withOpacity(0.8),
                                  blurRadius: 3,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                rarityColor.withOpacity(0.4),
                                rarityColor.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: rarityColor,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: rarityColor.withOpacity(0.3),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            rarity.toUpperCase(),
                            style: TextStyle(
                              color: rarityColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: AppTheme.getPrimaryBackgroundFromContext(context),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      weapon['type'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatBadge(
                          iconPath: IconMapper.getAttributeIconPath('bonus'),
                          icon: Icons.trending_up,
                          value: '+${weapon['attack_bonus'] ?? 0}',
                          label: 'ATK',
                          color: AppTheme.getAccentGoldFromContext(context),
                        ),
                        const SizedBox(width: 8),
                        _StatBadge(
                          icon: Icons.build,
                          value: '${weapon['durability'] ?? 0}%',
                          label: 'DUR',
                          color: AppTheme.getTextSecondaryFromContext(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (animated) {
      return AppAnimations.fadeSlideIn(
        duration: AppAnimations.mediumDuration,
        offset: const Offset(30, 0),
        fromRight: true,
        delay: animationDelay ?? Duration.zero,
        child: card,
      );
    }
    return card;
  }
}

class _StatBadge extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String value;
  final String label;
  final Color color;

  const _StatBadge({
    this.icon,
    this.iconPath,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    
    if (iconPath != null) {
      iconWidget = SvgIconWidget(
        assetPath: iconPath!,
        size: 13,
        color: color,
      );
    } else if (icon != null) {
      iconWidget = Icon(icon!, size: 13, color: color);
    } else {
      iconWidget = const SizedBox(width: 13, height: 13);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 5),
          Text(
            '$value $label',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppTheme.getPrimaryBackgroundFromContext(context).withOpacity(0.5),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


