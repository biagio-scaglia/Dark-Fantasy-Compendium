import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/boss_service.dart';
import '../../../data/models/boss.dart';
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
  final BossService _service = BossService();

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
      final bossData = await _service.getById(widget.boss!['id']);
      if (bossData != null) {
        final data = {
          'id': bossData.id,
          'name': bossData.name,
          'title': bossData.title,
          'level': bossData.level,
          'health': bossData.health,
          'max_health': bossData.maxHealth,
          'attack': bossData.attack,
          'defense': bossData.defense,
          'description': bossData.description,
          'lore': bossData.lore,
          'reward_ids': bossData.rewardIds,
          'image_path': bossData.imagePath,
          'icon_path': bossData.iconPath,
        };
        setState(() {
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boss not found'), backgroundColor: Colors.red),
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
      final boss = Boss(
        id: widget.boss?['id'] ?? 0,
        name: _nameController.text,
        title: _titleController.text.isEmpty ? null : _titleController.text,
        level: int.tryParse(_levelController.text) ?? 1,
        health: int.tryParse(_healthController.text) ?? 100,
        maxHealth: int.tryParse(_maxHealthController.text) ?? 100,
        attack: int.tryParse(_attackController.text) ?? 10,
        defense: int.tryParse(_defenseController.text) ?? 10,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        lore: _loreController.text.isEmpty ? null : _loreController.text,
        rewardIds: [],
      );

      if (widget.boss != null && widget.boss!['id'] != null) {
        final updated = await _service.update(boss);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boss updated!'), backgroundColor: Colors.green),
          );
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update boss'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(boss);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boss created!'), backgroundColor: Colors.green),
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
            ? 'Edit Boss' 
            : 'New Boss'),
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
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _levelController,
              decoration: const InputDecoration(labelText: 'Level *'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final level = int.tryParse(v ?? '');
                if (level == null || level < 1 || level > 100) {
                  return 'Level between 1 and 100';
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
                    decoration: const InputDecoration(labelText: 'Health'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _maxHealthController,
                    decoration: const InputDecoration(labelText: 'Max Health'),
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
                    decoration: const InputDecoration(labelText: 'Attack'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _defenseController,
                    decoration: const InputDecoration(labelText: 'Defense'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
              controller: _loreController,
              decoration: const InputDecoration(labelText: 'Lore'),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBoss,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.boss != null && widget.boss!['id'] != null
                      ? 'Save Changes'
                      : 'Create Boss'),
            ),
          ],
        ),
      ),
    );
  }
}

