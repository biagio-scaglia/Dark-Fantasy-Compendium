import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<dynamic>> getAll(String endpoint) async {
    throw UnimplementedError('This app now uses local JSON services. Please update the page to use the appropriate service from lib/data/services/');
  }

  Future<Map<String, dynamic>> getOne(String endpoint, int id) async {
    throw UnimplementedError('This app now uses local JSON services. Please update the page to use the appropriate service from lib/data/services/');
  }

  Future<dynamic> get(String endpoint) async {
    throw UnimplementedError('This app now uses local JSON services. Please update the page to use the appropriate service from lib/data/services/');
  }

  Future<Map<String, dynamic>> create(String endpoint, Map<String, dynamic> data) async {
    throw UnimplementedError('This app now uses local JSON services. Please update the page to use the appropriate service from lib/data/services/');
  }

  Future<Map<String, dynamic>> update(String endpoint, int id, Map<String, dynamic> data) async {
    throw UnimplementedError('This app now uses local JSON services. Please update the page to use the appropriate service from lib/data/services/');
  }

  Future<void> delete(String endpoint, int id) async {
    throw UnimplementedError('This app now uses local JSON services. Please update the page to use the appropriate service from lib/data/services/');
  }

  Future<String> uploadImage(dynamic imageFile, {bool isIcon = false}) async {
    throw UnimplementedError('This app now uses local image handling. Please use ImagePickerHelper from lib/widgets/image_picker_helper.dart');
  }
}

