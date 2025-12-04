import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/class_service.dart';
import '../../../data/models/class_model.dart';
import '../../../widgets/dnd_class_card.dart';

class DndClassesListPage extends StatefulWidget {
  const DndClassesListPage({super.key});

  @override
  State<DndClassesListPage> createState() => _DndClassesListPageState();
}

class _DndClassesListPageState extends State<DndClassesListPage> {
  List<ClassModel> classes = [];
  bool isLoading = true;
  String? error;
  final ClassService _service = ClassService();

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
      final data = await _service.getAll();
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
          onPressed: () => context.go('/home'),
        ),
        title: const Text('D&D Classes'),
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
            Text('Error: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadClasses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (classes.isEmpty) {
      return const Center(child: Text('No classes found'));
    }

    return RefreshIndicator(
      onRefresh: _loadClasses,
      child: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final cls = classes[index];
          final clsMap = {
            'id': cls.id,
            'name': cls.name,
            'description': cls.description,
            'hit_dice': cls.hitDice,
            'image_path': cls.imagePath,
            'icon_path': cls.iconPath,
          };
          return DndClassCard(dndClass: clsMap);
        },
      ),
    );
  }
}

