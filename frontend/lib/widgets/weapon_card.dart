import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme/app_theme.dart';

class WeaponCard extends StatelessWidget {
  final Map<String, dynamic> weapon;

  const WeaponCard({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    final rarity = weapon['rarity'] ?? 'common';
    final rarityColor = AppTheme.getRarityColor(rarity);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.5),
      child: InkWell(
        onTap: () => context.push('/weapons/${weapon['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(em),
          child: Row(
            children: [
              Container(
                width: em * 3.75,
                height: em * 3.75,
                decoration: BoxDecoration(
                  color: rarityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: rarityColor, width: 2),
                ),
                child: Center(
                  child: FaIcon(FontAwesomeIcons.gavel, size: em * 1.875, color: AppTheme.textPrimary),
                ),
              ),
              SizedBox(width: em),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            weapon['name'] ?? '',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: em * 0.5, vertical: em * 0.25),
                          decoration: BoxDecoration(
                            color: rarityColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            rarity.toUpperCase(),
                            style: TextStyle(
                              color: rarityColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: em * 0.25),
                    Text(
                      weapon['type'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: em * 0.5),
                    Row(
                      children: [
                        _StatBadge(
                          icon: Icons.trending_up,
                          value: '+${weapon['attack_bonus'] ?? 0}',
                          label: 'ATK',
                          color: AppTheme.accentGold,
                        ),
                        SizedBox(width: em * 0.5),
                        _StatBadge(
                          icon: Icons.build,
                          value: '${weapon['durability'] ?? 0}%',
                          label: 'DUR',
                          color: AppTheme.textSecondary,
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

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

