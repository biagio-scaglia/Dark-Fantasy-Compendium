import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/boss_card.dart';

class BossesListPage extends StatefulWidget {
  const BossesListPage({super.key});

  @override
  State<BossesListPage> createState() => _BossesListPageState();
}

class _BossesListPageState extends State<BossesListPage> {
  List<dynamic> bosses = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadBosses();
  }

  Future<void> _loadBosses() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('bosses');
      setState(() {
        bosses = data;
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
        title: const Text('Boss'),
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
              onPressed: _loadBosses,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (bosses.isEmpty) {
      return const Center(child: Text('Nessun boss trovato'));
    }

    return RefreshIndicator(
      onRefresh: _loadBosses,
      child: ListView.builder(
        itemCount: bosses.length,
        itemBuilder: (context, index) {
          return BossCard(boss: bosses[index]);
        },
      ),
    );
  }
}

