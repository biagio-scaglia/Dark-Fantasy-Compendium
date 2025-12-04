import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/party_service.dart';
import '../../../data/models/party.dart';

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
  late TextEditingController _campaignIdController;
  late TextEditingController _charactersController;
  late TextEditingController _notesController;
  bool _isLoading = false;
  bool _isLoadingData = false;
  final PartyService _service = PartyService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _levelController = TextEditingController(text: '1');
    _experienceController = TextEditingController(text: '0');
    _campaignIdController = TextEditingController();
    _charactersController = TextEditingController();
    _notesController = TextEditingController();
    
    if (widget.party != null && widget.party!['id'] != null) {
      _loadParty();
    } else if (widget.party != null) {
      _populateFields(widget.party!);
    }
  }

  Future<void> _loadParty() async {
    setState(() => _isLoadingData = true);
    try {
      final partyData = await _service.getById(widget.party!['id']);
      if (partyData != null) {
        final data = partyData.toJson();
        setState(() {
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Party not found'), backgroundColor: Colors.red),
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

  void _populateFields(Map<String, dynamic> partyData) {
    _nameController.text = partyData['name'] ?? '';
    _descriptionController.text = partyData['description'] ?? '';
    _levelController.text = partyData['level']?.toString() ?? '1';
    _experienceController.text = partyData['experience_points']?.toString() ?? '0';
    _campaignIdController.text = partyData['campaign_id']?.toString() ?? '';
    _charactersController.text = (partyData['member_ids'] as List? ?? partyData['characters'] as List?)
        ?.map((e) => e.toString())
        .join(', ') ?? '';
    _notesController.text = partyData['notes'] ?? '';
  }

  Future<void> _saveParty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Parse characters IDs
      List<int>? memberIds;
      if (_charactersController.text.isNotEmpty) {
        memberIds = _charactersController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .map((e) => int.tryParse(e))
            .where((e) => e != null)
            .cast<int>()
            .toList();
      }
      
      // Parse campaign_id
      int? campaignId;
      if (_campaignIdController.text.isNotEmpty) {
        campaignId = int.tryParse(_campaignIdController.text.trim());
      }
      
      final party = Party(
        id: widget.party?['id'] ?? 0,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        level: int.tryParse(_levelController.text) ?? 1,
        experiencePoints: int.tryParse(_experienceController.text) ?? 0,
        campaignId: campaignId,
        memberIds: memberIds,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (widget.party != null && widget.party!['id'] != null) {
        final updated = await _service.update(party);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Party updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Failed to update party'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        final created = await _service.create(party);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Party created successfully'),
              backgroundColor: Colors.green,
            ),
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
    _levelController.dispose();
    _experienceController.dispose();
    _campaignIdController.dispose();
    _charactersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(widget.party != null && widget.party!['id'] != null ? 'Edit Party' : 'New Party'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Level *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Enter the level';
                      final level = int.tryParse(value!);
                      if (level == null || level < 1 || level > 20) {
                        return 'Level must be between 1 and 20';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(labelText: 'Experience Points'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final exp = int.tryParse(value);
                        if (exp == null || exp < 0) {
                          return 'XP must be >= 0';
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
              controller: _campaignIdController,
              decoration: const InputDecoration(
                labelText: 'Campaign ID',
                hintText: 'Enter the campaign ID (optional)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final id = int.tryParse(value);
                  if (id == null || id < 1) {
                    return 'ID must be a positive number';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _charactersController,
              decoration: const InputDecoration(
                labelText: 'Character IDs',
                hintText: 'Enter IDs separated by comma (e.g: 1, 2, 3)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
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
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

