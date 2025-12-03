import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/weapon_card.dart';

class WeaponsListPage extends StatefulWidget {
  const WeaponsListPage({super.key});

  @override
  State<WeaponsListPage> createState() => _WeaponsListPageState();
}

class _WeaponsListPageState extends State<WeaponsListPage> {
  List<dynamic> weapons = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWeapons();
  }

  Future<void> _loadWeapons() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('weapons');
      setState(() {
        weapons = data;
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
        title: const Text('Armi'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/weapons/new'),
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
              onPressed: _loadWeapons,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (weapons.isEmpty) {
      return const Center(child: Text('Nessuna arma trovata'));
    }

    return RefreshIndicator(
      onRefresh: _loadWeapons,
      child: ListView.builder(
        itemCount: weapons.length,
        itemBuilder: (context, index) {
          return WeaponCard(weapon: weapons[index]);
        },
      ),
    );
  }
}

