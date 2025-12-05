import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';
import 'svg_icon_widget.dart';

class KnightCard extends StatelessWidget {
  final Map<String, dynamic> knight;
  final bool animated;
  final Duration? animationDelay;

  const KnightCard({
    super.key,
    required this.knight,
    this.animated = false,
    this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 8,
      shadowColor: AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/knights/${knight['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.getSecondaryBackgroundFromContext(context),
                AppTheme.getPrimaryBackgroundFromContext(context),
                AppTheme.getAccentGoldFromContext(context).withOpacity(0.1),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          knight['name'] ?? '',
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
                        const SizedBox(height: 4),
                        Text(
                          knight['title'] ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.getAccentGoldFromContext(context),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: AppTheme.getGoldGradientFromContext(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Lv. ${knight['level'] ?? 0}',
                      style: TextStyle(
                        color: AppTheme.getPrimaryBackgroundFromContext(context),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatChip(
                    iconPath: 'zeromancer/heart-plus.svg',
                    label: 'HP',
                    value: '${knight['health'] ?? 0}/${knight['max_health'] ?? 0}',
                    color: AppTheme.accentCrimson,
                  ),
                  _StatChip(
                    iconPath: 'lorc/hammer-drop.svg',
                    label: 'ATK',
                    value: '${knight['attack'] ?? 0}',
                    color: AppTheme.getAccentGoldFromContext(context),
                  ),
                  _StatChip(
                    iconPath: 'sbed/shield.svg',
                    label: 'DEF',
                    value: '${knight['defense'] ?? 0}',
                    color: AppTheme.getAccentBrownFromContext(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (animated) {
      return AppAnimations.fadeSlideIn(
        duration: AppAnimations.mediumDuration,
        offset: const Offset(0, 20),
        fromBottom: true,
        delay: animationDelay ?? Duration.zero,
        child: card,
      );
    }
    return card;
  }
}

class _StatChip extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final Color color;

  _StatChip({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgIconWidget(
            iconPath: iconPath,
            size: 13,
            color: color,
            useThemeColor: false,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              '$label: $value',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: AppTheme.getPrimaryBackgroundFromContext(context).withOpacity(0.5),
                    blurRadius: 2,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

