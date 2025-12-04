import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/character_service.dart';
import '../../../data/models/character.dart';
import '../../../widgets/character_card.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  List<Character> characters = [];
  bool isLoading = true;
  String? error;
  final CharacterService _service = CharacterService();

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        characters = data;
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
        title: const Text('Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/characters/new'),
            tooltip: 'New Character',
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
              onPressed: _loadCharacters,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (characters.isEmpty) {
      return const Center(child: Text('No characters found'));
    }

    return RefreshIndicator(
      onRefresh: _loadCharacters,
      child: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final char = characters[index];
          final charMap = {
            'id': char.id,
            'name': char.name,
            'class_id': char.classId,
            'race_id': char.raceId,
            'level': char.level,
            'image_path': char.imagePath,
            'icon_path': char.iconPath,
          };
          return CharacterCard(character: charMap);
        },
      ),
    );
  }
}

