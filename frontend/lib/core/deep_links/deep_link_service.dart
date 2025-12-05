import '../../utils/logger.dart';

/// Service for handling deep links and app indexing
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final Map<String, DeepLinkRoute> _routes = {};

  /// Initialize deep link routes
  void initialize() {
    _registerRoutes();
    AppLogger.info('Deep link service initialized with ${_routes.length} routes');
  }

  /// Register all deep link routes
  void _registerRoutes() {
    // Characters
    _routes['/characters'] = DeepLinkRoute(
      path: '/characters',
      title: 'Characters',
      description: 'View all characters',
    );
    _routes['/characters/:id'] = DeepLinkRoute(
      path: '/characters/:id',
      title: 'Character Details',
      description: 'View character details',
    );

    // Campaigns
    _routes['/campaigns'] = DeepLinkRoute(
      path: '/campaigns',
      title: 'Campaigns',
      description: 'View all campaigns',
    );
    _routes['/campaigns/:id'] = DeepLinkRoute(
      path: '/campaigns/:id',
      title: 'Campaign Details',
      description: 'View campaign details',
    );

    // Items
    _routes['/items'] = DeepLinkRoute(
      path: '/items',
      title: 'Items',
      description: 'View all items',
    );
    _routes['/items/:id'] = DeepLinkRoute(
      path: '/items/:id',
      title: 'Item Details',
      description: 'View item details',
    );

    // Spells
    _routes['/spells'] = DeepLinkRoute(
      path: '/spells',
      title: 'Spells',
      description: 'View all spells',
    );

    // Parties
    _routes['/parties'] = DeepLinkRoute(
      path: '/parties',
      title: 'Parties',
      description: 'View all parties',
    );
    _routes['/parties/:id'] = DeepLinkRoute(
      path: '/parties/:id',
      title: 'Party Details',
      description: 'View party details',
    );

    // Maps
    _routes['/maps'] = DeepLinkRoute(
      path: '/maps',
      title: 'Maps',
      description: 'View all maps',
    );
    _routes['/maps/:id'] = DeepLinkRoute(
      path: '/maps/:id',
      title: 'Map Details',
      description: 'View map details',
    );

    // Bosses
    _routes['/bosses'] = DeepLinkRoute(
      path: '/bosses',
      title: 'Bosses',
      description: 'View all bosses',
    );
    _routes['/bosses/:id'] = DeepLinkRoute(
      path: '/bosses/:id',
      title: 'Boss Details',
      description: 'View boss details',
    );

    // Home
    _routes['/'] = DeepLinkRoute(
      path: '/',
      title: 'Home',
      description: 'Dark Fantasy Compendium home',
    );
  }

  /// Get route by path
  DeepLinkRoute? getRoute(String path) {
    // Try exact match first
    if (_routes.containsKey(path)) {
      return _routes[path];
    }

    // Try pattern matching for dynamic routes
    for (var route in _routes.values) {
      if (_matchesPattern(route.path, path)) {
        return route;
      }
    }

    return null;
  }

  /// Check if path matches pattern
  bool _matchesPattern(String pattern, String path) {
    final patternParts = pattern.split('/');
    final pathParts = path.split('/');

    if (patternParts.length != pathParts.length) {
      return false;
    }

    for (var i = 0; i < patternParts.length; i++) {
      if (patternParts[i].startsWith(':')) {
        // Dynamic segment
        continue;
      }
      if (patternParts[i] != pathParts[i]) {
        return false;
      }
    }

    return true;
  }

  /// Get all routes for indexing
  List<DeepLinkRoute> getAllRoutes() {
    return _routes.values.toList();
  }

  /// Generate sitemap for app indexing
  Map<String, dynamic> generateSitemap() {
    return {
      'version': '1.0',
      'routes': _routes.values.map((route) => {
            'path': route.path,
            'title': route.title,
            'description': route.description,
          }).toList(),
    };
  }

  /// Get metadata for a route
  Map<String, dynamic> getRouteMetadata(String path) {
    final route = getRoute(path);
    if (route == null) {
      return {};
    }

    return {
      'title': route.title,
      'description': route.description,
      'path': route.path,
    };
  }
}

/// Deep link route definition
class DeepLinkRoute {
  final String path;
  final String title;
  final String description;

  DeepLinkRoute({
    required this.path,
    required this.title,
    required this.description,
  });
}


