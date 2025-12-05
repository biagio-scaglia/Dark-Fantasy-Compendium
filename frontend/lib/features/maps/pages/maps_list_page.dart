import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/map_service.dart';
import '../../../data/models/map_model.dart';
import '../../../widgets/map_card.dart';
import 'map_form_page.dart';

class MapsListPage extends StatefulWidget {
  const MapsListPage({super.key});

  @override
  State<MapsListPage> createState() => _MapsListPageState();
}

class _MapsListPageState extends State<MapsListPage> {
  List<MapModel> maps = [];
  bool isLoading = true;
  String? error;
  final MapService _service = MapService();

  @override
  void initState() {
    super.initState();
    _loadMaps();
  }

  Future<void> _loadMaps() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        maps = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
          tooltip: 'Back',
        ),
        title: const Text('Maps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/maps/new'),
            tooltip: 'Add Map',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMaps,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (maps.isEmpty) {
      return const Center(child: Text('No maps found'));
    }

    return RefreshIndicator(
      onRefresh: _loadMaps,
      child: ListView.builder(
        itemCount: maps.length,
        itemBuilder: (context, index) {
          final map = maps[index];
          final mapMap = {
            'id': map.id,
            'name': map.name,
            'description': map.description,
            'image_path': map.imagePath,
            'campaign_id': map.campaignId,
          };
          return MapCard(map: mapMap);
        },
      ),
    );
  }
}


