import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class KnightFormPage extends StatefulWidget {
  final Map<String, dynamic>? knight;

  const KnightFormPage({super.key, this.knight});

  @override
  State<KnightFormPage> createState() => _KnightFormPageState();
}

class _KnightFormPageState extends State<KnightFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _factionIdController;
  late TextEditingController _levelController;
  late TextEditingController _healthController;
  late TextEditingController _maxHealthController;
  late TextEditingController _attackController;
  late TextEditingController _defenseController;
  late TextEditingController _weaponIdController;
  late TextEditingController _armorIdController;
  late TextEditingController _descriptionController;
  late TextEditingController _loreController;
  File? _selectedImage;
  File? _selectedIcon;
  String? _currentImageUrl;
  String? _currentIconUrl;
  bool _isLoading = false;
  bool _isLoadingData = false;
  bool _isUploadingImage = false;
  Map<String, dynamic>? _knightData;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _factionIdController = TextEditingController();
    _levelController = TextEditingController(text: '1');
    _healthController = TextEditingController(text: '100');
    _maxHealthController = TextEditingController(text: '100');
    _attackController = TextEditingController(text: '10');
    _defenseController = TextEditingController(text: '10');
    _weaponIdController = TextEditingController();
    _armorIdController = TextEditingController();
    _descriptionController = TextEditingController();
    _loreController = TextEditingController();
    
    if (widget.knight != null && widget.knight!['id'] != null) {
      _loadKnight();
    } else if (widget.knight != null) {
      _populateFields(widget.knight!);
    }
  }

  Future<void> _loadKnight() async {
    setState(() => _isLoadingData = true);
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('knights', widget.knight!['id']);
      setState(() {
        _knightData = data;
        _populateFields(data);
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel caricamento: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> knight) {
    _nameController.text = knight['name'] ?? '';
    _titleController.text = knight['title'] ?? '';
    _factionIdController.text = knight['faction_id']?.toString() ?? '';
    _levelController.text = knight['level']?.toString() ?? '1';
    _healthController.text = knight['health']?.toString() ?? '100';
    _maxHealthController.text = knight['max_health']?.toString() ?? '100';
    _attackController.text = knight['attack']?.toString() ?? '10';
    _defenseController.text = knight['defense']?.toString() ?? '10';
    _weaponIdController.text = knight['weapon_id']?.toString() ?? '';
    _armorIdController.text = knight['armor_id']?.toString() ?? '';
    _descriptionController.text = knight['description'] ?? '';
    _loreController.text = knight['lore'] ?? '';
    _currentImageUrl = knight['image_url'];
    _currentIconUrl = knight['icon_url'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _factionIdController.dispose();
    _levelController.dispose();
    _healthController.dispose();
    _maxHealthController.dispose();
    _attackController.dispose();
    _defenseController.dispose();
    _weaponIdController.dispose();
    _armorIdController.dispose();
    _descriptionController.dispose();
    _loreController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isIcon) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          if (isIcon) {
            _selectedIcon = File(image.path);
          } else {
            _selectedImage = File(image.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nella selezione immagine: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isUploadingImage = true;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      
      // Carica le immagini se selezionate
      String? imageUrl = _currentImageUrl;
      String? iconUrl = _currentIconUrl;
      
      if (_selectedImage != null) {
        imageUrl = await apiService.uploadImage(_selectedImage!, isIcon: false);
      }
      if (_selectedIcon != null) {
        iconUrl = await apiService.uploadImage(_selectedIcon!, isIcon: true);
      }
      
      setState(() => _isUploadingImage = false);
      
      final data = {
        'name': _nameController.text,
        'title': _titleController.text,
        'faction_id': int.tryParse(_factionIdController.text),
        'level': int.tryParse(_levelController.text) ?? 1,
        'health': int.tryParse(_healthController.text) ?? 100,
        'max_health': int.tryParse(_maxHealthController.text) ?? 100,
        'attack': int.tryParse(_attackController.text) ?? 10,
        'defense': int.tryParse(_defenseController.text) ?? 10,
        'weapon_id': _weaponIdController.text.isEmpty ? null : int.tryParse(_weaponIdController.text),
        'armor_id': _armorIdController.text.isEmpty ? null : int.tryParse(_armorIdController.text),
        'description': _descriptionController.text,
        'lore': _loreController.text.isEmpty ? null : _loreController.text,
        'image_url': imageUrl,
        'icon_url': iconUrl,
      };

      final knightId = widget.knight?['id'] ?? _knightData?['id'];
      if (knightId != null) {
        // Update
        await apiService.update('knights', knightId, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cavaliere aggiornato con successo')),
          );
          context.go('/knights/$knightId');
        }
      } else {
        // Create
        final created = await apiService.create('knights', data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cavaliere creato con successo')),
          );
          context.go('/knights/${created['id']}');
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
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Indietro',
          ),
          title: const Text('Caricamento...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Indietro',
        ),
        title: Text(widget.knight != null ? 'Modifica Cavaliere' : 'Nuovo Cavaliere'),
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
              controller: _factionIdController,
              decoration: const InputDecoration(labelText: 'ID Fazione *'),
              keyboardType: TextInputType.number,
              validator: (v) => v?.isEmpty ?? true ? 'Campo obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Livello'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _healthController,
                    decoration: const InputDecoration(labelText: 'Salute'),
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
                    controller: _maxHealthController,
                    decoration: const InputDecoration(labelText: 'Salute Max'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _attackController,
                    decoration: const InputDecoration(labelText: 'Attacco'),
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
                    controller: _defenseController,
                    decoration: const InputDecoration(labelText: 'Difesa'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _weaponIdController,
                    decoration: const InputDecoration(labelText: 'ID Arma'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _armorIdController,
              decoration: const InputDecoration(labelText: 'ID Armatura'),
              keyboardType: TextInputType.number,
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
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildImagePicker(
              label: 'Immagine',
              file: _selectedImage,
              currentUrl: _currentImageUrl,
              onTap: () => _pickImage(false),
            ),
            const SizedBox(height: 16),
            _buildImagePicker(
              label: 'Icona',
              file: _selectedIcon,
              currentUrl: _currentIconUrl,
              onTap: () => _pickImage(true),
            ),
            const SizedBox(height: 24),
            if (_isUploadingImage)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.accentGold,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.knight != null ? 'Aggiorna' : 'Crea',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required File? file,
    required String? currentUrl,
    required VoidCallback onTap,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (file != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  file,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (currentUrl != null && currentUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  currentUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[800],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              )
            else
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[600]!),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.photo_library),
              label: Text(file != null ? 'Cambia $label' : 'Seleziona $label'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

