import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../services/api_service.dart';
import '../../../../services/character_generator_service.dart';
import '../../../../core/theme/app_theme.dart';

class CharacterGeneratorPage extends StatefulWidget {
  const CharacterGeneratorPage({super.key});

  @override
  State<CharacterGeneratorPage> createState() => _CharacterGeneratorPageState();
}

class _CharacterGeneratorPageState extends State<CharacterGeneratorPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedClass;
  String? _selectedRace;
  int _level = 1;
  bool _autoSave = false;
  bool _isLoading = false;
  bool _loadingOptions = true;
  String? _error;
  
  List<String> _availableClasses = [];
  List<String> _availableRaces = [];
  
  Map<String, dynamic>? _generatedCharacter;
  
  late CharacterGeneratorService _generatorService;

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    _generatorService = CharacterGeneratorService(apiService);
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() {
      _loadingOptions = true;
      _error = null;
    });

    try {
      final classes = await _generatorService.getAvailableClasses();
      final races = await _generatorService.getAvailableRaces();
      
      setState(() {
        _availableClasses = classes;
        _availableRaces = races;
        if (classes.isNotEmpty) _selectedClass = classes.first;
        if (races.isNotEmpty) _selectedRace = races.first;
        _loadingOptions = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingOptions = false;
      });
    }
  }

  Future<void> _generateCharacter() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _error = 'Inserisci un nome per il personaggio';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _generatedCharacter = null;
    });

    try {
      final result = await _generatorService.generateCharacter(
        name: _nameController.text.trim(),
        className: _selectedClass,
        raceName: _selectedRace,
        level: _level,
        autoSave: _autoSave,
      );

      setState(() {
        _generatedCharacter = result;
        _isLoading = false;
      });

      if (_autoSave && result.containsKey('saved_character')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Personaggio generato e salvato con successo!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generatore Personaggi'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_loadingOptions)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                // Form Generazione
                Card(
                  color: AppTheme.secondaryDark,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Genera Personaggio D&D',
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nome Personaggio',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppTheme.accentGold),
                            ),
                            filled: true,
                            fillColor: AppTheme.secondaryDark,
                          ),
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedClass,
                          decoration: InputDecoration(
                            labelText: 'Classe',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppTheme.accentGold),
                            ),
                            filled: true,
                            fillColor: AppTheme.secondaryDark,
                          ),
                          items: _availableClasses.map((className) {
                            return DropdownMenuItem(
                              value: className,
                              child: Text(className),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedClass = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedRace,
                          decoration: InputDecoration(
                            labelText: 'Razza',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppTheme.accentGold),
                            ),
                            filled: true,
                            fillColor: AppTheme.secondaryDark,
                          ),
                          items: _availableRaces.map((raceName) {
                            return DropdownMenuItem(
                              value: raceName,
                              child: Text(raceName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRace = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Livello: $_level',
                              style: textTheme.bodyLarge,
                            ),
                            Expanded(
                              child: Slider(
                                value: _level.toDouble(),
                                min: 1,
                                max: 20,
                                divisions: 19,
                                label: '$_level',
                                onChanged: (value) {
                                  setState(() {
                                    _level = value.toInt();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CheckboxListTile(
                          title: const Text('Salva automaticamente'),
                          value: _autoSave,
                          onChanged: (value) {
                            setState(() {
                              _autoSave = value ?? false;
                            });
                          },
                          activeColor: AppTheme.accentGold,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _generateCharacter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGold,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Genera Personaggio'),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Errore
                if (_error != null)
                  Card(
                    color: Colors.red.shade900,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                
                // Risultato
                if (_generatedCharacter != null)
                  Card(
                    color: AppTheme.secondaryDark,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personaggio Generato',
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          if (_generatedCharacter!.containsKey('generated_data'))
                            _buildCharacterStats(
                              _generatedCharacter!['generated_data'] as Map<String, dynamic>,
                              textTheme,
                            ),
                          if (!_autoSave) ...[
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Qui potresti aggiungere logica per salvare manualmente
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Usa "Salva automaticamente" per salvare il personaggio'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentGold,
                              ),
                              child: const Text('Salva Personaggio'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterStats(Map<String, dynamic> data, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nome: ${data['name']}', style: textTheme.bodyLarge),
        Text('Livello: ${data['level']}', style: textTheme.bodyLarge),
        Text('Classe: ${data['class_name'] ?? "N/A"}', style: textTheme.bodyLarge),
        Text('Razza: ${data['race_name'] ?? "N/A"}', style: textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text('HP: ${data['current_hit_points']}/${data['max_hit_points']}', style: textTheme.bodyLarge),
        Text('AC: ${data['armor_class']}', style: textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text('Forza: ${data['strength']}', style: textTheme.bodyLarge),
        Text('Destrezza: ${data['dexterity']}', style: textTheme.bodyLarge),
        Text('Costituzione: ${data['constitution']}', style: textTheme.bodyLarge),
        Text('Intelligenza: ${data['intelligence']}', style: textTheme.bodyLarge),
        Text('Saggezza: ${data['wisdom']}', style: textTheme.bodyLarge),
        Text('Carisma: ${data['charisma']}', style: textTheme.bodyLarge),
      ],
    );
  }
}

