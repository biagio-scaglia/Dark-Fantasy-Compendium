import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme/app_theme.dart';

class KnightCard extends StatelessWidget {
  final Map<String, dynamic> knight;

  const KnightCard({super.key, required this.knight});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.5),
      child: InkWell(
        onTap: () => context.push('/knights/${knight['id']}'),
        borderRadius: BorderRadius.circular(em * 0.75),
        child: Padding(
          padding: EdgeInsets.all(em),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          knight['name'] ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: em * 0.25),
                        Text(
                          knight['title'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: em * 0.75, vertical: em * 0.375),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentGold),
                    ),
                    child: Text(
                      'Lv. ${knight['level'] ?? 0}',
                      style: const TextStyle(
                        color: AppTheme.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: em * 0.75),
              Wrap(
                spacing: em * 0.5,
                runSpacing: em * 0.5,
                children: [
                  _StatChip(
                    icon: FontAwesomeIcons.heart,
                    label: 'HP',
                    value: '${knight['health'] ?? 0}/${knight['max_health'] ?? 0}',
                    color: AppTheme.accentCrimson,
                  ),
                  _StatChip(
                    icon: FontAwesomeIcons.gavel,
                    label: 'ATK',
                    value: '${knight['attack'] ?? 0}',
                    color: AppTheme.accentGold,
                  ),
                  _StatChip(
                    icon: FontAwesomeIcons.shield,
                    label: 'DEF',
                    value: '${knight['defense'] ?? 0}',
                    color: AppTheme.accentBrown,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: em * 0.5, vertical: em * 0.25),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(em * 0.375),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: em * 0.75, color: color),
          SizedBox(width: em * 0.25),
          Flexible(
            child: Text(
              '$label: $value',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

