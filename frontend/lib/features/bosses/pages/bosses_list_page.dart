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
            tooltip: 'New Boss',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBosses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (bosses.isEmpty) {
      return const Center(child: Text('No bosses found'));
    }

    return RefreshIndicator(
      onRefresh: _loadBosses,
      child: ListView.builder(
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

