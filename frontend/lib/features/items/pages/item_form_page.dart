import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class ItemFormPage extends StatefulWidget {
  final Map<String, dynamic>? item;

  const ItemFormPage({super.key, this.item});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;
  late TextEditingController _effectController;
  late TextEditingController _valueController;
  late TextEditingController _loreController;
  String _selectedRarity = 'common';
  bool _isLoading = false;
  bool _isLoadingData = false;

  final List<String> _itemTypes = ['consumable', 'material', 'quest_item', 'equipment', 'other'];
  final List<String> _rarities = ['common', 'rare', 'epic', 'legendary'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _descriptionController = TextEditingController();
    _effectController = TextEditingController();
    _valueController = TextEditingController(text: '0');
    _loreController = TextEditingController();
    
    if (widget.item != null && widget.item!['id'] != null) {
      _loadItem();
    } else if (widget.item != null) {
      _populateFields(widget.item!);
    }
  }

  Future<void> _loadItem() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('items', widget.item!['id']);
      setState(() {
        _populateFields(data);
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> item) {
    _nameController.text = item['name'] ?? '';
    _typeController.text = item['type'] ?? '';
    _descriptionController.text = item['description'] ?? '';
    _effectController.text = item['effect'] ?? '';
    _valueController.text = item['value']?.toString() ?? '0';
    _loreController.text = item['lore'] ?? '';
    _selectedRarity = item['rarity'] ?? 'common';
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = {
        'name': _nameController.text,
        'type': _typeController.text,
        'description': _descriptionController.text,
        'effect': _effectController.text.isEmpty ? null : _effectController.text,
        'value': int.parse(_valueController.text),
        'rarity': _selectedRarity,
        'lore': _loreController.text.isEmpty ? null : _loreController.text,
      };

      if (widget.item != null && widget.item!['id'] != null) {
        await apiService.update('items', widget.item!['id'], data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      } else {
        await apiService.create('items', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item created!'), backgroundColor: Colors.green),
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
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _effectController.dispose();
    _valueController.dispose();
    _loreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.item != null && widget.item!['id'] != null 
            ? 'Edit Item' 
            : 'New Item'),
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
            DropdownButtonFormField<String>(
              value: _itemTypes.contains(_typeController.text) ? _typeController.text : null,
              decoration: const InputDecoration(labelText: 'Type *'),
              items: _itemTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _typeController.text = value ?? '';
                });
              },
              validator: (v) => v == null ? 'Select a type' : null,
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
              controller: _effectController,
              decoration: const InputDecoration(labelText: 'Effect'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Value'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRarity,
              decoration: const InputDecoration(labelText: 'Rarity'),
              items: _rarities.map((rarity) {
                return DropdownMenuItem(
                  value: rarity,
                  child: Text(rarity.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRarity = value ?? 'common';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _loreController,
              decoration: const InputDecoration(labelText: 'Lore'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.item != null && widget.item!['id'] != null
                      ? 'Save Changes'
                      : 'Create Item'),
            ),
          ],
        ),
      ),
    );
  }
}

