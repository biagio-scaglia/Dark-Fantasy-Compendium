import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_widget.dart';

/// Example page demonstrating the SvgIconWidget with multiple icons in a grid layout
/// Shows how icons automatically adapt to Light and Dark mode
class SvgIconsExamplePage extends StatelessWidget {
  const SvgIconsExamplePage({super.key});

  /// List of example icon paths from icons/ - only icons that actually exist
  static const List<String> exampleIcons = [
    // Weapons - verified to exist
    'lorc/broadsword.svg',
    'lorc/daggers.svg',
    'lorc/battle-axe.svg',
    'lorc/barbed-spear.svg',
    'lorc/bowman.svg',
    'lorc/crossed-swords.svg',
    'lorc/diving-dagger.svg',
    'lorc/bowie-knife.svg',
    'lorc/curvy-knife.svg',
    'lorc/energy-sword.svg',
    'lorc/bloody-sword.svg',
    'lorc/bouncing-sword.svg',
    // Armor - verified to exist
    'lorc/breastplate.svg',
    'lorc/armor-vest.svg',
    'lorc/barbute.svg',
    'lorc/crested-helmet.svg',
    'lorc/boots.svg',
    'lorc/dorsal-scales.svg',
    // Crystals and gems - verified to exist
    'lorc/crystal-shine.svg',
    'lorc/diamond-hard.svg',
    'lorc/crystal-cluster.svg',
    'lorc/crystal-bars.svg',
    'lorc/crystal-eye.svg',
    'lorc/emerald.svg',
    'lorc/checkered-diamond.svg',
    // Elements - verified to exist
    'lorc/fireball.svg',
    'lorc/fire-breath.svg',
    'lorc/fire-shield.svg',
    'lorc/arcing-bolt.svg',
    'lorc/bolt-eye.svg',
    'lorc/drop.svg',
    'lorc/droplet-splash.svg',
    // Shields - verified to exist
    'lorc/broken-shield.svg',
    'lorc/checked-shield.svg',
    'lorc/eye-shield.svg',
    'lorc/bordered-shield.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Icons Example'),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),
                      _buildInfoCard(context),
                      const SizedBox(height: 24),
                      _buildSizeExamples(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= exampleIcons.length) {
                        // Show placeholder for non-existent icons
                        return _buildIconCard(
                          context,
                          'non-existent-icon.svg',
                          'Error Icon',
                          showPlaceholder: true,
                        );
                      }
                      return _buildIconCard(
                        context,
                        exampleIcons[index],
                        _getIconName(exampleIcons[index]),
                      );
                    },
                    childCount: exampleIcons.length + 1, // +1 for error example
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SVG Icons Widget',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppTheme.getTextPrimaryFromContext(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Icons automatically adapt to ${brightness == Brightness.light ? 'Light' : 'Dark'} mode',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.getTextSecondaryFromContext(context),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.getAccentGoldFromContext(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'Features',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(context, '✓ Theme-aware colors (Light/Dark mode)'),
            _buildFeatureItem(context, '✓ Automatic error handling with placeholder'),
            _buildFeatureItem(context, '✓ Scalable sizes'),
            _buildFeatureItem(context, '✓ Uses assets/icons/ as root folder'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildSizeExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size Examples',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSizeExample(context, 24, 'Small'),
            _buildSizeExample(context, 48, 'Medium'),
            _buildSizeExample(context, 72, 'Large'),
            _buildSizeExample(context, 96, 'X-Large'),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeExample(BuildContext context, double size, String label) {
    final brightness = Theme.of(context).brightness;
    final textTertiary = brightness == Brightness.light
        ? AppTheme.lightTextTertiary
        : AppTheme.darkTextTertiary;
    
    return Column(
      children: [
        Container(
          width: size + 16,
          height: size + 16,
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? AppTheme.lightSurfaceVariant
                : AppTheme.darkSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: brightness == Brightness.light
                  ? AppTheme.lightBorder
                  : AppTheme.darkBorder,
            ),
          ),
          child: Center(
            child: SvgIconWidget(
              iconPath: 'lorc/broadsword.svg',
              size: size,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '${size.toInt()}px',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildIconCard(
    BuildContext context,
    String iconPath,
    String iconName, {
    bool showPlaceholder = false,
  }) {
    final brightness = Theme.of(context).brightness;
    
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: showPlaceholder
                  ? SvgIconWidget(
                      iconPath: iconPath,
                      size: 48,
                    )
                  : SvgIconWidget(
                      iconPath: iconPath,
                      size: 48,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              iconName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getIconName(String iconPath) {
    final parts = iconPath.split('/');
    final fileName = parts.last.replaceAll('.svg', '');
    // Convert kebab-case to Title Case
    return fileName
        .split('-')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1))
        .join(' '    );
  }
}

