import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/lore_service.dart';
import '../../../data/models/lore.dart';
import '../../../core/theme/app_theme.dart';

class LoreFormPage extends StatefulWidget {
  final Map<String, dynamic>? lore;

  const LoreFormPage({super.key, this.lore});

  @override
  State<LoreFormPage> createState() => _LoreFormPageState();
}

class _LoreFormPageState extends State<LoreFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _contentController;
  late TextEditingController _relatedEntityTypeController;
  late TextEditingController _relatedEntityIdController;
  bool _isLoading = false;
  bool _isLoadingData = false;
  final LoreService _service = LoreService();

  final List<String> _categories = ['history', 'legend', 'prophecy', 'tale', 'other'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _categoryController = TextEditingController();
    _contentController = TextEditingController();
    _relatedEntityTypeController = TextEditingController();
    _relatedEntityIdController = TextEditingController();
    
    if (widget.lore != null && widget.lore!['id'] != null) {
      _loadLore();
    } else if (widget.lore != null) {
      _populateFields(widget.lore!);
    }
  }

  Future<void> _loadLore() async {
    setState(() => _isLoadingData = true);
    try {
      final loreData = await _service.getById(widget.lore!['id']);
      if (loreData != null) {
        final data = {
          'id': loreData.id,
          'title': loreData.title,
          'category': loreData.category,
          'content': loreData.content,
          'related_entity_type': loreData.relatedEntityType,
          'related_entity_id': loreData.relatedEntityId,
          'image_path': loreData.imagePath,
        };
        setState(() {
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lore not found'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> lore) {
    _titleController.text = lore['title'] ?? '';
    _categoryController.text = lore['category'] ?? '';
    _contentController.text = lore['content'] ?? '';
    _relatedEntityTypeController.text = lore['related_entity_type'] ?? '';
    _relatedEntityIdController.text = lore['related_entity_id']?.toString() ?? '';
  }

  Future<void> _saveLore() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final lore = Lore(
        id: widget.lore?['id'] ?? 0,
        title: _titleController.text,
        category: _categoryController.text.isEmpty ? null : _categoryController.text,
        content: _contentController.text.isEmpty ? null : _contentController.text,
        relatedEntityType: _relatedEntityTypeController.text.isEmpty ? null : _relatedEntityTypeController.text,
        relatedEntityId: _relatedEntityIdController.text.isEmpty ? null : int.tryParse(_relatedEntityIdController.text),
      );

      if (widget.lore != null && widget.lore!['id'] != null) {
        final updated = await _service.update(lore);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lore updated!'), backgroundColor: Colors.green),
          );
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update lore'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(lore);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lore created!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    _relatedEntityTypeController.dispose();
    _relatedEntityIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lore')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.lore != null && widget.lore!['id'] != null 
            ? 'Edit Lore' 
            : 'New Lore'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _categories.contains(_categoryController.text) ? _categoryController.text : null,
              decoration: const InputDecoration(labelText: 'Category *'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoryController.text = value ?? '';
                });
              },
              validator: (v) => v == null ? 'Select a category' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content *'),
              maxLines: 8,
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _relatedEntityTypeController,
              decoration: const InputDecoration(
                labelText: 'Related Entity Type',
                hintText: 'e.g: knight, weapon, boss',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _relatedEntityIdController,
              decoration: const InputDecoration(
                labelText: 'Related Entity ID',
                hintText: 'Numeric ID',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveLore,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.lore != null && widget.lore!['id'] != null
                      ? 'Save Changes'
                      : 'Create Lore'),
            ),
          ],
        ),
      ),
    );
  }
}

