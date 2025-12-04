import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/item_card.dart';

class ItemsListPage extends StatefulWidget {
  const ItemsListPage({super.key});

  @override
  State<ItemsListPage> createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {
  List<dynamic> items = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('items');
      setState(() {
        items = data;
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
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/items/new'),
            tooltip: 'New Item',
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
              onPressed: _loadItems,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(child: Text('No items found'));
    }

    return RefreshIndicator(
      onRefresh: _loadItems,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemCard(item: items[index]);
        },
      ),
    );
  }
}

