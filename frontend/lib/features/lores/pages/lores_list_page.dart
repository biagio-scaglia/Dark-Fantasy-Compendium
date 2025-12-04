import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/lore_card.dart';

class LoresListPage extends StatefulWidget {
  const LoresListPage({super.key});

  @override
  State<LoresListPage> createState() => _LoresListPageState();
}

class _LoresListPageState extends State<LoresListPage> {
  List<dynamic> lores = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadLores();
  }

  Future<void> _loadLores() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('lores');
      setState(() {
        lores = data;
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
        title: const Text('Lore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/lores/new'),
            tooltip: 'New Lore',
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
              onPressed: _loadLores,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (lores.isEmpty) {
      return const Center(child: Text('No lore entries found'));
    }

    return RefreshIndicator(
      onRefresh: _loadLores,
      child: ListView.builder(
        itemCount: lores.length,
        itemBuilder: (context, index) {
          return LoreCard(lore: lores[index]);
        },
      ),
    );
  }
}

