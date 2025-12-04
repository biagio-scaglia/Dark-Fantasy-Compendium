import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';

class DndClassFormPage extends StatefulWidget {
  final Map<String, dynamic>? dndClass;

  const DndClassFormPage({super.key, this.dndClass});

  @override
  State<DndClassFormPage> createState() => _DndClassFormPageState();
}

class _DndClassFormPageState extends State<DndClassFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _hitDiceController;
  late TextEditingController _hitPointsController;
  late TextEditingController _spellcastingController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _hitDiceController = TextEditingController(text: '1d8');
    _hitPointsController = TextEditingController(text: '8');
    _spellcastingController = TextEditingController();
    
    if (widget.dndClass != null && widget.dndClass!['id'] != null) {
      _loadClass();
    } else if (widget.dndClass != null) {
      _populateFields(widget.dndClass!);
    }
  }

  Future<void> _loadClass() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('dnd-classes', widget.dndClass!['id']);
      _populateFields(data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> classData) {
    _nameController.text = classData['name'] ?? '';
    _descriptionController.text = classData['description'] ?? '';
    _hitDiceController.text = classData['hit_dice'] ?? '1d8';
    _hitPointsController.text = classData['hit_points_at_1st_level']?.toString() ?? '8';
    _spellcastingController.text = classData['spellcasting_ability'] ?? '';
  }

  Future<void> _saveClass() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final classData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'hit_dice': _hitDiceController.text,
        'hit_points_at_1st_level': int.parse(_hitPointsController.text),
        'hit_points_at_higher_levels': '1d8 (o 5) + modificatore di Costituzione',
        'proficiencies': [],
        'saving_throws': [],
        'starting_equipment': [],
        'class_features': [],
        'spellcasting_ability': _spellcastingController.text.isEmpty ? null : _spellcastingController.text,
      };

      if (widget.dndClass != null && widget.dndClass!['id'] != null) {
        await apiService.update('dnd-classes', widget.dndClass!['id'], classData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class updated successfully')),
          );
          context.pop();
        }
      } else {
        await apiService.create('dnd-classes', classData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class created successfully')),
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
    _descriptionController.dispose();
    _hitDiceController.dispose();
    _hitPointsController.dispose();
    _spellcastingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.dndClass != null && widget.dndClass!['id'] != null ? 'Modifica Classe' : 'Nuova Classe'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 5,
              validator: (value) => value?.isEmpty ?? true ? 'Enter a description' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hitDiceController,
                    decoration: const InputDecoration(labelText: 'Hit Dice *'),
                    validator: (value) => value?.isEmpty ?? true ? 'Enter hit dice' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _hitPointsController,
                    decoration: const InputDecoration(labelText: 'HP at 1st Level *'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Enter hit points' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _spellcastingController,
              decoration: const InputDecoration(labelText: 'Caratteristica Incantesimi (opzionale)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveClass,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }
}

