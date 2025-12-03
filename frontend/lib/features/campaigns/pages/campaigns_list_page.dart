import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../widgets/campaign_card.dart';

class CampaignsListPage extends StatefulWidget {
  const CampaignsListPage({super.key});

  @override
  State<CampaignsListPage> createState() => _CampaignsListPageState();
}

class _CampaignsListPageState extends State<CampaignsListPage> {
  List<dynamic> campaigns = [];
  bool isLoading = true;
  String? error;

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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('campaigns');
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
          onPressed: () => context.go('/'),
        ),
        title: const Text('Campagne'),
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
              onPressed: _loadCampaigns,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (campaigns.isEmpty) {
      return const Center(child: Text('Nessuna campagna trovata'));
    }

    return RefreshIndicator(
      onRefresh: _loadCampaigns,
      child: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          return CampaignCard(campaign: campaigns[index]);
        },
      ),
    );
  }
}

