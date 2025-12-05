import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../widgets/svg_icon_widget.dart';

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
                      _buildPrivacySection(context),
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
    final isLight = Theme.of(context).brightness == Brightness.light;
    final goldColor = AppTheme.getAccentGoldFromContext(context);
    final brownColor = AppTheme.getAccentBrownFromContext(context);
    
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.getMedievalGradientFromContext(context),
              shape: BoxShape.circle,
              border: Border.all(
                color: goldColor,
                width: 3,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLight 
                  ? Colors.white.withOpacity(0.25)
                  : Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: goldColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: SvgIconWidget(
                iconPath: 'lorc/crown.svg',
                size: 64,
                color: isLight ? brownColor : goldColor,
                useThemeColor: false,
              ),
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
      iconPath: 'lorc/crystal-shine.svg',
      children: [
        _InfoRow(
          label: 'Version',
          value: '1.0.0',
        ),
        const SizedBox(height: 8),
        _InfoRow(
          label: 'Platform',
          value: 'Flutter',
        ),
      ],
    );
  }

  Widget _buildCreditsSection() {
    return _InfoCard(
      title: 'Credits',
      iconPath: 'delapouite/character.svg',
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
          iconPath: 'lorc/crystal-shine.svg',
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
          iconPath: 'lorc/globe.svg',
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
      iconPath: 'lorc/book-cover.svg',
      children: [
        _InfoRow(label: 'Flutter', value: 'UI Framework'),
        const SizedBox(height: 4),
        _InfoRow(label: 'Provider', value: 'State Management'),
        const SizedBox(height: 4),
        _InfoRow(label: 'go_router', value: 'Navigation'),
        const SizedBox(height: 4),
        _InfoRow(label: 'path_provider', value: 'File System'),
        const SizedBox(height: 4),
        _InfoRow(label: 'shared_preferences', value: 'Local Storage'),
        const SizedBox(height: 4),
        _InfoRow(label: 'SVG Icons', value: 'Game-Icons.net'),
      ],
    );
  }

  Widget _buildLicenseSection(BuildContext context) {
    return _InfoCard(
      title: 'License',
      iconPath: 'lorc/scales.svg',
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
          iconPath: 'delapouite/palette.svg',
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
                  iconPath: 'lorc/sun.svg',
                  isSelected: themeProvider.themeMode == ThemeMode.light,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                ),
                _ThemeOption(
                  label: 'Dark',
                  iconPath: 'lorc/moon.svg',
                  isSelected: themeProvider.themeMode == ThemeMode.dark,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                ),
                _ThemeOption(
                  label: 'System',
                  iconPath: 'lorc/half-heart.svg',
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

  Widget _buildPrivacySection(BuildContext context) {
    return _InfoCard(
      title: 'Privacy & Data',
      iconPath: 'sbed/shield.svg',
      children: [
        Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppTheme.getTextPrimaryFromContext(context),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Dark Fantasy Compendium is a fully offline application. All your data is stored locally on your device and never leaves it.',
          style: TextStyle(
            color: AppTheme.getTextSecondaryFromContext(context),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Data Storage',
          style: TextStyle(
            color: AppTheme.getTextPrimaryFromContext(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '• All data is stored locally in JSON files\n• Images are saved on your device\n• No cloud synchronization\n• No data collection or analytics\n• No third-party services',
          style: TextStyle(
            color: AppTheme.getTextSecondaryFromContext(context),
            fontSize: 13,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Permissions',
          style: TextStyle(
            color: AppTheme.getTextPrimaryFromContext(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'The app may request permissions for:\n• Storage: To save images and data files\n• Camera: To take photos for entities (optional)\n• Gallery: To select images (optional)',
          style: TextStyle(
            color: AppTheme.getTextSecondaryFromContext(context),
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildExtraSection(BuildContext context) {
    return _InfoCard(
      title: 'About',
      iconPath: 'lorc/quill.svg',
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
  final String iconPath;
  final List<Widget> children;

  _InfoCard({
    required this.title,
    required this.iconPath,
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
                SvgIconWidget(
                  iconPath: iconPath,
                  size: 20,
                  color: AppTheme.getAccentGoldFromContext(context),
                  useThemeColor: false,
                ),
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
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  _InfoButton({
    required this.iconPath,
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
            SvgIconWidget(
              iconPath: iconPath,
              size: 20,
              color: AppTheme.getAccentGoldFromContext(context),
              useThemeColor: false,
            ),
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
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  _ThemeOption({
    required this.label,
    required this.iconPath,
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
            SvgIconWidget(
              iconPath: iconPath,
              size: 24,
              color: isSelected ? AppTheme.getAccentGoldFromContext(context) : AppTheme.getTextSecondaryFromContext(context),
              useThemeColor: false,
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

