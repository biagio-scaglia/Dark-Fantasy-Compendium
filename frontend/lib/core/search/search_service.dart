import '../../utils/logger.dart';

/// Search service with full-text search and indexing
class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final Map<String, SearchIndex> _indices = {};

  /// Create or update search index for a collection
  void indexCollection(String collectionName, List<Map<String, dynamic>> items) {
    final index = SearchIndex();
    for (var item in items) {
      index.addItem(item);
    }
    _indices[collectionName] = index;
    AppLogger.debug('Indexed ${items.length} items for $collectionName');
  }

  /// Search across a collection
  List<Map<String, dynamic>> search(
    String collectionName,
    String query, {
    List<String>? fields,
    int? limit,
  }) {
    final index = _indices[collectionName];
    if (index == null) {
      AppLogger.warning('No index found for collection: $collectionName');
      return [];
    }

    return index.search(query, fields: fields, limit: limit);
  }

  /// Search across all collections
  Map<String, List<Map<String, dynamic>>> searchAll(String query, {int? limit}) {
    final results = <String, List<Map<String, dynamic>>>{};
    for (var collectionName in _indices.keys) {
      final collectionResults = search(collectionName, query, limit: limit);
      if (collectionResults.isNotEmpty) {
        results[collectionName] = collectionResults;
      }
    }
    return results;
  }

  /// Clear index for a collection
  void clearIndex(String collectionName) {
    _indices.remove(collectionName);
  }

  /// Clear all indices
  void clearAllIndices() {
    _indices.clear();
  }
}

/// Search index with tokenized queries
class SearchIndex {
  final Map<String, Set<int>> _termToIds = {};
  final Map<int, Map<String, dynamic>> _idToItem = {};
  final Map<int, String> _idToText = {};

  /// Add item to index
  void addItem(Map<String, dynamic> item) {
    final id = item['id'] as int?;
    if (id == null) return;

    _idToItem[id] = item;

    // Extract searchable text from all string fields
    final searchableText = _extractSearchableText(item);
    _idToText[id] = searchableText;

    // Tokenize and index
    final tokens = _tokenize(searchableText);
    for (var token in tokens) {
      _termToIds.putIfAbsent(token, () => <int>{}).add(id);
    }
  }

  /// Extract all searchable text from item
  String _extractSearchableText(Map<String, dynamic> item) {
    final buffer = StringBuffer();
    _extractTextRecursive(item, buffer);
    return buffer.toString().toLowerCase();
  }

  void _extractTextRecursive(dynamic value, StringBuffer buffer) {
    if (value is Map) {
      for (var entry in value.entries) {
        // Skip internal fields
        if (entry.key == 'id' || entry.key == 'image_path' || entry.key == 'icon_path') {
          continue;
        }
        _extractTextRecursive(entry.value, buffer);
      }
    } else if (value is List) {
      for (var item in value) {
        _extractTextRecursive(item, buffer);
      }
    } else if (value is String) {
      buffer.write('$value ');
    } else if (value != null) {
      buffer.write('$value ');
    }
  }

  /// Tokenize text into search terms
  List<String> _tokenize(String text) {
    // Split by whitespace and punctuation, keep alphanumeric tokens
    final tokens = text
        .toLowerCase()
        .split(RegExp(r'[\s\W]+'))
        .where((token) => token.isNotEmpty && token.length > 1)
        .toSet()
        .toList();

    // Add n-grams for better matching (2-char and 3-char)
    final ngrams = <String>{};
    for (var token in tokens) {
      if (token.length >= 2) {
        for (var i = 0; i <= token.length - 2; i++) {
          ngrams.add(token.substring(i, i + 2));
        }
      }
      if (token.length >= 3) {
        for (var i = 0; i <= token.length - 3; i++) {
          ngrams.add(token.substring(i, i + 3));
        }
      }
    }

    return [...tokens, ...ngrams];
  }

  /// Search with tokenized query
  List<Map<String, dynamic>> search(
    String query, {
    List<String>? fields,
    int? limit,
  }) {
    if (query.trim().isEmpty) {
      return _idToItem.values.toList();
    }

    final queryTokens = _tokenize(query.toLowerCase());
    if (queryTokens.isEmpty) {
      return [];
    }

    // Find items that match all tokens (AND) or any token (OR)
    final matchingIds = <int, int>{};

    for (var token in queryTokens) {
      final ids = _termToIds[token];
      if (ids != null) {
        for (var id in ids) {
          matchingIds[id] = (matchingIds[id] ?? 0) + 1;
        }
      }
    }

    // Score by number of matching tokens
    final scoredResults = matchingIds.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Filter by fields if specified
    var results = scoredResults
        .map((entry) => _idToItem[entry.key]!)
        .where((item) => fields == null || _matchesFields(item, query, fields))
        .toList();

    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }

    return results;
  }

  /// Check if item matches query in specified fields
  bool _matchesFields(Map<String, dynamic> item, String query, List<String> fields) {
    final lowerQuery = query.toLowerCase();
    for (var field in fields) {
      final value = item[field];
      if (value != null && value.toString().toLowerCase().contains(lowerQuery)) {
        return true;
      }
    }
    return false;
  }

  /// Get all items
  List<Map<String, dynamic>> getAll() {
    return _idToItem.values.toList();
  }

  /// Clear index
  void clear() {
    _termToIds.clear();
    _idToItem.clear();
    _idToText.clear();
  }
}


