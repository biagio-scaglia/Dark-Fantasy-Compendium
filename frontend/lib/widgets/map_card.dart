import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapCard extends StatelessWidget {
  final Map<String, dynamic> map;

  const MapCard({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () => context.push('/maps/${map['id']}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentGold, width: 2),
                ),
                child: const Icon(
                  FontAwesomeIcons.map,
                  size: 40,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      map['name'] ?? 'Mappa senza nome',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      map['description'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (map['markers'] != null)
                          Chip(
                            label: Text('${(map['markers'] as List).length} marcatori'),
                            backgroundColor: AppTheme.accentGold.withOpacity(0.2),
                          ),
                        if (map['width'] != null && map['height'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${map['width']}x${map['height']}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
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

