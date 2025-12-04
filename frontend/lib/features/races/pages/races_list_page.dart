import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/race_service.dart';
import '../../../data/models/race.dart';
import '../../../widgets/image_picker_helper.dart';
import 'race_form_page.dart';
import 'race_detail_page.dart';

class RacesListPage extends StatefulWidget {
  const RacesListPage({super.key});

  @override
  State<RacesListPage> createState() => _RacesListPageState();
}

class _RacesListPageState extends State<RacesListPage> {
  List<Race> races = [];
  bool isLoading = true;
  String? error;
  final RaceService _service = RaceService();

  @override
  void initState() {
    super.initState();
    _loadRaces();
  }

  Future<void> _loadRaces() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        races = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteRace(Race race) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Race'),
        content: Text('Are you sure you want to delete ${race.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _service.delete(race.id);
        if (race.imagePath != null) {
          await ImagePickerHelper.deleteImageForEntity(race.imagePath);
        }
        _loadRaces();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting: $e'), backgroundColor: Colors.red),
          );
        }
      }
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
        title: const Text('Races'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await context.push('/races/new');
              _loadRaces();
            },
            tooltip: 'New Race',
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
              onPressed: _loadRaces,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (races.isEmpty) {
      return const Center(
        child: Text('No races found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRaces,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: races.length,
        itemBuilder: (context, index) {
          final race = races[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: ImagePickerHelper.buildImageWidget(race.imagePath),
              ),
              title: Text(race.name),
              subtitle: Text(race.description ?? ''),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () async {
                      await Future.delayed(Duration.zero);
                      if (mounted) {
                        await context.push('/races/${race.id}/edit');
                        _loadRaces();
                      }
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onTap: () => _deleteRace(race),
                  ),
                ],
              ),
              onTap: () {
                context.push('/races/${race.id}');
              },
            ),
          );
        },
      ),
    );
  }
}

