import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/boss_service.dart';
import '../../../core/theme/app_theme.dart';

class BossDetailPage extends StatefulWidget {
  final int bossId;

  const BossDetailPage({super.key, required this.bossId});

  @override
  State<BossDetailPage> createState() => _BossDetailPageState();
}

class _BossDetailPageState extends State<BossDetailPage> {
  Map<String, dynamic>? boss;
  bool isLoading = true;
  String? error;
  final BossService _service = BossService();

  @override
  void initState() {
    super.initState();
    _loadBoss();
  }

  Future<void> _loadBoss() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final bossData = await _service.getById(widget.bossId);
      if (bossData != null) {
        setState(() {
          boss = {
            'id': bossData.id,
            'name': bossData.name,
            'title': bossData.title,
            'level': bossData.level,
            'health': bossData.health,
            'max_health': bossData.maxHealth,
            'attack': bossData.attack,
            'defense': bossData.defense,
            'description': bossData.description,
            'lore': bossData.lore,
            'reward_ids': bossData.rewardIds,
            'image_path': bossData.imagePath,
            'icon_path': bossData.iconPath,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Boss not found';
          isLoading = false;
        });
      }
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
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(boss?['name'] ?? 'Boss'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null || boss == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error ?? "Boss not found"}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBoss,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildStats(),
            const SizedBox(height: 24),
            _buildDescription(),
            if (boss!['lore'] != null) ...[
              const SizedBox(height: 24),
              _buildLore(),
            ],
            if (boss!['rewards'] != null && (boss!['rewards'] as List).isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildRewards(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getGoldGradientFromContext(context),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                boss!['name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                boss!['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Level ${boss!['level'] ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiche',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _HealthBar(
              current: boss!['health'] ?? 0,
              max: boss!['max_health'] ?? 1,
            ),
            const SizedBox(height: 16),
            _StatRow(
              icon: Icons.dangerous,
              label: 'Attacco',
              value: '${boss!['attack'] ?? 0}',
              color: AppTheme.getAccentGoldFromContext(context),
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.shield,
              label: 'Difesa',
              value: '${boss!['defense'] ?? 0}',
              color: AppTheme.getAccentBrownFromContext(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              boss!['description'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLore() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: AppTheme.getAccentGoldFromContext(context)),
                const SizedBox(width: 8),
                Text(
                  'Lore',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.getAccentGoldFromContext(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              boss!['lore'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewards() {
    final rewards = boss!['rewards'] as List;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: AppTheme.getAccentGoldFromContext(context)),
                const SizedBox(width: 8),
                Text(
                  'Ricompense',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.getAccentGoldFromContext(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: rewards.map<Widget>((rewardId) {
                return Chip(
                  label: Text('Item #$rewardId'),
                  backgroundColor: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthBar extends StatelessWidget {
  final int current;
  final int max;

  const _HealthBar({required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    final percentage = (current / max).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HP',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$current / $max',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.accentCrimson,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppTheme.getSecondaryBackgroundFromContext(context),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentCrimson),
            minHeight: 12,
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


