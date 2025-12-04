import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/knight_service.dart';
import '../../../data/models/knight.dart';
import '../../../core/theme/app_theme.dart';
import 'knight_form_page.dart';

class KnightDetailPage extends StatefulWidget {
  final int knightId;

  const KnightDetailPage({super.key, required this.knightId});

  @override
  State<KnightDetailPage> createState() => _KnightDetailPageState();
}

class _KnightDetailPageState extends State<KnightDetailPage> {
  Map<String, dynamic>? knight;
  bool isLoading = true;
  String? error;
  final KnightService _service = KnightService();

  @override
  void initState() {
    super.initState();
    _loadKnight();
  }

  Future<void> _loadKnight() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final knightData = await _service.getById(widget.knightId);
      if (knightData != null) {
        setState(() {
          knight = {
            'id': knightData.id,
            'name': knightData.name,
            'title': knightData.title,
            'faction_id': knightData.factionId,
            'level': knightData.level,
            'health': knightData.health,
            'max_health': knightData.maxHealth,
            'attack': knightData.attack,
            'defense': knightData.defense,
            'weapon_id': knightData.weaponId,
            'armor_id': knightData.armorId,
            'description': knightData.description,
            'lore': knightData.lore,
            'image_path': knightData.imagePath,
            'icon_path': knightData.iconPath,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Knight not found';
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

  Future<void> _deleteKnight() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm deletion'),
        content: const Text('Are you sure you want to delete this knight?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final deleted = await _service.delete(widget.knightId);
      if (deleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Knight deleted successfully')),
        );
        context.go('/knights');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Failed to delete knight'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
        title: Text(knight?['name'] ?? 'Knight'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/knights/${widget.knightId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteKnight,
            color: Colors.red,
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
              onPressed: _loadKnight,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (knight == null) {
      return const Center(child: Text('Knight not found'));
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
            if (knight!['lore'] != null) ...[
              const SizedBox(height: 24),
              _buildLore(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              knight!['name'] ?? '',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              knight!['title'] ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.getAccentGoldFromContext(context),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.getAccentGoldFromContext(context)),
              ),
              child: Text(
                'Level ${knight!['level'] ?? 0}',
                style: TextStyle(
                  color: AppTheme.getAccentGoldFromContext(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
            _StatRow(
              icon: Icons.favorite,
              label: 'Salute',
              value: '${knight!['health'] ?? 0} / ${knight!['max_health'] ?? 0}',
              color: AppTheme.accentCrimson,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.dangerous,
              label: 'Attacco',
              value: '${knight!['attack'] ?? 0}',
              color: AppTheme.getAccentGoldFromContext(context),
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.shield,
              label: 'Difesa',
              value: '${knight!['defense'] ?? 0}',
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
              knight!['description'] ?? '',
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
              knight!['lore'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
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

