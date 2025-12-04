import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class WeaponFormPage extends StatefulWidget {
  final Map<String, dynamic>? weapon;

  const WeaponFormPage({super.key, this.weapon});

  @override
  State<WeaponFormPage> createState() => _WeaponFormPageState();
}

class _WeaponFormPageState extends State<WeaponFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _attackBonusController;
  late TextEditingController _durabilityController;
  late TextEditingController _rarityController;
  late TextEditingController _descriptionController;
  late TextEditingController _loreController;
  late TextEditingController _imageUrlController;
  late TextEditingController _iconUrlController;
  bool _isLoading = false;
  bool _isLoadingData = false;
  Map<String, dynamic>? _weaponData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _attackBonusController = TextEditingController(text: '0');
    _durabilityController = TextEditingController(text: '100');
    _rarityController = TextEditingController(text: 'common');
    _descriptionController = TextEditingController();
    _loreController = TextEditingController();
    _imageUrlController = TextEditingController();
    _iconUrlController = TextEditingController();
    
    if (widget.weapon != null && widget.weapon!['id'] != null) {
      _loadWeapon();
    } else if (widget.weapon != null) {
      _populateFields(widget.weapon!);
    }
  }

  Future<void> _loadWeapon() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('weapons', widget.weapon!['id']);
      setState(() {
        _weaponData = data;
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

  void _populateFields(Map<String, dynamic> weapon) {
    _nameController.text = weapon['name'] ?? '';
    _typeController.text = weapon['type'] ?? '';
    _attackBonusController.text = weapon['attack_bonus']?.toString() ?? '0';
    _durabilityController.text = weapon['durability']?.toString() ?? '100';
    _rarityController.text = weapon['rarity'] ?? 'common';
    _descriptionController.text = weapon['description'] ?? '';
    _loreController.text = weapon['lore'] ?? '';
    _imageUrlController.text = weapon['image_url'] ?? '';
    _iconUrlController.text = weapon['icon_url'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _attackBonusController.dispose();
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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = {
        'name': _nameController.text,
        'type': _typeController.text,
        'attack_bonus': int.tryParse(_attackBonusController.text) ?? 0,
        'durability': int.tryParse(_durabilityController.text) ?? 100,
        'rarity': _rarityController.text,
        'description': _descriptionController.text,
        'lore': _loreController.text.isEmpty ? null : _loreController.text,
        'image_url': _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        'icon_url': _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
      };

      final weaponId = widget.weapon?['id'] ?? _weaponData?['id'];
      if (weaponId != null) {
        await apiService.update('weapons', weaponId, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Weapon updated successfully')),
          );
          context.go('/weapons/$weaponId');
        }
      } else {
        final created = await apiService.create('weapons', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Weapon created successfully')),
          );
          context.go('/weapons/${created['id']}');
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
        title: Text(widget.weapon != null ? 'Edit Weapon' : 'New Weapon'),
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
                    controller: _attackBonusController,
                    decoration: const InputDecoration(labelText: 'Attack Bonus'),
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
            TextFormField(
              controller: _iconUrlController,
              decoration: const InputDecoration(labelText: 'Icon URL'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.accentGold,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                 : Text(
                      widget.weapon != null ? 'Update' : 'Create'),
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

