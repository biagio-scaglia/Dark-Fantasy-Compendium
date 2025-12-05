import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/map_service.dart';
import '../../../data/models/map_model.dart';

class MapFormPage extends StatefulWidget {
  final Map<String, dynamic>? map;

  const MapFormPage({super.key, this.map});

  @override
  State<MapFormPage> createState() => _MapFormPageState();
}

class _MapFormPageState extends State<MapFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _notesController;
  bool _isLoading = false;
  final MapService _service = MapService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
    _widthController = TextEditingController(text: '1000');
    _heightController = TextEditingController(text: '1000');
    _notesController = TextEditingController();
    
    if (widget.map != null && widget.map!['id'] != null) {
      _loadMap();
    } else if (widget.map != null) {
      _populateFields(widget.map!);
    }
  }

  Future<void> _loadMap() async {
    try {
      final mapData = await _service.getById(widget.map!['id']);
      if (mapData != null) {
        final data = mapData.toJson();
        _populateFields(data);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Map not found'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Map<String, dynamic> mapData) {
    _nameController.text = mapData['name'] ?? '';
    _descriptionController.text = mapData['description'] ?? '';
    _imageUrlController.text = mapData['image_path'] ?? mapData['image_url'] ?? '';
    _widthController.text = mapData['width']?.toString() ?? '1000';
    _heightController.text = mapData['height']?.toString() ?? '1000';
    _notesController.text = mapData['notes'] ?? '';
  }

  Future<void> _saveMap() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final mapModel = MapModel(
        id: widget.map?['id'] ?? 0,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        imagePath: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        width: int.tryParse(_widthController.text) ?? 1000,
        height: int.tryParse(_heightController.text) ?? 1000,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        markers: [],
        layers: [],
      );

      if (widget.map != null && widget.map!['id'] != null) {
        final updated = await _service.update(mapModel);
        if (updated != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Map updated successfully')),
          );
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to update map'), backgroundColor: Colors.red),
          );
        }
      } else {
        final created = await _service.create(mapModel);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Map created successfully')),
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
    _imageUrlController.dispose();
    _widthController.dispose();
    _heightController.dispose();
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
        title: Text(widget.map != null && widget.map!['id'] != null ? 'Edit Map' : 'New Map'),
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
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Enter a description' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL *'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a URL' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _widthController,
                    decoration: const InputDecoration(labelText: 'Width *'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Enter width' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(labelText: 'Height *'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Enter height' : null,
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
              onPressed: _isLoading ? null : _saveMap,
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


