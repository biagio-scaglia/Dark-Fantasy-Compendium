import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/race_service.dart';
import '../../../data/models/race.dart';
import '../../../widgets/image_picker_helper.dart';

class RaceDetailPage extends StatefulWidget {
  final int raceId;

  const RaceDetailPage({super.key, required this.raceId});

  @override
  State<RaceDetailPage> createState() => _RaceDetailPageState();
}

class _RaceDetailPageState extends State<RaceDetailPage> {
  Race? race;
  bool isLoading = true;
  final RaceService _service = RaceService();

  @override
  void initState() {
    super.initState();
    _loadRace();
  }

  Future<void> _loadRace() async {
    try {
      final data = await _service.getById(widget.raceId);
      setState(() {
        race = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Race')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (race == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Race')),
        body: const Center(child: Text('Race not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(race!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await context.push('/races/${race!.id}/edit');
              _loadRace();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ImagePickerHelper.buildImageWidget(race!.imagePath, height: 200, width: double.infinity),
          const SizedBox(height: 16),
          Text(race!.name, style: Theme.of(context).textTheme.headlineSmall),
          if (race!.description != null) ...[
            const SizedBox(height: 8),
            Text(race!.description!, style: Theme.of(context).textTheme.bodyLarge),
          ],
          if (race!.size != null) ...[
            const SizedBox(height: 16),
            Text('Size: ${race!.size}', style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (race!.speed != null) ...[
            const SizedBox(height: 8),
            Text('Speed: ${race!.speed} feet', style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (race!.traits != null && race!.traits!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Traits:', style: Theme.of(context).textTheme.titleMedium),
            ...race!.traits!.map((trait) => Text('• $trait')),
          ],
          if (race!.languages != null && race!.languages!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Languages:', style: Theme.of(context).textTheme.titleMedium),
            ...race!.languages!.map((lang) => Text('• $lang')),
          ],
        ],
      ),
    );
  }
}

