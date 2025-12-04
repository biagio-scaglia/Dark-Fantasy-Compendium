import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/icon_picker_widget.dart';

class FactionFormPage extends StatefulWidget {
  final Map<String, dynamic>? faction;

  const FactionFormPage({super.key, this.faction});

  @override
  State<FactionFormPage> createState() => _FactionFormPageState();
}

class _FactionFormPageState extends State<FactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _loreController;
  late TextEditingController _colorController;
  late TextEditingController _imageUrlController;
  late TextEditingController _iconUrlController;
  bool _isLoading = false;
  bool _isLoadingData = false;
  Map<String, dynamic>? _factionData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _loreController = TextEditingController();
    _colorController = TextEditingController(text: '#8B0000');
    _imageUrlController = TextEditingController();
    _iconUrlController = TextEditingController();
    
    if (widget.faction != null && widget.faction!['id'] != null) {
      _loadFaction();
    } else if (widget.faction != null) {
      _populateFields(widget.faction!);
    }
  }

  Future<void> _loadFaction() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('factions', widget.faction!['id']);
      setState(() {
        _factionData = data;
        _populateFields(data);
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> faction) {
    _nameController.text = faction['name'] ?? '';
    _descriptionController.text = faction['description'] ?? '';
    _loreController.text = faction['lore'] ?? '';
    _colorController.text = faction['color'] ?? '#8B0000';
    _imageUrlController.text = faction['image_url'] ?? '';
    _iconUrlController.text = faction['icon_url'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _loreController.dispose();
    _colorController.dispose();
    _imageUrlController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'lore': _loreController.text.isEmpty ? null : _loreController.text,
        'color': _colorController.text,
        'image_url': _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        'icon_url': _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
      };

      final factionId = widget.faction?['id'] ?? _factionData?['id'];
      if (factionId != null) {
        await apiService.update('factions', factionId, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faction updated successfully')),
          );
          context.go('/factions/$factionId');
        }
      } else {
        final created = await apiService.create('factions', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faction created successfully')),
          );
          context.go('/factions/${created['id']}');
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
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Back',
          ),
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Indietro',
        ),
        title: Text(widget.faction != null ? 'Edit Faction' : 'New Faction'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 3,
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _loreController,
              decoration: const InputDecoration(labelText: 'Lore'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Color (e.g: #8B0000) *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 16),
            IconPickerWidget(
              selectedIconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
              suggestedCategories: ['entity', 'game', 'location'],
              onIconSelected: (iconPath) {
                setState(() {
                  _iconUrlController.text = iconPath;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.faction != null ? 'Update' : 'Create',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

