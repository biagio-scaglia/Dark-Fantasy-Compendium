import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/image/image_editing_service.dart';
import '../../../core/accessibility/accessibility_helper.dart';
import '../../../core/theme/app_theme.dart';

class ImageEditorPage extends StatefulWidget {
  final String imagePath;
  final Function(String editedPath)? onSave;

  const ImageEditorPage({
    super.key,
    required this.imagePath,
    this.onSave,
  });

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  File? _editedImage;
  Uint8List? _imageBytes;
  bool _isProcessing = false;
  double _brightness = 0.0;
  double _contrast = 1.0;
  double _rotation = 0.0;
  int? _targetWidth;
  int? _targetHeight;
  bool _maintainAspectRatio = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final file = File(widget.imagePath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _editedImage = file;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading image: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _applyBrightness(double value) async {
    if (_imageBytes == null) return;
    setState(() {
      _isProcessing = true;
      _brightness = value;
    });

    try {
      final edited = await ImageEditingService().adjustBrightness(_imageBytes!, value);
      final tempFile = await _saveToTempFile(edited);
      setState(() {
        _imageBytes = edited;
        _editedImage = tempFile;
        _isProcessing = false;
      });
      AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.selectionClick);
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adjusting brightness: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _applyContrast(double value) async {
    if (_imageBytes == null) return;
    setState(() {
      _isProcessing = true;
      _contrast = value;
    });

    try {
      final edited = await ImageEditingService().adjustContrast(_imageBytes!, value);
      final tempFile = await _saveToTempFile(edited);
      setState(() {
        _imageBytes = edited;
        _editedImage = tempFile;
        _isProcessing = false;
      });
      AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.selectionClick);
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adjusting contrast: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _applyRotation(double angle) async {
    if (_imageBytes == null) return;
    setState(() {
      _isProcessing = true;
      _rotation = angle;
    });

    try {
      final edited = await ImageEditingService().rotateImage(_imageBytes!, angle);
      final tempFile = await _saveToTempFile(edited);
      setState(() {
        _imageBytes = edited;
        _editedImage = tempFile;
        _isProcessing = false;
      });
      AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.selectionClick);
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error rotating image: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _applyResize() async {
    if (_imageBytes == null || _targetWidth == null || _targetHeight == null) return;
    setState(() => _isProcessing = true);

    try {
      final edited = await ImageEditingService().resizeImage(
        _imageBytes!,
        _targetWidth!,
        _targetHeight!,
        maintainAspectRatio: _maintainAspectRatio,
      );
      final tempFile = await _saveToTempFile(edited);
      setState(() {
        _imageBytes = edited;
        _editedImage = tempFile;
        _isProcessing = false;
      });
      AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.mediumImpact);
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error resizing image: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _compressImage() async {
    if (_imageBytes == null) return;
    setState(() => _isProcessing = true);

    try {
      final edited = await ImageEditingService().compressImage(_imageBytes!, quality: 85);
      final tempFile = await _saveToTempFile(edited);
      setState(() {
        _imageBytes = edited;
        _editedImage = tempFile;
        _isProcessing = false;
      });
      AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.mediumImpact);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image compressed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error compressing image: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<File> _saveToTempFile(Uint8List bytes) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  Future<void> _saveImage() async {
    if (_editedImage == null) return;

    AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.heavyImpact);
    if (widget.onSave != null) {
      widget.onSave!(_editedImage!.path);
    }
    if (mounted) {
      context.pop(_editedImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
        backgroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
        actions: [
          if (_editedImage != null)
            Semantics(
              label: 'Save edited image',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveImage,
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradientFromContext(context),
        ),
        child: _isProcessing
            ? const Center(child: CircularProgressIndicator())
            : _imageBytes == null
                ? const Center(child: Text('No image loaded'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Image preview
                        Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.getAccentGoldFromContext(context),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _editedImage != null
                                ? Image.file(
                                    _editedImage!,
                                    fit: BoxFit.contain,
                                  )
                                : Image.memory(
                                    _imageBytes!,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),

                        // Brightness control
                        _buildSliderSection(
                          title: 'Brightness',
                          value: _brightness,
                          min: -1.0,
                          max: 1.0,
                          onChanged: _applyBrightness,
                        ),

                        // Contrast control
                        _buildSliderSection(
                          title: 'Contrast',
                          value: _contrast,
                          min: 0.0,
                          max: 2.0,
                          onChanged: _applyContrast,
                        ),

                        // Rotation buttons
                        _buildRotationSection(),

                        // Resize section
                        _buildResizeSection(),

                        // Compress button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Semantics(
                            label: 'Compress image to reduce file size',
                            button: true,
                            child: ElevatedButton.icon(
                              onPressed: _compressImage,
                              icon: const Icon(Icons.compress),
                              label: const Text('Compress Image'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.getSecondaryBackgroundFromContext(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Semantics(
              label: '$title slider',
              slider: true,
              value: value.toStringAsFixed(2),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: 100,
                label: value.toStringAsFixed(2),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRotationSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.getSecondaryBackgroundFromContext(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rotation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildRotationButton('90°', 90),
                _buildRotationButton('180°', 180),
                _buildRotationButton('270°', 270),
                _buildRotationButton('Reset', 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRotationButton(String label, double angle) {
    return Semantics(
      label: 'Rotate image $label',
      button: true,
      child: OutlinedButton(
        onPressed: () => _applyRotation(angle),
        child: Text(label),
      ),
    );
  }

  Widget _buildResizeSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.getSecondaryBackgroundFromContext(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resize',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Width',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _targetWidth = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Height',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _targetHeight = int.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Maintain Aspect Ratio'),
              value: _maintainAspectRatio,
              onChanged: (value) {
                setState(() => _maintainAspectRatio = value ?? true);
              },
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'Apply resize to image',
              button: true,
              child: ElevatedButton(
                onPressed: _applyResize,
                child: const Text('Apply Resize'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

