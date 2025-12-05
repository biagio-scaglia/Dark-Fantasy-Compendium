import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/services/campaign_service.dart';
import '../../../data/models/campaign.dart';
import '../../../core/theme/app_theme.dart';

class SessionFormPage extends StatefulWidget {
  final int campaignId;
  final Map<String, dynamic>? session;

  const SessionFormPage({super.key, required this.campaignId, this.session});

  @override
  State<SessionFormPage> createState() => _SessionFormPageState();
}

class _SessionFormPageState extends State<SessionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  late TextEditingController _xpController;
  late TextEditingController _dateController;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isLoadingData = false;
  final CampaignService _service = CampaignService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _notesController = TextEditingController();
    _xpController = TextEditingController(text: '0');
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    
    if (widget.session != null && widget.session!['id'] != null) {
      _populateFields(widget.session!);
    }
  }

  void _populateFields(Map<String, dynamic> session) {
    _titleController.text = session['title'] ?? '';
    _descriptionController.text = session['description'] ?? '';
    _notesController.text = session['notes'] ?? '';
    _xpController.text = session['experience_awarded']?.toString() ?? '0';
    if (session['date'] != null) {
      try {
        _selectedDate = DateTime.parse(session['date']);
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      } catch (e) {
        // Ignora errori di parsing
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final campaignData = await _service.getById(widget.campaignId);
      if (campaignData == null) {
        throw Exception('Campaign not found');
      }

      final sessionData = {
        'id': widget.session?['id'] ?? DateTime.now().millisecondsSinceEpoch,
        'date': _dateController.text,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'experience_awarded': int.tryParse(_xpController.text) ?? 0,
        'characters_present': [],
      };

      final sessions = List<Map<String, dynamic>>.from(campaignData.sessions ?? []);

      if (widget.session != null && widget.session!['id'] != null) {
        // Update existing session
        final index = sessions.indexWhere((s) => s['id'] == widget.session!['id']);
        if (index != -1) {
          sessions[index] = {...sessions[index], ...sessionData};
        }
      } else {
        // Create new session
        sessions.add(sessionData);
      }

      // Update campaign with new sessions list
      final updatedCampaign = Campaign(
        id: campaignData.id,
        name: campaignData.name,
        description: campaignData.description,
        dungeonMaster: campaignData.dungeonMaster,
        players: campaignData.players,
        characterIds: campaignData.characterIds,
        sessions: sessions,
        currentLevel: campaignData.currentLevel,
        setting: campaignData.setting,
        notes: campaignData.notes,
        imagePath: campaignData.imagePath,
        iconPath: campaignData.iconPath,
      );

      final updated = await _service.update(updatedCampaign);
      if (updated != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session saved!'), backgroundColor: Colors.green),
        );
        context.pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Failed to save session'), backgroundColor: Colors.red),
        );
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
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _xpController.dispose();
    _dateController.dispose();
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
        title: Text(widget.session != null && widget.session!['id'] != null 
            ? 'Edit Session' 
            : 'New Session'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Data *',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: _selectDate,
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titolo *'),
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 3,
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _xpController,
              decoration: const InputDecoration(labelText: 'XP Assegnati'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.session != null && widget.session!['id'] != null
                      ? 'Save Changes'
                      : 'Create Session'),
            ),
          ],
        ),
      ),
    );
  }
}


