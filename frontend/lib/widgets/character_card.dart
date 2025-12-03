import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CharacterCard extends StatelessWidget {
  final Map<String, dynamic> character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () => context.push('/characters/${character['id']}'),
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
                  FontAwesomeIcons.user,
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
                      character['name'] ?? 'Personaggio senza nome',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    if (character['player_name'] != null)
                      Text(
                        'Giocatore: ${character['player_name']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (character['level'] != null)
                          Chip(
                            label: Text('Livello ${character['level']}'),
                            backgroundColor: AppTheme.accentGold.withOpacity(0.2),
                          ),
                        if (character['current_hit_points'] != null && character['max_hit_points'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'HP: ${character['current_hit_points']}/${character['max_hit_points']}',
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

