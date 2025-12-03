import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';

class PartyFormPage extends StatefulWidget {
  final Map<String, dynamic>? party;

  const PartyFormPage({super.key, this.party});

  @override
  State<PartyFormPage> createState() => _PartyFormPageState();
}

class _PartyFormPageState extends State<PartyFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _levelController;
  late TextEditingController _experienceController;
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _levelController = TextEditingController(text: '1');
    _experienceController = TextEditingController(text: '0');
    _notesController = TextEditingController();
    
    if (widget.party != null && widget.party!['id'] != null) {
      _loadParty();
    } else if (widget.party != null) {
      _populateFields(widget.party!);
    }
  }

  Future<void> _loadParty() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('parties', widget.party!['id']);
      _populateFields(data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> partyData) {
    _nameController.text = partyData['name'] ?? '';
    _descriptionController.text = partyData['description'] ?? '';
    _levelController.text = partyData['level']?.toString() ?? '1';
    _experienceController.text = partyData['experience_points']?.toString() ?? '0';
    _notesController.text = partyData['notes'] ?? '';
  }

  Future<void> _saveParty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final partyData = {
        'name': _nameController.text,
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
        'level': int.parse(_levelController.text),
        'experience_points': int.parse(_experienceController.text),
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'characters': [],
        'campaign_id': null,
      };

      if (widget.party != null && widget.party!['id'] != null) {
        await apiService.update('parties', widget.party!['id'], partyData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Party aggiornato con successo')),
          );
          context.pop();
        }
      } else {
        await apiService.create('parties', partyData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Party creato con successo')),
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
    _descriptionController.dispose();
    _levelController.dispose();
    _experienceController.dispose();
    _notesController.dispose();
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
        title: Text(widget.party != null && widget.party!['id'] != null ? 'Modifica Party' : 'Nuovo Party'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome *'),
              validator: (value) => value?.isEmpty ?? true ? 'Inserisci un nome' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrizione'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Livello *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Inserisci il livello';
                      final level = int.tryParse(value!);
                      if (level == null || level < 1 || level > 20) {
                        return 'Livello deve essere tra 1 e 20';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(labelText: 'Punti Esperienza'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final exp = int.tryParse(value);
                        if (exp == null || exp < 0) {
                          return 'XP deve essere >= 0';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveParty,
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

