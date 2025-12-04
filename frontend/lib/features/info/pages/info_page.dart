import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
        backgroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradientFromContext(context),
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
                      _buildHeader(context),
                      const SizedBox(height: 32),
                      _buildVersionSection(),
                      const SizedBox(height: 24),
                      _buildCreditsSection(),
                      const SizedBox(height: 24),
                      _buildLibrariesSection(),
                      const SizedBox(height: 24),
                      _buildLicenseSection(context),
                      const SizedBox(height: 24),
                      _buildThemeSection(context),
                      const SizedBox(height: 24),
                      _buildExtraSection(context),
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

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.getMedievalGradientFromContext(context),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.getAccentGoldFromContext(context),
                width: 3,
              ),
            ),
            child: FaIcon(
              FontAwesomeIcons.crown,
              size: 64,
              color: AppTheme.getAccentGoldFromContext(context),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dark Fantasy Compendium',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimaryFromContext(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'D&D campaign manager and dark fantasy content library',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getTextSecondaryFromContext(context),
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

  Widget _buildLicenseSection(BuildContext context) {
    return _InfoCard(
      title: 'License',
      icon: FontAwesomeIcons.scaleBalanced,
      children: [
        Text(
          'MIT License',
          style: TextStyle(
            color: AppTheme.getTextPrimaryFromContext(context),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Contribute on GitHub',
          style: TextStyle(
            color: AppTheme.getAccentGoldFromContext(context),
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return _InfoCard(
          title: 'Theme',
          icon: FontAwesomeIcons.palette,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: AppTheme.getAccentGoldFromContext(context),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ThemeOption(
                  label: 'Light',
                  icon: FontAwesomeIcons.sun,
                  isSelected: themeProvider.themeMode == ThemeMode.light,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                ),
                _ThemeOption(
                  label: 'Dark',
                  icon: FontAwesomeIcons.moon,
                  isSelected: themeProvider.themeMode == ThemeMode.dark,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                ),
                _ThemeOption(
                  label: 'System',
                  icon: FontAwesomeIcons.circleHalfStroke,
                  isSelected: themeProvider.themeMode == ThemeMode.system,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildExtraSection(BuildContext context) {
    return _InfoCard(
      title: 'About',
      icon: FontAwesomeIcons.feather,
      children: [
        Text(
          'Dark Fantasy Compendium is a comprehensive tool for managing D&D campaigns and dark fantasy content. Track characters, parties, sessions, spells, items, maps, and more. Built for dungeon masters and players who want to organize their tabletop RPG experience.',
          style: TextStyle(
            color: AppTheme.getTextSecondaryFromContext(context),
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
      color: AppTheme.getSecondaryBackgroundFromContext(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, color: AppTheme.getAccentGoldFromContext(context), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.getTextPrimaryFromContext(context),
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
          style: TextStyle(
            color: AppTheme.getTextSecondaryFromContext(context),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppTheme.getTextPrimaryFromContext(context),
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
          color: AppTheme.getPrimaryBackgroundFromContext(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: AppTheme.getAccentGoldFromContext(context), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.getTextPrimaryFromContext(context),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.getTextSecondaryFromContext(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.getAccentGoldFromContext(context).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.getAccentGoldFromContext(context)
                : AppTheme.getTextSecondaryFromContext(context).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              color: isSelected ? AppTheme.getAccentGoldFromContext(context) : AppTheme.getTextSecondaryFromContext(context),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.getAccentGoldFromContext(context) : AppTheme.getTextSecondaryFromContext(context),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

