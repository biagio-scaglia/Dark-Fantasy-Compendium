import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/faction_service.dart';
import '../../../data/models/faction.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_picker_widget.dart';

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
  final FactionService _service = FactionService();

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
      final factionData = await _service.getById(widget.faction!['id']);
      if (factionData != null) {
        final data = {
          'id': factionData.id,
          'name': factionData.name,
          'description': factionData.description,
          'lore': factionData.lore,
          'color': factionData.color,
          'image_path': factionData.imagePath,
          'icon_path': factionData.iconPath,
        };
        setState(() {
          _factionData = data;
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faction not found'), backgroundColor: Colors.red),
          );
        }
      }
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
    _imageUrlController.text = faction['image_path'] ?? faction['image_url'] ?? '';
    _iconUrlController.text = faction['icon_path'] ?? faction['icon_url'] ?? '';
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
      final faction = Faction(
        id: widget.faction?['id'] ?? _factionData?['id'] ?? 0,
        name: _nameController.text,
        description: _descriptionController.text,
        lore: _loreController.text.isEmpty ? null : _loreController.text,
        color: _colorController.text,
        imagePath: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        iconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
      );

      final factionId = widget.faction?['id'] ?? _factionData?['id'];
      if (factionId != null) {
        final updated = await _service.update(faction);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faction updated successfully')),
          );
          context.go('/factions/$factionId');
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update faction'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(faction);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faction created successfully')),
          );
          context.go('/factions/${created.id}');
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
            SvgIconPickerWidget(
              selectedIconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
              entityType: 'faction',
              suggestedCategories: ['faction', 'location'],
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

