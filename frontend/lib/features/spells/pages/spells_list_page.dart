import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/spell_service.dart';
import '../../../data/models/spell.dart';

class SpellsListPage extends StatefulWidget {
  const SpellsListPage({super.key});

  @override
  State<SpellsListPage> createState() => _SpellsListPageState();
}

class _SpellsListPageState extends State<SpellsListPage> {
  List<Spell> spells = [];
  bool isLoading = true;
  String? error;
  final SpellService _service = SpellService();

  @override
  void initState() {
    super.initState();
    _loadSpells();
  }

  Future<void> _loadSpells() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        spells = data;
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
        title: const Text('Spells'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/spells/new'),
            tooltip: 'Add Spell',
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
              onPressed: _loadSpells,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (spells.isEmpty) {
      return const Center(
        child: Text('No spells found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spells.length,
      itemBuilder: (context, index) {
        final spell = spells[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(spell.name),
            subtitle: Text('Level ${spell.level}${spell.school != null && spell.school!.isNotEmpty ? ' - ${spell.school}' : ''}'),
            trailing: Text('${spell.level}'),
            onTap: () {
            },
          ),
        );
      },
    );
  }
}


