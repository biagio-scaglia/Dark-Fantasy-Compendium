import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/design_system/app_colors.dart';
import '../core/design_system/app_animations.dart';
import '../core/theme/app_theme_constants.dart';
import 'svg_icon_widget.dart';
import 'animated_card.dart';

class CampaignCard extends StatelessWidget {
  final Map<String, dynamic> campaign;
  final int? index; // For staggered animation

  const CampaignCard({
    super.key,
    required this.campaign,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final accentColor = AppColors.getAccentPrimary(brightness);
    
    Widget cardContent = AnimatedCard(
      onTap: () => context.push('/campaigns/${campaign['id']}'),
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
                  iconPath: campaign['icon_path'] ?? 'dice-twenty-faces-twenty.svg',
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
                  campaign['name'] ?? 'Unnamed campaign',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: AppThemeConstants.fontWeightSemiBold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppThemeConstants.spacing4),
                if (campaign['dungeon_master'] != null)
                  Text(
                    'DM: ${campaign['dungeon_master']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.getTextSecondary(brightness),
                        ),
                  ),
                SizedBox(height: AppThemeConstants.spacing8),
                Wrap(
                  spacing: AppThemeConstants.spacing8,
                  runSpacing: AppThemeConstants.spacing4,
                  children: [
                    if (campaign['sessions'] != null)
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
                          '${(campaign['sessions'] as List).length} sessions',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: accentColor,
                                fontWeight: AppThemeConstants.fontWeightMedium,
                              ),
                        ),
                      ),
                    if (campaign['current_level'] != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppThemeConstants.spacing12,
                          vertical: AppThemeConstants.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceVariant(brightness),
                          borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
                        ),
                        child: Text(
                          'Level ${campaign['current_level']}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.getTextSecondary(brightness),
                              ),
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


