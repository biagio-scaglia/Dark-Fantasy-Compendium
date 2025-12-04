import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';
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
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('campaigns', widget.campaignId);
      setState(() {
        campaign = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadSessions() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getAll('campaigns/${widget.campaignId}/sessions');
      setState(() {
        sessions = data;
      });
    } catch (e) {
      // Ignora errori per le sessioni
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
        appBar: AppBar(title: const Text('Campagna')),
        body: Center(child: Text('Errore: ${error ?? "Campagna non trovata"}')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(campaign!['name'] ?? 'Campagna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/sessions/new?campaignId=${widget.campaignId}'),
            tooltip: 'Nuova Sessione',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.calendar),
            onPressed: () => context.push('/sessions/calendar'),
            tooltip: 'Calendario Sessioni',
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
                label: 'Livello Attuale',
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
          FaIcon(icon, size: 20, color: AppTheme.accentGold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
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
              'Sessioni (${sessions.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: () => context.push('/sessions/calendar'),
              icon: const FaIcon(FontAwesomeIcons.calendar, size: 16),
              label: const Text('Calendario'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (sessions.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('Nessuna sessione registrata')),
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
            color: AppTheme.accentGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.accentGold, width: 2),
          ),
          child: Center(
            child: Text(
              sessionDate != null ? DateFormat('dd').format(sessionDate) : '?',
              style: TextStyle(
                color: AppTheme.accentGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(session['title'] ?? 'Sessione senza titolo'),
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
        title: Text(session['title'] ?? 'Sessione'),
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
                  backgroundColor: AppTheme.accentGold.withOpacity(0.2),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }
}

