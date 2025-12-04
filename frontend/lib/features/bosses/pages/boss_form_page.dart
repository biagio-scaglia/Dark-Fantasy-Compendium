import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class BossFormPage extends StatefulWidget {
  final Map<String, dynamic>? boss;

  const BossFormPage({super.key, this.boss});

  @override
  State<BossFormPage> createState() => _BossFormPageState();
}

class _BossFormPageState extends State<BossFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _levelController;
  late TextEditingController _healthController;
  late TextEditingController _maxHealthController;
  late TextEditingController _attackController;
  late TextEditingController _defenseController;
  late TextEditingController _descriptionController;
  late TextEditingController _loreController;
  bool _isLoading = false;
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _levelController = TextEditingController(text: '1');
    _healthController = TextEditingController(text: '100');
    _maxHealthController = TextEditingController(text: '100');
    _attackController = TextEditingController(text: '10');
    _defenseController = TextEditingController(text: '10');
    _descriptionController = TextEditingController();
    _loreController = TextEditingController();
    
    if (widget.boss != null && widget.boss!['id'] != null) {
      _loadBoss();
    } else if (widget.boss != null) {
      _populateFields(widget.boss!);
    }
  }

  Future<void> _loadBoss() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('bosses', widget.boss!['id']);
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

  void _populateFields(Map<String, dynamic> boss) {
    _nameController.text = boss['name'] ?? '';
    _titleController.text = boss['title'] ?? '';
    _levelController.text = boss['level']?.toString() ?? '1';
    _healthController.text = boss['health']?.toString() ?? '100';
    _maxHealthController.text = boss['max_health']?.toString() ?? '100';
    _attackController.text = boss['attack']?.toString() ?? '10';
    _defenseController.text = boss['defense']?.toString() ?? '10';
    _descriptionController.text = boss['description'] ?? '';
    _loreController.text = boss['lore'] ?? '';
  }

  Future<void> _saveBoss() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = {
        'name': _nameController.text,
        'title': _titleController.text,
        'level': int.parse(_levelController.text),
        'health': int.parse(_healthController.text),
        'max_health': int.parse(_maxHealthController.text),
        'attack': int.parse(_attackController.text),
        'defense': int.parse(_defenseController.text),
        'description': _descriptionController.text,
        'lore': _loreController.text.isEmpty ? null : _loreController.text,
        'rewards': [],
      };

      if (widget.boss != null && widget.boss!['id'] != null) {
        await apiService.update('bosses', widget.boss!['id'], data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boss aggiornato!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      } else {
        await apiService.create('bosses', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boss creato!'), backgroundColor: Colors.green),
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
    _titleController.dispose();
    _levelController.dispose();
    _healthController.dispose();
    _maxHealthController.dispose();
    _attackController.dispose();
    _defenseController.dispose();
    _descriptionController.dispose();
    _loreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Boss')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.boss != null && widget.boss!['id'] != null 
            ? 'Modifica Boss' 
            : 'Nuovo Boss'),
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
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titolo *'),
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _levelController,
              decoration: const InputDecoration(labelText: 'Livello *'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final level = int.tryParse(v ?? '');
                if (level == null || level < 1 || level > 100) {
                  return 'Livello tra 1 e 100';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _healthController,
                    decoration: const InputDecoration(labelText: 'Salute'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _maxHealthController,
                    decoration: const InputDecoration(labelText: 'Salute Massima'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _attackController,
                    decoration: const InputDecoration(labelText: 'Attacco'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _defenseController,
                    decoration: const InputDecoration(labelText: 'Difesa'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
              controller: _loreController,
              decoration: const InputDecoration(labelText: 'Lore'),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBoss,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.boss != null && widget.boss!['id'] != null
                      ? 'Salva Modifiche'
                      : 'Crea Boss'),
            ),
          ],
        ),
      ),
    );
  }
}

