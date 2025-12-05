import 'deep_link_service.dart';

/// Service for app indexing and SEO
class AppIndexing {
  static final AppIndexing _instance = AppIndexing._internal();
  factory AppIndexing() => _instance;
  AppIndexing._internal();

  final DeepLinkService _deepLinkService = DeepLinkService();

  /// Get app metadata for stores
  Map<String, dynamic> getAppMetadata() {
    return {
      'name': 'Dark Fantasy Compendium',
      'description': 'Offline D&D campaign manager with local data storage',
      'category': 'Games',
      'tags': [
        'D&D',
        'Dungeons & Dragons',
        'RPG',
        'Campaign Manager',
        'Character Sheet',
        'Offline',
        'Fantasy',
      ],
      'keywords': [
        'dnd',
        'dungeons dragons',
        'rpg',
        'campaign',
        'character',
        'spell',
        'item',
        'offline',
        'fantasy',
      ],
      'version': '1.0.0',
      'platform': 'mobile',
    };
  }

  /// Get navigation structure for indexing
  Map<String, dynamic> getNavigationStructure() {
    final routes = _deepLinkService.getAllRoutes();
    
    return {
      'structure': routes.map((route) => {
            'path': route.path,
            'title': route.title,
            'description': route.description,
            'indexable': true,
          }).toList(),
      'hierarchy': _buildHierarchy(routes),
    };
  }

  /// Build navigation hierarchy
  Map<String, dynamic> _buildHierarchy(List<DeepLinkRoute> routes) {
    final hierarchy = <String, dynamic>{
      'home': {
        'path': '/',
        'children': [],
      },
    };

    for (var route in routes) {
      if (route.path == '/') continue;

      final parts = route.path.split('/').where((p) => p.isNotEmpty).toList();
      if (parts.isEmpty) continue;

      final category = parts[0];
      if (!hierarchy.containsKey(category)) {
        hierarchy[category] = {
          'path': '/$category',
          'children': [],
        };
      }

      if (parts.length > 1) {
        (hierarchy[category] as Map<String, dynamic>)['children'].add({
          'path': route.path,
          'title': route.title,
        });
      }
    }

    return hierarchy;
  }

  /// Generate sitemap
  Map<String, dynamic> generateSitemap() {
    return _deepLinkService.generateSitemap();
  }

  /// Get route metadata for indexing
  Map<String, dynamic> getRouteMetadata(String path) {
    return _deepLinkService.getRouteMetadata(path);
  }

  /// Get all indexable routes
  List<Map<String, dynamic>> getAllIndexableRoutes() {
    return _deepLinkService.getAllRoutes().map((route) => {
          'path': route.path,
          'title': route.title,
          'description': route.description,
          'metadata': getRouteMetadata(route.path),
        }).toList();
  }
}


