import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';

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
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.users),
                text: 'Party',
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.userLarge),
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
                  FaIcon(
                    FontAwesomeIcons.users,
                    size: 64,
                    color: AppTheme.getAccentGoldFromContext(context),
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
                    icon: const FaIcon(FontAwesomeIcons.users),
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
                  FaIcon(
                    FontAwesomeIcons.userLarge,
                    size: 64,
                    color: AppTheme.getAccentGoldFromContext(context),
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
                    icon: const FaIcon(FontAwesomeIcons.userLarge),
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

