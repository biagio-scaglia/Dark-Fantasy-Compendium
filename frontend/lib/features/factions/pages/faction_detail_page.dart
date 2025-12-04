import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/faction_service.dart';
import '../../../data/models/faction.dart';
import '../../../core/theme/app_theme.dart';

class FactionDetailPage extends StatefulWidget {
  final int factionId;

  const FactionDetailPage({super.key, required this.factionId});

  @override
  State<FactionDetailPage> createState() => _FactionDetailPageState();
}

class _FactionDetailPageState extends State<FactionDetailPage> {
  Map<String, dynamic>? faction;
  bool isLoading = true;
  String? error;
  final FactionService _service = FactionService();

  @override
  void initState() {
    super.initState();
    _loadFaction();
  }

  Future<void> _loadFaction() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final factionData = await _service.getById(widget.factionId);
      if (factionData != null) {
        setState(() {
          faction = {
            'id': factionData.id,
            'name': factionData.name,
            'description': factionData.description,
            'lore': factionData.lore,
            'color': factionData.color,
            'image_path': factionData.imagePath,
            'icon_path': factionData.iconPath,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Faction not found';
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

  Color _parseColor(String? colorString) {
    if (colorString == null) return AppTheme.getAccentGoldFromContext(context);
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTheme.getAccentGoldFromContext(context);
    }
  }

  Future<void> _deleteFaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm deletion'),
        content: const Text('Are you sure you want to delete this faction?'),
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
      final deleted = await _service.delete(widget.factionId);
      if (deleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faction deleted successfully')),
        );
        context.go('/factions');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Failed to delete faction'),
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
          tooltip: 'Indietro',
        ),
        title: Text(faction?['name'] ?? 'Faction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/factions/${widget.factionId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteFaction,
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

    if (error != null || faction == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error ?? "Faction not found"}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFaction,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final factionColor = _parseColor(faction!['color']);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(factionColor),
            const SizedBox(height: 24),
            _buildDescription(),
            if (faction!['lore'] != null) ...[
              const SizedBox(height: 24),
              _buildLore(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color factionColor) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              factionColor.withOpacity(0.3),
              AppTheme.getSecondaryBackgroundFromContext(context),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: factionColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: factionColor, width: 2),
                    ),
                    child: Icon(
                      Icons.group,
                      size: 30,
                      color: factionColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      faction!['name'] ?? '',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: factionColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              faction!['description'] ?? '',
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
              faction!['lore'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

