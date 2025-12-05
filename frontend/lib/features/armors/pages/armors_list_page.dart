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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/armors/new'),
            tooltip: 'Add Armor',
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
                'Error loading armor',
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
                onPressed: _loadArmors,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (armors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 64,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No armor found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first armor to get started',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.push('/armors/new'),
                icon: const Icon(Icons.add),
                label: const Text('Create Armor'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadArmors,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: armors.length,
        itemBuilder: (context, index) {
          final armor = armors[index];
          final armorMap = {
            'id': armor.id,
            'name': armor.name,
            'type': armor.type,
            'defense_bonus': armor.defenseBonus,
            'durability': armor.durability,
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


