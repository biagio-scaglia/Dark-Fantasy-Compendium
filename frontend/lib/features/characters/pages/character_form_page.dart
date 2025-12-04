import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final classes = await apiService.getAll('dnd-classes');
      final races = await apiService.getAll('races');
      setState(() {
        _classes = classes;
        _races = races;
        if (classes.isNotEmpty && _classIdController.text.isEmpty) {
          _classIdController.text = classes.first['id'].toString();
        }
        if (races.isNotEmpty && _raceIdController.text.isEmpty) {
          _raceIdController.text = races.first['id'].toString();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel caricamento opzioni: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loadCharacter() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('characters', widget.character!['id']);
      setState(() {
        _populateFields(data);
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel caricamento: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> character) {
    _nameController.text = character['name'] ?? '';
    _playerNameController.text = character['player_name'] ?? '';
    _levelController.text = character['level']?.toString() ?? '1';
    _classIdController.text = character['class_id']?.toString() ?? '';
    _raceIdController.text = character['race_id']?.toString() ?? '';
    _backgroundController.text = character['background'] ?? '';
    _alignmentController.text = character['alignment'] ?? '';
    _strengthController.text = character['strength']?.toString() ?? '10';
    _dexterityController.text = character['dexterity']?.toString() ?? '10';
    _constitutionController.text = character['constitution']?.toString() ?? '10';
    _intelligenceController.text = character['intelligence']?.toString() ?? '10';
    _wisdomController.text = character['wisdom']?.toString() ?? '10';
    _charismaController.text = character['charisma']?.toString() ?? '10';
    _maxHpController.text = character['max_hit_points']?.toString() ?? '8';
    _currentHpController.text = character['current_hit_points']?.toString() ?? '8';
    _acController.text = character['armor_class']?.toString() ?? '10';
    _xpController.text = character['experience_points']?.toString() ?? '0';
    _notesController.text = character['notes'] ?? '';
    _backstoryController.text = character['backstory'] ?? '';
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = {
        'name': _nameController.text,
        'player_name': _playerNameController.text.isEmpty ? null : _playerNameController.text,
        'level': int.parse(_levelController.text),
        'class_id': int.parse(_classIdController.text),
        'race_id': int.parse(_raceIdController.text),
        'background': _backgroundController.text.isEmpty ? null : _backgroundController.text,
        'alignment': _alignmentController.text.isEmpty ? null : _alignmentController.text,
        'strength': int.parse(_strengthController.text),
        'dexterity': int.parse(_dexterityController.text),
        'constitution': int.parse(_constitutionController.text),
        'intelligence': int.parse(_intelligenceController.text),
        'wisdom': int.parse(_wisdomController.text),
        'charisma': int.parse(_charismaController.text),
        'max_hit_points': int.parse(_maxHpController.text),
        'current_hit_points': int.parse(_currentHpController.text),
        'armor_class': int.parse(_acController.text),
        'experience_points': int.parse(_xpController.text),
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

      if (widget.character != null && widget.character!['id'] != null) {
        await apiService.update('characters', widget.character!['id'], data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Personaggio aggiornato!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      } else {
        await apiService.create('characters', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Personaggio creato!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${e.toString()}'), backgroundColor: Colors.red),
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
        appBar: AppBar(title: const Text('Personaggio')),
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
              decoration: const InputDecoration(labelText: 'Nome *'),
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _playerNameController,
              decoration: const InputDecoration(labelText: 'Nome Giocatore'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Livello *'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final level = int.tryParse(v ?? '');
                      if (level == null || level < 1 || level > 20) {
                        return 'Livello tra 1 e 20';
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
                backgroundColor: AppTheme.accentGold,
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

