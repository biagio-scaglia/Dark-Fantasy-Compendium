import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/spell_service.dart';
import '../../../data/services/class_service.dart';
import '../../../data/models/spell.dart';
import '../../../data/models/class_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_picker_widget.dart';

class SpellFormPage extends StatefulWidget {
  final Map<String, dynamic>? spell;

  const SpellFormPage({super.key, this.spell});

  @override
  State<SpellFormPage> createState() => _SpellFormPageState();
}

class _SpellFormPageState extends State<SpellFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _levelController;
  late TextEditingController _schoolController;
  late TextEditingController _castingTimeController;
  late TextEditingController _rangeController;
  late TextEditingController _materialComponentsController;
  late TextEditingController _durationController;
  late TextEditingController _descriptionController;
  late TextEditingController _higherLevelController;
  late TextEditingController _componentsController;
  late TextEditingController _iconUrlController;
  bool _ritual = false;
  bool _concentration = false;
  bool _isLoading = false;
  bool _isLoadingData = false;
  Map<String, dynamic>? _spellData;
  final SpellService _service = SpellService();
  final ClassService _classService = ClassService();
  List<ClassModel> _allClasses = [];
  List<int> _selectedClassIds = [];

  final List<String> _schools = ['abjuration', 'conjuration', 'divination', 'enchantment', 'evocation', 'illusion', 'necromancy', 'transmutation'];
  final List<String> _components = ['V', 'S', 'M'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _levelController = TextEditingController(text: '1');
    _schoolController = TextEditingController();
    _castingTimeController = TextEditingController();
    _rangeController = TextEditingController();
    _materialComponentsController = TextEditingController();
    _durationController = TextEditingController();
    _descriptionController = TextEditingController();
    _higherLevelController = TextEditingController();
    _componentsController = TextEditingController();
    _iconUrlController = TextEditingController();
    
    _loadClasses();
    
    if (widget.spell != null && widget.spell!['id'] != null) {
      _loadSpell();
    } else if (widget.spell != null) {
      _populateFields(widget.spell!);
    }
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _classService.getAll();
      setState(() {
        _allClasses = classes;
      });
    } catch (e) {
      // Ignore error
    }
  }

  Future<void> _loadSpell() async {
    setState(() => _isLoadingData = true);
    try {
      final spellData = await _service.getById(widget.spell!['id']);
      if (spellData != null) {
        final data = {
          'id': spellData.id,
          'name': spellData.name,
          'level': spellData.level,
          'school': spellData.school,
          'casting_time': spellData.castingTime,
          'range': spellData.range,
          'components': spellData.components,
          'material_components': spellData.materialComponents,
          'duration': spellData.duration,
          'description': spellData.description,
          'higher_level': spellData.higherLevel,
          'allowed_class_ids': spellData.allowedClassIds,
          'ritual': spellData.ritual,
          'concentration': spellData.concentration,
          'image_path': spellData.imagePath,
          'icon_path': spellData.iconPath,
        };
        setState(() {
          _spellData = data;
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Spell not found'), backgroundColor: Colors.red),
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

  void _populateFields(Map<String, dynamic> spell) {
    _nameController.text = spell['name'] ?? '';
    _levelController.text = spell['level']?.toString() ?? '1';
    _schoolController.text = spell['school'] ?? '';
    _castingTimeController.text = spell['casting_time'] ?? '';
    _rangeController.text = spell['range'] ?? '';
    _materialComponentsController.text = spell['material_components'] ?? '';
    _durationController.text = spell['duration'] ?? '';
    _descriptionController.text = spell['description'] ?? '';
    _higherLevelController.text = spell['higher_level'] ?? '';
    _componentsController.text = (spell['components'] as List?)?.join(', ') ?? '';
    _ritual = spell['ritual'] ?? false;
    _concentration = spell['concentration'] ?? false;
    _iconUrlController.text = spell['icon_path'] ?? spell['icon_url'] ?? '';
    _selectedClassIds = (spell['allowed_class_ids'] as List?)?.cast<int>() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    _schoolController.dispose();
    _castingTimeController.dispose();
    _rangeController.dispose();
    _materialComponentsController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _higherLevelController.dispose();
    _componentsController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final components = _componentsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      
      final spell = Spell(
        id: widget.spell?['id'] ?? _spellData?['id'] ?? 0,
        name: _nameController.text,
        level: int.tryParse(_levelController.text) ?? 1,
        school: _schoolController.text.isEmpty ? null : _schoolController.text,
        castingTime: _castingTimeController.text.isEmpty ? null : _castingTimeController.text,
        range: _rangeController.text.isEmpty ? null : _rangeController.text,
        components: components.isEmpty ? null : components,
        materialComponents: _materialComponentsController.text.isEmpty ? null : _materialComponentsController.text,
        duration: _durationController.text.isEmpty ? null : _durationController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        higherLevel: _higherLevelController.text.isEmpty ? null : _higherLevelController.text,
        allowedClassIds: _selectedClassIds.isEmpty ? null : _selectedClassIds,
        ritual: _ritual,
        concentration: _concentration,
        iconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
      );

      final spellId = widget.spell?['id'] ?? _spellData?['id'];
      if (spellId != null) {
        final updated = await _service.update(spell);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Spell updated successfully')),
          );
          context.go('/spells/$spellId');
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update spell'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(spell);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Spell created successfully')),
          );
          context.go('/spells/${created.id}');
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
          tooltip: 'Back',
        ),
        title: Text(widget.spell != null ? 'Edit Spell' : 'New Spell'),
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Level *'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _schools.contains(_schoolController.text) ? _schoolController.text : null,
                    decoration: const InputDecoration(labelText: 'School'),
                    items: _schools.map((school) {
                      return DropdownMenuItem(
                        value: school,
                        child: Text(school[0].toUpperCase() + school.substring(1)),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        _schoolController.text = v ?? '';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _castingTimeController,
              decoration: const InputDecoration(labelText: 'Casting Time'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rangeController,
              decoration: const InputDecoration(labelText: 'Range'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _componentsController,
              decoration: const InputDecoration(
                labelText: 'Components (V, S, M - comma separated)',
                hintText: 'V, S, M',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _materialComponentsController,
              decoration: const InputDecoration(labelText: 'Material Components'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Ritual'),
                    value: _ritual,
                    onChanged: (v) {
                      setState(() {
                        _ritual = v ?? false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Concentration'),
                    value: _concentration,
                    onChanged: (v) {
                      setState(() {
                        _concentration = v ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _higherLevelController,
              decoration: const InputDecoration(labelText: 'At Higher Level'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Allowed Classes'),
              subtitle: Text(_selectedClassIds.isEmpty ? 'No classes selected' : '${_selectedClassIds.length} classes selected'),
              children: _allClasses.map((classModel) {
                final isSelected = _selectedClassIds.contains(classModel.id);
                return CheckboxListTile(
                  title: Text(classModel.name),
                  value: isSelected,
                  onChanged: (v) {
                    setState(() {
                      if (v ?? false) {
                        _selectedClassIds.add(classModel.id);
                      } else {
                        _selectedClassIds.remove(classModel.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SvgIconPickerWidget(
              selectedIconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
              onIconSelected: (iconPath) {
                setState(() {
                  if (iconPath.isNotEmpty && !iconPath.startsWith('assets/')) {
                    _iconUrlController.text = iconPath;
                  } else if (iconPath.isNotEmpty) {
                    final parts = iconPath.split('/');
                    _iconUrlController.text = parts.last;
                  } else {
                    _iconUrlController.text = '';
                  }
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
                      widget.spell != null ? 'Update' : 'Create',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

