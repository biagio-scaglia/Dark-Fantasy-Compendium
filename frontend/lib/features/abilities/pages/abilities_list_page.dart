import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';

class AbilitiesListPage extends StatefulWidget {
  const AbilitiesListPage({super.key});

  @override
  State<AbilitiesListPage> createState() => _AbilitiesListPageState();
}

class _AbilitiesListPageState extends State<AbilitiesListPage> {
  List<dynamic> abilities = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadAbilities();
  }

  Future<void> _loadAbilities() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('abilities');
      setState(() {
        abilities = data;
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
        title: const Text('Abilities'),
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
              onPressed: _loadAbilities,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (abilities.isEmpty) {
      return const Center(
        child: Text('No abilities found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: abilities.length,
      itemBuilder: (context, index) {
        final ability = abilities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(ability['name'] ?? 'Unknown'),
            subtitle: Text(ability['description'] ?? ''),
            onTap: () {
            },
          ),
        );
      },
    );
  }
}

