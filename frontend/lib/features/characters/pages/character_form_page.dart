import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/character_service.dart';
import '../../../data/services/class_service.dart';
import '../../../data/services/race_service.dart';
import '../../../data/models/character.dart';
import '../../../core/theme/app_theme.dart';

class CharacterFormPage extends StatefulWidget {
  final Map<String, dynamic>? character;

  const CharacterFormPage({super.key, this.character});

  @override
  State<CharacterFormPage> createState() => _CharacterFormPageState();
}

class _CharacterFormPageState extends State<CharacterFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _playerNameController;
  late TextEditingController _levelController;
  late TextEditingController _classIdController;
  late TextEditingController _raceIdController;
  late TextEditingController _backgroundController;
  late TextEditingController _alignmentController;
  late TextEditingController _strengthController;
  late TextEditingController _dexterityController;
  late TextEditingController _constitutionController;
  late TextEditingController _intelligenceController;
  late TextEditingController _wisdomController;
  late TextEditingController _charismaController;
  late TextEditingController _maxHpController;
  late TextEditingController _currentHpController;
  late TextEditingController _acController;
  late TextEditingController _xpController;
  late TextEditingController _notesController;
  late TextEditingController _backstoryController;
  
  List<dynamic> _classes = [];
  List<dynamic> _races = [];
  bool _isLoading = false;
  bool _isLoadingData = false;
  final CharacterService _service = CharacterService();
  final ClassService _classService = ClassService();
  final RaceService _raceService = RaceService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _playerNameController = TextEditingController();
    _levelController = TextEditingController(text: '1');
    _classIdController = TextEditingController();
    _raceIdController = TextEditingController();
    _backgroundController = TextEditingController();
    _alignmentController = TextEditingController();
    _strengthController = TextEditingController(text: '10');
    _dexterityController = TextEditingController(text: '10');
    _constitutionController = TextEditingController(text: '10');
    _intelligenceController = TextEditingController(text: '10');
    _wisdomController = TextEditingController(text: '10');
    _charismaController = TextEditingController(text: '10');
    _maxHpController = TextEditingController(text: '8');
    _currentHpController = TextEditingController(text: '8');
    _acController = TextEditingController(text: '10');
    _xpController = TextEditingController(text: '0');
    _notesController = TextEditingController();
    _backstoryController = TextEditingController();
    
    _loadOptions();
    
    if (widget.character != null && widget.character!['id'] != null) {
      _loadCharacter();
    } else if (widget.character != null) {
      _populateFields(widget.character!);
    }
  }

  Future<void> _loadOptions() async {
    try {
      final classes = await _classService.getAll();
      final races = await _raceService.getAll();
      setState(() {
        _classes = classes.map((c) => c.toJson()).toList();
        _races = races.map((r) => r.toJson()).toList();
        if (classes.isNotEmpty && _classIdController.text.isEmpty) {
          _classIdController.text = classes.first.id.toString();
        }
        if (races.isNotEmpty && _raceIdController.text.isEmpty) {
          _raceIdController.text = races.first.id.toString();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading options: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loadCharacter() async {
    setState(() => _isLoadingData = true);
    try {
      final characterData = await _service.getById(widget.character!['id']);
      if (characterData != null) {
        final data = characterData.toJson();
        setState(() {
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Character not found'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> character) {
    _nameController.text = character['name'] ?? '';
    final stats = character['stats'] as Map<String, dynamic>? ?? {};
    _playerNameController.text = stats['player_name'] ?? character['player_name'] ?? '';
    _levelController.text = character['level']?.toString() ?? '1';
    _classIdController.text = character['class_id']?.toString() ?? '';
    _raceIdController.text = character['race_id']?.toString() ?? '';
    _backgroundController.text = stats['background'] ?? character['background'] ?? '';
    _alignmentController.text = stats['alignment'] ?? character['alignment'] ?? '';
    _strengthController.text = stats['strength']?.toString() ?? character['strength']?.toString() ?? '10';
    _dexterityController.text = stats['dexterity']?.toString() ?? character['dexterity']?.toString() ?? '10';
    _constitutionController.text = stats['constitution']?.toString() ?? character['constitution']?.toString() ?? '10';
    _intelligenceController.text = stats['intelligence']?.toString() ?? character['intelligence']?.toString() ?? '10';
    _wisdomController.text = stats['wisdom']?.toString() ?? character['wisdom']?.toString() ?? '10';
    _charismaController.text = stats['charisma']?.toString() ?? character['charisma']?.toString() ?? '10';
    _maxHpController.text = stats['max_hit_points']?.toString() ?? character['max_hit_points']?.toString() ?? '8';
    _currentHpController.text = stats['current_hit_points']?.toString() ?? character['current_hit_points']?.toString() ?? '8';
    _acController.text = stats['armor_class']?.toString() ?? character['armor_class']?.toString() ?? '10';
    _xpController.text = stats['experience_points']?.toString() ?? character['experience_points']?.toString() ?? '0';
    _notesController.text = stats['notes'] ?? character['notes'] ?? '';
    _backstoryController.text = stats['backstory'] ?? character['backstory'] ?? '';
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final stats = {
        'player_name': _playerNameController.text.isEmpty ? null : _playerNameController.text,
        'background': _backgroundController.text.isEmpty ? null : _backgroundController.text,
        'alignment': _alignmentController.text.isEmpty ? null : _alignmentController.text,
        'strength': int.tryParse(_strengthController.text) ?? 10,
        'dexterity': int.tryParse(_dexterityController.text) ?? 10,
        'constitution': int.tryParse(_constitutionController.text) ?? 10,
        'intelligence': int.tryParse(_intelligenceController.text) ?? 10,
        'wisdom': int.tryParse(_wisdomController.text) ?? 10,
        'charisma': int.tryParse(_charismaController.text) ?? 10,
        'max_hit_points': int.tryParse(_maxHpController.text) ?? 8,
        'current_hit_points': int.tryParse(_currentHpController.text) ?? 8,
        'armor_class': int.tryParse(_acController.text) ?? 10,
        'experience_points': int.tryParse(_xpController.text) ?? 0,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'backstory': _backstoryController.text.isEmpty ? null : _backstoryController.text,
        'skill_proficiencies': [],
        'saving_throw_proficiencies': [],
        'tool_proficiencies': [],
        'weapon_proficiencies': [],
        'armor_proficiencies': [],
        'equipment': [],
        'weapons': [],
        'armors': [],
        'items': [],
        'known_spells': [],
        'prepared_spells': [],
        'spell_slots': {},
      };
      
      // Rimuovi valori nulli
      stats.removeWhere((key, value) => value == null);

      final character = Character(
        id: widget.character?['id'] ?? 0,
        name: _nameController.text,
        classId: _classIdController.text.isEmpty ? null : int.tryParse(_classIdController.text),
        raceId: _raceIdController.text.isEmpty ? null : int.tryParse(_raceIdController.text),
        level: int.tryParse(_levelController.text) ?? 1,
        stats: stats,
        description: null,
      );

      if (widget.character != null && widget.character!['id'] != null) {
        final updated = await _service.update(character);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Character updated!'), backgroundColor: Colors.green),
          );
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update character'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(character);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Character created!'), backgroundColor: Colors.green),
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
    _playerNameController.dispose();
    _levelController.dispose();
    _classIdController.dispose();
    _raceIdController.dispose();
    _backgroundController.dispose();
    _alignmentController.dispose();
    _strengthController.dispose();
    _dexterityController.dispose();
    _constitutionController.dispose();
    _intelligenceController.dispose();
    _wisdomController.dispose();
    _charismaController.dispose();
    _maxHpController.dispose();
    _currentHpController.dispose();
    _acController.dispose();
    _xpController.dispose();
    _notesController.dispose();
    _backstoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Character')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.character != null && widget.character!['id'] != null 
            ? 'Modifica Personaggio' 
            : 'Nuovo Personaggio'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _playerNameController,
              decoration: const InputDecoration(labelText: 'Player Name'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Level *'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final level = int.tryParse(v ?? '');
                      if (level == null || level < 1 || level > 20) {
                        return 'Level between 1 and 20';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _xpController,
                    decoration: const InputDecoration(labelText: 'XP'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _classes.isNotEmpty && _classIdController.text.isNotEmpty
                  ? int.tryParse(_classIdController.text)
                  : null,
              decoration: const InputDecoration(labelText: 'Classe *'),
              items: _classes.map((cls) {
                return DropdownMenuItem(
                  value: cls['id'] as int,
                  child: Text(cls['name'] ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _classIdController.text = value?.toString() ?? '';
                });
              },
              validator: (v) => v == null ? 'Seleziona una classe' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _races.isNotEmpty && _raceIdController.text.isNotEmpty
                  ? int.tryParse(_raceIdController.text)
                  : null,
              decoration: const InputDecoration(labelText: 'Razza *'),
              items: _races.map((race) {
                return DropdownMenuItem(
                  value: race['id'] as int,
                  child: Text(race['name'] ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _raceIdController.text = value?.toString() ?? '';
                });
              },
              validator: (v) => v == null ? 'Seleziona una razza' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _backgroundController,
              decoration: const InputDecoration(labelText: 'Background'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alignmentController,
              decoration: const InputDecoration(labelText: 'Allineamento'),
            ),
            const SizedBox(height: 24),
            const Text('Ability Scores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: _strengthController,
                  decoration: const InputDecoration(labelText: 'Forza'),
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(
                  controller: _dexterityController,
                  decoration: const InputDecoration(labelText: 'Destrezza'),
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: _constitutionController,
                  decoration: const InputDecoration(labelText: 'Costituzione'),
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(
                  controller: _intelligenceController,
                  decoration: const InputDecoration(labelText: 'Intelligenza'),
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: _wisdomController,
                  decoration: const InputDecoration(labelText: 'Saggezza'),
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(
                  controller: _charismaController,
                  decoration: const InputDecoration(labelText: 'Carisma'),
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Statistiche', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: _maxHpController,
                  decoration: const InputDecoration(labelText: 'HP Massimi'),
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(
                  controller: _currentHpController,
                  decoration: const InputDecoration(labelText: 'HP Correnti'),
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _acController,
              decoration: const InputDecoration(labelText: 'Classe Armatura (AC)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _backstoryController,
              decoration: const InputDecoration(labelText: 'Backstory'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCharacter,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.character != null && widget.character!['id'] != null
                      ? 'Salva Modifiche'
                      : 'Crea Personaggio'),
            ),
          ],
        ),
      ),
    );
  }
}

