import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/lore_service.dart';
import '../../../data/models/lore.dart';
import '../../../core/theme/app_theme.dart';

class LoreDetailPage extends StatefulWidget {
  final int loreId;

  const LoreDetailPage({super.key, required this.loreId});

  @override
  State<LoreDetailPage> createState() => _LoreDetailPageState();
}

class _LoreDetailPageState extends State<LoreDetailPage> {
  Map<String, dynamic>? lore;
  bool isLoading = true;
  String? error;
  final LoreService _service = LoreService();

  @override
  void initState() {
    super.initState();
    _loadLore();
  }

  Future<void> _loadLore() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loreData = await _service.getById(widget.loreId);
      if (loreData != null) {
        setState(() {
          lore = {
            'id': loreData.id,
            'title': loreData.title,
            'category': loreData.category,
            'content': loreData.content,
            'related_entity_type': loreData.relatedEntityType,
            'related_entity_id': loreData.relatedEntityId,
            'image_path': loreData.imagePath,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Lore not found';
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
        title: Text(lore?['title'] ?? 'Lore'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null || lore == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error ?? "Lore not found"}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLore,
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
            _buildContent(),
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
              lore!['title'] ?? '',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.getAccentGoldFromContext(context)),
              ),
              child: Text(
                lore!['category'] ?? '',
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

  Widget _buildContent() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: AppTheme.getAccentGoldFromContext(context), size: 28),
                const SizedBox(width: 12),
                Text(
                  'Content',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.getAccentGoldFromContext(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              lore!['content'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

