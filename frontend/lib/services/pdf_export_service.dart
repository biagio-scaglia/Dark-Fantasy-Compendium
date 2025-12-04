import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfExportService {
  PdfExportService();

  Future<Map<String, dynamic>> checkStatus() async {
    throw UnimplementedError('PDF export is not available in offline mode. This feature requires a backend API.');
  }

  Future<void> exportCharacterPdf(int characterId, {bool simple = true}) async {
    throw UnimplementedError('PDF export is not available in offline mode. This feature requires a backend API.');
  }

  Future<void> _saveAndOpenPdf(Uint8List bytes, String filename) async {
    try {
      // Ottieni la directory dei documenti
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      
      // Scrivi il file
      await file.writeAsBytes(bytes);
      
      // Apri il file
      await OpenFile.open(file.path);
    } catch (e) {
      throw Exception('Error saving/opening PDF: $e');
    }
  }
}

