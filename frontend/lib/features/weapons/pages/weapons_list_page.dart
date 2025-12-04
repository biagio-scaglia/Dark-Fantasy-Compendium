import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/weapon_service.dart';
import '../../../data/models/weapon.dart';
import '../../../widgets/weapon_card.dart';

class WeaponsListPage extends StatefulWidget {
  const WeaponsListPage({super.key});

  @override
  State<WeaponsListPage> createState() => _WeaponsListPageState();
}

class _WeaponsListPageState extends State<WeaponsListPage> {
  List<Weapon> weapons = [];
  bool isLoading = true;
  String? error;
  final WeaponService _service = WeaponService();

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
      final data = await _service.getAll();
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
          onPressed: () => context.go('/home'),
          tooltip: 'Back',
        ),
        title: const Text('Weapons'),
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
            Text('Error: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWeapons,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (weapons.isEmpty) {
      return const Center(child: Text('No weapons found'));
    }

    return RefreshIndicator(
      onRefresh: _loadWeapons,
      child: ListView.builder(
        itemCount: weapons.length,
        itemBuilder: (context, index) {
          final weapon = weapons[index];
          final weaponMap = {
            'id': weapon.id,
            'name': weapon.name,
            'type': weapon.type,
            'attack_bonus': weapon.attackBonus,
            'rarity': weapon.rarity,
            'image_path': weapon.imagePath,
            'icon_path': weapon.iconPath,
          };
          return WeaponCard(weapon: weaponMap);
        },
      ),
    );
  }
}

