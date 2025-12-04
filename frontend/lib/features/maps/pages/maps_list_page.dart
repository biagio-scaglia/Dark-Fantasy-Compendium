import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/map_card.dart';
import 'map_form_page.dart';

class MapsListPage extends StatefulWidget {
  const MapsListPage({super.key});

  @override
  State<MapsListPage> createState() => _MapsListPageState();
}

class _MapsListPageState extends State<MapsListPage> {
  List<dynamic> maps = [];
  bool isLoading = true;
  String? error;

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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('maps');
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
          onPressed: () => context.go('/'),
          tooltip: 'Back',
        ),
        title: const Text('Maps'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/maps/new'),
        child: const Icon(Icons.add),
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
          return MapCard(map: maps[index]);
        },
      ),
    );
  }
}

