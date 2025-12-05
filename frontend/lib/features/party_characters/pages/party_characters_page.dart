import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_widget.dart';

class PartyCharactersPage extends StatelessWidget {
  const PartyCharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Party & Characters'),
          backgroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: SvgIconWidget(
                  iconPath: 'team-idea.svg',
                  size: 24,
                  useThemeColor: true,
                ),
                text: 'Party',
              ),
              Tab(
                icon: SvgIconWidget(
                  iconPath: 'character.svg',
                  size: 24,
                  useThemeColor: true,
                ),
                text: 'Characters',
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.getBackgroundGradientFromContext(context),
          ),
          child: const TabBarView(
            children: [
              _PartiesTab(),
              _CharactersTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartiesTab extends StatelessWidget {
  const _PartiesTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIconWidget(
                    iconPath: 'team-idea.svg',
                    size: 64,
                    color: AppTheme.getAccentGoldFromContext(context),
                    useThemeColor: false,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manage Your Parties',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create and manage character groups',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getTextSecondaryFromContext(context),
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/parties'),
                    icon: SvgIconWidget(
                      iconPath: 'team-idea.svg',
                      size: 20,
                      color: AppTheme.getPrimaryBackgroundFromContext(context),
                      useThemeColor: false,
                    ),
                    label: const Text('View Parties'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.getAccentGoldFromContext(context),
                      foregroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharactersTab extends StatelessWidget {
  const _CharactersTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIconWidget(
                    iconPath: 'character.svg',
                    size: 64,
                    color: AppTheme.getAccentGoldFromContext(context),
                    useThemeColor: false,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manage Your Characters',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create and manage characters for your campaigns',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getTextSecondaryFromContext(context),
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/characters'),
                    icon: SvgIconWidget(
                      iconPath: 'character.svg',
                      size: 20,
                      color: AppTheme.getPrimaryBackgroundFromContext(context),
                      useThemeColor: false,
                    ),
                    label: const Text('View Characters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.getAccentGoldFromContext(context),
                      foregroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


