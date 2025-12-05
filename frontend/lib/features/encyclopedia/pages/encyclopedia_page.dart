import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_widget.dart';

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
                      iconPath: 'delapouite/wizard-face.svg',
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
                      iconPath: 'delapouite/team-idea.svg',
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
                      iconPath: 'lorc/wizard-staff.svg',
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
                      iconPath: 'lorc/star-swirl.svg',
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
                      iconPath: 'lorc/crystal-shine.svg',
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
                      iconPath: 'lorc/scroll-unfurled.svg',
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
                      iconPath: 'sbed/shield.svg',
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
                      iconPath: 'lorc/hammer-drop.svg',
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
                      iconPath: 'lorc/breastplate.svg',
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
                      iconPath: 'lorc/dragon-head.svg',
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
                      iconPath: 'delapouite/tower-flag.svg',
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
                      title: 'Characters',
                      iconPath: 'delapouite/character.svg',
                      route: '/characters',
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
                      title: 'Lore',
                      iconPath: 'lorc/quill.svg',
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
  final String iconPath;
  final String route;
  final Gradient gradient;

  _EncyclopediaCard({
    required this.title,
    required this.iconPath,
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
                child: SvgIconWidget(
                  iconPath: iconPath,
                  size: 48,
                  color: AppTheme.getTextPrimaryFromContext(context),
                  useThemeColor: false,
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

