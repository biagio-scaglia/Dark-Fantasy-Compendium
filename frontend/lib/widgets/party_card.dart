import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'svg_icon_widget.dart';

class PartyCard extends StatelessWidget {
  final Map<String, dynamic> party;

  const PartyCard({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () => context.push('/parties/${party['id']}'),
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
                child: Center(
                  child: SvgIconWidget(
                    iconPath: 'team-idea.svg',
                    size: 40,
                    color: AppTheme.getAccentGoldFromContext(context),
                    useThemeColor: false,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party['name'] ?? 'Unnamed party',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    if (party['description'] != null)
                      Text(
                        party['description'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (party['level'] != null)
                          Chip(
                            label: Text('Level ${party['level']}'),
                            backgroundColor: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                          ),
                        if (party['characters'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${(party['characters'] as List).length} characters',
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


