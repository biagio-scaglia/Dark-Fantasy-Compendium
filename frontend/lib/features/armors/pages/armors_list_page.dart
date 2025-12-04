import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/armor_service.dart';
import '../../../data/models/armor.dart';
import '../../../widgets/armor_card.dart';

class ArmorsListPage extends StatefulWidget {
  const ArmorsListPage({super.key});

  @override
  State<ArmorsListPage> createState() => _ArmorsListPageState();
}

class _ArmorsListPageState extends State<ArmorsListPage> {
  List<Armor> armors = [];
  bool isLoading = true;
  String? error;
  final ArmorService _service = ArmorService();

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
      final data = await _service.getAll();
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
          final armor = armors[index];
          final armorMap = {
            'id': armor.id,
            'name': armor.name,
            'type': armor.type,
            'defense_bonus': armor.defenseBonus,
            'rarity': armor.rarity,
            'image_path': armor.imagePath,
            'icon_path': armor.iconPath,
          };
          return ArmorCard(armor: armorMap);
        },
      ),
    );
  }
}

