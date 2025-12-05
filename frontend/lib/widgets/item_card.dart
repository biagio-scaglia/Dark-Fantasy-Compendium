import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'svg_icon_widget.dart';
import '../utils/icon_mapper.dart';

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final rarity = item['rarity'] ?? 'common';
    final rarityColor = AppTheme.getRarityColor(rarity);

    return Card(
      elevation: 8,
      shadowColor: rarityColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/items/${item['id']}'),
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
                  customPath: item['icon_path'] as String?,
                  entityType: item['type'] as String?,
                ) ?? IconMapper.getEntityIconPath('magic-item') ?? 'assets/icons/star-swirl.svg',
                size: 50,
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
                            item['name'] ?? '',
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
                        ),
                        if (item['value'] != null && item['value'] > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppTheme.getGoldGradientFromContext(context),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.6),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.monetization_on, size: 12, color: AppTheme.getPrimaryBackgroundFromContext(context)),
                                const SizedBox(width: 4),
                                Text(
                                  '${item['value']}',
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
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['type'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (item['effect'] != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          item['effect'] ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.getAccentGoldFromContext(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


