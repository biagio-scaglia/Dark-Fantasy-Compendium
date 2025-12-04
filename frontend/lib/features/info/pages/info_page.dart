import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildVersionSection(),
                      const SizedBox(height: 24),
                      _buildCreditsSection(),
                      const SizedBox(height: 24),
                      _buildLibrariesSection(),
                      const SizedBox(height: 24),
                      _buildLicenseSection(),
                      const SizedBox(height: 24),
                      _buildThemeSection(context),
                      const SizedBox(height: 24),
                      _buildExtraSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.medievalGradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accentGold,
                width: 3,
              ),
            ),
            child: const FaIcon(
              FontAwesomeIcons.crown,
              size: 64,
              color: AppTheme.accentGold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dark Fantasy Compendium',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'D&D campaign manager and dark fantasy content library',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionSection() {
    return _InfoCard(
      title: 'App Version',
      icon: FontAwesomeIcons.code,
      children: [
        _InfoRow(
          label: 'Frontend (Flutter)',
          value: '1.0.0',
        ),
        const SizedBox(height: 8),
        _InfoRow(
          label: 'Backend (FastAPI)',
          value: '1.0.0',
        ),
      ],
    );
  }

  Widget _buildCreditsSection() {
    return _InfoCard(
      title: 'Credits',
      icon: FontAwesomeIcons.user,
      children: [
        _InfoRow(
          label: 'Developer',
          value: 'Biagio Scaglia',
        ),
        const SizedBox(height: 8),
        _InfoRow(
          label: 'Design',
          value: 'Biagio Scaglia',
        ),
        const SizedBox(height: 16),
        _InfoButton(
          icon: FontAwesomeIcons.github,
          label: 'GitHub Repository',
          onTap: () async {
            final url = Uri.parse('https://github.com/yourusername/dark-fantasy-compendium');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
        const SizedBox(height: 8),
        _InfoButton(
          icon: FontAwesomeIcons.globe,
          label: 'Website',
          onTap: () async {
            final url = Uri.parse('https://yourwebsite.com');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
      ],
    );
  }

  Widget _buildLibrariesSection() {
    return _InfoCard(
      title: 'Technologies',
      icon: FontAwesomeIcons.book,
      children: [
        _InfoRow(label: 'Flutter', value: 'SDK'),
        const SizedBox(height: 4),
        _InfoRow(label: 'Provider', value: 'State Management'),
        const SizedBox(height: 4),
        _InfoRow(label: 'go_router', value: 'Navigation'),
        const SizedBox(height: 4),
        _InfoRow(label: 'FastAPI', value: 'Backend'),
        const SizedBox(height: 4),
        _InfoRow(label: 'Pydantic', value: 'Data Validation'),
        const SizedBox(height: 4),
        _InfoRow(label: 'FontAwesome', value: 'Icons'),
      ],
    );
  }

  Widget _buildLicenseSection() {
    return _InfoCard(
      title: 'License',
      icon: FontAwesomeIcons.scaleBalanced,
      children: [
        const Text(
          'MIT License',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Contribute on GitHub',
          style: TextStyle(
            color: AppTheme.accentGold,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return _InfoCard(
      title: 'Theme',
      icon: FontAwesomeIcons.palette,
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: true,
          onChanged: (value) {
            // Placeholder for theme switching
          },
          activeColor: AppTheme.accentGold,
        ),
      ],
    );
  }

  Widget _buildExtraSection() {
    return _InfoCard(
      title: 'About',
      icon: FontAwesomeIcons.feather,
      children: [
        const Text(
          'Dark Fantasy Compendium is a comprehensive tool for managing D&D campaigns and dark fantasy content. Track characters, parties, sessions, spells, items, maps, and more. Built for dungeon masters and players who want to organize their tabletop RPG experience.',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.secondaryDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, color: AppTheme.accentGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _InfoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _InfoButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.accentGold.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: AppTheme.accentGold, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

