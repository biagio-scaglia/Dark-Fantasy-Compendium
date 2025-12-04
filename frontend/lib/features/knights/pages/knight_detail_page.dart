import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('knights', widget.knightId);
      setState(() {
        knight = data;
        isLoading = false;
      });
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
        title: const Text('Conferma eliminazione'),
        content: const Text('Sei sicuro di voler eliminare questo cavaliere?'),
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
      await apiService.delete('knights', widget.knightId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Knight deleted successfully')),
        );
        context.go('/knights');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: ${e.toString()}'),
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
        title: Text(knight?['name'] ?? 'Cavaliere'),
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
            Text('Errore: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadKnight,
              child: const Text('Riprova'),
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
                color: AppTheme.accentGold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accentGold),
              ),
              child: Text(
                'Livello ${knight!['level'] ?? 0}',
                style: const TextStyle(
                  color: AppTheme.accentGold,
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
              color: AppTheme.accentGold,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.shield,
              label: 'Difesa',
              value: '${knight!['defense'] ?? 0}',
              color: AppTheme.accentBrown,
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
              'Descrizione',
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
                const Icon(Icons.menu_book, color: AppTheme.accentGold),
                const SizedBox(width: 8),
                Text(
                  'Lore',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.accentGold,
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

