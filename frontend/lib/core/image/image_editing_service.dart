import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Service for image editing operations (all in isolates)
class ImageEditingService {
  static final ImageEditingService _instance = ImageEditingService._internal();
  factory ImageEditingService() => _instance;
  ImageEditingService._internal();

  /// Crop image
  Future<Uint8List> cropImage(
    Uint8List imageBytes,
    int x,
    int y,
    int width,
    int height,
  ) async {
    return await compute(_cropImageIsolateStatic, {
      'bytes': imageBytes,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    });
  }

  /// Resize image
  Future<Uint8List> resizeImage(
    Uint8List imageBytes,
    int width,
    int height, {
    bool maintainAspectRatio = true,
  }) async {
    return await compute(_resizeImageIsolateStatic, {
      'bytes': imageBytes,
      'width': width,
      'height': height,
      'maintainAspectRatio': maintainAspectRatio,
    });
  }

  /// Rotate image
  Future<Uint8List> rotateImage(
    Uint8List imageBytes,
    double angle,
  ) async {
    return await compute(_rotateImageIsolateStatic, {
      'bytes': imageBytes,
      'angle': angle,
    });
  }

  /// Apply brightness adjustment
  Future<Uint8List> adjustBrightness(
    Uint8List imageBytes,
    double brightness, {
    double min = -1.0,
    double max = 1.0,
  }) async {
    final clampedBrightness = brightness.clamp(min, max);
    return await compute(_adjustBrightnessIsolateStatic, {
      'bytes': imageBytes,
      'brightness': clampedBrightness,
    });
  }

  /// Apply contrast adjustment
  Future<Uint8List> adjustContrast(
    Uint8List imageBytes,
    double contrast, {
    double min = 0.0,
    double max = 2.0,
  }) async {
    final clampedContrast = contrast.clamp(min, max);
    return await compute(_adjustContrastIsolateStatic, {
      'bytes': imageBytes,
      'contrast': clampedContrast,
    });
  }

  /// Compress image
  Future<Uint8List> compressImage(
    Uint8List imageBytes, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  }) async {
    return await compute(_compressImageIsolateStatic, {
      'bytes': imageBytes,
      'quality': quality,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
    });
  }

  /// Get image dimensions
  Future<ImageDimensions> getImageDimensions(Uint8List imageBytes) async {
    return await compute(_getImageDimensionsIsolateStatic, imageBytes);
  }
}

/// Image dimensions
class ImageDimensions {
  final int width;
  final int height;

  ImageDimensions({required this.width, required this.height});
}

// Static isolate functions (must be top-level or static)

Uint8List _cropImageIsolateStatic(Map<String, dynamic> params) {
  try {
    final bytes = params['bytes'] as Uint8List;
    final x = params['x'] as int;
    final y = params['y'] as int;
    final width = params['width'] as int;
    final height = params['height'] as int;

    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    final cropped = img.copyCrop(image, x: x, y: y, width: width, height: height);
    return Uint8List.fromList(img.encodeJpg(cropped, quality: 90));
  } catch (e) {
    throw Exception('Crop failed: $e');
  }
}

Uint8List _resizeImageIsolateStatic(Map<String, dynamic> params) {
  try {
    final bytes = params['bytes'] as Uint8List;
    final width = params['width'] as int;
    final height = params['height'] as int;
    final maintainAspectRatio = params['maintainAspectRatio'] as bool? ?? true;

    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    img.Image resized;
    if (maintainAspectRatio) {
      resized = img.copyResize(
        image,
        width: width,
        height: height,
        interpolation: img.Interpolation.linear,
      );
    } else {
      resized = img.copyResize(
        image,
        width: width,
        height: height,
        interpolation: img.Interpolation.linear,
      );
    }

    return Uint8List.fromList(img.encodeJpg(resized, quality: 90));
  } catch (e) {
    throw Exception('Resize failed: $e');
  }
}

Uint8List _rotateImageIsolateStatic(Map<String, dynamic> params) {
  try {
    final bytes = params['bytes'] as Uint8List;
    final angle = params['angle'] as double;

    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    final rotated = img.copyRotate(image, angle: angle);
    return Uint8List.fromList(img.encodeJpg(rotated, quality: 90));
  } catch (e) {
    throw Exception('Rotate failed: $e');
  }
}

Uint8List _adjustBrightnessIsolateStatic(Map<String, dynamic> params) {
  try {
    final bytes = params['bytes'] as Uint8List;
    final brightness = params['brightness'] as double;

    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    final adjusted = img.adjustColor(
      image,
      brightness: brightness,
    );

    return Uint8List.fromList(img.encodeJpg(adjusted, quality: 90));
  } catch (e) {
    throw Exception('Brightness adjustment failed: $e');
  }
}

Uint8List _adjustContrastIsolateStatic(Map<String, dynamic> params) {
  try {
    final bytes = params['bytes'] as Uint8List;
    final contrast = params['contrast'] as double;

    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    final adjusted = img.adjustColor(
      image,
      contrast: contrast,
    );

    return Uint8List.fromList(img.encodeJpg(adjusted, quality: 90));
  } catch (e) {
    throw Exception('Contrast adjustment failed: $e');
  }
}

Uint8List _compressImageIsolateStatic(Map<String, dynamic> params) {
  try {
    final bytes = params['bytes'] as Uint8List;
    final quality = params['quality'] as int? ?? 85;
    final maxWidth = params['maxWidth'] as int?;
    final maxHeight = params['maxHeight'] as int?;

    var image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    // Resize if needed
    if (maxWidth != null || maxHeight != null) {
      final targetWidth = maxWidth ?? image.width;
      final targetHeight = maxHeight ?? image.height;
      image = img.copyResize(
        image,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.linear,
      );
    }

    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  } catch (e) {
    throw Exception('Compression failed: $e');
  }
}

ImageDimensions _getImageDimensionsIsolateStatic(Uint8List bytes) {
  try {
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    return ImageDimensions(width: image.width, height: image.height);
  } catch (e) {
    throw Exception('Failed to get dimensions: $e');
  }
}


