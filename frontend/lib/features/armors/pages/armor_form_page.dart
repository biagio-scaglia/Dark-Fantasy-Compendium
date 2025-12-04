import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/armor_service.dart';
import '../../../data/models/armor.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/icon_picker_widget.dart';

class ArmorFormPage extends StatefulWidget {
  final Map<String, dynamic>? armor;

  const ArmorFormPage({super.key, this.armor});

  @override
  State<ArmorFormPage> createState() => _ArmorFormPageState();
}

class _ArmorFormPageState extends State<ArmorFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _defenseBonusController;
  late TextEditingController _durabilityController;
  late TextEditingController _rarityController;
  late TextEditingController _descriptionController;
  late TextEditingController _loreController;
  late TextEditingController _imageUrlController;
  late TextEditingController _iconUrlController;
  bool _isLoading = false;
  bool _isLoadingData = false;
  Map<String, dynamic>? _armorData;
  final ArmorService _service = ArmorService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _defenseBonusController = TextEditingController(text: '0');
    _durabilityController = TextEditingController(text: '100');
    _rarityController = TextEditingController(text: 'common');
    _descriptionController = TextEditingController();
    _loreController = TextEditingController();
    _imageUrlController = TextEditingController();
    _iconUrlController = TextEditingController();
    
    if (widget.armor != null && widget.armor!['id'] != null) {
      _loadArmor();
    } else if (widget.armor != null) {
      _populateFields(widget.armor!);
    }
  }

  Future<void> _loadArmor() async {
    setState(() => _isLoadingData = true);
    try {
      final armorData = await _service.getById(widget.armor!['id']);
      if (armorData != null) {
        final data = {
          'id': armorData.id,
          'name': armorData.name,
          'type': armorData.type,
          'defense_bonus': armorData.defenseBonus,
          'durability': armorData.durability,
          'rarity': armorData.rarity,
          'description': armorData.description,
          'lore': armorData.lore,
          'image_path': armorData.imagePath,
          'icon_path': armorData.iconPath,
        };
        setState(() {
          _armorData = data;
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Armor not found'), backgroundColor: Colors.red),
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

  void _populateFields(Map<String, dynamic> armor) {
    _nameController.text = armor['name'] ?? '';
    _typeController.text = armor['type'] ?? '';
    _defenseBonusController.text = armor['defense_bonus']?.toString() ?? '0';
    _durabilityController.text = armor['durability']?.toString() ?? '100';
    _rarityController.text = armor['rarity'] ?? 'common';
    _descriptionController.text = armor['description'] ?? '';
    _loreController.text = armor['lore'] ?? '';
    _imageUrlController.text = armor['image_path'] ?? armor['image_url'] ?? '';
    _iconUrlController.text = armor['icon_path'] ?? armor['icon_url'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _defenseBonusController.dispose();
    _durabilityController.dispose();
    _rarityController.dispose();
    _descriptionController.dispose();
    _loreController.dispose();
    _imageUrlController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final armor = Armor(
        id: widget.armor?['id'] ?? _armorData?['id'] ?? 0,
        name: _nameController.text,
        type: _typeController.text,
        defenseBonus: int.tryParse(_defenseBonusController.text) ?? 0,
        durability: int.tryParse(_durabilityController.text) ?? 100,
        rarity: _rarityController.text,
        description: _descriptionController.text,
        lore: _loreController.text.isEmpty ? null : _loreController.text,
        imagePath: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        iconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
      );

      final armorId = widget.armor?['id'] ?? _armorData?['id'];
      if (armorId != null) {
        final updated = await _service.update(armor);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Armor updated successfully')),
          );
          context.go('/armors/$armorId');
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update armor'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(armor);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Armor created successfully')),
          );
          context.go('/armors/${created.id}');
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
        title: Text(widget.armor != null ? 'Edit Armor' : 'New Armor'),
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
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _defenseBonusController,
                    decoration: const InputDecoration(labelText: 'Defense Bonus'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _durabilityController,
                    decoration: const InputDecoration(labelText: 'Durability'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _rarityController.text.isEmpty ? 'common' : _rarityController.text,
              decoration: const InputDecoration(labelText: 'Rarity'),
              items: ['common', 'rare', 'epic', 'legendary']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase())))
                  .toList(),
              onChanged: (v) => _rarityController.text = v ?? 'common',
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
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 16),
            IconPickerWidget(
              selectedIconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
              suggestedCategories: ['entity', 'weapon'],
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
                      widget.armor != null ? 'Update' : 'Create',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

