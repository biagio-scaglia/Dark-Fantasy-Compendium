import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/knight_service.dart';
import '../../../data/models/knight.dart';
import '../../../widgets/knight_card.dart';
import 'knight_form_page.dart';

class KnightsListPage extends StatefulWidget {
  const KnightsListPage({super.key});

  @override
  State<KnightsListPage> createState() => _KnightsListPageState();
}

class _KnightsListPageState extends State<KnightsListPage> {
  List<Knight> knights = [];
  bool isLoading = true;
  String? error;
  final KnightService _service = KnightService();

  @override
  void initState() {
    super.initState();
    _loadKnights();
  }

  Future<void> _loadKnights() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        knights = data;
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
        title: const Text('Knights'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/knights/new'),
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
              onPressed: _loadKnights,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (knights.isEmpty) {
      return const Center(child: Text('No knights found'));
    }

    return RefreshIndicator(
      onRefresh: _loadKnights,
      child: ListView.builder(
        itemCount: knights.length,
        itemBuilder: (context, index) {
          final knight = knights[index];
          final knightMap = {
            'id': knight.id,
            'name': knight.name,
            'title': knight.title,
            'level': knight.level,
            'health': knight.health,
            'max_health': knight.maxHealth,
            'attack': knight.attack,
            'defense': knight.defense,
            'image_path': knight.imagePath,
            'icon_path': knight.iconPath,
          };
          return KnightCard(knight: knightMap);
        },
      ),
    );
  }
}

