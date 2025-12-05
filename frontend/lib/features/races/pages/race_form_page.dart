import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/race_service.dart';
import '../../../data/models/race.dart';
import '../../../widgets/image_picker_helper.dart';
import '../../../core/theme/app_theme.dart';

class RaceFormPage extends StatefulWidget {
  final Race? race;
  final int? raceId;

  const RaceFormPage({super.key, this.race, this.raceId});

  @override
  State<RaceFormPage> createState() => _RaceFormPageState();
}

class _RaceFormPageState extends State<RaceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _sizeController;
  late TextEditingController _speedController;
  bool _isLoading = false;
  String? _imagePath;
  final RaceService _service = RaceService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _sizeController = TextEditingController();
    _speedController = TextEditingController();
    
    if (widget.race != null) {
      _populateFields(widget.race!);
    } else if (widget.raceId != null) {
      _loadRace();
    }
  }

  Future<void> _loadRace() async {
    try {
      final race = await _service.getById(widget.raceId!);
      if (race != null && mounted) {
        _populateFields(race);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading race: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _populateFields(Race race) {
    _nameController.text = race.name;
    _descriptionController.text = race.description ?? '';
    _sizeController.text = race.size ?? '';
    _speedController.text = race.speed?.toString() ?? '';
    _imagePath = race.imagePath;
  }

  Future<void> _pickImage() async {
    final path = await ImagePickerHelper.showImageSourceDialog(context);
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _saveRace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? savedImagePath = _imagePath;
      if (_imagePath != null && widget.race != null) {
        savedImagePath = await ImagePickerHelper.saveImageForEntity(
          _imagePath!,
          'race',
          widget.race!.id,
        );
      }

      final race = Race(
        id: widget.race?.id ?? 0,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        size: _sizeController.text.isEmpty ? null : _sizeController.text,
        speed: _speedController.text.isEmpty ? null : int.tryParse(_speedController.text),
        imagePath: savedImagePath,
      );

      if (widget.race != null || widget.raceId != null) {
        final id = widget.race?.id ?? widget.raceId!;
        final updatedRace = Race(
          id: id,
          name: race.name,
          description: race.description,
          size: race.size,
          speed: race.speed,
          abilityScoreIncreases: race.abilityScoreIncreases,
          traits: race.traits,
          languages: race.languages,
          subraces: race.subraces,
          imagePath: savedImagePath,
          iconPath: race.iconPath,
        );
        await _service.update(updatedRace);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Race updated!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      } else {
        final created = await _service.create(race);
        if (_imagePath != null) {
          final savedPath = await ImagePickerHelper.saveImageForEntity(
            _imagePath!,
            'race',
            created.id,
          );
          if (savedPath != null) {
            final updated = Race(
              id: created.id,
              name: created.name,
              description: created.description,
              size: created.size,
              speed: created.speed,
              abilityScoreIncreases: created.abilityScoreIncreases,
              traits: created.traits,
              languages: created.languages,
              subraces: created.subraces,
              imagePath: savedPath,
              iconPath: created.iconPath,
            );
            await _service.update(updated);
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Race created!'), backgroundColor: Colors.green),
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
    _sizeController.dispose();
    _speedController.dispose();
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
        title: Text(widget.race != null || widget.raceId != null ? 'Edit Race' : 'New Race'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePath != null
                    ? ImagePickerHelper.buildImageWidget(_imagePath, fit: BoxFit.cover)
                    : const Center(child: Icon(Icons.add_photo_alternate, size: 48)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
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
                    controller: _sizeController,
                    decoration: const InputDecoration(labelText: 'Size'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _speedController,
                    decoration: const InputDecoration(labelText: 'Speed'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveRace,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.race != null || widget.raceId != null ? 'Save Changes' : 'Create Race'),
            ),
          ],
        ),
      ),
    );
  }
}


