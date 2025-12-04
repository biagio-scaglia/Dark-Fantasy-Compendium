import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';

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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('maps', widget.map!['id']);
      _populateFields(data);
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
    _imageUrlController.text = mapData['image_url'] ?? '';
    _widthController.text = mapData['width']?.toString() ?? '1000';
    _heightController.text = mapData['height']?.toString() ?? '1000';
    _notesController.text = mapData['notes'] ?? '';
  }

  Future<void> _saveMap() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final mapData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'image_url': _imageUrlController.text,
        'width': int.parse(_widthController.text),
        'height': int.parse(_heightController.text),
        'notes': _notesController.text,
        'markers': [],
        'layers': [],
      };

      if (widget.map != null && widget.map!['id'] != null) {
        await apiService.update('maps', widget.map!['id'], mapData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Map updated successfully')),
          );
          context.pop();
        }
      } else {
        await apiService.create('maps', mapData);
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
        title: Text(widget.map != null && widget.map!['id'] != null ? 'Modifica Mappa' : 'Nuova Mappa'),
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
                  : const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }
}

