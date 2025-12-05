import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/services/campaign_service.dart';
import '../../../core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CampaignDetailPage extends StatefulWidget {
  final int campaignId;

  const CampaignDetailPage({super.key, required this.campaignId});

  @override
  State<CampaignDetailPage> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  Map<String, dynamic>? campaign;
  List<dynamic> sessions = [];
  bool isLoading = true;
  String? error;
  final CampaignService _service = CampaignService();

  @override
  void initState() {
    super.initState();
    _loadCampaign();
    _loadSessions();
  }

  Future<void> _loadCampaign() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final campaignData = await _service.getById(widget.campaignId);
      if (campaignData != null) {
        final data = campaignData.toJson();
        setState(() {
          campaign = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Campaign not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadSessions() async {
    try {
      final campaignData = await _service.getById(widget.campaignId);
      if (campaignData != null && campaignData.sessions != null) {
        setState(() {
          sessions = campaignData.sessions!;
        });
      }
    } catch (e) {
      // Ignore errors for sessions
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Campagna')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || campaign == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Campaign')),
        body: Center(child: Text('Error: ${error ?? "Campaign not found"}')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(campaign!['name'] ?? 'Campaign'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/sessions/new?campaignId=${widget.campaignId}'),
            tooltip: 'New Session',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.calendar),
            onPressed: () => context.push('/sessions/calendar'),
            tooltip: 'Session Calendar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign!['name'] ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              campaign!['description'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoSection(),
            const SizedBox(height: 24),
            _buildSessionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (campaign!['dungeon_master'] != null)
              _buildInfoRow(
                icon: FontAwesomeIcons.userTie,
                label: 'Dungeon Master',
                value: campaign!['dungeon_master'],
              ),
            if (campaign!['current_level'] != null)
              _buildInfoRow(
                icon: FontAwesomeIcons.chartLine,
                label: 'Current Level',
                value: '${campaign!['current_level']}',
              ),
            if (campaign!['setting'] != null)
              _buildInfoRow(
                icon: FontAwesomeIcons.map,
                label: 'Ambientazione',
                value: campaign!['setting'],
              ),
            if (campaign!['players'] != null && (campaign!['players'] as List).isNotEmpty)
              _buildInfoRow(
                icon: FontAwesomeIcons.users,
                label: 'Giocatori',
                value: (campaign!['players'] as List).join(', '),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: AppTheme.getAccentGoldFromContext(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondaryFromContext(context),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sessions (${sessions.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: () => context.push('/sessions/calendar'),
              icon: const FaIcon(FontAwesomeIcons.calendar, size: 16),
              label: const Text('Calendar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (sessions.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No sessions recorded')),
            ),
          )
        else
          ...sessions.map((session) => _buildSessionCard(session)),
      ],
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    DateTime? sessionDate;
    try {
      sessionDate = DateTime.parse(session['date'] ?? '');
    } catch (e) {
      sessionDate = null;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.getAccentGoldFromContext(context), width: 2),
          ),
          child: Center(
            child: Text(
              sessionDate != null ? DateFormat('dd').format(sessionDate) : '?',
              style: TextStyle(
                color: AppTheme.getAccentGoldFromContext(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(session['title'] ?? 'Untitled Session'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sessionDate != null)
              Text(DateFormat('dd MMMM yyyy', 'it_IT').format(sessionDate)),
            if (session['experience_awarded'] != null && session['experience_awarded'] > 0)
              Text('XP: ${session['experience_awarded']}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Mostra dettagli sessione
          _showSessionDetails(session);
        },
      ),
    );
  }

  void _showSessionDetails(Map<String, dynamic> session) {
    DateTime? sessionDate;
    try {
      sessionDate = DateTime.parse(session['date'] ?? '');
    } catch (e) {
      sessionDate = null;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session['title'] ?? 'Session'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (sessionDate != null)
                Text(
                  DateFormat('dd MMMM yyyy', 'it_IT').format(sessionDate),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(height: 16),
              if (session['description'] != null)
                Text(session['description'] ?? ''),
              if (session['notes'] != null && session['notes'].toString().isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Note:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(session['notes'] ?? ''),
              ],
              if (session['experience_awarded'] != null && session['experience_awarded'] > 0) ...[
                const SizedBox(height: 16),
                Chip(
                  label: Text('XP: ${session['experience_awarded']}'),
                  backgroundColor: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}


