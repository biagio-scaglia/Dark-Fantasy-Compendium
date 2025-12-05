import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';

class BossCard extends StatelessWidget {
  final Map<String, dynamic> boss;
  final bool animated;
  final Duration? animationDelay;

  const BossCard({
    super.key,
    required this.boss,
    this.animated = false,
    this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 10,
      shadowColor: AppTheme.accentCrimson.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/bosses/${boss['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.getAccentGoldFromContext(context),
                AppTheme.getAccentDarkGoldFromContext(context),
                AppTheme.accentCrimson.withOpacity(0.8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.6),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentCrimson.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
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
                          boss['name'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          boss['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Lv. ${boss['level'] ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _HealthBar(
                current: boss['health'] ?? 0,
                max: boss['max_health'] ?? 1,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _StatChip(
                    icon: Icons.dangerous,
                    label: 'ATK',
                    value: '${boss['attack'] ?? 0}',
                  ),
                  const SizedBox(width: 10),
                  _StatChip(
                    icon: Icons.shield,
                    label: 'DEF',
                    value: '${boss['defense'] ?? 0}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (animated) {
      return AppAnimations.fadeScaleIn(
        duration: AppAnimations.mediumDuration,
        beginScale: 0.9,
        endScale: 1.0,
        delay: animationDelay ?? Duration.zero,
        child: card,
      );
    }
    return card;
  }
}

class _HealthBar extends StatelessWidget {
  final int current;
  final int max;

  const _HealthBar({required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    final percentage = (current / max).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'HP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            Text(
              '$current / $max',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.black.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 0.5
                    ? Colors.green.shade300
                    : percentage > 0.25
                        ? Colors.orange.shade300
                        : Colors.red.shade300,
              ),
              minHeight: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            '$label: $value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


