import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/knight_card.dart';
import 'knight_form_page.dart';

class KnightsListPage extends StatefulWidget {
  const KnightsListPage({super.key});

  @override
  State<KnightsListPage> createState() => _KnightsListPageState();
}

class _KnightsListPageState extends State<KnightsListPage> {
  List<dynamic> knights = [];
  bool isLoading = true;
  String? error;

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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('knights');
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
          onPressed: () => context.go('/'),
          tooltip: 'Indietro',
        ),
        title: const Text('Cavalieri'),
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
            Text('Errore: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadKnights,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (knights.isEmpty) {
      return const Center(child: Text('Nessun cavaliere trovato'));
    }

    return RefreshIndicator(
      onRefresh: _loadKnights,
      child: ListView.builder(
        itemCount: knights.length,
        itemBuilder: (context, index) {
          return KnightCard(knight: knights[index]);
        },
      ),
    );
  }
}

