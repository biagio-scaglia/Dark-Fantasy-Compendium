import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'svg_icon_widget.dart';
import '../utils/icon_mapper.dart';

class DndClassCard extends StatelessWidget {
  final Map<String, dynamic> dndClass;

  const DndClassCard({super.key, required this.dndClass});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () => context.push('/dnd-classes/${dndClass['id']}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgIconWithGradient(
                assetPath: IconMapper.getIconPath(
                  customPath: dndClass['icon_path'] as String?,
                  className: dndClass['name'] as String?,
                ) ?? IconMapper.getClassIconPath(dndClass['name'] as String?) ?? 'assets/icons/barbarian.svg',
                size: 80,
                iconColor: AppTheme.getAccentGoldFromContext(context),
                gradientColors: [
                  AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
                  AppTheme.getAccentGoldFromContext(context).withOpacity(0.1),
                ],
                borderRadius: 8,
                border: Border.all(
                  color: AppTheme.getAccentGoldFromContext(context),
                  width: 2,
                ),
                shadows: [
                  BoxShadow(
                    color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dndClass['name'] ?? 'Unnamed class',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dndClass['description'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (dndClass['hit_dice'] != null)
                      Chip(
                        label: Text('Dice: ${dndClass['hit_dice']}'),
                        backgroundColor: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                      ),
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


