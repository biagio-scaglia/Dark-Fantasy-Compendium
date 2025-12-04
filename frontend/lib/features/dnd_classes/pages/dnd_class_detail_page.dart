import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dnd_class_form_page.dart';

class DndClassDetailPage extends StatefulWidget {
  final int classId;

  const DndClassDetailPage({super.key, required this.classId});

  @override
  State<DndClassDetailPage> createState() => _DndClassDetailPageState();
}

class _DndClassDetailPageState extends State<DndClassDetailPage> {
  Map<String, dynamic>? dndClass;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadClass();
  }

  Future<void> _loadClass() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('dnd-classes', widget.classId);
      if (mounted) {
        setState(() {
          dndClass = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteClass() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm deletion'),
        content: const Text('Are you sure you want to delete this class?'),
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
      final apiService = Provider.of<ApiService>(context, listen: false);
      await apiService.delete('dnd-classes', widget.classId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Class deleted successfully')),
        );
        context.go('/dnd-classes');
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
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('D&D Class')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || dndClass == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('D&D Class')),
        body: Center(child: Text('Error: ${error ?? "Class not found"}')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(dndClass!['name'] ?? 'Classe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/dnd-classes/${widget.classId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteClass,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dndClass!['name'] ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              dndClass!['description'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _buildInfoSection(),
            if (dndClass!['proficiencies'] != null && (dndClass!['proficiencies'] as List).isNotEmpty)
              _buildListSection('Competenze', dndClass!['proficiencies']),
            if (dndClass!['class_features'] != null && (dndClass!['class_features'] as List).isNotEmpty)
              _buildListSection('Caratteristiche', dndClass!['class_features']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dndClass!['hit_dice'] != null)
              _buildInfoRow(
                icon: FontAwesomeIcons.dice,
                label: 'Hit Dice',
                value: dndClass!['hit_dice'],
              ),
            if (dndClass!['hit_points_at_1st_level'] != null)
              _buildInfoRow(
                icon: FontAwesomeIcons.heart,
                label: 'Hit Points at 1st Level',
                value: '${dndClass!['hit_points_at_1st_level']}',
              ),
            if (dndClass!['spellcasting_ability'] != null)
              _buildInfoRow(
                icon: FontAwesomeIcons.wandMagicSparkles,
                label: 'Caratteristica Incantesimi',
                value: dndClass!['spellcasting_ability'],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: AppTheme.getAccentGoldFromContext(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondaryFromContext(context),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            leading: FaIcon(FontAwesomeIcons.check, size: 16, color: AppTheme.getAccentGoldFromContext(context)),
            title: Text(item.toString()),
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}

