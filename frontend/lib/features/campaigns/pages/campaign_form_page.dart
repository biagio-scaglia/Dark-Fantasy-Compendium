import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class CampaignFormPage extends StatefulWidget {
  final Map<String, dynamic>? campaign;

  const CampaignFormPage({super.key, this.campaign});

  @override
  State<CampaignFormPage> createState() => _CampaignFormPageState();
}

class _CampaignFormPageState extends State<CampaignFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dmController;
  late TextEditingController _playersController;
  late TextEditingController _levelController;
  late TextEditingController _settingController;
  late TextEditingController _notesController;
  bool _isLoading = false;
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _dmController = TextEditingController();
    _playersController = TextEditingController();
    _levelController = TextEditingController(text: '1');
    _settingController = TextEditingController();
    _notesController = TextEditingController();
    
    if (widget.campaign != null && widget.campaign!['id'] != null) {
      _loadCampaign();
    } else if (widget.campaign != null) {
      _populateFields(widget.campaign!);
    }
  }

  Future<void> _loadCampaign() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('campaigns', widget.campaign!['id']);
      setState(() {
        _populateFields(data);
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> campaign) {
    _nameController.text = campaign['name'] ?? '';
    _descriptionController.text = campaign['description'] ?? '';
    _dmController.text = campaign['dungeon_master'] ?? '';
    _playersController.text = (campaign['players'] as List?)?.join(', ') ?? '';
    _levelController.text = campaign['current_level']?.toString() ?? '1';
    _settingController.text = campaign['setting'] ?? '';
    _notesController.text = campaign['notes'] ?? '';
  }

  Future<void> _saveCampaign() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final players = _playersController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      
      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'dungeon_master': _dmController.text,
        'players': players,
        'current_level': int.parse(_levelController.text),
        'setting': _settingController.text.isEmpty ? null : _settingController.text,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'characters': [],
        'sessions': [],
      };

      if (widget.campaign != null && widget.campaign!['id'] != null) {
        await apiService.update('campaigns', widget.campaign!['id'], data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campagna aggiornata!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      } else {
        await apiService.create('campaigns', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campagna creata!'), backgroundColor: Colors.green),
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
    _dmController.dispose();
    _playersController.dispose();
    _levelController.dispose();
    _settingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Campagna')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.campaign != null && widget.campaign!['id'] != null 
            ? 'Modifica Campagna' 
            : 'Nuova Campagna'),
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
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrizione *'),
              maxLines: 3,
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dmController,
              decoration: const InputDecoration(labelText: 'Dungeon Master *'),
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _playersController,
              decoration: const InputDecoration(
                labelText: 'Giocatori',
                hintText: 'Separati da virgola (es: Mario, Luigi, Peppe)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _levelController,
              decoration: const InputDecoration(labelText: 'Livello Attuale'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _settingController,
              decoration: const InputDecoration(labelText: 'Ambientazione'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCampaign,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.campaign != null && widget.campaign!['id'] != null
                      ? 'Salva Modifiche'
                      : 'Crea Campagna'),
            ),
          ],
        ),
      ),
    );
  }
}

