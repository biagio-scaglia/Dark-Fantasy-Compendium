import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/faction_card.dart';

class FactionsListPage extends StatefulWidget {
  const FactionsListPage({super.key});

  @override
  State<FactionsListPage> createState() => _FactionsListPageState();
}

class _FactionsListPageState extends State<FactionsListPage> {
  List<dynamic> factions = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadFactions();
  }

  Future<void> _loadFactions() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('factions');
      setState(() {
        factions = data;
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
        title: const Text('Factions'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/factions/new'),
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
              onPressed: _loadFactions,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (factions.isEmpty) {
      return const Center(child: Text('No factions found'));
    }

    return RefreshIndicator(
      onRefresh: _loadFactions,
      child: ListView.builder(
        itemCount: factions.length,
        itemBuilder: (context, index) {
          return FactionCard(faction: factions[index]);
        },
      ),
    );
  }
}

