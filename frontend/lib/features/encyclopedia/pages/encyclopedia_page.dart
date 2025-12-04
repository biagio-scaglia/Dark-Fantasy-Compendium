import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';

class EncyclopediaPage extends StatelessWidget {
  const EncyclopediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encyclopedia'),
        backgroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradientFromContext(context),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildListDelegate([
                    _EncyclopediaCard(
                      title: 'D&D Classes',
                      icon: FontAwesomeIcons.hatWizard,
                      route: '/dnd-classes',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentGoldFromContext(context),
                          AppTheme.getAccentDarkGoldFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Races',
                      icon: FontAwesomeIcons.usersLine,
                      route: '/races',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentBrownFromContext(context),
                          AppTheme.getPrimaryBackgroundFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Spells',
                      icon: FontAwesomeIcons.wandSparkles,
                      route: '/spells',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentGoldFromContext(context),
                          AppTheme.accentCrimson,
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Abilities',
                      icon: FontAwesomeIcons.star,
                      route: '/abilities',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentCrimson,
                          AppTheme.getAccentGoldFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Items',
                      icon: FontAwesomeIcons.box,
                      route: '/items',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentGoldFromContext(context),
                          AppTheme.getAccentDarkGoldFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Maps',
                      icon: FontAwesomeIcons.map,
                      route: '/maps',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentGoldFromContext(context),
                          AppTheme.accentCrimson,
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Knights',
                      icon: FontAwesomeIcons.shieldHalved,
                      route: '/knights',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentGoldFromContext(context),
                          AppTheme.getAccentBrownFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Weapons',
                      icon: FontAwesomeIcons.gavel,
                      route: '/weapons',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentBrownFromContext(context),
                          AppTheme.getPrimaryBackgroundFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Armor',
                      icon: FontAwesomeIcons.shield,
                      route: '/armors',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentGoldFromContext(context),
                          AppTheme.getAccentBrownFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Bosses',
                      icon: FontAwesomeIcons.dragon,
                      route: '/bosses',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentCrimson,
                          AppTheme.getAccentBrownFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Factions',
                      icon: FontAwesomeIcons.chessRook,
                      route: '/factions',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentDarkGoldFromContext(context),
                          AppTheme.getAccentBrownFromContext(context),
                        ],
                      ),
                    ),
                    _EncyclopediaCard(
                      title: 'Lore',
                      icon: FontAwesomeIcons.feather,
                      route: '/lores',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getAccentBrownFromContext(context),
                          AppTheme.getPrimaryBackgroundFromContext(context),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EncyclopediaCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final Gradient gradient;

  const _EncyclopediaCard({
    required this.title,
    required this.icon,
    required this.route,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.getPrimaryBackgroundFromContext(context).withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: FaIcon(
                  icon,
                  size: 48,
                  color: AppTheme.getTextPrimaryFromContext(context),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.getTextPrimaryFromContext(context),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: AppTheme.getPrimaryBackgroundFromContext(context).withOpacity(0.8),
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

