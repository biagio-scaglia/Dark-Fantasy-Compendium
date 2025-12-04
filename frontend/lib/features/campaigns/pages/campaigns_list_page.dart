import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/campaign_service.dart';
import '../../../data/models/campaign.dart';
import '../../../widgets/campaign_card.dart';

class CampaignsListPage extends StatefulWidget {
  const CampaignsListPage({super.key});

  @override
  State<CampaignsListPage> createState() => _CampaignsListPageState();
}

class _CampaignsListPageState extends State<CampaignsListPage> {
  List<Campaign> campaigns = [];
  bool isLoading = true;
  String? error;
  final CampaignService _service = CampaignService();

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        campaigns = data;
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
        title: const Text('Campaigns'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/campaigns/new'),
            tooltip: 'New Campaign',
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
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadCampaigns,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (campaigns.isEmpty) {
      return const Center(child: Text('No campaigns found'));
    }

    return RefreshIndicator(
      onRefresh: _loadCampaigns,
      child: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          final camp = campaigns[index];
          final campMap = {
            'id': camp.id,
            'name': camp.name,
            'description': camp.description,
            'dungeon_master': camp.dungeonMaster,
            'players': camp.players,
            'current_level': camp.currentLevel,
            'setting': camp.setting,
            'image_path': camp.imagePath,
            'icon_path': camp.iconPath,
          };
          return CampaignCard(campaign: campMap);
        },
      ),
    );
  }
}

