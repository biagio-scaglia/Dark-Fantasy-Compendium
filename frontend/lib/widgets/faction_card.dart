import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';

class FactionCard extends StatelessWidget {
  final Map<String, dynamic> faction;

  const FactionCard({super.key, required this.faction});

  Color _parseColor(String? colorString) {
    if (colorString == null) return AppTheme.accentGold;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTheme.accentGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final factionColor = _parseColor(faction['color']);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => context.push('/factions/${faction['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                factionColor.withOpacity(0.3),
                AppTheme.secondaryDark,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: factionColor, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: factionColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: factionColor, width: 2),
                  ),
                  child: Icon(
                    Icons.group,
                    size: 30,
                    color: factionColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        faction['name'] ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: factionColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        faction['description'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

