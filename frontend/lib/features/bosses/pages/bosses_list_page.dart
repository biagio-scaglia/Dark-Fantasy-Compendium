import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/boss_service.dart';
import '../../../data/models/boss.dart';
import '../../../widgets/boss_card.dart';

class BossesListPage extends StatefulWidget {
  const BossesListPage({super.key});

  @override
  State<BossesListPage> createState() => _BossesListPageState();
}

class _BossesListPageState extends State<BossesListPage> {
  List<Boss> bosses = [];
  bool isLoading = true;
  String? error;
  final BossService _service = BossService();

  @override
  void initState() {
    super.initState();
    _loadBosses();
  }

  Future<void> _loadBosses() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        bosses = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
          tooltip: 'Back',
        ),
        title: const Text('Bosses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/bosses/new'),
            tooltip: 'Add Boss',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading bosses',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadBosses,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (bosses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dangerous_outlined,
                size: 64,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No bosses found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first boss to get started',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.push('/bosses/new'),
                icon: const Icon(Icons.add),
                label: const Text('Create Boss'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBosses,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: bosses.length,
        itemBuilder: (context, index) {
          final boss = bosses[index];
          final bossMap = {
            'id': boss.id,
            'name': boss.name,
            'title': boss.title,
            'level': boss.level,
            'health': boss.health,
            'max_health': boss.maxHealth,
            'attack': boss.attack,
            'defense': boss.defense,
            'description': boss.description,
            'image_path': boss.imagePath,
            'icon_path': boss.iconPath,
          };
          return BossCard(boss: bossMap);
        },
      ),
    );
  }
}


