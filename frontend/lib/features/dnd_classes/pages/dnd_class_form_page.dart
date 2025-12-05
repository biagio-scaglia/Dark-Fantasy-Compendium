import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/class_service.dart';
import '../../../data/models/class_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_picker_widget.dart';

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
  late TextEditingController _iconUrlController;
  bool _isLoading = false;
  final ClassService _service = ClassService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _hitDiceController = TextEditingController(text: '1d8');
    _hitPointsController = TextEditingController(text: '8');
    _spellcastingController = TextEditingController();
    _iconUrlController = TextEditingController();
    
    if (widget.dndClass != null && widget.dndClass!['id'] != null) {
      _loadClass();
    } else if (widget.dndClass != null) {
      _populateFields(widget.dndClass!);
    }
  }

  Future<void> _loadClass() async {
    try {
      final classData = await _service.getById(widget.dndClass!['id']);
      if (classData != null) {
        final data = {
          'id': classData.id,
          'name': classData.name,
          'description': classData.description,
          'hit_dice': classData.hitDice,
          'hit_points_at_1st_level': classData.hitPointsAt1stLevel,
          'hit_points_at_higher_levels': classData.hitPointsAtHigherLevels,
          'proficiencies': classData.proficiencies,
          'saving_throws': classData.savingThrows,
          'starting_equipment': classData.startingEquipment,
          'class_features': classData.classFeatures,
          'spellcasting_ability': classData.spellcastingAbility,
          'image_path': classData.imagePath,
          'icon_path': classData.iconPath,
        };
        _populateFields(data);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Class not found'), backgroundColor: Colors.red),
        );
      }
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
    _iconUrlController.text = classData['icon_path'] ?? classData['icon_url'] ?? '';
  }

  Future<void> _saveClass() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final classModel = ClassModel(
        id: widget.dndClass?['id'] ?? 0,
        name: _nameController.text,
        description: _descriptionController.text,
        hitDice: _hitDiceController.text,
        hitPointsAt1stLevel: int.tryParse(_hitPointsController.text) ?? 8,
        hitPointsAtHigherLevels: '1d8 (o 5) + modificatore di Costituzione',
        proficiencies: [],
        savingThrows: [],
        startingEquipment: [],
        classFeatures: [],
        spellcastingAbility: _spellcastingController.text.isEmpty ? null : _spellcastingController.text,
        iconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
      );

      if (widget.dndClass != null && widget.dndClass!['id'] != null) {
        final updated = await _service.update(classModel);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class updated successfully')),
          );
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update class'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(classModel);
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
    _iconUrlController.dispose();
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
            const SizedBox(height: 16),
            SvgIconPickerWidget(
              selectedIconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
              entityType: 'character',
              suggestedCategories: ['character', 'spell'],
              onIconSelected: (iconPath) {
                setState(() {
                  _iconUrlController.text = iconPath;
                });
              },
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

