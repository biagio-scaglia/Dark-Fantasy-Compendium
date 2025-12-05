import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';

class LoreCard extends StatelessWidget {
  final Map<String, dynamic> lore;
  final bool animated;
  final Duration? animationDelay;

  const LoreCard({
    super.key,
    required this.lore,
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
        onTap: () => context.push('/lores/${lore['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.getSecondaryBackgroundFromContext(context),
                AppTheme.getPrimaryBackgroundFromContext(context),
                AppTheme.getAccentGoldFromContext(context).withOpacity(0.15),
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
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppTheme.getGoldGradientFromContext(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu_book,
                  size: 24,
                  color: AppTheme.getPrimaryBackgroundFromContext(context),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lore['title'] ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        shadows: [
                          Shadow(
                            color: AppTheme.getPrimaryBackgroundFromContext(context).withOpacity(0.8),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
                            AppTheme.getAccentDarkGoldFromContext(context).withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.getAccentGoldFromContext(context),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        lore['category'] ?? '',
                        style: TextStyle(
                          color: AppTheme.getAccentGoldFromContext(context),
                          fontSize: 10,
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
                    const SizedBox(height: 8),
                    Text(
                      lore['content'] ?? '',
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
        offset: const Offset(0, 20),
        fromBottom: true,
        delay: animationDelay ?? Duration.zero,
        child: card,
      );
    }
    return card;
  }
}


