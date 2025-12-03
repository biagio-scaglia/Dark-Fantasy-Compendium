import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';

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
      shadowColor: AppTheme.accentGold.withOpacity(0.3),
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
                AppTheme.secondaryDark,
                AppTheme.primaryDark,
                AppTheme.accentGold.withOpacity(0.1),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.accentGold.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withOpacity(0.2),
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
                                color: AppTheme.primaryDark.withOpacity(0.8),
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
                            color: AppTheme.accentGold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.accentGold.withOpacity(0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGold.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Lv. ${knight['level'] ?? 0}',
                      style: TextStyle(
                        color: AppTheme.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppTheme.accentGold.withOpacity(0.5),
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
                    icon: FontAwesomeIcons.heart,
                    label: 'HP',
                    value: '${knight['health'] ?? 0}/${knight['max_health'] ?? 0}',
                    color: AppTheme.accentCrimson,
                  ),
                  _StatChip(
                    icon: FontAwesomeIcons.gavel,
                    label: 'ATK',
                    value: '${knight['attack'] ?? 0}',
                    color: AppTheme.accentGold,
                  ),
                  _StatChip(
                    icon: FontAwesomeIcons.shield,
                    label: 'DEF',
                    value: '${knight['defense'] ?? 0}',
                    color: AppTheme.accentBrown,
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
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
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
          FaIcon(icon, size: 13, color: color),
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
                    color: AppTheme.primaryDark.withOpacity(0.5),
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

