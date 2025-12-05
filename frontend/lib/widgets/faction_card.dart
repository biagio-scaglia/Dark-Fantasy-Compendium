import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';

class FactionCard extends StatelessWidget {
  final Map<String, dynamic> faction;
  final bool animated;
  final Duration? animationDelay;

  const FactionCard({
    super.key,
    required this.faction,
    this.animated = false,
    this.animationDelay,
  });

  Color _parseColor(BuildContext context, String? colorString) {
    if (colorString == null) return AppTheme.getAccentGoldFromContext(context);
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTheme.getAccentGoldFromContext(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final factionColor = _parseColor(context, faction['color']);

    final card = Card(
      elevation: 8,
      shadowColor: factionColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/factions/${faction['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.getSecondaryBackgroundFromContext(context),
                AppTheme.getPrimaryBackgroundFromContext(context),
                factionColor.withOpacity(0.2),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: factionColor.withOpacity(0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: factionColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      factionColor,
                      factionColor.withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: factionColor.withOpacity(0.8),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: factionColor.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.group,
                  size: 26,
                  color: AppTheme.getPrimaryBackgroundFromContext(context),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faction['name'] ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: factionColor,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppTheme.getPrimaryBackgroundFromContext(context).withOpacity(0.8),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      faction['description'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
        offset: const Offset(-30, 0),
        fromLeft: true,
        delay: animationDelay ?? Duration.zero,
        child: card,
      );
    }
    return card;
  }
}


