import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<dynamic>> getAll(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List;
      }
      throw Exception('Failed to load $endpoint');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getOne(String endpoint, int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      throw Exception('Failed to load $endpoint/$id');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> create(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      throw Exception('Failed to create $endpoint');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> update(String endpoint, int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      throw Exception('Failed to update $endpoint/$id');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> delete(String endpoint, int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$endpoint/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete $endpoint/$id');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> uploadImage(File imageFile, {bool isIcon = false}) async {
    try {
      final endpoint = isIcon ? 'upload/icon' : 'upload/image';
      final uri = Uri.parse('$baseUrl/$endpoint');
      
      final request = http.MultipartRequest('POST', uri);
      final fileStream = http.ByteStream(imageFile.openRead());
      final fileLength = await imageFile.length();
      
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: imageFile.path.split('/').last,
      );
      
      request.files.add(multipartFile);
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        // Restituisce l'URL completo
        final url = data['url'] as String;
        // Se l'URL non inizia con http, aggiungi il baseUrl
        if (url.startsWith('http')) {
          return url;
        } else if (url.startsWith('/')) {
          return '$baseUrl$url';
        } else {
          return '$baseUrl/$url';
        }
      }
      throw Exception('Failed to upload image: ${response.body}');
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}

