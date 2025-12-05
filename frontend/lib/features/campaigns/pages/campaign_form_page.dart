import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/campaign_service.dart';
import '../../../data/models/campaign.dart';
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
  final CampaignService _service = CampaignService();

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
      final campaignData = await _service.getById(widget.campaign!['id']);
      if (campaignData != null) {
        final data = campaignData.toJson();
        setState(() {
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campaign not found'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
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
      final players = _playersController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      
      final campaign = Campaign(
        id: widget.campaign?['id'] ?? 0,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        dungeonMaster: _dmController.text.isEmpty ? null : _dmController.text,
        players: players.isEmpty ? null : players,
        currentLevel: int.tryParse(_levelController.text) ?? 1,
        setting: _settingController.text.isEmpty ? null : _settingController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        characterIds: [],
        sessions: [],
      );

      if (widget.campaign != null && widget.campaign!['id'] != null) {
        final updated = await _service.update(campaign);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campaign updated!'), backgroundColor: Colors.green),
          );
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update campaign'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(campaign);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campaign created!'), backgroundColor: Colors.green),
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
            : 'New Campaign'),
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
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 3,
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dmController,
              decoration: const InputDecoration(labelText: 'Dungeon Master *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _playersController,
              decoration: const InputDecoration(
                labelText: 'Players',
                hintText: 'Separated by comma (e.g: Mario, Luigi, Peppe)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _levelController,
              decoration: const InputDecoration(labelText: 'Current Level'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _settingController,
              decoration: const InputDecoration(labelText: 'Setting'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCampaign,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.campaign != null && widget.campaign!['id'] != null
                      ? 'Save Changes'
                      : 'Create Campaign'),
            ),
          ],
        ),
      ),
    );
  }
}


