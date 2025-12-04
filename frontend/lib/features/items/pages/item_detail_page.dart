import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/item_service.dart';
import '../../../data/models/item.dart';
import '../../../core/theme/app_theme.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  const ItemDetailPage({super.key, required this.itemId});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  Map<String, dynamic>? item;
  bool isLoading = true;
  String? error;
  final ItemService _service = ItemService();

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  Future<void> _loadItem() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final itemData = await _service.getById(widget.itemId);
      if (itemData != null) {
        setState(() {
          item = {
            'id': itemData.id,
            'name': itemData.name,
            'type': itemData.type,
            'description': itemData.description,
            'effect': itemData.effect,
            'value': itemData.value,
            'rarity': itemData.rarity,
            'lore': itemData.lore,
            'owner_id': itemData.ownerId,
            'image_path': itemData.imagePath,
            'icon_path': itemData.iconPath,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Item not found';
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
          tooltip: 'Indietro',
        ),
        title: Text(item?['name'] ?? 'Oggetto'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null || item == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error ?? "Item not found"}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadItem,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final rarity = item!['rarity'] ?? 'common';
    final rarityColor = AppTheme.getRarityColor(rarity);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(rarity, rarityColor),
            const SizedBox(height: 24),
            _buildInfo(),
            const SizedBox(height: 24),
            _buildDescription(),
            if (item!['lore'] != null) ...[
              const SizedBox(height: 24),
              _buildLore(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String rarity, Color rarityColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item!['name'] ?? '',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: rarityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: rarityColor),
                  ),
                  child: Text(
                    rarity.toUpperCase(),
                    style: TextStyle(
                      color: rarityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item!['type'] ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informazioni',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (item!['effect'] != null)
              _InfoRow(
                icon: Icons.auto_awesome,
                label: 'Effetto',
                value: item!['effect'] ?? '',
                color: AppTheme.getAccentGoldFromContext(context),
              ),
            if (item!['value'] != null && item!['value'] > 0) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.monetization_on,
                label: 'Valore',
                value: '${item!['value']}',
                color: AppTheme.getAccentGoldFromContext(context),
              ),
            ],
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
              item!['description'] ?? '',
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
              item!['lore'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
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

