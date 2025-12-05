import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/knight_service.dart';
import '../../../data/models/knight.dart';
import '../../../widgets/knight_card.dart';
import 'knight_form_page.dart';

class KnightsListPage extends StatefulWidget {
  const KnightsListPage({super.key});

  @override
  State<KnightsListPage> createState() => _KnightsListPageState();
}

class _KnightsListPageState extends State<KnightsListPage> {
  List<Knight> knights = [];
  bool isLoading = true;
  String? error;
  final KnightService _service = KnightService();

  @override
  void initState() {
    super.initState();
    _loadKnights();
  }

  Future<void> _loadKnights() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        knights = data;
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
        title: const Text('Knights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/knights/new'),
            tooltip: 'Add Knight',
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
                'Error loading knights',
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
                onPressed: _loadKnights,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (knights.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 64,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No knights found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first knight to get started',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.push('/knights/new'),
                icon: const Icon(Icons.add),
                label: const Text('Create Knight'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadKnights,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: knights.length,
        itemBuilder: (context, index) {
          final knight = knights[index];
          final knightMap = {
            'id': knight.id,
            'name': knight.name,
            'title': knight.title,
            'level': knight.level,
            'health': knight.health,
            'max_health': knight.maxHealth,
            'attack': knight.attack,
            'defense': knight.defense,
            'image_path': knight.imagePath,
            'icon_path': knight.iconPath,
          };
          return KnightCard(knight: knightMap);
        },
      ),
    );
  }
}


