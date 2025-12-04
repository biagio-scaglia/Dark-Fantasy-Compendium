import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/armor_card.dart';

class ArmorsListPage extends StatefulWidget {
  const ArmorsListPage({super.key});

  @override
  State<ArmorsListPage> createState() => _ArmorsListPageState();
}

class _ArmorsListPageState extends State<ArmorsListPage> {
  List<dynamic> armors = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadArmors();
  }

  Future<void> _loadArmors() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('armors');
      setState(() {
        armors = data;
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
        title: const Text('Armor'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/armors/new'),
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
              onPressed: _loadArmors,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (armors.isEmpty) {
      return const Center(child: Text('No armor found'));
    }

    return RefreshIndicator(
      onRefresh: _loadArmors,
      child: ListView.builder(
        itemCount: armors.length,
        itemBuilder: (context, index) {
          return ArmorCard(armor: armors[index]);
        },
      ),
    );
  }
}

