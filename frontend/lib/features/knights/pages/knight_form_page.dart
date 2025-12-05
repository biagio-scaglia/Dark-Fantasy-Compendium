import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/knight_service.dart';
import '../../../data/models/knight.dart';
import '../../../data/services/local_json_service.dart';
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
  final KnightService _service = KnightService();
  final LocalJsonService _jsonService = LocalJsonService();

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
      final knightData = await _service.getById(widget.knight!['id']);
      if (knightData != null) {
        final data = {
          'id': knightData.id,
          'name': knightData.name,
          'title': knightData.title,
          'faction_id': knightData.factionId,
          'level': knightData.level,
          'health': knightData.health,
          'max_health': knightData.maxHealth,
          'attack': knightData.attack,
          'defense': knightData.defense,
          'weapon_id': knightData.weaponId,
          'armor_id': knightData.armorId,
          'description': knightData.description,
          'lore': knightData.lore,
          'image_path': knightData.imagePath,
          'icon_path': knightData.iconPath,
        };
        setState(() {
          _knightData = data;
          _populateFields(data);
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Knight not found'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading error: ${e.toString()}'), backgroundColor: Colors.red),
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
    _currentImageUrl = knight['image_path'] ?? knight['image_url'];
    _currentIconUrl = knight['icon_path'] ?? knight['icon_url'];
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
          SnackBar(content: Text('Image selection error: $e'), backgroundColor: Colors.red),
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
      // Salva le immagini se selezionate
      String? imagePath = _currentImageUrl;
      String? iconPath = _currentIconUrl;
      
      final knightId = widget.knight?['id'] ?? _knightData?['id'];
      
      final knight = Knight(
        id: knightId ?? 0,
        name: _nameController.text,
        title: _titleController.text.isEmpty ? null : _titleController.text,
        factionId: _factionIdController.text.isEmpty ? null : int.tryParse(_factionIdController.text),
        level: int.tryParse(_levelController.text) ?? 1,
        health: int.tryParse(_healthController.text) ?? 100,
        maxHealth: int.tryParse(_maxHealthController.text) ?? 100,
        attack: int.tryParse(_attackController.text) ?? 10,
        defense: int.tryParse(_defenseController.text) ?? 10,
        weaponId: _weaponIdController.text.isEmpty ? null : int.tryParse(_weaponIdController.text),
        armorId: _armorIdController.text.isEmpty ? null : int.tryParse(_armorIdController.text),
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        lore: _loreController.text.isEmpty ? null : _loreController.text,
        imagePath: imagePath,
        iconPath: iconPath,
      );

      if (knightId != null && knightId > 0) {
        // Update - salva immagini se selezionate
        if (_selectedImage != null) {
          imagePath = await _jsonService.saveImage(_selectedImage!, 'knight', knightId);
        }
        if (_selectedIcon != null) {
          iconPath = await _jsonService.saveImage(_selectedIcon!, 'knight', knightId);
        }
        
        final updatedKnight = Knight(
          id: knight.id,
          name: knight.name,
          title: knight.title,
          factionId: knight.factionId,
          level: knight.level,
          health: knight.health,
          maxHealth: knight.maxHealth,
          attack: knight.attack,
          defense: knight.defense,
          weaponId: knight.weaponId,
          armorId: knight.armorId,
          description: knight.description,
          lore: knight.lore,
          imagePath: imagePath,
          iconPath: iconPath,
        );
        
        setState(() => _isUploadingImage = false);
        
        final updated = await _service.update(updatedKnight);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Knight updated successfully')),
          );
          context.go('/knights/$knightId');
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update knight'), backgroundColor: Colors.red),
          );
        }
      } else {
        // Create - prima crea, poi salva immagini
        setState(() => _isUploadingImage = false);
        
        final created = await _service.create(knight);
        
        // Salva immagini dopo la creazione
        if (_selectedImage != null) {
          imagePath = await _jsonService.saveImage(_selectedImage!, 'knight', created.id);
        }
        if (_selectedIcon != null) {
          iconPath = await _jsonService.saveImage(_selectedIcon!, 'knight', created.id);
        }
        
        // Aggiorna con i path delle immagini
        if (imagePath != knight.imagePath || iconPath != knight.iconPath) {
          final updatedKnight = Knight(
            id: created.id,
            name: created.name,
            title: created.title,
            factionId: created.factionId,
            level: created.level,
            health: created.health,
            maxHealth: created.maxHealth,
            attack: created.attack,
            defense: created.defense,
            weaponId: created.weaponId,
            armorId: created.armorId,
            description: created.description,
            lore: created.lore,
            imagePath: imagePath,
            iconPath: iconPath,
          );
          await _service.update(updatedKnight);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Knight created successfully')),
          );
          context.go('/knights/${created.id}');
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
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Back',
          ),
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(widget.knight != null ? 'Edit Knight' : 'New Knight'),
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
              controller: _factionIdController,
              decoration: const InputDecoration(labelText: 'Faction ID *'),
              keyboardType: TextInputType.number,
              validator: (v) => v?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Level'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _healthController,
                    decoration: const InputDecoration(labelText: 'Health'),
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
                    decoration: const InputDecoration(labelText: 'Max Health'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _attackController,
                    decoration: const InputDecoration(labelText: 'Attack'),
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
                    decoration: const InputDecoration(labelText: 'Defense'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _weaponIdController,
                    decoration: const InputDecoration(labelText: 'Weapon ID'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _armorIdController,
              decoration: const InputDecoration(labelText: 'Armor ID'),
              keyboardType: TextInputType.number,
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
              label: 'Icon',
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
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.knight != null ? 'Update' : 'Create',
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
              label: Text(file != null ? 'Change $label' : 'Select $label'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


