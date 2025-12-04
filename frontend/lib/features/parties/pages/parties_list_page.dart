import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/party_card.dart';

class PartiesListPage extends StatefulWidget {
  const PartiesListPage({super.key});

  @override
  State<PartiesListPage> createState() => _PartiesListPageState();
}

class _PartiesListPageState extends State<PartiesListPage> {
  List<dynamic> parties = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadParties();
  }

  Future<void> _loadParties() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('parties');
      setState(() {
        parties = data;
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
        ),
        title: const Text('Party'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/parties/new'),
        child: const Icon(Icons.add),
      ),
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
              onPressed: _loadParties,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (parties.isEmpty) {
      return const Center(child: Text('No parties found'));
    }

    return RefreshIndicator(
      onRefresh: _loadParties,
      child: ListView.builder(
        itemCount: parties.length,
        itemBuilder: (context, index) {
          return PartyCard(party: parties[index]);
        },
      ),
    );
  }
}

