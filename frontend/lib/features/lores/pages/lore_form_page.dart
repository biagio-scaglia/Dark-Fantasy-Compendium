import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class LoreFormPage extends StatefulWidget {
  final Map<String, dynamic>? lore;

  const LoreFormPage({super.key, this.lore});

  @override
  State<LoreFormPage> createState() => _LoreFormPageState();
}

class _LoreFormPageState extends State<LoreFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _contentController;
  late TextEditingController _relatedEntityTypeController;
  late TextEditingController _relatedEntityIdController;
  bool _isLoading = false;
  bool _isLoadingData = false;

  final List<String> _categories = ['history', 'legend', 'prophecy', 'tale', 'other'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _categoryController = TextEditingController();
    _contentController = TextEditingController();
    _relatedEntityTypeController = TextEditingController();
    _relatedEntityIdController = TextEditingController();
    
    if (widget.lore != null && widget.lore!['id'] != null) {
      _loadLore();
    } else if (widget.lore != null) {
      _populateFields(widget.lore!);
    }
  }

  Future<void> _loadLore() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('lores', widget.lore!['id']);
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

  void _populateFields(Map<String, dynamic> lore) {
    _titleController.text = lore['title'] ?? '';
    _categoryController.text = lore['category'] ?? '';
    _contentController.text = lore['content'] ?? '';
    _relatedEntityTypeController.text = lore['related_entity_type'] ?? '';
    _relatedEntityIdController.text = lore['related_entity_id']?.toString() ?? '';
  }

  Future<void> _saveLore() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = {
        'title': _titleController.text,
        'category': _categoryController.text,
        'content': _contentController.text,
        'related_entity_type': _relatedEntityTypeController.text.isEmpty 
            ? null 
            : _relatedEntityTypeController.text,
        'related_entity_id': _relatedEntityIdController.text.isEmpty
            ? null
            : int.tryParse(_relatedEntityIdController.text),
      };

      if (widget.lore != null && widget.lore!['id'] != null) {
        await apiService.update('lores', widget.lore!['id'], data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lore aggiornata!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      } else {
        await apiService.create('lores', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lore creata!'), backgroundColor: Colors.green),
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
    _titleController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    _relatedEntityTypeController.dispose();
    _relatedEntityIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lore')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.lore != null && widget.lore!['id'] != null 
            ? 'Modifica Lore' 
            : 'Nuova Lore'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titolo *'),
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _categories.contains(_categoryController.text) ? _categoryController.text : null,
              decoration: const InputDecoration(labelText: 'Categoria *'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoryController.text = value ?? '';
                });
              },
              validator: (v) => v == null ? 'Seleziona una categoria' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Contenuto *'),
              maxLines: 8,
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _relatedEntityTypeController,
              decoration: const InputDecoration(
                labelText: 'Tipo Entità Correlata',
                hintText: 'es: knight, weapon, boss',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _relatedEntityIdController,
              decoration: const InputDecoration(
                labelText: 'ID Entità Correlata',
                hintText: 'ID numerico',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveLore,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.lore != null && widget.lore!['id'] != null
                      ? 'Salva Modifiche'
                      : 'Crea Lore'),
            ),
          ],
        ),
      ),
    );
  }
}

