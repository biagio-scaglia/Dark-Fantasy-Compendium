import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class WeaponDetailPage extends StatefulWidget {
  final int weaponId;

  const WeaponDetailPage({super.key, required this.weaponId});

  @override
  State<WeaponDetailPage> createState() => _WeaponDetailPageState();
}

class _WeaponDetailPageState extends State<WeaponDetailPage> {
  Map<String, dynamic>? weapon;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWeapon();
  }

  Future<void> _loadWeapon() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('weapons', widget.weaponId);
      setState(() {
        weapon = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteWeapon() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: const Text('Are you sure you want to delete this weapon?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      await apiService.delete('weapons', widget.weaponId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Weapon deleted successfully')),
        );
        context.go('/weapons');
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
          tooltip: 'Indietro',
        ),
        title: Text(weapon?['name'] ?? 'Weapon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/weapons/${widget.weaponId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteWeapon,
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

    if (error != null || weapon == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error ?? "Weapon not found"}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWeapon,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final rarity = weapon!['rarity'] ?? 'common';
    final rarityColor = AppTheme.getRarityColor(rarity);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(rarity, rarityColor),
            const SizedBox(height: 12),
            _buildStats(),
            const SizedBox(height: 12),
            _buildDescription(),
            if (weapon!['lore'] != null) ...[
              const SizedBox(height: 12),
              _buildLore(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String rarity, Color rarityColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                weapon!['name'] ?? '',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: rarityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: rarityColor),
              ),
              child: Text(
                rarity.toUpperCase(),
                style: TextStyle(
                  color: rarityColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          weapon!['type'] ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiche',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _StatRow(
          icon: Icons.trending_up,
          label: 'Bonus Attacco',
          value: '+${weapon!['attack_bonus'] ?? 0}',
          color: AppTheme.accentGold,
        ),
        const SizedBox(height: 8),
        _StatRow(
          icon: Icons.build,
          label: 'Durabilità',
          value: '${weapon!['durability'] ?? 0}%',
          color: AppTheme.textSecondary,
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrizione',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          weapon!['description'] ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildLore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book, size: 18, color: AppTheme.accentGold),
            const SizedBox(width: 6),
            Text(
              'Lore',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          weapon!['lore'] ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
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
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

