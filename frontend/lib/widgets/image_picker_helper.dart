import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../data/services/local_json_service.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();
  static final LocalJsonService _jsonService = LocalJsonService();

  static Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return image.path;
      }
    } catch (e) {
    }
    return null;
  }

  static Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return image.path;
      }
    } catch (e) {
    }
    return null;
  }

  static Future<String?> pickImageFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      }
    } catch (e) {
    }
    return null;
  }

  static Future<String?> saveImageForEntity(String imagePath, String entityType, int entityId) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await _jsonService.saveImage(file, entityType, entityId);
      }
    } catch (e) {
    }
    return null;
  }

  static Future<void> deleteImageForEntity(String? imagePath) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      await _jsonService.deleteImage(imagePath);
    }
  }

  static Widget buildImageWidget(String? imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    try {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        );
      }
    } catch (e) {
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  static Future<String?> showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await pickImageFromGallery();
                  if (path != null && context.mounted) {
                    Navigator.pop(context, path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await pickImageFromCamera();
                  if (path != null && context.mounted) {
                    Navigator.pop(context, path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('File Picker'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await pickImageFromFile();
                  if (path != null && context.mounted) {
                    Navigator.pop(context, path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

