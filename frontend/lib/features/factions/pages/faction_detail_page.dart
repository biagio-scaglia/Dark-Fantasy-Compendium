import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class FactionDetailPage extends StatefulWidget {
  final int factionId;

  const FactionDetailPage({super.key, required this.factionId});

  @override
  State<FactionDetailPage> createState() => _FactionDetailPageState();
}

class _FactionDetailPageState extends State<FactionDetailPage> {
  Map<String, dynamic>? faction;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadFaction();
  }

  Future<void> _loadFaction() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getOne('factions', widget.factionId);
      setState(() {
        faction = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return AppTheme.accentGold;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTheme.accentGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(faction?['name'] ?? 'Fazione'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null || faction == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Errore: ${error ?? "Fazione non trovata"}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFaction,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    final factionColor = _parseColor(faction!['color']);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(factionColor),
            const SizedBox(height: 24),
            _buildDescription(),
            if (faction!['lore'] != null) ...[
              const SizedBox(height: 24),
              _buildLore(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color factionColor) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              factionColor.withOpacity(0.3),
              AppTheme.secondaryDark,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: factionColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: factionColor, width: 2),
                    ),
                    child: Icon(
                      Icons.group,
                      size: 30,
                      color: factionColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      faction!['name'] ?? '',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: factionColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrizione',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              faction!['description'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLore() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book, color: AppTheme.accentGold),
                const SizedBox(width: 8),
                Text(
                  'Lore',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.accentGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              faction!['lore'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

