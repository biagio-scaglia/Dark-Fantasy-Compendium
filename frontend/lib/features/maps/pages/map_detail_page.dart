import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/map_service.dart';
import '../../../data/models/map_model.dart';
import '../../../core/theme/app_theme.dart';
import 'map_form_page.dart';

class MapDetailPage extends StatefulWidget {
  final int mapId;

  const MapDetailPage({super.key, required this.mapId});

  @override
  State<MapDetailPage> createState() => _MapDetailPageState();
}

class _MapDetailPageState extends State<MapDetailPage> {
  Map<String, dynamic>? map;
  bool isLoading = true;
  String? error;
  final MapService _service = MapService();

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  Future<void> _loadMap() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final mapData = await _service.getById(widget.mapId);
      if (mapData != null) {
        final data = mapData.toJson();
        setState(() {
          map = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Map not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || map == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map')),
        body: Center(child: Text('Error: ${error ?? "Map not found"}')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(map!['name'] ?? 'Mappa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/maps/${widget.mapId}/edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (map!['image_url'] != null)
              Image.network(
                map!['image_url'],
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Immagine non disponibile')),
                  );
                },
              ),
            const SizedBox(height: 16),
            Text(
              map!['name'] ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              map!['description'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (map!['markers'] != null && (map!['markers'] as List).isNotEmpty)
              _buildMarkersSection(),
            if (map!['notes'] != null && map!['notes'].toString().isNotEmpty)
              _buildNotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkersSection() {
    final markers = map!['markers'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Marcatori (${markers.length})',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...markers.map((marker) => Card(
          child: ListTile(
            title: Text(marker['name'] ?? ''),
            subtitle: Text(marker['type'] ?? ''),
            trailing: Text('${marker['x']?.toStringAsFixed(1) ?? 0}%, ${marker['y']?.toStringAsFixed(1) ?? 0}%'),
          ),
        )),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(map!['notes'] ?? ''),
      ],
    );
  }
}

