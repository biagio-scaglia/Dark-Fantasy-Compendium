import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/character_service.dart';
import '../../../data/services/class_service.dart';
import '../../../data/services/race_service.dart';
import '../../../data/models/character.dart';
import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_animations.dart';
import '../../../core/theme/app_theme_constants.dart';
import '../../../widgets/animated_button.dart';

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
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    final brightness = Theme.of(context).brightness;
    final isEdit = widget.character != null && widget.character!['id'] != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(isEdit ? 'Edit Character' : 'New Character'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppThemeConstants.spacing16),
          children: [
            // Basic Information Section
            AppAnimations.fadeSlideIn(
              duration: AppAnimations.medium,
              offset: const Offset(0, 20),
              child: _buildSectionCard(
                context,
                title: 'Basic Information',
                icon: Icons.person,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
                  ),
                  SizedBox(height: AppThemeConstants.spacing16),
                  TextFormField(
                    controller: _playerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Player Name',
                      prefixIcon: Icon(Icons.people),
                    ),
                  ),
                  SizedBox(height: AppThemeConstants.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _levelController,
                          decoration: const InputDecoration(
                            labelText: 'Level *',
                            prefixIcon: Icon(Icons.trending_up),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            final level = int.tryParse(v ?? '');
                            if (level == null || level < 1 || level > 20) {
                              return 'Level 1-20';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: AppThemeConstants.spacing16),
                      Expanded(
                        child: TextFormField(
                          controller: _xpController,
                          decoration: const InputDecoration(
                            labelText: 'Experience Points',
                            prefixIcon: Icon(Icons.star),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppThemeConstants.spacing16),
            // Class & Race Section
            AppAnimations.fadeSlideIn(
              duration: AppAnimations.medium,
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 100),
              child: _buildSectionCard(
                context,
                title: 'Class & Race',
                icon: Icons.category,
                children: [
                  DropdownButtonFormField<int>(
                    value: _classes.isNotEmpty && _classIdController.text.isNotEmpty
                        ? int.tryParse(_classIdController.text)
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Class *',
                      prefixIcon: Icon(Icons.class_),
                    ),
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
                    validator: (v) => v == null ? 'Select a class' : null,
                  ),
                  SizedBox(height: AppThemeConstants.spacing16),
                  DropdownButtonFormField<int>(
                    value: _races.isNotEmpty && _raceIdController.text.isNotEmpty
                        ? int.tryParse(_raceIdController.text)
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Race *',
                      prefixIcon: Icon(Icons.face),
                    ),
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
                    validator: (v) => v == null ? 'Select a race' : null,
                  ),
                  SizedBox(height: AppThemeConstants.spacing16),
                  TextFormField(
                    controller: _backgroundController,
                    decoration: const InputDecoration(
                      labelText: 'Background',
                      prefixIcon: Icon(Icons.history_edu),
                    ),
                  ),
                  SizedBox(height: AppThemeConstants.spacing16),
                  TextFormField(
                    controller: _alignmentController,
                    decoration: const InputDecoration(
                      labelText: 'Alignment',
                      prefixIcon: Icon(Icons.balance),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppThemeConstants.spacing16),
            // Ability Scores Section
            AppAnimations.fadeSlideIn(
              duration: AppAnimations.medium,
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 200),
              child: _buildSectionCard(
                context,
                title: 'Ability Scores',
                icon: Icons.fitness_center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _strengthController,
                          decoration: const InputDecoration(
                            labelText: 'Strength',
                            prefixIcon: Icon(Icons.bolt),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: AppThemeConstants.spacing8),
                      Expanded(
                        child: TextFormField(
                          controller: _dexterityController,
                          decoration: const InputDecoration(
                            labelText: 'Dexterity',
                            prefixIcon: Icon(Icons.speed),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppThemeConstants.spacing8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _constitutionController,
                          decoration: const InputDecoration(
                            labelText: 'Constitution',
                            prefixIcon: Icon(Icons.favorite),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: AppThemeConstants.spacing8),
                      Expanded(
                        child: TextFormField(
                          controller: _intelligenceController,
                          decoration: const InputDecoration(
                            labelText: 'Intelligence',
                            prefixIcon: Icon(Icons.lightbulb),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppThemeConstants.spacing8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _wisdomController,
                          decoration: const InputDecoration(
                            labelText: 'Wisdom',
                            prefixIcon: Icon(Icons.auto_awesome),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: AppThemeConstants.spacing8),
                      Expanded(
                        child: TextFormField(
                          controller: _charismaController,
                          decoration: const InputDecoration(
                            labelText: 'Charisma',
                            prefixIcon: Icon(Icons.chat_bubble),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppThemeConstants.spacing16),
            // Statistics Section
            AppAnimations.fadeSlideIn(
              duration: AppAnimations.medium,
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 300),
              child: _buildSectionCard(
                context,
                title: 'Statistics',
                icon: Icons.bar_chart,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _maxHpController,
                          decoration: const InputDecoration(
                            labelText: 'Max HP',
                            prefixIcon: Icon(Icons.favorite),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: AppThemeConstants.spacing8),
                      Expanded(
                        child: TextFormField(
                          controller: _currentHpController,
                          decoration: const InputDecoration(
                            labelText: 'Current HP',
                            prefixIcon: Icon(Icons.favorite_border),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppThemeConstants.spacing16),
                  TextFormField(
                    controller: _acController,
                    decoration: const InputDecoration(
                      labelText: 'Armor Class (AC)',
                      prefixIcon: Icon(Icons.shield),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppThemeConstants.spacing16),
            // Additional Information Section
            AppAnimations.fadeSlideIn(
              duration: AppAnimations.medium,
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 400),
              child: _buildSectionCard(
                context,
                title: 'Additional Information',
                icon: Icons.note,
                children: [
                  TextFormField(
                    controller: _backstoryController,
                    decoration: const InputDecoration(
                      labelText: 'Backstory',
                      prefixIcon: Icon(Icons.book),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: AppThemeConstants.spacing16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      prefixIcon: Icon(Icons.note_add),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppThemeConstants.spacing24),
            // Save Button
            AppAnimations.fadeSlideIn(
              duration: AppAnimations.medium,
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 500),
              child: AnimatedElevatedButton(
                label: isEdit ? 'Save Changes' : 'Create Character',
                icon: isEdit ? Icons.save : Icons.add,
                onPressed: _isLoading ? null : _saveCharacter,
                isFullWidth: true,
              ),
            ),
            SizedBox(height: AppThemeConstants.spacing16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final brightness = Theme.of(context).brightness;
    final accentColor = AppColors.getAccentPrimary(brightness);

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
        side: BorderSide(
          color: AppColors.getBorder(brightness),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppThemeConstants.spacing8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppThemeConstants.spacing12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: AppThemeConstants.fontWeightSemiBold,
                        color: AppColors.getTextPrimary(brightness),
                      ),
                ),
              ],
            ),
            SizedBox(height: AppThemeConstants.spacing16),
            ...children,
          ],
        ),
      ),
    );
  }
}


