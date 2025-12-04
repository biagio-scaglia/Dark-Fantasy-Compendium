import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.getAccentGoldFromContext(context), width: 2),
                ),
                child: Icon(
                  FontAwesomeIcons.userShield,
                  size: 40,
                  color: AppTheme.getAccentGoldFromContext(context),
                ),
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

