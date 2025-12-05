import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/ability_service.dart';
import '../../../data/models/ability.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_picker_widget.dart';

class AbilityFormPage extends StatefulWidget {
  final Map<String, dynamic>? ability;

  const AbilityFormPage({super.key, this.ability});

  @override
  State<AbilityFormPage> createState() => _AbilityFormPageState();
}

class _AbilityFormPageState extends State<AbilityFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _abilityTypeController;
  late TextEditingController _abilityScoreController;
  late TextEditingController _modifierController;
  late TextEditingController _iconUrlController;
  bool _proficiencyBonus = false;
  bool _isLoading = false;
  bool _isLoadingData = false;
  Map<String, dynamic>? _abilityData;
  final AbilityService _service = AbilityService();

  final List<String> _abilityTypes = ['skill', 'saving_throw', 'attack', 'other'];
  final List<String> _abilityScores = ['strength', 'dexterity', 'constitution', 'intelligence', 'wisdom', 'charisma'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _abilityTypeController = TextEditingController();
    _abilityScoreController = TextEditingController();
    _modifierController = TextEditingController(text: '0');
    _iconUrlController = TextEditingController();
    
    if (widget.ability != null && widget.ability!['id'] != null) {
      _loadAbility();
    } else if (widget.ability != null) {
      _populateFields(widget.ability!);
    }
  }

  Future<void> _loadAbility() async {
    setState(() => _isLoadingData = true);
    try {
      final abilityData = await _service.getById(widget.ability!['id']);
      if (abilityData != null) {
        final data = {
          'id': abilityData.id,
          'name': abilityData.name,
          'description': abilityData.description,
          'ability_type': abilityData.abilityType,
          'ability_score': abilityData.abilityScore,
          'modifier': abilityData.modifier,
          'proficiency_bonus': abilityData.proficiencyBonus,
          'image_path': abilityData.imagePath,
          'icon_path': abilityData.iconPath,
        };
        setState(() {
          _abilityData = data;
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ability not found'), backgroundColor: Colors.red),
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

  void _populateFields(Map<String, dynamic> ability) {
    _nameController.text = ability['name'] ?? '';
    _descriptionController.text = ability['description'] ?? '';
    _abilityTypeController.text = ability['ability_type'] ?? '';
    _abilityScoreController.text = ability['ability_score'] ?? '';
    _modifierController.text = ability['modifier']?.toString() ?? '0';
    _proficiencyBonus = ability['proficiency_bonus'] ?? false;
    _iconUrlController.text = ability['icon_path'] ?? ability['icon_url'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _abilityTypeController.dispose();
    _abilityScoreController.dispose();
    _modifierController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final ability = Ability(
        id: widget.ability?['id'] ?? _abilityData?['id'] ?? 0,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        abilityType: _abilityTypeController.text.isEmpty ? null : _abilityTypeController.text,
        abilityScore: _abilityScoreController.text.isEmpty ? null : _abilityScoreController.text,
        modifier: int.tryParse(_modifierController.text),
        proficiencyBonus: _proficiencyBonus,
        iconPath: _iconUrlController.text.isEmpty ? null : _iconUrlController.text,
      );

      final abilityId = widget.ability?['id'] ?? _abilityData?['id'];
      if (abilityId != null) {
        final updated = await _service.update(ability);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ability updated successfully')),
          );
          context.go('/abilities/$abilityId');
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update ability'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(ability);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ability created successfully')),
          );
          context.go('/abilities/${created.id}');
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
        title: Text(widget.ability != null ? 'Edit Ability' : 'New Ability'),
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
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _abilityTypes.contains(_abilityTypeController.text) ? _abilityTypeController.text : null,
              decoration: const InputDecoration(labelText: 'Ability Type'),
              items: _abilityTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ')),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _abilityTypeController.text = v ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _abilityScores.contains(_abilityScoreController.text) ? _abilityScoreController.text : null,
              decoration: const InputDecoration(labelText: 'Ability Score'),
              items: _abilityScores.map((score) {
                return DropdownMenuItem(
                  value: score,
                  child: Text(score[0].toUpperCase() + score.substring(1)),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _abilityScoreController.text = v ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modifierController,
              decoration: const InputDecoration(labelText: 'Modifier'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Proficiency Bonus'),
              value: _proficiencyBonus,
              onChanged: (v) {
                setState(() {
                  _proficiencyBonus = v ?? false;
                });
              },
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
                      widget.ability != null ? 'Update' : 'Create',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

