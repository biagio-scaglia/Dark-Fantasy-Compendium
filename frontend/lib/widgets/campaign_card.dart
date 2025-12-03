import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CampaignCard extends StatelessWidget {
  final Map<String, dynamic> campaign;

  const CampaignCard({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () => context.push('/campaigns/${campaign['id']}'),
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
                  FontAwesomeIcons.diceD20,
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
                      campaign['name'] ?? 'Campagna senza nome',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    if (campaign['dungeon_master'] != null)
                      Text(
                        'DM: ${campaign['dungeon_master']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (campaign['sessions'] != null)
                          Chip(
                            label: Text('${(campaign['sessions'] as List).length} sessioni'),
                            backgroundColor: AppTheme.accentGold.withOpacity(0.2),
                          ),
                        if (campaign['current_level'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'Livello ${campaign['current_level']}',
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

