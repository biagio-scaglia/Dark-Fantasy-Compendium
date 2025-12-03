import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/dnd_class_card.dart';

class DndClassesListPage extends StatefulWidget {
  const DndClassesListPage({super.key});

  @override
  State<DndClassesListPage> createState() => _DndClassesListPageState();
}

class _DndClassesListPageState extends State<DndClassesListPage> {
  List<dynamic> classes = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('dnd-classes');
      setState(() {
        classes = data;
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
        ),
        title: const Text('Classi D&D'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/dnd-classes/new'),
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
              onPressed: _loadClasses,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (classes.isEmpty) {
      return const Center(child: Text('Nessuna classe trovata'));
    }

    return RefreshIndicator(
      onRefresh: _loadClasses,
      child: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return DndClassCard(dndClass: classes[index]);
        },
      ),
    );
  }
}

