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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/weapons/new'),
            tooltip: 'Add Weapon',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading weapons',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadWeapons,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (weapons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_martial_arts_outlined,
                size: 64,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No weapons found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first weapon to get started',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.push('/weapons/new'),
                icon: const Icon(Icons.add),
                label: const Text('Create Weapon'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWeapons,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: weapons.length,
        itemBuilder: (context, index) {
          final weapon = weapons[index];
          final weaponMap = {
            'id': weapon.id,
            'name': weapon.name,
            'type': weapon.type,
            'attack_bonus': weapon.attackBonus,
            'durability': weapon.durability,
            'rarity': weapon.rarity,
            'image_path': weapon.imagePath,
            'icon_path': weapon.iconPath,
          };
          return WeaponCard(
            weapon: weaponMap,
            animated: true,
            animationDelay: Duration(milliseconds: 100 * (index % 5)),
          );
        },
      ),
    );
  }
}


