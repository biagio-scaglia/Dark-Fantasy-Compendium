import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'api_service.dart';

class PdfExportService {
  final ApiService apiService;

  PdfExportService(this.apiService);

  Future<Map<String, dynamic>> checkStatus() async {
    try {
      final response = await apiService.get('pdf-export/status');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Errore nel controllo stato PDF export: $e');
    }
  }

  Future<void> exportCharacterPdf(int characterId, {bool simple = true}) async {
    try {
      final endpoint = simple 
          ? 'pdf-export/character/$characterId/simple'
          : 'pdf-export/character/$characterId';
      
      // Costruisci l'URL completo
      final baseUrl = apiService.baseUrl;
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Accept': 'application/pdf'},
      );

      if (response.statusCode == 200) {
        // Salva il PDF
        final bytes = response.bodyBytes;
        await _saveAndOpenPdf(bytes, 'character_$characterId.pdf');
      } else {
        throw Exception('Errore nell\'export PDF: ${response.body}');
      }
    } catch (e) {
      throw Exception('Errore nell\'export PDF: $e');
    }
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
      throw Exception('Errore nel salvataggio/apertura PDF: $e');
    }
  }
}

