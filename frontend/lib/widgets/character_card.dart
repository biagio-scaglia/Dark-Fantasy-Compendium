import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/design_system/app_colors.dart';
import '../core/design_system/app_animations.dart';
import '../core/theme/app_theme_constants.dart';
import 'svg_icon_widget.dart';
import 'animated_card.dart';

class CharacterCard extends StatelessWidget {
  final Map<String, dynamic> character;
  final int? index; // For staggered animation

  const CharacterCard({
    super.key,
    required this.character,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final accentColor = AppColors.getAccentPrimary(brightness);
    final currentHp = character['current_hit_points'] as int?;
    final maxHp = character['max_hit_points'] as int?;
    final hpPercentage = (currentHp != null && maxHp != null && maxHp > 0)
        ? currentHp / maxHp
        : 1.0;
    final hpColor = hpPercentage > 0.5
        ? Colors.green
        : hpPercentage > 0.25
            ? Colors.orange
            : Colors.red;

    Widget cardContent = AnimatedCard(
      onTap: () => context.push('/characters/${character['id']}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AppAnimations.scaleIn(
            duration: AppAnimations.medium,
            begin: 0.8,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
                border: Border.all(
                  color: accentColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: SvgIconWidget(
                  iconPath: character['icon_path'] ?? 'character.svg',
                  size: 40,
                  color: accentColor,
                  useThemeColor: false,
                ),
              ),
            ),
          ),
          SizedBox(width: AppThemeConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character['name'] ?? 'Unnamed character',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: AppThemeConstants.fontWeightSemiBold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppThemeConstants.spacing4),
                if (character['player_name'] != null)
                  Text(
                    'Player: ${character['player_name']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.getTextSecondary(brightness),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: AppThemeConstants.spacing8),
                Wrap(
                  spacing: AppThemeConstants.spacing8,
                  runSpacing: AppThemeConstants.spacing4,
                  children: [
                    if (character['level'] != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppThemeConstants.spacing12,
                          vertical: AppThemeConstants.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Level ${character['level']}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: accentColor,
                                fontWeight: AppThemeConstants.fontWeightMedium,
                              ),
                        ),
                      ),
                    if (currentHp != null && maxHp != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppThemeConstants.spacing12,
                          vertical: AppThemeConstants.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: hpColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
                          border: Border.all(
                            color: hpColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: hpColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: AppThemeConstants.spacing4),
                            Text(
                              'HP: $currentHp/$maxHp',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: hpColor,
                                    fontWeight: AppThemeConstants.fontWeightMedium,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Apply staggered animation if index is provided
    if (index != null) {
      return AppAnimations.fadeSlideIn(
        duration: AppAnimations.medium,
        offset: const Offset(0, 20),
        delay: Duration(milliseconds: 100 * (index! % 5)),
        child: cardContent,
      );
    }

    return cardContent;
  }
}


